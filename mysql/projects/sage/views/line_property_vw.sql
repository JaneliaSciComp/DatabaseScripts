CREATE OR REPLACE VIEW line_property_vw AS
SELECT lp.id          AS id
      ,l.id           AS line_id
      ,l.name         AS name
      ,cvt1.name      AS lab
      ,cv.name        AS cv
      ,cv_term.name   AS type
      ,lp.value       AS value
      ,lp.create_date AS create_date
FROM line_property lp
JOIN line l ON (lp.line_id = l.id)
JOIN cv_term cvt1 ON (l.lab_id = cvt1.id)
JOIN cv cv1 ON (cvt1.cv_id = cv1.id)
JOIN cv_term ON (lp.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
