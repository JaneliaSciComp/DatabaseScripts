#!/bin/sh

./load-department-data.sh

mv ~/accounting ../data/accounting.out

./load-computing-data.sh

#./load-scientific-computing.sh
#
#./load-computing-services.sh
