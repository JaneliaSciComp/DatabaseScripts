CREATE OR REPLACE VIEW olympiad_sequence_property_vw AS
SELECT sp.id            AS id
      ,sp.phase_id      AS sequence_id
      ,cv_term.name     AS type
      ,sp.value         AS value
      ,sp.create_date   AS create_date
FROM phase_property sp
JOIN cv_term ON (sp.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id and cv.name like 'fly_olympiad%')
;
