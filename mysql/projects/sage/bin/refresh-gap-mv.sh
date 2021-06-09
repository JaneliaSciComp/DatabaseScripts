#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing gap mv's"
echo "..refreshing gap experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_gap_experiment_data_mv.sql
echo "..done @ `date`"
echo "..refreshing gap picklist values @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/olympiad_gap_picklist.sql
echo "..done @ `date`"
echo ".done"
