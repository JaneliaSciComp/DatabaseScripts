#!/bin/bash

PGSQL_HOME=/opt/pgsql

$PGSQL_HOME/bin/psql -d postgres -p 5433 -c "drop database labtrack"
$PGSQL_HOME/bin/psql -d postgres -p 5433 -c "create database labtrack owner joe tablespace labtrackdata"
$PGSQL_HOME/bin/psql -d labtrack -U joe -p 5433 < /home/svirskasr/LBNL/labtrack_v8.dmp.gz
