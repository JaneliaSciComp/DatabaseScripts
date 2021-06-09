#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing bowl mv's"
echo "..refreshing bowl experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_bowl_experiment_data_mv.sql
echo "..done @ `date`"
echo "..refreshing bowl picklist values @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/olympiad_bowl_picklist.sql
echo "..done @ `date`"
echo ".done"
