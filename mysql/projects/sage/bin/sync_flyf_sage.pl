#!/usr/bin/perl

# Perl built-ins
use strict;
use warnings;
use DBI;
use Getopt::Long;
use IO::File;
use Pod::Text;
use Pod::Usage;

use JFRC::Utils::SAGE qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant USER => 'sageApp';
use constant PASS => 'h3ll0K1tty';
my $FLYF_SERVER = 'dbi:JDBC:hostname=prod1;port=9001';
my $FLYF_URL = 'jdbc:filemaker://10.40.3.26:2399/FLYF_2?user=flyf2&password=flycore';


# ****************************************************************************
# * Global variables                                                         *
# ****************************************************************************
# Command-line parameters
my($DEBUG,$DEV,$TEST,$VERBOSE) = (0)x4;
# Database
my $SAGE = 'dbi:mysql:dbname=sage;host=';
our $dbh;
my ($db,$dbhf);
# SQL statements
my %sth =(
  DELETE => 'DELETE FROM event WHERE process_id=(SELECT id FROM cv_term_vw '
            . "WHERE cv='process' AND cv_term='cross')",
  LINE_IDS => "SELECT id,name,lab FROM line_vw",
  LINE => 'SELECT id FROM line_vw WHERE name=? AND lab=?',
  LINE2 => 'SELECT id FROM line_vw WHERE name=?',
  EVENT => 'INSERT INTO event (process_id,action,operator,event_date) '
           . 'VALUES(?,?,?,?)',
  EVENTP => 'SELECT id FROM cross_event_vw WHERE process=? and action=? AND '
            . 'operator=? AND event_date=? AND project=? AND project_lab=? AND '
            . 'cross_type=?',
  EPP => 'SELECT value FROM event_property WHERE event_id=? AND type_id=?',
  EPI => 'INSERT INTO event_property (event_id,type_id,value) '
         . 'VALUES (?,?,?)',
  LINEEVENT => 'INSERT INTO line_event (line_id,event_id) VALUES(?,?)',
  LINEEVENTP => 'SELECT id FROM line_event WHERE line_id=? AND event_id=?',
  LEPP => 'SELECT id,value FROM line_event_property WHERE line_event_id=? AND '
          . 'type_id=?',
  LEPI => 'INSERT INTO line_event_property (line_event_id,type_id,value) '
          . 'VALUES (?,?,?)',
);
# Counter
my (%count,%acc);
# CV term IDs
my %ID;


# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Get the command-line parameters
GetOptions(development => \$DEV,
           'output=s'  => \my $output_file,
           verbose     => \$VERBOSE,
           debug       => \$DEBUG,
           test        => \$TEST,
           help        => \my $HELP)
  or pod2usage(-1);

# Display help and exit if the -help parm is specified
pod2text($0),&terminateProgram() if ($HELP);

$VERBOSE = 1 if ($DEBUG);
# Open the output stream and alias STDERR
my $handle = ($output_file) ? (new IO::File $output_file,'>'
                or &terminateProgram("ERROR: could not open $output_file ($!)"))
                           : (new_from_fd IO::File \*STDOUT,'>'
                or &terminateProgram("ERROR: could not open STDOUT ($!)"));
open(STDERR,'>&='.fileno($handle))
    or &terminateProgram("ERROR: could not alias STDERR ($!)");
autoflush $handle 1;
# Initialize database handles
&initialize();
$ID{cross} = &getCVTermID(CV => 'process',TERM => 'cross');
$ID{effector} = &getCVTermID(CV => 'fly',TERM => 'effector');
$ID{cross_type} = &getCVTermID(CV => 'flycore',TERM => 'cross_type');
$ID{project} = &getCVTermID(CV => 'flycore',TERM => 'project');
$ID{project_lab} = &getCVTermID(CV => 'flycore',TERM => 'project_lab');
$ID{rearing} = &getCVTermID(CV => 'fly_olympiad',TERM => 'rearing_protocol');
# Sync
&processCrosses();
# Display summary
if ($VERBOSE) {
  printf $handle "%-32s%d\n"x15,
                 'Cross events:',$count{cross}||0,
                 'No project:',$count{noproject}||0,
                 'No project lab:',$count{noprojectlab}||0,
                 'No cross type:',$count{nocross}||0,
                 'No effector:',$count{noeffector}||0,
                 'No rearing:',$count{norearing}||0,
                 'Events inserted:',$count{einserted}||0,
                 'Existing events:',$count{eexists}||0,
                 'Event properties inserted:',$count{epinserted}||0,
                 'Existing event properties:',$count{epexists}||0,
                 'Line events inserted:',$count{linserted}||0,
                 'Existing line events:',$count{lexists}||0,
                 'Line event properties inserted:',$count{lepinserted}||0,
                 'Existing line event properties:',$count{lepexists}||0,
                 'Insert errors:',$count{error}||0;
  print $handle "Projects:\n";
  printf $handle "  %s: %d\n",$_,$acc{project}{$_}
    foreach (sort keys %{$acc{project}});
  print $handle "Project labs:\n";
  printf $handle "  %s: %d\n",$_,$acc{project_lab}{$_}
    foreach (sort keys %{$acc{project_lab}});
  print $handle "Cross types:\n";
  printf $handle "  %s: %d\n",$_,$acc{cross_type}{$_}
    foreach (sort keys %{$acc{cross_type}});
  print $handle "Effectors:\n";
  printf $handle "  %s: %d\n",$_,$acc{effector}{$_}
    foreach (sort keys %{$acc{effector}});
}
# We're done
&terminateProgram();

# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************

# ****************************************************************************
# * Subroutine:  initialize                                                  *
# * Description:                                                             *
# * Description: This routine will initialize the program. The following     *
# *              steps are taken:                                            *
# *              1) Connect to the SAGE database                             *
# *              2) Connect to the FLYF database                             *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub initialize
{
  # SAGE
  $SAGE .= ($DEV) ? 'db-dev' : 'mysql3';
  $dbh = DBI->connect($SAGE,USER,PASS)
    || &terminateProgram("Could not connect to $SAGE");
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth);
  # FLYF
  $FLYF_URL =~ s/([=;])/uc sprintf("%%%02x",ord($1))/eg;
  $dbhf = DBI->connect(join(';url=',$FLYF_SERVER,$FLYF_URL),(undef)x2)
    or &terminateProgram($DBI::errstr);
}


sub processCrosses
{
my $rv;

  my $PROJECT = '';
  unless ($TEST) {
    $rv = $sth{DELETE}->execute();
    printf $handle "Deleted %d cross event%s\n",$rv,(1 == $rv) ? '' : 's'
      if ($VERBOSE);
  }
  # Get line IDs
  my %LINEID = ();
  $sth{LINE_IDS}->execute();
  my($idarr) = $sth{LINE_IDS}->fetchall_arrayref();
  foreach (@$idarr) {
    $LINEID{$_->[1]}{$_->[2]} = $_->[0];
  }
  my $PROJECT_TERM = ($PROJECT) ? "='$PROJECT'" : ' IS NOT NULL';
  my($aref) = $dbhf->selectall_arrayref('SELECT sf."Lab ID",sf.Stock_Name,'
    . 'pc.Barcode_CrossSerialNumber,pc.Wish_List,pc.Project,pc.Lab_Project,pc.Cross_Type,pc.Date_Crossed,pc.Reporter,'
    . 'pc.Rearing_Condition FROM StockFinder sf,Project_Crosses pc WHERE '
    . "pc.Project$PROJECT_TERM AND sf.Stock_Name IS NOT NULL AND "
    . 'pc.Date_Crossed IS NOT NULL AND pc."_kf_Parent_UID"=sf."__kp_UniqueID"');
  printf $handle "Found %d events in FLYF2\n",scalar(@$aref);
  my (%lab,%line);
  foreach (@$aref) {
    my($lab,$line,$barcode,$wish_list,$project,$project_lab,$cross,$date,$effector,$rearing) = @$_;
    &terminateProgram("Missing lab for $line") unless ($lab);
    unless ($project) {
      print $handle "Missing project for $line\n" if ($DEBUG);
      ++$count{noproject};
      next;
    }
    unless ($project_lab) {
      print $handle "Missing project lab for $line\n" if ($DEBUG);
      ++$count{noprojectlab};
      next;
    }
    # Get the project lab ID
    unless ($lab{$project_lab}) {
      $lab{$project_lab} = &getCVTermID(CV => 'lab',TERM => $project_lab);
    }
    $rearing = 'rc2' if ($project ne 'Fly Light');
    $cross = $project if (!$cross && $project ne 'Fly Light');
    (++$count{norearing} && next) if (!$rearing && $project ne 'Fly Light');
    $count{cross}++;
    $effector ||= '';
    $rearing ||= '';
    $project_lab ||= '';
    $cross = '' if (!$cross && $project ne 'Fly Light');
    print $handle join("\t",$barcode,$lab,$line,$project,$project_lab,$cross,$date,
                       $effector,$rearing),"\n" if ($VERBOSE);
    (++$count{nocross} && next) if (!$cross && $project eq 'Fly Light');
    (++$count{noeffector} && next) unless ($effector);
    $acc{project}{$project}++;
    $acc{project_lab}{$project_lab}++;
    $acc{cross_type}{$cross}++ if ($cross);
    $acc{effector}{$effector}++ if ($effector);
    # Get line data
    unless (exists $line{$line}) {
      #$sth{LINE}->execute($line,lc($lab));
      #my($lid) = $sth{LINE}->fetchrow_array();
      my($lid) = $LINEID{$line}{lc($lab)};
      if ($lid) {
        $line{$line} = $lid;
      }
      else {
        print $handle "  Line $line for lab [",lc($lab),
                      "] is not in SAGE: will try without lab\n";
        $sth{LINE2}->execute($line);
        my $lar = $sth{LINE2}->fetchall_arrayref();
        if (scalar(@$lar) > 1) {
          print $handle "  Line $line is in SAGE multiple times\n";
          next;
        }
        elsif (!scalar(@$lar)) {
          print $handle "  Line $line is not in SAGE\n";
          next;
        }
        $line{$line} = $lar->[0][0];
      }
    }
    my($eid) = &addEvent($date,$project,$project_lab,$cross);
    # Add line event
    $sth{LINEEVENTP}->execute($line{$line},$eid);
    my($leid) = $sth{LINEEVENTP}->fetchrow_array();
    # Code is disabled until (maybe unless) we change the schema/constraints
    if ($leid && 0) {
      print $handle "  Line event exists for line $line and event ID $eid\n" if ($DEBUG);
      $count{lexists}++;
    }
    else {
      print $handle "  INSERT line event for line ID $line{$line}, "
                    . "event ID $eid\n" if ($DEBUG);
      unless ($TEST) {
        $rv = $sth{LINEEVENT}->execute($line{$line},$eid);
        $leid = $dbh->last_insert_id(undef,undef,'line_event','id');
        $count{linserted}++;
      }
    }
    unless ($TEST) {
      &checkAndInsertLEP($leid,$line,'fly','effector',$effector);
      &checkAndInsertLEP($leid,$line,'fly_olympiad','rearing_protocol',$rearing);
      &checkAndInsertLEP($leid,$line,'fly','cross_barcode',int($barcode));
      &checkAndInsertLEP($leid,$line,'fly','wish_list',$wish_list)
        if ($wish_list);
    }
#    $sth{LEPP}->execute($eid,$line,'light_imagery','uas_reporter');
#    my($rid,$rep) = $sth{LEPP}->fetchrow_array();
#    $rv = $sth{LEPI}->execute($leid,$ID{reporter},$reporter) unless ($rid);
#    $sth{LEPP}->execute($eid,$line,'fly_olympiad','rearing_protocol');
#    ($rid,$rep) = $sth{LEPP}->fetchrow_array();
#    $rv = $sth{LEPI}->execute($leid,$ID{rearing},$rearing) unless ($rid);
  }
}


sub checkAndInsertLEP
{
  my($leid,$line,$cv,$type,$value) = @_;
  $sth{LEPP}->execute($leid,&getCVTermID(CV => $cv,TERM => $type));
  my($rid,$val) = $sth{LEPP}->fetchrow_array();
  if ($rid) {
    $count{lepexists}++;
  }
  else {
    print $handle "  INSERT line event property $type ($value)\n"
      if ($DEBUG);
    my $rv = $sth{LEPI}->execute($leid,&getCVTermID(CV => $cv,TERM => $type),
                                 $value);
    if ($rv) {
      $count{lepinserted}++;
    }
    else {
      &terminateProgram("Could not insert line event property $type ($value)");
    }
  }
}


sub addEvent
{
my $rv;

  my($date,$project,$project_lab,$cross) = @_;
  $sth{EVENTP}->execute('cross','P','Fly Core',$date.' 00:00:00',$project,
                        $project_lab,$cross);
  my($eid) = $sth{EVENTP}->fetchrow_array();
  if ($eid) {
    print $handle "  Cross event exists for $project,$project_lab,$cross on $date\n"
      if ($DEBUG);
    $count{eexists}++;
  }
  else {
    # The event doesn't exist - create it
    print $handle "  INSERT cross event for $date\n" if ($DEBUG);
    $rv = $sth{EVENT}->execute($ID{cross},'P','Fly Core',$date.' 00:00:00');
    $eid = $dbh->last_insert_id(undef,undef,'event','id');
    &terminateProgram("Could not insert event for $date 00:00:00") unless ($eid);
    $count{einserted}++;
  }
  &checkAndInsertEP($eid,'project',$project);
  &checkAndInsertEP($eid,'project_lab',$project_lab);
  &checkAndInsertEP($eid,'cross_type',$cross);
  return($eid);
}


sub checkAndInsertEP
{
  my($eid,$type,$value) = @_;
  $sth{EPP}->execute($eid,$ID{$type});
  my($val) = $sth{EPP}->fetchrow_array();
  if ($val) {
    $count{epexists}++;
  }
  else {
    print $handle "  INSERT event property $type ($value)\n"
      if ($DEBUG);
    my $rv = $sth{EPI}->execute($eid,$ID{$type},$value);
    $count{epinserted}++;
  }
}


# ****************************************************************************
# * Subroutine:  terminateProgram                                            *
# * Description: This routine will gracefully terminate the program. If a    *
# *              message is passed in, we exit with a code of -1. Otherwise, *
# *              we exit with a code of 0.                                   *
# *                                                                          *
# * Parameters:  message: the error message to print                         *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub terminateProgram
{
  my $message = shift;
  print { $handle || \*STDERR } "$message\n" if ($message);
  $handle->close if ($handle);
  ref($sth{$_}) && $sth{$_}->finish foreach (keys %sth);
  $dbh->disconnect if ($dbh);
  $dbhf->disconnect if ($dbhf);
  exit(($message) ? -1 : 0);
}
