CREATE OR REPLACE VIEW olympiad_trikinetics_analysis_session_property_vw AS
SELECT  spv.session_id
       ,MAX(IF(strcmp(spv.type,'temperature'),NULL,spv.value))  AS temperature
       ,MAX(IF(strcmp(spv.type,'monitor'),NULL,spv.value))      AS monitor
       ,MAX(IF(strcmp(spv.type,'channel'),NULL,spv.value))      AS channel
FROM session_property_vw spv 
JOIN olympiad_trikinetics_session_vw sv ON (spv.session_id = sv.session_id AND sv.session_type = 'crossings')
GROUP BY 1
;
