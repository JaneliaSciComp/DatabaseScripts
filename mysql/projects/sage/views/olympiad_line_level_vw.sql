/* 
    name: olympiad_aggression_vw, olympiad_bowl_vw, olympiad_box_vw, olympiad_climbing_vw, olympiad_gap_vw, olympiad_lethality_vw, olympiad_observation_vw, olympiad_sterility_vw, olympiad_trikinetics_vw

    mv:  NONE

    app:  Line Level Reports
    
*/

-- ==============================
-- aggression assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_aggression_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.arena_experiment_name           AS experiment
       ,e.chamber_experiment_name         AS chamber
       ,e.arena                           AS arena
       ,e.automated_pf                    AS automated_pf
       ,e.effector                        AS effector
       ,substr(e.exp_datetime,1,8)        AS exp_date
       ,e.gender                          AS gender
       ,e.genotype                        AS genotype
       ,e.manual_pf                       AS manual_pf
       ,e.protocol                        AS protocol
       ,e.session_type                    AS session_type
       ,e.screen_type                     AS screen_type
       ,e.screen_reason                   AS screen_reason
       ,e.temperature                     AS temperature
       ,e.wish_list                       AS wish_list
FROM olympiad_aggression_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
;

-- ==============================
-- bowl assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_bowl_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.experiment_name                 AS experiment
       ,e.automated_pf                    AS automated_pf
       ,e.effector                        AS effector
       ,substr(e.exp_datetime,1,8)        AS exp_date
       ,e.gender                          AS gender
       ,e.genotype                        AS genotype
       ,e.manual_pf                       AS manual_pf
       ,e.protocol                        AS protocol
       ,e.screen_type                     AS screen_type
       ,e.screen_reason                   AS screen_reason
       ,e.wish_list                       AS wish_list
FROM olympiad_bowl_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
;

-- ==============================
-- box assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_box_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.experiment_name                 AS experiment
       ,e.automated_pf                    AS automated_pf
       ,e.box                             AS box
       ,e.effector                        AS effector
       ,substr(e.exp_datetime,1,8)        AS exp_date
       ,e.gender                          AS gender
       ,e.genotype                        AS genotype
       ,e.manual_pf                       AS manual_pf
       ,e.experiment_protocol             AS protocol
       ,e.screen_reason                   AS screen_reason
       ,e.screen_type                     AS screen_type
       ,e.wish_list                       AS wish_list
FROM olympiad_box_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
WHERE e.session_type='tracking'
;

-- ==============================
-- climbing assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_climbing_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.experiment_name                 AS experiment
       ,e.automated_pf                    AS automated_pf
       ,e.effector                        AS effector
       ,substr(e.exp_datetime,1,8)        AS exp_date
       ,e.gender                          AS gender
       ,e.genotype                        AS genotype
       ,e.manual_pf                       AS manual_pf
       ,e.protocol                        AS protocol
       ,screen_reason                     AS screen_reason
       ,screen_type                       AS screen_type
       ,wish_list                         AS wish_list
FROM olympiad_climbing_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
;

-- ==============================
-- gap assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_gap_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.experiment_name                 AS experiment
       ,e.automated_pf                    AS automated_pf
       ,e.effector                        AS effector
       ,substr(e.exp_datetime,1,8)        AS exp_date
       ,e.gender                          AS gender
       ,e.genotype                        AS genotype
       ,e.manual_pf                       AS manual_pf
       ,e.protocol                        AS protocol
       ,e.screen_reason                   AS screen_reason
       ,e.screen_type                     AS screen_type
       ,e.wish_list                       AS wish_list
FROM  olympiad_gap_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
;

-- ==============================
-- lethality assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_lethality_vw AS
SELECT  exp_datetime.value         AS 'Date'
       ,lab.display_name           AS 'Lab'
       ,l.name                     AS 'Line'
       ,wish_list.value            AS 'Wish_List'
       ,effector.value             AS 'Effector'
       ,o.value                    AS 'Stage_at_Death'
       ,temperature.value          AS 'Temperature'
       ,notes_behavioral.value     AS 'Behavioral_Notes'
FROM experiment e LEFT JOIN experiment_property exp_datetime     ON (exp_datetime.experiment_id = e.id     AND exp_datetime.type_id     = getcvtermid('fly_olympiad_lethality','exp_datetime',null))
                  LEFT JOIN experiment_property notes_behavioral ON (notes_behavioral.experiment_id = e.id AND notes_behavioral.type_id = getcvtermid('fly_olympiad_lethality','notes_behavioral',null))
                  LEFT JOIN experiment_property temperature      ON (temperature.experiment_id = e.id      AND temperature.type_id      = getcvtermid('fly_olympiad_lethality','temperature',null))
                  JOIN session s on (e.id = s.experiment_id)
                  LEFT JOIN session_property wish_list           ON (wish_list.session_id = s.id           AND wish_list.type_id        = getcvtermid('fly_olympiad_lethality','wish_list',null))
                  LEFT JOIN session_property effector            ON (effector.session_id = s.id            AND effector.type_id         = getcvtermid('fly_olympiad_lethality','effector',null))
                  LEFT JOIN observation o                        ON (o.session_id = s.id                   AND o.type_id                = getCvTermId('fly_olympiad_lethality', 'stage_at_death', NULL))
                  JOIN line l ON (s.line_id = l.id)
                  JOIN cv_term lab ON (lab.id = l.lab_id)
WHERE e.type_id = getcvtermid('fly_olympiad_lethality','lethality',null)
;

-- ==============================
-- observation assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_observation_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.experiment_name                 AS experiment
       ,e.automated_pf                    AS automated_pf
       ,e.effector                        AS effector
       ,substr(e.exp_datetime,1,8)        AS exp_date
       ,e.gender                          AS gender
       ,e.genotype                        AS genotype
       ,e.manual_pf                       AS manual_pf
       ,e.no_phenotypes                   AS no_phenotypes
       ,e.protocol                        AS protocol
       ,e.screen_reason                   AS screen_reason 
       ,e.screen_type                     AS screen_type 
       ,e.wish_list                       AS wish_list
FROM  olympiad_observation_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
;

-- ==============================
-- sterility assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_sterility_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.experiment_name                 AS experiment
       ,e.automated_pf                    AS automated_pf
       ,e.cross_barcode                   AS cross_barcode
       ,e.effector                        AS effector
       ,substr(e.exp_datetime,1,8)        AS exp_date
       ,e.experimenter                    AS experimenter
       ,e.gender                          AS gender
       ,e.genotype                        AS genotype
       ,e.manual_pf                       AS manual_pf
       ,e.data                            AS sterile
       ,e.screen_reason                   AS screen_reason
       ,e.screen_type                     AS screen_type
       ,e.wish_list                       AS wish_list
FROM olympiad_sterility_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
WHERE data_type = 'sterile'
;

-- ==============================
-- trikinetics assay
-- ==============================
CREATE OR REPLACE VIEW olympiad_trikinetics_vw AS
SELECT  e.line_name                       AS line
       ,g.name                            AS gene
       ,g.synonym_string                  AS synonyms
       ,e.experiment_name                 AS experiment
       ,e.automated_pf                    AS automated_pf
       ,e.effector                        AS effector
       ,e.manual_pf                       AS manual_pf
FROM  olympiad_trikinetics_experiment_data_mv e
JOIN line l ON (e.line_id = l.id)
LEFT JOIN gene g ON (l.gene_id = g.id)
;
