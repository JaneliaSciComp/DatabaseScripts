#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing throughput report mv's"
echo "..refreshing mv @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/olympiad_runs_unique_mv.sql
echo "..done @ `date`"
echo ".done"
