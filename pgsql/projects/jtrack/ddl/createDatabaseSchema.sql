-- **********
-- Labtrack 
-- **********
create role joe login encrypted password 'joe';
create role jtrack nologin;
-- mkdir -m 700 /opt/pgsql-data/jtrack/data
create tablespace jtrackdata owner joe location '/opt/pgsql-data/jtrack/data';
create database jtrack owner joe tablespace jtrackdata;
create role svirskasr login encrypted password 'svirskasr';
create role dolafit login encrypted password 'x' superuser;

