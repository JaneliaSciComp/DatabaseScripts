#! /usr/bin/perl
package loader;

use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = ( "load_part");

use DBI;

# function
sub load_part {
    my( $parthashes) = ( @_ );

    # database handle
    my $dbh = DBI->connect( "DBI:mysql:parts:db-dev", "partsApp", "partsApp" , { PrintError => 1 , RaiseError => 0 } );
    my $sth;
    my @row;

    # prepare insert statement
    $sth = $dbh->prepare( "INSERT INTO part (project_id,engineer_id,part_number,revision,description,model_file,create_date) 
                           VALUES (154,27,?,?,?,?,str_to_date(?,\"%m/%d/%Y\"))" );
                           
    # insert
    foreach my $parthash (@$parthashes) {

	    $sth->execute($parthash->{part_number}
	                 ,$parthash->{revision}
	                 ,$parthash->{description}
	                 ,$parthash->{model_file}
	                 ,$parthash->{create_date}
	                 );
    }
    
    # close statement and database handle
    $sth->finish();
    $dbh->disconnect();
}

=pod

=head4 DESCRIPTION

load_part(parthash) 

=head1 AUTHOR

Tom Dolafi, dolafit@janelia.hhmi.org

=cut
