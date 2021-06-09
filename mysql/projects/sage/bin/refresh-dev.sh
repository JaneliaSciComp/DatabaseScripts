#!/bin/sh
HOST=dev-db
DB=sage
USER=sageAdmin
PASSWORD=$1
PPASSWORD=l3g05

# data dump of sage data except score array
echo "Creating data dump file of prod SAGE"
mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi attenuator cv cv_relationship cv_term cv_term_relationship data_set data_set_family data_set_field data_set_field_value detector event event_property experiment experiment_property experiment_relationship gene gene_synonym image image_property image_session laser line line_event line_event_property line_property namespace_sequence_number observation organism phase phase_property score score_statistic secondary_image session session_property session_relationship > d1.dmp
echo ".done"

# data dump of box score arrays
#mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 30 limit 10000" > d2.dmp
# data dump of aggression score arrays
#mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 39 limit 10000" > d3.dmp
# data dump of trikinetics score arrays
#mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 31" > d4.dmp
# data dump of gap score arrays
#mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 38" > d5.dmp
# data dump of bowl score arrays
#mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 50" > d6.dmp
# data dump of larval score arrays
#mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 60" > d7.dmp

# truncate development db
echo "Truncating dev SAGE"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../ddl/refresh-truncate.sql
echo ".done"

# load development db
echo "Loading dev SAGE"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} -f < d1.dmp
#mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < d2.dmp
#mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < d3.dmp
#mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < d4.dmp
#mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < d5.dmp
#mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < d6.dmp
#mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < d7.dmp
echo ".done"

# clean up data dump files
echo "Cleaning up data dump files"
rm d*.dmp
echo ".done"

# refresh mv's
echo "Refresh mv's"
./refresh-box-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-aggression-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-gap-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-bowl-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-line-summary-picklists.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-throughput-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/grooming_score_vw.sql
echo ".done"

# test data
echo "Load test data"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../sql/sageapi_test_data.sql
echo ".done"
