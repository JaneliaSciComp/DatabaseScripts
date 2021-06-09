#!/bin/bash
PGSQL_HOME=/opt/pgsql

$PGSQL_HOME/bin/pg_ctl restart -m immediate
