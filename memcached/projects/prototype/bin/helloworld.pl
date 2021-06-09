#! /usr/bin/perl

use Cache::Memcached;
use DBI;
use Data::Dumper;

# Configure the memcached server
my $cache = new Cache::Memcached { 'servers' => [ 'localhost:11211', ]
                                   ,
                                 };

# Get the image name from the command line
# memcached keys must not contain spaces, so create
# a key name by replacing spaces with underscores

my $image = shift or die "Must specify the image name\n";
my $imagekey = $image;
$imagekey =~ s/ /_/;

# Load the data from the cache

my $imagedata = $cache->get($imagekey);

# If the data wasn't in the cache, then we load it from the database

if (!defined($imagedata))
{
    $imagedata = load_imagedata($image);

    if (defined($imagedata))
    {

# Set the data into the cache, using the key

	if ($cache->set($imagekey,$imagedata))
        {
            print STDERR "Image data loaded from database and cached\n";
        }
        else
        {
            print STDERR "Couldn't store to cache\n";
	}
    }
    else
    {
     	die "Couldn't find $image\n";
    }
}
else
{
    print STDERR "Image data loaded from Memcached\n";
    print Dumper($imagedata);
}

sub load_imagedata
{
    my ($image) = @_;

    my $dsn = "DBI:mysql:database=nighthawk;host=localhost;port=3306";

    $dbh = DBI->connect($dsn, 'nighthawkAdmin','nighthawkAdmin');

    my ($imagebase) = $dbh->selectrow_hashref(sprintf('select * from image where name = %s',
                                                     $dbh->quote($image)));

    if (!defined($image))
    {
     	return (undef);
    }

    $imagebase->{properties} =
	$dbh->selectall_hashref(sprintf('select image_property.* from image_property join image on (image.id = image_id and image.id = %s )',
                                         $dbh->quote($imagebase->{id})),1);

    return($imagebase);
}

