/* 
    name: olympiad_gap_experiment_data_mv

    mv:   olympiad_gap_experiment_data_mv

    app:  SAGE REST API
    
    note: This script performs the following queries to flatten Gap Crossing Assay data.
          1.  Create a temp table containing experiment properties
          2.  Create a temp table containing session properties and scores.
          3.  Create a temp table combining experiment and session properties plus scores. 
          4.  Create materialized view of combined temp table.
          5.  Create view on materialized view for use by SAGE REST API
    
    This materialized view creates one record for each experiment of Gap Crossing Assay.
    This makes it so that any query is possible against the materialized view without having to do any joins.
*/
-- =================================================== 
-- create temp table containing experiment properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_gap_experiment_data_mv;
CREATE TABLE tmp_olympiad_gap_experiment_data_mv
SELECT e.id AS experiment_id, cast(e.name as char(250)) AS experiment_name, 
       cast(archived.value as char(1)) AS archived, cast(automated_pf.value as char(1)) AS automated_pf, cast(brightness.value as char(50)) AS brightness,
       cast(computer.value as char(50)) AS computer, cast(disk_id.value as char(50)) AS disk_id, cast(duration.value as char(50)) AS duration, 
       cast(experimenter.value as char(50)) AS experimenter, cast(exposure_time.value as char(50)) AS exposure_time, 
       cast(exp_datetime.value as char(50)) AS exp_datetime, dayofweek(cast(exp_datetime.value as datetime)) AS day_of_week, cast(file_system_path.value as char(225)) AS file_system_path,
       cast(flag_aborted.value as char(1)) AS flag_aborted, cast(flag_legacy.value as char(1)) AS flag_legacy, cast(flag_redo.value as char(1)) AS flag_redo, 
       cast(flag_review.value as char(1)) AS flag_review, cast(frame_rate.value as char(50)) AS frame_rate, cast(gain.value as char(50)) AS gain,
       cast(humidity.value as char(50)) AS humidity, cast(location_x.value as decimal(10,4)) AS location_x,  cast(location_y.value as decimal(10,4)) AS location_y,
       cast(manual_pf.value as char(1)) AS manual_pf, cast(notes_behavioral.value as char(225)) AS notes_behavioral, cast(notes_keyword.value as char(225)) AS notes_keyword,
       cast(notes_technical.value as char(225)) AS notes_technical, cast(protocol.value as char(50)) AS protocol, cast(radius.value as decimal(10,4)) AS radius,
       cast(radius_disk1.value as char(50)) AS radius_disk1, cast(radius_disk2.value as char(50)) AS radius_disk2, cast(radius_disk3.value as char(50)) AS radius_disk3,
       cast(radius_disk4.value as char(50)) AS radius_disk4, cast(radius_disk5.value as char(50)) AS radius_disk5, cast(radius_disk6.value as char(50)) AS radius_disk6,
       cast(radius_gap1.value as char(50)) AS radius_gap1, cast(radius_gap2.value as char(50)) AS radius_gap2, cast(radius_gap3.value as char(50)) AS radius_gap3,
       cast(radius_gap4.value as char(50)) AS radius_gap4, cast(radius_gap5.value as char(50)) AS radius_gap5, cast(region.value as char(50)) AS region,
       cast(rig.value as unsigned integer) AS rig, cast(room.value as char(50)) AS room, cast(screen_reason.value as char(225)) AS screen_reason, 
       cast(screen_type.value as char(50)) AS screen_type, cast(temperature.value as unsigned integer) AS temperature, cast(threshold.value as char(50)) AS threshold
FROM experiment e LEFT JOIN experiment_property archived          ON (e.id = archived.experiment_id            AND archived.type_id          = getCvTermId('fly_olympiad_gap', 'archived', NULL))
                  LEFT JOIN experiment_property automated_pf      ON (automated_pf.experiment_id = e.id        AND automated_pf.type_id      = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))
                  LEFT JOIN experiment_property brightness        ON (e.id = brightness.experiment_id          AND brightness.type_id        = getCvTermId('fly_olympiad_gap', 'brightness', NULL))
                  LEFT JOIN experiment_property computer          ON (e.id = computer.experiment_id            AND computer.type_id          = getCvTermId('fly_olympiad_apparatus', 'computer', NULL))
                  LEFT JOIN experiment_property disk_id           ON (e.id = disk_id.experiment_id             AND disk_id.type_id           = getCvTermId('fly_olympiad_apparatus', 'disk_id', NULL))
                  LEFT JOIN experiment_property duration          ON (e.id = duration.experiment_id            AND duration.type_id          = getCvTermId('fly_olympiad_gap', 'duration', NULL))
                  LEFT JOIN experiment_property experimenter      ON (e.id = experimenter.experiment_id        AND experimenter.type_id      = getCvTermId('fly_olympiad_gap', 'experimenter', NULL))
                  LEFT JOIN experiment_property exposure_time     ON (e.id = exposure_time.experiment_id       AND exposure_time.type_id     = getCvTermId('fly_olympiad_gap', 'exposure_time', NULL))
                  LEFT JOIN experiment_property exp_datetime      ON (exp_datetime.experiment_id = e.id        AND exp_datetime.type_id      = getCvTermId('fly_olympiad_gap', 'exp_datetime', NULL))
                  LEFT JOIN experiment_property file_system_path  ON (file_system_path.experiment_id = e.id    AND file_system_path.type_id  = getCvTermId('fly_olympiad_gap', 'file_system_path', NULL))     
                  LEFT JOIN experiment_property flag_aborted      ON (e.id = flag_aborted.experiment_id        AND flag_aborted.type_id      = getCvTermId('fly_olympiad_gap', 'flag_aborted', NULL))
                  LEFT JOIN experiment_property flag_legacy       ON (e.id = flag_legacy.experiment_id         AND flag_legacy.type_id       = getCvTermId('fly_olympiad_gap', 'flag_legacy', NULL))
                  LEFT JOIN experiment_property flag_redo         ON (e.id = flag_redo.experiment_id           AND flag_redo.type_id         = getCvTermId('fly_olympiad_gap', 'flag_redo', NULL))
                  LEFT JOIN experiment_property flag_review       ON (e.id = flag_review.experiment_id         AND flag_review.type_id       = getCvTermId('fly_olympiad_gap', 'flag_review', NULL))
                  LEFT JOIN experiment_property frame_rate        ON (frame_rate.experiment_id = e.id          AND frame_rate.type_id        = getCvTermId('fly_olympiad_gap', 'frame_rate', NULL))     
                  LEFT JOIN experiment_property gain              ON (gain.experiment_id = e.id                AND gain.type_id              = getCvTermId('fly_olympiad_gap', 'gain', NULL))     
                  LEFT JOIN experiment_property humidity          ON (e.id = humidity.experiment_id            AND humidity.type_id          = getCvTermId('fly_olympiad_gap', 'humidity', NULL))
                  LEFT JOIN experiment_property location_x        ON (location_x.experiment_id = e.id          AND location_x.type_id        = getCvTermId('fly_olympiad_apparatus', 'location_x', NULL))
                  LEFT JOIN experiment_property location_y        ON (location_y.experiment_id = e.id          AND location_y.type_id        = getCvTermId('fly_olympiad_apparatus', 'location_y', NULL))     
                  LEFT JOIN experiment_property manual_pf         ON (manual_pf.experiment_id = e.id           AND manual_pf.type_id         = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                  LEFT JOIN experiment_property notes_behavioral  ON (e.id = notes_behavioral.experiment_id    AND notes_behavioral.type_id  = getCvTermId('fly_olympiad_gap', 'notes_behavioral', NULL))
                  LEFT JOIN experiment_property notes_keyword     ON (e.id = notes_keyword.experiment_id       AND notes_keyword.type_id     = getCvTermId('fly_olympiad_gap', 'notes_keyword', NULL))
                  LEFT JOIN experiment_property notes_technical   ON (e.id = notes_technical.experiment_id     AND notes_technical.type_id   = getCvTermId('fly_olympiad_gap', 'notes_technical', NULL))
                  LEFT JOIN experiment_property protocol          ON (protocol.experiment_id = e.id            AND protocol.type_id          = getCvTermId('fly_olympiad_gap', 'protocol', NULL))
                  LEFT JOIN experiment_property radius            ON (radius.experiment_id = e.id              AND radius.type_id            = getCvTermId('fly_olympiad_apparatus', 'radius', NULL))
                  LEFT JOIN experiment_property radius_disk1      ON (radius_disk1.experiment_id = e.id        AND radius_disk1.type_id      = getCvTermId('fly_olympiad_gap', 'radius_disk1', NULL))
                  LEFT JOIN experiment_property radius_disk2      ON (radius_disk2.experiment_id = e.id        AND radius_disk2.type_id      = getCvTermId('fly_olympiad_gap', 'radius_disk2', NULL))
                  LEFT JOIN experiment_property radius_disk3      ON (radius_disk3.experiment_id = e.id        AND radius_disk3.type_id      = getCvTermId('fly_olympiad_gap', 'radius_disk3', NULL))
                  LEFT JOIN experiment_property radius_disk4      ON (radius_disk4.experiment_id = e.id        AND radius_disk4.type_id      = getCvTermId('fly_olympiad_gap', 'radius_disk4', NULL))
                  LEFT JOIN experiment_property radius_disk5      ON (radius_disk5.experiment_id = e.id        AND radius_disk5.type_id      = getCvTermId('fly_olympiad_gap', 'radius_disk5', NULL))
                  LEFT JOIN experiment_property radius_disk6      ON (radius_disk6.experiment_id = e.id        AND radius_disk6.type_id      = getCvTermId('fly_olympiad_gap', 'radius_disk6', NULL))
                  LEFT JOIN experiment_property radius_gap1       ON (radius_gap1.experiment_id = e.id         AND radius_gap1.type_id       = getCvTermId('fly_olympiad_gap', 'radius_gap1', NULL))
                  LEFT JOIN experiment_property radius_gap2       ON (radius_gap2.experiment_id = e.id         AND radius_gap2.type_id       = getCvTermId('fly_olympiad_gap', 'radius_gap2', NULL))
                  LEFT JOIN experiment_property radius_gap3       ON (radius_gap3.experiment_id = e.id         AND radius_gap3.type_id       = getCvTermId('fly_olympiad_gap', 'radius_gap3', NULL))
                  LEFT JOIN experiment_property radius_gap4       ON (radius_gap4.experiment_id = e.id         AND radius_gap4.type_id       = getCvTermId('fly_olympiad_gap', 'radius_gap4', NULL))
                  LEFT JOIN experiment_property radius_gap5       ON (radius_gap5.experiment_id = e.id         AND radius_gap5.type_id       = getCvTermId('fly_olympiad_gap', 'radius_gap5', NULL))
                  LEFT JOIN experiment_property region            ON (region.experiment_id = e.id              AND region.type_id            = getCvTermId('fly_olympiad_gap', 'region', NULL))
                  LEFT JOIN experiment_property rig               ON (rig.experiment_id = e.id                 AND rig.type_id               = getCvTermId('fly_olympiad_apparatus', 'rig', NULL))
                  LEFT JOIN experiment_property room              ON (e.id = room.experiment_id                AND room.type_id              = getCvTermId('fly_olympiad_apparatus', 'room', NULL))
                  LEFT JOIN experiment_property screen_reason     ON (e.id = screen_reason.experiment_id       AND screen_reason.type_id     = getCvTermId('fly_olympiad_gap', 'screen_reason', NULL))
                  LEFT JOIN experiment_property screen_type       ON (e.id = screen_type.experiment_id         AND screen_type.type_id       = getCvTermId('fly_olympiad_gap', 'screen_type', NULL))
                  LEFT JOIN experiment_property temperature       ON (temperature.experiment_id = e.id         AND temperature.type_id       = getCvTermId('fly_olympiad_gap', 'temperature', NULL))
                  LEFT JOIN experiment_property threshold         ON (threshold.experiment_id = e.id           AND threshold.type_id         = getCvTermId('fly_olympiad_gap', 'threshold', NULL))
WHERE e.type_id = getCvTermId('fly_olympiad_gap', 'gap_crossing', NULL);
CREATE INDEX olympiad_gap_edmv_experiment_id_ind ON tmp_olympiad_gap_experiment_data_mv(experiment_id);

-- =================================================== 
-- create temp table containing session properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_gap_session_meta_data_mv;
CREATE TABLE tmp_olympiad_gap_session_meta_data_mv
SELECT e.id AS experiment_id, s.id AS session_id, s.line_id AS line_id, 
       cast(l.name as char(50)) AS line_name, cast(lab_cv.name as char(50)) AS line_lab, cast(s.name as char(250)) AS session_name,
       cast(cross_barcode.value as char(50)) AS cross_barcode, cast(cross_date.value as char(50)) AS cross_date, cast(datetime_sorting.value as char(50)) AS datetime_sorting,
       cast(effector.value as char(50)) AS effector, cast(flip_used.value as char(1)) AS flip_used, cast(gender.value as char(50)) AS gender,
       cast(genotype.value as char(50)) AS genotype, cast(handler_cross.value as char(50)) AS handler_cross, cast(handler_sorting.value as char(50)) as handler_sorting,
       cast(handling_protocol.value as char(50)) AS handling_protocol, cast(hours_starved.value as unsigned integer) AS hours_starved, cast(num_flies.value as char(50)) AS num_flies,
       cast(num_flies_dead.value as char(50)) AS num_flies_dead, cast(rearing_incubator.value as char(3)) AS rearing_incubator, cast(rearing_protocol.value as char(50)) AS rearing_protocol,
       cast(robot_stock_copy.value as char(50)) AS robot_stock_copy, (case when (wish_list.value is not null and wish_list.value != -1) then cast(wish_list.value as char(50)) else cast(guess_wish_list.value as char(50)) end) AS wish_list
FROM experiment e JOIN session s                                  ON (e.id = s.experiment_id)
                  LEFT JOIN session_property cross_barcode        ON (s.id = cross_barcode.session_id          AND cross_barcode.type_id     = getCvTermId('fly_olympiad_gap', 'cross_barcode', NULL))
                  LEFT JOIN session_property cross_date           ON (s.id = cross_date.session_id             AND cross_date.type_id        = getCvTermId('fly_olympiad_gap', 'cross_date', NULL))
                  LEFT JOIN session_property datetime_sorting     ON (s.id = datetime_sorting.session_id       AND datetime_sorting.type_id  = getCvTermId('fly_olympiad_gap', 'datetime_sorting', NULL))
                  LEFT JOIN session_property effector             ON (effector.session_id = s.id               AND effector.type_id          = getCvTermId('fly', 'effector', NULL))
                  LEFT JOIN session_property flip_used            ON (s.id = flip_used.session_id              AND flip_used.type_id         = getCvTermId('fly_olympiad_gap', 'flip_used', NULL))
                  LEFT JOIN session_property gender               ON (gender.session_id = s.id                 AND gender.type_id            = getCvTermId('fly_olympiad_gap', 'gender', NULL))     
                  LEFT JOIN session_property genotype             ON (s.id = genotype.session_id               AND genotype.type_id          = getCvTermId('fly_olympiad_gap', 'genotype', NULL))
                  LEFT JOIN session_property guess_wish_list      ON (guess_wish_list.session_id = s.id        AND guess_wish_list.type_id   = getCvTermId('fly','guess_wish_list',NULL))
                  LEFT JOIN session_property handler_cross        ON (s.id = handler_cross.session_id          AND handler_cross.type_id     = getCvTermId('fly_olympiad_gap', 'handler_cross', NULL))
                  LEFT JOIN session_property handler_sorting      ON (s.id = handler_sorting.session_id        AND handler_sorting.type_id   = getCvTermId('fly_olympiad_gap', 'handler_sorting', NULL))
                  LEFT JOIN session_property handling_protocol    ON (s.id = handling_protocol.session_id      AND handling_protocol.type_id = getCvTermId('fly_olympiad_gap', 'handling_protocol', NULL))
                  LEFT JOIN session_property hours_starved        ON (hours_starved.session_id = s.id          AND hours_starved.type_id     = getCvTermId('fly_olympiad_gap', 'hours_starved', NULL))  
                  LEFT JOIN session_property num_flies            ON (s.id = num_flies.session_id              AND num_flies.type_id         = getCvTermId('fly_olympiad_gap', 'num_flies', NULL))
                  LEFT JOIN session_property num_flies_dead       ON (s.id = num_flies_dead.session_id         AND num_flies_dead.type_id    = getCvTermId('fly_olympiad_gap', 'num_flies', NULL))
                  LEFT JOIN session_property rearing_incubator    ON (s.id = rearing_incubator.session_id      AND rearing_incubator.type_id = getCvTermId('fly_olympiad_gap', 'rearing_incubator', NULL))
                  LEFT JOIN session_property rearing_protocol     ON (s.id = rearing_protocol.session_id       AND rearing_protocol.type_id  = getCvTermId('fly_olympiad_gap', 'rearing_protocol', NULL))
                  LEFT JOIN session_property robot_stock_copy     ON (s.id = robot_stock_copy.session_id       AND robot_stock_copy.type_id  = getCvTermId('fly_olympiad_gap', 'robot_stock_copy', NULL))
                  LEFT JOIN session_property wish_list            ON (wish_list.session_id = s.id              AND wish_list.type_id         = getCvTermId('fly','wish_list',NULL))
                  JOIN line l ON (s.line_id = l.id)
                  JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
WHERE e.type_id = getCvTermId('fly_olympiad_gap', 'gap_crossing', NULL);
CREATE INDEX olympiad_gap_smd_mv_experiment_id_ind ON tmp_olympiad_gap_session_meta_data_mv(experiment_id);


-- =================================================== 
-- create temp table combining experiment and session 
-- properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_gap_data_mv;
CREATE TABLE tmp_olympiad_gap_data_mv
SELECT  e.experiment_id, e.experiment_name, s.session_id, s.line_id, s.line_name, s.line_lab, s.session_name,
        e.archived, e.automated_pf, e.brightness, e.computer, s.cross_barcode, s.cross_date, s.datetime_sorting,
        e.day_of_week, e.disk_id, e.duration, s.effector, e.experimenter, e.exposure_time, e.exp_datetime,
        e.file_system_path, e.flag_aborted, e.flag_legacy, e.flag_redo, e.flag_review, s.flip_used, e.frame_rate,
        e.gain, s.gender, s.genotype, s.handler_cross, s.handler_sorting, s.handling_protocol, s.hours_starved,
        e.humidity, e.location_x, e.location_y, e.manual_pf, e.notes_behavioral, e.notes_keyword, e.notes_technical,
        s.num_flies, s.num_flies_dead, e.protocol, e.radius, e.radius_disk1, e.radius_disk2, e.radius_disk3,
        e.radius_disk4, e.radius_disk5, e.radius_disk6, e.radius_gap1, e.radius_gap2, e.radius_gap3, e.radius_gap4,
        e.radius_gap5, s.rearing_incubator, s.rearing_protocol, e.region, e.rig, s.robot_stock_copy, e.room,
        e.screen_reason, e.screen_type, e.temperature, e.threshold, s.wish_list
FROM tmp_olympiad_gap_experiment_data_mv  e
JOIN tmp_olympiad_gap_session_meta_data_mv s ON (e.experiment_id = s.experiment_id);
CREATE INDEX olympiad_gap_edmv_experiment_id_ind ON tmp_olympiad_gap_data_mv(experiment_id);
CREATE INDEX olympiad_gap_edmv_experiment_name_ind ON tmp_olympiad_gap_data_mv(experiment_name);
CREATE INDEX olympiad_gap_edmv_session_id_ind ON tmp_olympiad_gap_data_mv(session_id);
CREATE INDEX olympiad_gap_edmv_session_name_ind ON tmp_olympiad_gap_data_mv(session_name);
CREATE INDEX olympiad_gap_edmv_line_id_ind ON tmp_olympiad_gap_data_mv(line_id);
CREATE INDEX olympiad_gap_edmv_line_name_ind ON tmp_olympiad_gap_data_mv(line_name);
CREATE INDEX olympiad_gap_edmv_exp_datetime_ind ON tmp_olympiad_gap_data_mv(exp_datetime);
CREATE INDEX olympiad_gap_edmv_automated_pf_ind ON tmp_olympiad_gap_data_mv(automated_pf);
CREATE INDEX olympiad_gap_edmv_manual_pf_ind ON tmp_olympiad_gap_data_mv(manual_pf);
CREATE INDEX olympiad_gap_edmv_screen_reason_ind ON tmp_olympiad_gap_data_mv(screen_reason);
CREATE INDEX olympiad_gap_edmv_screen_type_ind ON tmp_olympiad_gap_data_mv(screen_type);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_gap_experiment_data_mv;
RENAME TABLE tmp_olympiad_gap_data_mv TO olympiad_gap_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_gap_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_gap_session_meta_data_mv;


-- =================================================== 
-- create SAGE REST API view
-- =================================================== 
 
/* 
     olympiad_gap_counts_vw
     
     This view creates one record for each score_array that is associated to a given experiment.
     Additional fields are added for every single piece of metadata that goes with the score.
     This makes it so that any query is possible against the view without having to do any joins.
*/
 
CREATE OR REPLACE VIEW olympiad_gap_counts_vw AS
SELECT STRAIGHT_JOIN e.*,
       getCvTermName(sa.type_id) AS data_type,
       uncompress(sa.value) AS data,
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format
FROM olympiad_gap_experiment_data_mv e
     JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_gap', NULL) AND sa.session_id = e.session_id)
;
 
/* 
     olympiad_gap_counts_vw2
     
     This view creates one record for each score that is associated to a given experiment.
     Additional fields are added for every single piece of metadata that goes with the score.
     This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_gap_counts_vw2 AS
SELECT STRAIGHT_JOIN e.*,
       score_cv.name AS data_type,
       score.value AS data,
       1 AS data_rows, 
       1 AS data_columns, 
       'double' AS data_format
FROM olympiad_gap_experiment_data_mv e
     JOIN score ON (score.session_id = e.session_id)
     JOIN cv_term score_cv ON (score.type_id = score_cv.id)
;

/* 
    olympiad_gap_totals_vw
    
    This view creates one record for each score that is associated to a given experiment.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_gap_totals_vw AS
SELECT e.*,
       'gap_dead_total' AS data_type,
       concat(gap1.value,' ',gap2.value,' ',gap3.value,' ',gap4.value,' ',gap5.value,' ',arena.value) AS data,
       '1' AS data_rows,
       '6' data_columns,
       'uint16' AS data_format
FROM olympiad_gap_experiment_data_mv e
     JOIN score gap1 ON (gap1.session_id = e.session_id)
     JOIN cv_term gap1_cv ON (gap1.type_id = gap1_cv.id and gap1_cv.name = 'gap1_dead_total')
     JOIN score gap2 ON (gap2.session_id = e.session_id)
     JOIN cv_term gap2_cv ON (gap2.type_id = gap2_cv.id and gap2_cv.name = 'gap2_dead_total')
     JOIN score gap3 ON (gap3.session_id = e.session_id)
     JOIN cv_term gap3_cv ON (gap3.type_id = gap3_cv.id and gap3_cv.name = 'gap3_dead_total')
     JOIN score gap4 ON (gap4.session_id = e.session_id)
     JOIN cv_term gap4_cv ON (gap4.type_id = gap4_cv.id and gap4_cv.name = 'gap4_dead_total')
     JOIN score gap5 ON (gap5.session_id = e.session_id)
     JOIN cv_term gap5_cv ON (gap5.type_id = gap5_cv.id and gap5_cv.name = 'gap5_dead_total')
     JOIN score arena ON (arena.session_id = e.session_id)
     JOIN cv_term arena_cv ON (arena.type_id = arena_cv.id and arena_cv.name = 'arena_total')
;
