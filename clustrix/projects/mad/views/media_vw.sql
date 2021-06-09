CREATE OR REPLACE VIEW media_vw AS
SELECT m.id
      ,m.name
      ,lab_id
      ,lab.name as lab
      ,type_id
      ,ct.name as type
FROM media m
JOIN cv_term ct ON (m.type_id = ct.id)
JOIN cv_term lab ON (m.lab_id = lab.id)
;
