#! /usr/bin/perl
package parser;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = ( "parse" );

# function parses file and returns array of arrays
sub parse {
    my( $file,$delimiter) = ( @_ );

    open (my $IN, $file) or die( "Can't open $file ($!)" );
        
        my $header = <$IN>;
        
        my @lines;
        while ( my $input = <$IN> ) {
            chomp $input;
            # remove double quotes
            $input =~ s/"//g;          
            my @line = split ($delimiter,$input);
            # remove leading and trailing whitespace
            foreach (@line) {
            	$_ =~ s/^\s+|\s+$//g;
            	# set to undef if empty srting
            	if ($_ eq '') {
		           $_ = undef;
	            }
            }
            push(@lines,\@line) if exists $line[0];                           
        }
    
    close $IN;
    return (\@lines);
}

=pod

=head4 DESCRIPTION

parse(file,delimiter) will parse 

=head1 AUTHOR

Tom Dolafi, dolafit@janelia.hhmi.org

=cut
