CREATE OR REPLACE VIEW olympiad_sequence_vw AS
SELECT p.id            AS id
      ,p.experiment_id AS experiment_id
      ,p.name          AS name
      ,p.create_date   AS create_date
FROM phase p
JOIN cv_term ON (p.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id and cv.name like 'fly_olympiad%')
;
