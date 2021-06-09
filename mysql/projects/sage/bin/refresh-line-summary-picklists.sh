#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing line summary picklist values @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/line_summary_picklist.sql
echo "done @ `date`"
