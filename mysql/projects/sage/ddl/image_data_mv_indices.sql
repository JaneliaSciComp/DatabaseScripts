-- create indices on image data temporary table
CREATE INDEX image_data_mv_line_ind ON tmp_image_data_mv(line);
CREATE INDEX image_data_mv_name_ind ON tmp_image_data_mv(name);
CREATE INDEX image_data_mv_family_ind ON tmp_image_data_mv(family);
CREATE INDEX image_data_mv_capture_date_ind ON tmp_image_data_mv(capture_date);
CREATE INDEX image_data_mv_representative_ind ON tmp_image_data_mv(representative);
CREATE INDEX image_data_mv_display_ind ON tmp_image_data_mv(display);
-- CREATE INDEX image_data_mv_area_ind ON tmp_image_data_mv(area (767));
CREATE INDEX image_data_mv_class_ind ON tmp_image_data_mv(class (767));
CREATE INDEX image_data_mv_gender_ind ON tmp_image_data_mv(gender (767));
-- CREATE INDEX image_data_mv_height_ind ON tmp_image_data_mv(height (767));
CREATE INDEX image_data_mv_objective_ind ON tmp_image_data_mv(objective (767));
-- CREATE INDEX image_data_mv_organ_ind ON tmp_image_data_mv(organ (767));
-- CREATE INDEX image_data_mv_qi_ind ON tmp_image_data_mv(qi (767));
-- CREATE INDEX image_data_mv_qm_ind ON tmp_image_data_mv(qm (767));
-- CREATE INDEX image_data_mv_renamed_by_ind ON tmp_image_data_mv(renamed_by (767));
-- CREATE INDEX image_data_mv_width_ind ON tmp_image_data_mv(width (767));

-- CREATE INDEX image_data_mv_age_ind ON tmp_image_data_mv(age (767));
-- CREATE INDEX image_data_mv_dissection_date_ind ON tmp_image_data_mv(dissection_date (767));
-- CREATE INDEX image_data_mv_ihc_batch_ind ON tmp_image_data_mv(ihc_batch (767));
-- CREATE INDEX image_data_mv_dissector_ind ON tmp_image_data_mv(dissector (767));
-- CREATE INDEX image_data_mv_mounter_ind ON tmp_image_data_mv(mounter (767));
-- CREATE INDEX image_data_mv_mount_date_ind ON tmp_image_data_mv(mount_date (767));
CREATE INDEX image_data_mv_data_set_ind ON tmp_image_data_mv(data_set(100));
CREATE INDEX image_data_mv_cross_barcode_ind on tmp_image_data_mv(cross_barcode(10));
CREATE INDEX image_data_mv_slide_code_ind on tmp_image_data_mv(slide_code(15));
CREATE INDEX image_data_mv_jfs_path_ind ON tmp_image_data_mv(jfs_path);
CREATE INDEX image_data_mv_create_date_ind ON tmp_image_data_mv(create_date);
CREATE INDEX image_data_mv_update_date_ind ON tmp_image_data_mv(update_date);


-- drop image data table
DROP TABLE IF EXISTS image_data_mv;
-- rename image data temporary table to image data table
RENAME TABLE tmp_image_data_mv to image_data_mv;

CREATE OR REPLACE VIEW image_data_vw AS 
SELECT gene_data_mv.gene,image_data_mv.* 
FROM image_data_mv 
JOIN image ON (image.id = image_data_mv.id)
JOIN line ON (image.line_id = line.id)
LEFT OUTER JOIN gene_data_mv ON (line.gene_id = gene_data_mv.id)
;

DROP TABLE IF EXISTS tmp_image_family_vector_mv;
CREATE TABLE tmp_image_family_vector_mv AS
SELECT family,line, line_property.value as vector, DATE_FORMAT(image_data_mv.capture_date,'%Y-%m-%d') as capture_date, count(1) as counts
FROM image_data_mv
JOIN image ON (image.id = image_data_mv.id)
JOIN line ON (image.line_id = line.id)
LEFT JOIN line_property ON (line.id = line_property.line_id AND type_id = 87)
GROUP BY 1,2,3,4;

CREATE INDEX image_family_vector_mv_family_ind on tmp_image_family_vector_mv(family);
CREATE INDEX image_family_vector_mv_vector on tmp_image_family_vector_mv(vector);

DROP TABLE IF EXISTS image_family_vector_mv;
RENAME TABLE tmp_image_family_vector_mv to image_family_vector_mv;

CREATE OR REPLACE VIEW image_family_vector_vw AS
SELECT * from image_family_vector_mv;


CREATE OR REPLACE VIEW image_data_flylight_flip_vw AS 
SELECT mv.*,i.url
FROM image_data_mv mv JOIN image i ON mv.id = i.id WHERE family = 'flylight_flip';

CREATE OR REPLACE VIEW image_data_flylight_collaborations_vw AS
SELECT mv.*,i.url
FROM image_data_mv mv JOIN image i ON mv.id = i.id WHERE family = 'flylight_collaborations';

CREATE OR REPLACE VIEW image_data_flylight_rd_vw AS
SELECT mv.*,i.url
FROM image_data_mv mv JOIN image i ON mv.id = i.id WHERE family = 'flylight_rd';

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

