#!/bin/bash

DATE=`date +%Y%m%d%H%M`
BACKUPDIR=/opt/pgsql-dump
PGDATA=/opt/pgsql-data
PGSQL_HOME=/opt/pgsql

echo "select pg_start_backup('full - $DATE');" | $PGSQL_HOME/bin/psql
cd $PGDATA
tar -zcvf $BACKUPDIR/full-dump-pit-$DATE.tar.gz .
echo "select pg_stop_backup();" | $PGSQL_HOME/bin/psql

