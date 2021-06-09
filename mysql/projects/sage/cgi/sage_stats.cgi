#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;
use DBI;

use JFRC::Utils::Web qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant NBSP => '&nbsp;';
use constant USER => 'sageRead';
my $DB = 'dbi:mysql:dbname=sage;host=';
my $DBL = 'dbi:mysql:dbname=sage;host=larval-sage-db';

# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE Dashboard';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $SAGE_ONLY = 0;
my $DATABASE;
my %sth = (
DL => 'SELECT name,lab_display_name,genotype,robot_id,flycore_id FROM '
      . 'line_vw WHERE name IN (SELECT name FROM (SELECT name,COUNT(1) AS c '
      . 'FROM line GROUP BY 1 HAVING c>1) x) ORDER BY 1,2',
LA => "SELECT lab,assay,experiment_count,session_count FROM lab_assay_stat_mv WHERE assay NOT LIKE 'disk_%'",
PRIMARY => 'SELECT getCVTermDisplayName(c.object_id),definition,line_count,image_count FROM primary_image_stat_mv p JOIN cv_term_relationship_vw c ON (c.subject=p.family)',
SECONDARY => 'SELECT definition,image_count FROM secondary_image_stat_mv',
SNE => 'SELECT cv,COUNT(1) FROM session_vw WHERE experiment_id IS NULL '
       . 'GROUP BY 1',
VOLUME => 'SELECT getCVTermDisplayName(c.object_id),SUM(volume) FROM '
          . 'primary_image_volume_stat_mv p JOIN cv_term_relationship_vw c '
          . 'ON (c.subject=p.family) GROUP BY 1',
);
my %sthl = (
LA => 'SELECT lab,assay,SUM(experiment_count),SUM(session_count) FROM '
      . 'lab_assay_stat_mv',
PRIMARY => 'SELECT getCVTermDisplayName(c.object_id),definition,line_count,image_count FROM primary_image_stat_mv p JOIN cv_term_relationship_vw c ON (c.subject=p.family)',
VOLUME => 'SELECT getCVTermDisplayName(c.object_id),SUM(volume) FROM '
          . 'primary_image_volume_stat_mv p JOIN cv_term_relationship_vw c '
          . 'ON (c.subject=p.family COLLATE latin1_swedish_ci) GROUP BY 1',
);

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Session authentication
my $Session = &establishSession(css_prefix => $PROGRAM);
&sessionLogout($Session) if (param('logout'));

# Connect to database
$SAGE_ONLY = param('_sageonly');
$DATABASE = lc(param('_database') || 'prod');
$DB .= ($DATABASE eq 'prod') ? 'mysql3' : 'db-dev';
my $dbh = DBI->connect($DB,(USER)x2,{RaiseError=>1,PrintError=>0});
$sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
  foreach (keys %sth);
my $dbhl = DBI->connect($DBL,(USER)x2,{RaiseError=>1,PrintError=>0});
$sthl{$_} = $dbhl->prepare($sthl{$_}) || &terminateProgram($dbhl->errstr)
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

  # Duplicate lines
  $sth{DL}->execute();
  my $ar = $sth{DL}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      h3('Duplicate lines'),
      table({class => 'tablesorter',&identify('table1')},
            thead(Tr(th(['Line','Lab','Genotype','Robot ID','Fly Core ID']))),
            tbody(map { Tr(td([@$_])) } @$ar)))
         . div({style=>'clear:both;'},NBSP);

  # Experiments/sessions by lab/assay
  $sth{LA}->execute();
  $ar = $sth{LA}->fetchall_arrayref();
  unless ($SAGE_ONLY) {
    $sthl{LA}->execute();
    my $arl = $sthl{LA}->fetchall_arrayref();
    push @$ar,@$arl;
  }
  my ($te,$ts) = (0)x3;
  my (%estat,%stat);
  foreach (@$ar) {
    $te += $_->[2];
    $ts += $_->[3];
    $stat{$_->[0]} += $_->[3];
    ($a = $_->[1]) =~ s/fly_olympiad_//;
    $estat{$a} += $_->[2] if ($_->[0] eq 'Fly Olympiad');
  }
  my (@pie_data,@pie_label);
  foreach (sort {$stat{$b} <=> $stat{$a}} keys %stat) {
    if ($stat{$_}/$ts < .01) {
      $stat{Other} += $stat{$_};
      delete $stat{$_};
      next;
    }
    push @pie_data,$stat{$_};
    push @pie_label,'"' . $_
                    . sprintf ' %.2f%%"',$stat{$_}/$ts*100;
  }
  push @pie_data,$stat{Other};
  push @pie_label,'"Other'
                  . sprintf ' %.2f%%"',$stat{Other}/$ts*100;
  my $pie_data = '[' . join(',',map {$_} @pie_data) . ']';
  my $pie_label = '[' . join(',',map {$_} @pie_label) . ']';
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      h3('Experiments/sessions by lab/assay'),
      table({class => 'tablesorter',&identify('table2')},
            thead(Tr(th(['Lab','Assay','Experiments','Sessions']))),
            tbody(map { Tr(td([@$_])) } @$ar),
            tfoot(Tr(td([span({style => 'font-weight: bold;'},
                             'TOTAL'),NBSP,$te,$ts])))))
         . div({style => 'float: left; padding-right: 15px;'},
            "<canvas id='pie' width=500 height=500>[No canvas support]</canvas>")
         . div({style=>'clear:both;'},NBSP);

  # Imagery
  $sth{PRIMARY}->execute();
  $ar = $sth{PRIMARY}->fetchall_arrayref();
  my %ih;
  $ts = 0;
  # -------------------------------------------------------------------------
  # Get Simpson and Rubin stuff from Nighthawk
my %REMAP = ('rubix-chacrm' => 'Rubin Lab ChaCRM', #DELETE ME
  GAL4 => 'Simpson Lab GAL4',
  'GAL4-larvae' => 'Simpson Lab GAL4 Larval',
  'immunohistochemistry-optimizing' => 'Simpson Lab Immunohistochemistry Optimizing',
  'simpson-lab' => 'Simpson Lab General');
$REMAP{$_} = span({style => 'color: #c66;'},$REMAP{$_}) foreach (keys %REMAP);
  my $hr = $dbhn->selectall_hashref("SELECT family,COUNT(DISTINCT line) AS line_count,COUNT(1) AS image_count FROM image_property_mv WHERE family IN ('GAL4','GAL4-larvae','immunohistochemistry-optimizing','simpson-lab') GROUP BY 1",'family');
  push @$ar,[(/rubin/ ? 'Rubin Lab' : 'Simpson Lab'),$REMAP{$_},
             $hr->{$_}{line_count},$hr->{$_}{image_count}] foreach (keys %$hr);
  # Get Larval stuff
  unless ($SAGE_ONLY) {
    $sthl{PRIMARY}->execute();
    my $arl = $sthl{PRIMARY}->fetchall_arrayref();
    push @$ar,@$arl;
  }
  # -------------------------------------------------------------------------
  # Primary image count pie chart
  foreach (@$ar) {
    $ih{shift @$_} += $_->[-1];
    $ts += $_->[-1];
  }
  @pie_data = @pie_label = ();
  foreach (sort {$ih{$b} <=> $ih{$a}} keys %ih) {
    if ($ih{$_}/$ts < .05) {
      $ih{Other} += $ih{$_};
      delete $ih{$_};
      next;
    }
    push @pie_data,$ih{$_};
    push @pie_label,'"' . $_
                    . sprintf ' %.2f%%"',$ih{$_}/$ts*100;
  }
  if (exists $ih{Other}) {
    push @pie_data,$ih{Other};
    push @pie_label,sprintf '"Other %.2f%%"',$ih{Other}/$ts*100;
  }
  my $pie_data2 = '[' . join(',',map {$_} @pie_data) . ']';
  my $pie_label2 = '[' . join(',',map {$_} @pie_label) . ']';
  # Add secondary image count
  %stat = map { $_->[0] => [$_->[1],$_->[2]] } @$ar;
  $sth{SECONDARY}->execute();
  $ar = $sth{SECONDARY}->fetchall_arrayref();
  (exists $stat{$_->[0]}) || ($stat{$_->[0]} = [0,0]) foreach (@$ar);
  $stat{$_->[0]} = [@{$stat{$_->[0]}},$_->[1]] foreach (@$ar);
  # -------------------------------------------------------------------------
  # Get Simpson and Rubin stuff from Nighthawk
  $hr = $dbhn->selectall_hashref("SELECT family,COUNT(1) AS image_count FROM image i JOIN secondary_image s ON (i.id=s.image_id) WHERE family IN ('GAL4','GAL4-larvae','immunohistochemistry-optimizing','simpson-lab') GROUP BY 1",'family');
  push @{$stat{$REMAP{$_}}},$hr->{$_}{image_count} foreach (keys %$hr);
  # -------------------------------------------------------------------------
  @$ar = ();
  my @total = (0)x3;
  foreach (sort keys %stat) {
    my @arr = @{$stat{$_}};
    push @arr,0 if (2 == scalar(@arr));
    push @$ar,[$_,@arr];
    $total[$_] += $arr[$_] foreach (0..2);
  }
  # Primary image volume pie chart
  $sth{VOLUME}->execute;
  my $ar2 = $sth{VOLUME}->fetchall_arrayref();
  $ts = 0;
  %stat = ();
  # -------------------------------------------------------------------------
  # Get Simpson and Rubin volumes from Nighthawk
  $hr = $dbhn->selectall_hashref("SELECT LEFT(family,5) AS family,SUM(file_size) AS volume FROM image_property_mv WHERE family IN ('GAL4','GAL4-larvae','immunohistochemistry-optimizing','simpson-lab') GROUP BY 1",'family');
  $stat{(/rubin/ ? 'Rubin Lab' : 'Simpson Lab')} += $hr->{$_}{volume}
    foreach (keys %$hr);
  unless ($SAGE_ONLY) {
    $sthl{VOLUME}->execute();
    my $arl = $sthl{VOLUME}->fetchall_arrayref();
    push @$ar2,@$arl;
  }
  # -------------------------------------------------------------------------
  foreach (@$ar2) {
    if ($_->[1] < 2e12) {
      $stat{Other} += $_->[1];
    }
    else {
      $stat{$_->[0]} += $_->[1];
      $ts += $_->[1];
    }
  }
  $ts += $stat{Other};
  @pie_data = ();
  @pie_label = ();
  foreach (sort {$stat{$b} <=> $stat{$a}} keys %stat) {
    push @pie_data,$stat{$_};
    push @pie_label,'"' . $_
                    . sprintf ' %dTB"',$stat{$_}/1e12;
  }
  my $pie_data3 = '[' . join(',',map {$_} @pie_data) . ']';
  my $pie_label3 = '[' . join(',',map {$_} @pie_label) . ']';

  $total[0] = NBSP;
  my @x = sort { (my $aa = $a->[0]) =~ s/.+?>//;
                 (my $bb = $b->[0]) =~ s/.+?>//;
                 $aa cmp $bb} @$ar;
  $panel .= div({style => 'float: left; padding-right: 15px;'},
      h3('Imagery by family'),
      div(table({class => 'tablesorter',&identify('table2')},
                thead(Tr(th(['Family','Lines','Primary','Secondary']))),
                tbody(map { Tr(td([$_->[0],$_->[1],$_->[2],$_->[3]])) } @x),
                tfoot(Tr(td([span({style => 'font-weight: bold;'},
                                 'TOTAL'),@total]))))),
          'NOTE: Image families in ',span({style => 'color: #c66'},'red'),
          ' are awaiting migration to SAGE'
      )
      . div({style => 'float: left; padding-right: 15px;'},
            "<canvas id='pie2' width=550 height=500>[No canvas support]</canvas>")
      . div({style => 'float: left; padding-right: 15px;'},
            "<canvas id='pie3' width=550 height=500>[No canvas support]</canvas>");

  # Pie chart JavaScript
  my $config = qq~
pie.Set('chart.colors',[getGradient(pie,'#d33'),getGradient(pie,'#3d3'),getGradient(pie,'#33d'),getGradient(pie,'#d3d'),getGradient(pie,'#3dd'),getGradient(pie,'#dd3')]);
pie.Set('chart.variant','donut');
pie.Set('chart.text.size',10);
pie.Set('chart.highlight.style','3d');
pie.Set('chart.linewidth',0);
pie.Set('chart.gutter',150);
pie.Set('chart.strokestyle','white');
~;
  my $pie = qq~
<script type="text/javascript">
function getGradient(obj, color) {
  var gradient = obj.context.createRadialGradient(obj.canvas.width/2, obj.canvas.height/2,0,obj.canvas.width/2,obj.canvas.height/2,200);
  gradient.addColorStop(0,'black');
  gradient.addColorStop(0.5,color);
  gradient.addColorStop(1,'black');
  return RGraph.isIE8() ? color : gradient;
}
function createCharts () {
var pie = new RGraph.Pie('pie',$pie_data);
pie.Set('chart.labels',$pie_label);
pie.Set('chart.title',"Sessions by project/lab");
$config
pie.Draw();
pie = new RGraph.Pie('pie2',$pie_data2);
pie.Set('chart.labels',$pie_label2);
pie.Set('chart.title',"Primary images by project/lab");
$config
pie.Draw();
pie = new RGraph.Pie('pie3',$pie_data3);
pie.Set('chart.labels',$pie_label3);
pie.Set('chart.title',"Primary image data volume by project/lab");
$config
pie.Draw();
};
</script>
~;
  print $pie,div({align => 'center'},$panel);

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
                         RGraph/RGraph.pie
                         RGraph/RGraph.vprogress
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
