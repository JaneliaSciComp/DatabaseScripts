#! /bin/ksh
MYSQL_DIR="/opt/mysql/bin"
DDL_DIR="../ddl"
DATA_DIR="../data"
SQL_DIR="../sql"

rm webhelpdesk-mysql0.dmp
${MYSQL_DIR}/mysqldump -t -h mysql0 -u root -p webhelpdesk_p --max_allowed_packet=2147483648 > ${DATA_DIR}/webhelpdesk-mysql0.dmp

# 
# set global max_allowed_packet=1000000000;
# set global net_buffer_length=1000000; 
#
${MYSQL_DIR}/mysql -h mysql1 -u root -p webhelpdesk --max_allowed_packet=2147483648 < ${DATA_DIR}/webhelpdesk-mysql0.dmp
