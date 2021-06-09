#!/bin/bash
#BASEDIR=/opt/mysql/bin/mysql
#BACKUPDIR=/opt/mysql-dump
DATE=`date +%Y%m%d%H%M`
MYSQLDUMP=/opt/mysql/bin/mysqldump

#cd $BACKUPDIR
$MYSQLDUMP --single-transaction --max_allowed_packet=1G --host=prd-db --user=flyfAdmin --password=fr3ngu3ll1s@urus flyboy > flyboy-dump-$DATE.sql

#cd $BASEDIR
mysql -h val-db -u flyfAdmin -pf1yf@dm1n --execute "drop database flyboy"
mysql -h val-db -u flyfAdmin -pf1yf@dm1n --execute "create database flyboy"
mysql -h val-db -u flyfAdmin -pf1yf@dm1n flyboy < flyboy-dump-$DATE.sql

rm -rf flyboy-dump-$DATE.sql
