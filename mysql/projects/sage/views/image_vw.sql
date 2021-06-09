CREATE OR REPLACE VIEW image_vw AS
SELECT i.id             AS id
      ,i.name           AS name
      ,i.url            AS url
      ,i.path           AS path
      ,cvt1.name        AS source
      ,cvt2.name        AS family
      ,l.name           AS line
      ,lp.value         AS genotype
      ,i.capture_date   AS capture_date
      ,i.representative AS representative
      ,i.display        AS display
      ,i.created_by     AS created_by
      ,i.create_date    AS create_date
FROM image i
JOIN cv_term cvt1 ON (i.source_id = cvt1.id)
JOIN cv cv1 ON (cvt1.cv_id = cv1.id)
JOIN cv_term cvt2 ON (i.family_id = cvt2.id)
JOIN cv cv2 ON (cvt2.cv_id = cv2.id)
JOIN line l ON (i.line_id = l.id)
LEFT JOIN line_property lp ON (lp.line_id = l.id and lp.type_id = getcvtermid('line','genotype',NULL))
WHERE cv1.name = 'lab'
  AND cv2.name = 'family'
;
