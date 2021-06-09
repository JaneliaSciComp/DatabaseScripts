CREATE OR REPLACE VIEW rubin_image_property_vw AS
SELECT image_id id, 
      MAX(IF(STRCMP(image_property.type,'line'),null,value)) AS 'line',
      MAX(IF(STRCMP(image_property.type,'gender'),null,value)) AS 'gender',
      MAX(IF(STRCMP(image_property.type,'age'),null,value)) AS 'age',
      MAX(IF(STRCMP(image_property.type,'organ'),null,value)) AS 'organ',
      MAX(IF(STRCMP(image_property.type,'created_by'),null,value)) AS 'created_by'
FROM image_property
GROUP BY image_id;
--ORDER BY name;


CREATE OR REPLACE VIEW rubin_image_vw AS
SELECT image.name,
       image.family,
       capture_date as 'capture_date',
       x.created_by,
       x.line
      ,value as 'gene'
      ,x.gender
      ,x.age
      ,x.organ
      ,image.display 
FROM rubin_image_property_vw as x
JOIN image_property on (x.id = image_id)
JOIN image on (x.id=image.id)
WHERE type = 'gene';
--ORDER BY name;


--CREATE OR REPLACE VIEW rubin_image_family_property_vw AS
--SELECT  image.family, type property_type, value property_value
--FROM image, image_property
--WHERE image.id = image_property.image_id
--AND type in ('line','gender','age','organ','gene')
--UNION
--SELECT family, 'capture_date', capture_date
--FROM image
--WHERE capture_date is not null;


--CREATE OR REPLACE VIEW rubin_chacrm_property_vw AS
--SELECT image.id,
--      MAX(IF(STRCMP(image_property.type,'line'),null,value)) AS 'line',
--      MAX(IF(STRCMP(image_property.type,'gender'),null,value)) AS 'gender',
--      MAX(IF(STRCMP(image_property.type,'age'),null,value)) AS 'age',
--      MAX(IF(STRCMP(image_property.type,'organ'),null,value)) AS 'organ',
--      MAX(IF(STRCMP(image_property.type,'created_by'),null,value)) AS 'created_by'
--FROM image
--JOIN image_property on (image.id = image_id)
--WHERE image.family = 'rubin-chacrm'
--GROUP BY id;

--CREATE OR REPLACE VIEW rubin_chacrm_vw AS
--SELECT image.name,
--       capture_date as 'capture_date',
--       x.created_by,
--       x.line, value as 'gene'
--      ,x.gender
--      ,x.age
--      ,x.organ
--FROM  rubin_chacrm_property_vw as x
--JOIN image_property on (x.id = image_id)
--JOIN image on (x.id=image.id)
--WHERE type = 'gene';

CREATE OR REPLACE VIEW rubin_lab_external_property_vw AS
SELECT image.id,
      MAX(IF(STRCMP(image_property.type,'line'),null,value)) AS 'line',
      MAX(IF(STRCMP(image_property.type,'date'),null,value)) AS 'date',
      MAX(IF(STRCMP(image_property.type,'disc'),null,value)) AS 'disc',
      MAX(IF(STRCMP(image_property.type,'age'),null,value)) AS 'age',
      MAX(IF(STRCMP(image_property.type,'external_lab'),null,value)) AS 'external_lab',
      MAX(IF(STRCMP(image_property.type,'created_by'),null,value)) AS 'created_by'
FROM image
JOIN image_property on (image.id = image_id)
WHERE image.family = 'rubin-lab-external'
GROUP BY id;

CREATE OR REPLACE VIEW rubin_lab_external_vw AS
SELECT image.name
      ,image.representative
      ,x.created_by
      ,x.line
      ,x.date
      ,x.disc
      ,x.age
      ,x.external_lab
      ,image.display
FROM rubin_lab_external_property_vw as x
JOIN image on (x.id=image.id);

CREATE OR REPLACE VIEW dimension_vw AS
SELECT image_id as id,
      MAX(IF(STRCMP(image_property.type,'height'),IF(STRCMP(image_property.type,'dimension_y'),null,value),value)) AS 'height',
      MAX(IF(STRCMP(image_property.type,'width'),IF(STRCMP(image_property.type,'dimension_x'),null,value),value)) AS 'width'
FROM image_property
GROUP BY image_id;

