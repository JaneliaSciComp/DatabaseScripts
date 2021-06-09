CREATE OR REPLACE VIEW entity_vw AS
SELECT e.id               AS id
      ,e.name             AS name
      ,type.name          AS cv_term
      ,e.actor_name       AS actor_name
      ,e.create_date      AS create_date
FROM entity e
JOIN cv_term type ON (e.type_id = type.id)
;
