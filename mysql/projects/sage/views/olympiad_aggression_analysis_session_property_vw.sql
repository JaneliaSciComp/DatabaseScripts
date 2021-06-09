CREATE OR REPLACE VIEW olympiad_aggression_analysis_session_property_vw AS
SELECT  aggression_sv.session_id AS session_id
FROM olympiad_aggression_session_vw aggression_sv 
;
