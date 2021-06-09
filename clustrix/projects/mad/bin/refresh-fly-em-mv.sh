#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

echo "Refreshing Fly EM mv's"
echo "..refreshing fly em annotation vw @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/fly_em_annotations_vw.sql
echo "..done @ `date`"
echo ".done"
