#! /bin/ksh

# inputs
DB=$1
PROJECT_NAME=$2

# variables
DB_DIR="../${DB}"
PROJECT_DIR="${DB_DIR}/projects/${PROJECT_NAME}"
PROJECT_SUBDIRS="bin data ddl doc functions sql views"

if [ -d ${DB_DIR} ]; then
    if [ -d ${PROJECT_DIR} ]; then
        echo "Project directory ${PROJECT_DIR} already exists... exiting script!"
        exit;
    else
       # Create project directory
       mkdir ${PROJECT_DIR}

       # Create project sub-directories
       for i in ${PROJECT_SUBDIRS} ; do
           mkdir ${PROJECT_DIR}/$i
       done
    fi
else
    echo "Database directory ${DB_DIR} does not exist... exiting script!"
    exit;
fi
