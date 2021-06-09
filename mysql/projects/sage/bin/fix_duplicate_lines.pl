#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use DBI;
use Getopt::Long;
use IO::File;
use JFRC::Utils::DB;
use Pod::Text;
use Pod::Usage;

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
my $FLYF_SERVER = 'dbi:JDBC:hostname=prod1;port=9001';
my $FLYF_URL = 'jdbc:filemaker://10.40.3.26:2399/FLYF_2?user=flyf2&password=flycore';
my %TERM;

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Command-line parameters
our($DEBUG,$TEST,$VERBOSE) = (0)x3;
# Files
our $handle;
# Database
our ($dbh,$dbhf);
my %sth = (
  CHANGE => "SELECT flycore_id,GROUP_CONCAT(id),COUNT(1) AS c FROM line_vw WHERE flycore_id IS NOT NULL AND flycore_id != '' GROUP BY 1 HAVING c>1",
  DEVENT => "DELETE FROM line_event WHERE line_id=?",
  DLINE => "DELETE FROM line WHERE id=?",
  DLINEPROP => "DELETE FROM line_property WHERE line_id=?",
  DPUB => "DELETE FROM publishing_name WHERE line_id=?",
  DUPS => "SELECT name,GROUP_CONCAT(lab),COUNT(1) AS c FROM line_vw "
          . "GROUP BY 1 HAVING c>1",
  ID => "SELECT id,flycore_id FROM line_vw WHERE name=? AND lab=?",
  IMAGE => "SELECT id FROM image WHERE line_id=?",
  NAME => "SELECT name FROM line WHERE id=?",
  REASSIGNI => "UPDATE image SET line_id=? WHERE line_id=?",
  REASSIGNS => "UPDATE session SET line_id=? WHERE line_id=?",
  REASSIGNP => "UPDATE publishing_name SET line_id=? WHERE line_id=?",
  REASSIGNE => "UPDATE line_event SET line_id=? WHERE line_id=?",
  SESSION => "SELECT id FROM session WHERE line_id=?",
  TERM => "SELECT cv_term,display_name,id FROM cv_term_vw WHERE cv='lab'",
);


# Get the command-line parameters
GetOptions('output=s' => \my $output_file,
           test       => \$TEST,
           verbose    => \$VERBOSE,
           debug      => \$DEBUG,
           help       => \my $HELP)
  or pod2usage(-1);

$VERBOSE = 1 if ($DEBUG);
&initialize();

&processDuplicates();

sub terminateProgram
{
}


sub initialize
{
  # Open the output stream and alias STDERR
  $handle = ($output_file) ? (new IO::File $output_file,'>'
            or &terminateProgram("ERROR: could not open $output_file ($!)"))
                           : (new_from_fd IO::File \*STDOUT,'>'
            or &terminateProgram("ERROR: could not open STDOUT ($!)"));
  open(STDERR,'>&='.fileno($handle))
      or &terminateProgram("ERROR: could not alias STDERR ($!)");
  autoflush $handle 1;
  # SAGE
  &dbConnect(\$dbh,'sage');
  foreach (keys %sth) {
    $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr);
  }
  # FLYF2
  $FLYF_URL =~ s/([=;])/uc sprintf("%%%02x",ord($1))/eg;
  $dbhf = DBI->connect(join(';url=',$FLYF_SERVER,$FLYF_URL),(undef)x2);
  # CV terms
  $sth{TERM}->execute();
  my $ar = $sth{TERM}->fetchall_arrayref();
  $TERM{$_->[1]} = [$_->[0],$_->[2]] foreach (@$ar);
}


sub processDuplicates
{
  $sth{DUPS}->execute();
  my $ar = $sth{DUPS}->fetchall_arrayref();
  print $handle "Lines with duplicates: ",scalar(@$ar),"\n";
  my %duplicated_line = ();
  foreach (@$ar) {
    my($line) = $_->[0];
    my(@lab) = split(',',$_->[1]);
    print $handle "$line\n" if ($VERBOSE);
    $duplicated_line{$line}++;
    my %id;
    foreach my $l (sort @lab) {
      $sth{ID}->execute($line,$l);
      my $idref = $sth{ID}->fetchrow_arrayref();
      $id{$l} = [$idref->[0],($idref->[1]||'')];
    }
    print $handle "  " . join(', ',map { "$_ (SAGE ID: $id{$_}[0]   FLYF2 ID:$id{$_}[1])" }
                                         sort keys %id) . "\n" if ($DEBUG);
    my @bad = ();
    my ($flylab,$good) = ('')x2;
    foreach my $l (sort keys %id) {
      if ($id{$l}[1]) {
        print $handle "  Selecting FLYF2 lab for __kp_UniqueID $id{$l}[1]\n" if ($DEBUG);
        $flylab = $dbhf->selectrow_array('SELECT "Lab ID" FROM StockFinder WHERE "__kp_UniqueID"=' . $id{$l}[1]);
        print $handle "    Found FLYF2 lab $flylab\n" if ($DEBUG);
        $flylab = ucfirst($flylab) . ' Lab' unless (exists $TERM{$flylab});
        unless (exists $TERM{$flylab}) {
          print $handle "  Lab $flylab does not exist\n";
          next;
        }
        print "  Found $id{$l}[1], comparing $l eq $TERM{$flylab}[0]\n";
        ($l eq $TERM{$flylab}[0]) ? $good = $id{$l}[0] : push @bad,$id{$l}[0];
      }
      else {
        push @bad,$id{$l}[0];
      }
    }
    if ($DEBUG) {
      print $handle "  Fly lab: $flylab  ";
      print $handle ($good) ? "Good: $good  Bad: " . join(', ',@bad) . "\n"
                            : "No good line ID found\n";
    }
    next if ($line eq 'FCF_pBDPGAL4U_1500437');
    &processLine(1,$good,@bad) if ($good);
  }
  # Look for changed stock names
  $sth{CHANGE}->execute();
  $ar = $sth{CHANGE}->fetchall_arrayref();
  print $handle "Lines whose FlyCore IDs changed stock names: ",scalar(@$ar),"\n";
  foreach (@$ar) {
    my $flycore_id = $_->[0];
    unless ($flycore_id =~ /^\d+$/) {
      print "$flycore_id - ad FlyCore ID\n";
      next;
    }
    my(@sage_ids) = split(/,/,$_->[1]);
    my($stockname) = $dbhf->selectrow_array('SELECT "Stock_Name" FROM StockFinder WHERE "__kp_UniqueID"=' . $flycore_id);
    next if (exists $duplicated_line{$stockname});
    print $handle "$flycore_id: $stockname\n" if ($VERBOSE);
    my @bad = ();
    my $good = '';
    foreach my $sid (@sage_ids) {
      $sth{NAME}->execute($sid);
      my $name  = $sth{NAME}->fetchrow_array();
      if ($name eq $stockname) {
        $good = $sid;
      }
      else {
        print $handle "  FlyCore stock name was changed from $name to $stockname\n" if ($DEBUG);
        push @bad,$sid;
      }
    }
    if (scalar(@bad) < 1) {
      print $handle "  Couldn't find any bad IDs\n";
    }
    elsif ($good) {
      &processLine(0,$good,@bad);
    }
  }
}


sub processLine
{
  my($reassign,$good,@bad) = @_;
  foreach my $lid (@bad) {
    print $handle "  Bad line ID $lid:\n" if ($DEBUG);
    $sth{IMAGE}->execute($lid);
    my $ar = $sth{IMAGE}->fetchall_arrayref();
    print $handle "    Images: " . scalar(@$ar) . "\n" if ($DEBUG);
    $sth{SESSION}->execute($lid);
    my $ar2 = $sth{SESSION}->fetchall_arrayref();
    print $handle "    Sessions: " . scalar(@$ar2) . "\n" if ($DEBUG);
    &removeLine($good,$lid,scalar(@$ar)) if ($reassign);
  }
}


sub removeLine
{
  my($good,$bad,$to_reassign) = @_;
  if ($to_reassign) {
    foreach (qw(images sessions publishing events)) {
      if ($TEST) {
        print $handle "  Would have reassigned $_\n";
      }
      else {
        my($suffix) = uc(substr($_,0,1));
        $sth{"REASSIGN$suffix"}->execute($good,$bad);
        print $handle "  $_ reassigned: " . $sth{"REASSIGN$suffix"}->rows . "\n"
          if ($DEBUG);
      }
    }
  }
  if ($TEST) {
    print $handle "  Would have deleted line ID $bad\n" if ($VERBOSE);
  }
  else {
    $sth{DLINEPROP}->execute($bad);
    print $handle "  Line properties deleted\n" if ($sth{DLINEPROP}->rows && $DEBUG);
    $sth{DPUB}->execute($bad);
    print $handle "  Publishing names deleted\n" if ($sth{DPUB}->rows && $DEBUG);
    $sth{DEVENT}->execute($bad);
    print $handle "  Line event deleted\n" if ($sth{DEVENT}->rows && $VERBOSE);
    $sth{DLINE}->execute($bad);
    print $handle "  Line ID $bad deleted\n" if ($sth{DLINE}->rows && $VERBOSE);
  }
}
