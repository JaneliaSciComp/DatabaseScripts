ALTER table sage.experiment add column o_id int;
INSERT INTO sage.experiment (name,type_id,protocol,lab_id,experimenter,create_date,o_id)
SELECT concat(name,'_',create_date),sage.getCvTermId('fly_olympiad_box','box',null),protocol,sage.getCvTermId('lab','olympiad',null),experimenter,create_date,id FROM olympiad.experiment;

INSERT INTO sage.experiment_property(experiment_id,type_id,value,create_date)
SELECT se.id,sage.getCvTermId('fly_olympiad_box',oep.type,null),oep.value,oep.create_date FROM olympiad.experiment_property oep join sage.experiment se on ( se.o_id = oep.experiment_id);

ALTER table sage.phase add column o_id int;
INSERT INTO sage.phase(experiment_id,name,type_id,create_date,o_id)
SELECT se.id,os.name,sage.getCvTermId('fly_olympiad_box','sequence_24',null),os.create_date,os.id FROM olympiad.sequence os join sage.experiment se on ( se.o_id = os.experiment_id) join olympiad.sequence_property osp on (osp.sequence_id = os.id and value ='24');

INSERT INTO sage.phase(experiment_id,name,type_id,create_date,o_id)
SELECT se.id,os.name,sage.getCvTermId('fly_olympiad_box','sequence_34',null),os.create_date,os.id FROM olympiad.sequence os join sage.experiment se on ( se.o_id = os.experiment_id) join olympiad.sequence_property osp on (osp.sequence_id = os.id and value ='34');

INSERT INTO sage.phase_property(phase_id,type_id,value,create_date)
SELECT sp.id,sage.getCvTermId('fly_olympiad_box',osp.type,null),osp.value,osp.create_date FROM olympiad.sequence_property osp join sage.phase sp on (sp.o_id = osp.sequence_id);

ALTER table sage.session add column o_id int;
INSERT INTO sage.session(name,type_id,line_id,experiment_id,lab_id,create_date,o_id)
SELECT ore.name,sage.getCvTermId('fly_olympiad_box','region',null),line.id,se.id,sage.getCvTermId('lab','olympiad',null),ore.create_date,ore.id FROM olympiad.region ore join sage.experiment se on ( se.o_id = ore.experiment_id) join sage.line on (line.name = concat('GMR_',substring(ore.line,1,11)) collate latin1_general_cs);

INSERT INTO sage.session(name,type_id,line_id,experiment_id,lab_id,create_date,o_id)
SELECT ore.name,sage.getCvTermId('fly_olympiad_box','region',null),line.id,se.id,sage.getCvTermId('lab','olympiad',null),ore.create_date,ore.id FROM olympiad.region ore join sage.experiment se on ( se.o_id = ore.experiment_id) join sage.line on (line.name = concat(substring(ore.line,1,1),'1118') collate latin1_general_cs);

INSERT INTO sage.session_property(session_id,type_id,value,create_date)
SELECT ss.id,sage.getCvTermId('fly_olympiad_box',orp.type,null),orp.value,orp.create_date  FROM olympiad.region_property orp join sage.session ss on (ss.o_id = orp.region_id);


INSERT INTO sage.score_array(session_id,phase_id,term_id,type_id,value,data_type,row_count,column_count,create_date)
SELECT ss.id,sp.id,sage.getCvTermId('fly_olympiad_box','not applicable',null),sage.getCvTermId('fly_olympiad_box',os.type,null),os.array_value,os.data_type,os.row_count,os.column_count,os.create_date FROM olympiad.score os join sage.session ss on (ss.o_id = os.region_id) join sage.phase sp on (sp.o_id = os.sequence_id);


ALTER table sage.experiment drop column o_id;
ALTER table sage.phase drop column o_id;
ALTER table sage.session drop column o_id;


