#! /bin/ksh
MYSQL_DIR="/opt/mysql/bin"
DATA_DIR="../data"
VIEWS_DIR="../views"
DB_HOST="mysql2"
DB_NAME="nighthawk"

# get rubin data
${MYSQL_DIR}/mysqldump -h ${DB_HOST} -u root -p rubin_nighthawk -t > ${DATA_DIR}/rubin-nighthawkBackup20080922.dmp
# get simpson namespace data
${MYSQL_DIR}/mysqldump -h ${DB_HOST} -u root -p -t simpson_nighthawk namespace_sequence_number > ${DATA_DIR}/simpson-nighthawkBackupNamespaceTable20080922.dmp

# load data into merged nighthawk db
mysql -h ${DB_HOST} -u root -p ${DB_NAME} < ${DATA_DIR}/rubin-nighthawkBackup20080922.dmp
mysql -h ${DB_HOST} -u root -p ${DB_NAME} < ${DATA_DIR}/simpson-nighthawkBackupNamespaceTable20080922.dmp

# compile views
${MYSQL_DIR}/mysql ${DB_HOST} -u root -p ${DB_NAME} < ${VIEWS_DIR}/source rubin-image_vw.sql
${MYSQL_DIR}/mysql ${DB_HOST} -u root -p ${DB_NAME} < ${VIEWS_DIR}/source simpson-image_vw.sql
${MYSQL_DIR}/mysql ${DB_HOST} -u root -p ${DB_NAME} < ${VIEWS_DIR}/source truman-image_vw.sql
