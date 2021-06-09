#! /bin/ksh
MYSQL_DIR="/opt/mysql/bin"
DDL_DIR="../ddl"
DATA_DIR="../data"
SQL_DIR="../sql"

# STOP Webhelpdesk server
ssh workorder
su - tomcat -c "/opt/whdworkorder/bin/whd -u stop"

# create database on mysql1
${MYSQL_DIR}/mysql -h mysql1 -u root -p < ${DDL_DIR}/workorderDBBuild.sql

# create schema objects
${MYSQL_DIR}/mysql -h mysql1 -u root -p workorder < ${DDL_DIR}/schema.sql

# Production mysql0 data dump
${MYSQL_DIR}/mysqldump -h mysql0 -u root -p -t workorder_p > ${DATA_DIR}/mysql0-data.dmp

# InnoDB mysql1 data load
${MYSQL_DIR}/mysql -h mysql1 -u root -p workorder < ${DATA_DIR}/mysql0-data.dmp

# Compare counts
${MYSQL_DIR}/mysql -v -h mysql1 -u root -p workorder < ${SQL_DIR}/count-mysql1.sql > ${DATA_DIR}/mysql1.count
${MYSQL_DIR}/mysql -v -h mysql0 -u root -p workorder_p < ${SQL_DIR}/count-mysql0.sql > ${DATA_DIR}/mysql0.count


# START Webhelpdesk server
ssh workorder
su - tomcat -c "/opt/whdworkorder/bin/whd -u start"
