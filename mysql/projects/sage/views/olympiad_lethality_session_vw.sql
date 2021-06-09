CREATE OR REPLACE VIEW olympiad_lethality_session_vw AS
SELECT  line_vw.name                                 AS line
       ,line_vw.id                                   AS line_id
       ,line_vw.gene                                 AS gene
       ,synonyms                                     AS synonyms
       ,sv.id                                        AS session_id
       ,sv.name                                      AS session
       ,sv.experiment_id                             AS experiment_id
FROM line_vw
JOIN session_vw sv ON (sv.line_id = line_vw.id)
WHERE sv.lab='olympiad' AND sv.cv='fly_olympiad_lethality'
;
