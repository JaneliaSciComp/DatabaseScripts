#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing Genie mv's"
echo "..refreshing query report vw @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/query_report_vw.sql
echo "..done @ `date`"
echo "..refreshing lineup vw @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/lineup_vw.sql
echo "..done @ `date`"
echo ".done"
