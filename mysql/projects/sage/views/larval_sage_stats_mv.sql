DROP TABLE IF EXISTS tmp_primary_image_stat_mv;
CREATE TABLE tmp_primary_image_stat_mv
SELECT c.name AS family
       ,definition
       ,COUNT(DISTINCT line_id) AS line_count
       ,COUNT(1) AS image_count
FROM image i JOIN cv_term c ON (i.family_id=c.id) GROUP BY 1;
DROP TABLE IF EXISTS primary_image_stat_mv;
RENAME TABLE tmp_primary_image_stat_mv TO primary_image_stat_mv;

DROP TABLE IF EXISTS tmp_primary_image_volume_stat_mv;
CREATE TABLE tmp_primary_image_volume_stat_mv
SELECT 'larval_olympiad' AS family,SUM(value) AS volume FROM image_property ip JOIN image_vw i ON (i.id=ip.image_id AND i.family='larval_olympiad') WHERE ip.type_id=getCVTermID('light_imagery','file_size',NULL);
DROP TABLE IF EXISTS primary_image_volume_stat_mv;
RENAME TABLE tmp_primary_image_volume_stat_mv TO primary_image_volume_stat_mv;

DROP TABLE IF EXISTS tmp_lab_assay_stat_mv;
CREATE TABLE tmp_lab_assay_stat_mv
SELECT getCVTermDisplayName(e.lab_id) AS lab
       ,c.name as assay
       ,ep.value AS tracker
       ,COUNT(DISTINCT e.id) AS experiment_count
       ,COUNT(s.id) AS session_count
FROM experiment e
     JOIN session s ON (e.id=s.experiment_id)
     JOIN cv_term ct ON (ct.id=e.type_id)
     JOIN cv c ON (c.id=ct.cv_id)
     JOIN experiment_property_vw ep ON (ep.experiment_id=e.id AND ep.type='tracker')
     GROUP BY 1,2,3
; 
DROP TABLE IF EXISTS lab_assay_stat_mv;
RENAME TABLE tmp_lab_assay_stat_mv TO lab_assay_stat_mv;

DROP TABLE IF EXISTS tmp_cv_effector_stat_mv;
CREATE TABLE tmp_cv_effector_stat_mv
SELECT e.cv AS cv
,ep.value AS tracker
,ep2.value AS effector
,COUNT(3) AS effector_count
FROM experiment_vw e
JOIN experiment_property_vw ep ON (e.id=ep.experiment_id AND ep.type='tracker')
JOIN experiment_property_vw ep2 ON (e.id=ep2.experiment_id AND ep2.type='effector') GROUP BY 1,2,3;
DROP TABLE IF EXISTS cv_effector_stat_mv;
RENAME TABLE tmp_cv_effector_stat_mv TO cv_effector_stat_mv;

DROP TABLE IF EXISTS tmp_cv_stimpro_stat_mv;
CREATE TABLE tmp_cv_stimpro_stat_mv
SELECT e.cv AS cv
,ep.value AS tracker
,ep2.value AS stimulus_protocol
,COUNT(3) AS stimulus_protocol_count
FROM experiment_vw e
JOIN experiment_property_vw ep ON (e.id=ep.experiment_id AND ep.type='tracker')
JOIN experiment_property_vw ep2 ON (e.id=ep2.experiment_id AND ep2.type='stimulus_protocol') GROUP BY 1,2,3;
DROP TABLE IF EXISTS cv_stimpro_stat_mv;
RENAME TABLE tmp_cv_stimpro_stat_mv TO cv_stimpro_stat_mv;

DROP TABLE IF EXISTS tmp_cv_plot_stat_mv;
CREATE TABLE tmp_cv_plot_stat_mv
SELECT cv.name AS cv
,ep.value AS tracker
,ip.value AS plot_type
,ip2.value AS product
,COUNT(4) AS num_plots
FROM experiment e
JOIN cv_term cvt ON (e.type_id=cvt.id)
JOIN cv ON (cvt.cv_id=cv.id)
JOIN experiment_property_vw ep ON (e.id=ep.experiment_id AND ep.type='tracker')
JOIN image i ON (e.id=i.experiment_id)
JOIN image_property_vw ip ON (i.id=ip.image_id AND ip.type='plot_type')
JOIN image_property_vw ip2 ON (i.id=ip2.image_id AND ip2.type='product') GROUP BY 1,2,3,4;
DROP TABLE IF EXISTS cv_plot_stat_mv;
RENAME TABLE tmp_cv_plot_stat_mv TO cv_plot_stat_mv;
