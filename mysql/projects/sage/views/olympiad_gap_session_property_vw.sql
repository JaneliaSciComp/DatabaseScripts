CREATE OR REPLACE VIEW olympiad_gap_session_property_vw AS
SELECT  spv.session_id
       ,MAX(IF(strcmp(spv.type,'effector'),NULL,spv.value)) AS effector
       ,MAX(IF(strcmp(spv.type,'genotype'),NULL,spv.value)) AS genotype
       ,MAX(IF(strcmp(spv.type,'rearing'),NULL,spv.value))  AS rearing
       ,MAX(IF(strcmp(spv.type,'gender'),NULL,spv.value))   AS gender
FROM session_property_vw spv 
JOIN olympiad_gap_session_vw sv ON (spv.session_id = sv.session_id)
GROUP BY 1
;
