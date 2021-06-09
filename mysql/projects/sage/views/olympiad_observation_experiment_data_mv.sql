/* 
    name: olympiad_observation_data_vw

    mv:   olympiad_observation_experiment_data_mv

    app:  SAGE REST API
    
    note: This script performs the following queries to flatten Observation Assay data.
          1.  Create a temp table containing experiment properties and observations
          4.  Create materialized view of temp table.
          5.  Create view on materialized view for use by SAGE REST API
*/

-- =================================================== 
-- create temp table containing experiment properties
-- and observations
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_observation_experiment_data_mv;
CREATE TABLE tmp_olympiad_observation_experiment_data_mv
SELECT  e.id AS experiment_id, cast(e.name as char(250)) AS experiment_name, s.id AS session_id, cast(s.name as char(250)) AS session_name,
        s.line_id AS line_id, cast(l.name as char(50)) AS line_name, cast(lab_cv.name as char(50)) AS line_lab, 
        cast(observed_gender.value as char(1)) AS observed_gender, cast(penetrance.value as char(50)) AS penetrance,
        cast(aint.value as char(1)) AS aint, cast(apparatus_id.value as char(3)) AS apparatus_id, cast(archived.value as char(1)) AS archived,
        cast(automated_pf.value as char(1)) AS automated_pf, cast(cross_barcode.value as char(50)) AS cross_barcode, cast(cross_date.value as char(50)) AS cross_date, cast(datetime_sorting.value as char(50)) AS datetime_sorting,
        cast(effector.value as char(50)) AS effector, cast(experimenter.value as char(50)) AS experimenter, cast(exp_datetime.value as char(50)) AS exp_datetime, dayofweek(cast(exp_datetime.value as datetime)) AS experiment_day_of_week,
        cast(file_system_path.value as char(225)) AS file_system_path, cast(flag_aborted.value as char(1)) AS flag_aborted, cast(flag_legacy.value as char(1)) AS flag_legacy,
        cast(flag_redo.value as char(1)) AS flag_redo, cast(flag_review.value as char(1)) AS flag_review, cast(flip_date.value as char(50)) AS flip_date,
        cast(flip_used.value as char(1)) AS flip_used, cast(gender.value as char(50)) AS gender, cast(genotype.value as char(50)) AS genotype,
        cast(gint.value as char(1)) AS gint, cast(handler_cross.value as char(50)) AS handler_cross, cast(handling_protocol.value as char(50)) AS handling_protocol,
        cast(hint.value as char(1)) AS hint, cast(humidity.value as char(50)) AS humidity, cast(lint.value as char(1)) AS lint,
        cast(manual_pf.value as char(1)) AS manual_pf, cast(notes_behavioral.value as char(225)) AS notes_behavioral, cast(notes_technical.value as char(225)) AS notes_technical,
        cast(no_phenotypes.value as char(1)) AS no_phenotypes, cast(pint.value as char(1)) AS pint, cast(protocol.value as char(50)) AS protocol,
        cast(psint.value as char(1)) AS psint, cast(rearing_incubator.value as char(3)) AS rearing_incubator, cast(rearing_protocol.value as char(50)) AS rearing_protocol,
        cast(robot_stock_copy.value as char(50)) AS robot_stock_copy, cast(room.value as char(50)) AS room, cast(roompheno.value as char(1)) AS roompheno,
        cast(screen_reason.value as char(225)) AS screen_reason, cast(screen_type.value as char(50)) AS screen_type, cast(sint.value as char(1)) AS sint,
        cast(temperature.value as char(50)) AS temperature, cast(tint.value as char(1)) AS tint, cast(wint.value as char(1)) AS wint, cast(wish_list.value as char(50)) AS wish_list,
        concat(cast(observed.value as char(1)), ' ') AS data, cast(s.name as char(50)) AS data_type, 'str1' as data_format, 1 as data_rows, 1 as data_columns
FROM experiment e LEFT JOIN experiment_property aint                ON (e.id = aint.experiment_id                AND aint.type_id              = getCvTermId('fly_olympiad_observation', 'aint', NULL))
                  LEFT JOIN experiment_property apparatus_id        ON (e.id = apparatus_id.experiment_id        AND apparatus_id.type_id      = getCvTermId('fly_olympiad_observation', 'apparatus_id', NULL))
                  LEFT JOIN experiment_property archived            ON (e.id = archived.experiment_id            AND archived.type_id          = getCvTermId('fly_olympiad_observation', 'archived', NULL))
                  LEFT JOIN experiment_property automated_pf        ON (e.id = automated_pf.experiment_id        AND automated_pf.type_id      = getCvTermId('fly_olympiad_qc', 'automated_pf', NULL))
                  LEFT JOIN experiment_property cross_barcode       ON (e.id = cross_barcode.experiment_id       AND cross_barcode.type_id     = getCvTermId('fly_olympiad_observation', 'cross_barcode', NULL))
                  LEFT JOIN experiment_property cross_date          ON (e.id = cross_date.experiment_id          AND cross_date.type_id        = getCvTermId('fly_olympiad_observation', 'cross_date', NULL))
                  LEFT JOIN experiment_property datetime_sorting    ON (e.id = datetime_sorting.experiment_id    AND datetime_sorting.type_id  = getCvTermId('fly_olympiad_observation', 'datetime_sorting', NULL))
                  LEFT JOIN experiment_property effector            ON (e.id = effector.experiment_id            AND effector.type_id          = getCvTermId('fly_olympiad_observation', 'effector', NULL))
                  LEFT JOIN experiment_property experimenter        ON (e.id = experimenter.experiment_id        AND experimenter.type_id      = getCvTermId('fly_olympiad_observation', 'experimenter', NULL))
                  LEFT JOIN experiment_property exp_datetime        ON (e.id = exp_datetime.experiment_id        AND exp_datetime.type_id      = getCvTermId('fly_olympiad_observation', 'exp_datetime', NULL))
                  LEFT JOIN experiment_property file_system_path    ON (e.id = file_system_path.experiment_id    AND file_system_path.type_id  = getCvTermId('fly_olympiad_observation', 'file_system_path', NULL))
                  LEFT JOIN experiment_property flag_aborted        ON (e.id = flag_aborted.experiment_id        AND flag_aborted.type_id      = getCvTermId('fly_olympiad_observation', 'flag_aborted', NULL))
                  LEFT JOIN experiment_property flag_legacy         ON (e.id = flag_legacy.experiment_id         AND flag_legacy.type_id       = getCvTermId('fly_olympiad_observation', 'flag_legacy', NULL))
                  LEFT JOIN experiment_property flag_redo           ON (e.id = flag_redo.experiment_id           AND flag_redo.type_id         = getCvTermId('fly_olympiad_observation', 'flag_redo', NULL))
                  LEFT JOIN experiment_property flag_review         ON (e.id = flag_review.experiment_id         AND flag_review.type_id       = getCvTermId('fly_olympiad_observation', 'flag_review', NULL))
                  LEFT JOIN experiment_property flip_date           ON (e.id = flip_date.experiment_id           AND flip_date.type_id         = getCvTermId('fly_olympiad_observation', 'flip_date', NULL))
                  LEFT JOIN experiment_property flip_used           ON (e.id = flip_used.experiment_id           AND flip_used.type_id         = getCvTermId('fly_olympiad_observation', 'flip_used', NULL))
                  LEFT JOIN experiment_property gender              ON (e.id = gender.experiment_id              AND gender.type_id            = getCvTermId('fly_olympiad_observation', 'gender', NULL))
                  LEFT JOIN experiment_property genotype            ON (e.id = genotype.experiment_id            AND genotype.type_id          = getCvTermId('fly_olympiad_observation', 'genotype', NULL))
                  LEFT JOIN experiment_property gint                ON (e.id = gint.experiment_id                AND gint.type_id              = getCvTermId('fly_olympiad_observation', 'gint', NULL))
                  LEFT JOIN experiment_property handler_cross       ON (e.id = handler_cross.experiment_id       AND handler_cross.type_id     = getCvTermId('fly_olympiad_observation', 'handler_cross', NULL))
                  LEFT JOIN experiment_property handling_protocol   ON (e.id = handling_protocol.experiment_id   AND handling_protocol.type_id = getCvTermId('fly_olympiad_observation', 'handling_protocol', NULL))
                  LEFT JOIN experiment_property hint                ON (e.id = hint.experiment_id                AND hint.type_id              = getCvTermId('fly_olympiad_observation', 'hint', NULL))
                  LEFT JOIN experiment_property humidity            ON (e.id = humidity.experiment_id            AND humidity.type_id          = getCvTermId('fly_olympiad_observation', 'humidity', NULL))
                  LEFT JOIN experiment_property lint                ON (e.id = lint.experiment_id                AND lint.type_id              = getCvTermId('fly_olympiad_observation', 'lint', NULL))
                  LEFT JOIN experiment_property manual_pf           ON (e.id = manual_pf.experiment_id           AND manual_pf.type_id         = getCvTermId('fly_olympiad_qc', 'manual_pf', NULL))
                  LEFT JOIN experiment_property notes_behavioral    ON (e.id = notes_behavioral.experiment_id    AND notes_behavioral.type_id  = getCvTermId('fly_olympiad_observation', 'notes_behavioral', NULL))
                  LEFT JOIN experiment_property notes_technical     ON (e.id = notes_technical.experiment_id     AND notes_technical.type_id   = getCvTermId('fly_olympiad_observation', 'notes_technical', NULL))
                  LEFT JOIN experiment_property no_phenotypes       ON (e.id = no_phenotypes.experiment_id       AND no_phenotypes.type_id     = getCvTermId('fly_olympiad_observation', 'no_phenotypes', NULL))
                  LEFT JOIN experiment_property pint                ON (e.id = pint.experiment_id                AND pint.type_id              = getCvTermId('fly_olympiad_observation', 'pint', NULL))
                  LEFT JOIN experiment_property protocol            ON (e.id = protocol.experiment_id            AND protocol.type_id          = getCvTermId('fly_olympiad_observation', 'protocol', NULL))
                  LEFT JOIN experiment_property psint               ON (e.id = psint.experiment_id               AND psint.type_id             = getCvTermId('fly_olympiad_observation', 'psint', NULL))
                  LEFT JOIN experiment_property rearing_incubator   ON (e.id = rearing_incubator.experiment_id   AND rearing_incubator.type_id = getCvTermId('fly_olympiad_observation', 'rearing_incubator', NULL))
                  LEFT JOIN experiment_property rearing_protocol    ON (e.id = rearing_protocol.experiment_id    AND rearing_protocol.type_id  = getCvTermId('fly_olympiad_observation', 'rearing_protocol', NULL))
                  LEFT JOIN experiment_property robot_stock_copy    ON (e.id = robot_stock_copy.experiment_id    AND robot_stock_copy.type_id  = getCvTermId('fly_olympiad_observation', 'robot_stock_copy', NULL))
                  LEFT JOIN experiment_property room                ON (e.id = room.experiment_id                AND room.type_id              = getCvTermId('fly_olympiad_apparatus', 'room', NULL))
                  LEFT JOIN experiment_property roompheno           ON (e.id = roompheno.experiment_id           AND roompheno.type_id         = getCvTermId('fly_olympiad_observation', 'roompheno', NULL))
                  LEFT JOIN experiment_property screen_reason       ON (e.id = screen_reason.experiment_id       AND screen_reason.type_id     = getCvTermId('fly_olympiad_observation', 'screen_reason', NULL))
                  LEFT JOIN experiment_property screen_type         ON (e.id = screen_type.experiment_id         AND screen_type.type_id       = getCvTermId('fly_olympiad_observation', 'screen_type', NULL))
                  LEFT JOIN experiment_property sint                ON (e.id = sint.experiment_id                AND sint.type_id              = getCvTermId('fly_olympiad_observation', 'sint', NULL))
                  LEFT JOIN experiment_property temperature         ON (e.id = temperature.experiment_id         AND temperature.type_id       = getCvTermId('fly_olympiad_observation', 'temperature', NULL))
                  LEFT JOIN experiment_property tint                ON (e.id = tint.experiment_id                AND tint.type_id              = getCvTermId('fly_olympiad_observation', 'tint', NULL))
                  LEFT JOIN experiment_property wint                ON (e.id = wint.experiment_id                AND wint.type_id              = getCvTermId('fly_olympiad_observation', 'wint', NULL))
                  LEFT JOIN experiment_property wish_list           ON (e.id = wish_list.experiment_id           AND wish_list.type_id         = getCvTermId('fly_olympiad_observation', 'wish_list', NULL))
                  JOIN session s                                    ON (e.id = s.experiment_id)
                  LEFT JOIN observation observed                    ON (s.id = observed.session_id               AND observed.type_id          = getCvTermId('fly_olympiad_observation', 'observed', NULL))
                  LEFT JOIN observation observed_gender             ON (s.id = observed_gender.session_id        AND observed_gender.type_id   = getCvTermId('fly_olympiad_observation', 'gender', NULL))
                  LEFT JOIN observation penetrance                  ON (s.id = penetrance.session_id             AND penetrance.type_id        = getCvTermId('fly_olympiad_observation', 'penetrance', NULL))
                  JOIN line l                                       ON (s.line_id = l.id)
                  JOIN cv_term lab_cv ON (l.lab_id = lab_cv.id)
WHERE e.type_id = getCvTermId('fly_olympiad_observation', 'observation', NULL)
;
CREATE INDEX olympiad_observation_edmv_experiment_id_ind ON tmp_olympiad_observation_experiment_data_mv(experiment_id);
CREATE INDEX olympiad_observation_edmv_experiment_name_ind ON tmp_olympiad_observation_experiment_data_mv(experiment_name);
CREATE INDEX olympiad_observation_edmv_observation_ind ON tmp_olympiad_observation_experiment_data_mv(data_type);
CREATE INDEX olympiad_observation_edmv_line_id_ind ON tmp_olympiad_observation_experiment_data_mv(line_id);
CREATE INDEX olympiad_observation_edmv_line_name_ind ON tmp_olympiad_observation_experiment_data_mv(line_name);
CREATE INDEX olympiad_observation_edmv_exp_datetime_ind ON tmp_olympiad_observation_experiment_data_mv(exp_datetime);
CREATE INDEX olympiad_observation_edmv_automated_pf_ind ON tmp_olympiad_observation_experiment_data_mv(automated_pf);
CREATE INDEX olympiad_observation_edmv_manual_pf_ind ON tmp_olympiad_observation_experiment_data_mv(manual_pf);
CREATE INDEX olympiad_observation_edmv_screen_reason_ind ON tmp_olympiad_observation_experiment_data_mv(screen_reason);
CREATE INDEX olympiad_observation_edmv_screen_type_ind ON tmp_olympiad_observation_experiment_data_mv(screen_type);

-- =================================================== 
-- create materialzed view
-- =================================================== 
DROP TABLE IF EXISTS olympiad_observation_experiment_data_mv;
RENAME TABLE tmp_olympiad_observation_experiment_data_mv TO olympiad_observation_experiment_data_mv;

-- =================================================== 
-- create view for SAGE REST API
-- and observations
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_observation_data_vw AS
SELECT  *
FROM olympiad_observation_experiment_data_mv
;
