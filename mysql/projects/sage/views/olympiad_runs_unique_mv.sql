/* 
    name: olympiad_runs_unique_vw

    mv:   olympiad_runs_unique_mv

    app:  SAGE PLOT THROUGHPUT Report
    
    note: This script performs the following queries to consolidate unique runs across all olympiad assays
          1.  Create unique run views for aggression, bowl, box, gap, lethality, observation, sterility, and trikinetics
          2.  Create a temp table containing union of unique run views
          4.  Create materialized view of temp table.
          5.  Create view on materialized view for use by SAGE Plot
    
*/
-- =================================================== 
-- aggression unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_aggression_runs_unique_vw AS
SELECT DISTINCT 
       e.arena_experiment_name     AS name
      ,e.line_id                   AS line_id
      ,e.line_name                 AS line_name
      ,e.session_id                AS session_id
      ,e.session_name              AS session_name
      ,e.effector                  AS effector
      ,e.arena_experiment_id       AS experiment_id
      ,e.exp_datetime              AS experiment_date_time
      ,IF(((count(distinct (case when ((e.flag_aborted <> '1') and (e.manual_pf <> 'F')) then e.chamber_experiment_id else NULL end)) / count(distinct e.chamber_experiment_id)) * 100.0) >= 75.0, 'P', 'F') AS automated_pf
      ,'U'                         AS manual_pf
      ,e.wish_list                 AS wish_list
      ,'fly_olympiad_aggression'   AS cv
FROM olympiad_aggression_experiment_data_mv e
WHERE line_name != 'Not_Applicable'
GROUP BY  e.arena_experiment_id,e.line_id
;

-- =================================================== 
-- bowl unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_bowl_runs_unique_vw AS
SELECT DISTINCT 
       e.experiment_name           AS name
      ,e.line_id                   AS line_id
      ,e.line_name                 AS line_name
      ,e.session_id                AS session_id
      ,e.session_name              AS session_name
      ,e.effector                  AS effector
      ,e.experiment_id             AS experiment_id
      ,e.exp_datetime              AS experiment_date_time
      ,e.automated_pf              AS automated_pf
      ,e.manual_pf                 AS manual_pf
      ,e.wish_list                 AS wish_list
      ,'fly_olympiad_fly_bowl'     AS cv
FROM olympiad_bowl_experiment_data_mv e 
;

-- =================================================== 
-- box unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_box_runs_unique_vw AS
SELECT DISTINCT 
       e.experiment_name           AS name
      ,e.line_id                   AS line_id
      ,e.line_name                 AS line_name
      ,e.session_id                AS session_id
      ,e.tube                      AS session_name
      ,e.effector                  AS effector
      ,e.experiment_id             AS experiment_id
      ,e.exp_datetime              AS experiment_date_time
      ,e.automated_pf              AS automated_pf
      ,e.manual_pf                 AS manual_pf
      ,e.wish_list                 AS wish_list
      ,'fly_olympiad_box'          AS cv 
FROM olympiad_box_experiment_data_mv e
WHERE e.session_type = 'region'
;

-- =================================================== 
-- climbing unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_climbing_runs_unique_vw AS
SELECT DISTINCT
       e.experiment_name           AS name
      ,e.line_id                   AS line_id
      ,e.line_name                 AS line_name
      ,e.session_id                AS session_id
      ,e.session_name              AS session_name
      ,e.effector                  AS effector
      ,e.experiment_id             AS experiment_id
      ,e.exp_datetime              AS experiment_date_time
      ,e.automated_pf              AS automated_pf
      ,e.manual_pf                 AS manual_pf
      ,e.wish_list                 AS wish_list
      ,'fly_olympiad_climbing'     AS cv
FROM olympiad_climbing_experiment_data_mv e
;

-- =================================================== 
-- gap unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_gap_runs_unique_vw AS
SELECT DISTINCT 
       e.experiment_name           AS name
      ,e.line_id                   AS line_id
      ,e.line_name                 AS line_name
      ,e.session_id                AS session_id
      ,e.session_name              AS session_name
      ,e.effector                  AS effector
      ,e.experiment_id             AS experiment_id
      ,e.exp_datetime              AS experiment_date_time
      ,e.automated_pf              AS automated_pf
      ,e.manual_pf                 AS manual_pf
      ,e.wish_list                 AS wish_list
      ,'fly_olympiad_gap'          AS cv
FROM olympiad_gap_experiment_data_mv e 
;

-- =================================================== 
-- lethality unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_lethality_runs_unique_vw AS
SELECT DISTINCT 
       e.name                               AS name
      ,s.line_id                            AS line_id
      ,l.name                               AS line_name
      ,s.id                                 AS session_id
      ,cast(s.name as char(250))            AS session_name
      ,cast(effector.value as char(50))     AS effector
      ,e.id                                 AS experiment_id
      ,cast(exp_datetime.value as char(50)) AS experiment_date_time
      ,'P'                                  AS automated_pf
      ,'U'                                  AS manual_pf
      ,cast(wish_list.value as char(50))    AS wish_list
      ,'fly_olympiad_lethality'             AS cv
FROM experiment e
JOIN session s ON (e.id = s.experiment_id)
JOIN session_property exp_datetime ON (exp_datetime.session_id = s.id and exp_datetime.type_id = getCvTermId('fly_olympiad','exp_datetime',NULL))
JOIN experiment_property effector ON (effector.experiment_id = e.id and effector.type_id = getCvTermId('fly_olympiad','effector',NULL))
JOIN line l ON (l.id = s.line_id)
LEFT JOIN session_property wish_list ON (wish_list.session_id = s.id and wish_list.type_id = getCvTermId('fly','wish_list',NULL))
WHERE e.type_id = getCvTermId('fly_olympiad_lethality','lethality',NULL)
;

-- =================================================== 
-- observation unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_observation_runs_unique_vw AS
SELECT DISTINCT 
       e.experiment_name           AS name
      ,e.line_id                   AS line_id
      ,e.line_name                 AS line_name
      ,e.session_id                AS session_id
      ,e.session_name              AS session_name
      ,e.effector                  AS effector
      ,e.experiment_id             AS experiment_id
      ,e.exp_datetime              AS experiment_date_time
      ,e.automated_pf              AS automated_pf
      ,e.manual_pf                 AS manual_pf
      ,e.wish_list                 AS wish_list
      ,'fly_olympiad_observation'  AS cv
FROM  olympiad_observation_experiment_data_mv e
;

-- =================================================== 
-- sterility unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_sterility_runs_unique_vw AS
SELECT DISTINCT 
       e.experiment_name           AS name
      ,e.line_id                   AS line_id
      ,e.line_name                 AS line_name
      ,e.session_id                AS session_id
      ,e.session_name              AS session_name
      ,e.effector                  AS effector
      ,e.experiment_id             AS experiment_id
      ,e.exp_datetime              AS experiment_date_time
      ,e.automated_pf              AS automated_pf
      ,e.manual_pf                 AS manual_pf
      ,e.wish_list                 AS wish_list
      ,'fly_olympiad_sterility'    AS cv
FROM olympiad_sterility_experiment_data_mv e
;

-- =================================================== 
-- trikinetics unique run view
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_trikinetics_runs_unique_vw AS
SELECT v.experiment_name           AS name
      ,v.line_id                   AS line_id
      ,v.line_name                 AS line_name
      ,v.session_id		   AS session_id
      ,v.session_name		   AS session_name
      ,v.effector                  AS effector
      ,v.experiment_id             AS experiment_id
      ,v.exp_datetime              AS experiment_date_time
      -- ,(case when ((length(group_concat(dead)) - length(replace(group_concat(dead), 'yes', '')))/3)/(length(group_concat(dead)) - length(replace(group_concat(dead), ',', '')) + 1) > 0.125 then 'F' else v.automated_pf end) 
      ,v.automated_pf              AS automated_pf
      ,v.manual_pf                 AS manual_pf
      -- ,v.wish_list                AS wish_list
      ,cast(NULL as char(50))      AS wish_list
      ,'fly_olympiad_trikinetics'  AS cv
FROM olympiad_trikinetics_experiment_data_mv v
WHERE v.session_type_id =  getCvTermId('fly_olympiad_trikinetics', 'crossings', NULL)
GROUP BY v.experiment_id, v.line_id
;

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS tmp_olympiad_runs_unique_mv;

CREATE TABLE tmp_olympiad_runs_unique_mv AS
SELECT v.*
FROM olympiad_gap_runs_unique_vw v
UNION ALl
SELECT v.*
FROM olympiad_bowl_runs_unique_vw v
UNION ALL 
SELECT v.* 
FROM olympiad_lethality_runs_unique_vw v
UNION ALL 
SELECT v.* 
FROM olympiad_observation_runs_unique_vw v
UNION ALL 
SELECT v.* 
FROM olympiad_sterility_runs_unique_vw v
UNION ALL
SELECT v.*
FROM olympiad_trikinetics_runs_unique_vw v
UNION ALL
SELECT v.*
FROM olympiad_aggression_runs_unique_vw v
UNION ALL
SELECT v.*
FROM olympiad_box_runs_unique_vw v
UNION ALL
SELECT v.*
FROM olympiad_climbing_runs_unique_vw v
;

CREATE INDEX olympiad_runs_umv_line_id_ind ON tmp_olympiad_runs_unique_mv(line_id);
CREATE INDEX olympiad_runs_umv_line_name_ind ON tmp_olympiad_runs_unique_mv(line_name);
CREATE INDEX olympiad_runs_umv_effector_ind ON tmp_olympiad_runs_unique_mv(effector);
CREATE INDEX olympiad_runs_umv_wish_list_ind ON tmp_olympiad_runs_unique_mv(wish_list);

DROP TABLE IF EXISTS olympiad_runs_unique_mv;

RENAME TABLE tmp_olympiad_runs_unique_mv TO olympiad_runs_unique_mv;

-- =================================================== 
-- create API view for SAGE Plot
-- =================================================== 
CREATE OR REPLACE VIEW olympiad_runs_unique_vw AS
SELECT *
FROM olympiad_runs_unique_mv
;
