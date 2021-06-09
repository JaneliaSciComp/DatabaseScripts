#! /bin/bash

ORACLE_HOME="/opt/oracle/product/10.2.0/db_1"
ORACLE_SID=""
BACKUPDIR="${ORACLE_HOME}/admin/${ORACLE_SID}/dpdump"
DATE=`date +%Y%m%d%R`
USER=""
PSWD=""

${ORACLE_HOME}/bin/expdp ${USER}/${PSWD}@${ORACLE_SID} full=y dumpfile=full-export-${DATE}.dmp logfile=full-export-${DATE}.log

gzip ${BACKUPDIR}/full-export-${DATE}.dmp

