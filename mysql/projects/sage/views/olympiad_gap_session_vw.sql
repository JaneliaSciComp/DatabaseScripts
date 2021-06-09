CREATE OR REPLACE VIEW olympiad_gap_session_vw AS
SELECT  line_vw.name                                        AS line
       ,line_vw.gene                                        AS gene
       ,synonyms                  AS synonyms
       ,sv.id                                               AS session_id
       ,sv.name                                             AS session
       ,sv.experiment_id                                    AS experiment_id
       ,sv.type                                             AS session_type
FROM line_vw
JOIN session_vw sv ON (sv.line_id = line_vw.id)
WHERE sv.lab='olympiad' AND sv.cv='fly_olympiad_gap'
;
