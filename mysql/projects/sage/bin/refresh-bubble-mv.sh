#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing bubble mv's"
echo "..refreshing bubble experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_bubble_experiment_data_mv.sql
echo "..done @ `date`"
echo "..refreshing bubble picklist values @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/olympiad_bubble_picklist.sql
echo "..done @ `date`"
echo ".done"
