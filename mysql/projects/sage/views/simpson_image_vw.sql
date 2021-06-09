CREATE OR REPLACE VIEW simpson_image_vw AS
SELECT image_vw.name,
       image_vw.family,
       image_vw.capture_date,
       image_vw.representative,
       image_vw.created_by,
       image_vw.line, 
       simpson_image_property_vw.organ,
       simpson_image_property_vw.specimen,
       simpson_image_property_vw.bits_per_sample,
       image_vw.display
FROM simpson_image_property_vw
JOIN image_vw on (simpson_image_property_vw.image_id=image_vw.id and image_vw.name like 'simpson%');
