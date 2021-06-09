#!/bin/sh

MYSQL_HOME="/opt/mysql"
MYSQL_DATA_DIR="/opt/mysql-data"
MYSQL_SOCKET_FILE="/tmp/mysql.sock"
MYSQL_PSWD=""

# remove query log file
rm $MYSQL_DATA_DIR/query.log

# flush mysql logs
$MYSQL_HOME/bin/mysqladmin flush-logs -u root -p$MYSQL_PSWD -S $MYSQL_SOCKET_FILE

# capture into array the bin log file names in reverse alphabetical order
cd $MYSQL_DATA_DIR
binlogs=(`ls -r bin.0*`)
# capture into variable the number of elements in array
numbinlogs=${#binlogs[@]}

# if number of elements is greater than zero then purge bin logs to first log in array
if [ $numbinlogs -gt 0 ]
then
   mysql -u root -p$MYSQL_PSWD -S $MYSQL_SOCKET_FILE -e "PURGE MASTER LOGS TO '${binlogs[@]:0:1}'"
fi

exit 0
