

CREATE OR REPLACE VIEW mounting_property_vw AS
SELECT event_id
      ,MAX(IF(STRCMP(type,'brain'),null,value)) AS 'brain'
      ,MAX(IF(STRCMP(type,'vnc'),null,value)) AS 'vnc'
      ,MAX(IF(STRCMP(type,'cns'),null,value)) AS 'cns'
      ,MAX(IF(STRCMP(type,'notes'),null,value)) AS 'mounting_notes'
FROM event_property
GROUP BY event_id;

CREATE OR REPLACE VIEW mounting_slide_vw AS
select slide.id
      ,batch.id batch_id
      ,batch.name
      ,slide.member
      ,slot.position
      ,is_redo
      ,line.id line_id
      ,line.name line
      ,brain
      ,vnc
      ,cns
      ,mounting_notes
from slide 
join slot on (slide.id=slide_id) 
join batch on (batch.id = slide.batch_id) 
join line on (slot.line_id = line.id) 
join event e on (e.line_id = line.id and e.batch_id = batch.id and e.process in ('Mounting','Redo') and e.action='out')
join mounting_property_vw on (mounting_property_vw.event_id = e.id);
