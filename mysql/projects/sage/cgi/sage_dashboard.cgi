#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;
use DBI;
use GD::Graph::area;
use MIME::Base64::Perl;
use HTTP::Date;
use HTTP::Date qw(time2iso time2isoz str2time);
use POSIX qw(ceil);

use JFRC::Utils::Web qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant NBSP => '&nbsp;';
use constant USER => 'sageRead';
my $DB = 'dbi:mysql:dbname=sage;host=';

# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE Dashboard';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $DATABASE;
my %sth = (
ATTENUATOR => 'SELECT wavelength,MIN(CAST(LEFT(transmission,'
              . 'CHAR_LENGTH(transmission)-1) AS DECIMAL(5,2))),'
              . 'MAX(CAST(LEFT(transmission,CHAR_LENGTH(transmission)-1) '
              . 'AS DECIMAL(5,2))) FROM attenuator GROUP BY 1',
CV => 'SELECT cv.name,cv.version,cv.definition,COUNT(cvt.name) FROM cv,'
      . 'cv_term cvt WHERE cv.id=cvt.cv_id GROUP BY 1,3 ORDER BY 1',
DETECTOR => 'SELECT image_channel_name,color FROM detector '
            . 'GROUP BY 1,2',
EXPERIMENT => 'SELECT lab,type,cvt.definition,experimenter,COUNT(3) FROM '
              . 'experiment_vw,cv,cv_term cvt WHERE cv=cv.name AND '
              . 'type=cvt.name AND cv.id=cvt.cv_id GROUP BY 1,2,3,4',
GROWTH => 'SELECT CONCAT(DATE(DATE_SUB(capture_date,INTERVAL '
          . "WEEKDAY(capture_date) DAY)),' - ',DATE(DATE_ADD(capture_date,"
          . 'INTERVAL 6-WEEKDAY(capture_date) DAY))),COUNT(1) FROM '
          . "image_vw WHERE source='JFRC' AND capture_date IS NOT NULL GROUP BY 1",
IMAGEP => 'SELECT i.cv,type,definition,COUNT(2) FROM image_property_vw i '
          . 'JOIN cv_term_vw cvt ON (i.type=cvt.cv_term AND i.cv=cvt.cv) '
          . 'GROUP BY 1,2,3',
LASER => 'SELECT name,power FROM laser GROUP by 1,2',
LINE => 'SELECT lab,COUNT(1) FROM line_vw GROUP BY 1',
LINESESS => 'SELECT cv session_type,lab,COUNT(DISTINCT line) FROM session_vw '
            . 'GROUP BY 1,2',
OBJECTIVE => 'SELECT DISTINCT(value),COUNT(1) FROM image_property WHERE '
             . "type_id=(SELECT id FROM cv_term_vw WHERE cv='light_imagery' "
             . "AND cv_term='objective') AND value IS NOT NULL GROUP BY 1",
PHASE => 'SELECT cv,type,cvt.definition,COUNT(2) FROM '
         . 'phase_vw,cv,cv_term cvt WHERE cv=cv.name AND type=cvt.name AND '
         . 'cv.id=cvt.cv_id GROUP BY 1,2',
PRIMARY => 'SELECT definition,COUNT(DISTINCT line_id),COUNT(1) FROM image i '
           . 'JOIN cv_term c ON (i.family_id=c.id) GROUP BY 1',
PRODUCT => 'SELECT product,COUNT(1) FROM image i,secondary_image_vw s WHERE '
             . 'i.id=s.image_id GROUP BY 1 ORDER BY 1',
SECONDARY => 'SELECT definition,COUNT(1) FROM image_vw i JOIN '
             . 'secondary_image s ON (s.image_id=i.id) JOIN cv_term_vw ctv ON '
             . '(i.family=ctv.cv_term) GROUP BY 1',
SESSION => 'SELECT lab,cv,type,cvt.definition,annotator,COUNT(3) FROM '
           . 'session_vw,cv,cv_term cvt WHERE cv=cv.name AND type=cvt.name AND '
           . 'cv.id=cvt.cv_id GROUP BY 1,2,3',
SESSIONO => 'SELECT s.cv,s.type,cvt.definition,o.type,cvt2.definition,COUNT(5) '
            . 'FROM session_vw s JOIN observation_vw o ON (s.id=o.session_id) '
            . 'JOIN cv_term_vw cvt ON (s.type=cvt.cv_term AND s.cv=cvt.cv) '
            . 'JOIN cv_term_vw cvt2 on (o.type=cvt2.cv_term AND o.cv=cvt2.cv) '
            . 'GROUP BY 1,2,3,4,5',
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

# Main processing
&showDashboard();

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
# * Subroutine:  showDashboard                                               *
# * Description: This routine will show the dashboard.                       *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub showDashboard
{
sub inputTabTitle { ($a = shift) =~ s/_/ /g; $a; }

my @SEARCH = qw(Line Imagery Annotation Zeiss);

  # ----- Page header -----
  print &pageHead(),start_form,&hiddenParameters();
  print table(Tr(td('Display: '),
                 td(radio_group(&identify('report'),
                                -values    => \@SEARCH,
                                -default   => $SEARCH[1],
                                -linebreak => 'true',
                                -onChange  => 'toggleDisplay()')))),hr;
  my $panel = '';

  # Line
  $sth{LINE}->execute();
  my $ar = $sth{LINE}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Lines by lab'),
        table({class => 'sortable',&identify('standard')},
              Tr(th(['Lab','Lines'])),
              map { Tr(td($_)) } @$ar));
  $sth{LINESESS}->execute();
  $ar = $sth{LINESESS}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Lines by session type'),
        table({class => 'sortable',&identify('standard')},
              Tr(th(['Type','Lab','Lines'])),
              map { Tr(td($_)) } @$ar));
  print div({id    => shift @SEARCH,
             align => 'center',
             style => 'display:none;'},$panel);
  $panel = '';

  # Imagery
  # Primary & secondary
if (0) {
  $sth{PRIMARY}->execute();
  $ar = $sth{PRIMARY}->fetchall_arrayref();
  my %hash = map { $_->[0] => [$_->[1],$_->[2]] } @$ar;
  $sth{SECONDARY}->execute();
  $ar = $sth{SECONDARY}->fetchall_arrayref();
  $hash{$_->[0]} = [@{$hash{$_->[0]}},$_->[1]] foreach (@$ar);
  @$ar = ();
  my @total = (0,0);
  foreach (sort keys %hash) {
    my @arr = @{$hash{$_}};
    push @arr,0 if (2 == scalar(@arr));
    push @$ar,[$_,@arr];
    $total[$_] += $arr[$_] foreach (0..2);
  }
  push @$ar,[map {span({style => 'font-weight:bold;'},$_)} ('TOTAL',@total)];
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Images by family'),
        table({class => 'sortable',&identify('standard')},
              Tr(th(['Family','Lines','Primary images','Secondary images'])),
              map { Tr(td($_)) } @$ar));
  my $e = 10**(length($total[1]) - 1);
  my $round = int($total[1]/$e+0.5) * (10**(length($total[1]) - 1));
  # Product count
  $sth{PRODUCT}->execute();
  $ar = $sth{PRODUCT}->fetchall_arrayref();
  $panel .= div({style => 'float: left;'},
        h3('Secondary images by product'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([qw(Product Count)])),
              map { Tr(td($_)) } @$ar));
  $panel .= div({style => 'clear: both;'},NBSP);
  # Image properties
  $sth{IMAGEP}->execute();
  $ar = $sth{IMAGEP}->fetchall_arrayref();
  $panel .= div({style => 'float: left;'},
        h3('Image properties'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([qw(CV Type Definition Count)])),
              map { Tr(td($_)) } @$ar));
  $panel .= div({style => 'clear: both;'},NBSP);
  # Growth graph
  $sth{GROWTH}->execute();
  $ar = $sth{GROWTH}->fetchall_arrayref();
  shift @$ar unless ($ar->[0][0]);
  $ar->[$_][1] += $ar->[$_-1][1] foreach (1..$#$ar);
  my $year = 0;
  my @arr;
  my $flotr_data = '';
  foreach (@$ar) {
    (my $yy = $_->[0]) =~ s/.+ //;
    $yy =~ s/-.+//;
    my ($start_date,$end_date) = split (/\s\-\s/,$_->[0]);
    my $timestamp = str2time($end_date);
    my $js_timestamp = $timestamp * 1000;
    $flotr_data .= "[$js_timestamp,$_->[1]],";
    $_->[0] = ($yy == $year) ? '' : ($year = $yy);
    push @{$arr[0]},$_->[0];
    push @{$arr[1]},$_->[1];
  }
  $flotr_data =~ s/\,$//;
  $panel .= qq~
<!--[if IE]><script language="javascript" type="text/javascript" src="/js/flotr/lib/excanvas.js"></script><![endif]-->
  ~;
  $panel .= div({id    => 'jfrc_imagery_graph',
                 style => 'width:800px;height:500px;'},'');
  $panel .= 'Mouseover data to view datapoints, click and drag window to zoom '
            . 'or ' . button({-id=>'reset-btn',-label=>'Click to reset graph'});
  $panel .= qq~ 
  <script type="text/javascript">
  zoom_graph('jfrc_imagery_graph',
  { series:[ {data:[ $flotr_data ],lines:{show:true,fill:true}, color: '#00A8F0' } ], 
  	options:{
      xaxis:{
	   mode:'time', 
	   labelsAngle:45,
	   noTicks: 20,
	   title: 'Year'
	  },
	  yaxis:{
 	   max: $round,
 	   min: 0,
 	   title: 'Primary Images'
	  },
	  selection: {
	   mode: 'xy'
	  },
	  mouse:{
	   track:true,
	   trackDecimals: 0,
	   relative: true,
	   position: 'ne',
	   trackFormatter: function(obj){ return 'Date: ' + show_date(obj.x) +', Images: ' + obj.y; }
	  },
	  title: 'JFRC-Generated Imagery',
	  HtmlText: false
  }});
  
  </script>
  ~;
}
  print div({id    => shift @SEARCH,
             align => 'center',
             style => 'display:block;'},$panel);
  $panel = '';

  # Annotation
  # Experiment
  $sth{EXPERIMENT}->execute();
  $ar = $sth{EXPERIMENT}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Experiments'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([qw(Lab Type Definition Experimenter Count)])),
              map { Tr(td($_)) } @$ar));
  # Phase
  $sth{PHASE}->execute();
  $ar = $sth{PHASE}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Phases'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([qw(CV Type Definition Count)])),
              map { Tr(td($_)) } @$ar));
  # Session
  $sth{SESSION}->execute();
  $ar = $sth{SESSION}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Sessions'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([qw(Lab CV Type Definition Annotator Count)])),
              map { Tr(td($_)) } @$ar));
if (0) {
  # Session/observations
  $sth{SESSIONO}->execute();
  $ar = $sth{SESSIONO}->fetchall_arrayref();
  $panel .= div({style => 'float: left;'},
        h3('Session/Observations'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([('CV','Session type','Session definition','Observation',
                      'Observation definition','Count')])),
              map { Tr(td($_)) } @$ar));
  $panel .= div({style => 'clear: both;'},NBSP);
}

  print div({id    => shift @SEARCH,
             align => 'center',
             style => 'display:none;'},$panel);
  $panel = '';

  # Zeiss
  $sth{LASER}->execute();
  $ar = $sth{LASER}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Lasers'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([qw(Laser Power)])),
              map { Tr(td($_)) } @$ar));
if (0) {
  $sth{DETECTOR}->execute();
  $ar = $sth{DETECTOR}->fetchall_arrayref();
  foreach (@$ar) {
    $_->[1] = span({title=>$_->[1]},
                   div({style=>'float:left;height:20px;width:20px;'
                               . 'background-color:'.$_->[1].';'},NBSP)
                   . NBSP . $_->[1]);
  }
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Detectors'),
        table({class => 'sortable',&identify('standard')},
              Tr(th(['Channel name','Color'])),
              map { Tr(td($_)) } @$ar));
  $sth{ATTENUATOR}->execute();
  $ar = $sth{ATTENUATOR}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Attenuators'),
        table({class => 'sortable',&identify('standard')},
              Tr(th(['Wavelength','Min transmission','Max transmission'])),
              map { Tr(td($_)) } @$ar));
  $panel .= div({style => 'clear: both;'},NBSP);
  $sth{OBJECTIVE}->execute();
  $ar = $sth{OBJECTIVE}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Objectives'),
        table({class => 'sortable',&identify('standard')},
              Tr(th([qw(Objective Count)])),
              map { Tr(td($_)) } @$ar));
}
  print div({id    => shift @SEARCH,
             align => 'center',
             style => 'display:none;'},$panel);

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
  if ($arg{mode} eq 'initial') {
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                      qw(prototype flotr/lib/canvas2image
                         flotr/lib/canvastext flotr/flotr
                         flotr/flotr_zoom_graph sorttable),$PROGRAM;
  }
  $arg{title} .= ' (Development)' if ($DATABASE eq 'dev');
  &pageHeader(title      => $arg{title},
              css_prefix => $PROGRAM,
              script     => \@scripts,
              expires    => 'now');
}
