#!/bin/sh
BASE_DIR=/opt/mysql/bin
$BASE_DIR/mysql -h localhost -u root -p -e "show slave status \G" > /tmp/output.txt
IOStatus=`grep "Slave_IO_Running:" /tmp/output.txt | cut -d ':' -f2` 
SQLStatus=`grep "Slave_SQL_Running:" /tmp/output.txt | cut -d ':' -f2` 
echo $IOStatus
echo $SQLStatus
if [ $IOStatus == "No" ] || [ $SQLStatus == "No" ] 
then
   cat "/tmp/output.txt" | /bin/mail -s "Larval-sage-db Slave_IO_Running : $IOStatus, Slave_SQL_Running : $SQLStatus " dolafit@janelia.hhmi.org
fi

