#!/usr/bin/perl

use strict;
use warnings;
use CGI qw/:standard :cgi-lib/;
use CGI::Session;

use JFRC::Utils::Web;

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant ANY  => '(any)';
use constant NBSP => '&nbsp;';

# General
my @DATATYPE = ('text','integer','float','boolean','pf','date_time','url',
                'array of integer','array of float');
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
our $APPLICATION = 'SAGE CV Editor';
my ($ADMIN,$MODIFY) = (0)x2;

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# General parameters
my $DATABASE = param('_database') || 'prod'; # Database

# Session authentication
my $Session = &JFRC::Utils::Web::establishSession(css_prefix => $PROGRAM);
&JFRC::Utils::Web::sessionLogout($Session) if (param('logout'));
# We have a session - can we edit CVs?
$ADMIN = ($Session->param('sage_cv_admin')) ? 1 : 0;
$MODIFY = ($Session->param('sage_cv_editor')) ? 1 : 0;

# Main processing
&getInput();

# We're done!
exit(0);


# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************

# ****************************************************************************
# * Subroutine:  getInput                                                    *
# * Description: This routine will prompt the user for search constraints.   *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub getInput
{
  # ----- Page header -----
  print &pageHeader(),start_form,&hiddenParameters();
  # ----- CV -----
  print div({&identify('cvarea')},NBSP),br;
  # ----- CV term -----
  print div({&identify('cvterm'),
             style=>'float:left;'},''),
        div({style=>'clear:both;'},NBSP);
  print div({&identify('add_cvterm'),
             class => 'boxed',
             style => 'display: none;'},
             h3({align => 'center'},'Add a new CV term'),br,
             table(
             Tr(td(['Name: ',input({&identify('name')}) . NBSP
                    . span({class => 'note'},'(required)')])),
             Tr(td(['Display name: ',input({&identify('display_name')})])),
             Tr(td(['Current: ',
                    checkbox(&identify('is_current'),
                             -checked => 1,
                             -value   => 1,
                             -label   => '')])),
             Tr(td(['Data type: ',
                    popup_menu(&identify('data_type'),
                               -values => \@DATATYPE)])),
             Tr(td(['Definition: ',input({&identify('definition'),
                                         -style => 'width: 40em;'})]))
             ),(br)x2,
             div({align => 'center'},
                 button(-value => 'Add',
                        -onClick => 'addCVTerm();'))
           ) if ($MODIFY);
  print div({style=>'clear:both;'},NBSP);
  print div({&identify('relationship_vw'),
            style => 'float:left'},''),
        div({style=>'clear:both;'},NBSP);
  print div({&identify('add_cvterm_relationship'),
             class => 'boxed',
             style => 'display: none;'
             },
             h3({align => 'center'},'Add a new CV term relationship'),br,
             table(
             Tr(td (['CV Term:', div({&identify('r_menu')})])),
             Tr(td ([radio_group( -name => 'r_type', 
                                                        -id => 'r_type',
                                                        -values => ['has_abbreviation','has_synonym'])])),
             Tr(td (['Object CV:', div({&identify('r_cv_menu')})])),
             Tr(td (['Object CV Term:', div({&identify('r_cv_term_menu')})])),
             Tr(td([''])),
             Tr(td(['',button(-value => 'Add Relationship',
                              -id => 'add_relationship',
                              -disabled => 'disabled',
                        -onClick => 'addRelationship();')]))

             )) if ($MODIFY);

  # ----- Footer -----
  print end_form,
        &JFRC::Utils::Web::sessionFooter($Session),end_html;
}


# ****************************************************************************
# * Subroutine:  identify                                                    *
# * Description: This routine will return a hash to identify an HTML element.*
# *                                                                          *
# * Parameters:  (unspecified): element name                                 *
# * Returns:     id/name hash                                                *
# ****************************************************************************
sub identify
{
  map { '-'.$_ => $_[0] } qw(id name);
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
  hidden(&identify('_database'),default=>$DATABASE),
  hidden(&identify('_modify'),default=>$MODIFY),
  hidden(&identify('_admin'),default=>$ADMIN);
}


# ****************************************************************************
# * Subroutine:  pageHeader                                                  *
# * Description: This routine will return the page header.                   *
# *                                                                          *
# * Parameters:  Named parameters                                            *
# *              title: page title                                           *
# *              mode:  mode (initial, list, or feather)                     *
# * Returns:     HTML                                                        *
# ****************************************************************************
sub pageHeader
{
  my %arg = (title => $APPLICATION,
             mode  => 'initial',
             @_);
  my @scripts = ({-language=>'JavaScript',-src=>'/js/sage_cv_editor.js'});
  my %load = ();
  my @styles = ();
  if ($arg{mode} eq 'initial') {
    $load{load} = 'displayCV();';
    push @scripts,map { {-language=>'JavaScript',-src=>"/js/$_.js"} }
                      qw(prototype);
    push @scripts,map { {-language=>'JavaScript',
                         -src=>"/js/scriptaculous/$_.js"} }
                      qw(scriptaculous effects);
    push @styles,map { Link({-rel=>'stylesheet',
                             -type=>'text/css','-href',@$_}) }
                     (['/css/fabtabulous.css']);
  }
  $arg{title} .= ' (Development)' if ($DATABASE eq 'dev');
  $arg{title} .= ' (Validation)' if ($DATABASE eq 'val');
  &JFRC::Utils::Web::pageHeader(title      => $arg{title},
                                css_prefix => $PROGRAM,
                                script     => \@scripts,
                                style      => \@styles,
                                expires    => 'now',
                                %load);
}
