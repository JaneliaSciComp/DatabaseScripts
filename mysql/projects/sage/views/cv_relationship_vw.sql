CREATE OR REPLACE VIEW cv_relationship_vw AS
SELECT
    cv.id    AS context_id,
    cv.name  AS context,
    cv1.id   AS subject_id,
    cv1.name AS subject,
    cvt.id   AS relationship_id,
    cvt.name AS relationship,
    cv2.id   AS object_id,
    cv2.name AS object
FROM cv
   , cv_relationship cr
   , cv_term cvt
   , cv cv1
   , cv cv2
WHERE cr.type_id = cvt.id
  AND cr.subject_id = cv1.id
  AND cr.object_id = cv2.id
  AND cr.is_current = 1
  AND cvt.is_current = 1
  AND cv1.is_current = 1
  AND cv2.is_current = 1
  AND cv.id = cvt.cv_id
;
