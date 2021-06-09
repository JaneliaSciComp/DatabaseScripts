CREATE OR REPLACE VIEW olympiad_experiment_property_vw AS
SELECT ep.id            AS id
      ,ep.experiment_id AS experiment_id
      ,ep_cv_term.name     AS type
      ,ep.value         AS value
      ,ep.create_date   AS create_date
FROM experiment e
JOIN experiment_property ep on (e.id = ep.experiment_id)
JOIN cv_term ep_cv_term ON (ep.type_id = ep_cv_term.id)
JOIN cv_term e_cv_term ON (e_cv_term.id = e.type_id)
JOIN cv e_cv ON (e_cv.id = e_cv_term.cv_id and e_cv.name like 'fly_olympiad%')
;
