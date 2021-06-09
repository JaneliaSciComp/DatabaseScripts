#!/usr/bin/perl
# ****************************************************************************
# Resource name:  sage_cv_editor_ajax.cgi
# Written by:     Rob Svirskas
# Revision level: 1.0
# Date released:  2009-05-14
# Description:    This program handles AJAX requests for CV term operations.
#                 Current requests:
#                 1) list_cv: return a popup menu containing a list of CVs 
#                 2) query_cv: return a table of CV terms for a given CV
#                    Input parameters:
#                      id: CV ID
#                      modify: true/false (true allows fields to be modified)
#                      admin: true/false (true allows fields to be added)
#                 3) update_cvterm:
#                    Input parameters:
#                      id: CV term ID
#                      value: new value
#                 4) add_cvterm:
#                    Input parameters:
#                      id: CV ID
#                      name: CV term name
#                      display_name: CV term display name
#                      data_type: CV term data type
#                      definition: CV term definition
#                      is_current: CV term current flag
#                 5) delete_cvterm:
#                    Input parameters:
#                      id: CV term ID
#                 The request type is sent in the "operation" parm.
# Input parms:    (see above)
#               
# Required resources:
#   Programs:       NONE
#   USEd modules:   strict
#                   warnings
#                   CGI
#                   DBI
#
#                               REVISION LOG
# ----------------------------------------------------------------------------
# | revision | name            | date    | description                       |
# ----------------------------------------------------------------------------
#     1.0     Rob Svirskas      09-22-17  Initial version
# ****************************************************************************

use strict;
use warnings;
use CGI qw/:standard/;
use DBI;
use Switch;


# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
use constant USER => 'sageApp';
my $PASS = 's@g3App';
use constant BLANK => '&nbsp;'x20;
my @DATATYPE = ('text','integer','float','boolean','pf','date_time','url',
                'array of integer','array of float');
my $DB = 'dbi:mysql:dbname=sage;host=';

#$DB .= (lc(param('database')) eq 'prod') ? 'mysql3' : 'db-dev';
switch (lc(param('database'))) {
  case 'dev' { $DB .= 'db-dev'; }
  case 'val' { $DB .= 'val-db'; }
  else       { $DB .= 'mysql3'; $PASS = 'h3ll0K1tty' }
}


my $dbh = DBI->connect($DB,USER,$PASS,{RaiseError=>1,PrintError=>0});
my $op = lc(param('operation'));
my $id = param('id');
  
if ($op eq 'list_cv') {
  print header(-expires => 'now');
  my $ar = $dbh->selectall_arrayref('SELECT id,name,display_name FROM cv ORDER BY 2');
  my %label;
  foreach (@$ar) {
    next if ($_->[1] =~ /_(?:abbreviations|synonyms|terms|obo)$/);
    $label{$_->[0]} = $_->[2];
  }
  my %cv = reverse %label;
  my @cv = ('',map { $cv{$_} } sort keys %cv);
  $label{''} = 'Select a CV...';
  print 'CV: ',
        popup_menu(-id => 'cv',
                   -labels   => \%label,
                   -values => \@cv,
                   -onChange => 'displayCVTerms();'),
        img({src   => '/images/loading.gif',
             style => 'display: none;',
             id    => 'loading'});
}
elsif ($op eq 'query_cv') {
  print header(-expires => 'now');
  my $sql = "SELECT name,display_name,definition,version FROM cv WHERE id=$id";
  my($name,$display,$definition,$version) = $dbh->selectrow_array($sql);
  # Get parent CV
#  $sql = 'SELECT id,display_name FROM cv_relationship_vw JOIN cv ON '
#         . "(cv.name=subject) WHERE relationship='sub_cv' AND "
#         . "object='$name'";
  $sql = 'SELECT id,display_name FROM cv_relationship_vw JOIN cv ON '
         . "(cv.name=object) WHERE relationship='is_sub_cv_of' AND "
         . "subject='$name'";
  my($pid,$parent) = $dbh->selectrow_array($sql);
  my @parent;
  push @parent,Tr(td(['Parent:',
                      a({-href => '#',
                         -onClick => "displayCVTerms($pid);"},$parent)]))
    if ($parent);
  # Get children CVs
#  $sql = 'SELECT id,display_name FROM cv_relationship_vw JOIN cv ON '
#         . "(cv.name=object) WHERE relationship='sub_cv' AND "
#         . "subject='$name'";
  $sql = 'SELECT id,display_name FROM cv_relationship_vw JOIN cv ON '
         . "(cv.name=subject) WHERE relationship='is_sub_cv_of' AND "
         . "object='$name'";
  my $ar = $dbh->selectall_arrayref($sql);
  my @child;
  foreach (@$ar) {
    my ($cid,$child) = @$_;
    push @child,a({-href => '#',
                   -onClick => "displayCVTerms($cid);"},$child);
  }
  if (scalar @child) {
    $a = join(', ',@child);
    @child = ();
    push @child,Tr(td(['Children:',$a]));
  }
  else {
  }
  # Get CV terms
  $sql = 'SELECT id,name,display_name,data_type,definition,is_current FROM '
         . "cv_term WHERE cv_id=$id ORDER BY 2";
  $ar = $dbh->selectall_arrayref($sql);
  print div({class => 'boxed'},
            hidden(-id=>'_cvid',-default=>$id),
            (sprintf '%s (%d term%s):',$name,scalar(@$ar),
                     (($#$ar) ? 's' : '')),
        br,
        table(@parent,@child,
              Tr(td(['Display name:',
                     div({id => 'cv_display'},$display||BLANK)])),
              Tr(td(['Definition:',
                     div({id => 'cv_definition'},$definition||BLANK)])),
              Tr(td(['Version:',$version])),
              Tr(td(['ID:',$id]))));
  exit(-1) unless (scalar @$ar);
  my @head = ('ID','Current','Name','Display name','Data type','Definition');
  unshift @head,'Delete?' if (param('admin'));
  my @row = (th(\@head));
  my %yn = (0 => 'N', 1 => 'Y');
  foreach (@$ar) {
    my ($delete,$current,$type);
    if (param('admin') || param('modify')) {
      $delete = img({id      => $_->[0],
                     src     => '/images/remove.png',
                     onClick => 'deleteData("' . $_->[0] . '");'})
        if (param('admin'));
      $current = popup_menu(-id       => $_->[0].'__is_current',
                            -labels   => \%yn,
                            -values   => [sort keys %yn],
                            -default  => $_->[5],
                            -onChange => 'changeData("'
                                         . $_->[0].'__is_current'
                                         . '","current flag");');
      $type = popup_menu(-id       => $_->[0].'__data_type',
                         -values   => \@DATATYPE,
                         -default  => $_->[3],
                         -onChange => 'changeData("'
                                      . $_->[0].'__data_type'
                                      . '","data type");');
    }
    else {
      $current = ($_->[5]) ? 'Y' : 'N';
      $type = $_->[3];
    }
    my @col = ($_->[0],
               $current,
               a({href => 'sage_cvterm_info.cgi?cvterm='.$_->[1],
                  target => '_blank'},$_->[1]),
               span({id => $_->[0].'__display_name'},$_->[2]||BLANK),
               $type,
               span({id => $_->[0].'__definition'},$_->[4]||BLANK));
    unshift @col,$delete if (param('admin'));
    push @row,td(\@col);
  }
  if ($parent) {
    $sql = 'SELECT id,name,display_name,data_type,definition,is_current FROM '
           . "cv_term WHERE cv_id=$pid ORDER BY 2";
    $ar = $dbh->selectall_arrayref($sql);
    if (scalar @$ar) {
      push @row,Tr(th({colspan => (param('admin')) ? 7 : 6},
                      "Terms from $parent"));
      foreach (@$ar) {
        my $link = a({href => 'sage_cvterm_info.cgi?cvterm='.$_->[1],
                     target => '_blank'},$_->[1]);
        if (param('admin')) {
          push @row,Tr(td(['',shift @$_,(pop @$_) ? 'Y' : 'N',
                           $_->[0],$_->[1],$_->[2]||'text',pop @$_]));
        }
        else {
          push @row,Tr(td([shift @$_,(pop @$_) ? 'Y' : 'N',
                           $_->[0],$_->[1],$_->[2]||'text',pop @$_]));
        }
      }
    }
  }
  print table({id => 'cvterms'},map {Tr($_)} @row);
}
elsif ($op eq 'update_cv' || $op eq 'update_cvterm') {
  print header(-expires => 'now');
  my $value = param('value');
  $value =~ s/^\s+//;
  $value =~ s/\s+$//;
  unless (length $value) {
    print BLANK;
    exit(0);
  }
  my $column;
  ($id,$column) = split('__',$id);
  my $table = ($op eq 'update_cv') ? 'cv' : 'cv_term';
  my $sql = "UPDATE $table SET $column='$value' WHERE id=$id";
  $dbh->do($sql);
  print $value;
}
elsif ($op eq 'add_cvterm') {
  my @fields = qw(display_name data_type definition is_current);
  my $name = param('name');
  my %hash = map { $_ => param($_)||'' } @fields;
  my $sql = 'INSERT INTO cv_term (cv_id,name,' . join(',',@fields)
            . ") VALUES ($id," . join(',',('?')x5) . ')';
  my $sth = $dbh->prepare($sql);
  $hash{is_current} = ($hash{is_current}) ? 1 : 0;
  eval { $sth->execute($name,@hash{@fields}); };
  &errorResponse("Could not insert new CV term\n$@") if ($@);
  print header,"Inserted new CV term $name";
}
elsif ($op eq 'delete_cvterm') {
  eval { $dbh->do("DELETE FROM cv_term WHERE id=$id"); };
  &errorResponse("Could not delete CV term\n$@") if ($@);
  print header,"Deleted CV term";
}
elsif ($op eq 'display_relationship'){
  print header(-expires => 'now');
  print button ( -value => 'Hide/Show is_a, part_of',
                 -onClick => 'hideBoring();'), br;
  my $sql_subject = "SELECT r.id, c.name, c3.name, c2.name FROM cv_term_relationship r JOIN cv_term c ON r.subject_id = c.id join cv ON cv.id = c.cv_id JOIN cv_term c2 ON (c2.id = r.object_id) JOIN cv_term c3 ON (c3.id = r.type_id) WHERE cv.id = $id ORDER BY 2";
  my $sql_object = "SELECT r.id, c2.name, c3.name, c.name FROM cv_term_relationship r JOIN cv_term c ON r.object_id = c.id JOIN cv ON cv.id = c.cv_id JOIN cv_term c2 ON (c2.id = r.subject_id) JOIN cv_term c3 ON (c3.id = r.type_id) WHERE cv.id = $id ORDER BY 2";
  my $sth_sub = $dbh->prepare($sql_subject);
  $sth_sub->execute();
  my $subjects = $sth_sub->fetchall_arrayref;
  my $sth_obj = $dbh->prepare($sql_object);
  $sth_obj->execute();
  my $objects = $sth_obj->fetchall_arrayref;
  #SUBJECT TABLE 
  if (scalar(@$subjects)){
    my @s_head =  ('Subject_Name', 'Relationship', 'Object_Name');
    unshift @s_head, 'Delete?' if (param('admin'));
    my @s_row = Tr(th(\@s_head));

    foreach my $i (@$subjects){
      my $boring = 0;
      my $r_id = shift @$i;
      my $delete = img({id      => $r_id,
                   src     => '/images/remove.png',
                   onClick => 'deleteRelationship("' . $r_id . '");'
                   });
      if (($i->[1] ne 'is_a') && ($i->[1] ne 'part_of')){
        unshift @$i, $delete if (param('admin'));
      }
      else{
        $boring = 1;
        unshift @$i, '' if (param('admin'));
      }      
      if ($boring){
        push @s_row, Tr({class=>'is_part'},td($i)); 
      }
      else{
        push @s_row, Tr(td($i)); 
      }
    } 
    print p(h3('Subject Relationship Table:')),
    table({id => 'subject_relationships'},map {$_} @s_row);
  }
  #OBJECT TABLE
  if (scalar(@$objects)){
   
    my @o_head =  ('Subject_Name', 'Relationship', 'Object_Name');
    unshift @o_head, 'Delete?' if (param('admin'));
    my @o_row = Tr(th(\@o_head));
  
    foreach my $i (@$objects){
      my $boring = 0;
      my $r_id = shift @$i;
      my $delete = img({id      => $r_id,
                   src     => '/images/remove.png',
                   onClick => 'deleteRelationship("' . $r_id . '");'
                   });
      if (($i->[1] ne 'is_a') && ($i->[1] ne 'part_of')){
        unshift @$i, $delete if (param('admin'));
      }
      else{
        $boring = 1;
        unshift @$i, '' if (param('admin'));
      }      
      if ($boring){ 
        push @o_row, Tr({class=>'is_part'},td($i)); 
      }
      else{
        push @o_row, Tr(td($i)); 
      }
    } 
    print p(h3('Object Relationship Table:')),
    table({id => 'object_relationships'},map {$_} @o_row);
  }
}
elsif ($op eq 'delete_relationship'){
  eval { $dbh->do("DELETE FROM cv_term_relationship WHERE id=$id"); };
  &errorResponse("Could not delete CV term relationship\n$@") if ($@);
  print header,"Deleted CV term relationship";
} 
elsif ($op eq 'term_relationship'){
  print header(-expires => 'now');
  my $sql = "SELECT id, name FROM cv_term WHERE cv_id=$id ORDER BY name";
  my $data = $dbh->selectall_arrayref($sql);

  my %labels;
  my @values;
  foreach my $i (@$data){
    $labels{$i->[0]} = $i->[1];
    push @values, $i->[0];
  }
  print popup_menu(-name => 'relationship_cv_term_menu',
                   -id => 'relationship_cv_term_menu',
                   -values => \@values,
                   -labels => \%labels);
}
elsif ($op eq 'cv_relationship'){
  print header(-expires => 'now');
  my $sql = "SELECT id, display_name FROM cv ORDER BY display_name";
  my $data = $dbh->selectall_arrayref($sql);
  my %labels;
  my @values;
  foreach my $i (@$data){
    $labels{$i->[0]} = $i->[1];
    push @values, $i->[0];
  }
  print popup_menu(-name => 'relationship_cv_menu',
                   -id => 'relationship_cv_menu',
                   -values => \@values,
                   -labels => \%labels,
                   -onChange => 'UpdateRelationshipCv();');

}
elsif ($op eq 'cv_term_relationship'){
  print header(-expires => 'now');
  my $sql = "SELECT id, name FROM cv_term where cv_id = $id ORDER BY name";
  my $data = $dbh->selectall_arrayref($sql);
  my %labels;
  my @values;
  foreach my $i (@$data){
    $labels{$i->[0]} = $i->[1];
    push @values, $i->[0];
  }
  print popup_menu(-name => 'r_object',
                   -id => 'r_object',
                   -values => \@values,
                   -labels => \%labels,
                  );
}
elsif ($op eq 'add_cvterm_relationship') {
  my @fields = qw(relationship_cv_term_menu r_type r_object);
  my $subject = param('id');
  my $relationship = param('type');
  my $object = param('object');
  my $sql_r = "SELECT id FROM cv_term_vw where cv_term='$relationship'";
  my $relationship_id = $dbh->selectrow_array($sql_r);
  my $sql = "INSERT INTO cv_term_relationship (type_id, subject_id, object_id, is_current) 
          VALUES ($relationship_id, $subject, $object, 1)";
  my $sth = $dbh->prepare($sql);
  eval { $sth->execute(); };
  &errorResponse("Could not insert new CV term\n$@") if ($@);
  print header,"Inserted new cv term relationship.";
}
exit(0);


sub errorResponse
{
  print header('text/html','400 Bad Request'),shift;
  exit(-1);
}
