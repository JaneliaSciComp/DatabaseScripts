CREATE OR REPLACE VIEW cv_relationship_vw AS
SELECT
    cv.name   AS context,
    cvt1.name AS subject,
    cvt.name  AS relationship,
    cvt2.name AS object
FROM cv
, cv_relationship cr
, cv_term cvt
, cv_term cvt1
, cv_term cvt2
WHERE cr.type_id = cvt.id
  AND cr.subject_id = cvt1.id
  AND cr.object_id = cvt2.id
  AND cr.is_current = 1
  AND cvt.is_current = 1
  AND cvt1.is_current = 1
  AND cvt2.is_current = 1
  AND cv.id = cvt1.cv_id;
  
