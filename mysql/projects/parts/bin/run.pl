#! /usr/bin/perl

use strict;
use warnings;

use parser('parse');
use loader('load_part');

use DBI;
use Data::Dumper;

my $partfile = '../data/parts.txt';

my $delimiter = '\t';

my $partdata = parse($partfile,$delimiter);
load_parts($partdata);

sub load_parts {
    my ($data) = (@_);

    my @parts;

    foreach my $line (@$data) {
        # remove whitespace from formula
	#if (defined $line->[3]){    	
        #    $line->[3] =~ s/\s+//g;	
	#}  

        # concat synonym with compound name
	#$line->[1] = (defined $line->[1]) ? join(' ',$line->[0],$line->[1]) : $line->[0];
    

        my %hash = (
            create_date => $line->[0],
            part_number => $line->[1],
            description => $line->[2],
            model_file  => $line->[3],
            revision    => 0
        );
          
        push(@parts,\%hash);        

        if (defined $line->[4]) {

            my %hash = (
                create_date => $line->[4],
                part_number => $line->[1],
                description => $line->[2],
                model_file  => $line->[3],
                revision    => 1
            );
            push(@parts,\%hash);
        }


        if (defined $line->[5]) {

            my %hash = (
                create_date => $line->[5],
                part_number => $line->[1],
                description => $line->[2],
                model_file  => $line->[3],
                revision    => 2
            );
            push(@parts,\%hash);
        }


        if (defined $line->[6]) {

            my %hash = (
                create_date => $line->[6],
                part_number => $line->[1],
                description => $line->[2],
                model_file  => $line->[3],
                revision    => 3
            );
            push(@parts,\%hash);
        }

    }
    
    load_part(\@parts);
    #print Dumper(\@parts);
    
}	
