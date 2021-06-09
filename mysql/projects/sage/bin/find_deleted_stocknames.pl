#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use JFRC::Utils::DB qw(:all);
use JFRC::Utils::SAGE qw(:all);

my $TEST = 1;

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
my $FLYF_SERVER = 'dbi:JDBC:hostname=prod1;port=9001';
my $FLYF_URL = 'jdbc:filemaker://10.40.2.26:2399/FLYF_2?user=flyf2&password=flycore';
# ****************************************************************************
# * Global variables                                                         *
# ****************************************************************************
my %sth = (
  LINE => 'SELECT id,name,flycore_id FROM line_vw WHERE flycore_id IS NOT NULL '
          . 'ORDER BY 1,2',
  IMAGE => 'SELECT name FROM image WHERE line_id=?',
  SESSION => 'SELECT name FROM session WHERE line_id=?',
  DPROP => 'DELETE FROM line_property WHERE line_id=?',
  DLINE => 'DELETE FROM line WHERE id=?',
);
my %sthf = (
  STOCKNAME => 'SELECT Stock_Name FROM StockFinder WHERE "__kp_UniqueID"=?',
);
my %sthl = (
  SESSION => 'SELECT name FROM session WHERE line_id=?',
);

# Initialize
&dbConnect(\our $dbh,'sage');
$sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
  foreach (keys %sth);
    $FLYF_URL =~ s/([=;])/uc sprintf("%%%02x",ord($1))/eg;
my $dbhf = DBI->connect(join(';url=',$FLYF_SERVER,$FLYF_URL),(undef)x2)
  or &terminateProgram($DBI::errstr);
$sthf{$_} = $dbhf->prepare($sthf{$_}) || &terminateProgram($dbhf->errstr)
 foreach (keys %sthf);
&dbConnect(\my $dbhl,'sage_larval');
$sthl{$_} = $dbhl->prepare($sthl{$_}) || &terminateProgram($dbhl->errstr)
  foreach (keys %sthl);

$sth{LINE}->execute;
my $ar = $sth{LINE}->fetchall_arrayref();
my($deleted,$mismatch,$missing) = (0)x3;
foreach my $sage (@$ar) {
  my($sage_id,$line,$uid) = @$sage;
  $sthf{STOCKNAME}->execute($uid);
  my($sn) = $sthf{STOCKNAME}->fetchrow_array();
  $sn ||= '';
  unless ($sn eq $line) {
    print "$line     $uid\n";
    print "  UID $uid has stock name [$line] in SAGE, but [$sn] in FLYF2\n";
    ($sn) ? $mismatch++ : $missing++;
    my($images,$sessions,$larval) = &getLineData($sage_id);
    if ($images || $sessions || $larval) {
      print "    Images: $images  Sessions: $sessions  Larval: $larval\n";
    }
    else {
      if ($TEST) {
        print "  Would have deleted line\n";
      }
      else {
        $sth{DPROP}->execute($sage_id);
        $sth{DLINE}->execute($sage_id);
        print "  Deleted line\n";
      }
      $deleted++;
    }
  }
}
print "Stocks in FLYF2 with mismatched line name in SAGE: $mismatch\n";
print "Lines in SAGE with no stock name in FLYF2: $missing\n";
print "Lines deleted from SAGE: $deleted\n";


sub getLineData
{
  my $id = shift;
  $sth{IMAGE}->execute($id);
  my $ar = $sth{IMAGE}->fetchall_arrayref();
  my $images = scalar(@$ar);
  $sth{SESSION}->execute($id);
  $ar = $sth{SESSION}->fetchall_arrayref();
  my $sessions = scalar(@$ar);
  $sthl{SESSION}->execute($id);
  $ar = $sthl{SESSION}->fetchall_arrayref();
  my $larval = scalar(@$ar);
  return($images,$sessions,$larval);
}
