DROP TABLE IF EXISTS simpson_pe_mv;

CREATE OR REPLACE VIEW simpson_pe_vw AS
SELECT line_vw.name AS line
       ,line_vw.gene
       ,getGeneSynonymString(line_vw.gene) AS synonyms
       ,sv.name
       ,MAX(IF(strcmp(ov.type,'notes'),NULL,ov.value)) AS notes
       ,MAX(IF(strcmp(ov.type,'temp_type'),NULL,ov.value)) AS temp_type
FROM line_vw
JOIN session_vw sv ON (sv.line_id = line_vw.id)
LEFT OUTER JOIN observation_vw ov ON (sv.id = ov.session_id)
WHERE sv.lab='simpson' AND ov.cv='proboscis_extension'
GROUP BY 1,2,3,4
;
