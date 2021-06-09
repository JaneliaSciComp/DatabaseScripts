CREATE OR REPLACE VIEW olympiad_box_session_vw AS
SELECT  line_vw.name                    AS line
       ,line_vw.gene                    AS gene
       ,line_vw.synonyms                AS synonyms
       ,sv.id                           AS session_id
       ,sv.name                         AS session
       ,sv.experiment_id                AS experiment_id
       ,sv.type                         AS session_type
FROM line_vw
JOIN session_vw sv ON (sv.line_id = line_vw.id)
JOIN experiment e ON (e.id = sv.experiment_id)
JOIN cv_term et ON (e.type_id = et.id)
JOIN cv ec ON (ec.id = et.cv_id and ec.name = 'fly_olympiad_box')
WHERE sv.lab='olympiad'
;
