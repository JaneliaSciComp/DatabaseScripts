CREATE OR REPLACE VIEW event_property_vw AS
SELECT ep.id            AS id
      ,ep.event_id      AS event_id
      ,cv.name          AS cv
      ,cv_term.name     AS type
      ,ep.value         AS value
      ,ep.create_date   AS create_date
FROM event_property ep
JOIN cv_term ON (ep.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
