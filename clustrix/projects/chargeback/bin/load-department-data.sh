#! /bin/ksh

getent group > ../data/getent.out
mysql -h clustrix2 -u chargebackApp -pc@3n@gn@thusW -e "LOAD DATA LOCAL INFILE '../data/getent.out' IGNORE INTO TABLE department FIELDS TERMINATED BY ':';" chargeback

