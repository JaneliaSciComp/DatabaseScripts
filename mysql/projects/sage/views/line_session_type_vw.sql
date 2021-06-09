CREATE OR REPLACE VIEW line_session_type_vw AS
SELECT  line_vw.name AS line
       ,COUNT(IF(strcmp(session_vw.cv,'fly_olympiad_aggression'),NULL,1))  AS fly_olympiad_aggression
       ,COUNT(IF(strcmp(session_vw.cv,'fly_olympiad_box'),NULL,1))  AS fly_olympiad_box
       ,COUNT(IF(strcmp(session_vw.cv,'fly_olympiad_gap'),NULL,1))  AS fly_olympiad_gap
       ,COUNT(IF(strcmp(session_vw.cv,'fly_olympiad_lethality'),NULL,1))  AS fly_olympiad_lethality
       ,COUNT(IF(strcmp(session_vw.cv,'fly_olympiad_sterility'),NULL,1))  AS fly_olympiad_sterility
       ,COUNT(IF(strcmp(session_vw.cv,'grooming'),NULL,1))  AS grooming
       ,COUNT(IF(strcmp(session_vw.cv,'ipcr'),NULL,1))  AS ipcr
       ,COUNT(IF(strcmp(session_vw.cv,'proboscis_extension'),NULL,1))  AS proboscis_extension
FROM line_vw
JOIN session_vw  ON (session_vw.line_id = line_vw.id)
GROUP BY 1
;
