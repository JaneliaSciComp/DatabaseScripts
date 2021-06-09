CREATE OR REPLACE VIEW simpson_image_property_vw AS
SELECT image_id as id, 
       MAX(IF(STRCMP(image_property.type,'line'),null,value)) AS 'line',
       MAX(IF(STRCMP(image_property.type,'organ'),null,value)) AS 'organ',
       MAX(IF(STRCMP(image_property.type,'specimen'),null,value)) AS 'specimen',      
       MAX(IF(STRCMP(image_property.type,'bits_per_sample'),null,value)) AS 'bits_per_sample',
       MAX(IF(STRCMP(image_property.type,'created_by'),null,value)) AS 'created_by',
       MAX(IF(STRCMP(image_property.type,'product'),null,value)) AS 'product',
       MAX(IF(STRCMP(image_property.type,'class'),null,value)) AS 'class'
FROM image_property
GROUP BY image_id;
--ORDER BY name;


CREATE OR REPLACE VIEW simpson_image_vw AS
SELECT image.name,
       image.family,
       capture_date as 'capture_date',
       image.representative,
       x.created_by,
       x.line, 
       x.organ,
       x.specimen,
       x.bits_per_sample,
       image.display
FROM simpson_image_property_vw as x
JOIN image on (x.id=image.id);
--ORDER BY name;

CREATE OR REPLACE VIEW simpson_image_class_vw AS
SELECT line,
       product,
       class
FROM simpson_image_property_vw
WHERE class IS NOT NULL;
      
--CREATE OR REPLACE VIEW simpson_image_family_property_vw AS
--SELECT  image.family, type property_type, value property_value
--FROM image, image_property
--WHERE image.id = image_property.image_id
--AND type in ('line','organ','bits_per_sample')
--UNION
--SELECT family, 'capture_date', capture_date
--FROM image
--WHERE capture_date is not null;
