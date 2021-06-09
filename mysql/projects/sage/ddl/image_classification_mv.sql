DROP TABLE IF EXISTS tmp_image_classification_mv;
CREATE TABLE tmp_image_classification_mv AS
SELECT id.family,
       lp.value AS driver,
       IF(id.age LIKE 'A%' OR id.age LIKE 'Day%','Adult',id.age) as age,
       SUBSTR(id.imaging_project,1,30) as imaging_project,
       cast(id.effector as char(50)) AS reporter,
       cast(id.data_set as char(50)) as data_set,
       count(1) as count
FROM image_data_mv id 
JOIN line_property_vw lp ON (lp.name=id.line AND lp.type='flycore_project') 
WHERE lp.value IS NOT NULL
GROUP BY 1,2,3,4,5,6;

DROP TABLE IF EXISTS image_classification_mv;
RENAME TABLE tmp_image_classification_mv to image_classification_mv;

CREATE OR REPLACE VIEW image_classification_vw AS
SELECT * from image_classification_mv;

