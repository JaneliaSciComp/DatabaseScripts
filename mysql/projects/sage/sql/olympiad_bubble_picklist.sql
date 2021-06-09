/*
  This script updates data set field with picklist values
*/

-- insert into data_set_field_value with possible picklist values
call getDataSetFieldValue('olympiad','bubble','data','effector','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','data','protocol','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','data','gender','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','data','bubble','olympiad_bubble_experiment_data_mv');

-- insert into data_set_field_value with possible values for data_type for counts
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'data')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'bubble')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'data_type'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'data')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'bubble')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'data_type'
        ),
        getcvtermname(subject_id)
FROM cv_term_relationship rel
JOIN cv_term term ON (term.id = subject_id)
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_fly_bubble','fly_olympiad'))
WHERE rel.type_id IN (SELECT cv_term.id
                      FROM cv_term
                      JOIN cv ON (cv_term.cv_id = cv.id AND cv.name = 'schema')
                      WHERE cv_term.name='is_a'
                     )
  AND getcvtermname(object_id) = 'score_array'
  AND getcvtermname(subject_id) not like 'hist%';

-- insert into data_set_field_value with possible values for data_type for counts
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'histogram')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'bubble')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'data_type'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'histogram')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'bubble')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'data_type'
        ),
        getcvtermname(subject_id)
FROM cv_term_relationship rel
JOIN cv_term term ON (term.id = subject_id)
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_fly_bubble','fly_olympiad'))
WHERE rel.type_id IN (SELECT cv_term.id
                      FROM cv_term
                      JOIN cv ON (cv_term.cv_id = cv.id AND cv.name = 'schema')
                      WHERE cv_term.name='is_a'
                     )
  AND getcvtermname(object_id) = 'score_array'
  AND getcvtermname(subject_id) like 'hist%';

-- insert into data_set_field_value with possible picklist values
call getDataSetFieldValue('olympiad','bubble','score','effector','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','score','protocol','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','score','gender','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','score','bubble','olympiad_bubble_experiment_data_mv');
-- insert into data_set_field_value with possible picklist values
call getDataSetFieldValue('olympiad','bubble','histogram','effector','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','histogram','protocol','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','histogram','gender','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','histogram','bubble','olympiad_bubble_experiment_data_mv');
-- insert into data_set_field_value with possible picklist values
call getDataSetFieldValue('olympiad','bubble','metadata','effector','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','metadata','protocol','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','metadata','gender','olympiad_bubble_experiment_data_mv');
call getDataSetFieldValue('olympiad','bubble','metadata','bubble','olympiad_bubble_experiment_data_mv');
