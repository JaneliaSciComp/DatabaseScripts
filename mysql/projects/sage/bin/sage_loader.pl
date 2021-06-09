#!/bin/env perl
# ****************************************************************************
# Resource name:  sage_loader
# Written by:     Rob Svirskas
# Revision level: 1.40 (also stored in $VERSION)
# Date released:  2018-12-21
# Description:    See the bottom of this file for the POD documentation.
#                 Search for the string '=head'.
# Required resources:
#   Programs:        NONE
#   USEd modules:    strict
#                    warnings
#                    DBI
#                    File::Basename
#                    Getopt::Long
#                    Image::Size
#                    IO::File
#                    JSON
#                    Kafka::Connection
#                    Kafka::Producer
#                    LWP::UserAgent
#                    Parse::RecDescent
#                    Pod::Text
#                    Pod::Usage
#                    POSIX
#                    Scalar::Util
#                    Switch
#                    Sys::Hostname
#                    Try::Tiny
#                    URI::Escape;
#                    XML::Simple
#                    JFRC::Utils::SAGE
#                    JFRC::DB::ChaCRM::Cvterm::Manager
#                    JFRC::DB::ChaCRM::Featureprop
#                    JFRC::DB::ChaCRM::Featureprop::Manager
#                    JFRC::DB::SAGE::DB
#                    JFRC::DB::SAGE::Experiment
#                    JFRC::DB::SAGE::ExperimentProperty
#                    JFRC::DB::SAGE::Gene
#                    JFRC::DB::SAGE::Image
#                    JFRC::DB::SAGE::ImageProperty
#                    JFRC::DB::SAGE::Line
#                    JFRC::DB::SAGE::Gene
#                    JFRC::DB::SAGE::Observation
#                    JFRC::DB::SAGE::Organism
#                    JFRC::DB::SAGE::Score
#                    JFRC::DB::SAGE::SecondaryImage
#                    JFRC::DB::SAGE::Session
#                    JFRC::DB::SAGE::SessionProperty
#   Config files:    (flow configuration as specified by -config)
#                    (optional grammar as specified -grammar)
#   Input files:     (as specified by -file parm)
#   Output files:    (as specified by -output parm)
#
#                               REVISION LOG
# ----------------------------------------------------------------------------
# | revision | name            | date      | description                     |
# ----------------------------------------------------------------------------
#     1.0     Rob Svirskas      2007-12-13  Initial version
#     1.1     Rob Svirskas      2013-04-12  Added image indexing logging
#     1.2     Rob Svirskas      2013-05-14  Added driver as imageprop.
#     1.3     Rob Svirskas      2013-05-29  Added genotype as imageprop for
#                                           Dickson lines.
#     1.4     Rob Svirskas      2013-06-13  Added production info check for
#                                           Fly Core sync.
#     1.5     Jonathan Epstein  2013-11-21  Added mutual-exclusion lock, and 
#                                           lock timeout.
#     1.6     Rob Svirskas      2013-11-26  Added property value remapping.
#     1.7     Rob Svirskas      2013-11-27  Fixed condition where XML file has
#                                           no remapping values.
#     1.8     Rob Svirskas      2013-12-09  No longer issues warning for
#                                           undefined FLYF2 production info.
#     1.9     Rob Svirskas      2013-12-17  Added code to skip LSM parsing.
#     1.10    Rob Svirskas      2014-01-07  Added QC column check for FlyCore.
#     1.11    Rob Svirskas      2014-01-15  Fixed error where @IMAGE was being
#                                           changed permanently.
#     1.12    Rob Svirskas      2014-01-23  Added "do not update" logic.
#     1.13    Rob Svirskas      2014-01-29  Added override line for dev
#                                           testing.
#     1.14    Rob Svirskas      2014-03-03  Added CV term insertion.
#     1.15    Rob Svirskas      2014-04-04  Added FlyCore "fragment".
#     1.16    Rob Svirskas      2014-04-07  Image vt_line is now selected from
#                                           line fragment.
#     1.17    Rob Svirskas      2014-10-10  Added VNC projection storage
#     1.18    Rob Svirskas      2014-11-06  Added processing for Lee lab
#     1.19    Rob Svirskas      2014-11-26  Modified to handle JRC prefix,
#                                           added additional terms from FLYF2
#     1.20    Rob Svirskas      2014-03-09  Strip CR/LF from FLYF2 genotype
#     1.21    Rob Svirskas      2014-03-09  Added FLYF2 Production info and QC.
#                                           Removed FLYF2 check.
#     1.22    Rob Svirskas      2014-04-06  Department is now assigned with
#                                           Fly Core as the primary source.
#     1.23    Rob Svirskas      2015-09-30  Skip FlyCore check for JRC_IS lines
#     1.24    Rob Svirskas      2016-03-31  Patch to correct PTR capture dates
#     1.25    Eric Trautman     2016-06-22  Always modifyImageRecord when 
#                                           running as jacs pipeline.
#     1.26    Rob Svirskas      2016-09-07  Modified FLYF2 functions to call
#                                           API. The database code remains in
#                                           place if it's needed at some
#                                           point for batch processing
#                                           performance.
#     1.27    Rob Svirskas      2016-10-13  Now pulls genotype from
#                                           StockFinder:c_genotype.
#     1.28    Rob Svirskas      2017-10-03  Now pulls chromosome from
#                                           StockFinder.
#     1.29    Rob Svirskas      2017-10-04  Now pulls vendor information from
#                                           StockFinder.
#     1.30    Rob Svirskas      2017-10-04  Allows continuation for
#                                           non-existent lab
#     1.31    Rob Svirskas      2017-10-13  Line insertion now allows for
#                                           department changes.
#     1.32    Rob Svirskas      2018-01-05  Added Kafka publishing.
#     1.33    Rob Svirskas      2018-01-24  Added FlyCore doi and doi_create
#                                           lineprops.
#     1.34    Rob Svirskas      2018-10-01  Added initial/stable split
#                                           checks.
#     1.35    Rob Svirskas      2018-10-02  Added publishing to new Kafka
#                                           topic.
#     1.36    Rob Svirskas      2018-10-08  Fixed image Kafka message.
#     1.37    Rob Svirskas      2018-10-26  Removed LDAP dependency, cleaned
#                                           up config.
#     1.38    Rob Svirskas      2018-10-29  Fixed driver detection.
#     1.39    Rob Svirskas      2018-11-06  Removed non-JSON published message
#     1.40    Rob Svirskas      2018-12-21  Added code to skip test lines.
# ****************************************************************************

# Perl built-ins
use strict;
use warnings;
use Fcntl qw(:flock);
use DBI;
use Digest::MD5 qw(md5_hex);
use File::Basename;
use Getopt::Long;
use Image::Size;
use IO::File;
use JSON;
use Kafka::Connection;
use Kafka::Producer;
use LWP::UserAgent;
use LWP::Simple;
use Parse::RecDescent;
use Pod::Text;
use Pod::Usage;
use POSIX qw(strftime);
use Scalar::Util qw(blessed);
use Switch;
use Sys::Hostname;
use Time::HiRes qw(gettimeofday time tv_interval);
use Try::Tiny;
use URI::Escape;
use XML::Simple;

# JFRC
use JFRC::Utils::SAGE qw(:all);

# Rose::DB modules for ChaCRM and SAGE
use JFRC::DB::ChaCRM::Cvterm::Manager;
use JFRC::DB::ChaCRM::Featureprop::Manager;
use lib '/groups/scicompsoft/home/svirskasr/workspace/JFRC-Utils-SAGE/lib';
use JFRC::DB::SAGE::Line;
use JFRC::DB::SAGE::Line::Manager;
use JFRC::DB::SAGE::Session;

# ****************************************************************************
# * Constants                                                                *
# ****************************************************************************
(my $PROGRAM = (split('/',$0))[-1]) =~ s/\..*$//;
my $VERSION = '1.40';
use constant DATA_PATH  => '/groups/scicomp/informatics/data/';
use constant NA => 'not_applicable';
my $FLYF_SERVER = 'dbi:JDBC:hostname=prod1;port=9001';
my $FLYF_URL = 'jdbc:filemaker://10.40.3.26:2399/FLYF_2?user=flyf2&password=flycore';
my $FLYCORE_RESPONDER = 'http://informatics-prod.int.janelia.org/cgi-bin/flycore_responder.cgi';
my $CONFIG_SERVER = 'http://config.int.janelia.org/config';
# For the following CV terms, if the property already exists in SAGE,
# do not overwrite it.
my %DO_NOT_UPDATE = map {$_ => 1} qw(objective);

# ****************************************************************************
# * Global variables                                                         *
# ****************************************************************************
# Command-line parameters
our($CHANGELOG,$DEBUG,$DESCRIPTION,$DEV,$HVALIDATE,$PROFILE,$TEST,$VERBOSE) = (0)x8;
our($LAB,$MODULE) = ('')x2;
my ($config,$grammar,$item,$parser,$lockfile,$override_line);
our $file;
# Configuration
my (%REST,%SERVER);
my (%LABID_MAP,%PREFIX_MAP,%REMAP,%REQUIRED,%SITE,%VALIDATE,%VALUE_REMAP,%VECTOR);
our (%ALT_CV);
my @ORIGINAL_IMAGE;
our (@CONTROL,@FIELD,@IMAGE,@SESSION);
my (@EXPERIMENT,@LINE,@OBSERVATION,@SCORE);
our ($BASE_CV,$ES_TYPE,$EXPERIMENT_KEY,$IMAGE_KEY,$JIRA_PID,$SESSION_KEY,
     $SESSION_TYPE,$SKIP_LSM_PARSE);
my ($CHECK_FLYCORE,$CV_INSERTION,$DISPLAY_KEY,$DUP_EXPERIMENTS,$DUP_SESSIONS,
    $EMAIL,$JIRA_ASSIGNEE,$LINE_INSERTION,$NO_NEW_EXPERIMENTS,$SKIP_PARSE_ERR,
    $UPDATE_GMR_LINES);
# Kafka
my ($connection,$producer);
# General
my $Module;
our $EARLY_EXIT;
our (%control_session,%count,%unknown,%valid);
our @message;
my (%cvterm,%experiment,%session);
my (@default,@timing);
my ($db,$dbc,$session_inserted);
my $Flycore_labid;
our ($dbh,$dbhc,$dbhf,$dbhs,$dbhw,$userid,$username);
my %sthf = (
  SF => 'SELECT Balancer,c_genotype,Genotype_GSI_Name_PlateWell,RobotID,"__kp_UniqueID","Lab ID",Member_OR_Requester,'
        . 'Project,Project_SubCat,landing_site,hide,Permission,"_kf_ParentLines",fragment,Alias,Production_Info,Quality_Control,Chromosome,vendor,vendorid FROM StockFinder '
        . 'WHERE Stock_Name=?',
  SFT => 'SELECT "__kp_UniqueID",Production_Info,Quality_Control,"Lab ID" FROM StockFinder WHERE Stock_Name=?',
);
my %sth = (
  CV => 'SELECT cv_term FROM cv_term_vw WHERE cv=? AND cv_term=?',
  CVI => 'SELECT id FROM cv WHERE name=?',
  CVINSERT => 'INSERT INTO cv_term (cv_id,name,display_name,definition,'
              . "data_type,is_current) VALUES (?,?,?,?,'text',1)",
  BATCH => 'SELECT ihc_batch FROM image_data_mv WHERE id=?',
  DRIVER => "SELECT value FROM line_property_vw WHERE type='flycore_project' AND name=?",
  UPDATE_LAB => "UPDATE line SET lab_id=? WHERE id=?",
  VT_LINE => "SELECT value FROM line_property_vw WHERE name=? AND "
             . "type='fragment'",
);
my %sths = (
  CHECK => 'SELECT checksum FROM sage_checksum WHERE sage_identifier=?',
  INSERT => 'INSERT INTO sage_checksum (sage_identifier,sage_entity,checksum) VALUES (?,?,?)',
);
my %sthw = (
  BN => 'SELECT alt_name FROM batch WHERE name=?',
  EVENT => 'SELECT e.create_date,operator FROM event e JOIN batch b ON '
           . '(b.id=e.batch_id) JOIN line l ON (l.id=e.line_id) WHERE l.name=? '
           . "AND b.name=? AND e.process=? AND action='out'",
);
my %sthc = (
  T => 'SELECT fmin,fmax,num_residues,strand,srcname,left_primer,right_primer '
       . 'FROM flybase_extract WHERE transformant=?',
);
my $Organism;
my $lockFh;

# ****************************************************************************
# * Main                                                                     *
# ****************************************************************************

# Get the command-line parameters
GetOptions('file=s'        => \$file,
           'item=s'        => \$item,
           'grammar=s'     => \$grammar,
           'line=s'        => \$override_line,
           'description=s' => \$DESCRIPTION,
           'config=s'      => \$config,
           'module=s'      => \$MODULE,
           'lab=s'         => \$LAB,
           'user=s'        => \$username,
           'lock=s'        => \$lockfile,
           development     => \$DEV,
           'output=s'      => \my $output_file,
           verbose         => \$VERBOSE,
           changelog       => \$CHANGELOG,
           debug           => \$DEBUG,
           test            => \$TEST,
           validate        => \$HVALIDATE,
           profile         => \$PROFILE,
           help            => \my $HELP)
  or pod2usage(-1);

# Display help and exit if the -help parm is specified
pod2text($0),&terminateProgram() if ($HELP);

$VERBOSE = 1 if ($CHANGELOG || $DEBUG || $PROFILE);
# Open the output stream and alias STDERR
our $handle = ($output_file) ? (new IO::File $output_file,'>'
                or &terminateProgram("ERROR: could not open $output_file ($!)"))
                           : (new_from_fd IO::File \*STDOUT,'>'
                or &terminateProgram("ERROR: could not open STDOUT ($!)"));
open(STDERR,'>&='.fileno($handle))
    or &terminateProgram("ERROR: could not alias STDERR ($!)");
autoflush $handle 1;

if ($lockfile) {
  open $lockFh, ">>$lockfile" or &terminateProgram ("ERROR: Unable to open $lockfile");
  chmod 0777, $lockfile; # let's try to set the file permissions, but no reason to get upset if this fails
  tryLockMaxWait($lockFh, 60) or &terminateProgram("ERROR: could not obtain mutual exclusion lock $lockfile");
}

# Initialize database handles
&initialize();
&terminateProgram('ERROR: you must specify a lab') unless ($LAB);

# Trap SIGUSR1
$SIG{USR1} = \&trapSIGUSR;

# Load the data
&loadData();

# Display summary
printf $handle "\n%-33s%s\n"x(scalar @timing),(map {@$_} @timing);
printf $handle "%-33s%d\n",
               'Parsing errors:',$count{parsing}||0 if ($grammar);
printf $handle "%-33s%d\n"x42,
               'Invalid fields:',$count{invalid}||0,
               'Incomplete loads:',$count{incomplete}||0,
               'Unknown genes:',$count{gene}||0,
               'Lines found:',$count{linefound}||0,
               'Lines found (lab changed):',$count{linelab}||0,
               'Lines not found:',$count{linenotfound}||0,
               'Lines inserted:',$count{lineadd}||0,
               'Line properties found:',$count{linepropfound}||0,
               'Line properties modified:',$count{linepropmodify}||0,
               'Line properties inserted:',$count{linepropadd}||0,
               'Experiments found:',$count{experimentfound}||0,
               'Experiments inserted:',$count{experimentadd}||0,
               'Duplicate experiments:',$count{duplicate_experiment}||0,
               'Experiment properties found:',$count{experimentpropfound}||0,
               'Experiment properties modified:',$count{experimentpropmodify}||0,
               'Experiment properties inserted:',$count{experimentpropadd}||0,
               'Sessions found:',$count{sessionfound}||0,
               'Sessions inserted:',$count{sessionadd}||0,
               'Duplicate sessions:',$count{duplicate_session}||0,
               'Session properties found:',$count{sessionpropfound}||0,
               'Session properties modified:',$count{sessionpropmodify}||0,
               'Session properties inserted:',$count{sessionpropadd}||0,
               'Observations found:',$count{observationfound}||0,
               'Observations modified:',$count{observationmodify}||0,
               'Observations inserted:',$count{observationadd}||0,
               'Scores found:',$count{scorefound}||0,
               'Scores modified:',$count{scoremodify}||0,
               'Scores inserted:',$count{scoreadd}||0,
               'Images found:',$count{imagefound}||0,
               'Images inserted:',$count{imageadd}||0,
               'Image properties found:',$count{imagepropfound}||0,
               'Image properties modified:',$count{imagepropmodify}||0,
               'Image properties inserted:',$count{imagepropadd}||0,
               'LSM attenuator entries found:',$count{attenuatorfound}||0,
               'LSM attenuator entries inserted:',$count{attenuatoradd}||0,
               'LSM laser entries found:',$count{laserfound}||0,
               'LSM laser entries inserted:',$count{laseradd}||0,
               'LSM detector entries found:',$count{detectorfound}||0,
               'LSM detector entries inserted:',$count{detectoradd}||0,
               'Secondary images found:',$count{secimagefound}||0,
               'Secondary images inserted:',$count{secimageadd}||0,
               'Checksums found:',$count{checksumfound}||0,
               'Checksums inserted:',$count{checksumadd}||0
;
(1 == $session{$_}) && delete($session{$_}) foreach (keys %session);
if (scalar(keys %session)) {
  printf $handle "\nDuplicate sessions\n%s\n",'-'x18;
  print $handle join("\n",sort keys %session),"\n";
}
if (scalar(keys %unknown)) {
  printf $handle "\nUnknown genes\n%s\n",'-'x13;
  print $handle join("\n",sort keys %unknown),"\n";
}
if ($TEST) {
  print $handle <<__EOT__;
//////////////////////////////////////////////////////////////////////////////
//                           RUNNING IN TEST MODE                           //
//                   No data was written to the database.                   //
//////////////////////////////////////////////////////////////////////////////
__EOT__
}

# We're done
&terminateProgram();

# ****************************************************************************
# * Subroutines                                                              *
# ****************************************************************************

sub trapSIGUSR
{
  print $handle "********** Activating debug mode and profiling **********\n";
  $CHANGELOG = $DEBUG = $PROFILE = $VERBOSE = 1;
}


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
  # Get username
  $userid = getlogin || getpwuid($<)
    || &terminateProgram('Could not determine username');
  unless ($username) {
    my $ret = &getREST("$CONFIG_SERVER/workday/$userid");
    $username = ($ret) ? join(' ',$ret->{config}{first},$ret->{config}{last}) : $userid;
  }
  push @default,"Running as $userid ($username) on " . hostname;
  # ChaCRM CV terms
  my @WANTED = qw(annotation_symbol tiling_path_fragment_id
                  transformant_type);
  my $c = JFRC::DB::ChaCRM::Cvterm::Manager->get_cvterm(
          with_objects => 'cv',
          query        => ['t2.name' => 'feature_property',
                           't1.name' => \@WANTED]);
  $cvterm{$_->name} = $_->cvterm_id foreach (@$c);
  # Initialize SAGE database
  JFRC::DB::SAGE::DB->default_domain('development') if ($DEV);
  $db = JFRC::DB::SAGE::DB->new;
  if ($TEST) {
    $db->autocommit(0);
    print $handle <<__EOT__;
//////////////////////////////////////////////////////////////////////////////
//                           RUNNING IN TEST MODE                           //
//                 No data will be written to the database.                 //
//////////////////////////////////////////////////////////////////////////////
__EOT__
  }
  $dbh = $db->dbh or &terminateProgram($db->error);
  $sth{$_} = $dbh->prepare($sth{$_}) || &terminateProgram($dbh->errstr)
    foreach (keys %sth);
  my $o = JFRC::DB::SAGE::Organism->new(genus => 'Drosophila',
                                        species => 'melanogaster');
  &terminateProgram('Could not find organism')
    unless ($o->load(speculative => 1));
  $Organism = $o->id;
  # Configure XML
  my $p;
  $config .= '-config.xml' unless ($config =~ /-config\.xml$/);
  $config = DATA_PATH . $config unless ($config =~ /\//);
  eval {
    $p = XMLin($config,
               ForceArray => [qw(control field link experiment image session)],
               KeyAttr => { map { $_ => 'key' } qw(term value_remap)}
              );
  };
  &terminateProgram("Could not configure from XML file: $@") if ($@);
  @CONTROL = @{$p->{control}} if (defined $p->{control});
  &terminateProgram('No input fields found in XML configuration')
    unless (defined $p->{field});
  if (exists $p->{value_remap}) {
    my %tmp = %{$p->{value_remap}};
    $VALUE_REMAP{$tmp{$_}{type}}{$_} = $tmp{$_}{new}
      foreach (keys %tmp);
  }
  @FIELD = @{$p->{field}};
  @EXPERIMENT = @{$p->{experiment}} if (defined $p->{experiment});
  @IMAGE = @{$p->{image}} if (defined $p->{image});
  @SESSION = @{$p->{session}} if (defined $p->{session});
  @OBSERVATION = @{$p->{observation}} if (defined $p->{observation});
  @SCORE = @{$p->{score}} if (defined $p->{score});
  $JIRA_PID = $p->{jira_pid} if (exists $p->{jira_pid});
  $JIRA_ASSIGNEE = $p->{jira_assignee} if (exists $p->{jira_assignee});
  $LAB = $p->{lab} if (exists $p->{lab});
  $LAB = lc($LAB);
  $EMAIL = (exists $p->{email}) ? $p->{email} : 'svirskasr@hhmi.org';
  # BASE_CV is the base CV type
  $BASE_CV = $p->{cv};
  # ES_TYPE is the experiment/session type.
  $ES_TYPE = $p->{es_type} || $BASE_CV;
  $SESSION_TYPE = $p->{session_type} || '';
  $DISPLAY_KEY = $p->{display_key} || '';
  $EXPERIMENT_KEY = $p->{experiment_key} || '';
  $DUP_EXPERIMENTS = $p->{allow_duplicate_experiments} || 0;
  $DUP_SESSIONS = $p->{allow_duplicate_sessions} || 0;
  $NO_NEW_EXPERIMENTS = $p->{disallow_new_experiments} || 0;
  $CV_INSERTION = $p->{allow_cv_insertion} || 0;
  $LINE_INSERTION = $p->{allow_line_insertion} || 0;
  $SKIP_LSM_PARSE = $p->{skip_lsm_parsing} || 0;
  $CHECK_FLYCORE = $p->{check_flycore} || 0;
  $SKIP_PARSE_ERR = $p->{skip_parsing_errors} || 0;
  $UPDATE_GMR_LINES = $p->{update_gmr_lines} || 0;
  $IMAGE_KEY = $p->{image_key} || '';
  $SESSION_KEY = $p->{session_key} || '';
  push @default,"Lab: $LAB";
  push @default,"Base CV: $BASE_CV";
  push @default,"Experiment/session type: $ES_TYPE" if ($ES_TYPE);
  push @default,"Session type: $SESSION_TYPE" if ($SESSION_TYPE);
  push @default,"Configuration: $config";
  push @default,"Check FlyCore: $CHECK_FLYCORE";
  push @default,"Module: $MODULE" if ($MODULE);
  push @default,"Grammar: $grammar" if ($grammar);
  push @default,"Run description: $DESCRIPTION" if ($DESCRIPTION);
  print $handle join("\n",@default),"\n";
  # Configure ChaCRM XML
  eval {
    $p = XMLin(DATA_PATH . 'crm-config.xml',
               ForceArray => [qw()],
               KeyAttr => { map { $_ => 'key' } qw(term)}
              );
  };
  &terminateProgram("Could not configure from XML file: $@") if ($@);
  $VECTOR{$_->{content}} = $_->{vector} foreach (@{$p->{vector_map}});
  $SITE{$_->{content}} = $_->{landing_site} foreach (@{$p->{site_map}});
  # Configure REST services and servers
  my $ret = &getREST("$CONFIG_SERVER/rest_services");
  &terminateProgram("Could not get rest_services configuration") unless ($ret);
  %REST = %{$ret->{config}};
  $ret = &getREST("$CONFIG_SERVER/servers");
  &terminateProgram("Could not get servers configuration") unless ($ret);
  %SERVER = %{$ret->{config}};
  my $rvar = &getREST($REST{sage}{url}."/cvterms?cv=lab_prefix&_columns=cv_term,definition,id");
  &terminateProgram("Could not get lab prefix mappings") unless ($rvar->{cvterm_data});
  %PREFIX_MAP = map { $_->{cv_term} => $_->{definition} } @{$rvar->{cvterm_data}};
  $rvar = &getREST($REST{sage}{url}."/cvterms?cv=lab&_columns=cv_term,id");
  &terminateProgram("Could not get lab mappings") unless ($rvar->{cvterm_data});
  %LABID_MAP = map { $_->{cv_term} => $_->{id} } @{$rvar->{cvterm_data}};

  # Initialize a RecDescent parser (if needed)
  if ($grammar) {
    my $stream= new IO::File $grammar,'<'
      or &terminateProgram("Could not open grammar $grammar: $!");
    sysread $stream,my $prd_grammar,-s $stream;
    $stream->close;
    $Parse::RecDescent::skip = undef;
    $parser = new Parse::RecDescent($prd_grammar)
      || &terminateProgram('Bad grammar');
  }
  # ChaCRM
  $dbc = JFRC::DB::ChaCRM::DB->new;
  $dbhc = $dbc->dbh or &terminateProgram($dbc->error);
  $sthc{$_} = $dbhc->prepare($sthc{$_}) || &terminateProgram($dbhc->errstr)
    foreach (keys %sthc);
  # SAGE COA, WIP
  if ($IMAGE_KEY) {
    $dbhs = DBI->connect('dbi:mysql:dbname=sagecoa;host=mysql3','secretsquirrel','w@yn3')
      or &terminateProgram($DBI::errstr);
    $sths{$_} = $dbhs->prepare($sths{$_}) || &terminateProgram($dbhs->errstr)
      foreach (keys %sths);
    $dbhw = DBI->connect('dbi:mysql:dbname=wip;host=mysql2',('wipRead')x2)
      or &terminateProgram($DBI::errstr);
    $sthw{$_} = $dbhw->prepare($sthw{$_}) || &terminateProgram($dbhw->errstr)
      foreach (keys %sthw);
  }
  # Kafka
  try {
    $connection = Kafka::Connection->new(host => $SERVER{Kafka}{address},
                                         timeout => 5);
    $producer = Kafka::Producer->new(Connection => $connection)
      if ($connection);
  }
  catch {
    my $error = $_;
    if (blessed($error) && $error->isa('Kafka::Exception')) {
      &terminateProgram('Error: ('.$error->code.') '.$error->message);
    }
    else {
      &terminateProgram($error);
    }
  };
  &terminateProgram("Couldn't connect to Kafka at $SERVER{Kafka}{address}") unless ($producer);
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
  print { $handle || \*STDERR } "$message\n" if ($message);
  $handle->close if ($handle);
  if (scalar @message) {
    if (open(SENDMAIL,'|/usr/lib/sendmail -i -t')) {
      print SENDMAIL <<__EOT__;
To: $EMAIL
Subject: SAGE loader errors
This is an automated email from sage_loader. Some data could not be loaded.

__EOT__
      print SENDMAIL join("\n",@default),"\n\n";
      print SENDMAIL join("\n",@message);
      close(SENDMAIL);
    }
  }
  unlock($lockFh) if ($lockFh);
  undef $producer;
  $connection->close;
  undef $connection;
  exit(($message) ? -1 : 0);
}

  
sub publish
{
  return unless ($producer);
  my($message) = shift;
  my $topic = 'sage_loader';
  try {
    my $t = time;
    my $stamp = strftime "%Y-%m-%d %H:%M:%S", localtime $t;
    $stamp .= sprintf ".%03d", ($t-int($t))*1000;
    if (ref($message)) {
      $message->{time} = $t;
      $message = encode_json $message;
    }
    else {
      $topic = 'flycore_sync';
      $message = "$PROGRAM: $message";
    }
    print $handle "  PUBLISH $message\n" if ($DEBUG);
    my $response = $producer->send($topic,0,$message,$stamp,undef,int(time*1000));
  }
  catch {
    my $error = $_;
    if (blessed($error) && $error->isa('Kafka::Exception')) {
      print 'Error: (' . $error->code . ') ' . $error->message . "\n";
    }
    else {
      print "$error\n";
    }
  };
}


# ****************************************************************************
# * Subroutine:  loadData                                                    *
# * Description: This routine will load the tab-delimited data. Two types of *
# *              operations are permitted: standard and special. Standard    *
# *              operations are performed according to parameters in the XML.*
# *              Special operations are performed if a function is found     *
# *              that matches the operation type and base CV. Operations are *
# *              performed as follows:                                       *
# *              1) Preload special operations                               *
# *              2) Transform special operations                             *
# *              3) Line standard operations                                 *
# *              4) Line special operations                                  *
# *              5) Experiment special operations                            *
# *              6) Experiment standard operations                           *
# *              7) Session special operations                               *
# *              8) Session standard operations                              *
# *              9) Observation special operations                           *
# *              10) Observation standard operations                         *
# *              11) Score special operations                                *
# *                                                                          *
# * Parameters:  NONE                                                        *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub loadData
{
no strict 'refs';

  foreach (@FIELD) {
    switch ($_->{type}) {
      case 'line' { push @LINE,$_->{term}; }
      case 'experiment' { push @EXPERIMENT,$_->{term}; }
      case 'session' { push @SESSION,$_->{term}; }
      case 'image' { push @IMAGE,$_->{term}; }
      case 'observation' { push @OBSERVATION,$_->{term}; }
      case 'score' { push @SCORE,$_->{term}; }
    }
    @ORIGINAL_IMAGE = @IMAGE;
    # Determine remapping
    ($_->{remap}) && ($REMAP{$_->{term}} = $_->{remap});
    # Set alternate CV
    $ALT_CV{$_->{term}} = $_->{cv} if (exists $_->{cv});
    # Determine validation CVs
    $VALIDATE{$_->{term}} = $_->{validation_cv} if (exists $_->{validation_cv});
    # Set required status
    $REQUIRED{$_->{term}} = 1 if ($_->{required});
  }
  # Special preload processing
  $Module = $MODULE || 'JFRC::Utils::SAGE::' . $BASE_CV;
  $Module = 'JFRC::Utils::SAGE::' . $Module unless ($Module =~ /::/);
  print $handle "Loading module $Module\n" if ($DEBUG);
  eval "require $Module";
  print $handle "Loaded $Module\n" if ($DEBUG);
  my $func = $Module . '::preload';
  &$func();

  my $t0 = time;
  if ($file) {
    my $stream = new IO::File $file,'<'
      or &terminateProgram("Could not open $file ($!)");
    unless ($grammar) {
      # Skip the header
      chomp(my $row = $stream->getline);
      my @header = split(/\t/,$row);
      &terminateProgram(sprintf 'Input file does not match spec: expected %d '
                        . 'columns, got %d',scalar(@FIELD),scalar(@header))
        unless (scalar(@header) == scalar(@FIELD));
      if ($HVALIDATE) {
        $header[0] =~ s/^#\s*//;
        my $okay = 1;
        foreach (0..$#header) {
          unless (lc($header[$_]) eq $FIELD[$_]{term}) {
            printf $handle "Column %d in input (%s) does not match "
                           . "spec (%s)\n",$_+1,$header[$_],$FIELD[$_]{term};
            $okay = 0;
          }
        }
        &terminateProgram('Input file does not match spec') unless ($okay);
      }
    }
    while (defined(my $row = $stream->getline)) {
      $db->begin_work() || &terminateProgram('Could not open database transaction')
        if ($TEST);
      &loadItem($row);
      $db->rollback if ($TEST);
    }
    $stream->close;
  }
  elsif ($item) {
    $db->begin_work || &terminateProgram('Could not open database transaction')
      if ($TEST);
    &loadItem($item);
    $db->rollback if ($TEST);
  }
  push @timing,['Load data:',&computeElapsedTime(time-$t0)];
}


sub loadItem
{
no strict 'refs';

  my $row = shift;
  chomp($row);
  # Skip blank rows
  return if ($row =~ /^\s*$/);
  my %row = ();
  my $start_time = strftime "%Y-%m-%d %H:%M:%S %Y",localtime;
  my $t0 = [gettimeofday];
  $EARLY_EXIT = 0;
  if ($parser) {
    my $ret = $parser->start($row);
    unless ($ret) {
      if ($SKIP_PARSE_ERR) {
        print $handle "Could not parse $row\n";
        $count{parsing}++;
      }
      else {
        &terminateProgram("Could not parse $row");
      }
    }
    %row = %$ret;
    $row{line} = $override_line if ($DEV && $override_line);
    printf $handle "  Elapsed time (RD parser): %.3f sec\n",tv_interval($t0)
      if ($PROFILE);
  }
  else {
    @row{map {$_->{term}} @FIELD} = split(/\t/,$row);
    return unless (scalar(@FIELD) == scalar(keys %row));
  }
  if ($row{line} =~ /TEST/) {
    print $handle "Skipping test line $row{line}\n";
    return();
  }
  print $handle $row{$DISPLAY_KEY||'line'},"\n" if ($VERBOSE);
  # Special transform processing
  my $func = $Module . '::transform';
  unless (&$func(\%row)) {
    push @message,"Incomplete transform processing for line $row{line}";
    unless ($EARLY_EXIT) {
      print $handle "  Incomplete transform processing for line ",
                    $row{line},"\n";
      $count{incomplete}++;
    }
    return;
  }
  # ---------- Line ----------
  my $t1 = [gettimeofday];
  unless (defined($row{line}) && $row{line}) {
    print $handle "  Line is undefined\n";
    return;
  }
  $row{line} = 'GMR_' . $row{line} . '_AE_01'
   if ($row{line} =~ /^\d+[A-H][01][0-9]$/);
  my $line = $row{line};
  unless ($line) {
    print $handle "  A line row is not present\n";
    $count{incomplete}++ unless ($EARLY_EXIT);
    return;
  }
  # Insert or update a line/lab record in the line table
  $Flycore_labid = '';
  if (($CHECK_FLYCORE || $line =~ /^JRC/) && $line !~ /^JRC_I/) {
    unless (&checkFlyCoreREST($line)) {
      $count{incomplete}++ unless ($EARLY_EXIT);
      return;
    }
  }
  my($l,$op,$line_lab) = &getLine($line);
  unless ($l) {
    print $handle "  Could not get line $line\n";
    $count{incomplete}++ unless ($EARLY_EXIT);
    return;
  }
  # Special processing for Rubin (and "Rubin-like") lines
  if ($UPDATE_GMR_LINES && ($l->name =~ /^GMR_\d+[A-H][01][0-9]/)) {
    # Crossload data from ChaCRM
    &fetchChaCRMData($l,\%row);
  }
  # Crossload data from Fly Core
  if (($CHECK_FLYCORE || $line =~ /^JRC/) && $line !~ /^JRC_I/) {
    &fetchFlyCoreDataREST($l,\%row) if ($CHECK_FLYCORE);
    if ($line =~ /^JRC_S[LS]\d+$/) {
      my $driver = $row{'_flycore_project'};
      if (($line =~ /_SS/) && ($driver ne 'Split_GAL4')) {
        push @message,"Line $line should be Split_GAL4 but is $driver";
        $count{incomplete}++;
        return;
      }
      elsif (($line =~ /_SL/) && ($driver ne 'Split_LexA')) {
        push @message,"Line $line should be Split_LexA but is $driver";
        $count{incomplete}++;
        return;
      }
    }
  }
  # Special line processing
  $func = $Module . '::line';
  unless (&$func($l,\%row)) {
    push @message,"Incomplete line processing for line $line ($Module)";
    unless ($EARLY_EXIT) {
      print $handle "  Incomplete line processing for line $line\n";
      $count{incomplete}++;
    }
    return;
  }
  # Add line properties
  &addGeneral($l,\%row,($_)x2,'lineprop') foreach (@LINE);
  &publish({client => $PROGRAM,version => $VERSION,host => hostname,user => $userid,
            duration => tv_interval($t1) * 1000,operation => $op,type => 'line',
            item => $line,lab => $line_lab});
  printf $handle "  Elapsed time (line processing): %.3f sec\n",tv_interval($t1)
    if ($PROFILE);
  # ---------- Experiment ----------
  $t1 = [gettimeofday];
  # Special experiment processing
  $func = $Module . '::experiment';
  unless (&$func($l,\%row)) {
    push @message,"Incomplete experiment processing for line $line ($Module)";
    unless ($EARLY_EXIT) {
      print $handle "  Incomplete experiment processing for line $line\n";
      $count{incomplete}++;
    }
    return;
  }
  my $e;
  if ($EXPERIMENT_KEY) {
    # Insert the experiment
    &terminateProgram("No experiment key [$EXPERIMENT_KEY] for $line")
      unless (length($row{$EXPERIMENT_KEY}));
    $e = &getExperiment($BASE_CV,$ES_TYPE,$l->id,\%row);
    unless ($e) {
      push @message,"No experiment returned for line $line";
      unless ($EARLY_EXIT) {
        print $handle "  No experiment returned for line $line\n";
        $count{incomplete}++;
      }
      return;
    }
    unless ($DUP_EXPERIMENTS || grep {/^$line$/} @CONTROL) {
      $experiment{$e->name.'_'.$line}++;
      if ($experiment{$e->name.'_'.$line} > 1) {
        push @message,"Duplicate experiment (" . $e->name . ") for line $line";
        print $handle '  Experiment ' . $e->name
                      . " already exists for $line\n";
        $count{duplicate_experiment}++;
        $count{incomplete}++;
        return;
      }
    }
    # Check for missing experiment properties
    my @missing;
    foreach (@EXPERIMENT) {
      push @missing,$_
        if ($REQUIRED{$_} && (!exists($row{$_}) || !length($row{$_})));
    }
    if (scalar @missing) {
      push @message,"Experiment " . $e->name . " has null fields for line $line";
      print $handle "  Experiment $e->{name} has null fields: ",
                   join(', ',@missing),"\n";
      &submitJIRATicket({summary => "Null fields for " . $l->{name},
          description => "Experiment $e->{name} has null fields: "
                         . join(', ',@missing)})
        if ($JIRA_PID);
      $count{incomplete}++;
      return;
    }
    # Add experiment properties
    &addGeneral($e,\%row,($_)x2,'experimentprop') foreach (@EXPERIMENT);
    printf $handle "  Elapsed time (experiment processing): %.3f sec\n",
                   tv_interval($t1) if ($PROFILE);
  }
  # ---------- Session ----------
  $t1 = [gettimeofday];
  # Special session processing
  $func = $Module . '::session';
  unless (&$func($l,$e,\%row)) {
    push @message,"Incomplete session processing for line $line ($Module)";
    unless ($EARLY_EXIT) {
      print $handle "  Incomplete session processing for line $line\n";
      $count{incomplete}++;
    }
    return;
  }
  my $s;
  if ($SESSION_KEY) {
    # Insert the session
    &terminateProgram("No session key for $line")
      unless (length($row{$SESSION_KEY}));
    $session_inserted = 0;
    $s = &getSession(cv => $BASE_CV,
                     cvterm => ($SESSION_TYPE || $ES_TYPE),
                     experiment => $e,
                     line => $l,
                     name => $row{$SESSION_KEY});
    unless ($session_inserted) {
      # Duplicate sessions are allowed if:
      # 1) We're inserting imagery
      # 2) It's a control line
      # 3) We say so in the config
      unless ($DUP_SESSIONS || $IMAGE_KEY || grep {/^$line$/} @CONTROL) {
        $session{$s->name.'_'.$line}++;
        if ($session{$s->name.'_'.$line} > 1) {
          push @message,"Duplicate session (" . $s->name . ") for line $line";
          print $handle '  Session '.$s->name." already exists for $line\n";
          &submitJIRATicket({summary => 'Session '.$s->name.' already '
                                        ."exists for $line",
                             description => '  Session '.$s->name.' already '
                                            . "exists for $line"}) if ($JIRA_PID);
          $count{duplicate_session}++;
          $count{incomplete}++;
          return;
        }
      }
    }
    # Check for missing session properties
    my @missing;
    foreach (@SESSION) {
      push @missing,$_
        if ($REQUIRED{$_} && (!exists($row{$_}) || !length($row{$_})));
    }
    if (scalar @missing) {
      push @message,"Session " . $s->name . " has null fields for line $line";
      print $handle "  Session $s->{name} has null fields: ",
                   join(', ',@missing),"\n";
      &submitJIRATicket({summary => "Null fields for " . $l->{name},
          description => "Session $s->{name} has null fields: "
                         . join(', ',@missing)})
        if ($JIRA_PID);
      $count{incomplete}++;
      return;
    }
    # Add session properties
    &addGeneral($s,\%row,($_)x2,'sessionprop') foreach (@SESSION);
    printf $handle "  Elapsed time (session processing): %.3f sec\n",
                   tv_interval($t1) if ($PROFILE);
  }
  # ---------- Observations ----------
  $t1 = [gettimeofday];
  # Special observation processing
  $func = $Module . '::observation';
  unless (&$func($l,$e,\%row)) {
    push @message,"Incomplete observation processing for line $line ($Module)";
    unless ($EARLY_EXIT) {
      print $handle "  Incomplete observation processing for line $line\n";
      $count{incomplete}++;
    }
    return;
  }
  # Add the observations
  if ($s) {
    &addGeneral($s,\%row,($_)x2,'observation') foreach (@OBSERVATION);
    printf $handle "  Elapsed time (observation processing): %.3f sec\n",
                   tv_interval($t1) if ($PROFILE);
  }
  # ---------- Scores ----------
  $t1 = [gettimeofday];
  # Special score processing
  $func = $Module . '::score';
  unless (&$func($l,$e,$s,\%row)) {
    push @message,"Incomplete score processing for line $line ($Module)";
    unless ($EARLY_EXIT) {
      print $handle "  Incomplete score processing for line $line\n";
      $count{incomplete}++;
    }
    return;
  }
  # Add the scores
  if ($s) {
    &addGeneral($s,\%row,($_)x2,'score') foreach (@SCORE);
    printf $handle "  Elapsed time (score processing): %.3f sec\n",
                   tv_interval($t1) if ($PROFILE);
  }
  # ---------- Image ----------
  if ($IMAGE_KEY) {
    my $start_ms = time * 1000;
    $t1 = [gettimeofday];
    # Special image processing
    $func = $Module . '::image';
    @IMAGE = @ORIGINAL_IMAGE if (scalar @ORIGINAL_IMAGE);
    unless (&$func($l,$s,\%row)) {
      push @message,"Incomplete image processing for line $line ($Module)";
      unless ($EARLY_EXIT) {
        print $handle "  Incomplete image processing for line $line\n";
        $count{incomplete}++;
      }
      return;
    }
    # Add the image
    my($i,$op) = &getImage($l,\%row);
    # Add image properties
    if ($i) {
      &addGeneral($i,\%row,($_)x2,'imageprop') foreach (@IMAGE);
      unless ($row{extension} eq 'lsm') {
        ($row{width},$row{height}) = imgsize($row{path});
        &addGeneral($i,\%row,($_)x2,'imageprop') foreach (qw(width height));
      }
      # Add a "driver" image property. This is actually a lineprop
      # (flycore_project), but this will prevent image_data_mv builds
      # from taking forever.
      $sth{DRIVER}->execute($line);
      my($driver) = $sth{DRIVER}->fetchrow_array();
      if ($driver) {
        $row{driver} = $driver || '';
        &addGeneral($i,\%row,('driver')x2,'imageprop');
      }
      # Add a "vt_line" image property for Dickson lines.
      if ($line =~ /^BJD/) {
        $sth{VT_LINE}->execute($line);
        my($vt) = $sth{VT_LINE}->fetchrow_array();
        if ($vt) {
          $vt =~ s/\s.*$//;
          $row{vt_line} = $vt || '';
          &addGeneral($i,\%row,('vt_line')x2,'imageprop');
        }
      }
    }
    else {
      return;
    }
    # Special post-insert image processing
    $func = $Module . '::postimage';
    unless (&$func($i,,\%row)) {
      push @message,"Incomplete image post-processing for line $line ($Module)";
      unless ($EARLY_EXIT) {
        print $handle "  Incomplete image post-processing for line $line\n";
        $count{incomplete}++;
      }
      return;
    }
    # Secondary data
    &addSecondaryData($i,\%row);
    printf $handle "  Elapsed time (image processing): %.3f sec\n",
                   tv_interval($t1) if ($PROFILE);
    # Log indexing
    my $stop_time = strftime "%Y-%m-%d %H:%M:%S %Y",localtime;
    &insertOperation(OPERATION => 'image_indexing',
                     NAME => $row{$IMAGE_KEY},
                     START => $start_time,
                     STOP => $stop_time,
                     PROGRAM => $0,
                     OPERATOR => $row{userid} || $userid,
                     VERSION => $VERSION);
    my $stop_ms = time * 1000;
    &publish({client => $PROGRAM,version => $VERSION,host => hostname,user => $userid,
              duration => $stop_ms - $start_ms,operation => $op,type => 'image',
              item => $row{$IMAGE_KEY},lab => $LAB});
  }
  printf $handle "  Elapsed time: %.3f sec\n",tv_interval($t0) if ($PROFILE);
}


# ****************************************************************************
# * Subroutine:  fetchChaCRMData                                             *
# * Description: This routine will fetch the following data from ChaCRM for  *
# *              a given transformant ID:                                    *
# *                Gene                                                      *
# *                Landing site                                              *
# *                Plate                                                     *
# *                Transformant type                                         *
# *                Vector                                                    *
# *                Well                                                      *
# *                                                                          *
# * Parameters:  message: the error message to print                         *
# * Returns:     NONE                                                        *
# ****************************************************************************
sub fetchChaCRMData
{
my %ch;

  my($l,$row) = @_;
  (my $name = $l->name) =~ s/^GMR_//;
  # Get the gene from ChaCRM
  my $f = JFRC::DB::ChaCRM::Featureprop::Manager->get_featureprop(
              with_objects => 'feature',
              query        => [name        => $name,
                               is_obsolete => 0,
                               type_id     => $cvterm{tiling_path_fragment_id},
                               rank        => 0]);
  return unless (1 == scalar(@$f));
  my $fp = JFRC::DB::ChaCRM::Featureprop->new(feature_id => $f->[0]->value,
               type_id    => $cvterm{annotation_symbol},
               rank       => 0);
  &terminateProgram("Could not find annotation symbol for $name")
    unless ($fp->load(speculative => 1));
  print $handle '  Found ChaCRM annotation_symbol ',$fp->value,"\n"
    if ($DEBUG);
  my $gene = $fp->value;
  my $cph = $dbh->prepare("CALL getGene('$gene')");
  $cph->execute();
  $gene = $cph->fetchrow_array();
  if ($gene) {
    $ch{gene_id} = &getGeneID($gene)
      || &terminateProgram('No ChaCRM gene for '.$l->name);
    $l->gene_id($ch{gene_id});
    eval {$l->save;};
    if ($@) {
      &submitJIRATicket({summary => 'Could not update gene for '
                                    . $l->id . 'in line table',
                         description => $@}) if ($JIRA_PID);
      &terminateProgram($@);
    }
  }
  else {
    # If we don't have a gene, that means it was part of FlyBase in 12/2008,
    # but is no more.
    $count{gene}++;
    $unknown{$fp->value}++;
    print $handle '  Gene ',$fp->value,' does not exist in SAGE (it might be '
                  . "withdrawn from FlyBase)\n";
  }
  delete $ch{gene_id};
  # Transformant type
  $f = JFRC::DB::ChaCRM::Featureprop::Manager->get_featureprop(
           with_objects => 'feature',
           query        => [name        => $name,
                            is_obsolete => 0,
                            type_id     => $cvterm{transformant_type},
                            rank        => 0]);
  if ($f->[0] && $f->[0]->value) {
    print $handle '  Found ChaCRM transformant type ',$f->[0]->value,"\n"
      if ($DEBUG);
    $ch{transformant_type} = $f->[0]->value;
  }
  # Parse the rest out of the transformant ID
  my($p,$w,$v,$ls) = $name =~ /(\d+)([A-H]\d+)_([A-Z]{2})_(\d+)/;
  @ch{qw(plate well)} = ('GR.'.$p,$w);
  $ch{vector} = $VECTOR{$v} || &terminateProgram("No vector for $v");
  $ch{landing_site} = $SITE{$ls}
    || &terminateProgram("No landing site for $ls");
  # Fragment data
  $sthc{T}->execute($name);
  my($min,$max,$len,$strand,$chr,$left,$right) = $sthc{T}->fetchrow_array();
  $ch{min_coord} = $min if ($min);
  $ch{max_coord} = $max if ($max);
  $ch{num_residues} = $len if ($len);
  $ch{strand} = $strand if ($strand);
  $ch{chromosome} = $chr if ($chr);
  $ch{left_primer} = $left if ($left);
  $ch{right_primer} = $right if ($right);
  # Add data to SAGE
  foreach (sort keys %ch) {
  	next unless ($ch{$_});
  	$row->{'_'.$_} = $ch{$_};
    &addGeneral($l,$row,$_,'_'.$_,'lineprop');
  }
}


sub getREST
{
  my($rest) = shift;
  my $response = get $rest;
  unless (length($response)) {
    print "REST GET returned null response\n"
          . "Request: $rest\n";
    return();
  }
  my $rvar;
  eval {$rvar = decode_json($response)};
  &terminateProgram("REST GET failed\nRequest: $rest\n"
                    . "Response: $response\nError: $@") if ($@);
  return($rvar);
}


sub checkFlyCoreREST
{
  my $line = shift;
  my $rest = "$FLYCORE_RESPONDER?request=lab&line=$line";
  my $response = get $rest;
  my $rvar;
  &terminateProgram("REST GET [$rest] returned null response")
    unless (length($response));
  eval {$rvar = decode_json($response)};
  &terminateProgram("REST GET [$rest] failed: $@") if ($@);
  &terminateProgram("REST GET [$rest] error: $rvar->{error}") if ($rvar->{error});
  $Flycore_labid = '';
  if ($rvar->{'__kp_UniqueID'}) {
    if (!$rvar->{lab}) {
      push @message,"Line $line does not have a defined lab in the Fly Core database";
      print $handle "  Line $line does not have a defined lab in the Fly Core database\n";
      return();
    }
  }
  else {
    push @message,"Line $line is not present in the Fly Core database";
    print $handle "  Line $line is not present in the Fly Core database\n";
    return();
  }
  $Flycore_labid = $rvar->{lab};
}


sub fetchFlyCoreDataREST
{
  my($l,$row) = @_;
  my $rest = "$FLYCORE_RESPONDER?request=linedata&line=" . $l->name;
  my $response = get $rest;
  my $rvar;
  &terminateProgram("REST GET [$rest] returned null response")
    unless (length($response));
  eval {$rvar = decode_json($response)};
  &terminateProgram("REST GET [$rest] failed: $@") if ($@);
  &terminateProgram("REST GET [$rest] error: $rvar->{error}") if ($rvar->{error});
  print $handle "  Updated in FLYF2 at $rvar->{linedata}{date_modified}\n"
    if ($DEBUG && $rvar->{linedata}{date_modified});
  $row->{'_balancer'} = $rvar->{linedata}{Balancer};
  $row->{'_doi'} = $rvar->{linedata}{doi};
  $row->{'_doi_create'} = $rvar->{linedata}{doi_create};
  $row->{'_chromosome'} = $rvar->{linedata}{Chromosome};
  $row->{'_genotype'} = $rvar->{linedata}{c_genotype}
                        || $rvar->{linedata}{Genotype_GSI_Name_PlateWell};
  if ($row->{'_genotype'} =~ /[^\x00-\x7f]/) {
    (my $msg = $row->{'_genotype'}) =~ s/[^\x00-\x7f]/!/g;
    push @message,"Line " . $l->name . " has non-ASCII genotype $msg (unprintable characters replaced with !)";
  }
  $row->{'_robot'} = $rvar->{linedata}{RobotID};
  $row->{'_flycore'} = $rvar->{linedata}{'__kp_UniqueID'};
  $row->{'_flycore_lab'} = $rvar->{linedata}{'Lab ID'};
  $row->{'_flycore_requester'} = $rvar->{linedata}{Member_OR_Requester};
  $row->{'_flycore_project'} = $rvar->{linedata}{Project};
  $row->{'_flycore_project_subcat'} = $rvar->{linedata}{Project_SubCat};
  $row->{'_flycore_landing_site'} = $rvar->{linedata}{landing_site};
  $row->{'_hide'} = $rvar->{linedata}{Hide} || 'N';
  $row->{'_flycore_permission'} = $rvar->{linedata}{Permission};
  $row->{'_flycore_parents'} = $rvar->{linedata}{'_kf_ParentLines'};
  $row->{'_fragment'} = $rvar->{linedata}{fragment};
  $row->{'_flycore_alias'} = $rvar->{linedata}{Alias};
  $row->{'_flycore_production_info'} = $rvar->{linedata}{Production_Info};
  $row->{'_flycore_quality_control'} = $rvar->{linedata}{Quality_Control};
  $row->{'_flycore_vendor'} = $rvar->{linedata}{vendor};
  $row->{'_flycore_vendor_id'} = $rvar->{linedata}{vendorid};
  $row->{'_genotype'} =~ s/[\n\r]/ /g;
  &addGeneral($l,$row,'balancer','_balancer','lineprop');
  &addGeneral($l,$row,'chromosome','_chromosome','lineprop');
  &addGeneral($l,$row,'doi','_doi','lineprop');
  &addGeneral($l,$row,'doi_create','_doi_create','lineprop');
  &addGeneral($l,$row,'fragment','_fragment','lineprop');
  &addGeneral($l,$row,'genotype','_genotype','lineprop');
  &addGeneral($l,$row,'robot_id','_robot','lineprop');
  &addGeneral($l,$row,'flycore_id','_flycore','lineprop');
  &addGeneral($l,$row,'flycore_lab','_flycore_lab','lineprop');
  &addGeneral($l,$row,'flycore_requester','_flycore_requester','lineprop');
  &addGeneral($l,$row,'flycore_project','_flycore_project','lineprop');
  &addGeneral($l,$row,'flycore_project_subcat','_flycore_project_subcat','lineprop');
  &addGeneral($l,$row,'flycore_landing_site','_flycore_landing_site','lineprop');
  &addGeneral($l,$row,'hide','_hide','lineprop');
  &addGeneral($l,$row,'flycore_permission','_flycore_permission','lineprop');
  &addGeneral($l,$row,'flycore_alias','_flycore_alias','lineprop');
  &addGeneral($l,$row,'flycore_production_info','_flycore_production_info','lineprop');
  &addGeneral($l,$row,'flycore_quality_control','_flycore_quality_control','lineprop');
  &addGeneral($l,$row,'flycore_vendor','_flycore_vendor','lineprop');
  &addGeneral($l,$row,'flycore_vendor_id','_flycore_vendor_id','lineprop');
}


sub checkFlyCore
{
  my $line = shift;
  unless ($dbhf) {
    $FLYF_URL =~ s/([=;])/uc sprintf("%%%02x",ord($1))/eg;
    $dbhf = DBI->connect(join(';url=',$FLYF_SERVER,$FLYF_URL),(undef)x2)
      or &terminateProgram($DBI::errstr);
    $sthf{$_} = $dbhf->prepare($sthf{$_}) || &terminateProgram($dbhf->errstr)
      foreach (keys %sthf);
  }
  $sthf{SFT}->execute($line);
  my($flycore,$prod,$qc,$labid) = $sthf{SFT}->fetchrow_array();
  return(0) unless (defined $flycore);
  $prod ||= '';
  $qc ||= '';
  $Flycore_labid = $labid || '';
  return(1);
  return (($prod =~ /(?:Dead|Exit|GSI Fail|Tossed)/)
          || ($qc eq 'Ignore Stock Name')) ? 0 : 1;
}


sub fetchFlyCoreData
{
  my($l,$row) = @_;
  unless ($dbhf) {
    $FLYF_URL =~ s/([=;])/uc sprintf("%%%02x",ord($1))/eg;
    $dbhf = DBI->connect(join(';url=',$FLYF_SERVER,$FLYF_URL),(undef)x2)
      or &terminateProgram($DBI::errstr);
    $sthf{$_} = $dbhf->prepare($sthf{$_}) || &terminateProgram($dbhf->errstr)
      foreach (keys %sthf);
  }
  $sthf{SF}->execute($l->name);
  my($balancer,$c_genotype,$genotype,$robot,$flycore,$lid,$mor,$proj,$subcat,$ls,$hide,
     $permission,$parents,$fragment,$alias,$prod,$qc,$chromosome,$vendor,$vendorid) = $sthf{SF}->fetchrow_array();
  $genotype =~ s/[\n\r]/ /g;
  $row->{'_balancer'} = $balancer || '';
  $row->{'_chromosome'} = $chromosome || '';
  $row->{'_fragment'} = $fragment || '';
  $row->{'_genotype'} = $c_genotype || $genotype || '';
  $row->{'_genotype'} =~ s/\r/ /g;
  $row->{'_genotype'} =~ s/\n/ /g;
  $row->{'_robot'} = (defined $robot) ? int($robot) : '';
  $row->{'_flycore'} = (defined $flycore) ? int($flycore) : '';
  $row->{'_flycore_lab'} = $lid || '';
  $row->{'_flycore_requester'} = $mor || '';
  $row->{'_flycore_project'} = $proj || '';
  $row->{'_flycore_project_subcat'} = $subcat || '';
  $row->{'_flycore_landing_site'} = $ls || '';
  $hide = ($hide) ? 'Y' : 'N';
  $row->{'_hide'} = $hide || '';
  $row->{'_flycore_permission'} = $permission || '';
  $row->{'_flycore_parents'} = $parents || '';
  $row->{'_flycore_alias'} = $alias || '';
  $row->{'_flycore_production_info'} = $prod || '';
  $row->{'_flycore_quality_control'} = $qc || '';
  $row->{'_flycore_vendor'} = $vendor || '';
  $row->{'_flycore_vendor_id'} = $vendorid || '';
  &addGeneral($l,$row,'balancer','_balancer','lineprop');
  &addGeneral($l,$row,'chromosome','_chromosome','lineprop');
  &addGeneral($l,$row,'fragment','_fragment','lineprop');
  &addGeneral($l,$row,'genotype','_genotype','lineprop');
  &addGeneral($l,$row,'robot_id','_robot','lineprop');
  &addGeneral($l,$row,'flycore_id','_flycore','lineprop');
  &addGeneral($l,$row,'flycore_lab','_flycore_lab','lineprop');
  &addGeneral($l,$row,'flycore_requester','_flycore_requester','lineprop');
  &addGeneral($l,$row,'flycore_project','_flycore_project','lineprop');
  &addGeneral($l,$row,'flycore_project_subcat','_flycore_project_subcat','lineprop');
  &addGeneral($l,$row,'flycore_landing_site','_flycore_landing_site','lineprop');
  &addGeneral($l,$row,'hide','_hide','lineprop');
  &addGeneral($l,$row,'flycore_permission','_flycore_permission','lineprop');
  &addGeneral($l,$row,'flycore_alias','_flycore_alias','lineprop');
  &addGeneral($l,$row,'flycore_production_info','_flycore_production_info','lineprop');
  &addGeneral($l,$row,'flycore_quality_control','_flycore_quality_control','lineprop');
  &addGeneral($l,$row,'flycore_vendor','_flycore_vendor','lineprop');
  &addGeneral($l,$row,'flycore_vendor_id','_flycore_vendor_id','lineprop');
}


sub getGeneID
{
  my $gene = shift;
  my $g = JFRC::DB::SAGE::Gene->new(name => $gene,
                                    organism_id => $Organism);
  &terminateProgram("Could not find gene ID for $gene")
    unless ($g->load(speculative => 1));
  return($g->id);
}


sub getLine
{
  my $line = shift;
  my $lab = $LAB;
  # Set the lab by the line prefix
  if ($line =~ /^[A-Z]{3}_/) {
    my $prefix = substr($line,0,3);
    $lab = $PREFIX_MAP{$prefix} if (exists $PREFIX_MAP{$prefix});
  }
  # Override with Fly Core Lab ID
  if ($Flycore_labid) {
    $lab = lc($Flycore_labid);
    $lab =~ s/ +/_/g;
    switch ($lab) {
      case 'fly_facility' { $lab = 'fly'; }
      case 'fly_olympiad' { $lab = 'olympiad'; }
      case 'lee,_t'       { $lab = 'leet'; }
    }
  }
  $lab = 'none' if ('Not_Applicable' eq $line);
  # There are two pBDPGAL4U lines in Fly Core. Only this one is valid.
  $lab = 'olympiad' if ($line eq 'pBDPGAL4U');
  print $handle "Searching for $line [$lab]\n";
  # Check to make sure the lab exists
  unless (exists $LABID_MAP{$lab}) {
    push @message,"Lab $lab does not exist for line $line";
    print $handle "  Lab $lab does not exist\n" if ($DEBUG);
    return();
  }
  my $lab_id = $LABID_MAP{$lab};
  my $l;
  # Look for existing lines
  my $lines = JFRC::DB::SAGE::Line::Manager->get_line(
                query => [name => $line,
                organism_id => $Organism]);
  if (!scalar(@$lines)) {
    # Case 1: new line - insert it
    $l = JFRC::DB::SAGE::Line->new(lab => &getCVTermID(CV=>'lab',TERM=>$lab),
                                   name => $line,
                                   organism_id => $Organism);
    if ($l->load(speculative => 1)) {
      push @message,"Line $line was not found, but speculative load failed";
      print $handle "  Line $line was not found, but speculative load failed\n"
        if ($DEBUG);
      return();
    }
    if ($LINE_INSERTION) {
      eval {$l->save;};
      if ($@) {
        &submitJIRATicket({summary => "Could not insert $line into line table",
                           description => $@}) if ($JIRA_PID);
        &terminateProgram($@);
      }
      print $handle "  Added line $line (",$l->id,")\n" if ($DEBUG);
      $count{lineadd}++;
      return($l,'insert',$lab);
    }
    else {
      push @message,"Did not insert line $line; line insertion disabled";
      print $handle "Did not insert line $line; line insertion disabled\n" if ($DEBUG);
      return();
    }
  }
  elsif (1 == scalar(@$lines)) {
    # Case 2: one line exists in SAGE
    if ($lab_id == $lines->[0]{lab_id}) {
      # Case 2.1 - lab didn't change
      $l = $lines->[0];
      print $handle "  Found line $line (",$lines->[0]{id},")\n" if ($DEBUG);
      $count{linefound}++;
      return($lines->[0],'update',$lab);
    }
    else {
      # Case 2.2 - lab changed
      # Case 2.2.1 - we didn't check FlyCore (we might not have the "real" lab)
      if (!$CHECK_FLYCORE) {
        print $handle "  Found line $line (",$lines->[0]{id},")\n" if ($DEBUG);
        $count{linefound}++;
        return($lines->[0],'update',$lab);
      }
      # Case 2.2.2 - we checked FlyCore, and it's different
      my($row_count) = $sth{UPDATE_LAB}->execute($lab_id,$lines->[0]{id});
      if ($row_count) {
        push @message,"Updated lab for line $line to $lab";
        print $handle "  Found line $line (",$lines->[0]{id},"), updated lab\n" if ($DEBUG);
        $count{linelab}++;
        $lines->[0]{lab_id} = $lab_id;
        return($lines->[0],'update',$lab);
      }
      else {
        push @message,"Could not update lab for line $line to $lab";
        print $handle "  Could not update lab for line $line (",$lines->[0]{id},")\n" if ($DEBUG);
        return();
      }
    }
  }
  else {
    # Case 3: Multiple lines exist in SAGE
    push @message,"Line $line is in SAGE more than once";
    print $handle "  Line $line is in SAGE more than once\n" if ($DEBUG);
    $count{linenotfound}++;
    return();
  }
}


sub getImage
{
  my($l,$row) = @_;
  my $op = 'update';
  my $i = JFRC::DB::SAGE::Image->new(name => $row->{$IMAGE_KEY},
                                     source_id => &getCVTermID(CV=>'lab',TERM=>$row->{source}),
                                     family_id => &getCVTermID(CV=>'family',TERM=>$row->{family}),
                                     line_id => $l->{id});          
  if ($i->load(speculative => 1)) {
    print $handle '  Found image ',$row->{$IMAGE_KEY},' (',$i->id,")\n"
      if ($DEBUG);
    $count{imagefound}++;
    if (('light_imagery' eq $BASE_CV)
        && ('rubin' eq $LAB || 'baker' eq $LAB || 'zlatic' eq $LAB || 'flylight' eq $LAB || 'simpson' eq $LAB || 'leet' eq $LAB || 'jacs' eq $username)) {
      &modifyImageRecord($i,$row);
    }
    if (('light_imagery' eq $BASE_CV) && ('rubin' eq $LAB)) {
      &addWIPData($i,$row);
    }
  }
  elsif (('light_imagery' eq $BASE_CV)
         && (('rubin' eq $LAB && $row->{designator} !~ /external/)
             || ('baker' eq $LAB && $row->{designator} !~ /biorad/)
             || ('zlatic' eq $LAB && $row->{designator} =~ /peripheral/))) {
    printf $handle "  Awaiting image load for %s\n",$row->{$IMAGE_KEY}
      if ($DEBUG);
    $count{incomplete}++;
    return(0);
  }
  else {  	
    $i->url($row->{url}) if ($row->{url});
    $i->path($row->{path}) if ($row->{path});
    if ($row->{date}) {
      (my $cd = $row->{date}) =~ s/\//-/g;
      $i->capture_date($cd);
    }
    $i->representative($row->{representative}||0);
    $i->created_by($row->{created_by}||$username);
    eval {$i->save;};
    
    if ($@) {
      &submitJIRATicket({summary => "Could not insert " . $row->{$IMAGE_KEY}
                         . ' into image table',
                         description => $@}) if ($JIRA_PID);
      print $handle "key: $row->{$IMAGE_KEY}\n";
      print $handle "source_id: " . &getCVTermID(CV=>'lab',TERM=>$row->{source}) . "\n";
      print $handle "family_id: " . &getCVTermID(CV=>'family',TERM=>$row->{family}) . "\n";
      print $handle "line_id: " . $l->{id} . "\n";
      &terminateProgram($@);
    }
    
    $op = 'insert';
    print $handle '  Added image ',$row->{$IMAGE_KEY},' (',$i->id,")\n"
      if ($CHANGELOG || $DEBUG);
    
    $count{imageadd}++;
  }
  return($i,$op);
}


sub modifyImageRecord
{
  my($i,$row) = @_;
  $i->url($row->{url}) if ($row->{url});
  $i->path($row->{path}) if ($row->{path});
  $i->representative($row->{representative})
    if ($row->{representative});
  if ($row->{date}) {
    (my $cd = $row->{date}) =~ s/\//-/g;
    $i->capture_date($cd);
  }
#  $i->created_by($row->{created_by}||$username);
  $i->save;
    eval {$i->save;};
    if ($@) {
      &submitJIRATicket({summary => 'Could not modify image ' . $i->id
                                    . 'in line table',
                         description => $@}) if ($JIRA_PID);
      &terminateProgram($@);
    }
}


sub addWIPData
{
  my($i,$row) = @_;
  $sth{BATCH}->execute($i->id);
  my($ihc_batch) = $sth{BATCH}->fetchrow_array();
  return unless ($ihc_batch);
  # Add batch information
  $sthw{BN}->execute($ihc_batch);
  ($row->{ihc_batch_number}) = $sthw{BN}->fetchrow_array();
  &addGeneral($i,$row,('ihc_batch_number')x2,'imageprop');
  # Add dissection information
  $sthw{EVENT}->execute($row->{line},$ihc_batch,'Dissection');
  ($row->{dissection_date},$row->{dissector}) = $sthw{EVENT}->fetchrow_array();
  &addGeneral($i,$row,($_)x2,'imageprop')
    foreach (qw(dissection_date dissector));
  # Add mounting information
  $sthw{EVENT}->execute($row->{line},$ihc_batch,'Mounting');
  ($row->{mount_date},$row->{mounter}) = $sthw{EVENT}->fetchrow_array();
  &addGeneral($i,$row,($_)x2,'imageprop')
    foreach (qw(mount_date mounter));
}


sub addSecondaryData
{
  my($i,$row) = @_;
  if ($row->{secdata_store}) {
    # Handle non-substack secondary data
    foreach my $product (split(/\s*,\s*/,$row->{secdata_store})) {
      (my $type = $product) =~ s/_.+//;
      # Outlier: projection reference sums are in the "reference" directory
      $type = 'reference' if ($product =~ /projection_ref_/);      
      # Outlier: VNC alignment projections are in the "registration" directory
      $type = 'registration' if ($product =~ /projection_vnc/);      
      &insertSecondaryFile($row,$product,$type,$i->{id});
    }
  }
  if ($row->{substack_store}) {
    # Substacks
    my $wildcard = '*.jpg';
    $wildcard = '-' . $wildcard if ($row->{family} =~ /^zlatic_medial/);
    my @list = glob(join('/',$row->{projection_dir},$row->{stack}).$wildcard);
    my $channel = 0;
    if ($row->{family} =~ /larval_.+_hires/) {
      foreach my $product (split(/\s*,\s*/,$row->{substack_store})) {
        @list = glob(join('/',$row->{$product.'_dir'},$row->{$product.'_file'}));
        (my $type = $product) =~ s/_.+//;
        foreach (@list) {
          print $handle "  $product: [$_]\n";
          $row->{$product.'_file'} = basename($_);
          &insertSecondaryFile($row,$product,$product,$i->{id});
        }
      }
    }
    else {
    foreach my $product (split(/\s*,\s*/,$row->{substack_store})) {
      (my $type = $product) =~ s/_.+//;
      foreach (@list) {
        next if (/_(?:00|total).jpg/);
        next if ($row->{family} =~ /^zlatic_medial/ && !/-sliced-projection-/);
        if (/-sliced-projection-/) {
          # Zlatic lab
          my $p = (/composite/) ? 0 : 2;
          next unless ($p == $channel);
          $row->{$product.'_file'} = basename($_);
          &insertSecondaryFile($row,$product,'projection',$i->{id});
        }
        elsif (/_p\d+_\d+.jpg/) {
          # Lee lab
          my($p) = $_ =~ /_p(\d+)_\d+\.jpg/;
          $p ||= 0;
          next unless ($p == $channel);
          $row->{$product.'_file'} = basename($_);
          &insertSecondaryFile($row,$product,'projection',$i->{id});
        }
        else {
          # All other labs
          my($ch) = $_ =~ /_ch(\d+)_/;
          $ch ||= 0;
          next unless ($ch == $channel);
          $row->{$product.'_file'} = basename($_);
          &insertSecondaryFile($row,$product,'projection',$i->{id});
        }
      }
      $channel += (('leet' eq $LAB) ? 1 : 2);
    }
    }
  }
}


sub insertSecondaryFile
{
  my($row,$product,$type,$iid) = @_;
  # File
  my $file;
  unless ($file = $row->{$product.'_file'}) {
    print $handle "  $product","_file is not defined\n" if ($DEBUG);
    return;
  }
  # Image name
  unless ($row->{$type.'_loc'}) {
    print $handle "  $type","_loc is not defined\n" if ($DEBUG);
    return;
  }
  my $image_name = join('/',$row->{$type.'_loc'},$file);
  # File path
  unless ($row->{$type.'_dir'}) {
    print $handle "  $type","_dir is not defined\n" if ($DEBUG);
    return;
  }
  my $file_path = join('/',$row->{$type.'_dir'},$file);
  if (($file =~ /\.reg\.local\.jpg/) || ($file =~ /-PP-warp\.png/)){
  	$product = "projection_local_registered";
  }
  my $si = JFRC::DB::SAGE::SecondaryImage->new(name => $image_name,
               image_id => $iid,
               product_id => &getCVTermID(CV=>'product',TERM=>$product));
  my $need_checksum = 1;
  if ($si->load(speculative => 1)) {
    print $handle "  Found $product $file",' (',$si->id,")\n" if ($DEBUG);
    $count{secimagefound}++;
    $sths{CHECK}->execute($si->id);
    my($c) = $sths{CHECK}->fetchrow_array;
    $need_checksum = 0 if ($c);
    $count{checksumfound}++;
  }
  else {
    if (-e $file_path) {
      # Insert into SAGE secondary_image
      $si->name($image_name);
      $si->path($file_path);
      my $url = join('/','http://img.int.janelia.org',$row->{img_application},
                     $row->{designator} . '-secondary-data',
                     ,uri_escape($image_name));
      $si->url($url);
      eval {$si->save;};
      if ($@) {
        &submitJIRATicket({summary => "Could not insert $image_name into secondary_image table",
                           description => $@}) if ($JIRA_PID);
        &terminateProgram($@);
      }
      print $handle "  Added $product $file",' (',$si->id,")\n" if ($DEBUG);
      $count{secimageadd}++;
    }
    else {
      print $handle "  Could not find $product","_file $file_path\n" if ($DEBUG);
      return;
    }
  }
  # Calculate and store checksum
  if ($need_checksum) {
    my $checksum = &getChecksum($file_path);
    if ($checksum) {
      my($ret) = $sths{INSERT}->execute($si->id,'secondary_image',$checksum);
      print $handle "  Inserted checksum $checksum\n" if ($ret && $DEBUG);
      $count{checksumadd}++;
    }
  }
}


sub getChecksum
{
  my $file_path = shift;
  unless (-e $file_path) {
    print $handle "  File $file_path does not exist\n";
    return(0);
  }
  open SLURP,$file_path;
  sysread SLURP,my $slurp,-s SLURP;
  close(SLURP);
  if ($slurp) {
    my $digest = md5_hex($slurp);
    return($digest);
  }
  else {
    print $handle "  Could not calculate checksum for $file_path\n";
    return(0);
  }
}


sub getExperiment
{
  my($exp,$cv_term,$line_id,$row) = @_;
  my $name = $row->{$EXPERIMENT_KEY};
  my $experimenter = $row->{experimenter} || '';
  my $type_id = &getCVTermID(CV=>$exp,TERM=>$cv_term);
  &terminateProgram("Could not find CV term $exp/$cv_term") unless ($type_id);
  my $e = JFRC::DB::SAGE::Experiment->new(type_id => $type_id,
                                          name => $name,
                                          lab_id => &getCVTermID(CV=>'lab',
                                                                 TERM=>$LAB),
                                          experimenter => $experimenter||$username);
  if ($e->load(speculative => 1)) {
    print $handle "  Found experiment $exp (",$e->id,") for line $line_id ",
                  "($name)\n" if ($DEBUG);
    $count{experimentfound}++;
  }
  elsif ($NO_NEW_EXPERIMENTS) {
    print $handle "  Will not add new experiment $exp for line $line_id ",
                  "($name)\n" if ($DEBUG);
    return(0);
  }
  else {
    eval {$e->save;};
    if ($@) {
      &submitJIRATicket({summary => "Could not insert $exp into experiment table",
                         description => $@}) if ($JIRA_PID);
      &terminateProgram($@);
    }
    print $handle "  Added experiment $exp (",$e->id,") for line $line_id ",
                  "($name)\n" if ($CHANGELOG || $DEBUG);
    $row->{manual_pf} = 'U' if ($exp =~ /olympiad/i);
    $count{experimentadd}++;
  }
  return($e);
}


sub insertCVTerm
{
  my($cv,$term) = @_;
  $sth{CVI}->execute($cv);
  my($cv_id) = $sth{CVI}->fetchrow_array();
  return(0) unless ($cv_id);
  print $handle "  Adding CV term $cv ($cv_id)/$term\n" if ($DEBUG);
  $sth{CVINSERT}->execute($cv_id,($term)x2,"$term (inserted by sage_loader)");
  return(&getCVTermID(CV=>$cv,TERM=>$term));
}


sub getSession
{
  my %arg = ((map { $_ => '' } qw(cv cvterm experiment line name)),@_);
  $arg{cvterm} = $arg{cv} unless ($arg{cvterm});
  my $line_id = $arg{line}->id;
  my $name = $arg{name};
  my %extra;
  $extra{experiment_id} = $arg{experiment}->id if ($arg{experiment});
  my $type_id = &getCVTermID(CV=>$arg{cv},TERM=>$arg{cvterm});
  $type_id = &insertCVTerm($arg{cv},$arg{cvterm})
    if ($CV_INSERTION && !$type_id);
  &terminateProgram("Could not find CV term $arg{cv}/$arg{cvterm}")
    unless ($type_id);
  my $s = JFRC::DB::SAGE::Session->new(type_id => $type_id,
                                       line_id => $line_id,
                                       name => $name,
                                       lab_id => &getCVTermID(CV=>'lab',
                                                              TERM=>$LAB),
                                       annotator => $username,
                                       %extra);
  if ($s->load(speculative => 1)) {
    print $handle "  Found session $arg{cvterm} (",$s->id,') for line ',
                  "$line_id ($name)\n" if ($DEBUG);
    $count{sessionfound}++;
  }
  else {
    $s->experiment_id($arg{experiment}->id) if ($arg{experiment});
    eval {$s->save;};
    if ($@) {
      &submitJIRATicket({summary => "Could not insert $name into session table",
                         description => $@}) if ($JIRA_PID);
      &terminateProgram($@);
    }
    print $handle "  Added session $arg{cvterm} (",$s->id,') for line ',
                  "$line_id ($name)\n" if ($CHANGELOG || $DEBUG);
    $count{sessionadd}++;
    $session_inserted = 1;
  }
  return($s);
}


sub addGeneral
{
  my($s,$row,$type,$rowtype,$add,$run_num) = @_;
  if ($row->{$type} && exists($VALUE_REMAP{$type}{$row->{$type}})) {
    print $handle "  Remapped $row->{$type} to $VALUE_REMAP{$type}{$row->{$type}}\n"
      if ($DEBUG);
    $row->{$type} = $VALUE_REMAP{$type}{$row->{$type}};
  }
  my $cv = ($add eq 'lineprop') ? 'line' : $BASE_CV;
  $cv = 'light_imagery' if ($add eq 'imageprop');
  $cv = $ALT_CV{$type} if (exists $ALT_CV{$type});
  return unless &checkValue($row,$rowtype,$type,$cv);
  my $value = (exists $REMAP{$type}) ? &remapValue($type,$row->{$rowtype})
                                     : $row->{$rowtype};
  my $x;
  my $tid = &getCVTermID(CV=>$cv,TERM=>$type)
    || &terminateProgram("Term $type for CV $cv is not defined");
  switch ($add) {
    case 'lineprop' {
      $x = JFRC::DB::SAGE::LineProperty->new(line_id => $s->id,
                                             type_id => $tid);
    }
    case 'experimentprop' {
      $x = JFRC::DB::SAGE::ExperimentProperty->new(experiment_id => $s->id,
                                                   type_id => $tid);
    }
    case 'sessionprop' {
      $x = JFRC::DB::SAGE::SessionProperty->new(session_id => $s->id,
                                                type_id => $tid);
    }
    case 'imageprop' {
      $x = JFRC::DB::SAGE::ImageProperty->new(image_id => $s->id,
                                              type_id => $tid);
    }
    case 'observation' {
      $x = JFRC::DB::SAGE::Observation->new(session_id => $s->id,
               term_id => &getCVTermID(CV=>$cv,TERM=>NA),
               type_id => $tid);
    }
    case 'score' {
      $x = JFRC::DB::SAGE::Score->new(session_id => $s->id,
               term_id => &getCVTermID(CV=>$cv,TERM=>NA),
               type_id => $tid,
               run => $run_num);
    }
  }
  my $changed = 0;
  if ($x->load(speculative => 1)) {
    if ($value eq $x->value) {
      print $handle "  Found $add $type (".$x->value.")\n" if ($DEBUG);
      $count{$add.'found'}++;
    }
    elsif (($type eq 'manual_pf') && ($x->value ne 'U') && ($value eq 'U')) {
      print $handle "  Will not change $add $type (".$x->value.") back to U\n"
        if ($DEBUG);
      $count{$add.'found'}++;
    }
    elsif (exists $DO_NOT_UPDATE{$type}) {
      print $handle "  Will not change $add $type\n" if ($DEBUG);
      $count{$add.'found'}++;
    }
    else {
      print $handle "  Modified $add $type from (" . $x->value
                    . ") to ($value)\n" if ($CHANGELOG || $DEBUG);
      $count{$add.'modify'}++;
      $changed++;
    }
  }
  else {
    $changed++;
    print $handle "  Added $add $type ($value)\n" if ($CHANGELOG || $DEBUG);
    $count{$add.'add'}++;
  }
  if ($changed) {
    $x->value($value);
    eval {$x->save;};
    if ($@) {
      &submitJIRATicket({summary => "Could not insert/update $add/$type",
                         description => $@}) if ($JIRA_PID);
      &terminateProgram($@);
    }
  }
}


sub checkValue
{
  my($row,$type,$storetype,$cv) = @_;
  &terminateProgram("There is no $type field for " . $row->{line})
    unless (exists $row->{$type});
  return(0) unless (defined($row->{$type}));
  # Trim leading and trailing quotes
  $row->{$type} =~ s/^"//;
  $row->{$type} =~ s/"$//;
  # Trim leading and trailing spaces
  $row->{$type} =~ s/^\s+//;
  $row->{$type} =~ s/\s+$//;
  return(0) unless (length($row->{$type}));
  # Basic regex validation
  my $dt = &getCVTermType(CV=>$cv,TERM=>$storetype);
  $row->{$type} = uc($row->{$type}) if ($dt eq 'boolean' || $dt eq 'pf');
  my $validate = &getCVTermDefinition(CV=>'regex',TERM=>$dt||'text');
  unless ($row->{$type} =~ /^$validate$/) {
    print $handle "  Invalid $type [$dt $validate] for ",$row->{line},' (',
                  $row->{$type},")\n";
    &submitJIRATicket({summary => "Invalid $type for " . $row->{line},
        description => "Invalid $type [$dt $validate] for " . $row->{line}
                       . ' (' . $row->{$type} . ')'}) if ($JIRA_PID);
    $count{invalid}++;
    return(0);
  }
  # CV validation
  if ((exists $VALIDATE{$type}) && (!exists $valid{$type}{$row->{$type}})) {
    $sth{CV}->execute($VALIDATE{$type},$row->{$type});
    my($cvt) = $sth{CV}->fetchrow_array();
    print $handle "  Validating $type $row->{$type} against CV "
                  . "$VALIDATE{$type}\n" if ($DEBUG);
    if ($cvt) {
      $valid{$type}{$row->{$type}}++;
    }
    else {
      print $handle "  Invalid value for $type for ",$row->{line},' (',
                    $row->{$type},")\n";
      &submitJIRATicket({summary => "Invalid $type for " . $row->{line},
          description => "Invalid $type for " . $row->{line} . ' ('
                         . $row->{$type} . ')'}) if ($JIRA_PID);
      $count{invalid}++;
      return(0);
    }
  }
  return(1);
}


sub remapValue
{
  my($type,$value) = @_;
  my $new = &getCVTermDisplay(CV=>$REMAP{$type},TERM=>$value);
  print $handle "  Remap $value to $new using $REMAP{$type}\n"
    if ($DEBUG && length($new));
  return(length($new)) ? $new : $value;
}


# ****************************************************************************
# * Subroutine:  computeElapsedTime                                          *
# * Description: Convert an elapsed time in Epoch seconds to English         *
# *              notation. Epoch seconds is the number of seconds past the   *
# *              "Epoch", which any self-respecting Unix geek knows as 00:00 *
# *              UTC on January 1, 1970.                                     *
# *                                                                          *
# * Parameters:  diff: number of seconds between events                      *
# * Returns:     elapsed time as [D days] HH:MM:SS                           *
# ****************************************************************************
sub computeElapsedTime
{
my $result = '';

  my $diff = shift;
  $diff = ($diff - (my $ss = $diff % 60)) / 60;
  $diff = ($diff - (my $mm = $diff % 60)) / 60;
  $diff = ($diff - (my $hh = $diff % 24)) / 24;
  $result = sprintf "%d day%s, ",$diff,(1 == $diff) ? '' : "s"
      if ($diff >= 1);
  $result .= sprintf "%02d:%02d:%02d",$hh,$mm,$ss;
  return($result);
}


sub submitJIRATicket
{
  my $submit = shift;
  $submit->{pid} = $JIRA_PID;
  $submit->{issuetype} = 6;
  $submit->{assignee} = $JIRA_ASSIGNEE if ($JIRA_ASSIGNEE);
  my $jira_url = "http://issuetracker/issuetracker/secure/CreateIssueDetails.jspa?";
  my @parms = map {join('=',$_,$submit->{$_})} keys %$submit;
  $jira_url .= join('&',@parms);
  my $browser = LWP::UserAgent->new;
  my $response = $browser->get($jira_url);
}


sub tryLock {
  my ($fh) = @_;
  # try to obtain an exclusive lock in a non-blocking fashion.
  return flock($fh, LOCK_EX | LOCK_NB);
}


sub tryLockMaxWait {
  my ($fh,$maxTries) = @_;
  for (my $i = $maxTries; $i > 0; $i--) {
    if (tryLock($fh)) {
      return 1;
    } else {
      print $handle "PID $$ waiting for lock, $i attempts remaining\n" if ($VERBOSE);
      sleep 1;
    }
  }
  return 0;
}


sub unlock {
  my ($fh) = @_;
  flock($fh, LOCK_UN) or die "Cannot unlock mutex - $!\n";
}



# ****************************************************************************
# * Parse::RecDescent subroutines                                            *
# ****************************************************************************

# ****************************************************************************
# * Subroutine:  Parse::RecDescent::assign                                   *
# * Description: This routine will accept a Parse::RecDescent %item hash     *
# *              and return a key/value pair for every scalar value, and a   *
# *              flattened hash for every value that is a hash. Any key      *
# *              starting with "__" (as in "__RULE__") is ignored.           *
# *                                                                          *
# * Parameters:  item_ref: reference to the Parse::RecDescent %item hash     *
# * Returns:     Flattened Parse::RecDescent %item hash                      *
# ****************************************************************************
sub Parse::RecDescent::assign
{
  my $item_ref = shift;
  my %data = ();
  foreach my $key (grep(!/^__/,keys %$item_ref)) {
    if ('HASH' eq ref($item_ref->{$key})) {
      $data{$_} = $item_ref->{$key}{$_} foreach (keys %{$item_ref->{$key}});
    }
    elsif ('ARRAY' eq ref($item_ref->{$key})) {
      (my $nk = $key) =~ s/\(.+//;
      $data{$nk} = (scalar @{$item_ref->{$key}}) ? $item_ref->{$key}->[0] : '';
    }
    else {
      $data{$key} = $item_ref->{$key};
    }
  }
  return(%data);
}


# ****************************************************************************
# * POD documentation                                                        *
# ****************************************************************************
__END__

=head1 NAME

sage_loader - load data into SAGE

=head1 SYNOPSIS

sage_loader [-lab <lab>] [-reload]
            [-output <output file>] [-development]
            [-test] [-verbose] [-debug] [-help]

=head1 DESCRIPTION

This program will recursively search a directory structure to find grooming
images and video to insert into the image management database. Images are TIF
files, and will be converted to JPG format. The video or [converted] image will
be stored as a primary image in the image database, with necessary metadata
(including line and body area, which are extracted from the file path). If a
file with a .txt extension is found, it is assumed to contain comments for a
given line/product/area (extracted from file path).

=head1 RUN INSTRUCTIONS

Monitoring output goes to STDOUT, unless redirected by the -output parameter.

The following options are supported:

  -lab:         (optional) lab to update data for [simpson]
  -reload:      (optional) image records in the database will be recreated
  -output:      (optional) send monitoring output to specified file
  -development: (optional) run against development manifold
  -test:        (optional) display changes, but do not update the database
  -verbose:     (optional) display monitoring output (chatty)
  -debug:       (optional) display monitoring output (chatty in the extreme)
  -help:        (optional) display usage help and exit

Options must be separated by spaces.

All output goes to STDOUT, unless redirected by the -output parameter.

=head1 EXAMPLES

The following command:

  load_grooming_images -lab simpson

=head1 EXIT STATUS

The following exit values are returned:

   0  Successful completion

  -1  An error occurred

=head1 BUGS

None known.

=head1 AUTHOR INFORMATION

Copyright 2008 by Howard Hughes Medical Institute

Author: Robert R. Svirskas, HHMI Janelia Farm Research Campus

Address bug reports and comments to:
svirskasr@janelia.hhmi.org

=cut
