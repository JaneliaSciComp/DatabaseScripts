#!/bin/bash

rm -rf crs
mkdir crs
tar -xvf crs.tar -C crs
cp computing-services.out crs/out/reports/
cp scientific-computing.out crs/out/reports/

#unset BEGIN_TIME END_TIME REPORT_TYPE SHARED_RESOURCE EMAIL_ADDRESS
#
#while getopts "b:e:t:r:" opt; do
#  case $opt in
#    b ) BEGIN_TIME=$OPTARG ;;
#    e ) END_TIME=$OPTARG ;;
#    t ) REPORT_TYPE=$OPTARG ;;
#    r ) SHARED_RESOURCE=$OPTARG ;;
#    m ) EMAIL_ADDRESS=$OPTARG ;;
#   \? ) echo "invalid option"; return 1
#  esac
#done
#shift $(($OPTIND - 1))
#
#echo "script2.sh: BEGIN_TIME is $BEGIN_TIME"
#echo "script2.sh: END_TIME is $END_TIME"
#echo "script2.sh: REPORT_TYPE is $REPORT_TYPE"
#echo "script2.sh: SHARED_RESOURCE is $SHARED_RESOURCE"

#
#department reports for finance
#./crs.sh 20070401 20070430 "-b 20070401 -e 20070430 -t department_transaction"
#
#resource reports for Reed
#./crs.sh 20070401 20070430 "-b 20070401 -e 20070430 -t resource_transaction"
#
#resource reports for software engineering
#./crs.sh 20070401 20070430 "-b 20070401 -e 20070430 -t resource_transaction -r "Software Engineering \(hr\)""
#
#alternate email (default is dolafit@janelia.hhmi.org)
#./crs.sh 20070401 20070430 "-b 20070401 -e 20070430 -t resource_transaction -e dolafit@janelia.hhmi.org"
#crs/shl/run_reports.sh $1 $2 "$3"
crs/shl/run_reports.sh "$1"
