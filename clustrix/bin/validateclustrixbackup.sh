#!/bin/sh
SERVER=
PASSWORD=

NOW="$(date +'%Y%m%d')"
echo "Date" $NOW
OUT=/tmp/out.txt
ERROR=""

echo "" > /tmp/out.txt
echo "***************** $SERVER Backups Report *******************" >> /tmp/out.txt
echo "*****************      $NOW            *******************" >> /tmp/out.txt
echo "*****************      small-dbs           *******************" >> /tmp/out.txt
echo "" >> /tmp/out.txt

/opt/mysql/bin/mysql -h $SERVER -u root -p$PASSWORD -e "SELECT * from system.backups where source='ftp://clustrixbackup:clustrix123@10.80.1.144/ifs/home/clustrixbackup/$SERVER/small-dbs' order by completed_time desc limit 1\G" >> $OUT

echo "" >> /tmp/out.txt

status=`grep "$NOW" /tmp/out.txt && grep "COMPLETED" $OUT`

    if [ $? -eq 0 ]
    then
       echo "small-db backups was successful" >> $OUT
    else
       echo "small-db backups was NOT successful" >> $OUT
       ERROR="**ERROR**"
    fi

echo "************************************************************" >> /tmp/out.txt

cat /tmp/out.txt | mailx -s "$SERVER Backups Report $ERROR" dolafit@janelia.hhmi.org

