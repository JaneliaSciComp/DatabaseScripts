CREATE OR REPLACE VIEW cv_term_validation_vw AS
SELECT cv_subject.name AS term_context
      ,subject.id AS term_id
      ,subject.name AS term
      ,type.name AS relationship
      ,object.name AS rule
FROM cv_term_relationship 
JOIN cv_term type ON (type.id = cv_term_relationship.type_id)
JOIN cv_term subject ON (subject.id = cv_term_relationship.subject_id)
JOIN cv cv_subject ON (cv_subject.id = subject.cv_id)
JOIN cv_term object ON (object.id = cv_term_relationship.object_id)
JOIN cv cv_type ON (cv_type.id = type.cv_id)
WHERE type.name = 'validated_by'
;
