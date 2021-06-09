/* 
    name: disk_usage_vw

    mv:   NONE

    app:  ?????
*/

CREATE OR REPLACE VIEW disk_usage_vw AS
SELECT e.name AS name
,ep.value AS read_datetime
,c.name AS cv
,getCvTermName(s.type_id) AS assay
,getCvTermName(o.type_id) AS storage
,o.value AS volume
FROM experiment e
JOIN cv_term ct ON (e.type_id=ct.id AND ct.name='disk_usage')
JOIN cv c ON (c.id=ct.cv_id)
JOIN experiment_property ep ON (e.id=ep.experiment_id AND ep.type_id=getCvTermID('disk_usage','read_datetime',NULL))
JOIN session s ON (e.id=s.experiment_id)
JOIN observation o ON (s.id=o.session_id)
;

CREATE OR REPLACE VIEW disk_usage_latest_detail_vw AS
SELECT read_datetime
          ,cv
          ,assay
          ,storage
          ,volume
          FROM disk_usage_vw d
          WHERE d.read_datetime= (SELECT MAX(d2.read_datetime) 
                                  FROM disk_usage_vw d2
                                )
;

CREATE OR REPLACE VIEW disk_usage_latest_vw AS
SELECT cv
,read_datetime
,SUM(IF(STRCMP(storage,'primary_volume'),0,volume))/1024 AS primary_volume
,SUM(IF(STRCMP(storage,'archive_volume'),0,volume))/1024 AS archive_volume
,SUM(IF(STRCMP(storage,'tier2_volume'),0,volume))/1024 AS tier2_volume
,SUM(IF(STRCMP(storage,'nearline_volume'),0,volume))/1024 AS nearline_volume
FROM disk_usage_latest_detail_vw
GROUP BY 1,2
;

CREATE OR REPLACE VIEW disk_usage_weekly_vw AS
SELECT YEARWEEK(read_datetime) AS year_week
       ,cv
       ,storage
       ,SUM(volume)/1024
FROM disk_usage_vw
GROUP BY 1,2,3
;
