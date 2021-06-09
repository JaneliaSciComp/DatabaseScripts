DELIMITER //

CREATE TRIGGER auditTrailLine AFTER UPDATE ON line
FOR EACH ROW
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_table_name, v_column_name, v_data_type CHAR(64);
  DECLARE table_def_cur CURSOR FOR  SELECT table_name, column_name, column_type FROM information_schema.columns WHERE table_name='line' and table_schema='wip';
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  OPEN table_def_cur;

  REPEAT
    FETCH table_def_cur INTO v_table_name, v_column_name, v_data_type;
     IF NOT done THEN
        IF v_column_name = 'batch_id' THEN
           IF (STRCMP(IFNULL(LOWER(old.batch_id),''),IFNULL(LOWER(new.batch_id),'')) != 0 ) THEN
              INSERT INTO audit_trail (table_name,column_name,data_type,primary_identifier,old_value,new_value,modify_date)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.batch_id,new.batch_id,now());
           END IF;
        END IF;
     END IF;
  UNTIL done END REPEAT;

  CLOSE table_def_cur;
     
END;
//

DELIMITER ;
