CREATE OR REPLACE VIEW media_relationship_vw AS
SELECT mr.id
      ,mr.subject_id
      ,s.name as subject
      ,mr.type_id
      ,ct.name as relationship
      ,mr.object_id
      ,o.name as object
FROM media_relationship mr
JOIN media s on (mr.subject_id = s.id)
JOIN media o on (mr.object_id = o.id)
JOIN cv_term ct ON (mr.type_id = ct.id)
;
