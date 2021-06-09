#!/bin/sh
dos2unix ../data/computing-services.out
wc -l ../data/computing-services.out 
echo ...
./computing-services-transform.sh ../data/computing-services.out > ../data/computing-services-parsed.out
mysql -h mysql1 -u chargebackApp -pchargebackApp -e "LOAD DATA LOCAL INFILE '../data/computing-services-parsed.out' IGNORE INTO TABLE computing_services_chargeback FIELDS TERMINATED BY ',' IGNORE 1 LINES (@close_date,department_code,service,unit,rate,project_code) SET close_date = str_to_date(@close_date, '%m/%d/%Y');" chargeback
rm ../data/computing-services-parsed.out
mysql -h mysql1 -u chargebackApp -pchargebackApp -e "SELECT count(1) FROM computing_services_chargeback" chargeback
