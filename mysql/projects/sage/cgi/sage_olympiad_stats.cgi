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
my $PRIMARY_COST = 180;
my $ARCHIVE_COST = 60;
my $DB = 'dbi:mysql:dbname=sage;host=';
my @ASSAY = qw(aggression box climbing fly_bowl gap_crossing observation sterility);
my @COLOR = qw(darkorange blue limegreen cyan magenta darkred gold wheat
               seagreen pink);
my %COLOR;

# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'Fly Olympiad SAGE Dashboard';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $DATABASE;
my %sth = (
DU => 'SELECT LEFT(d1.read_datetime,8),SUM(d1.volume),SUM(d2.volume) FROM '
      . 'disk_usage_detailed_vw d1 LEFT JOIN disk_usage_detailed_vw d2 ON '
      . '(d1.read_datetime=d2.read_datetime AND d1.cv=d2.cv AND '
      . "d1.assay=d2.assay AND d2.storage='archive_volume') WHERE "
      . "d1.cv='fly_olympiad' AND d1.storage='primary_volume' "
      . "AND d1.assay != 'flyolympiad' GROUP BY d1.read_datetime",
DUD => 'SELECT LEFT(d1.read_datetime,8),d1.assay,d1.volume,d2.volume FROM '
       . 'disk_usage_detailed_vw d1 LEFT JOIN disk_usage_detailed_vw d2 ON '
       . '(d1.read_datetime=d2.read_datetime AND d1.cv=d2.cv AND '
       . "d1.assay=d2.assay AND d2.storage='archive_volume') WHERE "
       . "d1.cv='fly_olympiad' and d1.storage='primary_volume' AND d1.assay != 'flyolympiad'",
ES => 'SELECT assay,line_count,experiment_count,session_count FROM lab_assay_stat_mv '
      . "WHERE lab='Fly Olympiad' AND assay != 'fly_olympiad'",
ET => 'SELECT e.cv,ep.value,count(1) FROM experiment_vw e JOIN '
      . 'experiment_property_vw ep ON (e.id=ep.experiment_id AND ep.type=?) '
      . 'GROUP BY 1,2',
EAD => 'SELECT e.cv,LEFT(ep.value,6),COUNT(1) FROM experiment_vw e JOIN '
       . 'experiment_property_vw ep ON (e.id=ep.experiment_id AND '
       . "ep.type='exp_datetime') WHERE ep.value IS NOT NULL AND ep.value > 0 "
       . 'GROUP BY 1,2',
LEGAL => "SELECT DISTINCT(cv_term) FROM cv_term_vw WHERE cv='effector' AND "
         . 'is_current=1',
EFF => 'SELECT cv,effector,effector_count FROM cv_effector_stat_mv WHERE '
       . "cv like 'fly_olympiad%' ORDER BY 1,2",
APF => 'SELECT cv,automated_pf,COUNT(2) FROM olympiad_runs_unique_mv WHERE '
       . 'automated_pf IS NOT NULL GROUP BY 1,2',
MPF => 'SELECT cv,manual_pf,COUNT(2) FROM olympiad_runs_unique_mv WHERE '
       . 'manual_pf IS NOT NULL GROUP BY 1,2',
);

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Session authentication
my $Session = &establishSession(css_prefix => $PROGRAM);
&sessionLogout($Session) if (param('logout'));

# Connect to database
$DATABASE = lc(param('_database') || 'prod');
$DB .= ($DATABASE eq 'prod') ? 'mysql3' : 'db-dev';
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

  # Experiments/sessions by assay
  $sth{ES}->execute();
  my $ar = $sth{ES}->fetchall_arrayref();
  my ($te,$ts) = (0)x2;
  my (%estat,%stat);
  foreach (@$ar) {
    $te += $_->[2];
    $ts += $_->[3];
    ($a = $_->[0]) =~ s/^fly_olympiad_//;
    $COLOR{$a} = shift @COLOR;
    $estat{$a} += $_->[2];
    $stat{$a} += $_->[3];
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
      h3('Experiments/sessions by assay'),
      table({class => 'tablesorter',&identify('table1')},
            thead(Tr(th(['Assay','Lines','Experiments','Sessions']))),
            tbody(map { Tr(td([@$_])) } @$ar),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),NBSP,$te,$ts])))))
         . div({style => 'float: left;'},
         div({style => 'float: left; padding-right: 15px;'},
            h4('Experiments by assay'),
            "<canvas id='vp' width=710 height=50>[No canvas support]</canvas>")
         . div({style=>'clear:both;'},NBSP)
         . div({style => 'float: left; padding-right: 15px;'},
            "<canvas id='vp2' width=710 height=50>[No canvas support]</canvas>"),
            h4('Sessions by assay')
         )
         . div({style=>'clear:both;'},NBSP);

  # Experiment_types
  $sth{ET}->execute('screen_type');
  $ar = $sth{ET}->fetchall_arrayref();
  $te = 0;
  $te += $_->[2] foreach (@$ar);
  $panel .= div({style => 'float: left; padding-right: 15px;'},
                h3('Experiments by screen type'),
                table({class => 'tablesorter',&identify('table2')},
                      thead(Tr(th(['Assay','Screen type','Count']))),
                      tbody(map { Tr(td([@$_])) } @$ar),
                      tfoot(Tr(td([span({style => 'font-weight: bold;'},
                                        'TOTAL'),'',$te])))));
  $sth{ET}->execute('screen_reason');
  $ar = $sth{ET}->fetchall_arrayref();
  $te = 0;
  $te += $_->[2] foreach (@$ar);
  $panel .= div({style => 'float: left; padding-right: 15px;'},
                h3('Experiments by screen reason'),
                table({class => 'tablesorter',&identify('table3')},
                      thead(Tr(th(['Assay','Screen reason','Count']))),
                      tbody(map { Tr(td([@$_])) } @$ar),
                      tfoot(Tr(td([span({style => 'font-weight: bold;'},
                                        'TOTAL'),'',$te])))));
  $panel .=  div({style => 'float: left; padding-right: 15px;'},
                 h4('Experiments by assay/date'),
                 "<canvas id='lp' width=500 height=300>[No canvas support]</canvas>");
  $panel .= div({style=>'clear: both;'},NBSP);

  # Experiments by assay/date
  $sth{EAD}->execute();
  $ar = $sth{EAD}->fetchall_arrayref();
  my (%ead,%mm);
  foreach (@$ar) {
    next unless ($_->[1] =~ /^\d+$/);
    $_->[0] =~ s/fly_olympiad_//;
    $ead{$_->[0]}{$_->[1]} = $_->[2];
    $mm{$_->[1]}++;
  }
  my @data;
  $a = 0;
  foreach my $assay (@ASSAY) {
    $data[$a] = sprintf 'var edata%d = [',$a;
    foreach (sort keys %mm) {
      $data[$a] .= ($ead{$assay}{$_} || 0) . ',';
    }
    $data[$a] =~ s/,$//;
    $data[$a++] .= '];';
  }
  my $lp_data = '';
  my $max = $#data;
  $lp_data .= $data[$_] . "\n" foreach (0..$max);
  $lp_data .= 'var elabels = [';
  $lp_data .= join(',',sort keys %mm) . "];\n";
  $lp_data .= "var lp = new RGraph.Line('lp',";
  $lp_data .= join(',',map {'edata' . $_} (0..$max)) . ");\n";

  # Effectors by assay
  $sth{LEGAL}->execute();
  $ar = $sth{LEGAL}->fetchall_arrayref();
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
              . ' are not valid';
    }
    $effector{$_->[1]} += $_->[2];
  }
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      div({class => 'edet'},
      h3('Effectors by assay',
         button(&identify('btnedet'),
                class=>'smallbutton',
                value=>'Show summary',
                onclick=>'toggleEffectorTable();')),
      table({class => 'tablesorter',&identify('table4')},
            thead(Tr(th(['Assay','Effector','Count']))),
            tbody(map { Tr(td([@$_])) } @$ar),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),NBSP,$te]))))),
      div({class => 'esum'},
      h3('Effectors',
         button(&identify('btnesum'),
                class=>'smallbutton',
                value=>'Show details',
                onclick=>'toggleEffectorTable();')),
      table({class => 'tablesorter',&identify('table5')},
            thead(Tr(th(['Effector','Count']))),
            tbody(map { Tr(td([$_,$effector{$_}])) } sort keys %effector),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),$te]))))),$note);
  # Pass/Fail by assay
  # Auto
  $sth{APF}->execute();
  $ar = $sth{APF}->fetchall_arrayref();
  my (%hb,%pf);
  my @total = (0)x6;
  foreach (@$ar) {
    @{$pf{$_->[0]}} = (0)x6 unless exists($pf{$_->[0]});
    switch ($_->[1]) {
      case 'P' { $total[0] += ($pf{$_->[0]}[0] = $_->[2]) }
      case 'F' { $total[1] += ($pf{$_->[0]}[1] = $_->[2])}
      else { $total[2] += ($pf{$_->[0]}[2] = $_->[2])}
    }
  }
  # Manual
  $sth{MPF}->execute();
  $ar = $sth{MPF}->fetchall_arrayref();
  foreach (@$ar) {
    @{$pf{$_->[0]}} = (0)x6 unless exists($pf{$_->[0]});
    switch ($_->[1]) {
      case 'P' { $total[3] += ($pf{$_->[0]}[3] = $_->[2]) }
      case 'F' { $total[4] += ($pf{$_->[0]}[4] = $_->[2])}
      else { $total[5] += ($pf{$_->[0]}[5] = $_->[2])}
    }
  }
  @$ar = ();
  foreach my $k (sort keys %pf) {
    my @row = (0)x6;
    # Auto
    my $t = $pf{$k}[0] + $pf{$k}[1] + $pf{$k}[2];
    foreach $a (0..2) {
      $row[$a] = sprintf "%d (%.2f%%)",$pf{$k}[$a],$pf{$k}[$a]/$t*100
        if ($pf{$k}[$a]);
    }
    my $last = 2;
    $last = ($pf{$k}[1]) ? 1 : 0 unless ($pf{$k}[2]);
    $hb{$k}{adata} = '[' . join(',',@{$pf{$k}}[0..$last]) . '],' . $t;
    $hb{$k}{att} = "['" . join("','",@row[0..$last]) . "']";
    # Manual
    $t = $pf{$k}[3] + $pf{$k}[4] + $pf{$k}[5];
    foreach $a (3..5) {
      $row[$a] = sprintf "%d (%.2f%%)",$pf{$k}[$a],$pf{$k}[$a]/$t*100
        if ($pf{$k}[$a]);
    }
    $hb{$k}{mdata} = '[' . join(',',@{$pf{$k}}[3..5]) . '],' . $t;
    $hb{$k}{mtt} = "['" . join("','",@row[3..5]) . "']";
    push @$ar,[$k,
               (map {"<canvas id='$_"
                     ."hb$k' width=100 height=20>[No canvas support]</canvas>"}
                qw(a m)),@{$pf{$k}}[0..5]];
  }
  my $t = $total[0] + $total[1] + $total[2];
  $hb{total}{adata} = '[' . join(',',@total[0..2]) . '],' . $t;
  my @row;
  push @row,sprintf '%d (%.2f%%)',$total[$_],$total[$_]/$t*100 foreach (0..2);
  $hb{total}{att} = "['" . join("','",@row) . "']";
  $t = $total[3]+$total[4]+$total[5];
  push @row,sprintf '%d (%.2f%%)',$total[$_],$total[$_]/$t*100 foreach (3..5);
  $hb{total}{mdata} = '[' . join(',',@total[3..5]) . '],' . $t;
  $hb{total}{mtt} = "['" . join("','",@row[3..5]) . "']";
  unshift @total,"<canvas id='mhbtotal' width=100 height=20>[No canvas support]</canvas>";
  unshift @total,"<canvas id='ahbtotal' width=100 height=20>[No canvas support]</canvas>";
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      h3('Assay Pass/Fail'),
      table({class => 'tablesorter',&identify('table6')},
            thead(Tr(th(['Assay','Auto Pass/Fail','Manual Pass/Fail']),
                     th({class=>'pfdel'},['Auto Pass','Auto Fail',
                                          'Auto Unknown','Manual Pass',
                                          'Manual Fail','Manual Unknown']))),
            tbody(map { Tr(td([@$_[0..2]]),td({class=>'pfdel'},[@$_[3..8]])) } @$ar),
            tfoot(Tr({id => 'standardfoot'},td([span({style => 'font-weight: bold;'},'TOTAL'),
                         @total[0..1]]),
                     td({class => 'pfdel'},[@total[2..7]])))
      ),
      div(
      span({style => 'background-color: green;'},(NBSP)x2),' PASS',(NBSP)x4,
      span({style => 'background-color: red;'},(NBSP)x2),' FAIL',(NBSP)x4,
      span({style => 'background-color: slategray;'},(NBSP)x2),' UNKNOWN',(NBSP)x2,
      button(&identify('btnPF'),
             class=>'smallbutton',
             value=>'Toggle details',
             onclick=>'togglePFTable();')));

  # Disk usage (total)
  my($lp2_data,$lp3_data);
  $sth{DU}->execute();
  $ar = $sth{DU}->fetchall_arrayref();
  if (scalar @$ar) {
  @data = ();
  foreach $a (0,1) {
    $data[$a] = sprintf 'var ddata%d = [',$a;
    foreach (@$ar) {
      $data[$a] .= ($_->[$a+1]/1024 || 0) . ',';
    }
    $data[$a] =~ s/,$//;
    $data[$a] .= '];';
  }
  $lp2_data .= $data[$_] . "\n" foreach (0..1);
  $lp2_data .= 'var dlabels = [';
  $lp2_data .= join(',',map {$_->[0]} @$ar) . "];\n";
  $lp2_data .= "var lp2 = new RGraph.Line('lp2',";
  $lp2_data .= join(',',map {'ddata' . $_} (0..1)) . ");\n";
  $panel .= div({style=>'clear:both;'},NBSP)
            . h4('Disk usage figures are for assay data only') . (br)x2
            . div({style => 'float: left; padding-right: 15px;'},
                  "<canvas id='lp2' width=500 height=300>[No canvas support]</canvas>");
  my $pc = &round5($ar->[-1][1]/1024)*$PRIMARY_COST;
  my $ac = &round5($ar->[-1][2]/1024)*$ARCHIVE_COST;
  my $tc = '$' . &commify($pc+$ac) . '/month';
  $pc = '$' . &commify($pc) . '/month';
  $ac = '$' . &commify($ac) . '/month';
  $panel .= div({style => 'float: left; padding-right: 15px;'},(br)x4,
                table({class => 'tablesorter',&identify('table7')},
                      Tr({colspan => 3},th('Disk usage as of ',$ar->[-1][0])),
                      Tr(td(['Primary',(sprintf '%.2fTB',$ar->[-1][1]/1024),$pc])),
                      Tr(td(['Archive',(sprintf '%.2fTB',$ar->[-1][2]/1024),$ac])),
                      Tr(td(['TOTAL',(sprintf '%.2fTB',($ar->[-1][1]+$ar->[-1][2])/1024),$tc]))),
               );

  # Disk usage (detailed)
  $sth{DUD}->execute();
  $ar = $sth{DUD}->fetchall_arrayref();
  my %assay; # {date}{assay}(primary,secondary)
  foreach (@$ar) {
    $assay{$_->[0]}{$_->[1]} = [($_->[2]||0),($_->[3]||0)];
  }
  # Disk usage (detailed primary)
  @data = ();
  $a = 0;
  foreach my $assay (@ASSAY) {
    $data[$a] = sprintf 'var d2data%d = [',$a;
    foreach my $d (sort keys %assay) {
      $data[$a] .= (($assay{$d}{$assay}[0]||0)/1024 || 0) . ',';
    }
    $data[$a] =~ s/,$//;
    $data[$a++] .= '];';
  }
  $max = $#data;
  $lp3_data .= $data[$_] . "\n" foreach (0..$max);
  $lp3_data .= 'var d2labels = [';
  $lp3_data .= join(',',sort keys %assay) . "];\n";
  $lp3_data .= "var lp3 = new RGraph.Line('lp3',";
  $lp3_data .= join(',',map {'d2data' . $_} (0..$max)) . ");\n";
  $panel .= div({style => 'float: left; padding-right: 15px;'},
                "<canvas id='lp3' width=500 height=300>[No canvas support]</canvas>");
  }

  # Chart JavaScript
  my $bar_config = qq~
vp.Set('chart.height',60);
vp.Set('chart.width',710);
vp.Set('chart.gutter',20);
vp.Set('chart.margin',0);
vp.Set('chart.tooltips.effect','fade');
vp.Set('chart.numticks',0);
~;
  my $chart = qq~
<script type="text/javascript">
var pfdetail = 0;
var edetail = 1;
\$(document).ready(function() {
  \$(".pfdel").hide();
  \$(".edet").hide();
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
$lp_data
lp.Set('chart.title', 'Experiments by year/month');
lp.Set('chart.key', ['Aggression','Box','Climbing','Fly bowl','Gap','Observation','Sterility']);
lp.Set('chart.labels',elabels);
lp.Set('chart.title.yaxis','Count');
lp.Set('chart.title.xaxis','Date');
lp.Set('chart.key.halign','left');
lp.Set('chart.text.angle',45);
lp.Set('chart.background.barcolor1','white');
lp.Set('chart.background.barcolor2','white');
lp.Set('chart.filled',false);
lp.Set('chart.filled.range',false);
lp.Set('chart.fillstyle','rgba(128,255,128,0.5)');
lp.Set('chart.linewidth',2);
lp.Set('chart.text.size',7);
lp.Set('chart.gutter',55);
lp.Set('chart.colors', ['$COLOR{aggression}','$COLOR{box}','$COLOR{climbing}','$COLOR{fly_bowl}','$COLOR{gap}','$COLOR{observation}','$COLOR{sterility}']);
lp.Set('chart.hmargin', 5); 
lp.Draw();
$lp2_data
lp2.Set('chart.title', 'Disk usage by date');
lp2.Set('chart.key', ['Primary','Archive']);
lp2.Set('chart.labels',dlabels);
lp2.Set('chart.title.yaxis','Usage (TB)');
lp2.Set('chart.title.xaxis','Date');
lp2.Set('chart.key.halign','left');
lp2.Set('chart.text.angle',45);
lp2.Set('chart.background.barcolor1','white');
lp2.Set('chart.background.barcolor2','white');
lp2.Set('chart.filled',false);
lp2.Set('chart.filled.range',false);
lp2.Set('chart.fillstyle','rgba(128,255,128,0.5)');
lp2.Set('chart.linewidth',2);
lp2.Set('chart.text.size',7);
lp2.Set('chart.gutter',55);
lp2.Set('chart.colors', ['darkblue','darkred']);
lp2.Set('chart.hmargin', 5); 
lp2.Draw();
$lp3_data
lp3.Set('chart.title', 'Disk usage (primary) by assay/date');
lp3.Set('chart.key', ['Aggression','Box','Climbing','Fly bowl','Gap','Observation','Sterility']);
lp3.Set('chart.labels',d2labels);
lp3.Set('chart.title.yaxis','Usage (TB)');
lp3.Set('chart.title.xaxis','Date');
lp3.Set('chart.key.halign','left');
lp3.Set('chart.text.angle',45);
lp3.Set('chart.background.barcolor1','white');
lp3.Set('chart.background.barcolor2','white');
lp3.Set('chart.filled',false);
lp3.Set('chart.filled.range',false);
lp3.Set('chart.fillstyle','rgba(128,255,128,0.5)');
lp3.Set('chart.linewidth',2);
lp3.Set('chart.text.size',7);
lp3.Set('chart.gutter',55);
lp3.Set('chart.colors', ['$COLOR{aggression}','$COLOR{box}','$COLOR{climbing}','$COLOR{fly_bowl}','$COLOR{gap}','$COLOR{observation}','$COLOR{sterility}']);
lp3.Set('chart.hmargin', 5); 
lp3.Draw();
~;
  foreach (keys %hb) {
    $chart .= "var hb = new RGraph.HProgress('ahb" . $_ . "',$hb{$_}{adata});";
    $chart .= "hb.Set('chart.tooltips',$hb{$_}{att});";
  $chart .= qq~
hb.Set('chart.colors',['green','red','slategray']);
hb.Set('chart.numticks',0);
hb.Set('chart.gutter',0);
hb.Draw();
~;
    $chart .= "var hb = new RGraph.HProgress('mhb" . $_ . "',$hb{$_}{mdata});";
    $chart .= "hb.Set('chart.tooltips',$hb{$_}{mtt});";
  $chart .= qq~
hb.Set('chart.colors',['green','red','slategray']);
hb.Set('chart.numticks',0);
hb.Set('chart.gutter',0);
hb.Draw();
~;
  }
  $chart .= qq~
};
</script>
~;
  print $chart,div({align => 'center'},$panel);

  # ----- Footer -----
  print div({style => 'clear: both;'},NBSP),end_form,
        &sessionFooter($Session),end_html;
}


sub round5
{
  return((sprintf '%d',($_[0]*2)+.5)/2);
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
                         RGraph/RGraph.line
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
