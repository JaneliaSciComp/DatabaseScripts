CREATE OR REPLACE VIEW cv_term_relationship_vw AS
SELECT
    cv_subject.id    AS subject_context_id,
    cv_subject.name  AS subject_context,
    cvt_subject.id   AS subject_id,
    cvt_subject.name AS subject,
    cv_rel.id        AS relationship_context_id,
    cv_rel.name      AS relationship_context,
    cvt_rel.id       AS relationship_id,
    cvt_rel.name     AS relationship,
    cv_object.id     AS object_context_id,
    cv_object.name   AS object_context,
    cvt_object.id    AS object_id,
    cvt_object.name  AS object
FROM cv_term_relationship cr
   , cv_term cvt_rel
   , cv cv_rel
   , cv_term cvt_subject
   , cv cv_subject
   , cv_term cvt_object
   , cv cv_object
WHERE cr.type_id = cvt_rel.id
  AND cv_rel.id = cvt_rel.cv_id
  AND cr.subject_id = cvt_subject.id
  AND cv_subject.id = cvt_subject.cv_id
  AND cr.object_id = cvt_object.id
  AND cv_object.id = cvt_object.cv_id
  AND cr.is_current = 1
  AND cvt_rel.is_current = 1
  AND cvt_subject.is_current = 1
  AND cvt_object.is_current = 1
;
