CREATE OR REPLACE VIEW simpson_image_class_vw AS
SELECT line,
       product,
       class
FROM simpson_image_property_vw
JOIN image_vw on (simpson_image_property_vw.image_id=image_vw.id)
WHERE class IS NOT NULL;
