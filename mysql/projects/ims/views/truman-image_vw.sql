CREATE OR REPLACE VIEW truman_image_property_vw AS
SELECT image_id as id, 
      MAX(IF(STRCMP(image_property.type,'line'),null,value)) AS 'line',
      MAX(IF(STRCMP(image_property.type,'created_by'),null,value)) AS 'created_by'
FROM image_property
GROUP BY image_id;
--ORDER BY name;


CREATE OR REPLACE VIEW truman_image_vw AS
SELECT image.name,
       image.family,
       capture_date as 'capture_date',
       x.created_by,
       x.line, 
       value as 'gene',
       image.display
FROM truman_image_property_vw as x
JOIN image_property on (x.id = image_id)
JOIN image on (x.id=image.id)
WHERE type = 'gene';
--ORDER BY name;


--CREATE OR REPLACE VIEW truman_image_family_property_vw AS
--SELECT  image.family, type property_type, value property_value
--FROM image, image_property
--WHERE image.id = image_property.image_id
--AND type in ('line','gene')
--UNION
--SELECT family, 'capture_date', capture_date
--FROM image
--WHERE capture_date is not null;
