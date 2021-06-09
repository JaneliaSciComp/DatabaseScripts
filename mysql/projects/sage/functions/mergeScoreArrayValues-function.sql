DELIMITER //

DROP FUNCTION IF EXISTS mergeScoreArrayValues
//

CREATE DEFINER = sageAdmin FUNCTION  mergeScoreArrayValues
(score1_id int, score2_id int)
RETURNS TEXT
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
  DECLARE v_data1_has_data int;
  DECLARE v_data2_has_data int;
  
  DECLARE out_merged_scores mediumtext;
  
  -- Get the values and properties of the score arrays.
  SELECT uncompress(value), type_id, row_count, column_count, data_type FROM score_array WHERE id = score1_id INTO v_data1, v_data1_type_id, v_data1_rows, v_data1_columns, v_data1_format;
  SELECT uncompress(value), type_id, row_count, column_count, data_type FROM score_array WHERE id = score2_id INTO v_data2, v_data2_type_id, v_data2_rows, v_data2_columns, v_data2_format;
  
  SET v_data1_has_data = (v_data1_rows <> 0 AND v_data1_columns <> 0);
  SET v_data2_has_data = (v_data2_rows <> 0 AND v_data2_columns <> 0);
  
  -- Make sure the score arrays are merge-able.
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
  
  SET @field_width1 = IF(v_data1_has_data, LENGTH(v_data1) / v_data1_rows / v_data1_columns, 0);
  SET @field_width2 = IF(v_data2_has_data, LENGTH(v_data2) / v_data2_rows / v_data2_columns, 0);
  SET @field_width = IF(@field_width1 > @field_width2, @field_width1, @field_width2);
  SET @field_pad1 = SPACE(@field_width - @field_width1);
  SET @field_pad2 = SPACE(@field_width - @field_width2);
  
  SET out_merged_scores = '';
  
  IF v_data1_has_data OR v_data2_has_data THEN
    -- Figure out the dimensionality of the merged array.
    IF (v_data1_has_data AND v_data1_rows > 1) OR v_data2_rows > 1 THEN
      SET @is_rows = FALSE;
      SET @rows = IF(v_data1_rows > v_data2_rows, v_data1_rows, v_data2_rows);
      SET @columns = 2;
    ELSE
      SET @is_rows = TRUE;
      SET @rows = 2;
      SET @columns = IF(v_data1_columns > v_data2_columns, v_data1_columns, v_data2_columns);
    END IF;
    
    -- Calculate the dummy value for filling in empty cells.
    IF SUBSTRING(v_data1_format, 1, 3) = 'str' THEN
      SET @dummy_value = SPACE(@field_width - 1);
    ELSE
      SET @dummy_value = CONCAT(SPACE(@field_width - 4), 'NaN');
    END IF;
    
    -- Fill in the cells of the array.
    -- Shorter fields will be padded with spaces and empty cells will be filled with a dummy/placeholder value.
    SET @row = 0;
    WHILE @row < @rows DO
      SET @column = 0;
      WHILE @column < @columns DO
        IF @is_rows THEN
          -- We're merging two rows of data.
          IF @row = 0 THEN
            IF v_data1_has_data AND @column < v_data1_columns THEN
              SET @value = CONCAT(@field_pad1, SUBSTRING(v_data1, @column * @field_width1 + 1, @field_width1 - 1));
            ELSE
              SET @value = @dummy_value;
            END IF;
          ELSE
            IF v_data2_has_data AND @column < v_data2_columns THEN
              SET @value = CONCAT(@field_pad2, SUBSTRING(v_data2, @column * @field_width2 + 1, @field_width2 - 1));
            ELSE
              SET @value = @dummy_value;
            END IF;
          END IF;
        ELSE
          -- We're merging two columns of data.
          IF @column = 0 THEN
            IF v_data1_has_data AND @row < v_data1_rows THEN
              SET @value = CONCAT(@field_pad1, SUBSTRING(v_data1, @row * @field_width1 + 1, @field_width1 - 1));
            ELSE
              SET @value = @dummy_value;
            END IF;
          ELSE
            IF v_data2_has_data AND @row < v_data2_rows THEN
              SET @value = CONCAT(@field_pad2, SUBSTRING(v_data2, @row * @field_width2 + 1, @field_width2 - 1));
            ELSE
              SET @value = @dummy_value;
            END IF;
          END IF;
        END IF;
        SET @column = @column + 1;
        IF @column < @columns THEN
          SET out_merged_scores = CONCAT(out_merged_scores, @value, ' ');
        ELSE
          SET out_merged_scores = CONCAT(out_merged_scores, @value, '\n');
        END IF;
      END WHILE;
      SET @row = @row + 1;
    END WHILE;
  END IF;
  
  RETURN out_merged_scores;

END;
//

DELIMITER ;
