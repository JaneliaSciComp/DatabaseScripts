/* 
    name: olympiad_aggression_feature_vw,  olympiad_aggression_tracking_vw,  olympiad_aggression_chamber_tracking_vw

    mv:   olympiad_aggression_experiment_data_mv

    app:  SAGE REST API
    
    note: This script performs the following queries to flatten Aggression Assay data.
          1.  Create a temp table containing experiment properties
          2.  Create a temp table containing session properties and scores.
          3.  Create a temp table combining experiment and session properties plus scores. 
          4.  Create materialized view of combined temp table.
          5.  Create view on materialized view for use by SAGE REST API
*/

-- =================================================== 
-- create temp table containing experiment properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_aggression_experiment_data_mv;
CREATE TABLE tmp_olympiad_aggression_experiment_data_mv
SELECT cast(arena.name as char(250)) AS arena_experiment_name, arena.id AS arena_experiment_id,
       cast(chamber.name as char(250)) AS chamber_experiment_name, chamber.id AS chamber_experiment_id, 
       cast(apparatus_id.value as char(50)) AS apparatus_id, cast(arena_num.value as char(50)) AS arena, cast(automated_pf.value as char(1)) AS automated_pf,
       cast(border_width.value as char(50)) AS border_width, cast(camera.value as char(50)) AS camera, cast(chamber_num.value as char(50)) AS chamber, 
       cast(computer.value as char(50)) AS computer, cast(correct_orientation.value as char(50)) AS correct_orientation, cast(correct_positions.value as char(50)) AS correct_positions, 
       cast(courtship_present.value as char(50)) AS courtship_present, dayofweek(cast(exp_datetime.value as char(50))) as day_of_week, 
       cast(dot_present.value as char(50)) AS dot_present, cast(experimenter.value as char(50)) AS experimenter, cast(exp_datetime.value as char(50)) AS exp_datetime, 
       cast(file_system_path.value as char(250)) AS file_system_path, cast(flag_aborted.value as char(1)) AS flag_aborted, cast(flag_legacy.value as char(1)) AS flag_legacy,
       cast(flag_redo.value as char(1)) AS flag_redo, cast(flag_review.value as char(1)) AS flag_review, cast(frame_rate.value as char(50)) AS frame_rate, 
       cast(humidity.value as char(50)) AS humidity, cast(manual_pf.value as char(1)) AS manual_pf, cast(mult_flies_present.value as char(50)) AS mult_flies_present,
       cast(notes_behavioral.value as char(250)) AS notes_behavioral, cast(notes_keyword.value as char(250)) AS notes_keyword, cast(notes_loading.value as char(250)) AS notes_loading,
       cast(notes_technical.value as char(250)) AS notes_technical, cast(number_denoised_frames.value as char(50)) AS number_denoised_frames, cast(num_chambers.value as char(50)) AS num_chambers, 
       cast(num_flies.value as char(50)) AS num_flies, cast(num_unprocessed_movies.value as char(50)) AS num_unprocessed_movies, cast(process_stopped.value as char(50)) AS process_stopped,
       cast(protocol.value as char(50)) AS protocol, cast(radius.value as char(50)) AS radius, cast(radius_plus_border.value as char(50)) AS radius_plus_border,
       cast(room.value as char(50)) AS room, cast(scale_calibration_file.value as char(50)) AS scale_calibration_file, cast(screen_reason.value as char(225)) AS screen_reason,
       cast(screen_type.value as char(50)) AS screen_type, cast(temperature.value as decimal(10,4)) AS temperature, cast(temperature_setpoint.value as decimal(10,4)) AS temperature_setpoint,
       cast(tuning_threshold.value as char(50)) AS tuning_threshold, cast(manual_curator.value as char(50)) AS manual_curator, cast(manual_curation_date.value as char(50)) AS manual_curation_date, 
       cast(notes_curation.value as char(250)) AS notes_curation
FROM experiment arena JOIN experiment_relationship er ON (arena.id = er.object_id)
                      JOIN experiment chamber ON (er.subject_id = chamber.id)
                      LEFT JOIN experiment_property apparatus_id            ON (apparatus_id.experiment_id = arena.id              AND apparatus_id.type_id            = getCvTermId('fly_olympiad', 'apparatus_id', NULL))
                      LEFT JOIN experiment_property arena_num               ON (arena_num.experiment_id = arena.id                 AND arena_num.type_id               = getCvTermId('fly_olympiad_apparatus', 'arena', NULL))
                      LEFT JOIN experiment_property automated_pf            ON (automated_pf.experiment_id = chamber.id            AND automated_pf.type_id            = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))  
                      LEFT JOIN experiment_property border_width            ON (border_width.experiment_id = chamber.id            AND border_width.type_id            = getCvTermId('fly_olympiad_aggression', 'border_width', NULL))
                      LEFT JOIN experiment_property camera                  ON (camera.experiment_id = arena.id                    AND camera.type_id                  = getCvTermId('fly_olympiad_apparatus', 'camera', NULL))
                      LEFT JOIN experiment_property chamber_num             ON (chamber_num.experiment_id = arena.id               AND chamber_num.type_id             = getCvTermId('fly_olympiad_aggression', 'chamber', NULL))
                      LEFT JOIN experiment_property computer                ON (computer.experiment_id = arena.id                  AND computer.type_id                = getCvTermId('fly_olympiad_apparatus', 'computer', NULL))
                      LEFT JOIN experiment_property correct_orientation     ON (correct_orientation.experiment_id = chamber.id     AND correct_orientation.type_id     = getCvTermId('fly_olympiad_aggression', 'correct_orientation', NULL))      
                      LEFT JOIN experiment_property correct_positions       ON (correct_positions.experiment_id = chamber.id       AND correct_positions.type_id       = getCvTermId('fly_olympiad_aggression', 'correct_positions', NULL))      
                      LEFT JOIN experiment_property courtship_present       ON (courtship_present.experiment_id = chamber.id       AND courtship_present.type_id       = getCvTermId('fly_olympiad_aggression', 'courtship_present', NULL))
                      LEFT JOIN experiment_property dot_present             ON (dot_present.experiment_id = chamber.id             AND dot_present.type_id             = getCvTermId('fly_olympiad_aggression', 'dot_present', NULL))
                      LEFT JOIN experiment_property experimenter            ON (experimenter.experiment_id = arena.id              AND experimenter.type_id            = getCvTermId('fly_olympiad_aggression', 'experimenter', NULL))
                      LEFT JOIN experiment_property exp_datetime            ON (exp_datetime.experiment_id = arena.id              AND exp_datetime.type_id            = getCvTermId('fly_olympiad_aggression', 'exp_datetime', NULL))  
                      LEFT JOIN experiment_property file_system_path        ON (file_system_path.experiment_id = chamber.id        AND file_system_path.type_id        = getCvTermId('fly_olympiad_aggression', 'file_system_path', NULL)) 
                      LEFT JOIN experiment_property flag_aborted            ON (flag_aborted.experiment_id = chamber.id            AND flag_aborted.type_id            = getCvTermId('fly_olympiad_aggression', 'flag_aborted', NULL))
                      LEFT JOIN experiment_property flag_legacy             ON (flag_legacy.experiment_id = arena.id               AND flag_legacy.type_id             = getCvTermId('fly_olympiad_aggression', 'flag_legacy', NULL))
                      LEFT JOIN experiment_property flag_redo               ON (flag_redo.experiment_id = arena.id                 AND flag_redo.type_id               = getCvTermId('fly_olympiad_aggression', 'flag_redo', NULL))
                      LEFT JOIN experiment_property flag_review             ON (flag_review.experiment_id = arena.id               AND flag_review.type_id             = getCvTermId('fly_olympiad_aggression', 'flag_review', NULL))
                      LEFT JOIN experiment_property frame_rate              ON (frame_rate.experiment_id = chamber.id              AND frame_rate.type_id              = getCvTermId('fly_olympiad_aggression', 'frame_rate', NULL))
                      LEFT JOIN experiment_property humidity                ON (humidity.experiment_id = arena.id                  AND humidity.type_id                = getCvTermId('fly_olympiad_aggression', 'humidity', NULL))
                      LEFT JOIN experiment_property manual_pf               ON (manual_pf.experiment_id = chamber.id               AND manual_pf.type_id               = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))                        
                      LEFT JOIN experiment_property mult_flies_present      ON (mult_flies_present.experiment_id = chamber.id      AND mult_flies_present.type_id      = getCvTermId('fly_olympiad_aggression', 'mult_flies_present', NULL))      
                      LEFT JOIN experiment_property notes_behavioral        ON (notes_behavioral.experiment_id  = arena.id         AND notes_behavioral.type_id        = getCvTermId('fly_olympiad_aggression', 'notes_behavioral', NULL))
                      LEFT JOIN experiment_property notes_keyword           ON (notes_keyword.experiment_id  = arena.id            AND notes_keyword.type_id           = getCvTermId('fly_olympiad_aggression', 'notes_keyword', NULL))
                      LEFT JOIN experiment_property notes_loading           ON (notes_loading.experiment_id = arena.id             AND notes_loading.type_id           = getCvTermId('fly_olympiad_aggression', 'notes_loading', NULL))
                      LEFT JOIN experiment_property notes_technical         ON (notes_technical.experiment_id = arena.id           AND notes_technical.type_id         = getCvTermId('fly_olympiad_aggression', 'notes_technical', NULL))
                      LEFT JOIN experiment_property number_denoised_frames  ON (number_denoised_frames.experiment_id = chamber.id  AND number_denoised_frames.type_id  = getCvTermId('fly_olympiad_aggression', 'number_denoised_frames', NULL))
                      LEFT JOIN experiment_property num_chambers            ON (num_chambers.experiment_id = chamber.id            AND num_chambers.type_id            = getCvTermId('fly_olympiad_aggression', 'num_chambers', NULL))
                      LEFT JOIN experiment_property num_flies               ON (num_flies.experiment_id = arena.id                 AND num_flies.type_id               = getCvTermId('fly_olympiad_aggression', 'num_flies', NULL))
                      LEFT JOIN experiment_property num_unprocessed_movies  ON (num_unprocessed_movies.experiment_id = chamber.id  AND num_unprocessed_movies.type_id  = getCvTermId('fly_olympiad_aggression', 'num_unprocessed_movies', NULL))      
                      LEFT JOIN experiment_property process_stopped         ON (process_stopped.experiment_id = chamber.id         AND process_stopped.type_id         = getCvTermId('fly_olympiad_aggression', 'process_stopped', NULL))      
                      LEFT JOIN experiment_property protocol                ON (protocol.experiment_id = arena.id                  AND protocol.type_id                = getCvTermId('fly_olympiad_aggression', 'protocol', NULL))
                      LEFT JOIN experiment_property radius                  ON (radius.experiment_id = chamber.id                  AND radius.type_id                  = getCvTermId('fly_olympiad_aggression', 'radius', NULL))
                      LEFT JOIN experiment_property radius_plus_border      ON (radius_plus_border.experiment_id = chamber.id      AND radius_plus_border.type_id      = getCvTermId('fly_olympiad_aggression', 'radius_plus_border', NULL))      
                      LEFT JOIN experiment_property room                    ON (room.experiment_id = arena.id                      AND room.type_id                    = getCvTermId('fly_olympiad_apparatus', 'room', NULL))
                      LEFT JOIN experiment_property scale_calibration_file  ON (scale_calibration_file.experiment_id = chamber.id  AND scale_calibration_file.type_id  = getCvTermId('fly_olympiad_aggression', 'scale_calibration_file', NULL))
                      LEFT JOIN experiment_property screen_reason           ON (screen_reason.experiment_id = arena.id             AND screen_reason.type_id           = getCvTermId('fly_olympiad_aggression', 'screen_reason', NULL))
                      LEFT JOIN experiment_property screen_type             ON (screen_type.experiment_id = arena.id               AND screen_type.type_id             = getCvTermId('fly_olympiad_aggression', 'screen_type', NULL))
                      LEFT JOIN experiment_property temperature             ON (temperature.experiment_id = arena.id               AND temperature.type_id             = getCvTermId('fly_olympiad_aggression', 'temperature', NULL))
                      LEFT JOIN experiment_property temperature_setpoint    ON (temperature_setpoint.experiment_id = arena.id      AND temperature_setpoint.type_id    = getCvTermId('fly_olympiad_aggression', 'temperature_setpoint', NULL))
                      LEFT JOIN experiment_property tuning_threshold        ON (tuning_threshold.experiment_id  = chamber.id       AND tuning_threshold.type_id        = getCvTermId('fly_olympiad_aggression', 'tuning_threshold', NULL))   
                      LEFT JOIN experiment_property manual_curator          ON (manual_curator.experiment_id = chamber.id                AND manual_curator.type_id          = getCvTermId('fly_olympiad_qc', 'manual_curator', NULL))
                      LEFT JOIN experiment_property manual_curation_date    ON (manual_curation_date.experiment_id = chamber.id          AND manual_curation_date.type_id    = getCvTermId('fly_olympiad_qc', 'manual_curation_date', NULL))
                      LEFT JOIN experiment_property notes_curation          ON (chamber.id = notes_curation.experiment_id                AND notes_curation.type_id          = getCvTermId('fly_olympiad_qc', 'notes_curation', NULL))
WHERE arena.type_id = getCvTermId('fly_olympiad_aggression', 'aggression', NULL)
; 
CREATE UNIQUE INDEX olympiad_aggression_edmv_chamber_id_ind ON tmp_olympiad_aggression_experiment_data_mv(chamber_experiment_id);

-- =================================================== 
-- create temp table containing session properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_aggression_session_data_mv;
CREATE TABLE tmp_olympiad_aggression_session_data_mv
SELECT chamber_experiment_id, s.id AS session_id, ses_cvt.name AS session_type, cast(s.name as char(250)) AS session_name, 
       cast(l.name as char(50)) AS line_name, l.id AS line_id, lab_cv.name AS line_lab,
       cast(cross_barcode.value as char(50)) AS cross_barcode, cast(cross_date.value as char(50)) AS cross_date, cast(datetime_sorting.value as char(50)) AS datetime_sorting,
       cast(effector.value as char(50)) AS effector, cast(gender.value as char(50)) AS gender, cast(genotype.value as char(50)) AS genotype,
       cast(handler_cross.value as char(50)) AS handler_cross, cast(handler_sorting.value as char(50)) AS handler_sorting, cast(handling_protocol.value as char(50)) AS handling_protocol,
       cast(hours_sorted.value as char(50)) AS hours_sorted, cast(housing.value as char(50)) AS housing, cast(marking.value as char(50)) AS marking,
       cast(rearing_incubator.value as char(50)) AS rearing_incubator, cast(rearing_protocol.value as char(50)) AS rearing_protocol, cast(rearing_temperature.value as char(50)) AS rearing_temperature,
       cast(robot_stock_copy.value as char(50)) AS robot_stock_copy, cast(wish_list.value as char(50)) AS wish_list
FROM tmp_olympiad_aggression_experiment_data_mv chamber 
                        JOIN session s                                  ON (chamber_experiment_id = s.experiment_id)
                        JOIN cv_term AS ses_cvt                         ON (s.type_id = ses_cvt.id                     AND ses_cvt.name NOT IN ('raw_data_individual', 'raw_data_pair'))
                        JOIN session s2                                 ON (chamber_experiment_id =  s2.experiment_id  AND s2.name LIKE '%fly1' AND s2.type_id = getCvTermId('fly_olympiad_aggression', 'raw_data_individual', NULL))
                        LEFT JOIN session_property cross_barcode        ON (s2.id = cross_barcode.session_id           AND cross_barcode.type_id        = getCvTermId('fly_olympiad_aggression', 'cross_barcode', NULL))  
                        LEFT JOIN session_property cross_date           ON (s2.id = cross_date.session_id              AND cross_date.type_id           = getCvTermId('fly_olympiad_aggression', 'cross_date', NULL))  
                        LEFT JOIN session_property datetime_sorting     ON (s2.id = datetime_sorting.session_id        AND datetime_sorting.type_id     = getCvTermId('fly_olympiad_aggression', 'datetime_sorting', NULL))  
                        LEFT JOIN session_property effector             ON (s2.id = effector.session_id                AND effector.type_id             = getCvTermId('fly_olympiad_aggression', 'effector', NULL))  
                        LEFT JOIN session_property gender               ON (s2.id = gender.session_id                  AND gender.type_id               = getCvTermId('fly_olympiad_aggression', 'gender', NULL))  
                        LEFT JOIN session_property genotype             ON (s2.id = genotype.session_id                AND genotype.type_id             = getCvTermId('fly_olympiad_aggression', 'genotype', NULL))  
                        LEFT JOIN session_property handler_cross        ON (s2.id = handler_cross.session_id           AND handler_cross.type_id        = getCvTermId('fly_olympiad_aggression', 'handler_cross', NULL))  
                        LEFT JOIN session_property handler_sorting      ON (s2.id = handler_sorting.session_id         AND handler_sorting.type_id      = getCvTermId('fly_olympiad_aggression', 'handler_sorting', NULL))  
                        LEFT JOIN session_property handling_protocol    ON (s2.id = handling_protocol.session_id       AND handling_protocol.type_id    = getCvTermId('fly_olympiad_aggression', 'handling_protocol', NULL))  
                        LEFT JOIN session_property hours_sorted         ON (s2.id = hours_sorted.session_id            AND hours_sorted.type_id         = getCvTermId('fly_olympiad_aggression', 'hours_sorted', NULL))  
                        LEFT JOIN session_property housing              ON (s2.id = housing.session_id                 AND housing.type_id              = getCvTermId('fly_olympiad_aggression', 'housing', NULL))  
                        LEFT JOIN session_property marking              ON (s2.id = marking.session_id                 AND marking.type_id              = getCvTermId('fly_olympiad_aggression', 'marking', NULL))  
                        LEFT JOIN session_property rearing_incubator    ON (s2.id = rearing_incubator.session_id       AND rearing_incubator.type_id    = getCvTermId('fly_olympiad_aggression', 'rearing_incubator', NULL))  
                        LEFT JOIN session_property rearing_protocol     ON (s2.id = rearing_protocol.session_id        AND rearing_protocol.type_id     = getCvTermId('fly_olympiad_aggression', 'rearing_protocol', NULL))  
                        LEFT JOIN session_property rearing_temperature  ON (s2.id = rearing_temperature.session_id     AND rearing_temperature.type_id  = getCvTermId('fly_olympiad_aggression', 'rearing_temperature', NULL))  
                        LEFT JOIN session_property robot_stock_copy     ON (s2.id = robot_stock_copy.session_id        AND robot_stock_copy.type_id     = getCvTermId('fly_olympiad_aggression', 'robot_stock_copy', NULL))  
                        LEFT JOIN session_property wish_list            ON (s2.id = wish_list.session_id               AND wish_list.type_id            = getCvTermId('fly_olympiad_aggression', 'wish_list', NULL))  
                        JOIN line l ON (s.line_id = l.id)
                        JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
;
INSERT INTO tmp_olympiad_aggression_session_data_mv
SELECT chamber_experiment_id, s.id AS session_id, ses_cvt.name AS session_type, cast(s.name as char(250)) AS session_name,
       cast(l.name as char(50)) AS line_name, l.id AS line_id, lab_cv.name AS line_lab,
       cast(cross_barcode.value as char(50)) AS cross_barcode, cast(cross_date.value as char(50)) AS cross_date, cast(datetime_sorting.value as char(50)) AS datetime_sorting,
       cast(effector.value as char(50)) AS effector, cast(gender.value as char(50)) AS gender, cast(genotype.value as char(50)) AS genotype,
       cast(handler_cross.value as char(50)) AS handler_cross, cast(handler_sorting.value as char(50)) AS handler_sorting, cast(handling_protocol.value as char(50)) AS handling_protocol,
       cast(hours_sorted.value as char(50)) AS hours_sorted, cast(housing.value as char(50)) AS housing, cast(marking.value as char(50)) AS marking,
       cast(rearing_incubator.value as char(50)) AS rearing_incubator, cast(rearing_protocol.value as char(50)) AS rearing_protocol, cast(rearing_temperature.value as char(50)) AS rearing_temperature,
       cast(robot_stock_copy.value as char(50)) AS robot_stock_copy, cast(wish_list.value as char(50)) AS wish_list
FROM tmp_olympiad_aggression_experiment_data_mv chamber
                        JOIN session s                                  ON (chamber_experiment_id = s.experiment_id)
                        JOIN cv_term AS ses_cvt                         ON (s.type_id = ses_cvt.id                     AND ses_cvt.name IN ('raw_data_individual', 'raw_data_pair'))
                        LEFT JOIN session_property cross_barcode        ON (s.id = cross_barcode.session_id           AND cross_barcode.type_id        = getCvTermId('fly_olympiad_aggression', 'cross_barcode', NULL))
                        LEFT JOIN session_property cross_date           ON (s.id = cross_date.session_id              AND cross_date.type_id           = getCvTermId('fly_olympiad_aggression', 'cross_date', NULL))
                        LEFT JOIN session_property datetime_sorting     ON (s.id = datetime_sorting.session_id        AND datetime_sorting.type_id     = getCvTermId('fly_olympiad_aggression', 'datetime_sorting', NULL))
                        LEFT JOIN session_property effector             ON (s.id = effector.session_id                AND effector.type_id             = getCvTermId('fly_olympiad_aggression', 'effector', NULL))
                        LEFT JOIN session_property gender               ON (s.id = gender.session_id                  AND gender.type_id               = getCvTermId('fly_olympiad_aggression', 'gender', NULL))
                        LEFT JOIN session_property genotype             ON (s.id = genotype.session_id                AND genotype.type_id             = getCvTermId('fly_olympiad_aggression', 'genotype', NULL))
                        LEFT JOIN session_property handler_cross        ON (s.id = handler_cross.session_id           AND handler_cross.type_id        = getCvTermId('fly_olympiad_aggression', 'handler_cross', NULL))
                        LEFT JOIN session_property handler_sorting      ON (s.id = handler_sorting.session_id         AND handler_sorting.type_id      = getCvTermId('fly_olympiad_aggression', 'handler_sorting', NULL))
                        LEFT JOIN session_property handling_protocol    ON (s.id = handling_protocol.session_id       AND handling_protocol.type_id    = getCvTermId('fly_olympiad_aggression', 'handling_protocol', NULL))
                        LEFT JOIN session_property hours_sorted         ON (s.id = hours_sorted.session_id            AND hours_sorted.type_id         = getCvTermId('fly_olympiad_aggression', 'hours_sorted', NULL))
                        LEFT JOIN session_property housing              ON (s.id = housing.session_id                 AND housing.type_id              = getCvTermId('fly_olympiad_aggression', 'housing', NULL))
                        LEFT JOIN session_property marking              ON (s.id = marking.session_id                 AND marking.type_id              = getCvTermId('fly_olympiad_aggression', 'marking', NULL))
                        LEFT JOIN session_property rearing_incubator    ON (s.id = rearing_incubator.session_id       AND rearing_incubator.type_id    = getCvTermId('fly_olympiad_aggression', 'rearing_incubator', NULL))
                        LEFT JOIN session_property rearing_protocol     ON (s.id = rearing_protocol.session_id        AND rearing_protocol.type_id     = getCvTermId('fly_olympiad_aggression', 'rearing_protocol', NULL))
                        LEFT JOIN session_property rearing_temperature  ON (s.id = rearing_temperature.session_id     AND rearing_temperature.type_id  = getCvTermId('fly_olympiad_aggression', 'rearing_temperature', NULL))
                        LEFT JOIN session_property robot_stock_copy     ON (s.id = robot_stock_copy.session_id        AND robot_stock_copy.type_id     = getCvTermId('fly_olympiad_aggression', 'robot_stock_copy', NULL))
                        LEFT JOIN session_property wish_list            ON (s.id = wish_list.session_id               AND wish_list.type_id            = getCvTermId('fly_olympiad_aggression', 'wish_list', NULL))
                        JOIN line l ON (s.line_id = l.id)
                        JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
;
CREATE INDEX olympiad_aggression_sd_mv_chamber_id_ind ON tmp_olympiad_aggression_session_data_mv(chamber_experiment_id);
CREATE UNIQUE INDEX olympiad_aggression_sd_mv_session_id_ind ON tmp_olympiad_aggression_session_data_mv(session_id);

-- =================================================== 
-- create temp table combining experiment and session 
-- properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_aggression_data_mv;
CREATE TABLE tmp_olympiad_aggression_data_mv
SELECT e.arena_experiment_id, e.arena_experiment_name, e.chamber_experiment_id, e.chamber_experiment_name,
       s.line_id, s.line_lab, s.line_name, s.session_type, s.session_type as behavior, s.session_id, s.session_name,
       e.apparatus_id, e.arena, e.automated_pf, e.border_width, e.camera, e.chamber, e.computer, e.correct_orientation,
       e.correct_positions, e.courtship_present, s.cross_barcode, s.cross_date, s.datetime_sorting, e.day_of_week,
       e.dot_present, s.effector, e.exp_datetime, e.experimenter, e.file_system_path, e.flag_aborted, e.flag_legacy,
       e.flag_redo, e.flag_review, e.frame_rate, s.gender, s.genotype, s.handler_cross, s.handler_sorting, s.handling_protocol,
       s.hours_sorted, s.housing, e.humidity, e.manual_pf, e.manual_curator, e.manual_curation_date, s.marking, e.mult_flies_present, 
       e.notes_behavioral, e.notes_curation, e.notes_keyword, e.notes_loading, e.notes_technical, e.number_denoised_frames, e.num_chambers, e.num_flies, 
       e.num_unprocessed_movies, e.process_stopped, e.protocol, e.radius, e.radius_plus_border, s.rearing_incubator, s.rearing_protocol, 
       s.rearing_temperature, s.robot_stock_copy, e.room, e.scale_calibration_file, e.screen_reason, e.screen_type, e.temperature_setpoint, 
       e.temperature, e.tuning_threshold, s.wish_list
FROM tmp_olympiad_aggression_experiment_data_mv  e
JOIN tmp_olympiad_aggression_session_data_mv s ON (e.chamber_experiment_id = s.chamber_experiment_id);
CREATE INDEX olympiad_aggression_edmv_arena_experiment_id_ind ON tmp_olympiad_aggression_data_mv(arena_experiment_id);
CREATE INDEX olympiad_aggression_edmv_arena_experiment_name_ind ON tmp_olympiad_aggression_data_mv(arena_experiment_name);
CREATE INDEX olympiad_aggression_edmv_chamber_experiment_id_ind ON tmp_olympiad_aggression_data_mv(chamber_experiment_id);
CREATE INDEX olympiad_aggression_edmv_chamber_experiment_name_ind ON tmp_olympiad_aggression_data_mv(chamber_experiment_name);
CREATE INDEX olympiad_aggression_edmv_session_id_ind ON tmp_olympiad_aggression_data_mv(session_id);
CREATE INDEX olympiad_aggression_edmv_session_name_ind ON tmp_olympiad_aggression_data_mv(session_name);
CREATE INDEX olympiad_aggression_edmv_session_type_ind ON tmp_olympiad_aggression_data_mv(session_type);
CREATE INDEX olympiad_aggression_edmv_line_id_ind ON tmp_olympiad_aggression_data_mv(line_id);
CREATE INDEX olympiad_aggression_edmv_line_name_ind ON tmp_olympiad_aggression_data_mv(line_name);
CREATE INDEX olympiad_aggression_edmv_exp_datetime_ind ON tmp_olympiad_aggression_data_mv(exp_datetime);
CREATE INDEX olympiad_aggression_edmv_screen_type_ind ON tmp_olympiad_aggression_data_mv(screen_type);
CREATE INDEX olympiad_aggression_edmv_screen_reason_ind ON tmp_olympiad_aggression_data_mv(screen_reason);
CREATE INDEX olympiad_aggression_edmv_automated_pf_ind ON tmp_olympiad_aggression_data_mv(automated_pf);
CREATE INDEX olympiad_aggression_edmv_manual_pf_ind ON tmp_olympiad_aggression_data_mv(manual_pf);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_aggression_experiment_data_mv;
RENAME TABLE tmp_olympiad_aggression_data_mv TO olympiad_aggression_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_aggression_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_aggression_session_data_mv;


-- =================================================== 
-- create SAGE REST API view
-- =================================================== 

/* 
    olympiad_aggression_feature_vw
    
    This view creates one record for each score_array that is associated to a given fly.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_aggression_feature_vw AS
SELECT e.arena_experiment_id, e.arena_experiment_name, e.chamber_experiment_id, e.chamber_experiment_name,
       e.line_id, e.line_lab, e.line_name, e.session_type AS behavior, e.session_id, e.session_name,
       e.apparatus_id, e.arena, e.automated_pf, e.border_width, e.camera, e.chamber, e.computer, e.correct_orientation,
       e.correct_positions, e.courtship_present, e.cross_barcode, e.cross_date, e.datetime_sorting, e.day_of_week,
       e.dot_present, e.effector, e.exp_datetime, e.experimenter, e.file_system_path, e.flag_aborted, e.flag_legacy,
       e.flag_redo, e.flag_review, e.frame_rate, e.gender, e.genotype, e.handler_cross, e.handler_sorting, e.handling_protocol,
       e.hours_sorted, e.housing, e.humidity, e.manual_pf, e.manual_curator, e.manual_curation_date, e.marking, e.mult_flies_present, 
       e.notes_behavioral, e.notes_curation, e.notes_keyword, e.notes_loading, e.notes_technical, e.number_denoised_frames, e.num_chambers, 
       e.num_flies, e.num_unprocessed_movies, e.process_stopped, e.protocol, e.radius, e.radius_plus_border, e.rearing_incubator, 
       e.rearing_protocol, e.rearing_temperature, e.robot_stock_copy, e.room, e.scale_calibration_file, e.screen_reason, e.screen_type, 
       e.temperature_setpoint, e.temperature, e.tuning_threshold, e.wish_list,
       getCvTermName(sa.term_id) AS fly,
       getCvTermName(sa.type_id) AS data_type,
       uncompress(sa.value) AS data,
       sa.row_count AS data_rows,
       sa.column_count AS data_columns,
       sa.data_type AS  data_format
FROM olympiad_aggression_experiment_data_mv e JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_aggression', NULL) AND sa.session_id = e.session_id) 
WHERE e.session_type in ('raw_data_individual', 'raw_data_pair')
;

/* 
    olympiad_aggression_feature_vw2
    
    This view creates one record for each score_array that is associated to a given fly.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_aggression_feature_vw2 AS
SELECT e.arena_experiment_id, e.arena_experiment_name, e.chamber_experiment_id, e.chamber_experiment_name,
       e.line_id, e.line_lab, e.line_name, e.session_type AS behavior, e.session_id, e.session_name,
       e.apparatus_id, e.arena, e.automated_pf, e.border_width, e.camera, e.chamber, e.computer, e.correct_orientation,
       e.correct_positions, e.courtship_present, e.cross_barcode, e.cross_date, e.datetime_sorting, e.day_of_week,
       e.dot_present, e.effector, e.exp_datetime, e.experimenter, e.file_system_path, e.flag_aborted, e.flag_legacy,
       e.flag_redo, e.flag_review, e.frame_rate, e.gender, e.genotype, e.handler_cross, e.handler_sorting, e.handling_protocol,
       e.hours_sorted, e.housing, e.humidity, e.manual_pf, e.manual_curator, e.manual_curation_date, e.marking, e.mult_flies_present, 
       e.notes_behavioral, e.notes_curation, e.notes_keyword,
       e.notes_loading, e.notes_technical, e.number_denoised_frames, e.num_chambers, e.num_flies, e.num_unprocessed_movies,
       e.process_stopped, e.protocol, e.radius, e.radius_plus_border, e.rearing_incubator, e.rearing_protocol, e.rearing_temperature,
       e.robot_stock_copy, e.room, e.scale_calibration_file, e.screen_reason, e.screen_type, e.temperature_setpoint, e.temperature,
       e.tuning_threshold, e.wish_list,
       getCvTermName(score.term_id) AS fly,
       getCvTermName(score.type_id) AS data_type,
       score.value AS data,
       1 AS data_rows,
       1 AS data_columns,
       'double' AS  data_format
FROM olympiad_aggression_experiment_data_mv e JOIN score ON (e.session_id = score.session_id AND score.cv_id = getCvId('fly_olympiad_aggression', NULL))
WHERE e.session_type IN ('raw_data_individual', 'raw_data_pair')
;

/* 
    olympiad_aggression_tracking_vw
    
    This view creates one record for each score_array that is associated to a given fly.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_aggression_tracking_vw AS
SELECT e.arena_experiment_id, e.arena_experiment_name, e.chamber_experiment_id, e.chamber_experiment_name,
       e.line_id, e.line_lab, e.line_name, e.session_type AS behavior, e.session_id, e.session_name,
       e.apparatus_id, e.arena, e.automated_pf, e.border_width, e.camera, e.chamber, e.computer, e.correct_orientation,
       e.correct_positions, e.courtship_present, e.cross_barcode, e.cross_date, e.datetime_sorting, e.day_of_week,
       e.dot_present, e.effector, e.exp_datetime, e.experimenter, e.file_system_path, e.flag_aborted, e.flag_legacy,
       e.flag_redo, e.flag_review, e.frame_rate, e.gender, e.genotype, e.handler_cross, e.handler_sorting, e.handling_protocol,
       e.hours_sorted, e.housing, e.humidity, e.manual_pf, e.manual_curator, e.manual_curation_date, e.marking, e.mult_flies_present, 
       e.notes_behavioral, e.notes_curation, e.notes_keyword,
       e.notes_loading, e.notes_technical, e.number_denoised_frames, e.num_chambers, e.num_flies, e.num_unprocessed_movies,
       e.process_stopped, e.protocol, e.radius, e.radius_plus_border, e.rearing_incubator, e.rearing_protocol, e.rearing_temperature,
       e.robot_stock_copy, e.room, e.scale_calibration_file, e.screen_reason, e.screen_type, e.temperature_setpoint, e.temperature,
       e.tuning_threshold, e.wish_list,
       getCvTermName(sa.term_id) AS fly,
       getCvTermName(sa.type_id) AS data_type,
       sa.row_count AS data_rows,
       sa.column_count AS data_columns,
       sa.data_type AS  data_format,
       uncompress(sa.value) AS data
FROM olympiad_aggression_experiment_data_mv e JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_aggression', NULL) AND sa.session_id = e.session_id)
WHERE e.session_type NOT IN ('raw_data_individual', 'raw_data_pair')
;

/* 
    olympiad_aggression_tracking_vw2
    
    This view creates one record for each score_array that is associated to a given fly.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_aggression_tracking_vw2 AS
SELECT e.arena_experiment_id, e.arena_experiment_name, e.chamber_experiment_id, e.chamber_experiment_name,
       e.line_id, e.line_lab, e.line_name, e.session_type AS behavior, e.session_id, e.session_name,
       e.apparatus_id, e.arena, e.automated_pf, e.border_width, e.camera, e.chamber, e.computer, e.correct_orientation,
       e.correct_positions, e.courtship_present, e.cross_barcode, e.cross_date, e.datetime_sorting, e.day_of_week,
       e.dot_present, e.effector, e.exp_datetime, e.experimenter, e.file_system_path, e.flag_aborted, e.flag_legacy,
       e.flag_redo, e.flag_review, e.frame_rate, e.gender, e.genotype, e.handler_cross, e.handler_sorting, e.handling_protocol,
       e.hours_sorted, e.housing, e.humidity, e.manual_pf, e.manual_curator, e.manual_curation_date, e.marking, e.mult_flies_present, 
       e.notes_behavioral, e.notes_curation, e.notes_keyword,
       e.notes_loading, e.notes_technical, e.number_denoised_frames, e.num_chambers, e.num_flies, e.num_unprocessed_movies,
       e.process_stopped, e.protocol, e.radius, e.radius_plus_border, e.rearing_incubator, e.rearing_protocol, e.rearing_temperature,
       e.robot_stock_copy, e.room, e.scale_calibration_file, e.screen_reason, e.screen_type, e.temperature_setpoint, e.temperature,
       e.tuning_threshold, e.wish_list,
       getCvTermName(score.term_id) AS fly,
       getCvTermName(score.type_id) AS data_type,
       1 AS data_rows,
       1 AS data_columns,
       'double' AS  data_format,
       score.value AS data
FROM olympiad_aggression_experiment_data_mv e JOIN score ON (e.session_id = score.session_id AND score.cv_id = getCvId('fly_olympiad_aggression', NULL))
WHERE e.session_type NOT IN ('raw_data_individual', 'raw_data_pair')
;

/* 
    name: olympiad_aggression_chamber_tracking_data_mv

    app: SAGE API 
    
    note: This materialized view creates one record for each chamber/behavior combo.
*/

DROP TABLE IF EXISTS tmp_olympiad_aggression_chamber_tracking_data_mv;
CREATE TABLE tmp_olympiad_aggression_chamber_tracking_data_mv AS
SELECT s1.arena_experiment_id, s1.arena_experiment_name, s1.chamber_experiment_id, s1.chamber_experiment_name, s1.session_type AS behavior,
       s1.line_id as line_id_fly1, s1.line_lab as line_lab_fly1, s1.line_name as line_name_fly1, s1.session_id as session_id_fly1, s1.session_name as session_name_fly1,
       s2.line_id as line_id_fly2, s2.line_lab as line_lab_fly2, s2.line_name as line_name_fly2, s2.session_id as session_id_fly2, s2.session_name as session_name_fly2,
       s1.apparatus_id, s1.arena, s1.automated_pf, s1.border_width, s1.camera, s1.chamber, s1.computer, s1.correct_orientation,
       s1.correct_positions, s1.courtship_present, s1.cross_barcode, s1.cross_date, s1.datetime_sorting, s1.day_of_week,
       s1.dot_present, s1.effector, s1.exp_datetime, s1.experimenter, s1.file_system_path, s1.flag_aborted, s1.flag_legacy,
       s1.flag_redo, s1.flag_review, s1.frame_rate, s1.gender, s1.genotype, s1.handler_cross, s1.handler_sorting, s1.handling_protocol,
       s1.hours_sorted, s1.housing, s1.humidity, s1.manual_pf, s1.marking, s1.mult_flies_present, s1.notes_behavioral, s1.notes_keyword,
       s1.notes_loading, s1.notes_technical, s1.number_denoised_frames, s1.num_chambers, s1.num_flies, s1.num_unprocessed_movies,
       s1.process_stopped, s1.protocol, s1.radius, s1.radius_plus_border, s1.rearing_incubator, s1.rearing_protocol, s1.rearing_temperature,
       s1.robot_stock_copy, s1.room, s1.scale_calibration_file, s1.screen_reason, s1.screen_type, s1.temperature_setpoint, s1.temperature,
       s1.tuning_threshold, s1.wish_list,
       cast(null as char(250)) as session_id_pair,  cast(null as char(250)) as session_name_pair
FROM olympiad_aggression_experiment_data_mv s1 
JOIN olympiad_aggression_experiment_data_mv s2 ON (s1.chamber_experiment_id = s2.chamber_experiment_id and s1.session_type = s2.session_type and substr(s2.session_name,length(s2.session_name)-3) = 'fly2' and s2.session_type not in ('tussle','copulation'))
WHERE substr(s1.session_name,length(s1.session_name)-3) = 'fly1'
  AND s1.session_type not in ('tussle','copulation')
;
INSERT INTO tmp_olympiad_aggression_chamber_tracking_data_mv
SELECT s1.arena_experiment_id, s1.arena_experiment_name, s1.chamber_experiment_id, s1.chamber_experiment_name, s1.session_type AS behavior,
       s1.line_id as line_id_fly1, s1.line_lab as line_lab_fly1, s1.line_name as line_name_fly1, s1.session_id as session_id_fly1, s1.session_name as session_name_fly1,
       s2.line_id as line_id_fly2, s2.line_lab as line_lab_fly2, s2.line_name as line_name_fly2, s2.session_id as session_id_fly2, s2.session_name as session_name_fly2,
       s1.apparatus_id, s1.arena, s1.automated_pf, s1.border_width, s1.camera, s1.chamber, s1.computer, s1.correct_orientation,
       s1.correct_positions, s1.courtship_present, s1.cross_barcode, s1.cross_date, s1.datetime_sorting, s1.day_of_week,
       s1.dot_present, s1.effector, s1.exp_datetime, s1.experimenter, s1.file_system_path, s1.flag_aborted, s1.flag_legacy,
       s1.flag_redo, s1.flag_review, s1.frame_rate, s1.gender, s1.genotype, s1.handler_cross, s1.handler_sorting, s1.handling_protocol,
       s1.hours_sorted, s1.housing, s1.humidity, s1.manual_pf, s1.marking, s1.mult_flies_present, s1.notes_behavioral, s1.notes_keyword,
       s1.notes_loading, s1.notes_technical, s1.number_denoised_frames, s1.num_chambers, s1.num_flies, s1.num_unprocessed_movies,
       s1.process_stopped, s1.protocol, s1.radius, s1.radius_plus_border, s1.rearing_incubator, s1.rearing_protocol, s1.rearing_temperature,
       s1.robot_stock_copy, s1.room, s1.scale_calibration_file, s1.screen_reason, s1.screen_type, s1.temperature_setpoint, s1.temperature,
       s1.tuning_threshold, s1.wish_list,
       s3.session_id as session_id_pair, s3.session_name as session_name_pair
FROM olympiad_aggression_experiment_data_mv s1 
JOIN olympiad_aggression_experiment_data_mv s2 ON (s1.chamber_experiment_id = s2.chamber_experiment_id and  substr(s2.session_name,length(s2.session_name)-3) = 'fly2' and s2.session_type in ('tussle','copulation') and s1.session_type = s2.session_type)
JOIN olympiad_aggression_experiment_data_mv s3 ON (s1.chamber_experiment_id = s3.chamber_experiment_id and substr(s3.session_name,length(s3.session_name)-8) = 'fly1_fly2' and s3.session_type in ('tussle','copulation')  and s1.session_type = s3.session_type)
WHERE substr(s1.session_name,length(s1.session_name)-3) = 'fly1'
  AND s1.session_type in ('tussle','copulation')
;
CREATE INDEX olympiad_aggression_ctmv_session_id_fly1_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(session_id_fly1);
CREATE INDEX olympiad_aggression_ctmv_session_id_fly2_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(session_id_fly2);
CREATE INDEX olympiad_aggression_ctmv_line_name_fly1_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(line_name_fly1);
CREATE INDEX olympiad_aggression_ctmv_line_name_fly2_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(line_name_fly2);
CREATE INDEX olympiad_aggression_ctmv_session_id_pair_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(session_id_pair);
CREATE INDEX olympiad_aggression_ctmv_chamber_id_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(chamber_experiment_id);
CREATE INDEX olympiad_aggression_ctmv_arena_id_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(arena_experiment_id);
CREATE INDEX olympiad_aggression_ctmv_behavior_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(behavior);
CREATE INDEX olympiad_aggression_ctmv_automated_pf_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(automated_pf);
CREATE INDEX olympiad_aggression_ctmv_manual_pf_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(manual_pf);
CREATE INDEX olympiad_aggression_ctmv_screen_reason_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(screen_reason);
CREATE INDEX olympiad_aggression_ctmv_screen_type_ind ON tmp_olympiad_aggression_chamber_tracking_data_mv(screen_type);

DROP TABLE IF EXISTS olympiad_aggression_chamber_tracking_data_mv;
RENAME TABLE tmp_olympiad_aggression_chamber_tracking_data_mv TO olympiad_aggression_chamber_tracking_data_mv;

/* 
    name: olympiad_aggression_chamber_tracking_vw

    app:  SAGE REST API
    
    note: 
*/

CREATE OR REPLACE VIEW olympiad_aggression_chamber_tracking_vw AS
SELECT STRAIGHT_JOIN
         e.*,
         REPLACE(IFNULL(getCvTermName(sa_fly1.type_id),getCvTermName(sa_fly2.type_id)),'chamber_total','total') AS data_type,
         mergeScoreArrayRows(sa_fly1.id,sa_fly2.id) AS data_rows,
         mergeScoreArrayColumns(sa_fly1.id,sa_fly2.id) AS data_columns,
         mergeScoreArrayFormat(sa_fly1.id,sa_fly2.id) AS data_format,
         mergeScoreArrayValues(sa_fly1.id,sa_fly2.id) AS data
FROM olympiad_aggression_chamber_tracking_data_mv e JOIN score_array as sa_fly1 ON (e.session_id_fly1 = sa_fly1.session_id) JOIN score_array as sa_fly2 ON (sa_fly2.session_id = e.session_id_fly2 and sa_fly1.type_id = sa_fly2.type_id)
WHERE e.behavior not in ('raw_data_individual')
;

/* 
    name: olympiad_aggression_chamber_tracking_vw2

    app:  SAGE REST API
    
    note: 
*/

CREATE OR REPLACE VIEW olympiad_aggression_chamber_tracking_vw2 AS
SELECT STRAIGHT_JOIN
        e.*,
        REPLACE(IFNULL(getCvTermName(sc_fly1.type_id),getCvTermName(sc_fly2.type_id)),'chamber_total','total') AS data_type,
        2 AS data_rows,
        1 AS data_columns,
       'double' AS  data_format,
        concat(lpad(cast(sc_fly1.value as decimal(26,16)),26,' '),'\n',lpad(cast(sc_fly2.value as decimal(26,16)),26,' ')) AS data
FROM olympiad_aggression_chamber_tracking_data_mv e JOIN score sc_fly1 ON (e.session_id_fly1 = sc_fly1.session_id) JOIN score sc_fly2 ON (sc_fly2.session_id = e.session_id_fly2 and sc_fly1.type_id = sc_fly2.type_id)
WHERE e.behavior not in ('raw_data_individual')
;

/* 
    name: olympiad_aggression_chamber_tracking_vw3

    app:  SAGE REST API
    
    note: 
*/

CREATE OR REPLACE VIEW olympiad_aggression_chamber_tracking_vw3 AS
SELECT STRAIGHT_JOIN
        e.*,
         REPLACE(getCvTermName(sa.type_id),'chamber_total','total') AS data_type,
         sa.row_count AS data_rows,
         sa.column_count AS data_columns,
         sa.data_type AS  data_format,
         uncompress(sa.value) AS data
FROM olympiad_aggression_chamber_tracking_data_mv e JOIN score_array sa ON (e.session_id_pair = sa.session_id)
WHERE e.behavior not in ('raw_data_individual')
;

/* 
    name: olympiad_aggression_chamber_tracking_vw4

    app:  SAGE REST API
    
    note: 
*/

CREATE OR REPLACE VIEW olympiad_aggression_chamber_tracking_vw4 AS
SELECT STRAIGHT_JOIN
        e.*,
        REPLACE(getCvTermName(sc.type_id),'chamber_total','total') AS data_type,
        1 AS data_rows,
        1 AS data_columns,
       'double' AS  data_format,
        lpad(cast(sc.value as decimal(26,16)),26,' ') AS data
FROM olympiad_aggression_chamber_tracking_data_mv e JOIN score sc ON (e.session_id_pair = sc.session_id) 
WHERE e.behavior not in ('raw_data_individual')
;
