CREATE OR REPLACE VIEW cv_term_to_table_mapping_vw AS
SELECT cv_subject.name AS cv
      ,subject.id      AS cv_term_id
      ,subject.name    AS cv_term
      ,type.name       AS relationship
      ,object.name     AS schema_term 
FROM cv_term_relationship 
JOIN cv_term type ON (type.id = cv_term_relationship.type_id)
JOIN cv cv_type ON (cv_type.id = type.cv_id)
JOIN cv_term subject ON (subject.id = cv_term_relationship.subject_id)
JOIN cv cv_subject ON (cv_subject.id = subject.cv_id)
JOIN cv_term object ON (object.id = cv_term_relationship.object_id)
WHERE cv_type.name = 'schema'
;
