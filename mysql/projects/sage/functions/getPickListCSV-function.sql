DROP PROCEDURE IF EXISTS getPickListCSV;
DELIMITER //
CREATE DEFINER = sageAdmin PROCEDURE getPickListCSV
(OUT o_string text,column_name CHAR(255), table_name CHAR(255))
DETERMINISTIC
BEGIN

 DECLARE v_value text DEFAULT '';
 DECLARE v_string text DEFAULT '';
 DECLARE done int DEFAULT 0;

 DECLARE values_cur CURSOR FOR 
  SELECT *
  FROM tmp_picklist_vw
  ORDER BY 1;
 DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

 SET @stmt_text=CONCAT('CREATE VIEW tmp_picklist_vw AS SELECT DISTINCT ', `column_name`, ' FROM ', `table_name`);
 PREPARE stmt FROM @stmt_text;
 EXECUTE stmt; 
 DEALLOCATE PREPARE stmt;

 OPEN values_cur;
   REPEAT
     FETCH values_cur INTO v_value;
       IF NOT done THEN
         IF (v_string = '') THEN
           SET v_string := v_value;
         ELSE
           SET v_string := CONCAT(v_string,", ",v_value);
         END IF;
       END IF;
     UNTIL done END REPEAT; 
 CLOSE values_cur;


 SET @stmt_text=CONCAT('DROP VIEW IF EXISTS tmp_picklist_vw');
 PREPARE stmt FROM @stmt_text;
 EXECUTE stmt; 
 DEALLOCATE PREPARE stmt;

 SET o_string = v_string;

END;
//
DELIMITER ;
