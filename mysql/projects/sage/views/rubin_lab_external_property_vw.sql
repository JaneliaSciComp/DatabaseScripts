CREATE OR REPLACE VIEW rubin_lab_external_property_vw AS
SELECT image_vw.id,
       image_vw.line,
       image_vw.capture_date as date,
       MAX(IF(STRCMP(image_property_vw.type,'disc'),null,value)) AS 'disc',
       MAX(IF(STRCMP(image_property_vw.type,'stage'),null,value)) AS 'stage',
       MAX(IF(STRCMP(image_property_vw.type,'external_lab'),null,value)) AS 'external_lab',
       MAX(IF(STRCMP(image_property_vw.type,'width'),null,value)) AS 'width',
       MAX(IF(STRCMP(image_property_vw.type,'height'),null,value)) AS 'height',
       image_vw.created_by
FROM image_vw
JOIN image_property_vw on (image_vw.id = image_id)
WHERE image_vw.family = 'rubin_lab_external'
GROUP BY id;
