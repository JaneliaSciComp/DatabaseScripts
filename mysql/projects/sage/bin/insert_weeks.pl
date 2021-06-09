#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use JFRC::DB::SAGE::Line;

my $db = JFRC::DB::SAGE::DB->new;
my $dbh = $db->dbh;
foreach my $year (2006..2016) {
  my $format = "SELECT DATE_FORMAT('%8d','%%Y%%u') FROM dual";
  my($start) = $dbh->selectrow_array(sprintf($format,$year.'0101',$year.'0101'));
  my($stop) = $dbh->selectrow_array(sprintf($format,$year.'1231',$year.'1231'));
  foreach ($start..$stop) {
    $dbh->do("INSERT INTO week_number (week) VALUES(" . $_ . ")");
    print "$_\n";
  }
}
