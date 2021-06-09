CREATE OR REPLACE VIEW olympiad_box_session_property_vw AS
SELECT  s.id           AS session_id
       ,effector.value AS effector
       ,genotype.value AS genotype
       ,rearing.value  AS rearing
       ,gender.value   AS gender
       ,s_type.name    AS session_type
FROM session s
JOIN cv_term s_type ON (s_type.id = s.type_id)
JOIN cv s_cv ON (s_cv.id = s_type.cv_id)
JOIN experiment e ON (e.id = s.experiment_id)
JOIN cv_term e_type ON (e.type_id = e_type.id)
JOIN cv e_cv ON (e_cv.id = e_type.cv_id AND e_cv.name = 'fly_olympiad_box')
JOIN session_property effector ON (s.id = effector.session_id)
JOIN cv_term effector_type ON (effector.type_id = effector_type.id AND effector_type.name = 'effector')
JOIN session_property genotype ON (s.id = genotype.session_id)
JOIN cv_term genotype_type ON (genotype.type_id = genotype_type.id AND genotype_type.name = 'genotype')
JOIN session_property rearing ON (s.id = rearing.session_id)
JOIN cv_term rearing_type ON (rearing.type_id = rearing_type.id AND rearing_type.name = 'rearing')
JOIN session_property gender ON (s.id = gender.session_id)
JOIN cv_term gender_type ON (gender.type_id = gender_type.id AND gender_type.name = 'gender')
JOIN session_property temperature ON (s.id = temperature.session_id)
;
