#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use Getopt::Long;
use JSON;
use Kafka::Connection;
use Kafka::Producer;
use LWP::Simple;
use Pod::Text;
use Pod::Usage;
use POSIX qw(strftime);
use Scalar::Util qw(blessed);
use Time::HiRes qw(time);
use Try::Tiny;
use Sys::Hostname;
use JFRC::Utils::DB qw(:all);
use JFRC::Utils::SAGE qw(:all);


# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
use constant DATA_PATH => '/groups/scicomp/informatics/data/';

# ****************************************************************************
# * Global variables                                                         *
# ****************************************************************************
# Parameters
my ($ALL,$DEBUG,$LINE,$VERBOSE) = ('')x4;
my (%REST,%SERVER);
my $userid;
# Database
our $dbh;
my %sth = (
ILINE => "INSERT INTO line (name,lab_id,organism_id) VALUES (?,"
         . "getCvTermId('lab','flylight',''),1)",
LINE => "SELECT id FROM line WHERE name=?",
IPROP => "INSERT INTO line_property (line_id,type_id,value) VALUES (?,"
         . "getCvTermId('line',?,''),?)",
UPROP => "UPDATE line_property SET value=? WHERE line_id=? AND "
         . "type_id=getCvTermId('line',?,'')",
RELATIONSHIP => "SELECT object_id FROM line_relationship_vw WHERE subject=? "
                . "AND relationship='child_of'",
DRELATIONSHIP => "DELETE FROM line_relationship WHERE subject_id=? OR object_id=?",
);
# Kafka
my ($connection,$producer);


# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************


sub terminateProgram
{
  my $message = shift;
  print STDERR "$message\n" if ($message);
  if ($dbh) {
    ref($sth{$_}) && $sth{$_}->finish foreach (keys %sth);
     $dbh->disconnect;
  }
  undef $producer;
  $connection->close;
  undef $connection;
  exit(($message) ? -1 : 0);
}


sub logError
{
  my $msg = shift;
  print "$msg\n";
}


sub initializeProgram
{
  # Get general REST config
  my $file = DATA_PATH . 'rest_services.json';
  open SLURP,$file or &terminateProgram("Can't open $file: $!");
  sysread SLURP,my $slurp,-s SLURP;
  close(SLURP);
  my $hr = decode_json $slurp;
  %REST = %$hr;
  # Get servers
  $file = DATA_PATH . 'servers.json';
  open SLURP,$file or &terminateProgram("Can't open $file: $!");
  sysread SLURP,$slurp,-s SLURP;
  close(SLURP);
  $hr = decode_json $slurp;
  %SERVER = %$hr;
  # Initialize
  &dbConnect(\$dbh,'sage');
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth);
  # Kafka
  try {
    $connection = Kafka::Connection->new(host => $SERVER{Kafka}{address},
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
  &logError("Couldn't connect to Kafka at $SERVER{Kafka}{address}") unless ($producer);
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


sub insertLineProperty
{
  my($lid,$term,$value) = @_;
  my $rc = $sth{IPROP}->execute(@_);
  print "  Inserted $term ($value) for line ID $lid\n"
    if ($DEBUG && ($rc == 1));
  &logError("Could not insert line property $term ($value) for line ID $lid")
    unless ($rc == 1);
  return($rc == 1);
}


sub changeRelationships
{
  my($lid,$split_halfref,$parents) = @_;
  my $rc = $sth{DRELATIONSHIP}->execute($lid,$lid);
  print "  Deleted relationships for line ID $lid ($rc)\n" if ($DEBUG);
  $rc = &createRelationships($lid,$split_halfref);
  return(0) unless ($rc);
  $rc = $sth{UPROP}->execute($parents,$lid,'flycore_alias');
  print "  Updated flycore_alias ($parents) for line ID $lid\n"
    if ($DEBUG && ($rc == 1));
  return($rc);
}


sub createRelationships
{
  my($lid,$split_halfref) = @_;
  foreach my $parent_id (keys %$split_halfref) {
    my $sql = "CALL createLineRelationship($lid,$parent_id)";
    eval {$dbh->do($sql);};
    if ($@) {
      &logError('Error: '.$@);
      return(0);
    }
    else {
      print "  Inserted releationship to split half $parent_id\n"
        if ($DEBUG);
    }
  }
  return(1);
}


sub processInitialSplits
{
  my %count;
  my $rest = "$REST{flycore}{url}?request=initial_splits";
  my $response = get $rest;
  my $rvar;
  die("REST GET [$rest] returned null response")
    unless (length($response));
  eval {$rvar = decode_json($response)};
  die($rvar->{error}) if ($rvar->{error});
  printf "Retrieved %d initial splits\n",scalar(@{$rvar->{splits}}) if ($DEBUG);
  foreach (@{$rvar->{splits}}) {
    my($barcode,$split,$parents) = @{$_}{qw(cross_barcode line genotype)};
    next if ($LINE && ($LINE ne $split));
    $sth{LINE}->execute($split);
    my($lid) = $sth{LINE}->fetchrow_array();
    next if (!$ALL && $lid &&!$LINE);
    $count{read}++;
    printf "Cross barcode %d: %s %s\n",$barcode,$split,$parents if ($VERBOSE);
    my %split_half;
    my @halves = split(/-[Xx]-/,$parents);
    if ((scalar(@halves) == 2) && ($halves[0] eq $halves[1])) {
      &logError("Duplicate split halves for $split") if ($DEBUG);
      $count{error}++;
      next;
    }
    foreach my $half (@halves) {
      $sth{LINE}->execute($half);
      my $id = $sth{LINE}->fetchrow_array();
      if ($id) {
        $split_half{$id}++;
        print "  Split half $half found ($id)\n" if ($DEBUG);
      }
      else {
        print "  Split half $half was not found from $parents\n" if ($DEBUG);
        $count{error}++;
        next;
      }
    }
    unless (scalar(keys %split_half) == 2) {
      &logError("Could not find split halves for $split") if ($DEBUG);
      next;
    }
    my $error = 0;
    if ($lid) {
      $sth{RELATIONSHIP}->execute($split);
      my $ar2 = $sth{RELATIONSHIP}->fetchall_arrayref();
      $error++ unless (scalar(@$ar2) == 2);
      foreach my $sh (@$ar2) {
        $error++ unless (exists $split_half{$sh->[0]});
      }
      if ($error) {
        print "  Changing relationships for line ID $lid\n" if ($DEBUG);
        unless (&changeRelationships($lid,\%split_half,$parents)) {
          &logError("Could not update line relationships for line ID $lid");
          $count{error}++;
          next;
        }
      }
      print "  Found line $split : skipping load\n" if ($DEBUG);
      $count{skipped}++;
      next;
    }
    else {
      my $rc = $dbh->begin_work;
      $sth{ILINE}->execute($split);
      $lid = $dbh->{mysql_insertid};
      if ($lid) {
        &publish({client => $PROGRAM,host => hostname,user => $userid,
                  type => 'line',item => $split,item_id => $lid});
        print "  Inserted line $split ($lid)\n" if ($DEBUG);
        $rc = &createRelationships($lid,\%split_half);
        $rc = &insertLineProperty($lid,'hide','Y') if ($rc);
        $rc = &insertLineProperty($lid,'flycore_permission','Class 3 (Written)') if ($rc);
        $rc = &insertLineProperty($lid,'flycore_project','Split_GAL4') if ($rc);
        $rc = &insertLineProperty($lid,'flycore_project_subcat','InitialSplits') if ($rc);
        $rc = &insertLineProperty($lid,'flycore_lab','Fly Light') if ($rc);
        $rc = &insertLineProperty($lid,'flycore_alias',$parents) if ($rc);
        $error++ unless ($rc);
        $count{($rc) ? 'inserted' : 'skipped'}++;
      }
      else {
        $error = 1;
        $count{error}++;
      }
      $rc = ($error) ? $dbh->rollback : $dbh->commit;
    }
  }
  print "Split crosses:  ",scalar(@{$rvar->{splits}}),"\n",
        "Lines read:     ",($count{read} || 0),"\n",
        "Lines inserted: ",($count{inserted} || 0),"\n",
        "Lines skipped:  ",($count{skipped} || 0),"\n",
        "Lines in error: ",($count{error} || 0),"\n";
}


# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Get the command-line parameters
GetOptions('line=s' => \$LINE,
           all      => \$ALL,
           verbose  => \$VERBOSE,
           debug    => \$DEBUG,
           help     => \my $HELP)
  or pod2usage(-1);
$VERBOSE = 1 if ($DEBUG);

&initializeProgram();
&processInitialSplits();
&terminateProgram();
