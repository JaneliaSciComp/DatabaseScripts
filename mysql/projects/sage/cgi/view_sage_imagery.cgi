#!/usr/bin/perl 
# ****************************************************************************
# Resource name:  view_sage_imagery.cgi
# Written by:     Rob Svirskas
# Revision level: 3.8
# Date released:  2009-10-06
# Description:    See the bottom of this file for the POD documentation.
#                 Search for the string '=head'.
# Required resources:
#   Programs:        NONE
#   USEd modules:    strict
#                    warnings
#                    CGI
#                    DBI
#                    GD
#                    MIME::Base64::Perl
#                    Switch
#                    URI::Escape
#                    XML::Simple
#                    Time::HiRes
#                    JFRC::Utils::Web
#   Config files:    /opt/informatics/data/view_sage_imagery-config.xml
#   Input files:     NONE
#   CSS:             /css/labcommon.css
#                    /css/view_sage_imagery.css
#                    /css/view_sage_imagery_dark.css
#   JavaScript:      /js/prototype.js
#                    /js/labcommon.js
#                    /js/view_sage_imagery.js
#   Output files:    NONE
#   Database tables: image (S)
#                    image_property (S)
#                    image_vw (S)
#                    (family-identitied views) (S)
#                    secondary_image (S)
#
#                               REVISION LOG
# ----------------------------------------------------------------------------
# | revision | name            | date    | description                       |
# ----------------------------------------------------------------------------
#     1.0     Rob Svirskas      08-04-16  Initial version
#     1.1     Rob Svirskas      08-05-06  Improved substack UI.
#     1.2     Rob Svirskas      08-05-12  Added LSM metadata, additional UI
#                                         improvements.
#     1.3     Rob Svirskas      08-05-13  Improved parameter grouping.
#     1.4     Rob Svirskas      08-05-30  Now reads in text transformations
#                                         from XML - this will someday be
#                                         dealt with in the database.
#     1.5     Rob Svirskas      08-06-02  Added zoom data.
#     1.6     Rob Svirskas      08-06-06  Added illumination channel color.
#     1.7     Rob Svirskas      08-06-09  Changed stack display to use ID.
#                                         Added spectrum display.
#     1.8     Rob Svirskas      08-08-20  Added a "_header" option to render
#                                         an image query result page with full
#                                         header.
#     1.9     Rob Svirskas      08-08-21  Changed query operation to use
#                                         tables instead of views. Added
#                                         ability to use custom views for
#                                         stack selection. Added code to allow
#                                         direct display of viewable stacks.
#                                         Improved header handling.
#     2.0     Rob Svirskas      08-08-29  Image server authentication is now
#                                         part of the Ajax query population.
#                                         This ensures that multi-threaded
#                                         requests (a la Firefox3) won't ask
#                                         for login creds multiple times.
#     2.1     Rob Svirskas      08-09-22  Switched over to unified Nighthawk
#                                         database. Added lightbox
#                                         functionality to substack display.
#     2.2     Rob Svirskas      08-09-22  Added code to deny access to stacks.
#     2.3     Rob Svirskas      08-09-23  Fixed substack numbering.
#     2.4     Rob Svirskas      08-09-26  Added point detector name and 
#                                         spectral icon.
#     2.5     Rob Svirskas      08-10-02  Added URI escaping.
#     2.6     Rob Svirskas      08-11-07  Added "rlike" field designator.
#                                         Added display flag.
#     2.7     Rob Svirskas      08-11-10  Promoted genotype data.
#     2.8     Rob Svirskas      09-01-27  Uses new view for increased
#                                         performance.
#     2.9     Rob Svirskas      09-03-26  Added timestamp to capture data
#                                         (when available).
#     3.0     Rob Svirskas      09-03-27  Added filtering to primary select.
#     3.1     Rob Svirskas      09-03-31  Added "Imaged by".
#     3.2     Rob Svirskas      09-04-28  Added display options.
#     3.3     Rob Svirskas      09-04-30  Added per-line image limit.
#     3.4     Rob Svirskas      09-05-30  Sorted image types. Allow products
#                                         to be hidden on front page. Allow
#                                         SQL filters on "IN" clauses.
#     3.5     Rob Svirskas      09-05-30  Added code to handle requests from
#                                         other servers.
#     3.6     Rob Svirskas      09-05-22  Added icon.
#     3.7     Rob Svirskas      09-09-04  Now handles ramping.
#     3.8     Rob Svirskas      09-10-06  Automatic image property display.
# ****************************************************************************

# Installed modules
use strict;
use warnings;
use CGI qw/:standard/;
use DBI;
use File::Basename;
use GD;
use MIME::Base64::Perl;
use XML::Simple;
use Switch;
use Time::HiRes qw(gettimeofday tv_interval);
use URI::Escape;

# JFRC modules
use JFRC::Utils::Web;

# ****************************************************************************
# * Environment-dependent                                                    *
# ****************************************************************************
# Change this on foreign installation
use constant DATA_PATH => '/opt/informatics/data/';

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE Imagery Viewer';
use constant FETCH_LIMIT => 1000;
use constant NBSP => '&nbsp;';
use constant ANY => '(any)';
my $DEBUG = 1;

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
my (%DATA,%DATABASE,%IMAGERY,%LAB,%LINK_MAP,%TYPE,%TRANSFORMATION);
# Database
my $dbh;
# SQL statements
my %sth = (
ATTENUATOR => 'SELECT * FROM attenuator WHERE image_id=?',
DETECTOR => 'SELECT * FROM detector WHERE image_id=?',
PROPERTY => 'SELECT value FROM image_property_vw WHERE type=? AND image_id=?',
LINE_NAME => 'SELECT l.name FROM image i, line l WHERE l.id = i.line_id and i.id =?',
GENE => 'SELECT gene FROM image_gene_vw WHERE image_id=?',
ID => 'SELECT id,line FROM image_vw WHERE name=? AND family=?',
ID2 => 'SELECT i.id AS id,l.name AS line,value AS robot_id FROM image i JOIN '
       . 'line l ON (l.id=i.line_id) LEFT JOIN line_property_vw lp ON '
       . "(lp.line_id=l.id AND lp.type='robot_id') WHERE i.name=? AND "
       . "family_id=getCVTermID('family',?,NULL)",
IMAGE => 'SELECT * FROM image_vw WHERE name=?',
LASER => 'SELECT * FROM laser WHERE image_id=?',
LINE => 'SELECT id,lab_display_name,gene,synonyms FROM line_vw WHERE name=?',
LINEPROP => 'SELECT type,value FROM line_property_vw WHERE line_id=? '
            . 'ORDER BY 1',
PROPERTIES => 'SELECT type,value FROM image_property_vw WHERE image_id=? '
              . 'ORDER BY type',
SEC_URL => "SELECT url FROM secondary_image_vw WHERE image_id=? AND product=?",
STACK_URL => 'SELECT url FROM image WHERE id=?',
SUBSTACK_URL => 'SELECT url FROM secondary_image_vw WHERE image_id=? AND '
                . 'name=?',
SUBSTACKS => 'SELECT product,name FROM secondary_image_vw WHERE image_id=? AND '
             . "product LIKE 'substack_%' ORDER BY product,name",
);


# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************
# Configure XML
&configureXML();
# Connect to the database if we know the family
if (param('_family') && !&initializeDB(param('_family'))) {
    print header,&ajaxError($DBI::errstr,1);
    exit(-1);
}
# Determine the operation
switch (lc(param('_op'))) {
  case 'query' { print header,&populateQueryBlock(param('_family')); }
  case 'images' { print &renderImagesAjax(); }
  case 'stack' { &renderStackPage(); }
  else { &queryPage(); }
}
# We're done!
if ($dbh) {
  ref($sth{$_}) && $sth{$_}->finish foreach (keys %sth);
  $dbh->disconnect;
}
exit(0);


# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************

# ****************************************************************************
# * Subroutine:  configureXML                                                *
# * Description: This routine will initialize global variables using the XML *
# *              configuration file.                                         *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub configureXML
{
my $p;
  eval {
    $p = XMLin(DATA_PATH . $PROGRAM . '-config.xml',
               ForceArray => [qw(display link query transformation)],
               KeyAttr => { map { $_ => 'type' } qw(data imagery server)});
  };
  if ($@) {
    print header,&ajaxError('XML error: '.$@,1);
    exit(-1);
  }
  %TRANSFORMATION = map { $_->{key} => $_->{data} } @{$p->{transformation}};
  $LINK_MAP{$_->{site}} = $_->{content} foreach (@{$p->{link}});
  %TYPE = map { $_->{key} => $_->{value} } @{$p->{type}};
  %LAB = map { $_->{key} => $_->{lab} } @{$p->{type}};
  %DATA = %{$p->{data}};
  %DATABASE = %{$p->{database}};
  %IMAGERY = %{$p->{imagery}};
}


# ****************************************************************************
# * Subroutine:  initializeDB                                                *
# * Description: This routine will initialize the database connection.       *
# *                                                                          *
# * Parameters:  (unspecified): imagery family                               *
# * Returns:     1 for success, 0 for failure                                *
# ****************************************************************************
sub initializeDB
{
  # Database handle
  $dbh = DBI->connect(@DATABASE{qw(connect user pass)}) || return(0);
  #print STDERR "Connect to $DATABASE{connect}\n";
  # Statement handles
  $sth{$_} = $dbh->prepare($sth{$_}) || return(0) foreach (keys %sth);
  return(1);
}


# ****************************************************************************
# * Subroutine:  ajaxError                                                   *
# * Description: This routine will initialize the database connection.       *
# *                                                                          *
# * Parameters:  message: error message to display                           *
# *              imagewait: if true, the imagewait block will be populated   *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub ajaxError
{
  my($message,$imagewait) = @_;
  print STDERR "$message\n";
  (span({class => 'note'},'ERROR: ',$message),
   ($imagewait) ? img({&identify('imagewait'),src => '/images/loading.gif'})
                : '');
}


# ****************************************************************************
# * Subroutine:  queryPage                                                   *
# * Description: This routine will render the query page.                    *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub queryPage
{
  my %label = %TYPE;
  $label{0} = ' Choose imagery type...';
  print &pageHeader($APPLICATION,'initialize()');
  print start_multipart_form(&identify('main')),'Imagery type: ',
        popup_menu(&identify('_family'),
                   -onChange => 'chooseType()',
                   -values   => [sort { lc($label{$a}) cmp lc($label{$b}) }
                                        keys %label],
                   -labels   => \%label),NBSP,
        img({&identify('querywait'),src => '/images/loading.gif'}),
        div({-id=>'queryblock'},NBSP),br,
        div({-id=>'optionblock'},NBSP),end_form, # end main
        div({-id=>'imageblock'},div({-id=>'imageset'})),end_html;
}


# ****************************************************************************
# * Subroutine:  populateQueryBlock                                          *
# * Description: This routine will return HTML to populate the query block.  *
# *              Typically, this will be one or more scrolling lists with    *
# *              headings arranged in a two-row table.                       *
# *                                                                          *
# * Parameters:  family: imagery family                                      *
# * Returns:     array of HTML                                               *
# ****************************************************************************
sub populateQueryBlock
{
  my $family = shift;
  my (@header,@row);
  foreach my $element (@{$DATA{$family}{query}}) {
    my $eid = $element->{id};
    push @header,$element->{name};
    if ($element->{field} && $element->{field} eq 'rlike') {
      # Text input
      push @row,input({size => 8,
                       map {$_ => $eid} qw(id name)});
    }
    else {
      # Pulldown
      my $sel = 'value';
      my $sql = "SELECT DISTINCT($eid) FROM image_data_mv "
                . "WHERE family='$family'";
      # image_data_mv is the default table. It is overridden if there is
      # a "table" entry for this family.
      if (exists($element->{table})) {
        $sel = $eid;
        ($sel = $element->{sqlfilter}) =~ s/\%\%REPLACE\%\%/$eid/
          if (exists $element->{sqlfilter});
        $sql = "SELECT DISTINCT($sel) FROM " . $element->{table}
               . " WHERE family='$family'";
      }
      $sql .= ' ORDER BY 1';
      my $list = $dbh->selectcol_arrayref($sql)
        || return(&ajaxError($DBI::errstr,1));
      my @tmp = @$list;
      @$list = ();
      (defined) && push @$list,$_ foreach (@tmp);
      @$list = sort { lc($a) cmp lc($b) } @$list if ($eid =~ /^(?:gene|line)/);
      (pop @header),next unless (scalar @$list);
      $header[-1] = span({title=>scalar(@$list)},$header[-1]);
      unshift @$list,ANY;
      my $size = scalar(@$list);
      $size = 10 if ($size > 10);
      my @parms = (&identify($eid),values=>$list,default=>ANY,size=>$size,
                   multiple=>1,class=>$eid);
      push @row,scrolling_list(@parms);
    }
  }
  return(&ajaxError("No data found for $TYPE{$family}",1)) unless (scalar @row);
  my %modes = ('' => 'Default',
               projection_lines => 'Projections (reference+pattern; organized by line)',
               projection_all => 'Projections (reference+pattern)',
               projection_pattern => 'Projections (pattern)');
  (div({id=>'querybox'},
       map {div({id=>'queryitem'},$_,br,shift @row)} @header),
   div({style=>'clear:both;'},NBSP),
   button(&identify('_search'),
          value   => 'Search',
          onClick => 'submitQuery();'),NBSP,
   img({src=>$DATA{$family}{image}{loc}}),
   img({&identify('imagewait'),src=>'/images/loading.gif'}),br,
   div({class => 'boxed'},h3('Display options'),
   'Select at most '
   . popup_menu(&identify('_limit'),
                -labels => {0 => '(no limit)'},
                -values => [0..10])
   . ' image(s) per line (representatives first)',
   table(
   Tr(td({align => 'left'},['Representatives only:',
         checkbox(&identify('_representative'),
                  -checked => 0,
                  -label => '')])),
   Tr(td({align => 'left'},['Image size:',
         popup_menu(&identify('_size'),
                    -labels => {'' => 'Default'},
                    -values => ['',60,120,180])])),
   Tr(td({align => 'left'},['Lightbox projections:',
         checkbox(&identify('_lightbox'),
                  -checked => 0,
                  -label => '')])),
   Tr(td({align => 'left'},['Display mode:',
         popup_menu(&identify('_mode'),
                    -values => [sort keys %modes],
                    -default => '',
                    -labels => \%modes)])),
   )));
}


# ****************************************************************************
# * Subroutine:  renderImagesAjax                                            *
# * Description: This routine will render a table containing a list of       *
# *              stacks. Each stack is accompanied by a total image and      *
# *              links to secondary work products.                           *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub renderImagesAjax
{
  my $family = param('_family');
  my $limit = param('_limit');
  my $ph = (param('_header')) ? &pageHeader(param('line')) : header;
  my $mode = param('_mode');
  # Build query
  my (%func,%rlike);
  foreach my $element (@{$DATA{$family}{query}}) {
    $rlike{$element->{id}}++
      if ($element->{field} && $element->{field} eq 'rlike');
    $func{$element->{id}} = $element->{sqlfilter} if ($element->{sqlfilter});
  }
  my %field = ();
  foreach (param) {
    next if ((/^_/) || (ANY eq param($_)));
    next if (exists $rlike{$_} && !length(param($_)));
    $field{$_} = [param($_)];
  }
  # image_data_vw is the default view. It is overridden if there is
  # a "view" entry for this family.
  my $default = 'image_data_vw';
  my $view = $DATA{$family}{view}{name} || $default;
  my $sql = 'SELECT DISTINCT(name)';
  $sql .= ',line' if ($limit);
  $sql .= " FROM $view";
  $sql .= " WHERE family='$family'"; # if ($view eq $default);
  if (scalar keys %field) {
#    $sql .= ($view eq $default) ? ' AND' : ' WHERE';
    $sql .= ' AND';
    foreach my $parm (keys %field) {
      if (@{$field{$parm}} == 1) {
        if (exists $func{$parm}) {
          (my $sel = $func{$parm}) =~ s/\%\%REPLACE\%\%/$parm/;
          $sql .= " $sel='$field{$parm}[0]' AND";
        }
        elsif (exists $rlike{$parm}) {
          # For an RLIKE, there's a single entry. We lowercase it because
          # some columns (notably gene) are case-sensitive.
          $field{$parm}[0] = lc($field{$parm}[0]);
          $sql .= " lower($parm) rlike '$field{$parm}[0]' AND";
        }
        else {
          $sql .= " $parm='$field{$parm}[0]' AND";
        }
      }
      else {
        my $sel = $parm;
        ($sel = $func{$parm}) =~ s/\%\%REPLACE\%\%/$parm/
          if (exists $func{$parm});
        $sql .= " $sel IN (";
        $sql .= "'$_'," foreach (@{$field{$parm}});
        $sql =~ s/.$/) AND/;
      }
    }
  }
  $sql =~ s/ (?:AND|WHERE)$//;
  # Append the "display=1" check
  if (scalar keys %field) {
    $sql .= ' AND';
  }
  else {
    $sql .= ($sql =~ / WHERE /) ? ' AND' : ' WHERE';
  }
  $sql .= ' display=1';
  # Append representative check
  $sql .= ' AND representative=1' if (param('_representative'));
  # Order by
  $sql .= ($limit) ? ' ORDER BY line ASC,representative DESC,'
                     . 'IFNULL(qi,99) ASC,name ASC'
                   : ' ORDER BY line,name';
  print STDERR "[$sql]\n" if ($DEBUG);
  # Execute the query to get a list of images
  my $t0 = [gettimeofday];
  my $list = [];
  if ($limit) {
    my $prelist = $dbh->selectall_arrayref($sql)
      || return($ph,span({class=>'note'},$DBI::errstr));
    if (scalar @$prelist) {
  	  my $cnt = 0;
  	  my $ln = '';
      foreach (@$prelist) {
        if ($ln ne $_->[1]) {
          push @$list,$_->[0];
      	  $cnt = 1;
      	  $ln = $_->[1];
        }
        elsif ($cnt < $limit) {
          push @$list,$_->[0];
          $cnt++;
      	}
      }
    }
  }
  else {
    $list = $dbh->selectcol_arrayref($sql)
      || return($ph,span({class=>'note'},$DBI::errstr));
  }
  printf STDERR "DBI fetch: %.2fsec\n",tv_interval($t0,[gettimeofday])
    if ($DEBUG);
  return($ph,span({class=>'note'},'No images found')) unless (scalar @$list);
  $t0 = [gettimeofday];
  # Build the table
  my @row = ();
  my %ih = %{$IMAGERY{$DATA{$family}{designation}{type}||$family}};
  # Determine server
  my $srv = param('_server') ? ('http://' . param('_server')
                                . "/cgi-bin/$PROGRAM.cgi")
                             : '';
  # If we have more too many images, we'll timeout on the projection
  # fetches - so skip 'em.
  my $flimit = (scalar(@$list) > FETCH_LIMIT);
  my %lineproj;
  my $thumbs = '';
  foreach my $image (@$list) {
    # $image will contain <path>/<.lsm file>
    my($name,$path) = &parseName($image);
    # If we can't display it, skip it
    next if ($image =~ /(?:avi|pdf|sbfmf)$/);
    $sth{ID2}->execute($image,$family) || return($ph,&ajaxError($DBI::errstr));
    my($image_id,$line,$robot_id) = $sth{ID2}->fetchrow_array();
    my @cell = ();
    if ($mode) {
      my $lm = (param('_lightbox')) ? "lightbox[$mode]" : $mode;
      if ($mode eq 'projection_lines') {
        $lineproj{$line} .= &thumbRequest($image_id,$family,'projection_all',
                                          $name,(undef)x2,$lm,1);
      }
      else {
        $thumbs .= &thumbRequest($image_id,$family,$mode,$name,
                                 (undef)x2,$lm,1);
      }
    }
    # Parse display requirements
    foreach (@{$DATA{$family}{display}}) {
      next if ($_->{hidden});
      my $output = $_->{template};
      while (my($prod) = $output =~ m/\%\%(\w+)\%\%/g) {  
        my $tmp = NBSP;
        switch ($prod) {
          case /^(projection|registered)/ {

            if ($flimit) {
              $tmp = NBSP;
            }
            elsif (param('_lightbox')) {
              $tmp = &thumbRequest($image_id,$family,$prod,$name,
                                   undef,undef,'lightbox['.$prod.']',1);
            }
            else {
              $tmp = &thumbRequest($image_id,$family,$prod,$name);
            }
          }
          case /^(medial|rock|rotation|translation)/ {
               $tmp = &movieRequest($image_id,$family,$prod,$name,
                                    $ih{$prod}{display});}
          case 'stack_literal' {$tmp = $image;}
          case 'stack_display' {
          	$tmp =  &thumbRequest($image_id,$family,'primary',$image,undef,
                                      'projection_all','lightbox['.$prod.']',1)
                  if ($image =~ /(?:jpg|png)$/);
          }
          case 'primary' {
               my $nname = '';
               if ($family eq 'rubin-chacrm') {
                 my($s) = $name =~ /_(\d+)-/;
                 $nname = span({class => 'firsttime'},$name) if ($s eq '00');
               }          
               $tmp = a({href   => "$srv?_op=stack;_family=$family;"
                                   . "_image=".uri_escape($image),
                         target => '_blank'},$nname||$name);
          }
          case /^tiff/ {$tmp = &stackRequest($image_id,$prod,'TIFF');}
          case 'line_name' {$sth{LINE_NAME}->execute($image_id);
			    $tmp = $sth{LINE_NAME}->fetchrow_array();
                            $tmp = (length($tmp))
		                   ? span({style=>'font-size: 10pt;'},$tmp)
		                   : span({style=>'note'},"No $prod found");
	                    }
          case 'gene' {$sth{GENE}->execute($image_id);
                       my $cg = $sth{GENE}->fetchrow_array();
                       if ($cg) {
                         my $cph = $dbh->prepare("CALL getGeneSynonym('$cg')");
                         $cph->execute();
                         my $data = $cph->fetchall_arrayref();
                         @$data = map { $_->[0] } @$data;
                         $tmp = span({style=>'font-size: 10pt;'},
                                join(', ',map {a({href=>$LINK_MAP{'CRM map'}.$_,
                                                  target=>'_blank'},$_)}
                                              @$data));
                       }
                       else {
                         $tmp = span({style=>'note'},'No gene found');
                       }}
          case 'robot_id' {
            $tmp = span({id => $robot_id},'');
          }
          else {$sth{PROPERTY}->execute($prod,$image_id);
                $tmp = $sth{PROPERTY}->fetchrow_array();
                $tmp = (length($tmp))
                       ? span({style=>'font-size: 10pt;'},$tmp)
                       : span({style=>'note'},"No $prod found");}
        }
        $output =~ s/\%\%$prod\%\%/$tmp/g;
      }
      push @cell,$output;
    }
    push @row,td(\@cell);
  }
  printf STDERR "Output build: %.2fsec\n",tv_interval($t0,[gettimeofday])
    if ($DEBUG);
  my $msg = sprintf 'Found %d image%s',scalar(@$list),
                    (scalar(@$list) > 1) ? 's' : '';
  $msg .= ' (too many images - skipping thumbnails)' if ($flimit);
  my $warn = NBSP;
  my $imagery = '';
  if ($mode) {
    if ($mode eq 'projection_lines') {
      $imagery = table(Tr([map {td([$_,$lineproj{$_}])} sort keys %lineproj]));
    }
    else {
      $imagery = div({style => 'width: 600px;'},$thumbs);
    }
  }
  else {
    $imagery = table({class=>'imagetable'},Tr(\@row));
  }
  if ($DATA{$family}{warning}{text}) {
    $warn = br . div({class => 'warning'},$DATA{$family}{warning}{text})
            . div({style=>'clear:both;'},NBSP);
  }
  ($ph,br,span({class=>'success'},$msg),$warn,$imagery);
}


# ****************************************************************************
# * Subroutine:  renderStackPage                                             *
# * Description: This routine will render the stack projections for a single *
# *              stack.                                                      *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub renderStackPage
{
my (%prop,%substack_set,@table);

  my $image = param('_image');
  my $family = param('_family');
  # Get image ID
  $sth{ID}->execute($image,$family)
    || &terminateProgram($DBI::errstr,'Substack display error');
  my($image_id,undef) = $sth{ID}->fetchrow_array();
  # Prepare property table
  $sth{PROPERTIES}->execute($image_id);
  my $p = $sth{PROPERTIES}->fetchall_arrayref();
  &terminateProgram("Image $image was not found (imagery family $family)",
                    'Substack display error') unless (scalar @$p);
  push @{$prop{$_->[0]}},$_->[1] foreach (@$p);
  delete @prop{qw(path url)};
  # Fix dimensions, zoom, and voxel size
  my $dz = $prop{dimension_z}[0];
  foreach my $group (qw(dimension voxel_size zoom)) {
    if ((exists $prop{$group.'_x'}) && (1 == scalar(@{$prop{$group.'_x'}}))) {
      my $dim = join(' x ',$prop{$group.'_x'}[0],$prop{$group.'_y'}[0]);
      $dim .= ' x ' . $prop{$group.'_z'}[0] if (exists $prop{$group.'_z'});
      switch ($group) {
        case 'dimension'  { push @{$prop{dimensions}},$dim; }
        case 'voxel_size' { push @{$prop{'scaling_(&micro;m)'}},$dim; }
        else              { push @{$prop{$group}},$dim; }
      }
      next if ($group eq 'voxel_size');
      delete @prop{map { $group."_$_" } qw(x y z)};
    }
  }
  $prop{dimension_z}[0] = $dz;
  my @PROMOTE = qw(uas_reporter genotype short_genotype);
  my @prop_row;
  my %EXCLUDE = map {$_ => 1} @PROMOTE,
                    qw(bc_correction1 bc_correction2 dimension_z sample_0time
                       sample_0z voxel_size_x voxel_size_y voxel_size_z);
  foreach (keys %prop) {
    next if (exists $EXCLUDE{$_});
    push @prop_row,Tr(th(&translate($_).':'),td(join(', ',@{$prop{$_}})));
  }
  # The capture date is in the image table
  $sth{IMAGE}->execute($image);
  my($ih) = $sth{IMAGE}->fetchrow_hashref;
  my($line,$capture,$imager,$rep) = @{$ih}{qw(line capture_date created_by
                                              representative)};
  $capture ||= '';
  $capture =~ s/\s00:00:00//;
  # Display properties
  @prop_row = (Tr(th('Imagery type:'),td($TYPE{$family})),
               Tr(th('Image:'),
                  td(($DATA{$family}{hide_stack}{value})
                        ? basename($image)
                        : &stackRequest($image_id,'primary',basename($image)))),
               sort @prop_row);
  my @promoted = ();
  # Line data
  $sth{LINE}->execute($line);
  my $lh = $sth{LINE}->fetchrow_hashref();
  my @ldr;
  push @ldr,Tr(th('Lab'),td($lh->{lab_display_name}))
    if ($lh->{lab_display_name});
  $lh->{gene} = join(', ',$lh->{gene},$lh->{synonyms})
    if ($lh->{gene});
  push @ldr,Tr(th('Gene'),td($lh->{gene})) if ($lh->{gene});
  $sth{LINEPROP}->execute($lh->{id});
  $lh = $sth{LINEPROP}->fetchall_arrayref();
  (push @ldr,Tr(th(map {s/_/ /g; ucfirst;} $_->[0]),td($_->[1])))
    foreach (@$lh);
  my $line_data = $line;
  $line_data .= a({id => 'lel',
                   href => '#le',
                   title => 'Show line data',
                   onClick => "toggleLine('le'); return false;"},
                  img({id => 'lei',
                       src => '/css/plus.gif'}))
                . div({id => 'le',
                       style => 'display: none;'},
                      table({class => 'lineinfo'},@ldr))
    if (scalar @ldr);
  push @promoted,Tr(th('Line:'),td($line_data));
  push @promoted,Tr(th('Capture date:'),td($capture)) if ($capture);
  push @promoted,Tr(th('Imaged by:'),td($imager)) if ($imager);
  foreach (@PROMOTE) {
    push @promoted,Tr(th(&translate($_).':'),td(join(', ',@{$prop{$_}})))
      if (exists $prop{$_});
  }
  splice @prop_row,2,0,@promoted if (scalar @promoted);
  my $last_top = 1 + scalar(@promoted);
  my %ih = %{$IMAGERY{$DATA{$family}{designation}{type}||$family}};
  # Image projections
  my $html = br;
  foreach (@{$DATA{$family}{display}}) {
    my $output = $_->{template};
    foreach (my($prod) = $output =~ m/\%\%(\w+)\%\%/g) {
      next unless ($prod =~ /^(projection|registered)/);
      (my $title = basename($image)) =~ s/\.\w+$//;
      (my $alt_prod = $prod) =~ s/projection/substack/;
      my $thumb = &thumbRequest($image_id,$family,$prod,$title,undef,$alt_prod);
      unless (NBSP eq $thumb) {
        push @{$table[0]},$ih{$_}{display} || $prod;
        push @{$table[1]},$thumb;
      }
    }
  }
  $html .= (scalar @table) ?
             div({class=>'stackhoriz'},
                 h4('Total stack projections')
                 . table({class=>'stackproj'},
                         map { Tr(td($table[$_])) } (0,1)))
           : span({class=>'note'},"Image $image has no projections");
  # Get other work products
  my $products = '';
  my($name,$path) = &parseName($image);
  foreach (@{$DATA{$family}{display}}) {
    my $output = $_->{template};
    while (my($prod) = $output =~ m/\%\%(\w+)\%\%/g) {
      my $tmp = '';
      if (grep(/^(medial|rock|rotation|translation)/,$prod)) {
        $tmp = &movieRequest($image_id,$family,$prod,$name,
                             $ih{$prod}{display});
      }
      elsif ($prod =~ /^tiff/) {
        $tmp = &stackRequest($image_id,$prod,'TIFF');
      }
      $output =~ s/\%\%$prod\%\%/$tmp/g;
    }
    $products .= $output if ($output ne '<br>');
  }
  $products =~ s/^(?:&nbsp;|<br>)+//i;
  $html .= div({class=>'stackhorizlast'},
               h4('Other work products'),$products) if ($products);
  # Get substacks
  $sth{SUBSTACKS}->execute($image_id);
  my $s = $sth{SUBSTACKS}->fetchall_arrayref();
  push @{$substack_set{$_->[0]}},$_->[1] foreach (@$s);
  if (@$s) {
    my %strip;
    my @substack_row;
    my $first = 1;
    my %initial;
    foreach my $set (sort keys %substack_set) {
      (my $prod = $set) =~ s/substack/projection/;
      (my $title = basename($image)) =~ s/\.\w+$//;
      my $ss_num = 1;
      foreach (@{$substack_set{$set}}) {
        ($first) && push @{$strip{label}},sprintf '%02d',$ss_num;
        ($title = (split('/'))[-1]) =~ s/\.\w+$//;
#LB
        $initial{$set} = &urlRequestByFile($image_id,$_).'?height=800&proportional=yes'
          unless (exists $initial{$set});
        push @{$strip{$set}},&thumbRequest($image_id,$family,$set,
                                           (sprintf '%s substack %02d',$title,
                                           $ss_num++),$_,undef,'lightbox['.$set.']');
      }
      $first = 0;
    }
    # Separate scrolling strips
    #foreach (sort keys %substack_set) {
    #  my $t = table(Tr(td(\@{$strip{$_}})),
    #                Tr(td({align=>'center'},\@{$strip{label}})),
    #                );
    #  push @substack_row,Tr(td({class=>'tdmiddle'},
    #                           [($ih{$_}{display} || $_).NBSP,
    #                            div({id=>'scroll820'},$t)]));
    #}
    # Single scrolling strip
    my @ss = ();
    push @ss,Tr(td(\@{$strip{$_}})) foreach (sort keys %substack_set);
    unshift @ss,Tr(td({align=>'center',height=>'10px'},\@{$strip{label}}));
    push @substack_row,Tr(td({align=>'right',height=>'10px'},'Substack #'),
                          td({class   => 'tdmiddle',
                              rowspan => scalar(keys %substack_set)+1},
                             div({id=>'scroll820'},table(@ss))));
    push @substack_row,Tr(td({align=>'right',height=>'100px'},
                             a({href  => $initial{$_},
                                title => 'Click to display lightbox',
                                rel   => 'lightbox['.$_.']'},
                               ($ih{$_}{display} || $_)))) #LB
#                             ($ih{$_}{display} || $_)))
      foreach (sort keys %substack_set);
    $html .= div({style=>'clear:both;'},
                 br,h4('Substacks'),table(@substack_row));
  }
  else {
    $html .= div({style=>'clear:both;'},
                 br,span({class=>'note'},"Image $image has no substacks"));
  }
  print &pageHeader(basename($image)),
                    div({id=>'summaryarea'},
                        ($rep ? div({id=>'representative'},'Representative')
                              : ''),
                        table({class=>'summary'},@prop_row[0..$last_top]),
                        div({id=>'scrollsummary'},
                            div({class=>'stackhoriz'},
                                table({class=>'summary'},
                                      @prop_row[1+$last_top..$#prop_row])),
                            (map { div({class=>'stackhoriz'},
                                   &renderColumn($image_id,$_)) } 
                                 qw(laser detector)),
                            div({class=>'stackhorizlast'},
                                &renderColumn($image_id,
                                              'attenuator',\%prop)))),$html;
}


# ****************************************************************************
# * Subroutine:  parseName                                                   *
# * Description: This routine will parse a filepath to return the directory  *
# *              and filename.                                               *
# *                                                                          *
# * Parameters:  (unspecified): file path                                    *
# * Returns:     directory (less trailing separator) and filename            *
# *              (less extension)                                            *
# ****************************************************************************
sub parseName
{
  my($name,$path) = fileparse(shift);
  $path =~ s/\/$//;    # Directory path to primary data
  $name =~ s/\.\w+$//; # Primary data filename (less extension)
  return($name,$path);
}


# ****************************************************************************
# * Subroutine:  renderColumn                                                *
# * Description: This routine will render a data column of a given type.     *
# *                                                                          *
# * Parameters:  image_id: primary image ID                                  *
# *              type:     column type (attenuator, detector, or laser)      *
# *              p:        property hashref                                  *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub renderColumn
{
my (@row,$hr);

  my($image_id,$type,$p) = @_;
  my $html = '';
  if ('laser' eq $type) {
    # Get laser data
    $sth{LASER}->execute($image_id)
      || &terminateProgram($DBI::errstr,'Stack display error');
    $hr = $sth{LASER}->fetchall_hashref('name');
    if (scalar keys %$hr) {
      $html .= h4('Lasers',
                  img({src   => '/images/laser.png',
                       title => 'Lasers'}));
      push @row,Tr(td([$_,$$hr{$_}{power}||''])) foreach (sort keys %$hr);
      $html .= table({class=>'detector'},@row);
    }
    return($html);
  }
  else {
    # Get attenuator/detector data
    $sth{uc($type)}->execute($image_id)
      || &terminateProgram($DBI::errstr,'Stack display error');
    $hr = $sth{uc($type)}->fetchall_hashref('id');
    if (scalar keys %$hr) {
      $html .= h4(ucfirst($type).'s',);
      foreach my $ch (sort keys %$hr) {
        my $track = $$hr{$ch}{track};
        $track .= NBSP.'('.$$hr{$ch}{image_channel_name}.')'
          if (exists $$hr{$ch}{image_channel_name});
        $html .= span({class=>'track'},($track));
        # Spectral detector?
        $html .= (NBSP)x3 . img({src   => '/images/spectral_detector.png',
                                 title => 'Spectral detector'})
          if ($$hr{$ch}{image_channel_name} && $$hr{$ch}{image_channel_name} =~ /^ChS/);
        if ('attenuator' eq $type) {
          @row = ();
          (my $wavelength = $hr->{$ch}{wavelength}) =~ s/ .*//;
          my $content = NBSP;
          if ($wavelength >= 380 && $wavelength <= 750) {
            my $color = &wavelength2Color($wavelength);
            $content = span({title=>$color},
                            div({style=>'height:20px;width:20px;'
                                        . "background-color:$color;"}));
            $content .=  &wavelength2Spectrum($wavelength)
              unless (user_agent() =~ /MSIE/);
          }
          if ((!defined $hr->{$ch}{power_bc1})
              || ($hr->{$ch}{power_bc1} == $hr->{$ch}{power_bc2})) {
            push @row,Tr(td(sprintf '%s at %s',
                            @{$$hr{$ch}}{qw(wavelength transmission)}),
                         td($content));
            push @row,Tr(td([(NBSP)x2]));
          }
          else {
            # P(n) = (P2-P1)*(Z0-(n-1)*dZ-Z1)/Z2-Z1)+P1
            my $dZ = $p->{voxel_size_z}[0];
            my $P1 = $hr->{$ch}{power_bc1};
            my $P2 = $hr->{$ch}{power_bc2};
            my $Z0 = $p->{sample_0z}[0];
            my $Z1 = $p->{bc_correction1}[0];
            my $Z2 = $p->{bc_correction2}[0];
            my $hipower = ($P2-$P1)*($Z0-(1-1)*$dZ-$Z1)/($Z2-$Z1)+$P1;
            ($hipower < 0) && ($hipower = 0);
            my $lopower = ($P2-$P1)*($Z0-($p->{dimension_z}[0]-1)*$dZ-$Z1)/($Z2-$Z1)+$P1;
            push @row,Tr(td('Ramping'),
                         td(sprintf '%.2f%% - %.2f%%',
                            $hipower,$lopower));
            push @row,Tr(td($hr->{$ch}{wavelength}),td($content));
          }
          push @row,Tr(td([(NBSP)x2])) foreach (1..6);
          $html .= table({class=>'detector'},@row);
        }
        elsif ('detector' eq $type) {
          @row = ();
          @row = Tr(td(['Filter',$$hr{$ch}{filter}||'']));
          if (my $c = $$hr{$ch}{color}) {
            push @row,Tr(td(['Color',
                             span({title=>$c},
                                  div({style=>'height:20px;width:20px;'
                                              . "background-color:$c;"},
                                      NBSP))]));
          }
          push @row,Tr(td([&translate($_),$$hr{$ch}{$_}||'']))
            foreach (qw(point_detector_name));
          foreach (qw(detector_voltage amplifier_gain amplifier_offset)) {
            my($f) = $$hr{$ch}{$_.'_first'};
            my($l) = $$hr{$ch}{$_.'_last'};
            if (length($f) && length($l) && $f ne $l) {
              push @row,Tr(td([&translate($_),"$f - $l"]));
            }
            else {
              push @row,Tr(td([&translate($_),$$hr{$ch}{$_}]));
            }
          }
          push @row,Tr(td([&translate($_),$$hr{$ch}{$_}||'']))
            foreach (qw(pinhole_diameter digital_gain));
          $html .= table({class=>'detector'},@row);
        }
      }
    }
    return($html);
  }
}


# ****************************************************************************
# * Subroutine:  wavelength2Spectrum                                         *
# * Description: This routine will create a visible spectrum gradient with a *
# *              caret indicating a given wavelength. This is returned as a  *
# *              base-64 encoded image, so IE is outta luck.                 *
# *                                                                          *
# * Parameters:  wl: wavelength                                              *
# * Returns:     HTML image tag                                              *
# ****************************************************************************
sub wavelength2Spectrum
{
  my $wl = shift;
  my $MIN = 380;
  my $MAX = 750;
  my $SCALE = .33;
  GD::Image->trueColor(1);
  my $im = new GD::Image(map {$_*$SCALE} $MAX-$MIN+1,80);
  my $background = $im->colorAllocate((255)x2,254);
  $im->fill(0,0,$background);
  my @color;
  my $cn = 1;
  foreach ($MIN..$MAX) {
    my($r,$g,$b) = &wavelength2Color($_);
    my $test = $im->colorExact($r,$g,$b);
    $color[$cn] = (-1 == $test) ? $im->colorAllocate($r,$g,$b) : $test;
    $im->line((map {$_*$SCALE} $_-$MIN,79*.3,$_-$MIN,79),$color[$cn]);
    if ($wl == $_) {
    my $poly = new GD::Polygon;
      $poly->addPt(map {$_*$SCALE} $wl-$MIN,79*.3);
      my $left = $wl-$MIN - 79*.27;
      my $right = $wl-$MIN + 79*.27;
      $left = 0 if ($left < 0);
      $right = 400 if ($right > 400);
      $poly->addPt($left*$SCALE,0);
      $poly->addPt($right*$SCALE,0);
      $im->filledPolygon($poly,$color[$cn]);
    }
    $cn++;
  }
  binmode STDOUT;
  img({-src => 'data:image/png;base64,'
               . encode_base64($im->png),
       -alt => ''});
}


# ****************************************************************************
# * Subroutine:  wavelength2Color                                            *
# * Description: This routine will convert a vavelength value (in nm) to an  *
# *              RGB value. This is an optimized version of a FORTRAN        *
# *              routine written by Dan Brunton (astro@tamu.edu).            *
# *                                                                          *
# * Parameters:  wl: wavelength                                              *
# * Returns:     If an array is expected, a three-value (R, G, B) is         *
# *              returned. Otherwise, a hex color triplet is returned.       *
# ****************************************************************************
sub wavelength2Color
{
  my $wl = shift;
  my ($r,$g,$b) = (255)x3;
  if ($wl >= 380 && $wl < 440) {
    ($r,$g,$b) = (-1*($wl-440)/60,0,1);
  }
  elsif ($wl >= 440 && $wl < 490) {
    ($r,$g,$b) = (0,($wl-440)/50,1);
  }
  elsif ($wl >= 490 && $wl < 510) {
    ($r,$g,$b) = (0,1,-1*($wl-510)/20);
  }
  elsif ($wl >= 510 && $wl < 580) {
    ($r,$g,$b) = (($wl-510)/70,1,0);
  }
  elsif ($wl >= 580 && $wl < 645) {
    ($r,$g,$b) = (1,-1*($wl-645)/65,0);
  }
  elsif ($wl >= 645 && $wl <= 780) {
    ($r,$g,$b) = (1,0,0);
  }
  my $adjust = 1;
  if ($wl < 420) {
    $adjust = .3+.7*($wl-380)/40;
  }
  elsif ($wl > 700) {
    $adjust = .3+.7*(780-$wl)/80;
  }
  my $GAMMA = .98;
  ($r,$g,$b) = map { sprintf '%d',($_*255*$adjust)**$GAMMA } ($r,$g,$b);
  return (wantarray) ? ($r,$g,$b) : sprintf '#%02x%02x%02x',($r,$g,$b);
}


# ****************************************************************************
# * Subroutine:  translate                                                   *
# * Description: This routine will translate a property key into text.       *
# *              Property keys are all lowercase (no spaces) and are         *
# *              converted by first looking for a mapping in the XML config. *
# *              Failing that, underbars become spaces and the key then has  *
# *              the first letter of the first word capitalized.             *
# *                                                                          *
# * Parameters:  term: property key                                          *
# * Returns:     displayable text                                            *
# ****************************************************************************
sub translate
{
  my $term = shift;
  return($TRANSFORMATION{$term}) if (exists $TRANSFORMATION{$term});
  $term =~ s/_/ /g;
  ucfirst($term);
}


# ****************************************************************************
# * Subroutine:  pageHeader                                                  *
# * Description: This routine will return the page header.                   *
# *                                                                          *
# * Parameters:  title:  page title                                          *
# *              onload: onLoad action                                       *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub pageHeader
{
  my($title,$onload) = @_;
  my @scripts = map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                ('prototype',$PROGRAM);
  push @scripts,{-language=>'JavaScript',-src=>"/js/scriptaculous/scriptaculous.js?load=effects,builder"};
  push @scripts,{-language=>'JavaScript',-src=>"/js/lightbox.js"};
  my %load = ();
  $load{load} = " $onload" if ($onload);
  my @styles = map { Link({-rel=>'stylesheet',
                             -type=>'text/css','-href',@$_}) }
                     (["/css/lightbox.css"]);
  &JFRC::Utils::Web::pageHeader(title      => $title,
                                css_prefix => $PROGRAM,
                                script     => \@scripts,
                                style      => \@styles,
                                %load);
}


# ****************************************************************************
# * Subroutine:  stackRequest                                                *
# * Description: This routine will return the URL for stack (LSM or TIFF).   *
# *                                                                          *
# * Parameters:  parent:  primary image ID                                   *
# *              product: imagery product                                    *
# *              title:   link title                                         *
# * Returns:     URL or non-breaking space                                   *
# ****************************************************************************
sub stackRequest
{
  my($parent,$product,$title) = @_;
  my $url = &urlRequestByID($parent,$product);
  return(($url) ? a({href=>$url},$title) : NBSP);
}


# ****************************************************************************
# * Subroutine:  thumbRequest                                                *
# * Description: This routine will return a thumbnail image that will open   *
# *              the same image (at a different size) in a popup window when *
# *              clicked. Normally, this routine will use a primary image ID *
# *              and product type to fetch the appropriate image. This can   *
# *              be overridden to fetch a known filename if the "file" parm  *
# *              is specified. If an altername product is specified, the     *
# *              image will be sized as if it were that product.             *
# *                                                                          *
# * Parameters:  parent:   primary image ID                                  *
# *              family:   imagery family                                    *
# *              product:  imagery product                                   *
# *              title:    title for thumbnail and popup window              *
# *              file:     absolute filename to fetch (optional)             *
# *              alt_prod: alternate product (optional)                      *
# *              lightbox: lightbox tag (optional)                           *
# *              pure:     use "pure" lightbox (optional)                    *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub thumbRequest
{
  my($parent,$family,$product,$title,$file,$alt_prod,$lightbox,$pure) = @_;
  my $url = ($file) ? &urlRequestByFile($parent,$file)
                    : &urlRequestByID($parent,$product);
  return(NBSP) unless ($url);
  my %ih = %{$IMAGERY{$DATA{$family}{designation}{type}||$family}};
  $alt_prod = $product if ($alt_prod && !exists $ih{$alt_prod});
  my($tw,$th,$iw,$ih) = @{$ih{$alt_prod||$product}}{qw(thumbw thumbh
                                                       largew largeh)};
  if (param('_size')) {
    if ($th && $tw) {
      $th = $tw = param('_size');
    }
    elsif ($th) {
      $th = param('_size');
    }
    elsif ($tw) {
      $tw = param('_size');
    }
  }
  $title .= ' ' . $ih{$product}{comment}
    if (exists $ih{$product}{comment});
  my $scroll = 0;
  $scroll = 1 if ($iw > 512 || $ih > 512);
  my (@dimensions,@server);
  if ($th) {
    push @dimensions,'height',$th;
    push @server,"height=$th";
  }
  if ($tw) {
    push @dimensions,'width',$tw;
    push @server,"width=$tw";
  }
  push @server,'proportional=yes' if (1 == scalar(@server));
  my $lb_html = ($lightbox) ? a({href  => $url.'?height=800&proportional=yes',
                                 rel   => $lightbox}) : '';
  if ($pure) {
    a({href  => $url.'?height=800&proportional=yes',
       rel   => $lightbox,
       title => $title},
      img({src    => $url . '?' . join('&',@server),
           align  => 'absmiddle',
           title  => $title,
           @dimensions}));
  }
  else {
    a({href    => '#',
       onClick => "openImage('$url','$title',$iw,$ih,$scroll); return false;"},
      img({src    => $url . '?' . join('&',@server),
           align  => 'absmiddle',
           title  => $title,
           @dimensions})) . $lb_html;
  }
}


# ****************************************************************************
# * Subroutine:  urlRequestByID                                              *
# * Description: This routine will return an image URL given a primary or    *
# *              secondary image ID.                                         *
# *                                                                          *
# * Parameters:  id:      primary or secondary image ID                      *
# *              product: imagery product (blank for primary image)          *
# * Returns:     URL                                                         *
# ****************************************************************************
sub urlRequestByID
{
  my($id,$product) = @_;
  $product ||= 'primary';
  my $use_stack = ('primary' eq $product);
  my $statement = ($use_stack) ? 'STACK_URL' : 'SEC_URL';
  my @bind = $id;
  push @bind,$product unless ($use_stack);
  $sth{$statement}->execute(@bind);
  $sth{$statement}->fetchrow_array() || '';
}


# ****************************************************************************
# * Subroutine:  urlRequestByFile                                            *
# * Description: This routine will return an image URL given a name and      *
# *              primary image ID.                                           *
# *                                                                          *
# * Parameters:  (unspecified): primary image ID                             *
# *              (unspecified): secondary image name                         *
# * Returns:     URL                                                         *
# ****************************************************************************
sub urlRequestByFile
{
  $sth{SUBSTACK_URL}->execute(@_);
  $sth{SUBSTACK_URL}->fetchrow_array() || '';
}


# ****************************************************************************
# * Subroutine:  movieRequest                                                *
# * Description: This routine will return a link to display a movie. If no   *
# *              movie is present, a non-breaking space is returned.         *
# *                                                                          *
# * Parameters:  parent:  parent image ID                                    *
# *              family:  imagery family                                     *
# *              product: product                                            *
# *              title:   title to display                                   *
# *              link:    link text to display
# * Returns:     HTML                                                        *
# ****************************************************************************
sub movieRequest
{
  my($parent,$family,$product,$title,$link) = @_;
  my $url = &urlRequestByID($parent,$product) || return(NBSP);
  my %ih = %{$IMAGERY{$DATA{$family}{designation}{type}||$family}};
  my $size = $ih{$product}->{size};
  $title .= ' ' . $ih{$product}{display}
    if (exists $ih{$product}{display});
  return(a({href    => '#',
            onClick => "openQuicktime('$url','$title'," . join(',',($size)x2)
                                      . ",1); return false;"},
           $link || ucfirst($product)));
}


# ****************************************************************************
# * Subroutine:  identify                                                    *
# * Description: This routine will return a hash to identify an HTML element.*
# *                                                                          *
# * Parameters:  (unspecified): element name                                 *
# * Returns:     id/name hash                                                *
# ****************************************************************************
sub identify
{
  map { '-'.$_ => $_[0] } qw(id name);
}


# ****************************************************************************
# * POD documentation                                                        *
# ****************************************************************************
__END__

=head1 NAME

view_sage_imagery.cgi

=head1 SYNOPSIS

http://informatics/cgi-bin/view_sage_imagery.cgi

=head1 DESCRIPTION

This program will allow interactive viewing of a lab's imagery. Images are
requested from the image server (img.int.janelia.org).

This program is driven either by the imagery database (currently using the
"Nighthawk" schema).

=head1 PARAMETERS

=over

=item _op (optional)

Operation. If specified, this is an Ajax request, and will not
display HTML. There are two operations:

=over

query: populate the query section
images: display a list of images meeting query criteria

=back

=item _family (optional)

Imagery family. This is an Ajax request, and will not display HTML.

=item _image (optional)

Image to display information for. This is actually the base name of
the LM imagery file (less the .lsm extension). This is not valid by
itself, and must be specified along with "family" and "line".

=item _header (optional)

Print the full page header (including CSS and JavaScript). This is
only valid when the operation is "images" and is useful for rendering
the page outside of the control of Ajax. At a minimum, the family
must be specified.

=head1 BUGS

1) As usual, Internet Explorer does not support stuff that every other
browser does. In this case, Ajax. Look for "IE hack" in the code.

=head1 AUTHOR INFORMATION

Author: Robert R. Svirskas, HHMI Janelia Farm Research Campus

Address bug reports and comments to:
svirskasr@.janelia.hhmi.org

=cut
