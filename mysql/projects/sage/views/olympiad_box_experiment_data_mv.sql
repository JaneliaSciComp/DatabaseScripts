/* 
    name: olympiad_box_analysis_info_vw, olympiad_box_analysis_results_vw, olympiad_box_environmental_vw

    mv:   olympiad_box_experiment_data_mv, olympiad_box_environmental_mv

    app:  SAGE REST API
    
    note: This script performs the following queries to flatten Box Assay data.
          1.  Create a temp table containing experiment properties
          2.  Create a temp table containing session properties and scores.
          3.  Create a temp table combining experiment and session properties plus scores. 
          4.  Create materialized view of combined temp table.
          5.  Create view on materialized view for use by SAGE REST API
    
    This materialized view creates one record for each experiment of Box Assay.
    This makes it so that any query is possible against the materialized view without having to do any JOINs.
*/
-- =================================================== 
-- create experiment properties temp table
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_box_experiment_data_mv;
CREATE TABLE tmp_olympiad_box_experiment_data_mv
SELECT e.id AS experiment_id, cast(e.name as char(250)) AS experiment_name,
       cast(apparatus_id.value as char(50)) AS apparatus_id, cast(archived.value as char(50)) AS archived, cast(automated_pf.value as char(1)) AS automated_pf, 
       cast(behave_issue.value as char(50)) AS behave_issue, cast(box.value as char(50)) AS box, cast(calibratezz.value as char(50)) AS calibratezz,
       cast(computer.value as char(50)) AS computer, cast(cool_max_var.value as char(50)) AS cool_max_var, cast(errorcode.value as char(250)) AS errorcode, 
       dayofweek(cast(exp_datetime.value as datetime)) AS day_of_week, cast(experimenter.value as char(50)) AS experimenter, cast(experiment_reprocessed.value as char(50)) AS experiment_reprocessed, 
       cast(exp_datetime.value as char(50)) AS exp_datetime, cast(failed_stage.value as char(50)) AS failed_stage, cast(left(failure.value,10) as unsigned integer) AS failure, 
       cast(file_system_path.value as char(250)) AS file_system_path, cast(flag_aborted.value as char(1)) AS flag_aborted, cast(flag_legacy.value as char(1)) AS flag_legacy, 
       cast(flag_redo.value as char(1)) AS flag_redo, cast(flag_review.value as char(1)) AS flag_review, cast(force_seq_start.value as char(1)) AS force_seq_start, 
       cast(hot_max_var.value as char(50)) AS hot_max_var, cast(humidity.value as char(50)) AS humidity, cast(i2cHang.value as char(50)) AS i2cHang, cast(issue_behavioral.value as char(50)) AS issue_behavioral,
       cast(issue_technical.value as char(50)) AS issue_technical, cast(live_notes.value as char(250)) AS live_notes, cast(loadmetadata_error_message.value as char(250)) AS loadmetadata_error_message,
       cast(manual_curator.value as char(50)) AS manual_curator, cast(manual_curation_date.value as char(50)) AS manual_curation_date, cast(manual_pf.value as char(1)) AS manual_pf, 
       cast(manual_rating.value as char(50)) AS manual_rating, cast(max_vibration.value as char(50)) AS max_vibration, cast(notes_behavioral.value as char(250)) AS notes_behavioral, 
       cast(notes_curation.value as char(250)) AS notes_curation, cast(notes_keyword.value as char(250)) AS notes_keyword, cast(notes_technical.value as char(250)) AS notes_technical, 
       cast(protocol.value as char(50)) AS experiment_protocol, cast(resolution.value as char(50)) AS resolution, cast(room.value as char(50)) AS room, cast(screen_reason.value as char(50)) AS screen_reason,
       cast(screen_type.value as char(50)) AS screen_type, cast(tech_issue.value as char(50)) AS tech_issue, cast(temperature.value as decimal(10,4)) AS temperature,
       cast(left(total_duration_seconds.value,10) as unsigned) AS total_duration_seconds, cast(transition_duration.value as char(50)) AS transition_duration, cast(wish_list.value as char(50)) AS wish_list,
       cast(zzcal_offset.value as char(50)) AS zzcal_offset 
  FROM experiment e LEFT JOIN experiment_property apparatus_id               ON (e.id = apparatus_id.experiment_id               AND apparatus_id.type_id               = getCvTermId('fly_olympiad_box', 'apparatus_id', NULL))
                    LEFT JOIN experiment_property archived                   ON (e.id = archived.experiment_id                   AND archived.type_id                   = getCvTermId('fly_olympiad_box', 'archived', NULL))
                    LEFT JOIN experiment_property automated_pf               ON (e.id = automated_pf.experiment_id               AND automated_pf.type_id               = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))
                    LEFT JOIN experiment_property behave_issue               ON (e.id = behave_issue.experiment_id               AND behave_issue.type_id               = getCvTermId('fly_olympiad_box', 'behave_issue', NULL))
                    LEFT JOIN experiment_property box                        ON (e.id = box.experiment_id                        AND box.type_id                        = getCvTermId('fly_olympiad_apparatus', 'box', NULL))
                    LEFT JOIN experiment_property calibratezz                ON (e.id = calibratezz.experiment_id                AND calibratezz.type_id                = getCvTermId('fly_olympiad_box', 'calibratezz', NULL))
                    LEFT JOIN experiment_property computer                   ON (e.id = computer.experiment_id                   AND computer.type_id                   = getCvTermId('fly_olympiad_apparatus', 'computer', NULL))
                    LEFT JOIN experiment_property cool_max_var               ON (e.id = cool_max_var.experiment_id               AND cool_max_var.type_id               = getCvTermId('fly_olympiad_box', 'cool_max_var', NULL))
                    LEFT JOIN experiment_property errorcode                  ON (e.id = errorcode.experiment_id                  AND errorcode.type_id                  = getCvTermId('fly_olympiad_box', 'errorcode', NULL))
                    LEFT JOIN experiment_property experimenter               ON (e.id = experimenter.experiment_id               AND experimenter.type_id               = getCvTermId('fly_olympiad_box', 'experimenter', NULL))
                    LEFT JOIN experiment_property experiment_reprocessed     ON (e.id = experiment_reprocessed.experiment_id     AND experiment_reprocessed.type_id     = getCvTermId('fly_olympiad_qc_box', 'experiment_reprocessed', NULL))
                    LEFT JOIN experiment_property exp_datetime               ON (e.id = exp_datetime.experiment_id               AND exp_datetime.type_id               = getCvTermId('fly_olympiad_box', 'exp_datetime', NULL))
                    LEFT JOIN experiment_property failed_stage               ON (e.id = failed_stage.experiment_id               AND failed_stage.type_id               = getCvTermId('fly_olympiad_qc_box', 'failed_stage', NULL))
                    LEFT JOIN experiment_property failure                    ON (e.id = failure.experiment_id                    AND failure.type_id                    = getCvTermId('fly_olympiad_box', 'failure', NULL))
                    LEFT JOIN experiment_property file_system_path           ON (e.id = file_system_path.experiment_id           AND file_system_path.type_id           = getCvTermId('fly_olympiad_box', 'file_system_path', NULL))
                    LEFT JOIN experiment_property flag_aborted               ON (e.id = flag_aborted.experiment_id               AND flag_aborted.type_id               = getCvTermId('fly_olympiad_box', 'flag_aborted', NULL))
                    LEFT JOIN experiment_property flag_legacy                ON (e.id = flag_legacy.experiment_id                AND flag_legacy.type_id                = getCvTermId('fly_olympiad_box', 'flag_legacy', NULL))
                    LEFT JOIN experiment_property flag_redo                  ON (e.id = flag_redo.experiment_id                  AND flag_redo.type_id                  = getCvTermId('fly_olympiad_box', 'flag_redo', NULL))
                    LEFT JOIN experiment_property flag_review                ON (e.id = flag_review.experiment_id                AND flag_review.type_id                = getCvTermId('fly_olympiad_box', 'flag_review', NULL))
                    LEFT JOIN experiment_property force_seq_start            ON (e.id = force_seq_start.experiment_id            AND force_seq_start.type_id            = getCvTermId('fly_olympiad_box', 'force_seq_start', NULL))
                    LEFT JOIN experiment_property hot_max_var                ON (e.id = hot_max_var.experiment_id                AND hot_max_var.type_id                = getCvTermId('fly_olympiad_box', 'hot_max_var', NULL))
                    LEFT JOIN experiment_property humidity                   ON (e.id = humidity.experiment_id                   AND humidity.type_id                   = getCvTermId('fly_olympiad_box', 'humidity', NULL))
                    LEFT JOIN experiment_property i2cHang                    ON (e.id = i2cHang.experiment_id                    AND i2cHang.type_id                    = getCvTermId('fly_olympiad_box', 'i2cHang', NULL))
                    LEFT JOIN experiment_property issue_behavioral           ON (e.id = issue_behavioral.experiment_id           AND issue_behavioral.type_id           = getCvTermId('fly_olympiad_box', 'issue_behavioral', NULL))
                    LEFT JOIN experiment_property issue_technical            ON (e.id = issue_technical.experiment_id            AND issue_technical.type_id            = getCvTermId('fly_olympiad_box', 'issue_technical', NULL))
                    LEFT JOIN experiment_property live_notes                 ON (e.id = live_notes.experiment_id                 AND live_notes.type_id                 = getCvTermId('fly_olympiad_box', 'live_notes', NULL))
                    LEFT JOIN experiment_property loadmetadata_error_message ON (e.id = loadmetadata_error_message.experiment_id AND loadmetadata_error_message.type_id = getCvTermId('fly_olympiad_qc_box', 'loadmetadata_error_message', NULL))
                    LEFT JOIN experiment_property manual_curator             ON (manual_curator.experiment_id = e.id             AND manual_curator.type_id             = getCvTermId('fly_olympiad_qc', 'manual_curator', NULL))
                    LEFT JOIN experiment_property manual_curation_date       ON (manual_curation_date.experiment_id = e.id       AND manual_curation_date.type_id       = getCvTermId('fly_olympiad_qc', 'manual_curation_date', NULL))
                    LEFT JOIN experiment_property manual_pf                  ON (e.id = manual_pf.experiment_id                  AND manual_pf.type_id                  = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                    LEFT JOIN experiment_property manual_rating              ON (manual_rating.experiment_id = e.id              AND manual_rating.type_id              = getCvTermId('fly_olympiad_qc', 'manual_rating', NULL))
                    LEFT JOIN experiment_property max_vibration              ON (e.id = max_vibration.experiment_id              AND max_vibration.type_id              = getCvTermId('fly_olympiad_box', 'max_vibration', NULL))
                    LEFT JOIN experiment_property notes_behavioral           ON (e.id = notes_behavioral.experiment_id           AND notes_behavioral.type_id           = getCvTermId('fly_olympiad_box', 'notes_behavioral', NULL))
                    LEFT JOIN experiment_property notes_curation             ON (e.id = notes_curation.experiment_id             AND notes_curation.type_id             = getCvTermId('fly_olympiad_qc', 'notes_curation', NULL))
                    LEFT JOIN experiment_property notes_keyword              ON (e.id = notes_keyword.experiment_id              AND notes_keyword.type_id              = getCvTermId('fly_olympiad_box', 'notes_keyword', NULL))
                    LEFT JOIN experiment_property notes_technical            ON (e.id = notes_technical.experiment_id            AND notes_technical.type_id            = getCvTermId('fly_olympiad_box', 'notes_technical', NULL))
                    LEFT JOIN experiment_property protocol                   ON (e.id = protocol.experiment_id                   AND protocol.type_id                   = getCvTermId('fly_olympiad_box', 'protocol', NULL))
                    LEFT JOIN experiment_property resolution                 ON (e.id = resolution.experiment_id                 AND resolution.type_id                 = getCvTermId('fly_olympiad_box', 'resolution', NULL))
                    LEFT JOIN experiment_property room                       ON (e.id = room.experiment_id                       AND room.type_id                       = getCvTermId('fly_olympiad_apparatus', 'room', NULL))
                    LEFT JOIN experiment_property screen_reason              ON (e.id = screen_reason.experiment_id              AND screen_reason.type_id              = getCvTermId('fly_olympiad_box', 'screen_reason', NULL))
                    LEFT JOIN experiment_property screen_type                ON (e.id = screen_type.experiment_id                AND screen_type.type_id                = getCvTermId('fly_olympiad_box', 'screen_type', NULL))
                    LEFT JOIN experiment_property tech_issue                 ON (e.id = tech_issue.experiment_id                 AND tech_issue.type_id                 = getCvTermId('fly_olympiad_box', 'tech_issue', NULL))
                    LEFT JOIN experiment_property temperature                ON (e.id = temperature.experiment_id                AND temperature.type_id                = getCvTermId('fly_olympiad_box', 'temperature', NULL))
                    LEFT JOIN experiment_property total_duration_seconds     ON (e.id = total_duration_seconds.experiment_id     AND total_duration_seconds.type_id     = getCvTermId('fly_olympiad_box', 'total_duration_seconds', NULL))
                    LEFT JOIN experiment_property transition_duration        ON (e.id = transition_duration.experiment_id        AND transition_duration.type_id        = getCvTermId('fly_olympiad_box', 'transition_duration', NULL))
                    LEFT JOIN experiment_property wish_list                  ON (e.id = wish_list.experiment_id                  AND wish_list.type_id                  = getCvTermId('fly_olympiad_box', 'wish_list', NULL))
                    LEFT JOIN experiment_property zzcal_offset               ON (e.id = zzcal_offset.experiment_id               AND zzcal_offset.type_id               = getCvTermId('fly_olympiad_box', 'zzcal_offset', NULL))
WHERE e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL);

CREATE INDEX olympiad_box_edmv_experiment_id_ind ON tmp_olympiad_box_experiment_data_mv(experiment_id);

-- =================================================== 
-- create region session properties temp table
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_box_region_meta_data_mv;
CREATE TABLE tmp_olympiad_box_region_meta_data_mv
SELECT e.experiment_id, s.id AS session_id, cast(s.name as char(250)) as session_name, ses_cvt.name AS session_type, s.line_id AS line_id, cast(l.name as char(50)) AS line_name, lab_cv.name AS line_lab,
       cast(cross_date.value as char(50)) AS cross_date, cast(cross_barcode.value as char(50)) AS cross_barcode, cast(dob.value as char(50)) AS dob,
       cast(effector.value as char(50)) AS effector, cast(flip_date.value as char(50)) AS flip_date, cast(flip_used.value as char(50)) AS flip_used, 
       cast(gender.value as char(1)) AS gender, cast(genotype.value as char(50)) AS genotype, cast(handler_cross.value as char(50)) AS handler_cross,
       cast(handler_sorting.value  as char(50)) AS handler_sorting, cast(handler_starvation.value as char(50)) AS handler_starvation, cast(handling_protocol.value as char(50)) AS handling_protocol, 
       cast(left(hours_sorted.value,10) as signed) AS hours_sorted, cast(hours_starved.value as char(50)) AS hours_starved, cast(manual_pf.value as char(1)) AS manual_pf, cast(left(num_flies.value,10) as signed) AS num_flies, 
       cast(left(num_flies_dead.value,10) as signed) AS num_flies_dead, cast(rearing_incubator.value as char(50)) AS rearing_incubator, cast(rearing_protocol.value as char(50)) AS rearing_protocol,
       cast(left(region.value,10) as unsigned) AS region, cast(robot_stock_copy.value as char(50)) AS robot_stock_copy, cast(left(sequence.value,10) as unsigned) AS sequence,
       cast(temperature.value as decimal(10,4)) AS temperature_setpoint, (case when ses_cvt.name = 'region' then cast(left(s.name,10) as unsigned) else NULL end) AS tube, cast(version.value as char(50)) AS version,
       (case when (wish_list.value is not null and wish_list.value != -1) then cast(wish_list.value as char(50)) else cast(guess_wish_list.value as char(50)) end) AS wish_list
  FROM tmp_olympiad_box_experiment_data_mv e 
                    JOIN session s                                ON (e.experiment_id = s.experiment_id) 
                    JOIN cv_term AS ses_cvt                       ON (s.type_id = ses_cvt.id)
                    LEFT JOIN session_property cross_barcode      ON (s.id = cross_barcode.session_id      AND cross_barcode.type_id      = getCvTermId('fly_olympiad_box', 'cross_barcode', NULL))
                    LEFT JOIN session_property cross_date         ON (s.id = cross_date.session_id         AND cross_date.type_id         = getCvTermId('fly_olympiad_box', 'cross_date', NULL))
                    LEFT JOIN session_property dob                ON (s.id = dob.session_id                AND dob.type_id                = getCvTermId('fly_olympiad_box', 'dob', NULL))
                    LEFT JOIN session_property effector           ON (s.id = effector.session_id           AND effector.type_id           = getCvTermId('fly_olympiad_box', 'effector', NULL))
                    LEFT JOIN session_property flip_date          ON (s.id = flip_date.session_id          AND flip_date.type_id          = getCvTermId('fly_olympiad_box', 'flip_date', NULL))
                    LEFT JOIN session_property flip_used          ON (s.id = flip_used.session_id          AND flip_used.type_id          = getCvTermId('fly_olympiad_box', 'flip_used', NULL))
                    LEFT JOIN session_property gender             ON (s.id = gender.session_id             AND gender.type_id             = getCvTermId('fly_olympiad_box', 'gender', NULL))
                    LEFT JOIN session_property genotype           ON (s.id = genotype.session_id           AND genotype.type_id           = getCvTermId('fly_olympiad_box', 'genotype', NULL))
                    LEFT JOIN session_property guess_wish_list    ON (s.id = guess_wish_list.session_id    AND guess_wish_list.type_id    = getCvTermId('fly_olympiad_box', 'guess_wish_list', NULL))
                    LEFT JOIN session_property handler_cross      ON (s.id = handler_cross.session_id      AND handler_cross.type_id      = getCvTermId('fly_olympiad_box', 'handler_cross', NULL))
                    LEFT JOIN session_property handler_sorting    ON (s.id = handler_sorting.session_id    AND handler_sorting.type_id    = getCvTermId('fly_olympiad_box', 'handler_sorting', NULL))
                    LEFT JOIN session_property handler_starvation ON (s.id = handler_starvation.session_id AND handler_starvation.type_id = getCvTermId('fly_olympiad_box', 'handler_starvation', NULL))
                    LEFT JOIN session_property handling_protocol  ON (s.id = handling_protocol.session_id  AND handling_protocol.type_id  = getCvTermId('fly_olympiad_box', 'handling_protocol', NULL))
                    LEFT JOIN session_property hours_sorted       ON (s.id = hours_sorted.session_id       AND hours_sorted.type_id       = getCvTermId('fly_olympiad_box', 'hours_sorted', NULL))
                    LEFT JOIN session_property hours_starved      ON (s.id = hours_starved.session_id      AND hours_starved.type_id      = getCvTermId('fly_olympiad_box', 'hours_starved', NULL))
                    LEFT JOIN session_property manual_pf          ON (s.id = manual_pf.session_id          AND manual_pf.type_id          = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                    LEFT JOIN session_property num_flies          ON (s.id = num_flies.session_id          AND num_flies.type_id          = getCvTermId('fly_olympiad_box', 'num_flies', NULL))
                    LEFT JOIN session_property num_flies_dead     ON (s.id = num_flies_dead.session_id     AND num_flies_dead.type_id     = getCvTermId('fly_olympiad_box', 'num_flies_dead', NULL))
                    LEFT JOIN session_property rearing_incubator  ON (s.id = rearing_incubator.session_id  AND rearing_incubator.type_id  = getCvTermId('fly_olympiad_box', 'rearing_incubator', NULL))
                    LEFT JOIN session_property rearing_protocol   ON (s.id = rearing_protocol.session_id   AND rearing_protocol.type_id   = getCvTermId('fly_olympiad_box', 'rearing_protocol', NULL))
                    LEFT JOIN session_property region             ON (s.id = region.session_id             AND region.type_id             = getCvTermId('fly_olympiad_box', 'region', NULL))
                    LEFT JOIN session_property robot_stock_copy   ON (s.id = robot_stock_copy.session_id   AND robot_stock_copy.type_id   = getCvTermId('fly_olympiad_box', 'robot_stock_copy', NULL))
                    LEFT JOIN session_property sequence           ON (s.id = sequence.session_id           AND sequence.type_id           = getCvTermId('fly_olympiad_box', 'sequence', NULL))
                    LEFT JOIN session_property temperature        ON (s.id = temperature.session_id        AND temperature.type_id        = getCvTermId('fly_olympiad_box', 'temperature', NULL))
                    LEFT JOIN session_property version            ON (s.id = version.session_id            AND version.type_id            = getCvTermId('fly_olympiad_box', 'version', NULL))
                    LEFT JOIN session_property wish_list          ON (s.id = wish_list.session_id          AND wish_list.type_id          = getCvTermId('fly_olympiad_box', 'wish_list', NULL))
                    JOIN line l                                   ON (s.line_id = l.id)
                    JOIN cv_term lab_cv                           ON (l.lab_id = lab_cv.id)
WHERE s.type_id =  getCvTermId('fly_olympiad_box', 'region', NULL);

CREATE INDEX olympiad_box_rmd_mv_experiment_id_ind ON tmp_olympiad_box_region_meta_data_mv(experiment_id);
CREATE INDEX olympiad_box_rmd_mv_session_id_ind ON tmp_olympiad_box_region_meta_data_mv(session_id);

-- ===================================================
-- create tracking session properties temp table
-- ===================================================
DROP TABLE IF EXISTS tmp_olympiad_box_tracking_meta_data_mv;
CREATE TABLE tmp_olympiad_box_tracking_meta_data_mv
SELECT e.experiment_id, s.id AS session_id, cast(s.name as char(250)) as session_name, ses_cvt.name AS session_type,
       cast(left(region.value,10) as unsigned) AS region, cast(left(sequence.value,10) as unsigned) AS sequence,
       cast(temperature.value as decimal(10,4)) AS temperature_setpoint, cast(version.value as char(50)) AS version
  FROM tmp_olympiad_box_experiment_data_mv e
                    JOIN session s                                ON (e.experiment_id = s.experiment_id)
                    JOIN cv_term AS ses_cvt                       ON (s.type_id = ses_cvt.id)
                    LEFT JOIN session_property region             ON (s.id = region.session_id             AND region.type_id             = getCvTermId('fly_olympiad_box', 'region', NULL))
                    LEFT JOIN session_property sequence           ON (s.id = sequence.session_id           AND sequence.type_id           = getCvTermId('fly_olympiad_box', 'sequence', NULL))
                    LEFT JOIN session_property temperature        ON (s.id = temperature.session_id        AND temperature.type_id        = getCvTermId('fly_olympiad_box', 'temperature_setpoint', NULL))
                    LEFT JOIN session_property version            ON (s.id = version.session_id            AND version.type_id            = getCvTermId('fly_olympiad_box', 'version', NULL))
WHERE s.type_id =  getCvTermId('fly_olympiad_box', 'tracking', NULL);

CREATE INDEX olympiad_box_tmd_mv_session_id_ind ON tmp_olympiad_box_tracking_meta_data_mv(session_id);

-- ===================================================
-- create analysis session properties temp table
-- ===================================================
DROP TABLE IF EXISTS tmp_olympiad_box_analysis_meta_data_mv;
CREATE TABLE tmp_olympiad_box_analysis_meta_data_mv
SELECT e.experiment_id, s.id AS session_id, cast(s.name as char(250)) as session_name, ses_cvt.name AS session_type,
       cast(left(region.value,10) as unsigned) AS region, cast(left(sequence.value,10) as unsigned) AS sequence,
       cast(temperature.value as decimal(10,4)) AS temperature_setpoint, cast(version.value as char(50)) AS version
  FROM tmp_olympiad_box_experiment_data_mv e
                    JOIN session s                                ON (e.experiment_id = s.experiment_id)
                    JOIN cv_term AS ses_cvt                       ON (s.type_id = ses_cvt.id)
                    LEFT JOIN session_property region             ON (s.id = region.session_id             AND region.type_id             = getCvTermId('fly_olympiad_box', 'region', NULL))
                    LEFT JOIN session_property sequence           ON (s.id = sequence.session_id           AND sequence.type_id           = getCvTermId('fly_olympiad_box', 'sequence', NULL))
                    LEFT JOIN session_property temperature        ON (s.id = temperature.session_id        AND temperature.type_id        = getCvTermId('fly_olympiad_box', 'temperature_setpoint', NULL))
                    LEFT JOIN session_property version            ON (s.id = version.session_id            AND version.type_id            = getCvTermId('fly_olympiad_box', 'version', NULL))
WHERE s.type_id =  getCvTermId('fly_olympiad_box', 'analysis', NULL);

CREATE INDEX olympiad_box_amd_mv_session_id_ind ON tmp_olympiad_box_analysis_meta_data_mv(session_id);


-- =================================================== 
-- create temp table combining experiment and session 
-- properties
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_box_data_mv;
CREATE TABLE tmp_olympiad_box_data_mv
SELECT e.experiment_id, e.experiment_name, analysis.session_id, region.line_id, region.line_name, region.line_lab, analysis.session_name, analysis.session_type,
       e.apparatus_id, e.archived, e.automated_pf, e.behave_issue, e.box, e.calibratezz,
       e.computer, e.cool_max_var, region.cross_barcode, region.cross_date, e.day_of_week,
       region.dob, region.effector, e.errorcode, e.experiment_reprocessed, e.experiment_protocol,
       e.experimenter, e.exp_datetime, e.failed_stage, e.failure, e.file_system_path,
       e.flag_aborted, e.flag_legacy, e.flag_redo, e.flag_review, region.flip_date,
       region.flip_used, e.force_seq_start, region.gender, region.genotype, region.handler_cross,
       region.handler_sorting, region.handler_starvation, region.handling_protocol, e.hot_max_var, region.hours_sorted,
       region.hours_starved, e.humidity, e.i2cHang, e.issue_behavioral, e.issue_technical, e.live_notes,
       e.loadmetadata_error_message, e.manual_curator, e.manual_curation_date, e.manual_pf, e.manual_rating,
       e.max_vibration, e.notes_behavioral, e.notes_curation, e.notes_keyword,
       e.notes_technical, region.num_flies, region.num_flies_dead, region.rearing_incubator,
       region.rearing_protocol, e.resolution, region.robot_stock_copy, e.room,
       e.screen_reason, e.screen_type, tracking.sequence, e.tech_issue,
       tracking.temperature_setpoint, e.temperature, e.total_duration_seconds, e.transition_duration,
       analysis.region as tube, region.manual_pf as tube_manual_pf, tracking.version as tracking_version, analysis.version as analysis_version, 
       region.wish_list, e.zzcal_offset
FROM tmp_olympiad_box_experiment_data_mv e
JOIN tmp_olympiad_box_region_meta_data_mv region ON (e.experiment_id = region.experiment_id)
JOIN session_relationship rel1 ON (region.session_id = rel1.subject_id)
JOIN tmp_olympiad_box_tracking_meta_data_mv tracking ON (tracking.session_id = rel1.object_id)
JOIN session_relationship rel2 ON (tracking.session_id = rel2.subject_id)
JOIN tmp_olympiad_box_analysis_meta_data_mv analysis ON (analysis.session_id = rel2.object_id);

CREATE INDEX olympiad_box_edmv_cross_barcode_ind ON tmp_olympiad_box_data_mv(cross_barcode);

INSERT INTO tmp_olympiad_box_data_mv
SELECT e.experiment_id, e.experiment_name, tracking.session_id, region.line_id, region.line_name, region.line_lab, tracking.session_name, tracking.session_type,
       e.apparatus_id, e.archived, e.automated_pf, e.behave_issue, e.box, e.calibratezz,
       e.computer, e.cool_max_var, region.cross_barcode, region.cross_date, e.day_of_week,
       region.dob, region.effector, e.errorcode, e.experiment_reprocessed, e.experiment_protocol,
       e.experimenter, e.exp_datetime, e.failed_stage, e.failure, e.file_system_path,
       e.flag_aborted, e.flag_legacy, e.flag_redo, e.flag_review, region.flip_date, 
       region.flip_used, e.force_seq_start, region.gender, region.genotype, region.handler_cross,
       region.handler_sorting, region.handler_starvation, region.handling_protocol, e.hot_max_var, region.hours_sorted,
       region.hours_starved, e.humidity, e.i2cHang, e.issue_behavioral, e.issue_technical, e.live_notes,
       e.loadmetadata_error_message, e.manual_curator, e.manual_curation_date, e.manual_pf, e.manual_rating, 
       e.max_vibration, e.notes_behavioral, e.notes_curation, e.notes_keyword,
       e.notes_technical, region.num_flies, region.num_flies_dead, region.rearing_incubator,
       region.rearing_protocol, e.resolution, region.robot_stock_copy, e.room,
       e.screen_reason, e.screen_type, tracking.sequence, e.tech_issue,
       tracking.temperature_setpoint, e.temperature, e.total_duration_seconds, e.transition_duration, tracking.region as tube, region.manual_pf,
       tracking.version as tracking_version, null as analysis_version, region.wish_list, e.zzcal_offset
FROM tmp_olympiad_box_experiment_data_mv e
JOIN tmp_olympiad_box_region_meta_data_mv region ON (e.experiment_id = region.experiment_id)
JOIN session_relationship rel1 ON (region.session_id = rel1.subject_id)
JOIN tmp_olympiad_box_tracking_meta_data_mv tracking ON (tracking.session_id = rel1.object_id);

CREATE INDEX olympiad_box_edmv_experiment_id_ind ON tmp_olympiad_box_data_mv(experiment_id);
CREATE INDEX olympiad_box_edmv_experiment_name_ind ON tmp_olympiad_box_data_mv(experiment_name);
CREATE INDEX olympiad_box_edmv_session_id_ind ON tmp_olympiad_box_data_mv(session_id);
CREATE INDEX olympiad_box_edmv_session_name_ind ON tmp_olympiad_box_data_mv(session_name);
CREATE INDEX olympiad_box_edmv_session_type_ind ON tmp_olympiad_box_data_mv(session_type);
CREATE INDEX olympiad_box_edmv_line_id_ind ON tmp_olympiad_box_data_mv(line_id);
CREATE INDEX olympiad_box_edmv_line_name_ind ON tmp_olympiad_box_data_mv(line_name);
CREATE INDEX olympiad_box_edmv_exp_datetime_ind ON tmp_olympiad_box_data_mv(exp_datetime);
CREATE INDEX olympiad_box_edmv_sequence_ind ON tmp_olympiad_box_data_mv(sequence);
CREATE INDEX olympiad_box_edmv_temperature_setpoint_ind ON tmp_olympiad_box_data_mv(temperature_setpoint);
CREATE INDEX olympiad_box_edmv_tube_ind ON tmp_olympiad_box_data_mv(tube);
CREATE INDEX olympiad_box_edmv_automated_pf_ind ON tmp_olympiad_box_data_mv(automated_pf);
CREATE INDEX olympiad_box_edmv_manual_pf_ind ON tmp_olympiad_box_data_mv(manual_pf);
CREATE INDEX olympiad_box_edmv_tube_manual_pf_ind ON tmp_olympiad_box_data_mv(tube_manual_pf);
CREATE INDEX olympiad_box_edmv_screen_reason_ind ON tmp_olympiad_box_data_mv(screen_reason);
CREATE INDEX olympiad_box_edmv_screen_type_ind ON tmp_olympiad_box_data_mv(screen_type);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_box_experiment_data_mv;
RENAME TABLE tmp_olympiad_box_data_mv TO olympiad_box_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_box_experiment_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_box_region_meta_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_box_tracking_meta_data_mv;
DROP TABLE IF EXISTS tmp_olympiad_box_analysis_meta_data_mv;

-- =================================================== 
-- create SAGE REST API view
-- =================================================== 

/* 
    olympiad_box_analysis_info_vw
	
    This view creates one record for each score array that is produced by the box tracking code.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_box_analysis_info_vw AS
SELECT STRAIGHT_JOIN e.experiment_id, e.experiment_name, e.session_id, e.line_id, e.line_name, e.line_lab,
       e.apparatus_id, e.archived, e.automated_pf, e.behave_issue, e.box, e.calibratezz,
       e.computer, e.cool_max_var, e.cross_barcode, e.cross_date, e.day_of_week,
       e.dob, e.effector, e.errorcode, e.experiment_reprocessed, e.experiment_protocol,
       e.experimenter, e.exp_datetime, e.failed_stage, e.failure, e.file_system_path,
       e.flag_aborted, e.flag_legacy, e.flag_redo, e.flag_review, e.flip_date,
       e.flip_used, e.force_seq_start, e.gender, e.genotype, e.handler_cross,
       e.handler_sorting, e.handler_starvation, e.handling_protocol, e.hot_max_var, e.hours_sorted,
       e.hours_starved, e.humidity, e.i2cHang, e.issue_behavioral, e.issue_technical, e.live_notes,
       e.loadmetadata_error_message, e.manual_curator, e.manual_curation_date, e.manual_pf, e.manual_rating, 
       e.max_vibration, e.notes_behavioral, e.notes_curation, e.notes_keyword,
       e.notes_technical, e.num_flies, e.num_flies_dead, e.rearing_incubator,
       e.rearing_protocol, e.resolution, e.robot_stock_copy, e.room,
       e.screen_reason, e.screen_type, e.sequence, e.tech_issue,
       e.temperature_setpoint, e.temperature, e.total_duration_seconds, e.transition_duration, e.tube, e.tube_manual_pf,
       e.tracking_version, e.wish_list, e.zzcal_offset,
       sa_cv.name AS data_type, 
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format, 
       uncompress(sa.value) AS data
  FROM olympiad_box_experiment_data_mv e JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_box', NULL) AND e.session_id = sa.session_id and e.session_type = 'tracking')
                                         JOIN cv_term sa_cv ON (sa.type_id = sa_cv.id);

/* 
    olympiad_box_analysis_results_vw

    This view creates one record for each score array that is produced by the box analysis code.
    Additional fields are added for every single piece of metadata that goes with the score.
    This makes it so that any query is possible against the view without having to do any joins.
*/

CREATE OR REPLACE VIEW olympiad_box_analysis_results_vw AS
SELECT STRAIGHT_JOIN e.experiment_id, e.experiment_name, e.session_id, e.line_id, e.line_name, e.line_lab, 
       e.apparatus_id, e.archived, e.automated_pf, e.behave_issue, e.box, e.calibratezz,
       e.computer, e.cool_max_var, e.cross_barcode, e.cross_date, e.day_of_week,
       e.dob, e.effector, e.errorcode, e.experiment_reprocessed, e.experiment_protocol,
       e.experimenter, e.exp_datetime, e.failed_stage, e.failure, e.file_system_path,
       e.flag_aborted, e.flag_legacy, e.flag_redo, e.flag_review, e.flip_date,
       e.flip_used, e.force_seq_start, e.gender, e.genotype, e.handler_cross,
       e.handler_sorting, e.handler_starvation, e.handling_protocol, e.hot_max_var, e.hours_sorted,
       e.hours_starved, e.humidity, e.i2cHang, e.issue_behavioral, e.issue_technical, e.live_notes,
       e.loadmetadata_error_message, e.manual_curator, e.manual_curation_date, e.manual_pf, e.manual_rating,
       e.max_vibration, e.notes_behavioral, e.notes_curation, e.notes_keyword,
       e.notes_technical, e.num_flies, e.num_flies_dead, e.rearing_incubator,
       e.rearing_protocol, e.resolution, e.robot_stock_copy, e.room,
       e.screen_reason, e.screen_type, e.sequence, e.tech_issue,
       e.temperature_setpoint, e.temperature, e.total_duration_seconds, e.transition_duration, e.tube, e.tube_manual_pf,
       e.tracking_version, e.analysis_version, e.wish_list, e.zzcal_offset,
       sa_cv.name AS data_type, 
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format, 
       uncompress(sa.value) AS data
  FROM olympiad_box_experiment_data_mv e JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_box', NULL) AND e.session_id = sa.session_id and e.session_type = 'analysis')
                                         JOIN cv_term sa_cv ON (sa.type_id = sa_cv.id);

/* 
    olympiad_box_environmental_vw

    This view creates one record for each score array that is produced by the box tracking code
    at the experiment level.
*/
DROP TABLE IF EXISTS tmp_olympiad_box_environmental_mv;
CREATE TABLE tmp_olympiad_box_environmental_mv
SELECT DISTINCT e.experiment_id, e.experiment_name,
       e.apparatus_id, e.archived, e.automated_pf, e.behave_issue, e.box, e.calibratezz,
       e.computer, e.cool_max_var, e.day_of_week, e.errorcode, e.experiment_reprocessed, 
       e.experiment_protocol, e.experimenter, e.exp_datetime, e.failed_stage, e.failure, 
       e.file_system_path, e.flag_aborted, e.flag_legacy, e.flag_redo, e.flag_review, 
       e.force_seq_start, e.hot_max_var, e.humidity, e.i2cHang, e.issue_behavioral, e.issue_technical, 
       e.live_notes, e.loadmetadata_error_message, e.manual_curator, e.manual_curation_date, 
       e.manual_pf, e.manual_rating, e.max_vibration, e.notes_behavioral, e.notes_curation,
       e.notes_keyword, e.notes_technical, e.resolution, e.room, e.screen_reason, e.screen_type, 
       e.tech_issue, e.temperature, e.total_duration_seconds, e.transition_duration, e.zzcal_offset
  FROM olympiad_box_experiment_data_mv e 
;

CREATE INDEX olympiad_box_enmv_experiment_id_ind ON tmp_olympiad_box_environmental_mv(experiment_id);
CREATE INDEX olympiad_box_enmv_box_ind ON tmp_olympiad_box_environmental_mv(box);
CREATE INDEX olympiad_box_enmv_apparatus_id_ind ON tmp_olympiad_box_environmental_mv(apparatus_id);
CREATE INDEX olympiad_box_enmv_experiment_protocol_ind ON tmp_olympiad_box_environmental_mv(experiment_protocol);
CREATE INDEX olympiad_box_enmv_exp_datetime_ind ON tmp_olympiad_box_environmental_mv(exp_datetime);
CREATE INDEX olympiad_box_enmv_day_of_week_ind ON tmp_olympiad_box_environmental_mv(day_of_week);

DROP TABLE IF EXISTS olympiad_box_environmental_mv;
RENAME TABLE tmp_olympiad_box_environmental_mv TO olympiad_box_environmental_mv;

CREATE OR REPLACE VIEW olympiad_box_environmental_vw AS
SELECT STRAIGHT_JOIN e.*,
       sa_cv.name AS data_type, 
       sa.row_count AS data_rows, 
       sa.column_count AS data_columns, 
       sa.data_type AS data_format, 
       uncompress(sa.value) AS data
  FROM olympiad_box_environmental_mv e JOIN score_array sa ON (sa.cv_id = getCvId('fly_olympiad_box', NULL) AND e.experiment_id = sa.experiment_id AND sa.experiment_id IS NOT NULL)
                                       JOIN cv_term sa_cv ON (sa.type_id = sa_cv.id);


