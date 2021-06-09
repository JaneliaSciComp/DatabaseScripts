/* 
    name: olympiad_sterility_data_vw

    mv:   olympiad_sterility_experiment_data_mv

    app:  SAGE REST API
    
    note: This script performs the following queries to flatten Sterility Assay data.
          1.  Create a temp table containing experiment properties
          2.  Create a temp table containing session properties and scores.
          3.  Create a temp table combining experiment and session properties plus scores. 
          4.  Create materialized view of combined temp table.
          5.  Create view on materialized view for use by SAGE REST API
*/

-- =================================================== 
-- create temp table containing experiment properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_sterility_experiment_data_mv;
CREATE TABLE tmp_olympiad_sterility_experiment_data_mv
SELECT  e.id AS experiment_id, cast(e.name as char(250)) AS experiment_name,
        cast(date_scanned.value as char(50)) AS date_scanned, cast(exp_datetime.value as char(50)) AS exp_datetime, dayofweek(cast(exp_datetime.value as datetime)) AS experiment_day_of_week,
        cast(flag_legacy.value as char(1)) AS flag_legacy, cast(gender.value as char(50)) AS gender, cast(handling_protocol.value as char(50)) AS handling_protocol, 
        cast(humidity.value as char(50)) AS humidity, cast(protocol.value as char(50)) AS protocol, cast(rearing_protocol.value as char(50)) AS rearing_protocol, 
        cast(robot_stock_copy.value as char(50)) AS robot_stock_copy, cast(room.value as char(50)) AS room, cast(screen_reason.value as char(225)) AS screen_reason, 
        cast(screen_type.value as char(50)) AS screen_type, cast(temperature.value as char(50)) AS temperature, cast(wish_list.value as char(50)) AS wish_list
FROM experiment e LEFT JOIN experiment_property date_scanned           ON (e.id = date_scanned.experiment_id        AND date_scanned.type_id      = getCvTermId('fly_olympiad_sterility', 'date_scanned', NULL))
                  LEFT JOIN experiment_property exp_datetime           ON (e.id = exp_datetime.experiment_id        AND exp_datetime.type_id      = getCvTermId('fly_olympiad_sterility', 'exp_datetime', NULL))
                  LEFT JOIN experiment_property flag_legacy            ON (e.id = flag_legacy.experiment_id         AND flag_legacy.type_id       = getCvTermId('fly_olympiad_sterility', 'flag_legacy', NULL))
                  LEFT JOIN experiment_property gender                 ON (e.id = gender.experiment_id              AND gender.type_id            = getCvTermId('fly_olympiad_sterility', 'gender', NULL))
                  LEFT JOIN experiment_property handling_protocol      ON (e.id = handling_protocol.experiment_id   AND handling_protocol.type_id = getCvTermId('fly_olympiad_sterility', 'handling_protocol', NULL))
                  LEFT JOIN experiment_property humidity               ON (e.id = humidity.experiment_id            AND humidity.type_id          = getCvTermId('fly_olympiad_sterility', 'humidity', NULL))
                  LEFT JOIN experiment_property protocol               ON (e.id = protocol.experiment_id            AND protocol.type_id          = getCvTermId('fly_olympiad_sterility', 'protocol', NULL))
                  LEFT JOIN experiment_property rearing_protocol       ON (e.id = rearing_protocol.experiment_id    AND rearing_protocol.type_id  = getCvTermId('fly_olympiad_sterility', 'rearing_protocol', NULL))
                  LEFT JOIN experiment_property robot_stock_copy       ON (e.id = robot_stock_copy.experiment_id    AND robot_stock_copy.type_id  = getCvTermId('fly_olympiad_sterility', 'robot_stock_copy', NULL))
                  LEFT JOIN experiment_property room                   ON (e.id = room.experiment_id                AND room.type_id              = getCvTermId('fly_olympiad_apparatus', 'room', NULL))
                  LEFT JOIN experiment_property screen_reason          ON (e.id = screen_reason.experiment_id       AND screen_reason.type_id     = getCvTermId('fly_olympiad_sterility', 'screen_reason', NULL))
                  LEFT JOIN experiment_property screen_type            ON (e.id = screen_type.experiment_id         AND screen_type.type_id       = getCvTermId('fly_olympiad_sterility', 'screen_type', NULL))
                  LEFT JOIN experiment_property temperature            ON (e.id = temperature.experiment_id         AND temperature.type_id       = getCvTermId('fly_olympiad_sterility', 'temperature', NULL))
                  LEFT JOIN experiment_property wish_list              ON (e.id = wish_list.experiment_id           AND wish_list.type_id         = getCvTermId('fly_olympiad_sterility', 'wish_list', NULL))
WHERE e.type_id = getCvTermId('fly_olympiad_sterility', 'sterility', NULL)
;
CREATE INDEX olympiad_sterility_edmv_experiment_id_ind ON tmp_olympiad_sterility_experiment_data_mv(experiment_id);

-- =================================================== 
-- create temp table containing session properties
-- and scores.
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_sterility_session_data_mv;
CREATE TABLE tmp_olympiad_sterility_session_data_mv
SELECT  s.experiment_id AS experiment_id, s.id AS session_id, s.line_id AS line_id, 
        cast(l.name as char(50)) AS line_name, cast(lab_cv.name as char(50)) AS line_lab, cast(s.name as char(250)) AS session_name, 
        cast(archived.value as char(1)) AS archived, cast(automated_pf.value as char(1)) AS automated_pf, 
        cast(avg_size.value as char(50)) AS avg_size, cast(cross_barcode.value as char(50)) AS cross_barcode, cast(cross_date.value as char(50)) AS cross_date,
        cast(effector.value as char(50)) AS effector, cast(experimenter.value as char(50)) AS experimenter, cast(file_system_path.value as char(225)) AS file_system_path, 
        cast(flag_aborted.value as char(1)) AS flag_aborted, cast(flag_redo.value as char(1)) AS flag_redo, cast(flag_review.value as char(1)) AS flag_review, 
        cast(flip_date.value as char(50)) AS flip_date, cast(flip_used.value as char(1)) AS flip_used, cast(genotype.value as char(50)) AS genotype,
        cast(handler_cross.value as char(50)) AS handler_cross, cast(handler_sorting.value as char(50)) as handler_sorting, 
        cast(hit_detection.value as char(50)) AS hit_detection, cast(hit_detection_notes.value as char(225)) AS hit_detection_notes, cast(manual_pf.value as char(1)) AS manual_pf,
        cast(max_temperature.value as char(50)) AS max_temperature, cast(min_temperature.value as char(50)) AS min_temperature,
        cast(notes_technical.value as char(225)) AS notes_technical, cast(num_flies.value as char(50)) AS num_flies, cast(rearing_incubator.value as char(3)) AS rearing_incubator, 
        cast(rep.value as char(50)) AS rep, cast(total_area.value as char(50)) AS total_area, cast(total_area_count.value as char(50)) AS total_area_count, 
        cast(tube.value as char(50)) as tube, cast(getCvTermName(sc.type_id) as char(50)) AS data_type, sc.value AS data
FROM session s LEFT JOIN session_property archived             ON (s.id = archived.session_id               AND archived.type_id            = getCvTermId('fly_olympiad_sterility', 'archived', NULL))
               LEFT JOIN session_property automated_pf         ON (s.id = automated_pf.session_id           AND automated_pf.type_id        = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))
               LEFT JOIN session_property avg_size             ON (s.id = avg_size.session_id               AND avg_size.type_id            = getCvTermId('fly_olympiad_sterility', 'avg_size', NULL))
               LEFT JOIN session_property cross_barcode        ON (s.id = cross_barcode.session_id          AND cross_barcode.type_id       = getCvTermId('fly_olympiad_sterility', 'cross_barcode', NULL))
               LEFT JOIN session_property cross_date           ON (s.id = cross_date.session_id             AND cross_date.type_id          = getCvTermId('fly_olympiad_sterility', 'cross_date', NULL))
               LEFT JOIN session_property effector             ON (s.id = effector.session_id               AND effector.type_id            = getCvTermId('fly_olympiad_sterility', 'effector', NULL))
               LEFT JOIN session_property experimenter         ON (s.id = experimenter.session_id           AND experimenter.type_id        = getCvTermId('fly_olympiad_sterility', 'experimenter', NULL))
               LEFT JOIN session_property file_system_path     ON (s.id = file_system_path.session_id       AND file_system_path.type_id    = getCvTermId('fly_olympiad_sterility', 'file_system_path', NULL))
               LEFT JOIN session_property flag_aborted         ON (s.id = flag_aborted.session_id           AND flag_aborted.type_id        = getCvTermId('fly_olympiad_sterility', 'flag_aborted', NULL))
               LEFT JOIN session_property flag_redo            ON (s.id = flag_redo.session_id              AND flag_redo.type_id           = getCvTermId('fly_olympiad_sterility', 'flag_redo', NULL))
               LEFT JOIN session_property flag_review          ON (s.id = flag_review.session_id            AND flag_review.type_id         = getCvTermId('fly_olympiad_sterility', 'flag_review', NULL))
               LEFT JOIN session_property flip_date            ON (s.id = flip_date.session_id              AND flip_date.type_id           = getCvTermId('fly_olympiad_sterility', 'flip_date', NULL))
               LEFT JOIN session_property flip_used            ON (s.id = flip_used.session_id              AND flip_used.type_id           = getCvTermId('fly_olympiad_sterility', 'flip_used', NULL))
               LEFT JOIN session_property genotype             ON (s.id = genotype.session_id               AND genotype.type_id            = getCvTermId('fly_olympiad_sterility', 'genotype', NULL))
               LEFT JOIN session_property handler_cross        ON (s.id = handler_cross.session_id          AND handler_cross.type_id       = getCvTermId('fly_olympiad_sterility', 'handler_cross', NULL))
               LEFT JOIN session_property handler_sorting      ON (s.id = handler_sorting.session_id        AND handler_sorting.type_id     = getCvTermId('fly_olympiad_sterility', 'handler_sorting', NULL))                   
               LEFT JOIN session_property hit_detection        ON (s.id = hit_detection.session_id          AND hit_detection.type_id       = getCvTermId('fly_olympiad_sterility', 'hit_detection', NULL))
               LEFT JOIN session_property hit_detection_notes  ON (s.id = hit_detection_notes.session_id    AND hit_detection_notes.type_id = getCvTermId('fly_olympiad_sterility', 'hit_detection_notes', NULL))
               LEFT JOIN session_property manual_pf            ON (s.id = manual_pf.session_id              AND manual_pf.type_id           = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
               LEFT JOIN session_property max_temperature      ON (s.id = max_temperature.session_id        AND max_temperature.type_id     = getCvTermId('fly_olympiad_sterility', 'max_temperature', NULL))
               LEFT JOIN session_property min_temperature      ON (s.id = min_temperature.session_id        AND min_temperature.type_id     = getCvTermId('fly_olympiad_sterility', 'min_temperature', NULL))
               LEFT JOIN session_property notes_technical      ON (s.id = notes_technical.session_id        AND notes_technical.type_id     = getCvTermId('fly_olympiad_sterility', 'notes_technical', NULL))
               LEFT JOIN session_property num_flies            ON (s.id = num_flies.session_id              AND num_flies.type_id           = getCvTermId('fly_olympiad_sterility', 'num_flies', NULL))  
               LEFT JOIN session_property rearing_incubator    ON (s.id = rearing_incubator.session_id      AND rearing_incubator.type_id   = getCvTermId('fly_olympiad_sterility', 'rearing_incubator', NULL))
               LEFT JOIN session_property rep                  ON (s.id = rep.session_id                    AND rep.type_id                 = getCvTermId('fly_olympiad_sterility', 'rep', NULL))
               LEFT JOIN session_property total_area           ON (s.id = total_area.session_id             AND total_area.type_id          = getCvTermId('fly_olympiad_sterility', 'total_area', NULL))
               LEFT JOIN session_property total_area_count     ON (s.id = total_area_count.session_id       AND total_area_count.type_id    = getCvTermId('fly_olympiad_sterility', 'total_area_count', NULL))
               LEFT JOIN session_property tube                 ON (s.id = tube.session_id                   AND tube.type_id                = getCvTermId('fly_olympiad_apparatus', 'tube', NULL))
               JOIN score sc                                   ON (s.id = sc.session_id)
               JOIN line l                                     ON (s.line_id = l.id)
               JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
WHERE s.type_id = getCvTermId('fly_olympiad_sterility', 'sterility', NULL)
;
CREATE INDEX olympiad_sterility_sdmv_experiment_id_ind ON tmp_olympiad_sterility_session_data_mv(experiment_id);

-- =================================================== 
-- create temp table combining experiment and session 
-- properties plus scores.
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_sterility_data_mv;
CREATE TABLE tmp_olympiad_sterility_data_mv
SELECT  e.experiment_id, e.experiment_name, s.session_id, s.line_id, s.line_name, s.line_lab, s.session_name,
        s.archived, s.automated_pf, s.avg_size, s.cross_barcode, s.cross_date, s.effector, s.experimenter, e.date_scanned,
        e.exp_datetime, e.experiment_day_of_week, s.file_system_path, s.flag_aborted, e.flag_legacy flag_legacy, s.flag_redo, 
        s.flag_review, s.flip_date, s.flip_used, e.gender, s.genotype, s.handler_cross, s.handler_sorting, e.handling_protocol, 
        s.hit_detection, s.hit_detection_notes, e.humidity, s.manual_pf, s.max_temperature, s.min_temperature, s.notes_technical, 
        s.num_flies, e.protocol, s.rearing_incubator, e.rearing_protocol, s.rep, e.robot_stock_copy, e.room, e.screen_reason, 
        e.screen_type, e.temperature, s.total_area, s.total_area_count, s.tube, e.wish_list,
        s.data_type, 
        s.data, 
        1 AS data_rows, 
        1 AS data_columns, 
        'double' AS data_format
FROM tmp_olympiad_sterility_experiment_data_mv  e
LEFT JOIN tmp_olympiad_sterility_session_data_mv s ON (e.experiment_id = s.experiment_id);
CREATE INDEX olympiad_sterility_edmv_experiment_name_ind ON tmp_olympiad_sterility_data_mv(experiment_name);
CREATE INDEX olympiad_sterility_edmv_line_id_ind ON tmp_olympiad_sterility_data_mv(line_id);
CREATE INDEX olympiad_sterility_edmv_line_name_ind ON tmp_olympiad_sterility_data_mv(line_name);
CREATE INDEX olympiad_sterility_edmv_exp_datetime_ind ON tmp_olympiad_sterility_data_mv(exp_datetime);
CREATE INDEX olympiad_sterility_edmv_automated_pf_ind ON tmp_olympiad_sterility_data_mv(automated_pf);
CREATE INDEX olympiad_sterility_edmv_manual_pf_ind ON tmp_olympiad_sterility_data_mv(manual_pf);
CREATE INDEX olympiad_sterility_edmv_screen_reason_ind ON tmp_olympiad_sterility_data_mv(screen_reason);
CREATE INDEX olympiad_sterility_edmv_screen_type_ind ON tmp_olympiad_sterility_data_mv(screen_type);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_sterility_experiment_data_mv;
RENAME TABLE tmp_olympiad_sterility_data_mv TO olympiad_sterility_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_sterility_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_sterility_session_data_mv;

-- =================================================== 
-- create SAGE REST API view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_sterility_data_vw AS
SELECT  *
FROM olympiad_sterility_experiment_data_mv
;

CREATE OR REPLACE VIEW olympiad_sterility_instance_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.session_name                    AS session
       ,e.experiment_name                 AS experiment
       ,e.effector                        AS effector
       ,e.genotype                        AS genotype
       ,e.rearing_protocol                AS rearing
       ,e.gender                          AS gender
       ,e.experimenter                    AS experimenter
       ,e.data_type                       AS data_type
       ,e.data                            AS data
       ,e.data_rows                       AS data_rows
       ,e.data_columns                    AS data_columns
       ,e.data_format                     AS data_format
FROM olympiad_sterility_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
;
