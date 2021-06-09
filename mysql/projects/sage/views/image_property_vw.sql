CREATE OR REPLACE VIEW image_property_vw AS
SELECT ip.id        AS id
      ,ip.image_id  AS image_id
      ,cv.name      AS cv
      ,cv_term.name AS type
      ,ip.value     AS value
FROM image_property ip
JOIN cv_term ON (ip.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
