#!/bin/bash

DB_NAME=$1
DB_PORT=$2
PGSQL_HOME=/opt/pgsql

$PGSQL_HOME/bin/createlang -d $DB_NAME -p $DB_PORT -e -U postgres -W plpgsql
