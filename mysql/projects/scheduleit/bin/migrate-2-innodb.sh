#! /bin/ksh
MYSQL_DIR="/opt/mysql/bin"
DDL_DIR="../ddl"
DATA_DIR="../data"
SQL_DIR="../sql"

# create database on mysql1
${MYSQL_DIR}/mysql -h mysql1 -u root -p < ${DDL_DIR}/scheduleitDBBuild.sql
${MYSQL_DIR}/mysql -h mysql1 -u root -p < ${DDL_DIR}/user.sql
${MYSQL_DIR}/mysql -h mysql1 -u root -p < ${DDL_DIR}/user-privs.sql

${MYSQL_DIR}/mysql -h mysql1 -u root -p scheduleit < ${DDL_DIR}/schema.sql

# Production mysql0 data dump
${MYSQL_DIR}/mysqldump -h mysql0 -u root -p -t resource_scheduler_p > ${DATA_DIR}/mysql0-data.dmp

# InnoDB mysql1 data load
${MYSQL_DIR}/mysql -h mysql1 -u root -p scheduleit < ${DATA_DIR}/mysql0-data.dmp

# Compare counts
${MYSQL_DIR}/mysql -v -h mysql1 -u root -p scheduleit < ${SQL_DIR}/count.sql > ${DATA_DIR}/mysql1.count
${MYSQL_DIR}/mysql -v -h mysql0 -u root -p resource_scheduler_p < ${SQL_DIR}/count.sql > ${DATA_DIR}/mysql0.count
