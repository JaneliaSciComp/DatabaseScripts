CREATE OR REPLACE VIEW phase_property_vw AS
SELECT pp.id            AS id
      ,pp.phase_id      AS phase_id
      ,p.name           AS name
      ,cv.name          AS cv
      ,cv_term.name     AS type
      ,pp.value         AS value
      ,pp.create_date   AS create_date
FROM phase_property pp
JOIN phase p ON (pp.phase_id = p.id)
JOIN cv_term ON (pp.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
