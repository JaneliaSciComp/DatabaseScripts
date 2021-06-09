CREATE OR REPLACE VIEW media_property_vw AS
SELECT mp.id
      ,mp.media_id
      ,m.name as media
      ,mp.type_id
      ,ct.name as type
      ,mp.value
FROM media_property mp
JOIN media m on (mp.media_id = m.id)
JOIN cv_term ct ON (mp.type_id = ct.id)
;
