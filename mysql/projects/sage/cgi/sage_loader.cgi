#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;
use Net::LDAP;
use Switch;
use XML::Simple;

use JFRC::Utils::Web qw(:all);
use JFRC::Utils::SAGE qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant BASE_URL => 'http://img.int.janelia.org/flyolympiad-data/fly_olympiad_load/';
use constant DATA_PATH  => '/opt/informatics/data/';
use constant OUTPUT_PATH => '/groups/sciserv/flyolympiad/Olympiad_Screen/';
use constant NBSP => '&nbsp;';
# Modes
use constant INITIAL => 'initial';
use constant UPLOAD  => 'upload';
# LDAP
use constant BASE_DN => 'ou=People,dc=janelia,dc=org';
use constant SERVER => 'b03u01.int.janelia.org';
# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE loader';
my ($input_file,$output_file);

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $OPERATOR;
# XML configuration
my %PROFILE;

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# General parameters
my $DEBUG = param('_debug') ? 1 : 0;
my $PROFILE = param('_profile') ? 1 : 0;
my $VALIDATE = param('_validate') ? 1 : 0;

# Session authentication
my $Session = &establishSession(css_prefix => $PROGRAM);
&sessionLogout($Session) if (param('logout'));
$OPERATOR = $Session->param('user_id');

# Initialize XML
&initializeProgram();

# Main processing
my $mode = param('mode') || INITIAL;
$mode = UPLOAD if (param('upload'));
switch ($mode) {
  case UPLOAD { &runLoader(); }
  else        { &showQuery();  }
}

# We're done!
exit(0);

# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************

sub initializeProgram
{
# Configure XML
  my $p;
  eval {
    $p = XMLin(DATA_PATH . $PROGRAM . '-config.xml',
               KeyAttr => { profile => 'config'}
              );
  };
  &terminateProgram("Could not configure from XML file: $@") if ($@);
  %PROFILE = %{$p->{profile}};
}


sub showQuery
{
  my %profile = map {$_ => $PROFILE{$_}{name}} keys %PROFILE;
  # ----- Page header -----
  print &pageHead();
  my $content =
        div({id => 'tabs-1'},
            start_multipart_form,&hiddenParameters(),
            'Select a load/curation profile:',
            popup_menu(&identify('profile'),
                       -values => [sort keys %PROFILE],
                       -labels => \%profile,
                       -onChange => 'toggleProfile();'),
            br,
            div({style => 'margin: 15px;'},&getInstructions()),
            br,
            'Upload file:',
            filefield(-name => 'upload',
                      -size => 40),br,
            button(&identify('advancedbtn'),
                   class => 'smallbutton',
                   label => 'Show advanced options',
                   onClick => 'toggleAdvanced();'),
            div({&identify('advanced')},
                checkbox(&identify('_debug'),
                         -label => 'Run in debug mode',
                         -checked => 1),
                checkbox(&identify('_validate'),
                         -label => 'Validate input column names with spec',
                         -checked => 1),
                checkbox(&identify('_profile'),
                         -label => 'Show profiling information',
                         -checked => $PROFILE),
                br,
                'User: ',input({&identify('userid')}),
                ' (if specified, this user ID will be used as the',
                "experimentor/curator in place of $OPERATOR)"),
            (br)x2,
            div({align => 'center'},
                submit(-value => 'Run loader')),
            end_form
           );
  my @row;
  my $table_head = thead(Tr(th(['Assay','Date','View','Status'])));
  &getViewableFiles('loading',\@row);
  $content .= div({id => 'tabs-2'},
                  table({class => 'tablesorter',&identify('table1')},$table_head,tbody(@row)));
  &getViewableFiles('curation',\@row);
  $content .= div({id => 'tabs-3'},
                  table({class => 'tablesorter',&identify('table2')},$table_head,tbody(@row)));
  print div({id => 'tabs'},
            ul(li(a({href => '#tabs-1'},'Load/Curate')),
               li(a({href => '#tabs-2'},'View prior loads')),
               li(a({href => '#tabs-3'},'View prior curations'))),
            $content);
  # ----- Footer -----
  print &sessionFooter($Session),end_html;
}


sub getViewableFiles
{
  my($type,$row) = @_;
  my @file = glob(OUTPUT_PATH . "*/$type/*.txt");
  @$row = ();
  foreach (@file) {
    my($assay,$file) = (split(/\//))[5,7];
    my $datetime = substr($file,0,8) . ' '
       . join(':',substr($file,8,2),substr($file,10,2),substr($file,12,2));
    (my $log_file = $_) =~ s/.+Olympiad_Screen\///;
    (my $in_file = $log_file) =~ s/\.txt$/.xls/;
    my $last = `tail -1 $_`;
    my $status = ($last =~ /^Checksums inserted/)
      ? span({class => 'success'},'Complete')
      : span({class => 'note'},'Aborted');
    push @$row,Tr(td([$assay,$datetime,
                      a({href => BASE_URL . $in_file},'Input file') . (NBSP)x5
                      . a({href => BASE_URL . $log_file},'Log file'),$status]));
  }
}


sub runLoader
{
  my $profile = param('profile');
  # Check access
  &terminateProgram('You do not have the proper access to '
                    . $PROFILE{$profile}{operation} . 'data for the '
                    . $PROFILE{$profile}{assay} . ' assay. Contact the '
                    . 'appropriate assay owner to get access')
    unless ($Session->param($PROFILE{$profile}{access}));
  # Check user ID
  my $uid = lc(param('userid')) || $OPERATOR;
  my $ldap = Net::LDAP->new(SERVER);
  my $msg = $ldap->search(base   => "cn=$uid,".BASE_DN,
                          filter => 'uid=*');
  my $entry = $msg->shift_entry
    || &terminateProgram("Unknown user $uid");
  my @input = &convert_input(my $file = param('upload'));
  # ----- Page header -----
  print &pageHead(),start_multipart_form,&hiddenParameters();
  printf 'File %s contained %d line%s%s',$file,scalar(@input),
         (1 == scalar(@input) ? '' : 's'),br;
  my @lt = localtime();
  my $timestamp = sprintf '%4d%02d%02d%02d%02d%02d',$lt[5]+1900,$lt[4]+1,$lt[3],
                          $lt[2],$lt[1],$lt[0];
  $input_file = join('/',OUTPUT_PATH.$PROFILE{$profile}{assay},
                     ('curate' eq $PROFILE{$profile}{operation}) ? 'curation'
                                                                 : 'loading',
                     $timestamp . '_' . $$ . '.xls');
  ($output_file = $input_file) =~ s/xls$/txt/;
  print "Creating transient file $file",br if ($DEBUG);
  open FILE,">$input_file"
    or &terminateProgram("Could not open $input_file ($!)");
  print FILE "$_\n" foreach (@input);
  close(FILE);
  print "Running loader for $profile on $input_file",br if ($DEBUG);
  my @command =('/opt/informatics/bin/sage_loader.pl -file ',$input_file,
                '-lab',$PROFILE{$profile}{lab},
                '-config',$profile);
  push @command,'-output',$output_file;
  push @command,'-verbose','-changelog';
  push @command,'-debug' if ($DEBUG);
  push @command,'-profile' if ($PROFILE);
  push @command,'-validate' if ($VALIDATE);
  push @command,'-module',$PROFILE{$profile}{module}
    if (exists $PROFILE{$profile}{module});
  push @command,'-user',lc(param('userid'))||$OPERATOR;
  print join(' ','Executing command:',@command),br if ($DEBUG);
  my $output = `@command`;
  print "Output was sent to $output_file",br;
  $output .= "\n---------------------------------------\n\n" if ($output);
  open FILE,"$output_file";
  $output .= $_ while (<FILE>);
  close(FILE);
  print div({class => 'boxed'},
            div({class=>'scrollhead'},'Run results'),
            div({class=>'scrollbox'},
                div({class=>'scrollbar'},pre($output))));
  # ----- Footer -----
  print end_form,&sessionFooter($Session),end_html;
}


sub getInstructions
{
  my %message;
  foreach (keys %PROFILE) {
    $message{$_} = br . span({class => 'note'},'WARNING: you do not have '
                             . 'access to load/curate this data.')
      unless ($Session->param($PROFILE{$_}{access}));
  }
  return <<__EOT__;
<div id="olympiad_gap_pf" class="instructions">
Gap crossing manual curation input consists of six tab-delimited columns:
<ol>
<li>Line (required)</li>
<li>Experiment name (required)</li>
<li>Manual P/F (required; must be P, F, or U)</li>
<li>Curator (optional)</li>
<li>Curation date (required)</li>
<li>Curation notes (optional)</li>
</ol>
$message{olympiad_gap_pf}
</div>
<div id="olympiad_aggression_pf" class="instructions">
Aggression manual curation input consists of fourteen tab-delimited columns:
<ol>
<li>Line (required)</li>
<li>Experiment name (required)</li>
<li>Manual P/F (required; must be P, F, or U)</li>
<li>Flag aborted (required; must be 0 or 1)</li>
<li>Flag legacy (required; must be 0 or 1)</li>
<li>Flag redo (required; must be 0 or 1)</li>
<li>Flag review (required; must be 0 or 1)</li>
<li>Notes behavioral (optional)</li>
<li>Notes curation (optional)</li>
<li>Notes keyword (optional)</li>
<li>Notes loading (optional)</li>
<li>Notes technical (optional)</li>
<li>Manual curator (optional)</li>
<li>Manual curation date (required)</li>
</ol>
$message{olympiad_aggression_pf}
</div>
<div id="olympiad_bowl_pf" class="instructions">
Fly Bowl manual curation input consists of seven tab-delimited columns:
<ol>
<li>Line (required)</li>
<li>Experiment name (required)</li>
<li>Manual P/F (required; must be P, F, or U)</li>
<li>Curator (optional)</li>
<li>Curation date (required)</li>
<li>Curation notes (optional)</li>
<li>Diagnostic fields (optional)</li>
</ol>
$message{olympiad_bowl_pf}
</div>
<div id="olympiad_box_pf" class="instructions">
Box manual curation input consists of six tab-delimited columns:
<ol>
<li>Line (required)</li>
<li>Experiment name (required)</li>
<li>Manual P/F (required; must be P, F, or U)</li>
<li>Curator (optional)</li>
<li>Curation date (required)</li>
<li>Curation notes (optional)</li>
</ol>
$message{olympiad_box_pf}
</div>
<div id="olympiad_box_tube_pf" class="instructions">
Box manual curation input consists of seven tab-delimited columns:
<ol>
<li>Line (required)</li>
<li>Experiment name (required)</li>
<li>Tube (required)</li>
<li>Manual P/F (required; must be P, F, or U)</li>
<li>Curator (optional)</li>
<li>Curation date (required)</li>
<li>Curation notes (optional)</li>
</ol>
$message{olympiad_box_pf}
</div>
<div id="olympiad_observation" class="instructions">
Here are the observation instructions.
$message{olympiad_observation}
</div>
<div id="olympiad_observation_pf" class="instructions">
Observation manual curation input consists of six tab-delimited columns:
<ol>
<li>Line (required)</li>
<li>Experiment name (required)</li>
<li>Manual P/F (required; must be P, F, or U)</li>
<li>Curator (optional)</li>
<li>Curation date (required)</li>
<li>Curation notes (optional)</li>
</ol>
$message{olympiad_observation_pf}
</div>
<div id="olympiad_sterility" class="instructions">
Here are the sterility instructions.
$message{olympiad_sterility}
</div>
<div id="olympiad_sterility_pf" class="instructions">
Sterility manual curation input consists of six tab-delimited columns:
<ol>
<li>Line (required)</li>
<li>Experiment name (required)</li>
<li>Manual P/F (required; must be P, F, or U)</li>
<li>Curator (optional)</li>
<li>Curation date (required)</li>
<li>Curation notes (optional)</li>
</ol>
$message{olympiad_sterility_pf}
</div>
__EOT__
}


# ****************************************************************************
# * Subroutine:  convert_input                                               *
# * Description: This routine will create an array of rows from the input    *
# *              stream. This may seem like a waste of time, but trust me:   *
# *              it ain't. We should be able to handle any common IFS, and   *
# *              the expected input will be from Excel running on a Mac.     *
# *              Despite the fact that Excel is running on OS X (Unix-style  *
# *              line separators), it still produces the old-school Mac OFS. *
# *                                                                          *
# * Parameters:  stream: file handle to process                              *
# * Returns:     @field: array of input rows                                 *
# ****************************************************************************
sub convert_input
{
  my $stream = shift;
  my $buffer = '';
  $buffer .= $_ while (<$stream>);

  # Windows: CR/LF
  my @field = split(/\015\012/,$buffer);
  &terminateProgram('Could not process import file') unless (scalar @field);
  if (1 == scalar(@field)) {
    # Mac (pre-OS X): CR
    @field = split(/\012/,$buffer);
    if (1 == scalar(@field)) {
      # Unix: LF
      @field = split(/\015/,$buffer);
      if (1 == scalar(@field)) {
        &terminateProgram('Unknown input format');
      }
    }
  }
  return(@field);
}


# ****************************************************************************
# * Subroutine:  hiddenParameters                                            *
# * Description: This routine will return HTML for hidden parameters.        *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub hiddenParameters
{
  hidden(&identify('_operator'),default=>$OPERATOR);
}


# ****************************************************************************
# * Subroutine:  pageHead                                                    *
# * Description: This routine will return the page header.                   *
# *                                                                          *
# * Parameters:  Named parameters                                            *
# *              title: page title                                           *
# *              mode:  mode (basic, initial, or display)                    *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub pageHead
{
  my %arg = (title => $APPLICATION,
             mode  => INITIAL,
             @_);
  my @scripts = ({-language=>'JavaScript',-src=>"/js/$PROGRAM.js"});
  my @styles = ();
  my %load = ();
  if ($arg{mode} eq INITIAL) {
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                        qw(jquery/jquery-latest
                           jquery/jquery.tablesorter
                           tablesorter
                           jquery/jquery-ui-1.8.17.custom.min
                           jquery/jquery_tabs);
    push @styles,map { Link({-rel=>'stylesheet',
                             -type=>'text/css',-href=>"/css/$_"}) }
                     qw(ui-css/custom-theme/jquery-ui-1.8.14.custom.css
                        tablesorter-blue.css);
    $load{load} = 'tableInitialize(); initialize();'
  }
  &JFRC::Utils::Web::pageHeader(title      => $arg{title},
                                css_prefix => $PROGRAM,
                                script     => \@scripts,
                                style      => \@styles,
                                %load);
}
