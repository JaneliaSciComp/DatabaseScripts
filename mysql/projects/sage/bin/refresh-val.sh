#!/bin/sh
HOST=val-db
DB=sage
USER=sageAdmin
PASSWORD=$1
PPASSWORD=l3g05

# data dump of metadata
echo "Creating data dump of metadata tables @ `date`"
mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi attenuator cv cv_relationship cv_term cv_term_relationship data_set data_set_family data_set_field data_set_field_value data_set_view detector event event_property experiment experiment_property experiment_relationship gene gene_synonym image image_property image_session laser line line_event line_event_property line_property namespace_sequence_number observation organism phase phase_property score score_statistic secondary_image session session_property session_relationship > meta.dmp
echo "Done"

# data dump of score_arrays
echo "Creating data dump score array table"

echo "..creating data dump box score array @ `date`"
mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 30" > box.dmp
echo "..done"

echo "..creating data dump aggression score array @ `date`"
mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 39" > aggression.dmp
echo "..done"

echo "..creating data dump trikinetics score array @ `date`"
mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 31" > trikinetics.dmp
echo "..done"

echo "..creating data dump gap score array @ `date`"
mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 38" > gap.dmp
echo "..done"

echo "..creating data dump bowl score array @ `date`"
mysqldump -u ${USER} -p${PPASSWORD} -h sage-db sage -t -c --triggers=false --compatible=ansi score_array -w "cv_id = 50" > bowl.dmp
echo "..done"
echo "Done"

#
# data dump of larval score arrays
# larval data is in a separate mysql shard and therefore it can not be combined with sage-db data due to primary identifiers.
# 

# truncate validation db
echo "Truncating tables in validation @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../ddl/refresh-truncate.sql
echo "Done"

# load validation db
echo "Loading tables in validation @ `date`"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < meta.dmp
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < box.dmp
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < aggression.dmp
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < trikinetics.dmp
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < gap.dmp
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < bowl.dmp
echo "Done"

# clean up data dump files
echo "Cleaning up data dump files"
rm meta.dmp box.dmp aggression.dmp trikinetics.dmp gap.dmp bowl.dmp
echo "Done"

# refresh mv's
echo "Refresh materialized view"
./refresh-box-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-aggression-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-gap-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-bowl-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-sterility-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-observation-mv.sh  ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-line-summary-picklists.sh ${HOST} ${DB} ${USER} ${PASSWORD}
./refresh-throughput-mv.sh ${HOST} ${DB} ${USER} ${PASSWORD}
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < ../views/grooming_score_vw.sql
echo "Done"

# compile functions
echo "Compile functions"
../functions/compile-all-functions.sh ${HOST} ${DB} ${USER} ${PASSWORD}
echo "Done"
