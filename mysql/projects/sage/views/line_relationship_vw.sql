CREATE OR REPLACE VIEW line_relationship_vw AS
SELECT
    cv.id    AS context_id,
    cv.name  AS context,
    s1.id   AS subject_id,
    s1.name AS subject,
    cvt.id   AS relationship_id,
    cvt.name AS relationship,
    s2.id   AS object_id,
    s2.name AS object
FROM cv
   , line_relationship sr
   , cv_term cvt
   , line s1
   , line s2
WHERE sr.type_id = cvt.id
  AND sr.subject_id = s1.id
  AND sr.object_id = s2.id
  AND cvt.is_current = 1
  AND cv.id = cvt.cv_id
;
