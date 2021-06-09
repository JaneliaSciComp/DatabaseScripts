CREATE OR REPLACE VIEW entity_relationship_vw AS
SELECT er.id        AS id
    ,er.subject_id  AS subject_id
    ,er.type_id     AS type_id
    ,er.object_id   AS object_id
    ,e_subject.name AS subject
    ,cvt.name       AS type
    ,e_object.name  AS object
    ,er.create_date AS create_date
FROM entity_relationship er
  JOIN cv_term cvt ON (er.type_id = cvt.id)
  JOIN entity e_subject ON (er.subject_id = e_subject.id)
  JOIN entity e_object ON (er.object_id = e_object.id)
;
