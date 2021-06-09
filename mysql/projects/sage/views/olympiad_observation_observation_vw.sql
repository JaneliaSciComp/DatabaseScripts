CREATE OR REPLACE VIEW olympiad_observation_observation_vw AS
SELECT  l.name                           AS line
       ,e.id                             AS experiment_id
       ,s.name                           AS session
       ,c.display_name                   AS display_name
       ,o_observed.value                 AS observed
       ,o_gender.value                   AS gender
       ,o_penetrance.value              AS penetrance
FROM  session s
JOIN experiment e ON (e.id = s.experiment_id)
JOIN cv_term c ON (c.id = s.type_id)
JOIN observation o_observed ON (s.id = o_observed.session_id AND o_observed.type_id = getCvTermId('fly_olympiad_observation', 'observed', NULL))
LEFT JOIN observation o_gender ON (s.id = o_gender.session_id AND o_gender.type_id = getCvTermId('fly_olympiad_observation', 'gender', NULL))
LEFT JOIN observation o_penetrance ON (s.id = o_penetrance.session_id AND o_penetrance.type_id = getCvTermId('fly_olympiad_observation', 'penetrance', NULL))
JOIN line l ON (s.line_id = l.id)
WHERE e.type_id = getCvTermId('fly_olympiad_observation', 'observation', NULL)
;
