/* 
    name: olympiad_trikinetics_experiment_data_mv

    mv:   olympiad_trikinetics_experiment_data_mv

    app:  SAGE REST API
    
    note: This script performs the following queries to flatten Trikinetics Assay data.
          1.  Create a temp table containing experiment properties
          2.  Create a temp table containing session properties and scores.
          3.  Create a temp table combining experiment and session properties plus scores. 
          4.  Create materialized view of combined temp table.
          5.  Create view on materialized view for use by SAGE REST API
    
    This materialized view creates one record for each experiment of Trikinetics Assay.
    This makes it so that any query is possible against the materialized view without having to do any joins.
*/
-- =================================================== 
-- create temp table containing experiment properties
-- ===================================================
DROP TABLE IF EXISTS tmp_olympiad_trikinetics_experiment_data_mv;
CREATE TABLE tmp_olympiad_trikinetics_experiment_data_mv
SELECT e.id AS experiment_id, cast(e.name as char(250)) AS experiment_name,
       cast(automated_pf.value as char(1)) AS automated_pf, cast(bin_size.value as char(50)) AS bin_size, cast(exp_datetime.value as char(50)) AS exp_datetime, 
       dayofweek(cast(exp_datetime.value as datetime)) AS day_of_week, cast(file_system_path.value as char(225)) AS file_system_path, cast(incubator.value as char(50)) AS incubator, 
       cast(l_d_cycle.value as char(50)) AS l_d_cycle, cast(manual_pf.value as char(1)) AS manual_pf, cast(monitor.value as char(50)) AS monitor, 
       cast(protocol.value as char(50)) AS protocol, cast(temperature.value as unsigned integer) AS temperature
FROM experiment e LEFT JOIN experiment_property automated_pf         ON (e.id = automated_pf.experiment_id           AND automated_pf.type_id           = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))
                  LEFT JOIN experiment_property bin_size             ON (e.id = bin_size.experiment_id               AND bin_size.type_id               = getCvTermId('fly_olympiad_trikinetics', 'bin_size', NULL))
                  LEFT JOIN experiment_property exp_datetime           ON (e.id = exp_datetime.experiment_id           AND exp_datetime.type_id           = getCvTermId('fly_olympiad_trikinetics', 'exp_datetime', NULL))
                  LEFT JOIN experiment_property file_system_path       ON (e.id = file_system_path.experiment_id       AND file_system_path.type_id       = getCvTermId('fly_olympiad_trikinetics', 'file_system_path', NULL))
                  LEFT JOIN experiment_property incubator              ON (e.id = incubator.experiment_id              AND incubator.type_id              = getCvTermId('fly_olympiad_trikinetics', 'incubator', NULL))
                  LEFT JOIN experiment_property l_d_cycle              ON (e.id = l_d_cycle.experiment_id              AND l_d_cycle.type_id              = getCvTermId('fly_olympiad_trikinetics', 'l_d_cycle', NULL))
                  LEFT JOIN experiment_property manual_pf              ON (e.id = manual_pf.experiment_id              AND manual_pf.type_id              = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                  LEFT JOIN experiment_property monitor                ON (e.id = monitor.experiment_id                AND monitor.type_id                = getCvTermId('fly_olympiad_trikinetics', 'monitor', NULL))
                  LEFT JOIN experiment_property protocol               ON (e.id = protocol.experiment_id               AND protocol.type_id               = getCvTermId('fly_olympiad_trikinetics', 'protocol', NULL))
                  LEFT JOIN experiment_property temperature            ON (e.id = temperature.experiment_id            AND temperature.type_id            = getCvTermId('fly_olympiad_trikinetics', 'temperature', NULL))
                  -- LEFT JOIN experiment_property manual_rating        ON (manual_rating.experiment_id = e.id          AND manual_rating.type_id          = getCvTermId('fly_olympiad_qc', 'manual_rating', NULL))
                  -- LEFT JOIN experiment_property manual_curator       ON (manual_curator.experiment_id = e.id         AND manual_curator.type_id         = getCvTermId('fly_olympiad_qc', 'manual_curator', NULL))
                  -- LEFT JOIN experiment_property manual_curation_date ON (manual_curation_date.experiment_id = e.id   AND manual_curation_date.type_id   = getCvTermId('fly_olympiad_qc', 'manual_curation_date', NULL))
                  -- LEFT JOIN experiment_property notes_curation       ON (e.id = notes_curation.experiment_id         AND notes_curation.type_id         = getCvTermId('fly_olympiad_qc', 'notes_curation', NULL))
WHERE e.type_id = getCvTermId('fly_olympiad_trikinetics', 'trikinetics', NULL);
CREATE INDEX olympiad_trikinetics_edmv_experiment_id_ind ON tmp_olympiad_trikinetics_experiment_data_mv(experiment_id);

-- =================================================== 
-- create temp table containing session properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_trikinetics_session_meta_data_mv;
CREATE TABLE tmp_olympiad_trikinetics_session_meta_data_mv
SELECT e.id AS experiment_id, s.id AS session_id, s.line_id AS line_id, s.type_id AS session_type_id,
       cast(l.name as char(50)) AS line_name, cast(lab_cv.name as char(50)) AS line_lab, cast(s.name as char(250)) AS session_name,
       cast(channel.value as char(50)) AS channel, cast(dead.value as char(50)) AS dead, cast(effector.value as char(50)) AS effector,
       cast(monitor.value as char(50)) AS monitor, cast(num_flies.value as char(50)) AS num_flies, cast(start_date_time.value as char(50)) AS start_date_time
FROM experiment e JOIN session s                             ON (e.id = s.experiment_id)
                  LEFT JOIN session_property channel         ON (s.id = channel.session_id         AND channel.type_id         = getCvTermId('fly_olympiad_trikinetics', 'channel', NULL))
                  LEFT JOIN session_property dead            ON (s.id = dead.session_id            AND dead.type_id            = getCvTermId('fly_olympiad_trikinetics', 'dead', NULL))
                  LEFT JOIN session_property effector        ON (s.id = effector.session_id        AND effector.type_id        = getCvTermId('fly_olympiad_trikinetics', 'effector', NULL))
                  LEFT JOIN session_property monitor         ON (s.id = monitor.session_id         AND monitor.type_id         = getCvTermId('fly_olympiad_trikinetics', 'monitor', NULL))
                  LEFT JOIN session_property num_flies       ON (s.id = num_flies.session_id       AND num_flies.type_id       = getCvTermId('fly_olympiad_trikinetics', 'num_flies', NULL))
                  LEFT JOIN session_property start_date_time ON (s.id = start_date_time.session_id AND start_date_time.type_id = getCvTermId('fly_olympiad_trikinetics', 'start_date_time', NULL))
                  -- LEFT JOIN session_property wish_list       ON (s.id = wish_list.session_id       AND wish_list.type_id       = getCvTermId('fly', 'wish_list', NULL))
                  JOIN line l ON (s.line_id = l.id)
                  JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
WHERE e.type_id = getCvTermId('fly_olympiad_trikinetics', 'trikinetics', NULL);
CREATE INDEX olympiad_trikinetics_smd_mv_experiment_id_ind ON tmp_olympiad_trikinetics_session_meta_data_mv(experiment_id);

-- =================================================== 
-- create temp table combining experiment and session 
-- properties
-- =================================================== 
CREATE TABLE tmp_olympiad_trikinetics_data_mv
SELECT  e.experiment_id, e.experiment_name, s.session_id, s.line_id, s.line_name, s.line_lab, s.session_name, s.session_type_id,
        e.automated_pf, e.bin_size, s.channel, e.day_of_week, s.dead, s.effector, e.monitor AS env_monitor, e.exp_datetime, e.file_system_path, e.incubator,
        e.l_d_cycle, e.manual_pf, s.monitor, s.num_flies, e.protocol, s.start_date_time, e.temperature
FROM tmp_olympiad_trikinetics_experiment_data_mv  e
JOIN tmp_olympiad_trikinetics_session_meta_data_mv s ON (e.experiment_id = s.experiment_id);
CREATE INDEX olympiad_trikinetics_edmv_experiment_id_ind ON tmp_olympiad_trikinetics_data_mv(experiment_id);
CREATE INDEX olympiad_trikinetics_edmv_experiment_name_ind ON tmp_olympiad_trikinetics_data_mv(experiment_name);
CREATE INDEX olympiad_trikinetics_edmv_session_id_ind ON tmp_olympiad_trikinetics_data_mv(session_id);
CREATE INDEX olympiad_trikinetics_edmv_session_type_id_ind ON tmp_olympiad_trikinetics_data_mv(session_type_id);
CREATE INDEX olympiad_trikinetics_edmv_session_name_ind ON tmp_olympiad_trikinetics_data_mv(session_name);
CREATE INDEX olympiad_trikinetics_edmv_line_id_ind ON tmp_olympiad_trikinetics_data_mv(line_id);
CREATE INDEX olympiad_trikinetics_edmv_line_name_ind ON tmp_olympiad_trikinetics_data_mv(line_name);
CREATE INDEX olympiad_trikinetics_edmv_exp_datetime_ind ON tmp_olympiad_trikinetics_data_mv(exp_datetime);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_trikinetics_experiment_data_mv;
RENAME TABLE tmp_olympiad_trikinetics_data_mv TO olympiad_trikinetics_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_trikinetics_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_trikinetics_session_meta_data_mv;

/* 
    olympiad_trikinetics_monitor_vw
	
    This view creates one record for each score array that is produced by the TriKinetics monitors.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_trikinetics_monitor_vw AS
SELECT e.experiment_id, e.experiment_name, e.session_id, e.line_id, e.line_name, e.line_lab, e.session_name, getcvtermname(e.session_type_id) as session_type,
       e.automated_pf, e.bin_size, e.channel, e.day_of_week, if(getcvtermname(e.session_type_id) = 'monitor', NULL, ifnull(e.dead,'no')) AS dead, e.effector, e.env_monitor, e.exp_datetime, e.file_system_path, e.incubator,
       e.l_d_cycle, e.manual_pf, e.monitor, e.protocol, e.start_date_time, e.temperature,
       sa_cv.name AS data_type, 
       replace(uncompress(sa.value),'NA','NaN') AS data, 
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format
FROM olympiad_trikinetics_experiment_data_mv e JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_trikinetics', NULL) AND e.session_id = sa.session_id)
                                               JOIN cv_term sa_cv ON (sa.type_id = sa_cv.id)
WHERE (e.session_type_id = getCvTermId('fly_olympiad_trikinetics', 'monitor', NULL) or e.session_type_id = getCvTermId('fly_olympiad_trikinetics', 'crossings', NULL))
;

/* 
    olympiad_trikinetics_analysis_vw
	
    This view creates one record for each score AND score array that is produced by the TriKinetics analysis.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/
CREATE OR REPLACE VIEW olympiad_trikinetics_analysis_vw AS
SELECT STRAIGHT_JOIN e.experiment_id, e.experiment_name, e.session_id, e.line_id, e.line_name, e.line_lab, e.session_name,
       e.bin_size, e.day_of_week, env_monitor, e.exp_datetime, e.file_system_path, e.incubator,
       e.l_d_cycle, e.manual_pf, e.automated_pf, cast(e.num_flies as unsigned) AS channel_count, e.protocol, e.temperature,
       sa_cv.name AS data_type, 
       replace(uncompress(sa.value),'NA','NaN') AS data, 
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format
FROM olympiad_trikinetics_experiment_data_mv e JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_trikinetics', NULL) AND e.session_id = sa.session_id)
                                               JOIN cv_term sa_cv ON (sa.type_id = sa_cv.id)
WHERE e.session_type_id = getCvTermId('fly_olympiad_trikinetics', 'analysis', NULL)
UNION ALL
SELECT STRAIGHT_JOIN e.experiment_id, e.experiment_name, e.session_id, e.line_id, e.line_name, e.line_lab, e.session_name,
       e.bin_size, e.day_of_week, env_monitor, e.exp_datetime, e.file_system_path, e.incubator,
       e.l_d_cycle, e.manual_pf, e.automated_pf, cast(e.num_flies as unsigned) AS channel_count, e.protocol, e.temperature,
       score_cv.name AS data_type, 
       score.value AS data, 
       1 AS data_rows, 
       1 AS data_columns, 
       'double' AS data_format
FROM olympiad_trikinetics_experiment_data_mv e JOIN score ON (e.session_id = score.session_id)
                                               JOIN cv_term score_cv ON (score.type_id = score_cv.id)
WHERE e.session_type_id = getCvTermId('fly_olympiad_trikinetics', 'analysis', NULL)
;
