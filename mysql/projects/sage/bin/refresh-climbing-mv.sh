#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing climbing mv's"
echo "..refreshing climbing experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_climbing_experiment_data_mv.sql
echo "..done @ `date`"
echo "..refreshing climbing picklist values @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/olympiad_climbing_picklist.sql
echo "..done @ `date`"
echo ".done"
