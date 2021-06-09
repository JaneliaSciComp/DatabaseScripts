CREATE OR REPLACE VIEW line_experiment_vw AS
SELECT e.id            AS id
      ,e.name          AS name
      ,l.name          AS line
      ,cv.name         AS cv
      ,cv_term.name    AS type
      ,e.experimenter  AS experimenter
      ,cvt1.name       AS lab
      ,e.create_date   AS create_date
FROM experiment e
JOIN cv_term cvt1 ON (e.lab_id = cvt1.id)
JOIN cv cv1 ON (cvt1.cv_id = cv1.id)
JOIN cv_term ON (e.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
JOIN session s on (s.experiment_id = e.id)
JOIN line l on (s.line_id = l.id)
;
