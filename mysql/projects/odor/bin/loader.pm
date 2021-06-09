#! /usr/bin/perl
package loader;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = ( "load_odor");

use DBI;

# function
sub load_odor {
    my( $odorhashes) = ( @_ );

    # database handle
    my $dbh = DBI->connect( "DBI:mysql:odor:db-dev", "odorApp", "0d0rApp" , { PrintError => 1 , RaiseError => 0 } );
    my $sth;
    my @row;

    # prepare insert statement
    $sth = $dbh->prepare( "INSERT INTO odor (compound,synonym,lab_number,cas_registry,formula,molecular_weight,chem_group,chem_class,ventral,monell_number,firestein_number,albianu_number,calc_vapor_press,descriptors,m72_response,bottle_number,volume,purity,vendor,price,catalog_number,recieved_date,link) 
                           VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,str_to_date(?,\"%m/%d/%Y\"),?)" );
                           
    # insert
    foreach my $odorhash (@$odorhashes) {

	    $sth->execute($odorhash->{compound}
	                 ,$odorhash->{synonym}
	                 ,$odorhash->{lab_number}
	                 ,$odorhash->{cas_registry}
	                 ,$odorhash->{formula}
	                 ,$odorhash->{molecular_weight}
	                 ,$odorhash->{chem_group}
	                 ,$odorhash->{chem_class}
	                 ,$odorhash->{ventral}
	                 ,$odorhash->{monell_number}
	                 ,$odorhash->{firestein_number}
	                 ,$odorhash->{albianu_number}
	                 ,$odorhash->{calc_vapor_press}
	                 ,$odorhash->{descriptors}
	                 ,$odorhash->{m72_response}
	                 ,$odorhash->{bottle_number}
	                 ,$odorhash->{volume}
                         ,$odorhash->{purity}
                         ,$odorhash->{vendor}
                         ,$odorhash->{price}
                         ,$odorhash->{catalog_number}
                         ,$odorhash->{recieved_date}
                         ,$odorhash->{link}
	                 );
    }
    
    # close statement and database handle
    $sth->finish();
    $dbh->disconnect();
}

# deprecated with new version of spreadsheet from Dima
sub _load_labodor {
    my( $labodorhashes) = ( @_ );

    # database handle
    my $dbh = DBI->connect( "DBI:mysql:odor:db-dev", "odorApp", "odorApp" , { PrintError => 1 , RaiseError => 0 } );
    my $sth;
    my @row;

    # prepare insert statement
    $sth = $dbh->prepare( "INSERT INTO lab_odor (lab_number,volume,purity,price,vendor,catalog_number,recieved_date,compound) 
                           SELECT  ?,?,?,?,?,?,str_to_date(?,\"%m/%d/%Y\"),compound
                           FROM odor
                           WHERE compound = ?" );
                           
    # insert
    foreach my $labodorhash (@$labodorhashes) {

	    $sth->execute($labodorhash->{lab_number}
	                 ,$labodorhash->{volume}
	                 ,$labodorhash->{purity}
	                 ,$labodorhash->{price}
	                 ,$labodorhash->{vendor}
	                 ,$labodorhash->{catalog_number}
	                 ,$labodorhash->{recieved_date}
	                 ,$labodorhash->{odor}
	                 );
    }

    # close statement and database handle
    $sth->finish();
    $dbh->disconnect();
}

# deprecated with new version of spreadsheet from Dima
sub load_vial {
    my( $vialhashes) = ( @_ );

    # database handle
    my $dbh = DBI->connect( "DBI:mysql:odor:db-dev", "odorApp", "odorApp" , { PrintError => 1 , RaiseError => 0 } );
    my $sth;
    my @row;

    # prepare insert statement
    $sth = $dbh->prepare( "INSERT INTO vial (vial_number,concentration,dilutant,lab_number,compound) 
                           SELECT  ?,?,?,lab_number,compound
                           FROM lab_odor
                           WHERE lab_number = ?" );
                           
    # insert
    foreach my $vialhash (@$vialhashes) {

	    $sth->execute($vialhash->{vial_number}
	                 ,$vialhash->{concentration}	                 
	                 ,$vialhash->{dilutant}
	                 ,$vialhash->{lab_number}
	                 );
    }

    # close statement and database handle
    $sth->finish();
    $dbh->disconnect();
}

=pod

=head4 DESCRIPTION

load_odor(odorhash) 

=head1 AUTHOR

Tom Dolafi, dolafit@janelia.hhmi.org

=cut
