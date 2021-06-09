CREATE OR REPLACE VIEW olympiad_box_experiment_property_vw AS
SELECT  oepv.experiment_id
       ,MAX(IF(strcmp(oepv.type,'date_time'),NULL,oepv.value))               AS date_time 
       ,MAX(IF(strcmp(oepv.type,'box_name'),NULL,oepv.value))                AS box_name 
       ,MAX(IF(strcmp(oepv.type,'top_plate_id'),NULL,oepv.value))            AS top_plate_id 
       ,MAX(IF(strcmp(oepv.type,'failure'),NULL,oepv.value))                 AS failure 
       ,MAX(IF(strcmp(oepv.type,'errorcode'),NULL,oepv.value))               AS errorcode 
       ,MAX(IF(strcmp(oepv.type,'cool_max_var'),NULL,oepv.value))            AS cool_max_var 
       ,MAX(IF(strcmp(oepv.type,'hot_max_var'),NULL,oepv.value))             AS hot_max_var 
       ,MAX(IF(strcmp(oepv.type,'transition_duration'),NULL,oepv.value))     AS transition_duration 
       ,MAX(IF(strcmp(oepv.type,'questionable_data'),NULL,oepv.value))       AS questionable_data 
       ,MAX(IF(strcmp(oepv.type,'redo_experiment'),NULL,oepv.value))         AS redo_experiment 
       ,MAX(IF(strcmp(oepv.type,'live_notes'),NULL,oepv.value))              AS live_notes 
       ,MAX(IF(strcmp(oepv.type,'operator'),NULL,oepv.value))                AS operator 
       ,MAX(IF(strcmp(oepv.type,'max_vibration'),NULL,oepv.value))           AS max_vibration 
       ,MAX(IF(strcmp(oepv.type,'total_duration_seconds'),NULL,oepv.value))  AS total_duration_seconds 
       ,MAX(IF(strcmp(oepv.type,'force_seq_start'),NULL,oepv.value))         AS force_seq_start 
       ,MAX(IF(strcmp(oepv.type,'halt_early'),NULL,oepv.value))              AS halt_early 
FROM olympiad_experiment_property_vw oepv
JOIN olympiad_experiment_vw oev ON ( oepv.experiment_id = oev.id and oev.type='box')
GROUP BY 1
;
