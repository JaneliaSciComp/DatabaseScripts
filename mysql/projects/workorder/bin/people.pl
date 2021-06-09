#! /usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

my $ldapquery = `/usr/bin/ldapsearch -h ldap.int.janelia.org -x -LL -b ou=People,dc=janelia,dc=org -s sub cn sn givenName displayName mail employeeNumber departmentNumber`;

my $persons = parse_ldapquery_results($ldapquery);

#print "size of array: " . @$persons . ".\n";

write2csv($persons);

sub parse_ldapquery_results {
    my ($data) = (@_);

    my @people = split(/\n/, $data);
    
    my @persons = ();
    my $firstrecord = 1;
    my $substring=": ";
    my $dn = '';
    my $cn = '';
    my $sn = '';
    my $givenName = '';
    my $displayName = '';
    my $mail = '';
    my $employeeNumber = '';
    my $departmentNumber = '';

    foreach my $line (@people) {
   
        if ($line =~ m/^dn: cn=\w+/) {
           if ($firstrecord) {
               $firstrecord = 0;

               my $location=index($line,$substring) + 1;
               $dn = substr($line,$location);
               $dn =~ s/^\s*//; 

           } else {
                 if ($employeeNumber ne '') {

                     my %person = ( dn                => $dn
                                  , cn                => $cn
                                  , sn                => $sn
                                  , givenName         => $givenName
                                  , displayName       => $displayName
                                  , mail              => $mail
                                  , employeeNumber    => $employeeNumber
                                  , departmentNumber  => $departmentNumber
                                  );

                     push(@persons, \%person); 

                     $dn = '';
                     $cn = '';
                     $sn = '';
                     $givenName = '';
                     $displayName = '';
                     $mail = '';
                     $employeeNumber = '';
                     $departmentNumber = '';
                 }

                 my $location=index($line,$substring) + 1;
                 $dn = substr($line,$location);
                 $dn =~ s/^\s*//; 

           }
 
        } elsif  ($line =~ m/^cn: \w+/) {
              my $location=index($line,$substring) + 1;
              $cn = substr($line,$location);
              $cn =~ s/^\s*//; 
          }
          elsif  ($line =~ m/^sn: \w+/) {
              my $location=index($line,$substring) + 1;
              $sn = substr($line,$location);
              $sn =~ s/^\s*//; 
          }
          elsif  ($line =~ m/^givenName: \w+/) {
              my $location=index($line,$substring) + 1;
              $givenName = substr($line,$location);
              $givenName =~ s/^\s*//; 
          }
          elsif  ($line =~ m/^displayName: \w+/) {
              my $location=index($line,$substring) + 1;
              $displayName = substr($line,$location);
              $displayName =~ s/^\s*//; 
          }
          elsif  ($line =~ m/^mail: \w+/) {
              my $location=index($line,$substring) + 1;
              $mail = substr($line,$location);
              $mail =~ s/^\s*//; 
          }
          elsif  ($line =~ m/^employeeNumber: \w+/) {
              my $location=index($line,$substring) + 1;
              $employeeNumber = substr($line,$location);
              $employeeNumber =~ s/^\s*//; 
          }
          elsif ($line =~ m/^departmentNumber: \w+/) {
              my $location=index($line,$substring) + 1;
              $departmentNumber = substr($line,$location);
              $departmentNumber =~ s/^\s*//; 
          }
    } 

    return \@persons;
}


sub write2csv {
    my ($data) = (@_);

    my $file = "People.csv";
    open( my $OUT , '>' , $file ) or die( "Can't open $file ($!)" );
        print $OUT 'Username' . ',' . 'Last Name' . ','  . 'First Name' . ',' . 'Display Name' . ',' . 'Email' . ',' . 'Department Code';
        print $OUT "\n";
    foreach my $person (@$data) {
        print $OUT $person->{cn} . ',' . $person->{sn} . ','  . $person->{givenName} . ',' . $person->{displayName} . ',' . $person->{mail} . ',' . $person->{departmentNumber};
        print $OUT "\n";
    }
   close $OUT;
}

