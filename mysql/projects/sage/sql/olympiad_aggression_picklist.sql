/*
  This script updates data set field with picklist values
*/

-- update value column of data_set_field with comma separated string of possible picklist values 
call getPickListCSV(@values,'arena','olympiad_aggression_experiment_data_mv');
update data_set_field set value = @values  where name = 'arena' and data_set_id IN (select id from data_set where name in ('tracking','features','chamber_tracking'));
call getPickListCSV(@values,'camera','olympiad_aggression_experiment_data_mv');
update data_set_field set value = @values  where name = 'camera' and data_set_id IN (select id from data_set where name in ('tracking','features','chamber_tracking'));
call getPickListCSV(@values,'protocol','olympiad_aggression_experiment_data_mv');
update data_set_field set value = @values  where name = 'protocol' and data_set_id IN (select id from data_set where name in ('tracking','features','chamber_tracking'));
call getPickListCSV(@values,'behavior','olympiad_aggression_experiment_data_mv');
update data_set_field set value = @values  where name = 'behavior' and data_set_id IN (select id from data_set where name in ('tracking','features','chamber_tracking'));
call getPickListCSV(@values,'effector','olympiad_aggression_experiment_data_mv');
update data_set_field set value = @values  where name = 'effector' and data_set_id IN (select id from data_set where name in ('tracking','features','chamber_tracking'));
call getPickListCSV(@values,'chamber','olympiad_aggression_experiment_data_mv');
update data_set_field set value = @values  where name = 'chamber' and data_set_id IN (select id from data_set where name in ('tracking','features','chamber_tracking'));

-- insert into data_set_field_value with possible picklist values for features
call getDataSetFieldValue('olympiad','aggression','features','arena','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','features','camera','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','features','protocol','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','features','behavior','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','features','effector','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','features','chamber','olympiad_aggression_experiment_data_mv');

-- insert into data_set_field_value with possible picklist values for tracking
call getDataSetFieldValue('olympiad','aggression','tracking','arena','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','tracking','camera','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','tracking','protocol','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','tracking','behavior','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','tracking','effector','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','tracking','chamber','olympiad_aggression_experiment_data_mv');

-- insert into data_set_field_value with possible picklist values for chamber_tracking
call getDataSetFieldValue('olympiad','aggression','chamber_tracking','arena','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','chamber_tracking','camera','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','chamber_tracking','protocol','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','chamber_tracking','behavior','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','chamber_tracking','effector','olympiad_aggression_experiment_data_mv');
call getDataSetFieldValue('olympiad','aggression','chamber_tracking','chamber','olympiad_aggression_experiment_data_mv');

-- insert into data_set_field_value with possible values for data_type for features
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'features')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'data_type'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'features')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'data_type'
        ),
        getcvtermname(subject_id)
FROM cv_term_relationship rel
JOIN cv_term term ON (term.id = subject_id)
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_aggression','fly_olympiad'))
WHERE rel.type_id IN (SELECT cv_term.id
                      FROM cv_term
                      JOIN cv ON (cv_term.cv_id = cv.id AND cv.name = 'schema')
                      WHERE cv_term.name='is_a'
                     )
  AND getcvtermname(object_id) = 'score_array';

-- insert into data_set_field_value with possible values for data_type for tracking
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'tracking')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'data_type'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'tracking')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'data_type'
        ),
        getcvtermname(subject_id)
FROM cv_term_relationship rel
JOIN cv_term term ON (term.id = subject_id)
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_aggression','fly_olympiad'))
WHERE rel.type_id IN (SELECT cv_term.id
                      FROM cv_term
                      JOIN cv ON (cv_term.cv_id = cv.id AND cv.name = 'schema')
                      WHERE cv_term.name='is_a'
                     )
  AND getcvtermname(object_id) = 'score_array';

-- insert into data_set_field_value with possible values for data_type for chamber tracking
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'chamber_tracking')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'data_type'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'chamber_tracking')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'data_type'
        ),
        getcvtermname(subject_id)
FROM cv_term_relationship rel
JOIN cv_term term ON (term.id = subject_id)
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_aggression','fly_olympiad'))
WHERE rel.type_id IN (SELECT cv_term.id
                      FROM cv_term
                      JOIN cv ON (cv_term.cv_id = cv.id AND cv.name = 'schema')
                      WHERE cv_term.name='is_a'
                     )
  AND getcvtermname(object_id) = 'score_array';

-- insert into data_set_field_value with possible values for fly for features
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'features')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'fly'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'features')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'fly'
        ),
        term.name
FROM cv_term term
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_aggression','fly_olympiad'))
WHERE term.name in ('fly1','fly2','fly1_fly2');


-- insert into data_set_field_value with possible values for fly for tracking
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'tracking')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'fly'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'tracking')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'fly'
        ),
        term.name
FROM cv_term term 
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_aggression','fly_olympiad'))
WHERE term.name in ('fly1','fly2','fly1_fly2');

-- insert into data_set_field_value with possible values for fly for chamber tracking
DELETE FROM data_set_field_value
WHERE data_set_field_id = (SELECT dsf.id
                           FROM data_set_field dsf
                           JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'chamber_tracking')
                           JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
                           JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                           JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           WHERE dsf.name = 'fly'
                          );
INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'chamber_tracking')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'aggression')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'fly'
        ),
        term.name
FROM cv_term term
JOIN cv ON (cv.id = term.cv_id AND cv.name IN ('fly_olympiad_aggression','fly_olympiad'))
WHERE term.name in ('fly1','fly2','fly1_fly2');
