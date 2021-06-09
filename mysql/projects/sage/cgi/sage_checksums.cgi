#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;
use DBI;
use HTTP::Date;
use HTTP::Date qw(time2iso time2isoz str2time);

use JFRC::Utils::Web qw(:all);

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant NBSP => '&nbsp;';
my $DB = 'dbi:mysql:dbname=sagecoa;host=';

# General
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE Checksums';

# ****************************************************************************
# * Globals                                                                  *
# ****************************************************************************
# Parameters
my $DATABASE;
my %sth = (
PRESENT => 'SELECT family,count(1) FROM sage.image_vw i '
           . 'JOIN sage.secondary_image si ON (i.id=si.image_id) '
           . 'JOIN sage_checksum ON (sage_identifier=si.id) group by 1',
MISSINGC => 'SELECT i.family,count(1) FROM sage.secondary_image_vw si '
            . 'JOIN sage.image_vw i ON (i.id=si.image_id) WHERE '
            . 'si.id NOT IN (SELECT sage_identifier FROM sage_checksum) '
            . 'GROUP BY 1',
MISSINGS => 'SELECT sage_entity,sage_identifier,checksum FROM sage_checksum '
            . 'WHERE sage_identifier NOT IN '
            . '(SELECT id FROM sage.secondary_image) ORDER BY 1',
);

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Session authentication
my $Session = &establishSession(css_prefix => $PROGRAM);
&sessionLogout($Session) if (param('logout'));
&terminateProgram('You do not have access to SAGE data security functions. '
                    . 'If you need access, contact Rob Svirskas.')
  unless ($Session->param('sage_datasec'));

# Connect to database
$DATABASE = lc(param('_database') || 'prod');
$DB .= ($DATABASE eq 'prod') ? 'mysql3' : 'db-dev';
my $dbh = DBI->connect($DB,'secretsquirrel','w@yn3',{RaiseError=>1,PrintError=>0});
$sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
  foreach (keys %sth);

# Main processing
&showDashboard();

# We're done!
if ($dbh) {
  ref($sth{$_}) && $sth{$_}->finish foreach (keys %sth);
  $dbh->disconnect;
}
exit(0);


# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************

# ****************************************************************************
# * Subroutine:  showDashboard                                               *
# * Description: This routine will show the dashboard.                       *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub showDashboard
{
sub inputTabTitle { ($a = shift) =~ s/_/ /g; $a; }

  # ----- Page header -----
  print &pageHead(),start_form,&hiddenParameters();

  my $panel;
  # Present
  $sth{PRESENT}->execute();
  my $ar = $sth{PRESENT}->fetchall_arrayref();
  my $total = 0;
  $total += $_->[1] foreach @$ar;
  push @$ar,[map {span({style => 'font-weight:bold;'},$_)} ('TOTAL',$total)];
  $panel .= div({style => 'float: left; padding-right: 15px;'},
        h3('Checksums stored'),
        table({class => 'sortable',&identify('standard')},
              Tr(th(['Family','Checksums'])),
              map { Tr(td([$_->[0],&commify($_->[1])])) } @$ar));
  pop @$ar;
  # Missing from SAGECOA
  $sth{MISSINGC}->execute();
  $ar = $sth{MISSINGC}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
                h3('Secondary images without checksums'),
                ((scalar @$ar)
                 ? table({class => 'sortable',&identify('standard')},
                         Tr(th(['Family','Checksums'])),
                         map { Tr(td([$_->[0],&commify($_->[1])])) } @$ar)
                : span({class => 'success'},'NONE FOUND')));
  # Missing from SAGE
  $sth{MISSINGS}->execute();
  $ar = $sth{MISSINGS}->fetchall_arrayref();
  $panel .= div({style => 'float: left; padding-right: 15px;'},
                h3('Checksums without secondary images'),
                ((scalar @$ar)
                 ?  table({class => 'sortable',&identify('standard')},
                          Tr(th(['Entity','SAGE ID','Checksum'])),
                          map { Tr(td($_)) } @$ar)
                : span({class => 'success'},'NONE FOUND')));
  print $panel;

  # ----- Footer -----
  print div({style => 'clear: both;'},NBSP),end_form,
        &sessionFooter($Session),end_html;
}


sub commify
{
  my $text = reverse $_[0];
  $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
  return scalar reverse $text;
}


# ****************************************************************************
# * Subroutine:  hiddenParameters                                            *
# * Description: This routine will return HTML for hidden parameters.        *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub hiddenParameters
{
  hidden(&identify('_database'),default=>$DATABASE);
}


# ****************************************************************************
# * Subroutine:  pageHead                                                    *
# * Description: This routine will return the page header.                   *
# *                                                                          *
# * Parameters:  Named parameters                                            *
# *              title: page title                                           *
# *              mode:  mode (initial, list, or feather)                     *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub pageHead
{
  my %arg = (title => $APPLICATION,
             mode  => 'initial',
             @_);
  my @scripts = ();
  my @styles = ();
  if ($arg{mode} eq 'initial') {
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                      qw(sorttable d3/d3.min d3/d3.layout.min);
    push @styles,map { Link({-rel=>'stylesheet',
                             -type=>'text/css','-href',@$_}) }
                     (["/css/d3.css"]);
  }
  $arg{title} .= ' (Development)' if ($DATABASE eq 'dev');
  &pageHeader(title      => $arg{title},
              css_prefix => $PROGRAM,
              script     => \@scripts,
              style      => \@styles,
              expires    => 'now');
}
