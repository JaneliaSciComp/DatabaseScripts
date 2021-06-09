#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;
use DBI;
use XML::Simple;

use JFRC::Utils::SAGE qw(:all);
use JFRC::Utils::Web qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant DATA_PATH  => '/opt/informatics/data/';
use constant NBSP => '&nbsp;';
my $DB = 'dbi:mysql:dbname=sage;host=';

# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE assay information';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $DATABASE;
my %sth = (
ASSAY => 'SELECT display_name,definition,is_current,version,create_date FROM '
         . 'cv WHERE name=?',
ECOUNT => 'SELECT COUNT(1) FROM experiment_vw WHERE cv=?',
EXP => 'SELECT epv.type,"Experiment property",COUNT(1) FROM '
       . 'experiment_property_vw epv JOIN experiment_vw ev ON '
       . '(ev.id=epv.experiment_id AND ev.cv=?) GROUP BY 1',
SESS => 'SELECT spv.type,"Session property",COUNT(1) FROM session_property_vw '
        . 'spv JOIN session_vw sv ON (sv.id=spv.session_id) JOIN '
        . 'experiment_vw ev ON (ev.id=sv.experiment_id AND ev.cv=?) GROUP BY 1 '
        . 'UNION SELECT spv.type,"Session property",COUNT(1) FROM '
        . 'session_property_vw spv JOIN session_vw sv ON '
        . '(sv.id=spv.session_id) WHERE sv.cv=? GROUP BY 1',
PHASE => 'SELECT ppv.type,"Phase property",COUNT(1) FROM phase_property_vw ppv '
         . 'JOIN phase_vw pv ON (pv.id=ppv.phase_id) JOIN '
        . 'experiment_vw ev ON (ev.id=pv.experiment_id AND ev.cv=?) GROUP BY 1',
OBS => 'SELECT ov.type,"Observation value",COUNT(1) FROM observation_vw ov '
       . 'LEFT JOIN experiment_vw ev ON (ev.id=ov.experiment_id) LEFT JOIN '
       . 'session_vw sv ON (sv.id=ov.session_id) WHERE ev.cv=? OR sv.cv=? '
       . 'GROUP BY 1',
SCORE => 'SELECT scv.type,"Score value",COUNT(1) FROM score_vw scv '
       . 'LEFT JOIN experiment_vw ev ON (ev.id=scv.experiment_id) LEFT JOIN '
       . 'session_vw sv ON (sv.id=scv.session_id) LEFT JOIN phase_vw pv ON '
       . '(pv.id=scv.phase_id) WHERE ev.cv=? OR sv.cv=? OR pv.cv=? GROUP BY 1',
SCOREA => 'SELECT sav.type,"Score array value",COUNT(1) FROM score_array_vw sav '
          . 'LEFT JOIN experiment_vw ev ON (ev.id=sav.experiment_id) LEFT JOIN '
          . 'session_vw sv ON (sv.id=sav.session_id) LEFT JOIN phase_vw pv ON '
          . '(pv.id=sav.phase_id) WHERE ev.cv="fly_olympiad_aggression" OR '
          . 'sv.cv="fly_olympiad_aggression" OR pv.cv="fly_olympiad_aggression" '
          . 'GROUP BY 1',
SCOUNT => 'SELECT COUNT(1) FROM session_vw WHERE cv=?',
STAT => 'SELECT cvt.cv_term,"Score value",COUNT(1) FROM score_statistic ss '
        . 'LEFT JOIN experiment_vw ev ON (ev.id=ss.experiment_id) LEFT JOIN '
        . 'session_vw sv ON (sv.id=ss.session_id) LEFT JOIN phase_vw pv ON '
        . '(pv.id=ss.phase_id) JOIN cv_term_vw cvt ON (ss.type_id = cvt.id) '
        . 'WHERE ev.cv=? OR sv.cv=? OR pv.cv=? GROUP BY 1',
IMAGE => 'SELECT ipv.type,"Image property",COUNT(1) FROM image_property_vw ipv '
         . 'JOIN image i ON (i.id=ipv.image_id) JOIN experiment_vw ev ON '
         . '(ev.id=i.experiment_id AND ev.cv=?) GROUP BY 1',
);
# XML configuration
my (%REQUIRED,%TERM,@TERM_ORDER);

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Session authentication
my $Session = &establishSession(css_prefix => $PROGRAM);
&sessionLogout($Session) if (param('logout'));

our $dbh;
# Connect to database
$DATABASE = lc(param('_database') || 'prod');
$DB .= ($DATABASE eq 'prod') ? 'mysql3' : 'db-dev';
$dbh = DBI->connect($DB,('sageRead')x2,{RaiseError=>1,PrintError=>0});
if (param('assay')) {
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth);
  my $assay = param('assay');
  if ($assay =~ /fly_olympiad_/) {
    $assay =~ s/fly_//;
    # Configure XML
    my $p;
    eval {
      $p = XMLin(DATA_PATH . 'olympiad_required_metadata-config.xml',
                 ForceArray => [qw(field)],
                 KeyAttr => { map { $_ => 'key' } qw(term)}
                );
    };
    &terminateProgram("Could not configure from XML file: $@") if ($@);
    (($_->{required}) && $REQUIRED{$_->{term}}++) foreach (@{$p->{field}});
    if (-e (DATA_PATH . $assay . '-config.xml')) {
      eval {
        $p = XMLin(DATA_PATH . $assay . '-config.xml',
                   ForceArray => [qw(field)],
                   KeyAttr => { map { $_ => 'key' } qw(term)}
                  );
      };
      &terminateProgram("Could not configure from XML file: $@") if ($@);
      foreach (@{$p->{field}}) {
        $REQUIRED{$_->{term}} = 1 if ($_->{required});
      }
    }
  }
  # Main processing
  &showOutput();
}
else {
  # Configure XML
  my $p;
  eval {
    $p = XMLin(DATA_PATH . $PROGRAM . '-config.xml',
               ForceArray => [qw(search term)],
               KeyAttr => { map { $_ => 'key' } qw(term)}
              );
  };
  &terminateProgram("Could not configure from XML file: $@") if ($@);
  @TERM_ORDER = @{$p->{search}};
  %TERM = %{$p->{term}};
  &showQuery();
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

sub showQuery
{
sub inputTabTitle { ($a = shift) =~ s/_/ /g; $a; }
my @SEARCH = qw(Search);

  # ----- Page header -----
  print &pageHead(),start_form,&hiddenParameters(),
        div({id => 'mainmenu'},
            ul({id=>'fabtabs',class=>'fabtabs'},
            map { li(a({href => '#'.$_},&inputTabTitle($_))) } @SEARCH));

  print div({class => 'panel',align => 'center',id => shift @SEARCH},
        h3('Assay search'),
        &buildStandardQueryBox(TERM => \%TERM,ORDER => \@TERM_ORDER),
        div({style => 'clear:both;',
             align => 'center'},submit('Search')));

  # ----- Footer -----
  print end_form,&sessionFooter($Session),end_html;
}


# ****************************************************************************
# * Subroutine:  showOutput                                                  *
# * Description: This routine will show the assay output.                    *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub showOutput
{
  # ----- Page header -----
  print &pageHead(mode => 'output'),start_form,&hiddenParameters();

  # Present
  my $assay = param('assay');
  # Basic information
  print h2($assay);
  $sth{ASSAY}->execute($assay);
  my $ar = $sth{ASSAY}->fetchall_arrayref();
  if (scalar @$ar) {
    print table({class => 'tablesorter',&identify('table1')},
                thead(Tr(th(['Display name','Definition','Current','Version',
                       'Created']))),tbody(map {Tr(td([@$_]))} @$ar));
    $sth{ECOUNT}->execute($assay);
    my($num_exp) = $sth{ECOUNT}->fetchrow_array();
    $sth{SCOUNT}->execute($assay);
    my($num_sess) = $sth{SCOUNT}->fetchrow_array();
    print "Experiments: $num_exp",br,"Sessions: $num_sess";
    print br;
    # Storage information
    $sth{EXP}->execute($assay);
    $ar = $sth{EXP}->fetchall_arrayref();
    $sth{SESS}->execute(($assay)x2);
    my $ar2 = $sth{SESS}->fetchall_arrayref();
    $sth{PHASE}->execute($assay);
    my $ar3 = $sth{PHASE}->fetchall_arrayref();
    $sth{OBS}->execute(($assay)x2);
    my $ar4 = $sth{OBS}->fetchall_arrayref();
    $sth{SCORE}->execute(($assay)x3);
    my $ar5 = $sth{SCORE}->fetchall_arrayref();
    $sth{STAT}->execute(($assay)x3);
    my $ar6 = $sth{STAT}->fetchall_arrayref();
    $sth{IMAGE}->execute($assay);
    my $ar7 = $sth{IMAGE}->fetchall_arrayref();
    push @$ar,@$ar2,@$ar3,@$ar4,@$ar5,@$ar6,@$ar7;
    # Check for required CV terms that aren't present at all
    my (%found,%not_found);
    $found{$_->[0]}++ foreach (@$ar);
    foreach (keys %REQUIRED) {
      $not_found{$_}++ unless (exists $found{$_});
    }
    if (@$ar) {
      print table({class => 'tablesorter',&identify('table2')},
                  thead(Tr(th(['CV Term','Stored as','Count']))),
                  tbody(
                  map {Tr(td(a({href => 'sage_cvterm_info.cgi?cvterm='.$_->[0],
                                target => '_blank'},$_->[0])),
                           (&colorize(@$_,$num_exp,$num_sess)))}
                      sort {$a->[0] cmp $b->[0]} @$ar));
      if (scalar keys %not_found) {
      print span({class => 'red'},
                 'Required CV terms that are missing: '),
                 join(', ',sort keys %not_found);
      }
    }
  }
  else {
    print "Assay $assay does not exist";
  }

  # ----- Footer -----
  print div({style => 'clear: both;'},NBSP),end_form,
        &sessionFooter($Session),end_html;
}


sub colorize
{
  my($term,$type,$val,$exp,$sess) = @_;
  return(td($type),td(&commify($val)))
    if (!$REQUIRED{$term} || $type !~ /^(?:Experiment|Session|Score)/);
  if ($REQUIRED{$term}) {
    if (($type =~ /^Experiment/ && $val == $exp)
          || ($type =~ /^Session/ && $val == $sess)
          || ($type =~ /^Score/ && (($val == $exp) || ($val == $sess)))
       ) {
      $val = span({class => 'green'},&commify($val));
    }
    else {
      $val = span({class => 'red'},&commify($val));
    }
  }
  return(td($type),td($val));
}


sub commify
{
  my $text = reverse $_[0];
  $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
  return scalar reverse $text;
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
  hidden(&identify('_database'),default=>$DATABASE);
}


# ****************************************************************************
# * Subroutine:  pageHead                                                    *
# * Description: This routine will return the page header.                   *
# *                                                                          *
# * Parameters:  Named parameters                                            *
# *              title: page title                                           *
# *              mode:  mode (initial, list, or feather)                     *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub pageHead
{
  my %arg = (title => $APPLICATION,
             mode  => 'initial',
             @_);
  my @scripts = ();
  my @styles = ();
  my %load = ();
  if ($arg{mode} eq 'initial') {
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                      qw(prototype fabtabulous);
    push @styles,map { Link({-rel=>'stylesheet',
                             -type=>'text/css','-href',@$_}) }
                     (["/css/fabtabulous.css"]);
  }
  else {
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                      qw(jquery/jquery-latest jquery/jquery.tablesorter
                         tablesorter);
    push @styles,map { Link({-rel=>'stylesheet',
                             -type=>'text/css','-href',@$_}) }
                     (["/css/tablesorter-blue.css"]);
    $load{load} = ' tableInitialize();';
  }

  $arg{title} .= ' (Development)' if ($DATABASE eq 'dev');
  &pageHeader(title      => $arg{title},
              css_prefix => $PROGRAM,
              script     => \@scripts,
              style      => \@styles,
              expires    => 'now',
              %load);
}
