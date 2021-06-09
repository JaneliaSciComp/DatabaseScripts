#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing aggression mv's"
echo "..refreshing aggression experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_aggression_experiment_data_mv.sql
echo "..done @ `date`"
echo "..refreshing aggression picklist values @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/olympiad_aggression_picklist.sql
echo "..done @ `date`"
echo ".done"
