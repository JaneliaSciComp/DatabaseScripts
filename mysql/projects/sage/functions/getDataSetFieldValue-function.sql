DROP PROCEDURE IF EXISTS getDataSetFieldValue;
DELIMITER //
CREATE DEFINER = sageAdmin PROCEDURE getDataSetFieldValue
(lab CHAR(255), family CHAR(255), data_set CHAR(255), column_name CHAR(255), table_name CHAR(255))
DETERMINISTIC
BEGIN

 DECLARE v_data_set_field_id INT;

 SET @stmt_text=CONCAT('CREATE VIEW tmp_picklist_vw AS SELECT DISTINCT ', `column_name`, ' FROM ', `table_name`);
 PREPARE stmt FROM @stmt_text;
 EXECUTE stmt; 
 DEALLOCATE PREPARE stmt;

 SELECT dsf.id 
 FROM data_set_field dsf
 JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = `data_set`)
 JOIN data_set_family df on (ds.family_id = df.id and df.name = `family`)
 JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = `lab` collate latin1_general_cs)
 JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
 WHERE dsf.name = `column_name` INTO v_data_set_field_id;

 DELETE FROM data_set_field_value WHERE data_set_field_id = v_data_set_field_id;

 INSERT INTO data_set_field_value (data_set_field_id,value)
 SELECT v_data_set_field_id, tmp_picklist_vw.*
 FROM tmp_picklist_vw;

 SET @stmt_text=CONCAT('DROP VIEW IF EXISTS tmp_picklist_vw');
 PREPARE stmt FROM @stmt_text;
 EXECUTE stmt; 
 DEALLOCATE PREPARE stmt;

END;
//
DELIMITER ;
