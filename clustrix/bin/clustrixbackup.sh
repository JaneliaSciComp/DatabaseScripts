#!/bin/sh
SERVER=clustrix2
DATABASES="ahrens_lemur campus_security construct dmel flynet galaxy gbrowse_login geci_lemur genie hocs janeliareports jfrc_resources job_manager koyama_lemur looger_lemur mad meetingroom molbio odor parking parts plasmapper portfolio probes qstatworld research_tools ror scheduleit sequencer_requests simpson_lemur smith_lemur sternson_lemur tethered_flight visitorprojecttracker vivarium_manager worm_tracker zhang_lemur chargeback niko"

for db in ${DATABASES} ; do
  NOW="$(date +'%Y%m%d%H%M%S')"
  FTP_URL=ftp://clustrixbackup:clustrix123@10.40.6.195/ifs/home/clustrixbackup/$SERVER/$db/$NOW
  mysql -e "BACKUP $db.* TO '$FTP_URL'"
done
