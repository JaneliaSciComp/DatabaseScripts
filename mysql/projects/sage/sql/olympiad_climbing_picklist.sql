/*
  This script updates data set field with picklist values
*/

-- insert into data_set_field_value with possible picklist values
call getDataSetFieldValue('olympiad','climbing','metadata','effector','olympiad_climbing_experiment_data_mv');
call getDataSetFieldValue('olympiad','climbing','metadata','protocol','olympiad_climbing_experiment_data_mv');
call getDataSetFieldValue('olympiad','climbing','metadata','gender','olympiad_climbing_experiment_data_mv');
