#! /bin/ksh

DB_NAME=$1

BASEDIR="/opt/mysql"
BACKUPDIR="/opt/mysql-dump"
DATE=`date +%Y%m%d`

${BASEDIR}/bin/mysqldump -P 3306 -u root -p ${DB_NAME} > ${BACKUPDIR}/full-backup-${DB_NAME}-${DATE}.dmp
gzip ${BACKUPDIR}/full-backup-${DB_NAME}-${DATE}.dmp

