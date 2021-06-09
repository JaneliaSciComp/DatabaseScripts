CREATE OR REPLACE VIEW line_batch_history_vw AS
select e.id as event_id
     , e.line_id
     , e.batch_id
from event e 
where e.process='Fixation'
  and e.action='in'
  and e.line_id is not null;
