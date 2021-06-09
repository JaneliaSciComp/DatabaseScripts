#! /bin/ksh

getent group > ../data/getent.out
mysql -h mysql1 -u chargebackApp -pchargebackApp -e "LOAD DATA LOCAL INFILE '../data/getent.out' IGNORE INTO TABLE department FIELDS TERMINATED BY ':';" chargeback

#mysql -h mysql1 -u chargebackApp -pchargebackApp -e "update chargeback.department set department.name = 'harris' where department.code='93298'" chargeback
