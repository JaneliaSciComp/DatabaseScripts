/* Run in read committed isolation */
set transaction isolation level read committed;

/* Update rearing protocol values */
update session_property set value = 'RP_Olympiad_v001p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc1';
update session_property set value = 'RP_Olympiad_v002p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc2';
update session_property set value = 'RP_Olympiad_v003p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc3';
update session_property set value = 'RP_Olympiad_v004p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc4';
update session_property set value = 'RP_Olympiad_v005p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc5';
update session_property set value = 'RP_Olympiad_v006p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc6';
update session_property set value = 'RP_Olympiad_v007p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc7';
update session_property set value = 'RP_Olympiad_v008p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc8';
update session_property set value = 'RP_Olympiad_v009p0.xlsx' where type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL) and value = 'rc9';

/* Update experiment protocol values */
update experiment e, experiment_property ep set ep.value = 'EP_Box_v003p0.xlsx' where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL)  and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'protocol', NULL) and ep.value = '3.0';
update experiment e, experiment_property ep set ep.value = 'EP_Box_v003p1.xlsx' where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL)  and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'protocol', NULL) and ep.value = '3.1';
update experiment e, experiment_property ep set ep.value = 'EP_Box_v004p0.xlsx' where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL)  and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'protocol', NULL) and ep.value = '4.0';
update experiment e, experiment_property ep set ep.value = 'EP_Box_v004p1.xlsx' where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL)  and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'protocol', NULL) and ep.value = '4.1';
update experiment e, experiment_property ep set ep.value = 'EP_Box_v010p2.xlsx' where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL)  and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'protocol', NULL) and ep.value = '10.2';

/* Update experiment property CV terms */
update experiment e, experiment_property ep set ep.type_id = getCvTermId('fly_olympiad_box', 'exp_datetime', NULL) where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'date_time', NULL);
update experiment e, experiment_property ep set ep.type_id = getCvTermId('fly_olympiad_box', 'experimenter', NULL) where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'operator', NULL);
update experiment e, experiment_property ep set ep.type_id = getCvTermId('fly_olympiad_box', 'flag_review', NULL)  where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'questionable_data', NULL);
update experiment e, experiment_property ep set ep.type_id = getCvTermId('fly_olympiad_box', 'flag_redo', NULL)    where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'redo_experiment', NULL);
update experiment e, experiment_property ep set ep.type_id = getCvTermId('fly_olympiad_box', 'flag_aborted', NULL) where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'halt_early', NULL);
update experiment e, experiment_property ep set ep.type_id = getCvTermId('fly_olympiad_box', 'box', NULL)          where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'box_name', NULL);
update experiment e, experiment_property ep set ep.type_id = getCvTermId('fly_olympiad_box', 'apparatus_id', NULL) where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = ep.experiment_id and ep.type_id = getCvTermId('fly_olympiad_box', 'top_plate_id', NULL);

/* Update phase property CV terms */
select id from cv where name='fly_olympiad_box' into @olympiad_cv_id;
select id from cv where name='fly' into @fly_cv_id;
update cv_term set cv_id = @fly_cv_id, name = 'temperature_setpoint' where cv_id = @olympiad_cv_id and name = 'setpoint';
update experiment e, phase p, phase_property pp set pp.type_id = getCvTermId('fly_olympiad_box', 'temperature_setpoint', NULL) where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = p.experiment_id and pp.phase_id = p.id and pp.type_id = getCvTermId('fly_olympiad_box', 'temperature', NULL);

/* Update session property CV terms */
update experiment e, session s, session_property sp set sp.type_id = getCvTermId('fly_olympiad_box', 'num_flies', NULL)        where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = s.experiment_id and sp.session_id = s.id and sp.type_id = getCvTermId('fly_olympiad_box', 'n', NULL);
update experiment e, session s, session_property sp set sp.type_id = getCvTermId('fly_olympiad_box', 'num_flies_dead', NULL)   where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = s.experiment_id and sp.session_id = s.id and sp.type_id = getCvTermId('fly_olympiad_box', 'n_dead', NULL);
update experiment e, session s, session_property sp set sp.type_id = getCvTermId('fly_olympiad_box', 'rearing_protocol', NULL) where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = s.experiment_id and sp.session_id = s.id and sp.type_id = getCvTermId('fly_olympiad_box', 'rearing', NULL);
update experiment e, session s, session_property sp set sp.type_id = getCvTermId('fly_olympiad_box', 'hours_starved', NULL)   where e.type_id =  getCvTermId('fly_olympiad_box', 'box', NULL) and e.id = s.experiment_id and sp.session_id = s.id and sp.type_id = getCvTermId('fly_olympiad_box', 'starved', NULL);

/* Fill in new required fields with default values */
insert into experiment_property (experiment_id, type_id, value) (select id, getCvTermId('fly_olympiad_box', 'flag_legacy', NULL), '1' from experiment_vw where type = 'box');
insert into experiment_property (experiment_id, type_id, value) (select id, getCvTermId('fly_olympiad_apparatus', 'room', NULL), '2C.310.2' from experiment_vw where type = 'box');
insert into experiment_property (experiment_id, type_id, value) (select id, getCvTermId('fly_olympiad_box', 'temperature', NULL), '-1' from experiment_vw where type = 'box');
insert into experiment_property (experiment_id, type_id, value) (select id, getCvTermId('fly_olympiad_box', 'humidity', NULL), '-1' from experiment_vw where type = 'box');
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'cross_date', NULL), '00000000T000000' from experiment e join session s on (s.experiment_id = e.id) where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL));
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'hours_sorted', NULL), '-1' from experiment e join session s on (s.experiment_id = e.id) where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL));
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'cross_barcode', NULL), '-1' from experiment e join session s on (s.experiment_id = e.id) where e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL));
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'flip_used', NULL), 'unknown' from experiment e join session s on (s.experiment_id = e.id) where  e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL));
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'wish_list', NULL), '-1' from experiment e join session s on (s.experiment_id = e.id) where  e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL));
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'robot_stock_copy', NULL), 'unknown' from experiment e join session s on (s.experiment_id = e.id) where  e.type_id = getCvTermId('fly_olympiad_box', 'box', NULL));

/* According to Billy, handling_protocol should be 'HP_Box_v002p0.xlsx' for sessions with the 'DL_UAS_GAL80ts_Kir21_23_0010' effector and 'HP_Box_v001p0.xlsx' otherwise. */
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'handling_protocol', NULL), 'HP_Box_v001p0.xlsx' from experiment_vw e join session s on (s.experiment_id = e.id) join session_property_vw sp on (sp.session_id = s.id and sp.type = 'effector' and sp.value <> 'DL_UAS_GAL80ts_Kir21_23_0010') where e.type = 'box');
insert into session_property (session_id, type_id, value) (select s.id, getCvTermId('fly_olympiad_box', 'handling_protocol', NULL), 'HP_Box_v002p0.xlsx' from experiment_vw e join session s on (s.experiment_id = e.id) join session_property_vw sp on (sp.session_id = s.id and sp.type = 'effector' and sp.value = 'DL_UAS_GAL80ts_Kir21_23_0010') where e.type = 'box');


select id from cv_term_vw where cv='fly_olympiad' and cv_term='effector' into @adult_effector_id;
select id from cv_term_vw where cv='larval_olympiad' and cv_term='effector' into @larval_effector_id;
update session_property set type_id=getCvTermId('fly', 'effector', NULL) where type_id=@adult_effector_id or type_id=@larval_effector_id;
update experiment_property set type_id=getCvTermId('fly', 'effector', NULL) where type_id=@adult_effector_id or type_id=@larval_effector_id;
update cv_term set is_current=0 where id=@adult_effector_id or id=@larval_effector_id;

