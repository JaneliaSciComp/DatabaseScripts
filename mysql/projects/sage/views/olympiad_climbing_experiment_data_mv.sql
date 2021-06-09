/* 
    name: 

    mv:   olympiad_climbing_experiment_data_mv

    app:  SAGE REST API
    
    note: This script performs the following queries to flatten Bowl Assay data.
          1.  Create a temp table containing experiment properties
          2.  Create a temp table containing session properties and scores.
          3.  Create a temp table combining experiment and session properties plus scores. 
          4.  Create materialized view of combined temp table.
          5.  Create view on materialized view for use by SAGE REST API
*/

-- =================================================== 
-- create temp table containing experiment properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_climbing_experiment_data_mv;
CREATE TABLE tmp_olympiad_climbing_experiment_data_mv
SELECT e.id AS experiment_id, cast(e.name as char(250)) AS experiment_name, 
       cast(archived.value as char(50)) AS archived, cast(automated_pf.value as char(50)) AS automated_pf, cast(computer.value as char(50)) AS computer, 
       dayofweek(cast(exp_datetime.value as datetime)) AS day_of_week, cast(e.experimenter as char(50)) AS experimenter, cast(exp_datetime.value as char(255)) AS exp_datetime, 
       cast(file_system_path.value as char(255)) AS file_system_path, cast(left(flag_aborted.value,1) as unsigned integer) AS flag_aborted, cast(flag_legacy.value as char(1)) AS flag_legacy, 
       cast(flag_redo.value as char(1)) AS flag_redo, cast(flag_review.value as char(1)) AS flag_review, cast(humidity.value as decimal(10,4)) AS humidity, 
       cast(manual_pf.value as char(50)) AS manual_pf, cast(metadata_version.value as char(50)) AS metadata_version, cast(notes_behavioral.value as char(500)) AS notes_behavioral, 
       cast(notes_keyword.value as char(255)) AS notes_keyword, cast(notes_technical.value  as char(500)) AS notes_technical, cast(left(num_tubes.value,10) as unsigned integer) num_tubes, 
       cast(protocol.value as char(50)) AS protocol, cast(screen_reason.value as char(50)) AS screen_reason, cast(screen_type.value as char(50)) AS screen_type, 
       cast(temperature.value as decimal(10,4)) AS temperature 
FROM experiment e LEFT JOIN experiment_property archived             ON (archived.experiment_id = e.id             AND archived.type_id             = getCvTermId('fly_olympiad_climbing', 'archived', NULL))
                  LEFT JOIN experiment_property automated_pf         ON (automated_pf.experiment_id = e.id         AND automated_pf.type_id         = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))
                  LEFT JOIN experiment_property computer             ON (computer.experiment_id = e.id             AND computer.type_id             = getCvTermId('fly_olympiad_apparatus', 'computer', NULL))
                  LEFT JOIN experiment_property experimenter         ON (experimenter.experiment_id = e.id         AND experimenter.type_id         = getCvTermId('fly_olympiad_climbing', 'experimenter', NULL))
                  LEFT JOIN experiment_property exp_datetime         ON (exp_datetime.experiment_id = e.id         AND exp_datetime.type_id         = getCvTermId('fly_olympiad_climbing', 'exp_datetime', NULL))
                  LEFT JOIN experiment_property file_system_path     ON (file_system_path.experiment_id =e.id      AND file_system_path.type_id     = getCvTermId('fly_olympiad_climbing', 'file_system_path', NULL))
                  LEFT JOIN experiment_property flag_aborted         ON (flag_aborted.experiment_id = e.id         AND flag_aborted.type_id         = getCvTermId('fly_olympiad_climbing', 'flag_aborted', NULL))
                  LEFT JOIN experiment_property flag_legacy          ON (flag_legacy.experiment_id = e.id          AND flag_legacy.type_id          = getCvTermId('fly_olympiad_climbing', 'flag_legacy', NULL))
                  LEFT JOIN experiment_property flag_redo            ON (flag_redo.experiment_id = e.id            AND flag_redo.type_id            = getCvTermId('fly_olympiad_climbing', 'flag_redo', NULL))
                  LEFT JOIN experiment_property flag_review          ON (flag_review.experiment_id = e.id          AND flag_review.type_id          = getCvTermId('fly_olympiad_climbing', 'flag_review', NULL))
                  LEFT JOIN experiment_property humidity             ON (humidity.experiment_id = e.id             AND humidity.type_id             = getCvTermId('fly_olympiad_climbing', 'humidity', NULL))
                  LEFT JOIN experiment_property manual_pf            ON (manual_pf.experiment_id = e.id            AND manual_pf.type_id            = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                  LEFT JOIN experiment_property metadata_version     ON (metadata_version.experiment_id = e.id     AND metadata_version.type_id     = getCvTermId('fly_olympiad_climbing', 'metadata_version', NULL))
                  LEFT JOIN experiment_property notes_behavioral     ON (notes_behavioral.experiment_id = e.id     AND notes_behavioral.type_id     = getCvTermId('fly_olympiad_climbing', 'notes_behavioral', NULL))
                  LEFT JOIN experiment_property notes_keyword        ON (notes_keyword.experiment_id = e.id        AND notes_keyword.type_id        = getCvTermId('fly_olympiad_climbing', 'notes_keyword', NULL))
                  LEFT JOIN experiment_property notes_technical      ON (notes_technical.experiment_id = e.id      AND notes_technical.type_id      = getCvTermId('fly_olympiad_climbing', 'notes_technical', NULL))
                  LEFT JOIN experiment_property num_tubes            ON (num_tubes.experiment_id = e.id            AND num_tubes.type_id            = getCvTermId('fly_olympiad_climbing', 'num_tubes', NULL))
                  LEFT JOIN experiment_property protocol             ON (protocol.experiment_id = e.id             AND protocol.type_id             = getCvTermId('fly_olympiad_climbing', 'protocol', NULL))
                  LEFT JOIN experiment_property rig                  ON (e.id = rig.experiment_id                  AND rig.type_id                  = getCvTermId('fly_olympiad_apparatus', 'rig', NULL))
                  LEFT JOIN experiment_property room                 ON (e.id = room.experiment_id                 AND room.type_id                 = getCvTermId('fly_olympiad_apparatus', 'room', NULL))
                  LEFT JOIN experiment_property screen_reason        ON (e.id = screen_reason.experiment_id        AND screen_reason.type_id        = getCvTermId('fly_olympiad_climbing', 'screen_reason', NULL))
                  LEFT JOIN experiment_property screen_type          ON (e.id = screen_type.experiment_id          AND screen_type.type_id          = getCvTermId('fly_olympiad_climbing', 'screen_type', NULL))
                  LEFT JOIN experiment_property temperature          ON (temperature.experiment_id = e.id          AND temperature.type_id          = getCvTermId('fly_olympiad_climbing', 'temperature', NULL))
WHERE e.type_id = getCvTermId('fly_olympiad_climbing', 'climbing', NULL)
;
CREATE INDEX olympiad_climbing_edmv_experiment_id_ind ON tmp_olympiad_climbing_experiment_data_mv(experiment_id);


-- =================================================== 
-- create temp table containing session properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_climbing_session_meta_data_mv;
CREATE TABLE tmp_olympiad_climbing_session_meta_data_mv
SELECT e.id AS experiment_id, s.id AS session_id, cast(s.name as char(250)) AS session_name, s.line_id AS line_id, cast(l.name as char(50)) AS line_name, cast(lab_cv.name as char(50)) AS line_lab,
       cast(cross_barcode.value as char(50)) AS cross_barcode, cast(cross_date.value as char(50)) AS cross_date, cast(datetime_sorting.value as char(50)) AS datetime_sorting,
       cast(effector.value as char(50)) AS effector, cast(flip_date.value as char(50)) AS flip_date, cast(flip_used.value as char(50)) AS flip_used,  cast(gender.value as char(50)) AS gender, 
       cast(genotype.value as char(50)) AS genotype, cast(handler_cross.value as char(50)) AS handler_cross, cast(handling_protocol.value as char(50)) AS handling_protocol, 
       cast(handler_sorting.value as char(50)) AS handler_sorting, cast(hours_starved.value as decimal(10,4))  AS hours_starved, cast(manual_pf.value as char(50)) AS manual_pf, cast(notes_technical.value  as char(500)) AS notes_technical, 
       cast(left(num_flies.value,10) as unsigned integer) AS num_flies, cast(left(num_flies_dead.value,10) as unsigned integer) AS num_flies_dead, cast(left(rearing_incubator.value,10) as unsigned integer) AS rearing_incubator, 
       cast(rearing_protocol.value as char(50)) AS rearing_protocol, cast(wish_list.value as char(50)) AS wish_list
FROM experiment e JOIN session s ON (s.experiment_id = e.id)
                  LEFT JOIN session_property cross_barcode         ON (cross_barcode.session_id = s.id         AND cross_barcode.type_id         = getCvTermId('fly_olympiad_climbing', 'cross_barcode', NULL))
                  LEFT JOIN session_property cross_date            ON (cross_date.session_id = s.id            AND cross_date.type_id            = getCvTermId('fly_olympiad', 'cross_date', NULL))
                  LEFT JOIN session_property datetime_sorting      ON (datetime_sorting.session_id = s.id      AND datetime_sorting.type_id      = getCvTermId('fly_olympiad_climbing', 'datetime_sorting', NULL))
                  LEFT JOIN session_property effector              ON (effector.session_id = s.id              AND effector.type_id              = getCvTermId('fly_olympiad', 'effector', NULL))
                  LEFT JOIN session_property flip_date             ON (s.id = flip_date.session_id             AND flip_date.type_id             = getCvTermId('fly_olympiad_climbing', 'flip_date', NULL))
                  LEFT JOIN session_property flip_used             ON (flip_used.session_id = s.id             AND flip_used.type_id             = getCvTermId('fly_olympiad_climbing', 'flip_used', NULL))
                  LEFT JOIN session_property gender                ON (gender.session_id = s.id                AND gender.type_id                = getCvTermId('fly_olympiad', 'gender', NULL))
                  LEFT JOIN session_property genotype              ON (genotype.session_id = s.id              AND genotype.type_id              = getCvTermId('fly_olympiad', 'genotype', NULL))
                  LEFT JOIN session_property handler_cross         ON (handler_cross.session_id = s.id         AND handler_cross.type_id         = getCvTermId('fly_olympiad_climbing', 'handler_cross', NULL))
                  LEFT JOIN session_property handling_protocol     ON (handling_protocol.session_id = s.id     AND handling_protocol.type_id     = getCvTermId('fly_olympiad_climbing', 'handling_protocol', NULL))
                  LEFT JOIN session_property handler_sorting       ON (handler_sorting.session_id = s.id       AND handler_sorting.type_id       = getCvTermId('fly_olympiad', 'handler_sorting', NULL))
                  LEFT JOIN session_property hours_starved         ON (hours_starved.session_id = s.id         AND hours_starved.type_id         = getCvTermId('fly_olympiad', 'hours_starved', NULL))
                  LEFT JOIN session_property manual_pf             ON (manual_pf.session_id = s.id             AND manual_pf.type_id             = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                  LEFT JOIN session_property notes_technical       ON (notes_technical.session_id = s.id       AND notes_technical.type_id       = getCvTermId('fly_olympiad_climbing', 'notes_technical', NULL))
                  LEFT JOIN session_property num_flies             ON (num_flies.session_id = s.id             AND num_flies.type_id             = getCvTermId('fly_olympiad', 'num_flies', NULL))
                  LEFT JOIN session_property num_flies_dead        ON (num_flies_dead.session_id = s.id        AND num_flies_dead.type_id        = getCvTermId('fly_olympiad', 'num_flies_dead', NULL))
                  LEFT JOIN session_property rearing_incubator     ON (rearing_incubator.session_id = s.id     AND rearing_incubator.type_id     = getCvTermId('fly_olympiad', 'rearing_incubator', NULL))
                  LEFT JOIN session_property rearing_protocol      ON (rearing_protocol.session_id = s.id      AND rearing_protocol.type_id      = getCvTermId('fly_olympiad', 'rearing_protocol', NULL))
                  LEFT JOIN session_property wish_list             ON (wish_list.session_id = s.id             AND wish_list.type_id             = getCvTermId('fly', 'wish_list', NULL))
                   -- line data
                  JOIN line l ON (s.line_id = l.id)
                  JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
WHERE e.type_id = getCvTermId('fly_olympiad_climbing', 'climbing', NULL)
;
CREATE INDEX olympiad_climbing_smd_mv_experiment_id_ind ON tmp_olympiad_climbing_session_meta_data_mv(experiment_id);

-- ===================================================
-- create temp table containing phase properties
-- ===================================================
DROP TABLE IF EXISTS tmp_olympiad_climbing_phase_meta_data_mv;
CREATE TABLE tmp_olympiad_climbing_phase_meta_data_mv
SELECT e.id AS experiment_id, group_concat(p.name order by cast(p.name as unsigned) separator ',') AS phases
FROM experiment e JOIN phase p ON (p.experiment_id = e.id)
WHERE e.type_id = getCvTermId('fly_olympiad_climbing', 'climbing', NULL)
group by e.id
;
CREATE INDEX olympiad_climbing_pmd_mv_experiment_id_ind ON tmp_olympiad_climbing_phase_meta_data_mv(experiment_id);

-- =================================================== 
-- create temp table combining experiment and session 
-- properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_climbing_data_mv;
CREATE TABLE tmp_olympiad_climbing_data_mv
SELECT e.experiment_id, e.experiment_name, s.line_id, s.line_lab, s.line_name, s.session_id, s.session_name, ph.id as phase_id, ph.name as phase_name, p.phases,
       e.archived, e.automated_pf, e.computer, s.cross_barcode, s.cross_date, s.datetime_sorting,
       e.day_of_week, s.effector, e.experimenter, e.exp_datetime, e.file_system_path, e.flag_aborted,
       e.flag_legacy, e.flag_redo, e.flag_review, s.flip_date, s.flip_used, s.gender, s.genotype, s.handler_cross,
       s.handler_sorting, s.handling_protocol, s.hours_starved, e.humidity, e.manual_pf, s.manual_pf as session_manual_pf, 
       e.metadata_version, e.notes_behavioral, e.notes_keyword, e.notes_technical, s.notes_technical as session_notes_technical, 
       s.num_flies, s.num_flies_dead, e.num_tubes, e.protocol, s.rearing_incubator, s.rearing_protocol, e.screen_reason, 
       e.screen_type, e.temperature, s.wish_list
FROM tmp_olympiad_climbing_experiment_data_mv  e
JOIN tmp_olympiad_climbing_session_meta_data_mv s ON (e.experiment_id = s.experiment_id)
JOIN tmp_olympiad_climbing_phase_meta_data_mv p ON (e.experiment_id = p.experiment_id)
JOIN phase ph on (e.experiment_id = ph.experiment_id);
CREATE INDEX olympiad_climbing_edmv_experiment_id_ind ON tmp_olympiad_climbing_data_mv(experiment_id);
CREATE INDEX olympiad_climbing_edmv_experiment_name_ind ON tmp_olympiad_climbing_data_mv(experiment_name);
CREATE INDEX olympiad_climbing_edmv_session_id_ind ON tmp_olympiad_climbing_data_mv(session_id);
CREATE INDEX olympiad_climbing_edmv_session_name_ind ON tmp_olympiad_climbing_data_mv(session_name);
CREATE INDEX olympiad_climbing_edmv_phases_ind ON tmp_olympiad_climbing_data_mv(phases(255));
CREATE INDEX olympiad_climbing_edmv_phase_name_ind ON tmp_olympiad_climbing_data_mv(phase_name);
CREATE INDEX olympiad_climbing_edmv_phase_id_ind ON tmp_olympiad_climbing_data_mv(phase_id);
CREATE INDEX olympiad_climbing_edmv_line_id_ind ON tmp_olympiad_climbing_data_mv(line_id);
CREATE INDEX olympiad_climbing_edmv_line_name_ind ON tmp_olympiad_climbing_data_mv(line_name);
CREATE INDEX olympiad_climbing_edmv_automated_pf_ind ON tmp_olympiad_climbing_data_mv(automated_pf);
CREATE INDEX olympiad_climbing_edmv_exp_datetime_ind ON tmp_olympiad_climbing_data_mv(exp_datetime);
CREATE INDEX olympiad_climbing_edmv_flag_aborted_ind ON tmp_olympiad_climbing_data_mv(flag_aborted);
CREATE INDEX olympiad_climbing_edmv_manual_pf_ind ON tmp_olympiad_climbing_data_mv(manual_pf);
CREATE INDEX olympiad_climbing_edmv_session_manual_pf_ind ON tmp_olympiad_climbing_data_mv(session_manual_pf);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_climbing_experiment_data_mv;
RENAME TABLE tmp_olympiad_climbing_data_mv TO olympiad_climbing_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_climbing_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_climbing_session_meta_data_mv;


-- ===================================================
-- create meta data materialized view
-- ===================================================
DROP TABLE IF EXISTS tmp_olympiad_climbing_meta_data_mv;
CREATE TABLE tmp_olympiad_climbing_meta_data_mv
SELECT DISTINCT
       e.experiment_id, e.experiment_name, e.line_id, e.line_lab, e.line_name, e.session_id, e.session_name, e.phases,
       e.archived, e.automated_pf, e.computer, e.cross_barcode, e.cross_date, e.datetime_sorting,
       e.day_of_week, e.effector, e.experimenter, e.exp_datetime, e.file_system_path, e.flag_aborted,
       e.flag_legacy, e.flag_redo, e.flag_review, e.flip_date, e.flip_used, e.gender, e.genotype, e.handler_cross,
       e.handler_sorting, e.handling_protocol, e.hours_starved, e.humidity, e.manual_pf, e.manual_pf as session_manual_pf,
       e.metadata_version, e.notes_behavioral, e.notes_keyword, e.notes_technical, e.notes_technical as session_notes_technical,
       e.num_flies, e.num_flies_dead, e.num_tubes, e.protocol, e.rearing_incubator, e.rearing_protocol, e.screen_reason,
       e.screen_type, e.temperature, e.wish_list
FROM olympiad_climbing_experiment_data_mv e;
CREATE INDEX olympiad_climbing_mdmv_experiment_id_ind ON tmp_olympiad_climbing_meta_data_mv(experiment_id);
CREATE INDEX olympiad_climbing_mdmv_experiment_name_ind ON tmp_olympiad_climbing_meta_data_mv(experiment_name);
CREATE INDEX olympiad_climbing_mdmv_session_id_ind ON tmp_olympiad_climbing_meta_data_mv(session_id);
CREATE INDEX olympiad_climbing_mdmv_session_name_ind ON tmp_olympiad_climbing_meta_data_mv(session_name);
CREATE INDEX olympiad_climbing_mdmv_phases_ind ON tmp_olympiad_climbing_meta_data_mv(phases(255));
CREATE INDEX olympiad_climbing_mdmv_line_id_ind ON tmp_olympiad_climbing_meta_data_mv(line_id);
CREATE INDEX olympiad_climbing_mdmv_line_name_ind ON tmp_olympiad_climbing_meta_data_mv(line_name);
CREATE INDEX olympiad_climbing_mdmv_automated_pf_ind ON tmp_olympiad_climbing_meta_data_mv(automated_pf);
CREATE INDEX olympiad_climbing_mdmv_exp_datetime_ind ON tmp_olympiad_climbing_meta_data_mv(exp_datetime);
CREATE INDEX olympiad_climbing_mdmv_flag_aborted_ind ON tmp_olympiad_climbing_meta_data_mv(flag_aborted);
CREATE INDEX olympiad_climbing_mdmv_manual_pf_ind ON tmp_olympiad_climbing_meta_data_mv(manual_pf);
CREATE INDEX olympiad_climbing_mdmv_session_manual_pf_ind ON tmp_olympiad_climbing_meta_data_mv(session_manual_pf);

DROP TABLE IF EXISTS olympiad_climbing_meta_data_mv;
RENAME TABLE tmp_olympiad_climbing_meta_data_mv TO olympiad_climbing_meta_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_climbing_meta_data_mv;



-- =================================================== 
-- create SAGE REST API view
-- =================================================== 

/* 
    olympiad_climbing_meta_data_vw
    
    This view creates one record for each experiment with every single piece of metadata.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_climbing_meta_data_vw AS 
SELECT e.experiment_id, e.experiment_name, e.line_id, e.line_lab, e.line_name, e.session_id, e.session_name, e.phases,
       e.archived, e.automated_pf, e.computer, e.cross_barcode, e.cross_date, e.datetime_sorting,
       e.day_of_week, e.effector, e.experimenter, e.exp_datetime, e.file_system_path, e.flag_aborted,
       e.flag_legacy, e.flag_redo, e.flag_review, e.flip_date, e.flip_used, e.gender, e.genotype, e.handler_cross,
       e.handler_sorting, e.handling_protocol, e.hours_starved, e.humidity, e.manual_pf, e.manual_pf as session_manual_pf,
       e.metadata_version, e.notes_behavioral, e.notes_keyword, e.notes_technical, e.notes_technical as session_notes_technical,
       e.num_flies, e.num_flies_dead, e.num_tubes, e.protocol, e.rearing_incubator, e.rearing_protocol, e.screen_reason,
       e.screen_type, e.temperature, e.wish_list 
FROM olympiad_climbing_meta_data_mv e;

/* 
    olympiad_climbing_data_vw
    
    This view creates one record for each score_array that is associated to a given experiment.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_climbing_data_vw AS
SELECT  STRAIGHT_JOIN 
       e.experiment_id, e.experiment_name, e.line_id, e.line_lab, e.line_name, e.session_id, e.session_name, e.phase_name, e.phases,
       e.archived, e.automated_pf, e.computer, e.cross_barcode, e.cross_date, e.datetime_sorting,
       e.day_of_week, e.effector, e.experimenter, e.exp_datetime, e.file_system_path, e.flag_aborted,
       e.flag_legacy, e.flag_redo, e.flag_review, e.flip_date, e.flip_used, e.gender, e.genotype, e.handler_cross,
       e.handler_sorting, e.handling_protocol, e.hours_starved, e.humidity, e.manual_pf, e.manual_pf as session_manual_pf,
       e.metadata_version, e.notes_behavioral, e.notes_keyword, e.notes_technical, e.notes_technical as session_notes_technical,
       e.num_flies, e.num_flies_dead, e.num_tubes, e.protocol, e.rearing_incubator, e.rearing_protocol, e.screen_reason,
       e.screen_type, e.temperature, e.wish_list,
       getCvTermName(sa.type_id) AS data_type,
       uncompress(sa.value) AS data,
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format
FROM olympiad_climbing_experiment_data_mv e
     JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_climbing', NULL) AND sa.session_id = e.session_id and (sa.phase_id = e.phase_id or sa.phase_id is null))
;


