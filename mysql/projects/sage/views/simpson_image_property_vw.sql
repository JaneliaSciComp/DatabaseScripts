CREATE OR REPLACE VIEW simpson_image_property_vw AS
SELECT image_id as image_id, 
       MAX(IF(STRCMP(image_property_vw.type,'organ'),null,value)) AS 'organ',
       MAX(IF(STRCMP(image_property_vw.type,'specimen'),null,value)) AS 'specimen',      
       MAX(IF(STRCMP(image_property_vw.type,'bits_per_sample'),null,value)) AS 'bits_per_sample',
       MAX(IF(STRCMP(image_property_vw.type,'product'),null,value)) AS 'product',
       MAX(IF(STRCMP(image_property_vw.type,'class'),null,value)) AS 'class'
FROM image_property_vw
JOIN image_vw on (image_property_vw.image_id=image_vw.id and image_vw.family like 'simpson%')
GROUP BY image_id;
