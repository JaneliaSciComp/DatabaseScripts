#! /usr/bin/perl

use strict;
use warnings;

use parser('parse');
use loader('load_odor');

use DBI;
use Data::Dumper;

my $odorfile = '../data/odors.txt';
#my $labodorfile = '../data/labodors.txt';
#my $vialfile = '../data/vials.txt';

my $delimiter = '\t';

my $odordata = parse($odorfile,$delimiter);
load_odors($odordata);

#my $labodordata = parse($labodorfile,$delimiter);
#load_labodors($labodordata,$labtocompound);

#my $vialdata = parse($vialfile,$delimiter);
#load_vials($vialdata);


sub load_odors {
    my ($data) = (@_);

    my %labtocompound;
    my @odors;

    foreach my $line (@$data) {
        # remove whitespace from formula
	if (defined $line->[3]){    	
            $line->[3] =~ s/\s+//g;	
	}  

	# build lookup hash map of lab number to compound name
        #if (defined $line->[3]){    	
        #    $labtocompound{$line->[3]} = $line->[0];	
	#    }	    
	    
        # concat synonym with compound name
	$line->[1] = (defined $line->[1]) ? join(' ',$line->[0],$line->[1]) : $line->[0];
        #if (defined $line->[1]){    	
        #    $line->[1] = $line->[0] . ' ' . $line->[1];	
	#    } else {
	#    	$line->[1] = $line->[0];
	#    }	    
	    	    	    	    
    
        my %hash;
          
        @hash{qw(compound synonym lab_number cas_registry formula molecular_weight calc_vapor_press chem_group chem_class ventral descriptors monell_number firestein_number albianu_number m72_response bottle_number volume purity vendor price catalog_number recieved_date link)} = @$line; 
    
        push(@odors,\%hash);        
    }
    
    load_odor(\@odors);
    #print Dumper(\@odors);
    #return \%labtocompound;
    
}	

# deprecated with revised spreadsheet from Dima 
sub _load_labodors {
	my ($data,$odorlookup) = (@_);

    my @labodors;

    foreach my $line (@$data) {
 	    	       
        if (defined $line->[0]){    	
            $line->[2] = ${$odorlookup}{$line->[0]};            	
	    } else {
	    	$line->[2] = undef;
	    }
	    
	    if (defined $line->[6]){    	
            $line->[6] =~ s/\$//;  
            # print "$line->[0] -- $line->[6]\n";          	
	    }
	    
	     	    	       
        my %hash = (
            lab_number => $line->[0],
            volume => $line->[3],
            purity => $line->[4],
            vendor => $line->[5],
            price => $line->[6],
            catalog_number => $line->[7],
            recieved_date => $line->[8],
            odor => $line->[2]
        ); 
    
        push(@labodors,\%hash);        
    }
      
    load_labodor(\@labodors);  
    
}	

# deprecated with revised spreadsheet from Dima 
sub _load_vials {
	my ($data) = (@_);

    my @vials;

    foreach my $line (@$data) {
 	    	       	       
        my %hash = (
            vial_number => $line->[0],
            concentration => $line->[2],
            dilutant => $line->[3],
            lab_number => $line->[4]
        ); 
    
        push(@vials,\%hash);        
    }
       
    load_vial(\@vials);  
    
}	
