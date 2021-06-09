#! /bin/ksh

mysqldump -h workorderdb-p -P 3306 -u joomla_ro -p joomla_p jan_map jan_map_info > ../data/joomla_p_jan_map.dmp
