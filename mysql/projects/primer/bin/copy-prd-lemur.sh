#! /bin/ksh

/opt/mysql/bin/mysqldump -u root -p -n -t --order-by-primary lemurdb > ../data/copy-prd-lemur-20080212.sql
