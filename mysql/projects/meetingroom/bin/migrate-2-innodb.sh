#! /bin/ksh

# create database on mysql1
/opt/mysql/bin/mysql -h mysql1 -u root -p < ../ddl/meetingroomDBBuild.sql
/opt/mysql/bin/mysql -h mysql1 -u root -p < ../ddl/user.sql
/opt/mysql/bin/mysql -h mysql1 -u root -p < ../ddl/user-privs.sql

/opt/mysql/bin/mysql -h mysql1 -u root -p < ../ddl/schema.sql

# Production mysql0 data dump
/opt/mysql/bin/mysqldump -h mysql0 -u root -p -t room_scheduler_p > ../data/mysql0-data.dmp

# InnoDB mysql1 data load
/opt/mysql/bin/mysql -h mysql1 -u root -p meetingroom < ../data/mysql0-data.dmp

# Compare counts
/opt/mysql/bin/mysql -v -h mysql1 -u root -p meetingroom < ../sql/count.sql > ../data/mysql1.count
/opt/mysql/bin/mysql -v -h mysql0 -u root -p room_scheduler_p < ../sql/count.sql > ../data/mysql0.count
