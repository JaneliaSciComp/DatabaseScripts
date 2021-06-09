CREATE OR REPLACE VIEW session_vw AS
SELECT s.id            AS id
      ,s.name          AS name
      ,cv.name         AS cv
      ,cv_term.name    AS type
      ,s.line_id       AS line_id
      ,l.name          AS line
      ,s.image_id      AS image_id
      ,i.name          AS image
      ,s.experiment_id AS experiment_id
      ,s.phase_id      AS phase_id
      ,s.annotator     AS annotator
      ,lab.name        AS lab
      ,s.create_date   AS create_date
FROM session s
JOIN line l ON (s.line_id = l.id)
LEFT JOIN image i ON (s.image_id = i.id)
JOIN cv_term lab ON (s.lab_id = lab.id)
JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
JOIN cv_term ON (s.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
