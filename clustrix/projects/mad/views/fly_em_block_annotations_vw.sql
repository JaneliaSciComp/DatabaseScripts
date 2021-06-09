-- =================================================
-- 
-- =================================================

CREATE OR REPLACE VIEW fly_em_block_annotations_vw AS
SELECT m.name              AS substack
      ,s.name              AS stack
      ,lab.name            AS lab
      ,sp.value            AS 'active_blocks'
      ,MAX(IF(STRCMP(ctp2.name,'focused_annot'),null,a.value)) AS 'focused_annot'
      ,MAX(IF(STRCMP(ctp2.name,'focused_annot'),null,s2.complete_date)) AS 'focused_annot_complete_date'
      ,MAX(IF(STRCMP(ctp2.name,'focused_annot'),NULL,a.user_id)) AS 'focused_annot_user_id' 
      ,CASE IFNULL(MAX(IF(STRCMP(ctp2.name,'focused_annot'),null,s2.complete_date)),0) WHEN 0 THEN NULL ELSE sp.value  END AS 'focused_block_annot'
      ,MAX(IF(STRCMP(ctp2.name,'psd_annot'),null,a.value)) AS 'psd_annot'
      ,MAX(IF(STRCMP(ctp2.name,'psd_annot'),null,s2.complete_date)) AS 'psd_annot_complete_date'
      ,MAX(IF(STRCMP(ctp2.name,'psd_annot'),NULL,a.user_id)) AS 'psd_annot_user_id' 
      ,CASE IFNULL(MAX(IF(STRCMP(ctp2.name,'psd_annot'),null,s2.complete_date)),0) WHEN 0 THEN NULL ELSE sp.value  END AS 'psd_block_annot'
      ,MAX(IF(STRCMP(ctp2.name,'tbar_annot'),null,a.value)) AS 'tbar_annot'
      ,MAX(IF(STRCMP(ctp2.name,'tbar_annot'),null,s2.complete_date)) AS 'tbar_annot_complete_date'
      ,MAX(IF(STRCMP(ctp2.name,'tbar_annot'),NULL,a.user_id)) AS 'tbar_annot_user_id' 
      ,CASE IFNULL(MAX(IF(STRCMP(ctp2.name,'tbar_annot'),null,s2.complete_date)),0) WHEN 0 THEN NULL ELSE sp.value  END AS 'tbar_block_annot'
      ,MAX(IF(STRCMP(ctp2.name,'focused-orphan_annot'),null,a.value)) AS 'focused_orphan_annot'
      ,MAX(IF(STRCMP(ctp2.name,'focused-orphan_annot'),null,s2.complete_date)) AS 'focused_orphan_annot_complete_date'
      ,MAX(IF(STRCMP(ctp2.name,'focused-orphan_annot'),NULL,a.user_id)) AS 'focused-orphan_annot_user_id' 
      ,CASE IFNULL(MAX(IF(STRCMP(ctp2.name,'focused-orphan_annot'),null,s2.complete_date)),0) WHEN 0 THEN NULL ELSE sp.value  END AS 'focused_orphan_block_annot'
FROM media m
JOIN cv_term ct on (ct.id = m.type_id and ct.name = 'substack')
JOIN cv_term lab on (lab.id = m.type_id)
JOIN media_relationship mr on (m.id = mr.object_id)
JOIN media s on (s.id = mr.subject_id)
JOIN media_property sp on (m.id = sp.media_id)
JOIN cv_term ctp on (ctp.id = sp.type_id and ctp.name = 'active_blocks')
JOIN annotation a on (m.id = a.media_id and a.is_current = 1)
LEFT JOIN assignment s2 on (a.assignment_id = s2.id)
LEFT JOIN cv_term ctp2 on (ctp2.id = a.type_id)
GROUP BY m.id
;
