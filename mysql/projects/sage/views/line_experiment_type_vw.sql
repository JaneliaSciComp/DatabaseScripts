CREATE OR REPLACE VIEW line_experiment_type_vw AS
SELECT  line
--       ,grade
       ,COUNT(IF(strcmp(cv,'fly_olympiad_aggression'),NULL,1))  AS fly_olympiad_aggression
       ,COUNT(IF(strcmp(cv,'fly_olympiad_box'),NULL,1))  AS fly_olympiad_box
       ,COUNT(IF(strcmp(cv,'fly_olympiad_gap'),NULL,1))  AS fly_olympiad_gap
       ,COUNT(IF(strcmp(cv,'fly_olympiad_lethality'),NULL,1))  AS fly_olympiad_lethality
       ,COUNT(IF(strcmp(cv,'fly_olympiad_observation'),NULL,1))  AS fly_olympiad_observation
       ,COUNT(IF(strcmp(cv,'fly_olympiad_sterility'),NULL,1))  AS fly_olympiad_sterility
       ,COUNT(IF(strcmp(cv,'fly_olympiad_trikinetics'),NULL,1))  AS fly_olympiad_trikinetics
       ,COUNT(IF(strcmp(cv,'grooming'),NULL,1))  AS grooming
       ,COUNT(IF(strcmp(cv,'ipcr'),NULL,1))  AS ipcr
       ,COUNT(IF(strcmp(cv,'proboscis_extension'),NULL,1))  AS proboscis_extension
       ,COUNT(IF(strcmp(cv,'fly_olympiad_fly_bowl'),NULL,1))  AS fly_olympiad_fly_bowl
FROM line_experiment_type_unique_vw
GROUP BY 1
;
