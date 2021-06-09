CREATE OR REPLACE VIEW olympiad_aggression_session_property_vw AS
SELECT  spv.session_id
FROM olympiad_aggression_session_vw sv 
JOIN session_property_vw spv ON (spv.session_id = sv.session_id)
;
