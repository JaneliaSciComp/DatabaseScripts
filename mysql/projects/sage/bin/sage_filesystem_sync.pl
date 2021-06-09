#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use Getopt::Long;
use IO::File;
use Pod::Text;
use Pod::Usage;

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
my $DB = 'dbi:mysql:dbname=sage;host=';

# ****************************************************************************
# * Global variables                                                         *
# ****************************************************************************
# Command-line parameters
my($DEBUG,$DEV,$UPDATE,$VERBOSE) = ('')x4;
my $FAMILY = 'rubin_chacrm';
# Database
my $dbh;
my %sth = (
IMAGE => 'SELECT id,name,path,url FROM image_vw WHERE family=? ORDER BY 1',
UPDATE => 'UPDATE image SET path=? WHERE id=?',
);
# General
my %count;

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Get the command-line parameters
GetOptions('family=s'  => \$FAMILY,
           'output=s'  => \my $output_file,
           'error=s'   => \my $error_file,
           update      => \$UPDATE,
           development => \$DEV,
           verbose     => \$VERBOSE,
           debug       => \$DEBUG,
           help        => \my $HELP)
  or pod2usage(-1);

# Open the output stream
my $handle = ($output_file) ? (new IO::File $output_file,'>'
              or &terminateProgram("ERROR: could not open $output_file ($!)"))
                         : (new_from_fd IO::File \*STDOUT,'>'
              or &terminateProgram("ERROR: could not open STDOUT ($!)"));
autoflush $handle 1;
my $ehandle = ($error_file) ? (new IO::File $error_file,'>'
               or &terminateProgram("ERROR: could not open $error_file ($!)"))
                          : (new_from_fd IO::File \*STDERR,'>'
               or &terminateProgram("ERROR: could not open STDERR ($!)"));
autoflush $ehandle 1;

$VERBOSE = 1 if ($DEBUG);
&initialize();
&processFamily();
foreach (sort keys %count) {
  print $handle "$_: $count{$_}\n";
}
&terminateProgram();


# ****************************************************************************
# * Subroutine:  initialize                                                  *
# * Description: This routine will initialize CV term values for use with    *
# *              ChaCRM. Values go in the %cvterm hash. It will also         *
# *              initialize a database handle for use with the SAGE          *
# *              database and configure XML.                                 *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub initialize
{
  # Initialize SAGE database
  $DB .= ($DEV) ? 'dev-db' : 'mysql3';
  $dbh = DBI->connect($DB,'sageApp','h3ll0K1tty',{RaiseError=>1,PrintError=>0});
  print $handle "Connected to $DB:",$dbh->get_info(17),' ',
                $dbh->get_info(18),"\n" if ($DEBUG);
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth);
}


# ****************************************************************************
# * Subroutine:  terminateProgram                                            *
# * Description: This routine will gracefully terminate the program. If a    *
# *              message is passed in, we exit with a code of -1. Otherwise, *
# *              we exit with a code of 0.                                   *
# *                                                                          *
# * Parameters:  message: the error message to print                         *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub terminateProgram
{
  my $message = shift;
  print STDERR "$message\n" if ($message);
  exit(($message) ? -1 : 0);
}


sub processFamily
{
  $sth{IMAGE}->execute($FAMILY);
  my $ar = $sth{IMAGE}->fetchall_arrayref();
  my $total = scalar(@$ar);
  print $handle "Images found: $total\n";
  my $image_num = 0;
  foreach (@$ar) {
  	$image_num++;
  	print "Images processed: $image_num\n"
  	  if ((!($image_num % 100)) && $VERBOSE);
    my($id,$name,$path,$url) = @$_;
    unless ($path) {
      print $ehandle "$id ($name) has no path\n";
      $count{no_path}++;
      next;
    }
    print $handle "$name ($id): $path\n" if ($DEBUG);
    my $exists = (-e $path);
    if (($FAMILY =~ /truman/) && !$exists) {
      $path =~ s/tier2\/flylight\/LarvalScreen/archive\/flylight\/larvalscreen/;
      $exists = (-e $path);
      if ($exists) {
        print $handle "Change pathing\n";
        $sth{UPDATE}->execute($path,$id) if ($UPDATE);
      }
    }
    unless ($exists) {
      print $ehandle "$id: $path does not exist\n";
      $count{missing}++;
      next;
    }
    my $size = (-s $path);
        unless ($size) {
      print $ehandle "$id: $path is empty\n";
      $count{empty}++;
      next;
    }
    unless (-l $path) {
      $count{correct}++;
      next;
    }
    my $this_path = $path;
    my $actual_path = '';
    while (!$actual_path) {
      $actual_path = readlink $this_path;
      if (-e $actual_path) {
      	$this_path = $actual_path;
      	print $handle "  $actual_path\n" if ($DEBUG);
      	if (-l $this_path) {
          $actual_path = '';
      	}
      	else {
      	  $count{link}++;
      	}
      }
      else {
        print $ehandle "$id: $actual_path (link) does not exist\n";
        next;
      }
    }
    $size = (-s $actual_path);
    unless ($size) {
      print $ehandle "$id: $actual_path is empty\n";
      next;
    }
    if ($UPDATE) {
      $sth{UPDATE}->execute($actual_path,$id);
      my $rows = $sth{UPDATE}->rows;
      if ($rows) {
        $count{changed}++;
      }
      else {
      	print $ehandle "Could not update $name to $actual_path\n";
        $count{update_error}++;
      }
    }
    else {
      print $handle "  Update $name to $actual_path\n" if ($DEBUG);
    }
  }
}
