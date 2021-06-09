MYSQL_HOME=/opt/mysql
PATH=$MYSQL_HOME/bin:$PATH
export PATH

mysqlmanager --defaults-file=/etc/my_manager.cnf &
