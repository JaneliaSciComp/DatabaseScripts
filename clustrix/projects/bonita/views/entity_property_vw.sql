CREATE OR REPLACE VIEW entity_property_vw AS
SELECT ep.id          AS id
      ,e.id           AS entity_id
      ,e.name         AS name
      ,cv.name        AS cv
      ,cv_term.name   AS type
      ,ep.value       AS value
      ,ep.create_date AS create_date
FROM entity e
JOIN entity_property ep ON (ep.entity_id=e.id)
JOIN cv_term ON (ep.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
