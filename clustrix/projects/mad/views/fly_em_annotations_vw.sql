-- =================================================
-- substack data
-- =================================================
DROP TABLE IF EXISTS tmp_substack_mv;

CREATE TABLE tmp_substack_mv AS
SELECT m.name              AS substack
      ,s.name              AS stack
      ,lab.name            AS lab
      ,MAX(IF(STRCMP(ctp.name,'resolution'),null,sp.value)) AS 'resolution'
      ,MAX(IF(STRCMP(ctp.name,'roi_name'),null,sp.value)) AS 'roi_name'
FROM media m
JOIN cv_term ct on (ct.id = m.type_id and ct.name = 'substack')
JOIN cv_term lab on (lab.id = m.type_id)
LEFT JOIN media_relationship mr on (m.id = mr.object_id)
LEFT JOIN media s on (s.id = mr.subject_id)
LEFT JOIN media_property sp on (s.id = sp.media_id)
LEFT JOIN cv_term ctp on (ctp.id = sp.type_id)
GROUP BY m.id
;

CREATE INDEX tmp_substack_mv_substack_ind ON tmp_substack_mv(substack);

-- =================================================
-- substack property data
-- =================================================
DROP TABLE IF EXISTS tmp_substack_property_mv;

CREATE TABLE tmp_substack_property_mv AS
SELECT m.name AS substack
      ,MAX(IF(STRCMP(ctp.name,'file_system_path'),null,mp.value)) AS 'file_system_path'
      ,MAX(IF(STRCMP(ctp.name,'height'),null,mp.value)) AS 'height'
      ,MAX(IF(STRCMP(ctp.name,'length'),null,mp.value)) AS 'length'
      ,MAX(IF(STRCMP(ctp.name,'medulla_column'),null,mp.value)) AS 'medulla_column'
      ,MAX(IF(STRCMP(ctp.name,'volume'),null,mp.value)) AS 'volume'
      ,MAX(IF(STRCMP(ctp.name,'width'),null,mp.value)) AS 'width'
      ,MAX(IF(STRCMP(ctp.name,'x'),null,mp.value)) AS 'x'
      ,MAX(IF(STRCMP(ctp.name,'y'),null,mp.value)) AS 'y'
      ,MAX(IF(STRCMP(ctp.name,'z'),null,mp.value)) AS 'z'
FROM media m
JOIN cv_term ct on (ct.id = m.type_id and ct.name = 'substack')
JOIN media_property mp on (m.id = mp.media_id)
JOIN cv_term ctp on (ctp.id = mp.type_id)
GROUP BY m.id
;

CREATE INDEX tmp_substack_property_mv_substack_ind ON tmp_substack_property_mv(substack);

-- =================================================
-- substack annotation data
-- =================================================
DROP TABLE IF EXISTS tmp_substack_annotation_mv;

CREATE TABLE tmp_substack_annotation_mv AS
SELECT m.name AS substack
      ,MAX(IF(STRCMP(ctp.name,'focused_annot'),null,a.value)) AS 'focused_annot'
      ,MAX(IF(STRCMP(ctp.name,'focused_annot'),null,s.complete_date)) AS 'focused_annot_complete_date' 
      ,MAX(IF(STRCMP(ctp.name,'psd_annot'),null,a.value)) AS 'psd_annot'
      ,MAX(IF(STRCMP(ctp.name,'psd_annot'),null,s.complete_date)) AS 'psd_annot_complete_date' 
      ,MAX(IF(STRCMP(ctp.name,'tbar_annot'),null,a.value)) AS 'tbar_annot'
      ,MAX(IF(STRCMP(ctp.name,'tbar_annot'),null,s.complete_date)) AS 'tbar_annot_complete_date' 
      ,MAX(IF(STRCMP(ctp.name,'synapse_annot'),null,a.value)) AS 'synapse_annot'
      ,MAX(IF(STRCMP(ctp.name,'synapse_annot'),null,s.complete_date)) AS 'synapse_annot_complete_date' 
FROM media m
JOIN cv_term ct on (ct.id = m.type_id and ct.name = 'substack')
JOIN annotation a on (m.id = a.media_id and a.is_current = 1)
JOIN assignment s on (a.assignment_id = s.id)
JOIN cv_term ctp on (ctp.id = a.type_id)
GROUP BY m.id
;

CREATE INDEX tmp_substack_annotation_mv_substack_ind ON tmp_substack_annotation_mv(substack);

-- =================================================
-- fly em annotations data
-- =================================================
DROP TABLE IF EXISTS tmp_fly_em_annotations_mv;

CREATE TABLE tmp_fly_em_annotations_mv
SELECT s.substack
      ,s.stack
      ,s.lab
      ,s.resolution
      ,s.roi_name
      ,sp.file_system_path
      ,sp.height
      ,sp.length
      ,sp.medulla_column
      ,sp.volume
      ,sp.width
      ,sp.x
      ,sp.y
      ,sp.z
      ,cast(ifnull(sa.focused_annot,0) as unsigned) focused_annot
      ,sa.focused_annot_complete_date
      ,cast(ifnull(sa.psd_annot,0) as unsigned) psd_annot
      ,sa.psd_annot_complete_date
      ,cast(ifnull(sa.tbar_annot,0) as unsigned) tbar_annot
      ,sa.tbar_annot_complete_date
      ,cast(ifnull(sa.synapse_annot,0) as unsigned) synapse_annot
      ,sa.synapse_annot_complete_date
FROM tmp_substack_mv s
LEFT JOIN tmp_substack_property_mv sp on (s.substack = sp.substack)
LEFT JOIN tmp_substack_annotation_mv sa on (s.substack = sa.substack)
;

CREATE INDEX fly_em_annotations_mv_substack_ind ON tmp_fly_em_annotations_mv(substack);

-- =================================================
-- create mv
-- =================================================
DROP TABLE IF EXISTS tmp_substack_mv;
DROP TABLE IF EXISTS tmp_substack_property_mv;
DROP TABLE IF EXISTS tmp_substack_annotation_mv;

DROP TABLE IF EXISTS fly_em_annotations_mv;
RENAME TABLE tmp_fly_em_annotations_mv TO fly_em_annotations_mv;
-- TRUNCATE TABLE fly_em_annotations_mv;
-- INSERT INTO fly_em_annotations_mv SELECT * FROM tmp_fly_em_annotations_mv;
-- DROP TABLE IF EXISTS tmp_fly_em_annotations_mv;

CREATE OR REPLACE VIEW fly_em_annotations_vw AS
SELECT * FROM fly_em_annotations_mv;

