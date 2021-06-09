#!/bin/sh
cat ../data/accounting.out |sort -T /opt/tmp | uniq > ../data/compute_accounting.uniq
./qacct-transform.sh ../data/compute_accounting.uniq > ../data/compute_accounting.out
mysql -h mysql1 -u chargebackApp -pchargebackApp -e "LOAD DATA LOCAL INFILE '../data/compute_accounting.out' IGNORE INTO TABLE compute_accounting FIELDS TERMINATED BY '\t' IGNORE 1 LINES;" chargeback
rm ../data/compute_accounting.uniq
rm ../data/compute_accounting.out
