#! /bin/ksh

# extract data for cognos
mysql -h mysql1 -u workorderApp -pworkorderApp workorder < ../sql/extract-workorder.sql
mysql -h mysql1 -u chargebackApp -pchargebackApp chargeback < ../sql/extract-compute-farm.sql
mysql -h mysql1 -u chargebackApp -pchargebackApp chargeback < ../sql/extract-scientific-computing.sql
mysql -h mysql1 -u chargebackApp -pchargebackApp chargeback < ../sql/extract-storage.sql

scp mysql1:/tmp/*.csv ../data/
