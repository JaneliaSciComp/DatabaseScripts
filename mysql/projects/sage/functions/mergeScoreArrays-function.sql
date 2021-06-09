DELIMITER //

DROP PROCEDURE IF EXISTS mergeScoreArrays
//

CREATE DEFINER = sageAdmin PROCEDURE mergeScoreArrays
(IN score1_id int, IN score2_id int, OUT out_merged_scores mediumtext, OUT out_row_count int, OUT out_column_count int)
DETERMINISTIC
BEGIN
  DECLARE v_data1 mediumtext;
  DECLARE v_data1_type_id int;
  DECLARE v_data1_rows int;
  DECLARE v_data1_columns int;
  DECLARE v_data1_format char(255);
  DECLARE v_data2 mediumtext;
  DECLARE v_data2_type_id int;
  DECLARE v_data2_rows int;
  DECLARE v_data2_columns int;
  DECLARE v_data2_format char(255);
  
  # Get the values and properties of the score arrays.
  SELECT uncompress(value), type_id, row_count, column_count, data_type FROM score_array WHERE id = score1_id INTO v_data1, v_data1_type_id, v_data1_rows, v_data1_columns, v_data1_format;
  SELECT uncompress(value), type_id, row_count, column_count, data_type FROM score_array WHERE id = score2_id INTO v_data2, v_data2_type_id, v_data2_rows, v_data2_columns, v_data2_format;
  
  # Make sure the score ararys are merge-able.
  IF v_data1_type_id <> v_data2_type_id THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'The score arrays to be merged must be the same type.';
  END IF;
  IF v_data1_format <> v_data2_format THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'The score arrays to be merged must be the same format.';
  END IF;
  IF v_data1_rows <> v_data2_rows and v_data1_columns <> v_data2_columns THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'The score arrays to be merged must be the same dimensions.';
  END IF;
  IF v_data1_rows <> 1 and v_data1_columns <> 1 THEN
    SIGNAL SQLSTATE VALUE '45000' SET MESSAGE_TEXT = 'The score arrays to be merged must be a single column or a single row.';
  END IF;
  
  IF v_data1_rows = 1 THEN
    # Merge two rows together by simply concatenating them.
    SET out_merged_scores = concat(v_data1, v_data2);
    SET out_row_count = 2;
    SET out_column_count = v_data1_columns;
  ELSE
    # Merge two columns together value by value.
    SET out_merged_scores = REPLACE(v_data1, '\n', ' ');
    SET @field_width = LENGTH(out_merged_scores) / v_data1_rows;
    SET @row = 0;
    REPEAT
      SET @value2 = SUBSTRING(v_data2, @row * @field_width + 1, @field_width);
      SET out_merged_scores = INSERT(out_merged_scores, (@row * 2 + 1) * @field_width + 1, 0, @value2);
      SET @row = @row + 1;
    UNTIL @row = v_data1_rows
    END REPEAT;
    SET out_row_count = v_data1_rows;
    SET out_column_count = 2;
  END IF;
END;
//

DELIMITER ;
