#!/bin/bash
# Usage : ./go2clustrix2.sh $DBNAME

DBNAME=$1

BASEDIR=/clustrix/migration
MYSQLDUMP=/bin/mysqldump

cd $BASEDIR
mysql -e "CREATE DATABASE $DBNAME"

$MYSQLDUMP -u root -pXXXXXXX -h clustrix1 $DBNAME > $DBNAME.dmp 

clustrix_import -H clustrix2003 -u root -i $DBNAME.dmp -D $DBNAME -pXXXXXXX

echo "Do you want to continue to remove dump file (y/n)? "
read input;

if [ "$input" == "y" ]
then
    echo "Removing $DBNAME.dmp file "
    rm $DBNAME.dmp
fi

