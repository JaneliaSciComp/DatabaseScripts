#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing box mv's"
echo "..refreshing box experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_box_experiment_data_mv.sql
echo "..done @ `date`"
echo "..refreshing box picklist values @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/olympiad_box_picklist.sql
echo "..done @ `date`"
echo ".done"
