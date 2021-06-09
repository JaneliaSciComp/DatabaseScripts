CREATE OR REPLACE VIEW session_property_vw AS
SELECT sp.id          AS id
      ,sp.session_id  AS session_id
      ,s.name         AS name
      ,cvt1.name      AS lab
      ,cv.name        AS cv
      ,cv_term.name   AS type
      ,sp.value       AS value
      ,sp.create_date AS create_date
FROM session_property sp
JOIN session s ON (sp.session_id = s.id)
JOIN cv_term cvt1 ON (s.lab_id = cvt1.id)
JOIN cv cv1 ON (cvt1.cv_id = cv1.id)
JOIN cv_term ON (sp.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
