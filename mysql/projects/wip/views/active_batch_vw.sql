CREATE OR REPLACE VIEW batch_last_event_vw AS
SELECT batch_id,
       MAX(id) AS id
FROM event
WHERE item_type = 'batch'
GROUP BY batch_id;

CREATE OR REPLACE VIEW batch_line_count_vw AS
SELECT batch_id,
       COUNT(id) AS linecount
FROM line
GROUP BY 1;

CREATE OR REPLACE VIEW active_batch_vw AS
SELECT name,
       alt_name,
       linecount,
       e.process,
       action,
       operator,
       pfa,
       e.create_date,
       comment
FROM batch b
JOIN event e ON (b.id=batch_id)
JOIN batch_last_event_vw ble ON (ble.id=e.id)
LEFT JOIN batch_line_count_vw blc ON (blc.batch_id=b.id)
WHERE item_type='batch'
  AND is_active=1
ORDER BY b.create_date;

