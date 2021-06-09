/*
  This script updates data set field with picklist values
*/

-- update value column of data_set_field with comma separated string of possible picklist values 
call getPickListCSV(@values,'effector','olympiad_gap_experiment_data_mv');
update data_set_field set value = @values  where name = 'effector' and data_set_id IN (select id from data_set where name in('counts','totals'));
call getPickListCSV(@values,'protocol','olympiad_gap_experiment_data_mv');
update data_set_field set value = @values  where name = 'protocol' and data_set_id IN (select id from data_set where name in('counts','totals'));
call getPickListCSV(@values,'gender','olympiad_gap_experiment_data_mv');
update data_set_field set value = @values  where name = 'gender' and data_set_id IN (select id from data_set where name in('counts','totals'));
call getPickListCSV(@values,'rig','olympiad_gap_experiment_data_mv');
update data_set_field set value = @values  where name = 'rig' and data_set_id IN (select id from data_set where name in('counts','totals'));

-- insert into data_set_field_value with possible picklist values for counts
call getDataSetFieldValue('olympiad','gap','counts','effector','olympiad_gap_experiment_data_mv');
call getDataSetFieldValue('olympiad','gap','counts','protocol','olympiad_gap_experiment_data_mv');
call getDataSetFieldValue('olympiad','gap','counts','gender','olympiad_gap_experiment_data_mv');
call getDataSetFieldValue('olympiad','gap','counts','rig','olympiad_gap_experiment_data_mv');

-- insert into data_set_field_value with possible values for data_type for counts
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'counts')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'gap')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'data_type'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'counts')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'gap')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'data_type'
        ),
        getcvtermname(subject_id)
FROM cv_term_relationship rel
JOIN cv_term term ON (term.id = subject_id)
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_gap','fly_olympiad'))
WHERE rel.type_id IN (SELECT cv_term.id
                      FROM cv_term
                      JOIN cv ON (cv_term.cv_id = cv.id AND cv.name = 'schema')
                      WHERE cv_term.name='is_a'
                     )
  AND getcvtermname(object_id) = 'score_array';


-- insert into data_set_field_value with possible picklist values for gap totals
call getDataSetFieldValue('olympiad','gap','totals','effector','olympiad_gap_experiment_data_mv');
call getDataSetFieldValue('olympiad','gap','totals','protocol','olympiad_gap_experiment_data_mv');
call getDataSetFieldValue('olympiad','gap','totals','gender','olympiad_gap_experiment_data_mv');
call getDataSetFieldValue('olympiad','gap','totals','rig','olympiad_gap_experiment_data_mv');
