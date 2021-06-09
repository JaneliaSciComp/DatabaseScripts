CREATE OR REPLACE VIEW lab_vw AS
SELECT cv_term.id
      ,cv_term.name  AS lab
      ,cv_term.display_name
FROM cv_term
JOIN cv on (cv.id = cv_term.cv_id)
WHERE cv.name ='lab'
;
