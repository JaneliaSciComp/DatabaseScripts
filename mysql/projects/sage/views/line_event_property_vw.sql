CREATE OR REPLACE VIEW line_event_property_vw AS
SELECT lep.id           AS id
      ,le.event_id      AS event_id
      ,l.name           AS line
      ,cv.name          AS cv
      ,cv_term.name     AS type
      ,lep.value        AS value
      ,lep.create_date  AS create_date
FROM line_event_property lep
JOIN line_event le on (lep.line_event_id = le.id)
JOIN line l ON (le.line_id = l.id)
JOIN cv_term ON (lep.type_id = cv_term.id)
JOIN cv ON (cv_term.cv_id = cv.id)
;
