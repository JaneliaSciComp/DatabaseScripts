#!/bin/ksh

SERVER=prd-db
OUT=/tmp/diskspaceusage.txt
set -A ArchiveDirectories /opt/mysql-dump
set -A DataDirectories /opt/mysql-data


for dir in "${ArchiveDirectories[@]}"
do
  echo "" > $OUT
  echo "** $dir Disk Space Usage **" >> $OUT
  echo "" >> $OUT

  DiskTotalPercentage=`df -h $dir |grep -v "^Filesystem"|grep -v "^jdr"|awk '{print $1}'`
  DiskfreeSize=`df -h $dir |grep -v "^Filesystem"|awk '{print $3}'`
  DiskUsagePercentage=`df -h $dir |grep -v "^Filesystem"|grep -v "^jdr"|awk '{print $4}'`
  DiskUsageInteger="${DiskUsagePercentage%?}"

  echo "Total Size : " $DiskTotalPercentage >> $OUT
  echo " Free Size : " $DiskfreeSize >> $OUT
  echo "     Usage : " $DiskUsagePercentage >> $OUT
  echo "" >> $OUT
  
  if [[ $DiskUsageInteger > 89 ]]
  then
     echo "$SERVER free disk space $dir is LOW." >> $OUT  
     cat $OUT | mailx -s "$SERVER DISK SPACE $dir ** WARNING **" dolafit@janelia.hhmi.org
  fi

done


for dir in "${DataDirectories[@]}"
do
  echo "" > $OUT
  echo "** $dir Disk Space Usage **" >> $OUT
  echo "" >> $OUT

  DiskTotalPercentage=`df -h $dir |grep -v "^Filesystem"|grep -v "^jdr"|awk '{print $2}'`
  DiskfreeSize=`df -h $dir |grep -v "^Filesystem"|awk '{print $4}'`
  DiskUsagePercentage=`df -h $dir |grep -v "^Filesystem"|grep -v "^jdr"|awk '{print $5}'`
  DiskUsageInteger="${DiskUsagePercentage%?}"

  echo "Total Size : " $DiskTotalPercentage >> $OUT
  echo " Free Size : " $DiskfreeSize >> $OUT
  echo "     Usage : " $DiskUsagePercentage >> $OUT
  echo "" >> $OUT
  
 ( for res1 in `du -b /opt/mysql-data --max=1 | head -n -1| grep -v lost | grep -v performance | awk '{print $1 ":" $2}'`;do
         size=`echo $res1|cut -d: -f1`
         db1=`echo $res1|cut -d: -f2`
 
         db=`echo $db1|awk -F/ '{print $4}'`
         res=$(echo "$size/1024/1024/1024"|bc -l)
         printf "%s : %.3fG\n" $db $res
   done ) >>$OUT

  if [[ $DiskUsageInteger > 89 ]]
  then
     echo "" >> $OUT 
     echo "$SERVER free disk space $dir is LOW." >> $OUT  
     cat $OUT | mailx -s "$SERVER DISK SPACE $dir ** WARNING **" dolafit@janelia.hhmi.org
  fi
   
done
