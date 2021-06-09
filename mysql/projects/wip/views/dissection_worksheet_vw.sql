CREATE OR REPLACE VIEW dissection_event_property_vw AS
SELECT event_id
      ,MAX(IF(STRCMP(type,'brain'),null,value)) AS 'brain'
      ,MAX(IF(STRCMP(type,'vnc'),null,value)) AS 'vnc'
      ,MAX(IF(STRCMP(type,'cns'),null,value)) AS 'cns'
      ,MAX(IF(STRCMP(type,'notes'),null,value)) AS 'notes'
FROM event_property
join event on (event.id = event_property.event_id and event.process = 'Dissection' and action='out')
GROUP BY event_id;


CREATE OR REPLACE VIEW mounting_event_property_vw AS
SELECT event_id
      ,MAX(IF(STRCMP(type,'brain'),null,value)) AS 'brain'
      ,MAX(IF(STRCMP(type,'vnc'),null,value)) AS 'vnc'
      ,MAX(IF(STRCMP(type,'cns'),null,value)) AS 'cns'
      ,MAX(IF(STRCMP(type,'notes'),null,value)) AS 'notes'
FROM event_property
join event on (event.id = event_property.event_id and event.process = 'Mounting' and action='out')
GROUP BY event_id;

CREATE OR REPLACE VIEW dissection_in_vw AS
select batch_id batch
      ,line_id line
      ,dissection_in.operator
      ,dissection_in.create_date
from event dissection_in 
WHERE dissection_in.process = 'Dissection' and dissection_in.action ='in';

CREATE OR REPLACE VIEW dissection_out_vw AS
select batch_id batch
      ,line_id line
      ,dissection_out.create_date
      ,dissection_event_property_vw.brain
      ,dissection_event_property_vw.vnc
      ,dissection_event_property_vw.cns
      ,dissection_event_property_vw.notes
from event dissection_out 
join dissection_event_property_vw on (dissection_event_property_vw.event_id = dissection_out.id)
WHERE dissection_out.process = 'Dissection' and dissection_out.action ='out';

CREATE OR REPLACE VIEW mounting_out_vw AS
select batch_id batch
      ,line_id line
      ,mounting_out.create_date
      ,mounting_event_property_vw.brain
      ,mounting_event_property_vw.vnc
      ,mounting_event_property_vw.cns
      ,mounting_event_property_vw.notes
from event mounting_out
join mounting_event_property_vw on (mounting_event_property_vw.event_id = mounting_out.id)
WHERE  mounting_out.process = 'Mounting' and mounting_out.action ='out';

CREATE OR REPLACE VIEW dissection_worksheet_vw AS
select batch.name batch
      ,line.name line
      ,dissection_in_vw.operator
      ,dissection_in_vw.create_date dissection_start
      ,dissection_out_vw.create_date dissection_completed
      ,dissection_out_vw.brain dissection_brain
      ,dissection_out_vw.vnc dissection_vnc
      ,dissection_out_vw.cns dissection_cns
      ,dissection_out_vw.notes dissection_notes
      ,mounting_out_vw.brain mounting_brain
      ,mounting_out_vw.vnc mounting_vnc
      ,mounting_out_vw.cns mounting_cns
      ,mounting_out_vw.notes mounting_notes
      ,mounting_out_vw.create_date mounting_completed
      ,mounting_slide_vw.member
from batch
join dissection_in_vw on (dissection_in_vw.batch = batch.id)
join line on (line.id = dissection_in_vw.line)
join dissection_out_vw on (dissection_out_vw.batch = dissection_in_vw.batch and dissection_out_vw.line = dissection_in_vw.line)
left join mounting_out_vw on (mounting_out_vw.batch = dissection_in_vw.batch and mounting_out_vw.line = dissection_in_vw.line)
left join mounting_slide_vw on (mounting_out_vw.line = mounting_slide_vw.line_id and mounting_out_vw.batch = mounting_slide_vw.batch_id);

