CREATE OR REPLACE VIEW event_vw AS
SELECT e.id             AS id
      ,cv_term.name     AS process
      ,le.id            AS line_event_id 
      ,l.id             AS line_id
      ,l.name           AS line
      ,e.action         AS action
      ,e.operator       AS operator
      ,e.create_date    AS create_date
FROM event e
JOIN cv_term ON (e.process_id = cv_term.id)
JOIN line_event le ON (e.id = le.event_id)
JOIN line l on (l.id = le.line_id)
;
