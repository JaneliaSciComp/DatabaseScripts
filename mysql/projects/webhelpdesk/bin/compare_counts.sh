#! /bin/ksh
MYSQL_DIR="/opt/mysql/bin"
DDL_DIR="../ddl"
DATA_DIR="../data"
SQL_DIR="../sql"

# Compare counts
${MYSQL_DIR}/mysql -v -h mysql1 -u root -p webhelpdesk < ${SQL_DIR}/count-mysql1.sql > ${DATA_DIR}/mysql1.count
${MYSQL_DIR}/mysql -v -h mysql0 -u root -p webhelpdesk_p < ${SQL_DIR}/count-mysql0.sql > ${DATA_DIR}/mysql0.count

