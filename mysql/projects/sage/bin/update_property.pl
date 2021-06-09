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
my $itemtype = 'line';
# Database
my $SAGE = 'dbi:mysql:dbname=sage;host=mysql3';
our $dbh;
# Extras
my $is_current = 1;
my $data_type = "text";
my $rows = 0;

my %sth = (
  GETLINE => 'SELECT id FROM line WHERE name=?',
  GETIMAGE=> 'SELECT id FROM image WHERE name=?',
  LINE => 'INSERT INTO line_property (line_id,type_id,value) VALUES (?,?,?) '
          . 'ON DUPLICATE KEY UPDATE value=VALUES(value)',
  IMAGE => 'INSERT INTO image_property (image_id,type_id,value) VALUES (?,?,?) '
           . 'ON DUPLICATE KEY UPDATE value=VALUES(value)',
);


# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************
#
# Get the command-line parameters
&GetOptions('file=s'     => \my $input_file,
            'itemtype=s' => \$itemtype,
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
&processInput($input_file);
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
  my $glob_term = shift;
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
  if ($message) {
    print STDERR "$message\n";
  }
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
    my($item,$cv,$term,$value) = split(/\t/, $line);
    print "$item   $cv/$term   $value\n" if ($VERBOSE);
    if (!$item) {
      print "  Missing item on line $linenum\n";
      next;
    }
    elsif (!$cv) {
      print "  Missing CV on line $linenum\n";
      next;
    }
    elsif (!$term) {
      print "  Missing CV term  on line $linenum\n";
      next;
    }

    # Get item ID
    my $statement = ($itemtype eq 'line') ? 'GETLINE' : 'GETIMAGE';
    $sth{$statement}->execute($item);
    my $ar = $sth{$statement}->fetchall_arrayref();
    if (!scalar(@$ar)) {
      print $handle "  Item $item not found\n";
      next;
    }
    elsif (scalar(@$ar) > 1) {
      print $handle "  Item $item is not unique\n";
      next;
    }
    my $item_id = $ar->[0][0];
    # Get term ID
    my $term_id = &getCVTermID(CV=>$cv,TERM=>$term);
    unless ($term_id) {
      print $handle "  Could not find term ID for $cv/$term\n";
      next;
    }
    print $handle "  INSERT $item_id,$term_id,$value\n" if ($DEBUG);
    $statement =~ s/^GET//;
    my $rv = $sth{$statement}->execute($item_id,$term_id,$value);
    print $handle "  Result = $rv\n" if ($DEBUG);
    $rows++ if ($rv);
  }
  print $handle "$rows row(s) were inserted or updated\n";
}

# ****************************************************************************
# * POD documentation                                                        *
# ****************************************************************************
__END__

=head1 NAME

cvterm_loader.pl - load new terms into cv_term table

=head1 SYNOPSIS

cvterm_loader.pl      [-file <input file>] 
            [-output <output file>]
	    [-verbose] [-debug] [-help]

=head1 DESCRIPTION

This program will take a tab delimited terms that are to be entered into the 
cv_term table and bulk upload them into the table. The input file should be tab delimited with no header and the following columns: cv, new term, display name, definition. The display name and definition columns are optional. The display name will be copied from the new term if it is missing and the definition will be copied from the display name if available and the new term column if it is not available. The new terms will NOT be uploaded in the table if there is no cv_id for the cv or if the new term already exists for the cv specified, this will NOT stop terms that can be uploaded from uploading even if they are in the same file as incorrect terms.

=head1 RUN INSTRUCTIONS

Monitoring output goes to STDOUT, unless redirected by the -output parameter.
Error output goes to STDERR, unless redirected by the -error parameter
The following options are supported:

  -file:        (required) tab delimited file of terms to upload to cv_term
  -output:      (optional) send monitoring output to specified file
  -error:       (optional) send error output to specified file
  -verbose:     (optional) display monitoring output (chatty)
  -debug:       (optional) display monitoring output (chatty in the extreme)
  -help:        (optional) display usage help and exit

Options must be separated by spaces.

All output goes to STDOUT, unless redirected by the -output parameter.
All errors go to STDERR, unless redirected by the -error parameter.

=head1 EXAMPLES

The following command:

  perl cvterm_loader.pl -file input

=head1 EXIT STATUS

The following exit values are returned:

   0  Successful completion

  -1  An error occurred

=head1 BUGS

None known.

=head1 AUTHOR INFORMATION

Copyright 2011 by Howard Hughes Medical Institute

Author: Charlotte S. Weaver, HHMI Janelia Farm Research Campus

Address bug reports and comments to:
weaverc10@janelia.hhmi.org

=cut
