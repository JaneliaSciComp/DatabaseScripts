#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;
use DBI;
use Switch;

use JFRC::Utils::Web qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant NBSP => '&nbsp;';
use constant USER => 'sageRead';
my $DB = 'dbi:mysql:dbname=sage;host=';
my @COLOR = qw(darkorange blue limegreen cyan magenta darkred gold wheat
               seagreen pink);
my %COLOR;

# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'Larval Olympiad SAGE Dashboard';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $DATABASE;
my %sth = (
ES => 'SELECT tracker,experiment_count,session_count FROM lab_assay_stat_mv',
LEGALE => "SELECT DISTINCT(cv_term) FROM cv_term_vw WHERE cv='effector' AND "
          . 'is_current=1',
EFF => 'SELECT tracker,effector,effector_count FROM cv_effector_stat_mv '
       . 'ORDER BY 1,2',
LEGALS => 'SELECT DISTINCT(cv_term) FROM cv_term_vw WHERE cv='
          . "'larval_olympiad_protocol' AND is_current=1",
SP => 'SELECT tracker,stimulus_protocol,stimulus_protocol_count FROM '
      . 'cv_stimpro_stat_mv ORDER BY 1,2',
PLOTS => 'SELECT tracker,plot_type,product,num_plots FROM cv_plot_stat_mv',
);

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Session authentication
my $Session = &establishSession(css_prefix => $PROGRAM);
&sessionLogout($Session) if (param('logout'));

# Connect to database
$DATABASE = lc(param('_database') || 'prod');
$DB .= ($DATABASE eq 'prod') ? 'larval-sage-db' : 'db-dev';
my $dbh = DBI->connect($DB,(USER)x2,{RaiseError=>1,PrintError=>0});
$sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
  foreach (keys %sth);
my $dbhn = DBI->connect('dbi:mysql:dbname=nighthawk;host=mysql2',('nighthawkRead')x2,{RaiseError=>1,PrintError=>0});

# Main processing
&showDashboard();

# We're done!
if ($dbh) {
  ref($sth{$_}) && $sth{$_}->finish foreach (keys %sth);
  $dbh->disconnect;
}
$dbhn->disconnect;
exit(0);


# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************

# ****************************************************************************
# * Subroutine:  showDashboard                                               *
# * Description: This routine will show the dashboard.                       *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub showDashboard
{
  # ----- Page header -----
  print &pageHead(),start_form,&hiddenParameters();
  my $panel = '';

  # Experiments/sessions by tracker
  $sth{ES}->execute();
  my $ar = $sth{ES}->fetchall_arrayref();
  my ($te,$ts) = (0)x3;
  my (%estat,%stat);
  foreach (@$ar) {
    $te += $_->[1];
    $ts += $_->[2];
    ($a = $_->[0]) =~ s/^fly_olympiad_//;
    $COLOR{$a} = shift @COLOR;
    $estat{$a} += $_->[1];
    $stat{$a} += $_->[2];
  }
  my (@vp_color,@vp_data,@vp_label,@vp_tooltip);
  my $tt;
  foreach (sort {$estat{$a} <=> $estat{$b}} keys %estat) {
    $tt += $estat{$_};
    push @vp_color,$COLOR{$_};
    push @vp_data,$estat{$_};
    push @vp_label,'"' . $_ . '"';
    push @vp_tooltip,'"' . $_ . ': ' . $estat{$_} . '"';
  }
  my $vp_color = "['" . join("','",map {$_} @vp_color) . "']";
  my $vp_data = '[' . join(',',map {$_} @vp_data) . '],' . $tt;
  my $vp_label = '[' . join(',',map {$_} @vp_label) . ']';
  my $vp_tooltip = '[' . join(',',map {$_} @vp_tooltip) . ']';
  $tt = 0;
  @vp_color = @vp_data = @vp_label = @vp_tooltip = ();
  foreach (sort {$stat{$a} <=> $stat{$b}} keys %stat) {
    $tt += $stat{$_};
    push @vp_color,$COLOR{$_};
    push @vp_data,$stat{$_};
    push @vp_label,'"' . $_ . '"';
    push @vp_tooltip,'"' . $_ . ': ' . $stat{$_} . '"';
  }
  my $vp_color2 = "['" . join("','",map {$_} @vp_color) . "']";
  my $vp_data2 = '[' . join(',',map {$_} @vp_data) . '],' . $tt;
  my $vp_label2 = '[' . join(',',map {$_} @vp_label) . ']';
  my $vp_tooltip2 = '[' . join(',',map {$_} @vp_tooltip) . ']';
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      h3('Experiments/sessions by tracker'),
      table({class => 'tablesorter',&identify('table1')},
            thead(Tr(th(['Tracker','Experiments','Sessions']))),
            tbody(map { Tr(td([@$_])) } @$ar),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),$te,$ts])))))
         . div({style => 'float: left;'},
         div({style => 'float: left; padding-right: 15px;'},
            h4('Experiments by tracker'),
            "<canvas id='vp' width=650 height=50>[No canvas support]</canvas>")
         . div({style=>'clear:both;'},NBSP)
         . div({style => 'float: left; padding-right: 15px;'},
            "<canvas id='vp2' width=650 height=50>[No canvas support]</canvas>"),
            h4('Sessions by tracker')
         )
         . div({style=>'clear:both;'},NBSP);

  # Effectors by tracker
  $sth{LEGALE}->execute();
  $ar = $sth{LEGALE}->fetchall_arrayref();
  my (%effector,%legal);
  $legal{$_->[0]}++ foreach (@$ar);
  $sth{EFF}->execute();
  $ar = $sth{EFF}->fetchall_arrayref();
  $te = 0;
  my $note = '';
  foreach (@$ar) {
    $te += $_->[2];
    unless (exists $legal{$_->[1]}) {
      $_->[1] = span({style => 'color: #c66;'},$_->[1]);
      $note = 'NOTE: Effectors in ' . span({style => 'color: #c66'},'red')
              . 'are not valid';
    }
    $effector{$_->[1]} += $_->[2];
  }
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      div({class => 'edet'},
      h3('Effectors by tracker',
         button(&identify('btnedet'),
                class=>'smallbutton',
                value=>'Show summary',
                onclick=>'toggleEffectorTable();')),
      table({class => 'tablesorter',&identify('table2')},
            thead(Tr(th(['Tracker','Effector','Count']))),
            tbody(map { Tr(td([@$_])) } @$ar),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),NBSP,$te]))))),
      div({class => 'esum'},
      h3('Effectors',
         button(&identify('btnesum'),
                class=>'smallbutton',
                value=>'Show details',
                onclick=>'toggleEffectorTable();')),
      table({class => 'tablesorter',&identify('table3')},
            thead(Tr(th(['Effector','Count']))),
            tbody(map { Tr(td([$_,$effector{$_}])) } sort keys %effector),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),$te]))))),$note);

  # Stimulus/protocol by tracker
  $sth{LEGALS}->execute();
  $ar = $sth{LEGALS}->fetchall_arrayref();
  %effector = %legal = ();
  $legal{$_->[0]}++ foreach (@$ar);
  $sth{SP}->execute();
  $ar = $sth{SP}->fetchall_arrayref();
  $te = 0;
  $note = '';
  foreach (@$ar) {
    $te += $_->[2];
    unless (exists $legal{$_->[1]}) {
      $_->[1] = span({style => 'color: #c66;'},$_->[1]);
      $note = 'NOTE: stimulus/protocols in ' . span({style => 'color: #c66'},'red')
              . 'are not valid';
    }
    $effector{$_->[1]} += $_->[2];
  }
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      div({class => 'sdet'},
      h3('Stimulus/protocols by tracker',
         button(&identify('btnsdet'),
                class=>'smallbutton',
                value=>'Show summary',
                onclick=>'toggleStimproTable();')),
      table({class => 'tablesorter',&identify('table3')},
            thead(Tr(th(['Tracker','Stimulus/protocol','Count']))),
            tbody(map { Tr(td([@$_])) } @$ar),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),NBSP,$te]))))),
      div({class => 'ssum'},
      h3('Stimulus/protocols',
         button(&identify('btnssum'),
                class=>'smallbutton',
                value=>'Show details',
                onclick=>'toggleStimproTable();')),
      table({class => 'tablesorter',&identify('table3')},
            thead(Tr(th(['Stimulus/protocol','Count']))),
            tbody(map { Tr(td([$_,$effector{$_}])) } sort keys %effector),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),$te]))))),$note);

  # Plots by tracker/type/product
  $sth{PLOTS}->execute();
  $ar = $sth{PLOTS}->fetchall_arrayref();
  $te = 0;
  %effector = ();
  foreach (@$ar) {
    $effector{$_->[2]} += $_->[3];
    $te += $_->[3];
  }
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      div({class => 'pdet'},
      h3('Plots by tracker/type/product',
         button(&identify('btnpdet'),
                class=>'smallbutton',
                value=>'Show summary',
                onclick=>'togglePlotTable();')),
      table({class => 'tablesorter',&identify('table4')},
            thead(Tr(th(['Tracker','Plot type','Product','Count']))),
            tbody(map { Tr(td([@$_])) } @$ar),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),(NBSP)x2,$te]))))),
      div({class => 'psum'},
      h3('Plots by product',
         button(&identify('btnpsum'),
                class=>'smallbutton',
                value=>'Show details',
                onclick=>'togglePlotTable();')),
      table({class => 'tablesorter',&identify('table4')},
            thead(Tr(th(['Product','Count']))),
            tbody(map { Tr(td([$_,$effector{$_}])) } sort keys %effector),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),$te]))))));

  # Chart JavaScript
  my $bar_config = qq~
vp.Set('chart.height',60);
vp.Set('chart.width',650);
vp.Set('chart.gutter',20);
vp.Set('chart.margin',0);
vp.Set('chart.tooltips.effect','fade');
vp.Set('chart.numticks',0);
~;
  my $chart = qq~
<script type="text/javascript">
var pfdetail = 0;
var edetail = 1;
var sdetail = 1;
var pdetail = 1;
\$(document).ready(function() {
  \$(".pfdel").hide();
  \$(".edet").hide();
  \$(".sdet").hide();
  \$(".pdet").hide();
});
function togglePFTable () {
  if (pfdetail) {
    \$(".pfdel").hide();
  }
  else {
    \$(".pfdel").show();
  }
  pfdetail = 1 - pfdetail;
}
function toggleEffectorTable () {
  if (edetail) {
    \$(".esum").hide();
    \$(".edet").show();
  }
  else {
    \$(".esum").show();
    \$(".edet").hide();
  }
  edetail = 1 - edetail;
}
function toggleStimproTable () {
  if (sdetail) {
    \$(".ssum").hide();
    \$(".sdet").show();
  }
  else {
    \$(".ssum").show();
    \$(".sdet").hide();
  }
  sdetail = 1 - sdetail;
}
function togglePlotTable () {
  if (pdetail) {
    \$(".psum").hide();
    \$(".pdet").show();
  }
  else {
    \$(".psum").show();
    \$(".pdet").hide();
  }
  pdetail = 1 - pdetail;
}

function createCharts () {
var vp = new RGraph.HProgress('vp',$vp_data);
vp.Set('chart.tooltips',$vp_tooltip);
vp.Set('chart.key',$vp_label);
$bar_config
vp.Set('chart.colors',$vp_color);
vp.Draw();
vp = new RGraph.HProgress('vp2',$vp_data2);
vp.Set('chart.tooltips',$vp_tooltip2);
$bar_config
vp.Set('chart.colors',$vp_color2);
vp.Draw();
~;
  $chart .= qq~
};
</script>
~;
  print $chart,div({align => 'center'},$panel);

  # ----- Footer -----
  print div({style => 'clear: both;'},NBSP),end_form,
        &sessionFooter($Session),end_html;
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
                      qw(jquery/jquery-latest jquery/jquery.tablesorter
                         tablesorter RGraph/RGraph.common.core
                         RGraph/RGraph.hprogress
                         RGraph/RGraph.common.context
                         RGraph/RGraph.common.tooltips
                         RGraph/RGraph.common.annotate);
    push @styles,map { Link({-rel=>'stylesheet',
                             -type=>'text/css',-href=>"/css/$_"}) }
                     qw(tablesorter-blue.css);
    $load{load} = ' tableInitialize(); createCharts();';
  }
  $arg{title} .= ' (Development)' if ($DATABASE eq 'dev');
  &pageHeader(title      => $arg{title},
              css_prefix => $PROGRAM,
              script     => \@scripts,
              style      => \@styles,
              expires    => 'now',
              %load);
}
