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
our $APPLICATION = 'SAGE CV term information';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $DATABASE;
my $HIGH_LEVEL = 0;
my %sth = (
CV => 'SELECT cv FROM cv_term_vw WHERE id=?',
TERM => 'SELECT cv,id,display_name,definition,is_current,data_type,create_date '
        . 'FROM cv_term_vw WHERE cv_term=? ORDER BY 1',
CON => 'SELECT assay,stored,default_value,required FROM cv_term_constraint_vw '
       . 'WHERE cv_term=? ORDER BY 1',
EXP => 'SELECT epv.cv,ev.cv,"","","Experiment property",value FROM '
       . 'experiment_property_vw epv JOIN experiment_vw ev ON '
       . '(ev.id=epv.experiment_id AND epv.type=?) GROUP BY 1,2,3,4',
SESS => 'SELECT spv.cv,ev.cv,sv.cv,"","Session property",value FROM '
        . 'session_property_vw spv JOIN session_vw sv ON (sv.id=spv.session_id '
        . 'AND spv.type=?) JOIN experiment_vw ev ON (ev.id=sv.experiment_id) '
        . 'GROUP BY 1,2,3,4',
PHASE => 'SELECT ppv.cv,ev.cv,"",pv.cv,"Phase property",value FROM '
         . 'phase_property_vw ppv JOIN phase_vw pv ON (pv.id=ppv.phase_id AND '
         . 'ppv.type=?) JOIN experiment_vw ev ON (ev.id=pv.experiment_id) '
         . 'GROUP BY 1,2,3,4',
OBS => 'SELECT ov.cv,ev.cv,sv.cv,"","Observation value",value FROM '
       . 'observation_vw ov LEFT JOIN experiment_vw ev ON '
       . '(ev.id=ov.experiment_id) LEFT JOIN session_vw sv ON '
       . '(sv.id=ov.session_id) WHERE ov.type=? GROUP BY 1,2,3,4',
SCORE => 'SELECT scv.cv,ev.cv,sv.cv,pv.cv,"Score value",value FROM '
       . 'score_vw scv LEFT JOIN experiment_vw ev ON '
       . '(ev.id=scv.experiment_id) LEFT JOIN session_vw sv ON '
       . '(sv.id=scv.session_id) LEFT JOIN phase_vw pv ON (pv.id=scv.phase_id) '
       . 'WHERE scv.type=? GROUP BY 1,2,3,4',
STAT => 'SELECT cvt.cv,ev.cv,sv.cv,pv.cv,"Score statistic",n FROM '
      . 'score_statistic ss LEFT JOIN experiment_vw ev ON '
      . '(ev.id=ss.experiment_id) LEFT JOIN session_vw sv ON '
      . '(sv.id=ss.session_id) LEFT JOIN phase_vw pv ON (pv.id=ss.phase_id) '
      . 'JOIN cv_term_vw cvt ON (ss.type_id = cvt.id) '
      . 'WHERE cvt.cv_term=? GROUP BY 1,2,3,4',
IMAGE => 'SELECT cv,"","","","Image property",value FROM image_property_vw '
         . 'WHERE type=? GROUP BY 1,2,3,4',
E => 'SELECT cv FROM experiment_vw WHERE id=?',
S => 'SELECT cv FROM session_vw WHERE id=?',
P => 'SELECT cv FROM phase_vw WHERE id=?',
);
# XML configuration
my (%TERM,@TERM_ORDER);

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Session authentication
my $Session = &establishSession(css_prefix => $PROGRAM);
&sessionLogout($Session) if (param('logout'));

my $dbh;
$HIGH_LEVEL = param('_highlevel');
# Connect to database
$DATABASE = lc(param('_database') || 'prod');
$DB .= ($DATABASE eq 'prod') ? 'mysql3' : 'db-dev';
$dbh = DBI->connect($DB,('sageRead')x2,{RaiseError=>1,PrintError=>0});
if (param('cvterm')) {
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth);
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
        h3('CV term search'),
        &buildStandardQueryBox(TERM => \%TERM,ORDER => \@TERM_ORDER),
        div({style => 'clear:both;',
             align => 'center'},submit('Search')));

  # ----- Footer -----
  print end_form,&sessionFooter($Session),end_html;
}


# ****************************************************************************
# * Subroutine:  showOutput                                                  *
# * Description: This routine will show the CV term output.                  *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub showOutput
{
  # ----- Page header -----
  print &pageHead(mode => 'output'),start_form,&hiddenParameters();

  # Present
  my $term = param('cvterm');
  # Basic information
  print h2($term);
  $sth{TERM}->execute($term);
  my $ar = $sth{TERM}->fetchall_arrayref();
  if (scalar @$ar) {
    print h3('Basic information');
    print table({class => 'tablesorter',&identify('table1')},
                thead(Tr(th(['CV','ID','Display name','Definition','Current',
                             'Data type','Created']))),
                tbody(map {Tr(td([@$_]))} @$ar));
    my @id = map {$_->[1]} @$ar;
    print br;
    $sth{CON}->execute($term);
    $ar = $sth{CON}->fetchall_arrayref();
    if (scalar @$ar) {
      print h3('Constraints');
      print table({class => 'tablesorter',&identify('table11')},
                  thead(Tr(th(['Assay','Stored as','Default','Required']))),
                  tbody(map {Tr(td([@$_]))} @$ar));
      print br;
    }
    # Storage information
    print h3('Storage information');
    $sth{EXP}->execute($term);
    $ar = $sth{EXP}->fetchall_arrayref();
    $sth{SESS}->execute($term);
    my $ar2 = $sth{SESS}->fetchall_arrayref();
    my ($ar3,$ar4,$ar5,$ar6,$ar7,$ar8);
    unless ($HIGH_LEVEL) {
    $sth{PHASE}->execute($term);
    $ar3 = $sth{PHASE}->fetchall_arrayref();
    $sth{OBS}->execute($term);
    $ar4 = $sth{OBS}->fetchall_arrayref();
    $sth{SCORE}->execute($term);
    $ar5 = $sth{SCORE}->fetchall_arrayref();
    $sth{STAT}->execute($term);
    $ar6 = $sth{STAT}->fetchall_arrayref();
    $ar7 = $dbh->selectall_arrayref('SELECT type_id,experiment_id,session_id'
           . ',phase_id,"Score array value","(array)"FROM score_array WHERE '
           . 'type_id IN (' . join(',',@id) . ')');
    if (scalar @$ar7) {
      my %sa;
      $sa{$_->[0]} = [@$_] foreach (@$ar7);
      @$ar7 = ();
      push @$ar7,[@{$sa{$_}}] foreach (keys %sa);
      foreach (@$ar7) {
        $sth{CV}->execute($_->[0]);
        ($_->[0]) = $sth{CV}->fetchrow_array();
        my %m = (1=>'E',2=>'S',3=>'P');
        foreach my $k (keys %m) {
          if ($_->[$k]) {
            $sth{$m{$k}}->execute($_->[$k]);
            ($_->[$k]) = $sth{$m{$k}}->fetchrow_array();
          }
        }
      }
    }
    $sth{IMAGE}->execute($term);
    $ar8 = $sth{IMAGE}->fetchall_arrayref();
    }
    else {
      @$ar3 = @$ar4 = @$ar5 = @$ar6 = @$ar7 = @$ar8 = ();
    }
    push @$ar,@$ar2,@$ar3,@$ar4,@$ar5,@$ar6,@$ar7,@$ar8;
    print table({class => 'tablesorter',&identify('table2')},
                thead(
                Tr(th(['Term CV','Experiment CV','Session CV','Phase CV',
                       'Stored as','Sample data']))),
                tbody(map {Tr(td([@$_]))} sort {$a->[0] cmp $b->[0]} @$ar));
  }
  else {
    print "Term $term does not exist";
  }

  # ----- Footer -----
  print div({style => 'clear: both;'},NBSP),end_form,
        &sessionFooter($Session),end_html;
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
                      qw(prototype fabtabulous scriptaculous/scriptaculous),
                      $PROGRAM;
    push @styles,map { Link({-rel=>'stylesheet',
                             -type=>'text/css','-href',@$_}) }
                     (["/css/fabtabulous.css"]);
    $load{load} = ' ajaxInitialize();';
  }
  else {
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                      qw(jquery/jquery-latest
                         jquery/jquery.tablesorter tablesorter);
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
