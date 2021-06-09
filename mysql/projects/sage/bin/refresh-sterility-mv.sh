#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing sterility mv's"
echo "..refreshing sterility experiment mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_sterility_experiment_data_mv.sql
echo "..done @ `date`"
echo ".done"
