#!/usr/bin/perl
# Perl Built-ins
use strict;
use warnings;
use DBI;
use Getopt::Long;
use IO::File;
use IO::Select;
use Pod::Text;
use Pod::Usage;

# JFRC
use JFRC::Utils::SAGE qw(:all);

#****************************************************************************
#* Consants                                                                 *
#****************************************************************************
# Command-line parameters
my($DEBUG,$VERBOSE) = (0)x2;
my $EXTENSION = '.bz2';
# Database
my $SAGE = 'dbi:mysql:dbname=sage;host=mysql3';
our $dbh;
# Extras
my $is_current = 1;
my $data_type = "text";
my $rows = 0;

my %sth = (
  GETIMAGE => 'SELECT id,path,url FROM image WHERE name=?',
  UPDATE => 'UPDATE image SET path=?,url=? WHERE id=?',
  FILESIZE => 'INSERT INTO image_property (image_id,type_id,value) '
              . 'VALUES(?,?,?) ON DUPLICATE KEY UPDATE value=VALUES(value)',
);


# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************
#
# Get the command-line parameters
&GetOptions('file=s'     => \my $input_file,
            'item=s'     => \my $item,
            'output=s'   => \my $output_file,
            verbose      => \$VERBOSE,
	    debug        => \$DEBUG)
or pod2usage(-1);
$VERBOSE = 1 if ($DEBUG);

#Open the output stream
my $handle = ($output_file) ? (new IO::File $output_file,'>'
              or &terminateProgram("ERROR: could not open $output_file ($!)"))
                         : (new_from_fd IO::File \*STDOUT,'>'
              or &terminateProgram("ERROR: could not open STDOUT ($!)"));
autoflush $handle 1;

&dbConnect();
&processInput($item,$input_file);
&terminateProgram;


# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************


# ****************************************************************************
# * Subroutine:  dbConnect                                                   *
# * Description: This routine will connect to the specified database and     *
# *              prepare the statement.                                      *
# *                                                                          *
# * Parameters:                                                              *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub dbConnect
{
  print $handle "Connecting to $SAGE\n" if ($VERBOSE);
  $dbh = DBI->connect($SAGE,'sageApp','h3ll0K1tty');
  print $handle "Connected to ",$dbh->get_info(17),' ',
               $dbh->get_info(18),"\n" if ($VERBOSE);
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth); 
}

# ****************************************************************************
# * Subroutine:  processInput                                                *
# * Description: This routine will open the input stream (one or more files  *
# *              represented by a glob term, or STDIN).                      *
# *                                                                          *
# * Parameters:  glob_term: the glob term indicating the file(s) (optional)  *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub processInput
{
  my($item,$glob_term) = @_;
  if ($item) {
    &processStack($item);
    return;
  }
  if ($glob_term) {
    my @file_list = glob $glob_term;
    &terminateProgram("ERROR: no files matching $glob_term")
      if (! scalar @file_list);
    foreach my $file (@file_list) {
      my $stream = new IO::File $file,'<'
          or &terminateProgram("ERROR: Could not open $file ($!)");
      &processStream($stream);
    }
  }
  else {
    my $select = IO::Select->new(\*STDIN);
    &terminateProgram('ERROR: you must specify a file or provide input on '
                      . 'STDIN') unless ($select->can_read(0));
    my $stream = new_from_fd IO::File \*STDIN,'<'
        or &terminateProgram("ERROR: could not open STDIN ($!)");
    &processStream($stream);
  }
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
  $handle->close if ($handle);
  ref($sth{$_}) && $sth{$_}->finish foreach (keys %sth);
  $dbh->disconnect if ($dbh);
  exit(($message) ? -1 : 0);
}

# ****************************************************************************
# * Subroutine:  processStream                                               *
# * Description: This routine will process the input stream by executing the *
# *              specified statement for every line.                         *
# *                                                                          *
# * Parameters:  stream: input stream                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub processStream
{
my $stream = shift;
my $line;
my $rows = 0;
my $linenum = 0;

  while (defined($line = $stream->getline)) {
    $linenum++;
    chomp($line);
    my($stack) = split(/\t/,$line);
    print "$stack\n" if ($VERBOSE);
    $rows++ if &processStack($stack);
  }
  print $handle "$rows stack(s) were updated\n";
}


sub processStack
{
  my $stack = shift;
  # Get item ID
  $sth{GETIMAGE}->execute($stack);
  my $ar = $sth{GETIMAGE}->fetchall_arrayref();
  if (!scalar(@$ar)) {
    print $handle "  Stack $stack not found\n";
    return(0);
  }
  elsif (scalar(@$ar) > 1) {
    print $handle "  Stack $stack is not unique\n";
    return(0);
  }
  my($item_id,$path,$url) = @{$ar->[0]};
  print $handle "$stack\n" if ($DEBUG);
  unless ($path =~ /$EXTENSION$/) {
    $path .= $EXTENSION;
    unless (-s $path) {
      print $handle "  Cannot find $path on filesystem\n";
      return(0);
    }
  }
  my $filesize = (-s $path);
  print "  $path ($filesize)\n" if ($DEBUG);
  unless ($url =~ /$EXTENSION$/) {
    $url .= $EXTENSION;
    print "  $url\n" if ($DEBUG);
  }
  # Get term ID
  my($cv,$term) = ('light_imagery','file_size');
  my $term_id = &getCVTermID(CV=>$cv,TERM=>$term);
  unless ($term_id) {
    print $handle "  Could not find term ID for $cv/$term\n";
    next;
  }
  my $rv = $sth{UPDATE}->execute($path,$url,$item_id);
  printf $handle "  Rows updated: %d\n",$rv if ($DEBUG);
  return(1);
}
