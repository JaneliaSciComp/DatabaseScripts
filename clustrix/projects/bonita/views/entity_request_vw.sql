CREATE OR REPLACE VIEW entity_request_vw AS
SELECT e.id               AS id
      ,e.name             AS name
      ,type.name          AS cv_term
      ,name.value         AS request_name
      ,details.value      AS request_details
      ,e.actor_name       AS actor_name
      ,e.create_date      AS create_date
FROM entity e
JOIN entity_property name ON (name.entity_id=e.id)
JOIN cv_term cname ON (name.type_id = cname.id AND cname.name = 'Request.requestName')
JOIN entity_property details ON (details.entity_id=e.id)
JOIN cv_term cdetails ON (details.type_id = cdetails.id AND cdetails.name = 'Request.requestDetails')
JOIN cv_term type ON (e.type_id = type.id)
;
