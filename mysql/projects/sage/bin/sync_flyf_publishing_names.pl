#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use Getopt::Long;
use IO::File;
use JSON;
use Kafka::Connection;
use Kafka::Producer;
use LWP::Simple;
use POSIX qw(strftime);
use Scalar::Util qw(blessed);
use Sys::Hostname;
use Time::HiRes qw(time);
use Try::Tiny;
use JFRC::Utils::DB qw(:all);
use JFRC::Utils::SAGE qw(:all);


# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
use constant DATA_PATH => '/groups/scicomp/informatics/data/';
my $FLYF_SERVER = 'dbi:JDBC:hostname=<REPLACE>;port=9001';
my $FLYF_URL = 'jdbc:filemaker://<REPLACE>/FLYF_2?user=flyf2&password=flycore';

# ****************************************************************************
# * Global variables                                                         *
# ****************************************************************************
# Parameters
my ($DEBUG,$TEST,$VERBOSE) = (0)x3;
# Database
our ($dbh,$dbhf);
my %sth = (
EXISTS => "SELECT id FROM publishing_name WHERE line_id=? AND publishing_name=?",
DELETE => "DELETE from publishing_name WHERE id=?",
LINEID => "SELECT id FROM line WHERE name=?",
IPUBLISHING => "INSERT INTO publishing_name (line_id,source_id,publishing_name,for_publishing,published,label,requester,notes,source_create_date,preferred_name) "
         . "VALUES (?,?,?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE publishing_name=?,for_publishing=?,published=?,label=?,requester=?,notes=?",
SOURCE => "SELECT source_id,id,line FROM publishing_name_vw",
);
my %sthf = (
LINES => 'SELECT "__kp_UniqueID",Stock_Name FROM StockFinder WHERE Stock_Name IS NOT NULL',
NAMES => 'SELECT "_kf_parent_UID","__kp_name_serial_number",all_names,for_publishing,published,label,who,notes,create_date FROM all_names WHERE for_publishing=' . "'Yes'",
);
# Configuration
my %CONFIG;
# Kafka
my ($connection,$producer,$userid);
# General use
my %ASSIGN;
my @NAME;

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Get the command-line parameters
GetOptions(test    => \$TEST,
           verbose => \$VERBOSE,
           debug   => \$DEBUG);
$VERBOSE = 1 if ($DEBUG);
&initializeProgram();
&processNames();
&terminateProgram();

sub terminateProgram
{
  my $message = shift;
  print STDERR "$message\n" if ($message);
  if ($dbh) {
    ref($sth{$_}) && $sth{$_}->finish foreach (keys %sth);
     $dbh->disconnect;
  }
  if ($dbhf) {
    ref($sthf{$_}) && $sthf{$_}->finish foreach (keys %sthf);
     $dbhf->disconnect;
  }
  undef $producer;
  $connection->close;
  undef $connection;
  exit(($message) ? -1 : 0);
}


sub initializeProgram
{
  # Initialize
  my $file = DATA_PATH . 'servers.json';
  open SLURP,$file or &terminateProgram("Can't open $file: $!");
  sysread SLURP,my $slurp,-s SLURP;
  close(SLURP);
  my $hr = decode_json $slurp;
  %CONFIG = %$hr;
  &dbConnect(\$dbh,'sage');
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth);
  $FLYF_URL =~ s/<REPLACE>/$CONFIG{FlyCore}{address}/;
  $FLYF_URL =~ s/([=;])/uc sprintf("%%%02x",ord($1))/eg;
  $FLYF_SERVER =~ s/<REPLACE>/$CONFIG{JDBC}{address}/;
  $dbhf = DBI->connect(join(';url=',$FLYF_SERVER,$FLYF_URL),(undef)x2)
    or &terminateProgram($DBI::errstr);
  $sthf{$_} = $dbhf->prepare($sthf{$_}) || &terminateProgram("$_: ".$dbhf->errstr)
    foreach (keys %sthf);
  # Kafka
  try {
    $connection = Kafka::Connection->new(host => $CONFIG{Kafka}{address},
                                         timeout => 5);
    $producer = Kafka::Producer->new(Connection => $connection)
      if ($connection);
  }
  catch {
    my $error = $_;
    if (blessed($error) && $error->isa('Kafka::Exception')) {
      &logError('Error: ('.$error->code.') '.$error->message);
    }
    else {
      &logError($error);
    }
  };
  &logError("Couldn't connect to Kafka at $CONFIG{Kafka}{address}") unless ($producer);
  $userid = getlogin || getpwuid($<);
}


sub publish
{
  return unless ($producer);
  my($message) = shift;
  try {
    my $t = time;
    my $stamp = strftime "%Y-%m-%d %H:%M:%S", localtime $t;
    $stamp .= sprintf ".%03d", ($t-int($t))*1000;
    $message->{time} = $t;
    $message = encode_json $message;
    print "$message\n" if ($VERBOSE);
    my $response = $producer->send('flycore_sync',0,$message,$stamp,undef,int(time*1000));
  }
  catch {
    my $error = $_;
    if (blessed($error) && $error->isa('Kafka::Exception')) {
      &logError('Error: ('.$error->code.') '.$error->message);
    }
    else {
      &logError($error);
    }
  };
}


sub setPublishingName
{
  my($line,$allname) = @_;
  # _kf_parent_UID,__kp_name_serial_number,all_names,for_publishing,published,label,who,notes,create_date
  my($kp,$sn,$publishing_name,$for_publishing,$published,$label,$who,$notes,$created) = @$allname;
  foreach my $i (3..8) {
    $allname->[$i] ||= '';
  }
  foreach my $i (3..5) {
    $allname->[$i] = ($allname->[$i] =~ /^[Yy]/) ? 1 : 0;
  }
  # Get id for line
  $sth{LINEID}->execute($line);
  my($line_id) = $sth{LINEID}->fetchrow_array();
  return(0) unless ($line_id);
  # Insert/update record
  $sth{EXISTS}->execute($line_id,$publishing_name);
  $a = $sth{EXISTS}->fetchrow_array();
  (my $short_line = $line) =~ s/^.+_//;
  if ($short_line =~ /^IS\d+$/) {
    $short_line =~ s/IS/SS/;
  }
  my $default = ($short_line eq $publishing_name) ? 1 : 0;
  # (line_id,source_id,publishing_name,for_publishing,published,label,requester,notes,source_create_date)
  if ($TEST) {
    print "Would have used publishing name $allname->[2] for $line\n";
  }
  else {
    my $rows;
    $rows = $sth{IPUBLISHING}->execute($line_id,@$allname[1..8],$default,@$allname[2..7])
      or &terminateProgram($DBI::errstr);
    if ($rows > 0) {
      print "  Line $line ($line_id) has publishing name $publishing_name\n" if ($DEBUG);
      &publish({client => $PROGRAM,host => hostname,user => $userid,
                action => 'insert',type => 'line',item => $line,
                item_id => $line_id,publishing_name => $publishing_name})
        unless ($a);
    }
  }
  push @NAME,$allname;
  $ASSIGN{$kp}++;
  return(1)
}


sub processNames
{
  my (%flyf2_source,%stockname);
  print "Selecting stocks and names from FLYF2\n";
  $sthf{LINES}->execute();
  my $ar = $sthf{LINES}->fetchall_arrayref();
  $stockname{$_->[0]} = $_->[1] foreach (@$ar);
  # %stockname maps kp_UniqueID to stock name
  print "  Found ",scalar(keys %stockname)," stock names in StockFinder table\n"
    if ($VERBOSE);
  $sthf{NAMES}->execute();
  $ar = $sthf{NAMES}->fetchall_arrayref();
  print "  Found ",scalar(@$ar)," names in all_names table\n" if ($VERBOSE);
  print "Updating SAGE with new/updated names\n";
  # Loop over names
  foreach (@$ar) {
    # _kf_parent_UID,__kp_name_serial_number,all_names,for_publishing,published,label,who,notes,create_date
    my($kp,$sn,$publishing_name,$for_publishing,$published,$label,$who,$notes,$created) = @$_;
    $flyf2_source{$sn}++;
    print "  Warning: $stockname{$kp} has a publishing name with carriage returns\n"
      if (exists($stockname{$kp}) && ($publishing_name =~ /[\x00-\x1F]/));
    next unless ($publishing_name);
    chomp($publishing_name);
    $publishing_name =~ s/[\x00-\x1F]/ /g;
    $_->[2] = $publishing_name;
    if (exists($stockname{$kp}) && ($stockname{$kp} ne $publishing_name)) {
      my $line = $stockname{$kp};
      next if ($line eq 'KEEP EMPTY');
      my @original = @$_;
      &setPublishingName($line,$_);
      if ($line =~ /..._SS\d+$/) {
        (my $new_line = $line) =~ s/SS/IS/;
        my $ret = &setPublishingName($new_line,\@original);
        unless ($ret) {
          $new_line =~ s/^GMR/JRC/;
          my $ret = &setPublishingName($new_line,\@original);
        }
      }
    }
  }
  printf "  Updated %d usable names in all_names table that map to %d lines\n",
         scalar(@NAME),scalar(keys %ASSIGN) if ($VERBOSE);

  # Check for deletions
  print "Checking SAGE::publishing_names vs. FLYF2::all_names for deletions\n";
  $sth{SOURCE}->execute();
  $ar = $sth{SOURCE}->fetchall_arrayref();
  my %sage_source;
  foreach (@$ar) {
    $sage_source{$_->[0]} = $_->[1] unless ($_->[2] =~ /_IS\d+$/);
  }
  # Delete old records from SAGE
  if ($VERBOSE) {
    printf "  Found %d records in FLYF2\n",scalar(keys %flyf2_source);
    printf "  Found %d records in SAGE\n",scalar(keys %sage_source);
  }
  foreach (keys %sage_source) {
    unless (exists $flyf2_source{$_}) {
      print "  $_ present in SAGE not in FLYF2\n" if ($DEBUG);
      unless ($TEST) {
        $sth{DELETE}->execute($sage_source{$_});
        &publish({client => $PROGRAM,host => hostname,user => $userid,
                  action => 'delete',type => 'publishing_name',item => $_});
      }
    }
  }
}


sub logError
{
  my $msg = shift;
  print "$msg\n";
}
