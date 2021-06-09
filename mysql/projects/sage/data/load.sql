-- cv module
insert into sage.cv select * from annotation.cv;
insert into sage.cv_term select * from annotation.cv_term;
insert into sage.cv_term_relationship select * from annotation.cv_relationship;

-- annotation module
alter table session drop index session_type_uk_ind; -- LexA_Enhancer
insert into sage.session (id,name,type_id,annotator,lab,create_date) select id,name,type_id,annotator,lab,create_date from annotation.session;
insert into sage.session_property select * from annotation.session_property;
insert into sage.score select * from annotation.score;
insert into sage.observation select * from annotation.observation;

-- cv and relationship to schema 
insert into cv (name,definition) values ('schema','relationships defined in the schema');
insert into cv_term (cv_id,name) values (24,'annotated_with'),(24,'is_a'),(24,'observation'),(24,'score'),(24,'session'), (24,'session_property',(24,'region');
insert into cv_term_relationship (type_id,subject_id,object_id) select type_id, subject_id, object_id from (select distinct session.type_id subject_id from session) subject ,  (select id type_id from cv_term where name='is_a') type , (select id object_id from cv_term where name='session') object ;

insert into cv_term_relationship (type_id,subject_id,object_id) select type_id, subject_id, object_id from (select distinct type_id subject_id from session_property) subject ,  (select id type_id from cv_term where name='is_a') type , (select id object_id from cv_term where name='session_property') object ;

insert into cv_term_relationship (type_id,subject_id,object_id) select type_id, subject_id, object_id from (select distinct type_id subject_id from observation) subject ,  (select id type_id from cv_term where name='is_a') type , (select id object_id from cv_term where name='observation') object ;

insert into cv_term_relationship (type_id,subject_id,object_id) select type_id, subject_id, object_id from (select distinct type_id subject_id from score) subject ,  (select id type_id from cv_term where name='is_a') type , (select id object_id from cv_term where name='score') object ;

insert into cv_term_relationship (type_id,subject_id,object_id) select type_id, subject_id, object_id from (select cv_term.id subject_id from cv_term,cv where cv_id = cv.id and cv.name='prelim_annotation_terms') subject ,  (select id type_id from cv_term where name='is_a') type , (select id object_id from cv_term where name='region') object ;

-- view
create or replace view schema_cv_term_relationship_vw as select lab, project.name project, subject.id as cv_term_id, cv_subject.name cv, subject.name cv_term, type.name relationship, object.name schema_term from cv_term_relationship join cv_term type on type.id = type_id join cv_term subject on subject.id = subject_id join cv cv_subject on cv_subject.id = subject.cv_id join project_cv on cv_subject.id = project_cv.cv_id join project on project.id = project_id join cv_term object on object.id = object_id join cv cv_type on cv_type.id = type.cv_id where cv_type.name = 'schema';

-- view
create or replace view cv_relationship_vw as 
select subject.name subject, type.name relationship, object.name object from cv_relationship join cv_term type on type.id = type_id join cv subject on subject.id = subject_id join cv object on object.id = object_id ;

-- projects
insert into project (name,lab) values ('grooming','Simpson'),('prelim_annotation','Rubin'),('prelim_annotation','Lee'),('l3','Truman'),('courtship','Simpson'),('ipcr','Simpson'),('dissection','Fly Light');

insert into project_cv (project_id,cv_id) values (1,1),(2,6),(2,11),(2,12),(2,13),(3,11),(3,12),(3,13),(3,15),(4,19),(4,20),(5,21),(5,22),(5,23),(6,17),(7,18);

-- view
create or replace view project_cv_vw as select project.lab, project.name project, cv.name cv from project join project_cv on project_id = project.id join cv on cv_id = cv.id order by lab,project,cv;

-- namespace
insert into sage.namespace_sequence_number select * from nighthawk.namespace_sequence_number;

-- audit trail
insert into sage.audit_trail select * from annotation.audit_trail;

-- annotation symbol
insert into sage.annotation_symbol select * from annotation.annotation_symbol;

-- gene
insert into sage.gene (name,sequence) select distinct gene,max(sequence) from annotation.line group by gene;

DROP FUNCTION IF EXISTS getGeneId;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION getGeneId(name CHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_gene_id int;

  SELECT id FROM gene WHERE gene.name = name collate latin1_general_cs  INTO v_gene_id;

RETURN v_gene_id;

END//
DELIMITER ;

-- line
insert into sage.line (id,name,lab,gene_id,comment) select id,name,lab,getGeneId(gene),comment from  annotation.line;

insert into sage.line_property select * from annotation.line_property;

-- image
insert into sage.image (id,name,source_id,family_id,capture_date,representative,display,create_date,created_by,path,url,line_id)
select image.id,image.name,getCvTermId('nighthawk',image.source,image.source),getCvTermId('nighthawk',image.family,image.family),image.capture_date,image.representative,image.display,image.create_date, MAX(IF(STRCMP(image_property.type,'created_by'),null,image_property.value)) AS 'created_by', MAX(IF(STRCMP(image_property.type,'path'),null,image_property.value)) AS 'path', MAX(IF(STRCMP(image_property.type,'url'),null,image_property.value)) AS 'url',  getLineId(MAX(IF(STRCMP(image_property.type,'line'),null,image_property.value))) AS 'line_id' from  nighthawk.image,nighthawk.image_property where image_id = image.id group by image.id;


DROP FUNCTION IF EXISTS getLineId;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION getLineId(name CHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_line_id int;

  SELECT id FROM line WHERE line.name = name collate latin1_general_cs  INTO v_line_id;

  -- IF v_line_id is NULL THEN
  --   INSERT INTO line (name,lab) VALUES (name,'nighthawk');
  --   SELECT id FROM line WHERE line.name = name collate latin1_general_cs  INTO v_line_id;
  -- END IF;  

RETURN v_line_id;

END//
DELIMITER ;

insert into sage.attenuator select * from nighthawk.attenuator;

insert into sage.detector select * from nighthawk.detector;

insert into sage.laser select * from nighthawk.laser;

insert into sage.secondary_image select * from nighthawk.secondary_image;

insert into sage.image_property (image_id,type_id,value,create_date)
select image_id,getCvTermId('nighthawk',type,type),value,create_date from nighthawk.image_property where type not in ('created_by','path','url','line');

update session set image_id = getImageId(name);

DROP FUNCTION IF EXISTS getImageId;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION getImageId(name CHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_image_id int;

  SELECT id FROM image WHERE image.name like concat('%',name,'%') collate latin1_general_cs limit 1 INTO v_image_id;

  -- IF v_line_id is NULL THEN
  --   INSERT INTO line (name,lab) VALUES (name,'nighthawk');
  --   SELECT id FROM line WHERE line.name = name collate latin1_general_cs  INTO v_line_id;
  -- END IF;  

RETURN v_image_id;

END//
DELIMITER ;




