CREATE OR REPLACE VIEW assignment_vw AS
SELECT a.id
      ,an.user_id
      ,u.name as user
      ,an.id as annotation_id
      ,an.media_id
      ,cta.name as annotation
      ,a.type_id
      ,ct.name as type
      ,a.start_date
      ,a.complete_date
      ,a.is_complete
FROM assignment a
JOIN annotation an on (an.assignment_id = a.id)
JOIN user u on (an.user_id = u.id)
JOIN cv_term ct ON (a.type_id = ct.id)
JOIN cv_term cta ON (an.type_id = cta.id)
;
