DROP FUNCTION IF EXISTS putOlympiadLethality;
DELIMITER //
CREATE DEFINER = sageAdmin FUNCTION putOlympiadLethality(runDate CHAR(255), labName CHAR(255), lineName CHAR(255), effector CHAR(255), stage  CHAR(255), temp CHAR(255), notes_behavioral TEXT, wish_list CHAR(255))
RETURNS TEXT
DETERMINISTIC
BEGIN
  DECLARE v_lab_id int;
  DECLARE v_lethality_id int;
  DECLARE v_line_id int;
  DECLARE v_exp_count int;
  DECLARE v_experiment_id int;
  DECLARE v_session_id int;

  SELECT getCvTermId('lab', 'olympiad', NULL) INTO v_lab_id; 
  SELECT getCvTermId('fly_olympiad_lethality', 'lethality', NULL) INTO v_lethality_id; 

  SELECT id FROM line WHERE name = lineName collate latin1_general_cs AND lab_id = getCvTermId('lab', labName, NULL) INTO v_line_id; 
  IF v_line_id is null then
  RETURN concat("line ",lineName," not found for ",labName);
  END IF;

  SELECT count(*) + 1 FROM experiment INTO v_exp_count; 

  INSERT INTO experiment (name, type_id, lab_id, experimenter) VALUES (concat('Lethality ', lineName, ' ', runDate, ' ', v_exp_count), v_lethality_id, v_lab_id, ''); 
  SELECT last_insert_id() INTO v_experiment_id; 

  INSERT INTO experiment_property (experiment_id, type_id, value) VALUES (v_experiment_id, getCvTermId('fly_olympiad_lethality', 'exp_datetime', NULL), runDate); 
  INSERT INTO experiment_property (experiment_id, type_id, value) VALUES (v_experiment_id, getCvTermId('fly_olympiad_lethality', 'temperature', NULL), temp); 
  INSERT INTO experiment_property (experiment_id, type_id, value) VALUES (v_experiment_id, getCvTermId('fly_olympiad_lethality', 'notes_behavioral', NULL), notes_behavioral); 

  INSERT INTO session (experiment_id, name, type_id, line_id, lab_id) VALUES (v_experiment_id, 'Lethality', v_lethality_id, v_line_id, v_lab_id); 
  SELECT last_insert_id() INTO v_session_id; 

  INSERT INTO session_property (session_id, type_id, value) VALUES (v_session_id, getCvTermId('fly_olympiad_lethality', 'effector', NULL), effector); 
  INSERT INTO session_property (session_id, type_id, value) VALUES (v_session_id, getCvTermId('fly_olympiad_lethality', 'wish_list', NULL), wish_list); 
  INSERT INTO observation (session_id, term_id, type_id, value) VALUES (v_session_id, getCvTermId('fly_olympiad_lethality', 'not_applicable', NULL), getCvTermId('fly_olympiad_lethality', 'stage_at_death', NULL), stage); 

  RETURN concat("",v_experiment_id);

END  //

DELIMITER ;

GRANT EXECUTE ON FUNCTION sage.putOlympiadLethality TO sageOlympiad@'localhost';
GRANT EXECUTE ON FUNCTION sage.putOlympiadLethality TO sageOlympiad@'%';
