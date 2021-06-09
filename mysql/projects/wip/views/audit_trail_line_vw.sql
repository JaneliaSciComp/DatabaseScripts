CREATE OR REPLACE VIEW audit_trail_line_vw AS
SELECT l.id
      ,l.name line
      ,b.name current_batch
      ,pb.name previous_batch
      ,at.modify_date  
FROM line l 
LEFT OUTER JOIN batch b on (l.batch_id = b.id)
INNER JOIN audit_trail at ON (at.primary_identifier = l.id and at.table_name = 'line') 
INNER JOIN batch pb on ( at.old_value = pb.id)
order by at.modify_date asc
;
