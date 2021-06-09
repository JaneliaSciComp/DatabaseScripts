#!/bin/bash

BACKUPDIR=/opt/mysql-dump

cd $BACKUPDIR

files=`find . -type f -mtime +30 -exec ls {} + | grep -v '[A-Z][a-z][a-z]  1'`

for file in $files; do
      out=`echo $file | egrep "data|schema"`
      status=$?
      if [ $status -eq 0 ] 
      then    
         day=`echo $file | awk -F '-' '{print $3}' | awk '{ print substr( $0, 7, 2 ) }'` 
      else    
         day=`echo $file | awk -F '-' '{print $2}' | awk '{ print substr( $0, 7, 2 ) }'` 
      fi      
      if [[ $day = 01 ]] 
      then    
         echo "First file of the month " $file 
      else    
         echo "Not the first file of the month " $file 
         `rm $file`
      fi      
done  
