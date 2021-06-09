#!/bin/sh
HOST=$1
DB=$2
USER=$3
PASSWORD=$4

# depricated 
# mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < auditTrailObservation-trigger.sql
echo "compiling climbTree-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < climbTree-function.sql
echo "compiling climbTreeList-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < climbTreeList-function.sql
echo "compiling createCvId-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < createCvId-function.sql
echo "compiling createCvTermId-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < createCvTermId-function.sql
echo "compiling getAbbreviation-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getAbbreviation-function.sql
echo "compiling getCvId-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getCvId-function.sql
echo "compiling getCvTermDisplayName-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getCvTermDisplayName-function.sql
echo "compiling getCvTermId-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getCvTermId-function.sql
echo "compiling getCvTermName-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getCvTermName-function.sql
echo "compiling getDataSetFieldValue-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getDataSetFieldValue-function.sql
echo "compiling getExpressedRegionString-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getExpressedRegionString-function.sql
echo "compiling getGene-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getGene-function.sql
echo "compiling getGeneSynonym-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getGeneSynonym-function.sql
echo "compiling getGeneSynonymString-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getGeneSynonymString-function.sql
echo "compiling getLineSummaryString-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getLineSummaryString-function.sql
echo "compiling getPickListCSV-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getPickListCSV-function.sql
echo "compiling getPickListXML-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getPickListXML-function.sql
echo "compiling getPrimaryTerm-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getPrimaryTerm-function.sql
echo "compiling getScoreArrayResultSet-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getScoreArrayResultSet-function.sql
echo "compiling getSibling-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getSibling-function.sql
echo "compiling getSynonym-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getSynonym-function.sql
echo "compiling getTree-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getTree-function.sql
echo "compiling getTreeList-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < getTreeList-function.sql
echo "compiling mergeScoreArrayColumns-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < mergeScoreArrayColumns-function.sql
echo "compiling mergeScoreArrayFormat-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < mergeScoreArrayFormat-function.sql
echo "compiling mergeScoreArrayRows-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < mergeScoreArrayRows-function.sql
echo "compiling mergeScoreArrayValues-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < mergeScoreArrayValues-function.sql
echo "compiling mergeScoreArrays-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < mergeScoreArrays-function.sql
echo "compiling partitionScore-trigger.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < partitionScore-trigger.sql
echo "compiling partitionScoreArray-trigger.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < partitionScoreArray-trigger.sql
echo "compiling putLine-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < putLine-function.sql
echo "compiling putOlympiadLethality-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < putOlympiadLethality-function.sql
echo "compiling synonymsGene-trigger.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < synonymsGene-trigger.sql
echo "compiling xtab-function.sql"
mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DB} < xtab-function.sql
