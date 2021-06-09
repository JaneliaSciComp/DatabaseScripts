#!/bin/sh
dos2unix ../data/scientific-computing.out
wc -l ../data/scientific-computing.out
echo ...
./scientific-computing-transform.sh ../data/scientific-computing.out > ../data/scientific-computing-parsed.out
mysql -h mysql1 -u chargebackApp -pchargebackApp -e "LOAD DATA LOCAL INFILE '../data/scientific-computing-parsed.out' IGNORE INTO TABLE scientific_computing_chargeback FIELDS TERMINATED BY ',' IGNORE 1 LINES (@close_date,department_code,project,fte,rate,project_code) SET close_date = str_to_date(@close_date, '%m/%d/%Y');" chargeback
rm ../data/scientific-computing-parsed.out
mysql -h mysql1 -u chargebackApp -pchargebackApp -e "SELECT count(1) FROM scientific_computing_chargeback;" chargeback
