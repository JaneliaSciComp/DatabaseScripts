CREATE OR REPLACE VIEW annotation_vw AS
SELECT a.id
      ,a.media_id
      ,m.name as media
      ,a.type_id
      ,ct.name as type
      ,a.value
      ,a.is_current
FROM annotation a
JOIN media m on (a.media_id = m.id)
JOIN cv_term ct ON (a.type_id = ct.id)
;
