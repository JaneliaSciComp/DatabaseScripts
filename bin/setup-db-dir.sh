#! /bin/ksh

# inputs
DB=$1

# variables
DB_DIR="../${DB}"
DB_SUBDIRS="admin backup conf perf projects bin"

if [ -d ${DB_DIR} ]; then
    echo " directory ${DB_DIR} already exists..."
    # Create db sub-directories
    for i in ${DB_SUBDIRS} ; do
        if [ -d ${DB_DIR}/$i ]; then
            echo " directory ${DB_DIR}/$i already exists..."
        else
            mkdir ${DB_DIR}/$i
        fi
    done
else
    # Create db directory
    mkdir ${DB_DIR} 
    # Create db sub-directories
    for i in ${DB_SUBDIRS} ; do
        mkdir ${DB_DIR}/$i
    done
fi
