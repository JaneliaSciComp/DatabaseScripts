#!/bin/bash

PGSQL_HOME=/opt/pgsql
DB=$1

echo `date`
# full analyze verbose
#$PGSQL_HOME/bin/vacuumdb -d $DB -f -z -v -e -p 5432

# analyze verbose
$PGSQL_HOME/bin/vacuumdb -d $DB -z -v -e -p 5432

echo `date`
