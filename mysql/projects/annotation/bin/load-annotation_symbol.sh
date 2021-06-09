#!/bin/sh
DATA_DIR="../data"
DB_HOST="db-dev"
DB_NAME="annotation"
DB_USER="annotationAdmin"
DB_PASSWORD="annotationAdmin"

mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -e "LOAD DATA LOCAL INFILE '${DATA_DIR}/annotation_symbol.out' IGNORE INTO TABLE annotation_symbol FIELDS TERMINATED BY '\t' IGNORE 0 LINES (annotation_symbol,symbol);" ${DB_NAME}
