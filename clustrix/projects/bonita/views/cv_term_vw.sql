CREATE OR REPLACE VIEW cv_term_vw AS
SELECT
    cv.name          AS cv,
    cvt.id           AS id,
    cvt.name         AS cv_term,
    cvt.definition   AS definition,
    cvt.display_name AS display_name,
    cvt.data_type    AS data_type,
    cvt.is_current   AS is_current,
    cvt.create_date  AS create_date
FROM cv
   , cv_term cvt
WHERE cv.id = cvt.cv_id
;
