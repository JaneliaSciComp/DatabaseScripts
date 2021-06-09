#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use LWP::Simple;

use constant DATA_PATH => '/opt/informatics/data/';
my $file = DATA_PATH . 'rest_services.json';
open SLURP,$file or &terminateProgram("Can't open $file: $!");
sysread SLURP,my $slurp,-s SLURP;
close(SLURP);
my $hr = decode_json $slurp;
my %CONFIG = %$hr;

# SAGE
my $rest = "$CONFIG{sage}{url}/lines?_columns=name";
my $response = get $rest;
die("REST GET [$rest] returned null response")
  unless (length($response));
my $rvar;
eval {$rvar = decode_json($response)};
my %sage = map { $_->{name} => 1 } @{$rvar->{line_data}};

# FLYF2
$rest = "$CONFIG{flycore}{url}?request=linelist";
$response = get $rest;
die("REST GET [$rest] returned null response")
  unless (length($response));
eval {$rvar = decode_json($response)};
my $ar = $rvar->{lines};
my %flycore = map { $_ => 1 } @$ar;

# Compare
foreach (sort keys %flycore) {
  print "$_\n" unless (exists $sage{$_});
}
