#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing trikinetics mv's"
echo "..refreshing trikinetics experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_trikinetics_experiment_data_mv.sql
echo "..done @ `date`"
echo "..refreshing trikinetics picklist values @ `date`"
# mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/olympiad_trikinetics_picklist.sql
echo "..done @ `date`"
echo ".done"
