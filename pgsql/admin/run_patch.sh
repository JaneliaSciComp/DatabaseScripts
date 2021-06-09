#!/bin/bash

PGSQL_HOME=/opt/pgsql

$PGSQL_HOME/bin/pg_ctl -D /opt/pgsql-data/chacrm/ stop -m immediate
#$PGSQL_HOME/bin/pg_ctl -D /opt/pgsql-data/labtrack/ stop -m immediate

cd $PGSQL_HOME

patch -p0 -b -i gist_rtree.patch

ls -lrt ./src/backend/access/gist/gistproc*

sudo gmake
