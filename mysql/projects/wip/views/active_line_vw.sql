CREATE OR REPLACE VIEW line_last_event_vw AS
SELECT line_id,
       MAX(id) AS id
FROM event
WHERE item_type = 'line'
GROUP BY line_id;

CREATE OR REPLACE VIEW active_line_vw AS
SELECT name,
       e.process,
       action,
       operator,
       e.create_date
FROM line l
JOIN event e ON (l.id=line_id)
JOIN line_last_event_vw lle ON (lle.id=e.id)
WHERE item_type='line'
ORDER BY l.create_date;
