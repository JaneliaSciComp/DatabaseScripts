DELIMITER //

DROP PROCEDURE IF EXISTS sage.getScoreArrayResultSet
//
CREATE DEFINER=sageAdmin PROCEDURE sage.getScoreArrayResultSet 
(score_array_id INT)
DETERMINISTIC
BEGIN

  DECLARE v_connection_id INT DEFAULT 0;
  DECLARE v_table_name CHAR(255);

  DECLARE v_data_type CHAR(255);
  DECLARE v_row_count INT;
  DECLARE v_column_count INT;
  DECLARE v_score_array TEXT;

  DECLARE v_delimeter CHAR(255) DEFAULT '  ';
  DECLARE v_strlen INT;
  DECLARE v_loc INT;
  DECLARE temp TEXT;

  -- get database connection id
  SELECT CONNECTION_ID() INTO v_connection_id;
  
  -- create temp table
  SET v_table_name = CONCAT('tmp_',v_connection_id,'_',score_array_id);

  SET @v_sql = CONCAT ('CREATE TABLE ',v_table_name,' (results char(50))');
  PREPARE `v_sql` FROM @v_sql;
  EXECUTE `v_sql`;
  DEALLOCATE PREPARE `v_sql`;

  -- fetch score array
  SELECT data_type,row_count,column_count,uncompress(value)
  INTO v_data_type,v_row_count,v_column_count,v_score_array
  FROM score_array
  WHERE id = score_array_id;

  SET v_strlen = LENGTH(v_score_array);
  SET v_loc = v_strlen/v_row_count/v_column_count;

  -- build parsed array result set
  START TRANSACTION; 
  
    WHILE v_strlen > 0 DO
      IF v_loc = 0 THEN
        SET temp = (v_score_array);
        SET v_score_array = '';
        SET v_strlen = 0;
      ELSE
        SET temp = TRIM((SUBSTRING(v_score_array,1,v_loc)));
        SET v_score_array = (SUBSTRING(v_score_array FROM v_loc +1));
        SET v_strlen = LENGTH(v_score_array);
      END IF;

    -- insert parsed field into temp table
    SET @v_sql = CONCAT ('INSERT INTO ',v_table_name,' VALUES(','''',temp,'''',')');
    PREPARE `v_sql` FROM @v_sql;
    EXECUTE `v_sql`;
    DEALLOCATE PREPARE `v_sql`;

    END WHILE;
  -- end transaction 
  COMMIT;

  -- select results to pass to clients
  SET @v_sql = CONCAT ('SELECT * FROM ',v_table_name);
  PREPARE `v_sql` FROM @v_sql;
  EXECUTE `v_sql`;
  DEALLOCATE PREPARE `v_sql`;

  -- clean up temp table 
  SET @v_sql = CONCAT ('DROP TABLE ',v_table_name);
  PREPARE `v_sql` FROM @v_sql;
  EXECUTE `v_sql`;
  DEALLOCATE PREPARE `v_sql`;
  
END //
  
DELIMITER ;
