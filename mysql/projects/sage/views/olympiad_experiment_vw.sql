CREATE OR REPLACE VIEW olympiad_experiment_vw AS
SELECT e.id            AS id
      ,e.name          AS name
      ,cv_term.name    AS type
      ,protocol.value  AS protocol
      ,cvt1.name       AS lab
      ,e.experimenter  AS experimenter
      ,e.create_date   AS create_date
FROM experiment e
JOIN cv_term cvt1 ON (e.lab_id = cvt1.id)
JOIN cv cv1 ON (cvt1.cv_id = cv1.id and cv1.name = 'lab')
JOIN cv_term ON (e.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id and cv.name like 'fly_olympiad%')
LEFT JOIN experiment_property protocol ON (protocol.experiment_id = e.id AND protocol.type_id = getCvTermId('fly_olympiad', 'protocol', NULL))
;
