CREATE OR REPLACE VIEW olympiad_box_analysis_session_property_vw AS
SELECT  box_s.id           AS session_id
       ,e.id               AS experiment_id
       ,sequence.value     AS sequence
       ,region.value       AS region
       ,temperature.value  AS temperature
FROM experiment e 
JOIN cv_term e_type ON (e.type_id = e_type.id)
JOIN cv e_cv ON (e_cv.id = e_type.cv_id AND e_cv.name = 'fly_olympiad_box')
JOIN session box_s ON (e.id = box_s.experiment_id)
JOIN cv_term box_s_type ON (box_s.type_id = box_s_type.id AND box_s_type.name = 'analysis')
JOIN cv box_s_cv ON (box_s_cv.id = box_s_type.cv_id AND box_s_cv.name = 'fly_olympiad')
JOIN session_property sequence ON (box_s.id = sequence.session_id)
JOIN cv_term sequence_type ON (sequence.type_id = sequence_type.id AND sequence_type.name = 'sequence')
JOIN session_property region ON (box_s.id = region.session_id)
JOIN cv_term region_type ON (region.type_id = region_type.id AND region_type.name = 'region')
JOIN session_property temperature ON (box_s.id = temperature.session_id)
JOIN cv_term temperature_type ON (temperature.type_id = temperature_type.id AND temperature_type.name = 'temperature')
;
