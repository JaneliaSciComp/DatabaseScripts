DELIMITER //

DROP FUNCTION IF EXISTS mergeScoreArrayFormat
//

CREATE DEFINER = sageAdmin FUNCTION mergeScoreArrayFormat
(score1_id int, score2_id int)
RETURNS CHAR(255)
DETERMINISTIC
BEGIN
  DECLARE v_data1_type_id int;
  DECLARE v_data1_rows int;
  DECLARE v_data1_columns int;
  DECLARE v_data1_format char(255);
  DECLARE v_data2_type_id int;
  DECLARE v_data2_rows int;
  DECLARE v_data2_columns int;
  DECLARE v_data2_format char(255);
  DECLARE v_data1_has_data int;
  DECLARE v_data2_has_data int;

  DECLARE out_data_format char(255);
  
  # Get the values and properties of the score arrays.
  SELECT type_id, row_count, column_count, data_type FROM score_array WHERE id = score1_id INTO v_data1_type_id, v_data1_rows, v_data1_columns, v_data1_format;
  SELECT type_id, row_count, column_count, data_type FROM score_array WHERE id = score2_id INTO v_data2_type_id, v_data2_rows, v_data2_columns, v_data2_format;
  
  SET v_data1_has_data = (v_data1_rows <> 0 AND v_data1_columns <> 0);
  SET v_data2_has_data = (v_data2_rows <> 0 AND v_data2_columns <> 0);
  
  # Make sure the score ararys are merge-able.
  IF v_data1_type_id <> v_data2_type_id THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'The score arrays to be merged must be the same type.';
  END IF;
  IF v_data1_has_data AND v_data2_has_data AND v_data1_format <> v_data2_format AND 
    (SUBSTRING(v_data1_format, 1, 3) != 'int' OR SUBSTRING(v_data2_format, 1, 3) != 'int') AND 
    (SUBSTRING(v_data1_format, 1, 4) != 'uint' OR SUBSTRING(v_data2_format, 1, 4) != 'uint') AND
    (SUBSTRING(v_data1_format, 1, 4) != 'str' OR SUBSTRING(v_data2_format, 1, 4) != 'str') THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'The score arrays to be merged must have equivalent formats.';
  END IF;
  IF (v_data1_rows > 1 AND v_data2_columns > 1) OR (v_data1_columns > 1 AND v_data2_rows > 1) THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'The score arrays to be merged must be a single column or a single row.';
  END IF;
  
  IF v_data1_has_data AND v_data2_has_data THEN
    IF SUBSTRING(v_data1_format, 1, 4) = 'uint' THEN
      SET out_data_format = IF(LENGTH(v_data1_format) > LENGTH(v_data2_format) OR (LENGTH(v_data1_format) = LENGTH(v_data2_format) AND SUBSTRING(v_data1_format, 5) > SUBSTRING(v_data2_format, 5)),  v_data1_format, v_data2_format);
    ELSE
      SET out_data_format = IF(LENGTH(v_data1_format) > LENGTH(v_data2_format) OR (LENGTH(v_data1_format) = LENGTH(v_data2_format) AND SUBSTRING(v_data1_format, 4) > SUBSTRING(v_data2_format, 4)), v_data1_format, v_data2_format);
    END IF;
  ELSEIF v_data1_has_data THEN
    SET out_data_format = v_data1_format;
  ELSE
    SET out_data_format = v_data2_format;
  END IF;

  RETURN out_data_format;

END;
//

DELIMITER ;
