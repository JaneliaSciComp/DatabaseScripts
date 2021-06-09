CREATE OR REPLACE VIEW simpson_rep_image_vw AS
SELECT line_id
       ,MAX(IF(STRCMP(value,'Brain'),null,image_id)) AS 'brain_id'
       ,MAX(IF(STRCMP(value,'Thorax'),null,image_id)) AS 'thorax_id'
FROM image
JOIN image_property_vw ON (image_property_vw.image_id = image.id)
-- JOIN cv_term lab ON (lab.id = image.lab_id and lab.name = 'simpson')
WHERE type='organ'
GROUP BY line_id
;
