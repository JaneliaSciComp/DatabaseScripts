#!/bin/sh
cat ../data/accounting.out |sort -T /opt/tmp | uniq > ../data/compute_accounting.uniq
./qacct-transform.sh ../data/compute_accounting.uniq > ../data/compute_accounting.out
mysql -h clustrix2 -u chargebackApp -pc@3n@gn@thusW -e "truncate temp_data_load;" chargeback
mysql -h clustrix2 -u chargebackApp -pc@3n@gn@thusW -e "LOAD DATA LOCAL INFILE '../data/compute_accounting.out' IGNORE INTO TABLE temp_data_load FIELDS TERMINATED BY '\t' IGNORE 1 LINES;" chargeback
mysql -h clustrix2 -u chargebackApp -pc@3n@gn@thusW -e "insert into compute_accounting_fy15 select distinct * from temp_data_load where end_time > (select max(end_time) from compute_accounting_fy15)" chargeback
rm ../data/compute_accounting.uniq
rm ../data/compute_accounting.out
mysql -h clustrix2 -u chargebackApp -pc@3n@gn@thusW chargeback < ../sql/insert-monthly-compute-chargebacks.sql 
mysql -h clustrix2 -u chargebackApp -pc@3n@gn@thusW chargeback < ../sql/tax_code.sql
mysql -h clustrix2 -u chargebackApp -pc@3n@gn@thusW chargeback < ../sql/compute_usage.sql
