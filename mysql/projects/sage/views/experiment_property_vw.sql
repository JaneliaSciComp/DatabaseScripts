CREATE OR REPLACE VIEW experiment_property_vw AS
SELECT ep.id            AS id
      ,ep.experiment_id AS experiment_id
      ,e.name           AS name
      ,cvt1.name        AS lab
      ,cv.name          AS cv
      ,cv_term.name     AS type
      ,ep.value         AS value
      ,ep.create_date   AS create_date
FROM experiment_property ep
JOIN experiment e ON (ep.experiment_id = e.id)
JOIN cv_term cvt1 ON (e.lab_id = cvt1.id)
JOIN cv cv1 ON (cvt1.cv_id = cv1.id)
JOIN cv_term ON (ep.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
