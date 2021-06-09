CREATE OR REPLACE VIEW secondary_image_vw AS
SELECT si.id          AS id
      ,si.name        AS name
      ,si.image_id    AS image_id
      ,cvt1.name      AS product
      ,si.path        AS path
      ,si.url         AS url
      ,si.create_date AS create_date
      ,i.name         AS parent
FROM secondary_image si
JOIN cv_term cvt1 ON (si.product_id = cvt1.id)
JOIN cv cv1 ON (cvt1.cv_id = cv1.id)
JOIN image i ON (si.image_id = i.id)
WHERE cv1.name = 'product'
; 
