/*
  This script updates data set field with picklist values
*/

-- update value column of data_set_field with comma separated string of possible picklist values 
call getPickListCSV(@values,'box','olympiad_box_experiment_data_mv');
update data_set_field set value = @values  where name = 'box_name' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info','environmental'));
update data_set_field set value = @values  where name = 'box' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info','environmental'));
call getPickListCSV(@values,'apparatus_id','olympiad_box_experiment_data_mv');
update data_set_field set value = @values  where name = 'top_plate_id' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info','environmental'));
update data_set_field set value = @values  where name = 'apparatus_id' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info','environmental'));
call getPickListCSV(@values,'experiment_protocol','olympiad_box_experiment_data_mv');
update data_set_field set value = @values  where name = 'experiment_protocol' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info','environmental'));
call getPickListCSV(@values,'tube','olympiad_box_experiment_data_mv');
update data_set_field set value = @values  where name = 'tube' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info'));
call getPickListCSV(@values,'sequence','olympiad_box_experiment_data_mv');
update data_set_field set value = @values  where name = 'sequence' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info'));
call getPickListCSV(@values,'temperature_setpoint','olympiad_box_experiment_data_mv');
update data_set_field set value = @values  where name = 'temperature' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info'));
update data_set_field set value = @values  where name = 'temperature_setpoint' and data_set_id IN (select id from data_set where name in( 'analysis_results','analysis_info'));

-- insert into data_set_field_value with possible picklist values for analysis_results
call getDataSetFieldValue('olympiad','box','analysis_results','box','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_results','apparatus_id','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_results','experiment_protocol','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_results','tube','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_results','sequence','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_results','temperature_setpoint','olympiad_box_experiment_data_mv');

-- insert into data_set_field_value with possible picklist values for analysis_info
call getDataSetFieldValue('olympiad','box','analysis_info','box','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_info','apparatus_id','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_info','experiment_protocol','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_info','tube','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_info','sequence','olympiad_box_experiment_data_mv');
call getDataSetFieldValue('olympiad','box','analysis_info','temperature_setpoint','olympiad_box_experiment_data_mv');

-- insert into data_set_field_value with possible picklist values for environmental
call getDataSetFieldValue('olympiad','box','environmental','box','olympiad_box_environmental_mv');
call getDataSetFieldValue('olympiad','box','environmental','apparatus_id','olympiad_box_environmental_mv');
call getDataSetFieldValue('olympiad','box','environmental','experiment_protocol','olympiad_box_environmental_mv');

-- insert into data_set_field_value with possible values for data_type for analysis_results
-- SET @data_set_field_id = (SELECT dsf.id
--                            FROM data_set_field dsf
--                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'analysis_results')
--                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'box')
--                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
--                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
--                            WHERE dsf.name = 'data_type'
--                          );
-- DELETE FROM data_set_field_value 
-- WHERE data_set_field_id = @data_set_field_id;
-- 
-- INSERT INTO data_set_field_value (data_set_field_id,value)
-- SELECT @data_set_field_id,
--        data_type 
-- FROM olympiad_box_analysis_results_vw
-- GROUP BY 1,2
-- ORDER BY 1,2;
-- 
-- -- insert into data_set_field_value with possible values for data_type for analysis_info
-- SET @data_set_field_id =  (SELECT dsf.id
--                            FROM data_set_field dsf
--                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'analysis_info')
--                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'box')
--                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
--                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
--                            WHERE dsf.name = 'data_type'
--                           );
-- 
-- DELETE FROM data_set_field_value 
-- WHERE data_set_field_id = @data_set_field_id;
-- 
-- INSERT INTO data_set_field_value (data_set_field_id,value)
-- SELECT @data_set_field_id,
--        data_type
-- FROM olympiad_box_analysis_info_vw
-- GROUP BY 1,2
-- ORDER BY 1,2;
-- 
-- -- insert into data_set_field_value with possible values for data_type for environmental flattened view
-- SET @data_set_field_id = (SELECT dsf.id
--                            FROM data_set_field dsf
--                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'environmental')
--                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'box')
--                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
--                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
--                            WHERE dsf.name = 'data_type'
--                           );
-- 
-- DELETE FROM data_set_field_value
-- WHERE data_set_field_id = @data_set_field_id;
-- 
-- INSERT INTO data_set_field_value (data_set_field_id,value)
-- SELECT @data_set_field_id,
--        data_type
-- FROM olympiad_box_environmental_vw
-- GROUP BY 1,2
-- ORDER BY 1,2;
