#!/bin/bash

mkdir /opt/pgsql-data/chacrm
psql -U postgres -d postgres -f ../ddl/createDatabaseSchema.sql
