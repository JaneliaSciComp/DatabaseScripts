#!/bin/bash
#
# Postgresql vacuum script
#       
postgresql_username="postgres"

# Location of the psql binaries.
location_binaries="/usr/bin"
location_logfile="/the/location/of/the/log/file"
database="dbname"
PATH="$PATH:/bin:/usr/bin"
# Export the variables
export PATH
raw_tables="tablename1(index1,index2) tablename2(index1,index2)"

run_full() {
    
    echo ;
    echo "****************************************************************** " >> $location_logfile
    echo "Begining vacuum on $database today `date '+%d/%B/%Y'` " >> $location_logfile
    tables=$raw_tables
    arguments="--full --analyze --table"
    do_stuff
}

run_vacuum() {
    
    echo ;
    echo "****************************************************************** " >> $location_logfile
    echo "Begining vacuum on $database today `date '+%d/%B/%Y'` " >> $location_logfile
    tables=`echo $raw_tables | sed 's/([^)]*)//g'`
    arguments="--table"
    do_stuff
}

do_stuff() {
for i in $tables
	do
		start_time=`date '+%s'`
		timeinfo=`date '+%T %x'`
		echo "Begin Vacuum of $i at $timeinfo" >> $location_logfile
		$location_binaries/vacuumdb -U $postgresql_username $arguments $i $database >> $location_logfile 2>&1
		finish_time=`date '+%s'`
		duration=`expr $finish_time - $start_time`
		echo "End Vacuum on $i time `date '+%T %x'` , duration $duration seconds" >> $location_logfile
	done
}

case "$1" in
    # Run full_analyze
    full)
	run_full
	exit 1
	;;
# Run vacuum
    vacuum)
	run_vacuum
	exit 1
	;;
esac
