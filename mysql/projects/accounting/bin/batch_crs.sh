#!/bin/bash

rm -rf crs
mkdir crs
tar -xvf crs.tar -C crs
cp storage.out crs/out/reports/
cp se.out crs/out/reports/

# YYYYMMDD YYYYMMDD
#crs/shl/run_reports.sh 20060901 20060930 Yes
#crs/shl/run_reports.sh 20061001 20061031 Yes
#crs/shl/run_reports.sh 20061101 20061130 Yes
#crs/shl/run_reports.sh 20061201 20061231 Yes
crs/shl/run_reports.sh 20070101 20070131 Yes
crs/shl/run_reports.sh 20070201 20070228 Yes
