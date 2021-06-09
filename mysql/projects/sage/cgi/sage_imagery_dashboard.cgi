#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;
use Date::Manip qw(DateCalc ParseDate UnixDate);
use DBI;
use POSIX qw(ceil);
use JFRC::Utils::Web qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant NBSP => '&nbsp;';
use constant USER => 'sageRead';
my $DB = 'dbi:mysql:dbname=sage;host=';
my $WSDB = 'dbi:mysql:dbname=flyportal;host=prd-db';

# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE Imagery Dashboard';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $DATABASE;
my %sth = (
CAPTURED => 'SELECT family,MAX(capture_date),COUNT(2),COUNT(DISTINCT line) FROM '
            . 'image_data_mv GROUP BY 1',
IMAGE => "SELECT family,driver,age,imaging_project,reporter,data_set,count "
         . "FROM image_classification_mv WHERE family NOT LIKE 'fly_olympiad%' "
         . "AND family NOT LIKE '%external' AND family NOT IN "
         . "('baker_biorad','simpson_lab_grooming')",
CROSS => 'SELECT family,project_lab,cross_type,COUNT(3),COUNT(DISTINCT i.line) FROM '
         . 'image_data_mv i JOIN cross_event_vw cev ON '
         . '(i.cross_barcode=cev.cross_barcode COLLATE latin1_general_cs) '
         . 'GROUP BY 1,2,3',
THIS_WEEK => 'SELECT family,COUNT(1) FROM image_vw WHERE capture_date BETWEEN '
          . '? AND ? GROUP BY 1',
RUNNING => "SELECT DATE_FORMAT(capture_date,'%Y%u'),COUNT(1),COUNT(DISTINCT line) FROM "
           . 'image_vw WHERE capture_date IS NOT NULL AND family NOT LIKE '
           . "'fly_olympiad%' AND family NOT LIKE '%external' AND family NOT IN "
           . "('baker_biorad','simpson_lab_grooming') GROUP BY 1",
MONTH => "SELECT DATE_FORMAT(capture_date,'%Y%m'),family,COUNT(2),COUNT(DISTINCT line) FROM "
         . 'image_vw WHERE capture_date IS NOT NULL AND family NOT LIKE '
         . "'fly_olympiad%' AND family NOT LIKE '%external' AND family NOT IN "
         . "('baker_biorad','simpson_lab_grooming') AND "
         . "DATE_FORMAT(capture_date,'%Y%m') BETWEEN ? AND ? GROUP BY 1,2",
);
my %sthw = (
DATASET => 'SELECT ed.value,e.name,ed.owner_key FROM entityData ed '
           . 'JOIN entity e ON (e.id=ed.parent_entity_id AND entity_type_id='
           . "(SELECT id FROM entityType WHERE name='Data Set')) "
           . 'JOIN entityAttribute ea ON (ea.id=ed.entity_att_id AND '
           . "ea.name='Data Set Identifier') order by 1",
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
my $dbhw = DBI->connect($WSDB,('flyportalRead')x2,{RaiseError=>1,PrintError=>0});
$sthw{$_} = $dbhw->prepare($sthw{$_}) || &terminateProgram($dbhw->errstr)
  foreach (keys %sthw);

# Main processing
if (param('mode') eq 'rate') {
  &showRateDashboard();
}
else {
  &showStandardDashboard();
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
# * Subroutine:  showStandardDashboard                                       *
# * Description: This routine will show the standard dashboard.              *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub showStandardDashboard
{
  # ----- Page header -----
  print &pageHead(),start_form,&hiddenParameters();
  my %panel;
  my $ar;

  # Imagery on workstation
  $sthw{DATASET}->execute();
  $ar = $sthw{DATASET}->fetchall_arrayref();
  my %ws_map;
  foreach (@$ar) {
    $ws_map{$_->[0]}{name} = $_->[1];
    $ws_map{$_->[0]}{owner} = $_->[2];
  }

  # Imagery by family
  $sth{CAPTURED}->execute();
  $ar = $sth{CAPTURED}->fetchall_arrayref();
  $panel{captured} =
        h3('Imagery by family')
        . table({class => 'sortable',&identify('standard')},
                Tr(th(['Family','Last capture','Count','Line count'])),
                map { Tr(td($_)) } @$ar);
  $panel{captured_pie} = &pieChart($ar);

  # Imagery by cross
  $sth{CROSS}->execute();
  $ar = $sth{CROSS}->fetchall_arrayref();
  $panel{crosses} =
        h3('Imagery by cross')
        . table({class => 'sortable',&identify('standard')},
                Tr(th(['Family','Lab','Cross type','Count','Line count'])),
                map { Tr(td($_)) } @$ar);

  # Weekly imagery production
#  my $today = UnixDate("today","%Y%m%d");
#  my $cw_start = UnixDate(DateCalc($today,'previous monday'),"%Y%m%d");
#  my $cw_stop = UnixDate(DateCalc($cw_start,'+ 6 days'),"%Y%m%d");
#  $sth{THIS_WEEK}->execute($cw_start,$cw_stop);
#  $ar = $sth{THIS_WEEK}->fetchall_arrayref();
#  $panel{weekly} =
#        h3('Imagery for current week'),
#        table({class => 'sortable',&identify('standard')},
#              Tr(th(['Family','Count'])),
#              map { Tr(td($_)) } @$ar);

  # Imagery by dataset
  $sth{IMAGE}->execute();
  $ar = $sth{IMAGE}->fetchall_arrayref();
  foreach (@$ar) {
    splice @$_,-1,0,'';
    if (exists $ws_map{$_->[5]}) {
      ($_->[6] = $ws_map{$_->[5]}{owner}) =~ s/.+://;
      $_->[5] = span({style => 'color: #009900;'},$ws_map{$_->[5]}{name});
    }
  }
  $panel{dataset} =
        h3('Categorized confocal imagery')
        . 'Data sets in ' . span({style => 'color: green;'},'green')
        . ' are in the Janelia Workstation' . br
        . table({class => 'sortable',&identify('standard')},
                Tr(th(['Family','Driver','Age','Imaging project','Reporter','Data set','Owner','Count'])),
                map { Tr(td($_)) } @$ar);

  # Render
  print div({style => 'float: left; padding-right: 15px;'},
            $panel{captured},br,$panel{crosses}),
        div({style => 'float: left; padding-right: 15px;'},
            $panel{captured_pie}),
        div({style => 'float: left; padding-right: 15px;'},
            $panel{dataset});

  # ----- Footer -----
  print div({style => 'clear: both;'},NBSP),end_form,
        &sessionFooter($Session),end_html;
}


sub pieChart
{
  my $ar = shift;
  my @element;
  my $data;
  my @sorted = sort { $b->[-1] <=> $a->[-1] } @$ar;
  my $acc;
  foreach (@sorted) {
    next if ($_->[0] =~ /(?:^fly_olympiad|external|biorad|grooming)/);
    if (scalar(@element) <= 8) {
      push @element,"['$_->[0]',$_->[2]]";
    }
    $acc += $_->[2];
  }
  push @element,"['Other',$acc]";
  $data = "data: [\n" . join(",\n",@element) . "\n]";
  $a = <<__EOT__;
<div id="container" style="width: 600px; height: 400px; margin: 0 auto"></div>
<script type="text/javascript">
\$(function () {
  Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function(color) {
		      return {
		          radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
		          stops: [
		              [0, color],
		              [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
		          ]
		      };
		  });
        \$('#container').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Confocal imagery by family'
            },
            tooltip: {
        	    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +'</b>: '+ Highcharts.numberFormat(this.percentage,2) +' %';
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'Confocal imagery',
$data
            }]
        });
    });
</script>
__EOT__
  return($a);
}


# ****************************************************************************
# * Subroutine:  showRateDashboard                                           *
# * Description: This routine will show the rate dashboard.                  *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub showRateDashboard
{
  # ----- Page header -----
  print &pageHead(),start_form,&hiddenParameters();
  my %panel;
  my $ar;
  $sth{RUNNING}->execute();
  $ar = $sth{RUNNING}->fetchall_arrayref();
  my $line = param('line') || 0;
  my $term = ($line) ? 'lines' : 'images';
  my $column = ($line) ? 1 : 2;
  splice(@$_,$column,1) foreach (@$ar);
  $panel{weeklyrate} = &zoomChart($ar,"Confocal $term per week",$term,'weeklyrate');
  foreach (1..$#$ar) {
    $ar->[$_][-1] += $ar->[$_-1][-1];
  }
  $panel{running} = &zoomChart($ar,"Confocal $term running total",$term,'running',2);
  my $stop = param('stop') || UnixDate("today","%Y%m");
  my $start = param('start') || $stop;
  $start = param('start') || UnixDate(DateCalc($stop,'- 1 year'),"%Y%m");
  $sth{MONTH}->execute($start,$stop);
  $ar = $sth{MONTH}->fetchall_arrayref();
  $column = ($line) ? 2 : 3;
  splice(@$_,$column,1) foreach (@$ar);
  $panel{imaged_line} = &lineChart($ar,"Confocal $term per month by family",
                                   $term,$start,$stop);

  print div({style => 'float: left;'},
            $panel{running}),
        div({style => 'float: left;'},
            $panel{weeklyrate}),
        div({style => 'float: left;'},
            $panel{imaged_line});

  # ----- Footer -----
  print div({style => 'clear: both;'},NBSP),end_form,
        &sessionFooter($Session),end_html;
}


sub zoomChart
{
  my($ar,$title,$y_axis,$container,$color) = @_;
  $color ||= 0;
  my $data = '['
             . join(',',map {$_->[1]} @$ar)
             . ']';
  $a = <<__EOT__;
<div id="$container" style="width: 1000px; height: 400px; margin: 0 auto"></div>
<script type="text/javascript">
\$(function () {
        \$('#$container').highcharts({
            chart: {
                zoomType: 'x',
                spacingRight: 20
            },
            title: { text: '$title' },
            subtitle: {
                text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' :
                    'Pinch the chart to zoom in'
            },
            xAxis: {
                type: 'datetime',
                maxZoom: 7 * 24 * 3600000, // 1 week
                title: { text: null }
            },
            yAxis: {
                min: 0,
                title: { text: '# $y_axis' }
            },
            tooltip: { shared: true },
            legend: { enabled: false },
            plotOptions: {
                area: {
                    fillColor: {
                        linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1},
                        stops: [
                            [0, Highcharts.getOptions().colors[$color]],
                            [1, Highcharts.Color(Highcharts.getOptions().colors[$color]).setOpacity(0).get('rgba')]
                        ]
                    },
                    lineColor: Highcharts.getOptions().colors[$color],
                    lineWidth: 1,
                    marker: { enabled: false },
                    shadow: false,
                    states: { hover: { lineWidth: 1 } },
                    threshold: null
                }
            },
    
            series: [{
                type: 'area',
                name: 'Images',
                pointInterval: 7 * 24 * 3600000, // 1 week
                pointStart: Date.UTC(2006,11,06),
                data: $data
            }]
        });
    });
</script>
__EOT__
  return($a);
}


sub lineChart
{
  my($ar,$title,$y_axis,$start,$stop) = @_;
  my $subtitle = "($start-$stop)";
  my (%date,%date_list,%family,%series);
  foreach (@$ar) {
    $date_list{$_->[0]}++;
    $date{$_->[0]}{$_->[1]} = $_->[2];
    $family{$_->[1]}++;
  }
  my @series;
  foreach my $family (sort keys %family) {
    my @arr = ();
    foreach my $date (sort keys %date_list) {
      push @arr,$date{$date}{$family} || 0;
    }
    push @series,"{name: '$family',\ndata: ["
                 . join(',',@arr) . ']}';
  }
  my $series = 'series: [' . join(",\n",@series) . ']';
  my $categories = join(',',sort keys %date_list);
  $a = <<__EOT__;
<div id="container" style="width: 1000px; height: 400px; margin: 0 auto"></div>
<script type="text/javascript">
\$(function () {
        \$('#container').highcharts({
            title: {
                text: '$title',
                x: -20 //center
            },
            subtitle: {
                text: '$subtitle',
                x: -20 //center
            },
            xAxis: { categories: [$categories] },
            yAxis: {
                min: 0,
                title: { text: '# $y_axis' },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },$series
        });
    });
</script>
__EOT__
  return($a);
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
  if ($arg{mode} eq 'initial') {
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                      qw(jquery/jquery-latest highcharts/highcharts
                         highcharts/modules/exporting sorttable);
  }
  $arg{title} .= ' (Development)' if ($DATABASE eq 'dev');
  &pageHeader(title      => $arg{title},
              css_prefix => $PROGRAM,
              script     => \@scripts,
              expires    => 'now');
}
