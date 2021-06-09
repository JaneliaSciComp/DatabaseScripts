CREATE OR REPLACE VIEW experiment_relationship_vw AS
SELECT
    cv.id    AS context_id,
    cv.name  AS context,
    e1.id   AS subject_id,
    e1.name AS subject,
    cvt.id   AS relationship_id,
    cvt.name AS relationship,
    e2.id   AS object_id,
    e2.name AS object
FROM cv
   , experiment_relationship er
   , cv_term cvt
   , experiment e1
   , experiment e2
WHERE er.type_id = cvt.id
  AND er.subject_id = e1.id
  AND er.object_id = e2.id
  AND cvt.is_current = 1
  AND cv.id = cvt.cv_id
;
