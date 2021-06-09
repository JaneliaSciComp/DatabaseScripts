#! /usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

my $file = 'vs.csv';
my $delimiter = ',';
my $projects = parse($file,$delimiter);

write2csv($projects);

sub parse {
    my( $file,$delimiter) = ( @_ );

    open (my $IN, $file) or die( "Can't open $file ($!)" );


        my @lines;
        while ( my $input = <$IN> ) {
            chomp $input;
            my @line = split ($delimiter,$input);
            # remove leading and trailing whitespace
            foreach (@line) {
                $_ =~ s/^\s+|\s+$//g;
                # set to undef if empty srting
                if ($_ eq '') {
                           $_ = undef;
                    }
            }

            if (exists $line[0]) {
                if ($line[0] =~ m/^09/) {
                    if ($line[1] =~ m/^JVS/) {
                        if (!defined $line[5]) {
                            push(@lines,\@line);
                        }
                        if (defined $line[5]) {
                           if ($line[5] !~ m/^expired/) {
                              if ($line[5] !~ m/^pending/) {
                                 push(@lines,\@line);
                              }
                            }
                        }
                    }
                }
            }
        }

    close $IN;
    return (\@lines);
}


sub write2csv {
    my ($data) = (@_);

    my $file = "Project.csv";
    open( my $OUT , '>' , $file ) or die( "Can't open $file ($!)" );
        print $OUT 'Dept' . ',' . 'Project' . ','  . 'Description';
        print $OUT "\n";
    foreach my $project (@$data) {
         #print Dumper($project[0]);
        print $OUT @$project[0] . ',' . @$project[1] . ','  . @$project[2];
        print $OUT "\n";
    }
   close $OUT;
}
