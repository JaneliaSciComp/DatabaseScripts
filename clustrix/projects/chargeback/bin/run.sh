#!/bin/sh

./load-department-data.sh

mv /opt/tmp/accounting ../data/accounting.out

./load-computing-data.sh
