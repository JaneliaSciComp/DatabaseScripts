#!/bin/sh
wc -l ../data/leginon-storage.out
echo  ...
mysql -h leginon -u root -p1mDBguru -e "TRUNCATE TABLE leginon_storage;" projectdata
mysql -h leginon -u root -p1mDBguru -e "LOAD DATA LOCAL INFILE '../data/leginon-storage.out' IGNORE INTO TABLE leginon_storage FIELDS TERMINATED BY ',' IGNORE 0 LINES;" projectdata
mysql -h leginon -u root -p1mDBguru -e "SELECT count(1) FROM leginon_storage;" projectdata
