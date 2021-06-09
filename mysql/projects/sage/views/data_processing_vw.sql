CREATE OR REPLACE VIEW data_processing_vw AS
SELECT d.id            AS id
      ,o.name          AS operation
      ,i.name          AS image
      ,d.start         AS start_date
      ,d.stop          AS stop_date
FROM data_processing d 
JOIN image i ON (d.image_id = i.id)
JOIN cv_term o ON (d.operation_id = o.id)
;

CREATE OR REPLACE VIEW data_processing_property_vw AS
SELECT dp.id          AS id
      ,dp.data_processing_id  AS data_processing_id
      ,cv_term.name   AS type
      ,dp.value       AS value
      ,dp.create_date AS create_date
FROM data_processing_property dp
JOIN cv_term ON (dp.type_id = cv_term.id)
;

CREATE OR REPLACE VIEW  data_processing_data_vw AS
SELECT data_processing_id as data_processing_id
      ,o.name          AS operation
      ,i.name          AS image
      ,d.start         AS start_date
      ,d.stop          AS stop_date
      ,MAX(IF(STRCMP(ctp.name,'alignment_markers'),null,dp.value)) AS 'alignment_markers'
      ,MAX(IF(STRCMP(ctp.name,'alignment_target'),null,dp.value)) AS 'alignment_target'
      ,MAX(IF(STRCMP(ctp.name,'host'),null,dp.value)) AS 'host'
      ,MAX(IF(STRCMP(ctp.name,'imagej_macro'),null,dp.value)) AS 'imagej_macro'
      ,MAX(IF(STRCMP(ctp.name,'imagej_macro_version'),null,dp.value)) AS 'imagej_macro_version'
      ,MAX(IF(STRCMP(ctp.name,'operator'),null,dp.value)) AS 'operator'
      ,MAX(IF(STRCMP(ctp.name,'program'),null,dp.value)) AS 'program'
      ,MAX(IF(STRCMP(ctp.name,'version'),null,dp.value)) AS 'version'
FROM data_processing_property dp
JOIN cv_term ctp on ( dp.type_id = ctp.id)
JOIN data_processing d on (dp.data_processing_id = d.id)
JOIN image i ON (d.image_id = i.id)
JOIN cv_term o ON (d.operation_id = o.id)
GROUP BY data_processing_id
;
