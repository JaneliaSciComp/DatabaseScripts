CREATE OR REPLACE VIEW phase_vw AS
SELECT p.id            AS id
      ,p.experiment_id
      ,p.name          AS name
      ,cv.name         AS cv
      ,cv_term.name    AS type
      ,p.create_date   AS create_date
FROM phase p
JOIN cv_term ON (p.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
