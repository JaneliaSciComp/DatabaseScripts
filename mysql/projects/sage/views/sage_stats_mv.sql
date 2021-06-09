DROP TABLE IF EXISTS tmp_primary_image_stat_mv;
CREATE TABLE tmp_primary_image_stat_mv
SELECT c.name AS family
       ,definition
       ,COUNT(DISTINCT line_id) AS line_count
       ,COUNT(1) AS image_count
FROM image i JOIN cv_term c ON (i.family_id=c.id) GROUP BY 1
; 
DROP TABLE IF EXISTS primary_image_stat_mv;
RENAME TABLE tmp_primary_image_stat_mv TO primary_image_stat_mv;

DROP TABLE IF EXISTS tmp_secondary_image_stat_mv;
CREATE TABLE tmp_secondary_image_stat_mv
SELECT c.cv_term AS family
       ,definition
       ,COUNT(1) AS image_count
FROM image_vw i JOIN secondary_image s ON (s.image_id=i.id) JOIN cv_term_vw c ON (i.family=c.cv_term) GROUP BY 1
; 
DROP TABLE IF EXISTS secondary_image_stat_mv;
RENAME TABLE tmp_secondary_image_stat_mv TO secondary_image_stat_mv;

DROP TABLE IF EXISTS tmp_lab_assay_stat_mv;
CREATE TABLE tmp_lab_assay_stat_mv
SELECT getCVTermDisplayName(e.lab_id) AS lab
       ,c.name AS assay
       ,COUNT(DISTINCT s.line_id) AS line_count
       ,COUNT(DISTINCT e.id) AS experiment_count
       ,COUNT(s.id) AS session_count
FROM experiment e
     JOIN session s ON (e.id=s.experiment_id)
     JOIN cv_term ct ON (ct.id=e.type_id)
     JOIN cv c ON (c.id=ct.cv_id)
     GROUP BY 1,2
; 
DROP TABLE IF EXISTS lab_assay_stat_mv;
RENAME TABLE tmp_lab_assay_stat_mv TO lab_assay_stat_mv;

DROP TABLE IF EXISTS tmp_primary_image_volume_stat_mv;
CREATE TABLE tmp_primary_image_volume_stat_mv
SELECT family,SUM(file_size) AS volume FROM image_data_mv WHERE file_size IS NOT NULL GROUP BY 1;
DROP TABLE IF EXISTS primary_image_volume_stat_mv;
RENAME TABLE tmp_primary_image_volume_stat_mv TO primary_image_volume_stat_mv;

DROP TABLE IF EXISTS tmp_cv_effector_stat_mv;
CREATE TABLE tmp_cv_effector_stat_mv
SELECT e.cv AS cv
,value AS effector
,COUNT(2) AS effector_count
FROM experiment_property_vw ep
JOIN experiment_vw e ON (e.id=experiment_id)
WHERE ep.type='effector' GROUP BY 1,2
UNION SELECT e.cv,value,COUNT(2)
FROM session_property_vw sp
JOIN session s ON (s.id=session_id)
JOIN experiment_vw e ON (e.id=s.experiment_id)
WHERE sp.type='effector' GROUP BY 1,2;
DROP TABLE IF EXISTS cv_effector_stat_mv;
RENAME TABLE tmp_cv_effector_stat_mv TO cv_effector_stat_mv;
