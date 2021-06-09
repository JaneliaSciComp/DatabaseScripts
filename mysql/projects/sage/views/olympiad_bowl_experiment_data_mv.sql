/* 
    name: 

    mv:   olympiad_bowl_experiment_data_mv

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
DROP TABLE IF EXISTS tmp_olympiad_bowl_experiment_data_mv;
CREATE TABLE tmp_olympiad_bowl_experiment_data_mv
SELECT e.id AS experiment_id, cast(e.name as char(250)) AS experiment_name, 
       cast(analysis_protocol.value as char(50)) AS analysis_protocol, cast(archived.value as char(50)) AS archived, cast(automated_pf.value as char(50)) AS automated_pf,  cast(automated_pf_category.value as char(50)) AS automated_pf_category,
       cast(data_capture_version.value as char(50)) AS data_capture_version, dayofweek(cast(exp_datetime.value as datetime)) AS day_of_week, cast(e.experimenter as char(50)) AS experimenter, 
       cast(exp_datetime.value as char(255)) AS exp_datetime, cast(file_system_path.value as char(255)) AS file_system_path, cast(flag_aborted.value as unsigned integer) AS flag_aborted, 
       cast(flag_legacy.value as char(1)) AS flag_legacy, cast(flag_redo.value as char(1)) AS flag_redo, cast(flag_review.value as char(1)) AS flag_review, 
       cast(humidity.value as decimal(10,4)) AS humidity, cast(manual_curation_date.value as char(50)) AS manual_curation_date, cast(manual_curator.value as char(50)) AS manual_curator, 
       cast(manual_pf.value as char(50)) AS manual_pf, cast(manual_rating.value as char(50)) AS manual_rating, cast(metadata_curated.value as char(50)) AS metadata_curated, cast(notes_behavioral.value as char(500)) AS notes_behavioral, 
       cast(notes_curation.value as char(255)) AS notes_curation, cast(notes_keyword.value as char(255)) AS notes_keyword, cast(notes_technical.value  as char(500)) AS notes_technical, 
       cast(protocol.value as char(50)) AS protocol, cast(screen_reason.value as char(50)) AS screen_reason, cast(screen_type.value as char(50)) AS screen_type, 
       cast(temperature.value as decimal(10,4)) AS temperature 
FROM experiment e LEFT JOIN experiment_property analysis_protocol     ON (analysis_protocol.experiment_id = e.id     AND analysis_protocol.type_id     = getCvTermId('fly_olympiad_fly_bowl', 'analysis_protocol', NULL))
                  LEFT JOIN experiment_property archived              ON (archived.experiment_id = e.id              AND archived.type_id              = getCvTermId('fly_olympiad_fly_bowl', 'archived', NULL))
                  LEFT JOIN experiment_property automated_pf          ON (automated_pf.experiment_id = e.id          AND automated_pf.type_id          = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))
                  LEFT JOIN experiment_property automated_pf_category ON (automated_pf_category.experiment_id = e.id AND automated_pf_category.type_id = getCvTermId('fly_olympiad_qc', 'automated_pf_category', NULL))
                  LEFT JOIN experiment_property data_capture_version  ON (data_capture_version.experiment_id = e.id  AND data_capture_version.type_id  = getCvTermId('fly_olympiad_fly_bowl', 'data_capture_version', NULL))
                  LEFT JOIN experiment_property experimenter          ON (experimenter.experiment_id = e.id          AND experimenter.type_id          = getCvTermId('fly_olympiad_fly_bowl', 'experimenter', NULL))
                  LEFT JOIN experiment_property exp_datetime          ON (exp_datetime.experiment_id = e.id          AND exp_datetime.type_id          = getCvTermId('fly_olympiad_fly_bowl', 'exp_datetime', NULL))
                  LEFT JOIN experiment_property file_system_path      ON (file_system_path.experiment_id =e.id       AND file_system_path.type_id      = getCvTermId('fly_olympiad_fly_bowl', 'file_system_path', NULL))
                  LEFT JOIN experiment_property flag_aborted          ON (flag_aborted.experiment_id = e.id          AND flag_aborted.type_id          = getCvTermId('fly_olympiad_fly_bowl', 'flag_aborted', NULL))
                  LEFT JOIN experiment_property flag_legacy           ON (flag_legacy.experiment_id = e.id           AND flag_legacy.type_id           = getCvTermId('fly_olympiad_fly_bowl', 'flag_legacy', NULL))
                  LEFT JOIN experiment_property flag_redo             ON (flag_redo.experiment_id = e.id             AND flag_redo.type_id             = getCvTermId('fly_olympiad_fly_bowl', 'flag_redo', NULL))
                  LEFT JOIN experiment_property flag_review           ON (flag_review.experiment_id = e.id           AND flag_review.type_id           = getCvTermId('fly_olympiad_fly_bowl', 'flag_review', NULL))
                  LEFT JOIN experiment_property humidity              ON (humidity.experiment_id = e.id              AND humidity.type_id              = getCvTermId('fly_olympiad_fly_bowl', 'humidity', NULL))
                  LEFT JOIN experiment_property manual_curation_date  ON (manual_curation_date.experiment_id = e.id  AND manual_curation_date.type_id  = getCvTermId('fly_olympiad_qc', 'manual_curation_date', NULL))
                  LEFT JOIN experiment_property manual_curator        ON (manual_curator.experiment_id = e.id        AND manual_curator.type_id        = getCvTermId('fly_olympiad_qc', 'manual_curator', NULL))
                  LEFT JOIN experiment_property manual_pf             ON (manual_pf.experiment_id = e.id             AND manual_pf.type_id             = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                  LEFT JOIN experiment_property manual_rating         ON (manual_rating.experiment_id = e.id         AND manual_rating.type_id         = getCvTermId('fly_olympiad_qc', 'manual_rating', NULL))
                  LEFT JOIN experiment_property metadata_curated      ON (metadata_curated.experiment_id = e.id      AND metadata_curated.type_id      = getCvTermId('fly_olympiad', 'metadata_curated', NULL))
                  LEFT JOIN experiment_property notes_behavioral      ON (notes_behavioral.experiment_id = e.id      AND notes_behavioral.type_id      = getCvTermId('fly_olympiad_fly_bowl', 'notes_behavioral', NULL))
                  LEFT JOIN experiment_property notes_curation        ON (notes_curation.experiment_id = e.id        AND notes_curation.type_id        = getCvTermId('fly_olympiad_qc', 'notes_curation', NULL))
                  LEFT JOIN experiment_property notes_keyword         ON (notes_keyword.experiment_id = e.id         AND notes_keyword.type_id         = getCvTermId('fly_olympiad_fly_bowl', 'notes_keyword', NULL))
                  LEFT JOIN experiment_property notes_technical       ON (notes_technical.experiment_id = e.id       AND notes_technical.type_id       = getCvTermId('fly_olympiad_fly_bowl', 'notes_technical', NULL))
                  LEFT JOIN experiment_property protocol              ON (protocol.experiment_id = e.id              AND protocol.type_id              = getCvTermId('fly_olympiad_fly_bowl', 'protocol', NULL))
                  LEFT JOIN experiment_property screen_reason         ON (e.id = screen_reason.experiment_id         AND screen_reason.type_id         = getCvTermId('fly_olympiad_fly_bowl', 'screen_reason', NULL))
                  LEFT JOIN experiment_property screen_type           ON (e.id = screen_type.experiment_id           AND screen_type.type_id           = getCvTermId('fly_olympiad_fly_bowl', 'screen_type', NULL))
                  LEFT JOIN experiment_property temperature           ON (temperature.experiment_id = e.id           AND temperature.type_id           = getCvTermId('fly_olympiad_fly_bowl', 'temperature', NULL))
WHERE e.type_id = getCvTermId('fly_olympiad_fly_bowl', 'fly_bowl', NULL)
;
CREATE INDEX olympiad_bowl_edmv_experiment_id_ind ON tmp_olympiad_bowl_experiment_data_mv(experiment_id);


-- =================================================== 
-- create temp table containing session properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_bowl_session_meta_data_mv;
CREATE TABLE tmp_olympiad_bowl_session_meta_data_mv
SELECT e.id AS experiment_id, s.id AS session_id, cast(s.name as char(250)) AS session_name, s.line_id AS line_id, cast(l.name as char(50)) AS line_name, cast(lab_cv.name as char(50)) AS line_lab,
       cast(apparatus_id.value as char(255)) AS apparatus_id, cast(bowl.value as char(50)) AS bowl, cast(camera.value as char(50)) AS camera, 
       cast(computer.value as char(50)) AS computer, cast(cross_barcode.value as char(50)) AS cross_barcode, cast(cross_date.value as char(50)) AS cross_date, 
       cast(effector.value as char(50)) AS effector, cast(environmental_chamber.value as unsigned integer) AS environmental_chamber, cast(flip_date.value as char(50)) AS flip_date, 
       cast(flip_used.value as char(50)) AS flip_used,  cast(gender.value as char(50)) AS gender, cast(genotype.value as char(50)) AS genotype,
       cast(handler_cross.value as char(50)) AS handler_cross, cast(handler_sorting.value as char(50)) AS handler_sorting, cast(handler_starvation.value as char(50)) AS handler_starvation, 
       cast(handling_protocol.value as char(50)) AS handling_protocol, cast(harddrive.value as char(50)) AS harddrive, cast(hours_sorted.value as decimal(10,4)) AS hours_sorted, 
       cast(hours_starved.value as decimal(10,4))  AS hours_starved, cast(num_flies.value as unsigned integer) AS num_flies, cast(num_flies_damaged.value as unsigned integer) AS num_flies_damaged, 
       cast(num_flies_dead.value as unsigned integer) AS num_flies_dead, cast(plate.value as unsigned integer) AS plate, cast(rearing_incubator.value as unsigned integer) AS rearing_incubator, 
       cast(rearing_protocol.value as char(50)) AS rearing_protocol, cast(rig.value as unsigned integer) AS rig, cast(robot_stock_copy.value as char(50)) AS robot_stock_copy,
       cast(room.value as char(50)) AS room, cast(seconds_fliesloaded.value as decimal(10,4)) AS seconds_fliesloaded, cast(seconds_shiftflytemp.value as decimal(10,4)) AS seconds_shiftflytemp, 
       cast(top_plate.value as unsigned integer) AS top_plate, cast(visual_surround.value as char(50)) AS visual_surround, 
       (case when (wish_list.value is not null and wish_list.value != -1) then cast(wish_list.value as char(50)) else cast(guess_wish_list.value as char(50)) end) AS wish_list
FROM experiment e JOIN session s ON (s.experiment_id = e.id)
                  LEFT JOIN session_property apparatus_id          ON (apparatus_id.session_id = s.id          AND apparatus_id.type_id          = getCvTermId('fly_olympiad', 'apparatus_id', NULL))
                  LEFT JOIN session_property bowl                  ON (bowl.session_id = s.id                  AND bowl.type_id                  = getCvTermId('fly_olympiad_apparatus', 'bowl', NULL))
                  LEFT JOIN session_property camera                ON (camera.session_id = s.id                AND camera.type_id                = getCvTermId('fly_olympiad_apparatus', 'camera', NULL))
                  LEFT JOIN session_property computer              ON (computer.session_id = s.id              AND computer.type_id              = getCvTermId('fly_olympiad_apparatus', 'computer', NULL))
                  LEFT JOIN session_property cross_barcode         ON (cross_barcode.session_id = s.id         AND cross_barcode.type_id         = getCvTermId('fly_olympiad_fly_bowl', 'cross_barcode', NULL))
                  LEFT JOIN session_property cross_date            ON (cross_date.session_id = s.id            AND cross_date.type_id            = getCvTermId('fly_olympiad', 'cross_date', NULL))
                  LEFT JOIN session_property effector              ON (effector.session_id = s.id              AND effector.type_id              = getCvTermId('fly_olympiad', 'effector', NULL))
                  LEFT JOIN session_property environmental_chamber ON (environmental_chamber.session_id = s.id AND environmental_chamber.type_id = getCvTermId('fly_olympiad_apparatus', 'environmental_chamber', NULL))
                  LEFT JOIN session_property flip_date             ON (flip_date.session_id = s.id             AND flip_date.type_id             = getCvTermId('fly_olympiad_fly_bowl', 'flip_date', NULL))
                  LEFT JOIN session_property flip_used             ON (flip_used.session_id = s.id             AND flip_used.type_id             = getCvTermId('fly_olympiad_fly_bowl', 'flip_used', NULL))
                  LEFT JOIN session_property gender                ON (gender.session_id = s.id                AND gender.type_id                = getCvTermId('fly_olympiad', 'gender', NULL))
                  LEFT JOIN session_property genotype              ON (genotype.session_id = s.id              AND genotype.type_id              = getCvTermId('fly_olympiad', 'genotype', NULL))
                  LEFT JOIN session_property guess_wish_list       ON (guess_wish_list.session_id = s.id       AND guess_wish_list.type_id       = getCvTermId('fly', 'guess_wish_list', NULL))
                  LEFT JOIN session_property handler_cross         ON (handler_cross.session_id = s.id         AND handler_cross.type_id         = getCvTermId('fly_olympiad_fly_bowl', 'handler_cross', NULL))
                  LEFT JOIN session_property handler_sorting       ON (handler_sorting.session_id = s.id       AND handler_sorting.type_id       = getCvTermId('fly_olympiad', 'handler_sorting', NULL))
                  LEFT JOIN session_property handler_starvation    ON (handler_starvation.session_id = s.id    AND handler_starvation.type_id    = getCvTermId('fly_olympiad', 'handler_starvation', NULL))
                  LEFT JOIN session_property handling_protocol     ON (handling_protocol.session_id = s.id     AND handling_protocol.type_id     = getCvTermId('fly_olympiad', 'handling_protocol', NULL))
                  LEFT JOIN session_property harddrive             ON (harddrive.session_id = s.id             AND harddrive.type_id             = getCvTermId('fly_olympiad_apparatus', 'harddrive', NULL))
                  LEFT JOIN session_property hours_sorted          ON (hours_sorted.session_id = s.id          AND hours_sorted.type_id          = getCvTermId('fly_olympiad', 'hours_sorted', NULL))
                  LEFT JOIN session_property hours_starved         ON (hours_starved.session_id = s.id         AND hours_starved.type_id         = getCvTermId('fly_olympiad', 'hours_starved', NULL))
                  LEFT JOIN session_property num_flies             ON (num_flies.session_id = s.id             AND num_flies.type_id             = getCvTermId('fly_olympiad', 'num_flies', NULL))
                  LEFT JOIN session_property num_flies_damaged     ON (num_flies_damaged.session_id = s.id     AND num_flies_damaged.type_id     = getCvTermId('fly_olympiad', 'num_flies_damaged', NULL))
                  LEFT JOIN session_property num_flies_dead        ON (num_flies_dead.session_id = s.id        AND num_flies_dead.type_id        = getCvTermId('fly_olympiad', 'num_flies_dead', NULL))
                  LEFT JOIN session_property plate                 ON (plate.session_id = s.id                 AND plate.type_id                 = getCvTermId('fly_olympiad_apparatus', 'plate', NULL))
                  LEFT JOIN session_property rearing_incubator     ON (rearing_incubator.session_id = s.id     AND rearing_incubator.type_id     = getCvTermId('fly_olympiad', 'rearing_incubator', NULL))
                  LEFT JOIN session_property rearing_protocol      ON (rearing_protocol.session_id = s.id      AND rearing_protocol.type_id      = getCvTermId('fly_olympiad', 'rearing_protocol', NULL))
                  LEFT JOIN session_property rig                   ON (rig.session_id = s.id                   AND rig.type_id                   = getCvTermId('fly_olympiad_apparatus', 'rig', NULL))
                  LEFT JOIN session_property robot_stock_copy      ON (robot_stock_copy.session_id = s.id      AND robot_stock_copy.type_id      = getCvTermId('fly_olympiad_fly_bowl', 'robot_stock_copy', NULL))
                  LEFT JOIN session_property room                  ON (room.session_id = s.id                  AND room.type_id                  = getCvTermId('fly_olympiad_apparatus', 'room', NULL))
                  LEFT JOIN session_property seconds_fliesloaded   ON (seconds_fliesloaded.session_id = s.id   AND seconds_fliesloaded.type_id   = getCvTermId('fly_olympiad_fly_bowl', 'seconds_fliesloaded', NULL))
                  LEFT JOIN session_property seconds_shiftflytemp  ON (seconds_shiftflytemp.session_id = s.id  AND seconds_shiftflytemp.type_id  = getCvTermId('fly_olympiad_fly_bowl', 'seconds_shiftflytemp', NULL))
                  LEFT JOIN session_property top_plate             ON (top_plate.session_id = s.id             AND top_plate.type_id             = getCvTermId('fly_olympiad_apparatus', 'top_plate', NULL))
                  LEFT JOIN session_property visual_surround       ON (visual_surround.session_id = s.id       AND visual_surround.type_id       = getCvTermId('fly_olympiad_apparatus', 'visual_surround', NULL))
                  LEFT JOIN session_property wish_list             ON (wish_list.session_id = s.id             AND wish_list.type_id             = getCvTermId('fly', 'wish_list', NULL))
                   -- line data
                  JOIN line l ON (s.line_id = l.id)
                  JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
WHERE e.type_id = getCvTermId('fly_olympiad_fly_bowl', 'fly_bowl', NULL)
;
CREATE INDEX olympiad_bowl_smd_mv_experiment_id_ind ON tmp_olympiad_bowl_session_meta_data_mv(experiment_id);

-- =================================================== 
-- create temp table combining experiment and session 
-- properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_bowl_data_mv;
CREATE TABLE tmp_olympiad_bowl_data_mv
SELECT e.experiment_id, e.experiment_name, s.line_id, s.line_lab, s.line_name,
       e.analysis_protocol, s.apparatus_id, e.archived, e.automated_pf, e.automated_pf_category, s.bowl, s.camera, 
       s.computer, s.cross_barcode, s.cross_date, e.data_capture_version, e.day_of_week, 
       s.effector, s.environmental_chamber, e.experimenter, e.exp_datetime, e.file_system_path, 
       e.flag_aborted, e.flag_legacy, e.flag_redo, e.flag_review, s.flip_date, s.flip_used, 
       s.gender, s.genotype, s.handler_cross, s.handler_sorting, s.handler_starvation, 
       s.handling_protocol, s.harddrive, s.hours_sorted, s.hours_starved, e.humidity, 
       e.manual_curator, e.manual_curation_date, e.manual_pf, e.manual_rating, e.metadata_curated, e.notes_behavioral, 
       e.notes_curation, e.notes_keyword, e.notes_technical, s.num_flies, s.num_flies_dead, 
       s.num_flies_damaged, s.plate, e.protocol, s.rearing_incubator, s.rearing_protocol, s.rig, 
       s.robot_stock_copy, s.room, e.screen_reason, e.screen_type, s.seconds_fliesloaded, 
       s.seconds_shiftflytemp, s.session_id, s.session_name, e.temperature, s.top_plate, 
       s.visual_surround, s.wish_list
FROM tmp_olympiad_bowl_experiment_data_mv  e
JOIN tmp_olympiad_bowl_session_meta_data_mv s ON (e.experiment_id = s.experiment_id);
CREATE INDEX olympiad_bowl_edmv_experiment_id_ind ON tmp_olympiad_bowl_data_mv(experiment_id);
CREATE INDEX olympiad_bowl_edmv_experiment_name_ind ON tmp_olympiad_bowl_data_mv(experiment_name);
CREATE INDEX olympiad_bowl_edmv_session_id_ind ON tmp_olympiad_bowl_data_mv(session_id);
CREATE INDEX olympiad_bowl_edmv_session_name_ind ON tmp_olympiad_bowl_data_mv(session_name);
CREATE INDEX olympiad_bowl_edmv_line_id_ind ON tmp_olympiad_bowl_data_mv(line_id);
CREATE INDEX olympiad_bowl_edmv_line_name_ind ON tmp_olympiad_bowl_data_mv(line_name);
CREATE INDEX olympiad_bowl_edmv_automated_pf_ind ON tmp_olympiad_bowl_data_mv(automated_pf);
CREATE INDEX olympiad_bowl_edmv_automated_pf_cat_ind ON tmp_olympiad_bowl_data_mv(automated_pf_category);
CREATE INDEX olympiad_bowl_edmv_exp_datetime_ind ON tmp_olympiad_bowl_data_mv(exp_datetime);
CREATE INDEX olympiad_bowl_edmv_flag_aborted_ind ON tmp_olympiad_bowl_data_mv(flag_aborted);
CREATE INDEX olympiad_bowl_edmv_manual_pf_ind ON tmp_olympiad_bowl_data_mv(manual_pf);
CREATE INDEX olympiad_bowl_edmv_screen_reason_ind ON tmp_olympiad_bowl_data_mv(screen_reason);
CREATE INDEX olympiad_bowl_edmv_screen_type_ind ON tmp_olympiad_bowl_data_mv(screen_type);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_bowl_experiment_data_mv;
RENAME TABLE tmp_olympiad_bowl_data_mv TO olympiad_bowl_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_bowl_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_bowl_session_meta_data_mv;


-- =================================================== 
-- create SAGE REST API view
-- =================================================== 

/* 
    olympiad_bowl_meta_data_vw
    
    This view creates one record for each experiment with every single piece of metadata.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_bowl_meta_data_vw AS 
SELECT * 
FROM olympiad_bowl_experiment_data_mv;

/* 
    olympiad_bowl_data_vw
    
    This view creates one record for each score_array that is associated to a given experiment.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_bowl_data_vw AS
SELECT  STRAIGHT_JOIN e.*,
       getCvTermName(sa.type_id) AS data_type,
       uncompress(sa.value) AS data,
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format
FROM olympiad_bowl_experiment_data_mv e
     JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_fly_bowl', NULL) AND sa.experiment_id = e.experiment_id)
     INNER JOIN cv_term ct ON (sa.type_id = ct.id)
WHERE ct.name NOT LIKE 'hist%';

/* 
    olympiad_bowl_data_vw2
    
    This view creates one record for each score that is associated to a given experiment.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_bowl_data_vw2 AS
SELECT STRAIGHT_JOIN e.*,
       score_cv.name AS data_type,
       score.value AS data,
       1 AS data_rows, 
       1 AS data_columns, 
       'double' AS data_format
FROM olympiad_bowl_experiment_data_mv e
     JOIN score ON (score.session_id = e.session_id)
     JOIN cv_term score_cv ON (score.type_id = score_cv.id)
;

/* 
    olympiad_bowl_score_data_vw
    
    This view creates one record for each score that is associated to a given experiment.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_bowl_score_data_vw AS
SELECT STRAIGHT_JOIN e.*,
       score_cv.name AS data_type,
       score.value AS data,
       1 AS data_rows, 
       1 AS data_columns, 
       'double' AS data_format
FROM olympiad_bowl_experiment_data_mv e
     JOIN score ON (score.session_id = e.session_id)
     JOIN cv_term score_cv ON (score.type_id = score_cv.id)
;

/* 
    olympiad_bowl_histogram_vw
    
    This view creates one record for each score_array that is associated to a given experiment.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_bowl_histogram_vw AS
SELECT STRAIGHT_JOIN e.*,
       getCvTermName(sa.type_id) AS data_type,
       uncompress(sa.value) AS data,
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format
FROM olympiad_bowl_experiment_data_mv e
     JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_fly_bowl', NULL) AND sa.experiment_id = e.experiment_id)
     INNER JOIN cv_term ct ON (sa.type_id = ct.id)
WHERE ct.name LIKE 'hist%';

