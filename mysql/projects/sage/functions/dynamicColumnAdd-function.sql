DELIMITER $$
DROP PROCEDURE IF EXISTS `dynamicColumnAdd` $$
CREATE PROCEDURE `dynamicColumnAdd`(tableName CHAR(255))
BEGIN
 DECLARE columnName TEXT;
 DECLARE noMoreColumns BOOLEAN DEFAULT FALSE;
 DECLARE columnNameCursor CURSOR FOR
  SELECT `column_name` FROM
    (
    SELECT `column_name`,`data_type`,`column_type`,COUNT(1) rowcount
    FROM information_schema.columns
    WHERE table_schema='sage' AND table_name IN ('image_incremental_data_mv','tmp_image_incremental_data_mv')
    GROUP BY `column_name`,`ordinal_position`,`data_type`,`column_type`
    HAVING COUNT(1)=1
    ) A;
 DECLARE CONTINUE HANDLER
  FOR 1329
  SET noMoreColumns = TRUE;
 OPEN columnNameCursor;
 columnNameCursorLoop: LOOP
 FETCH columnNameCursor INTO columnName;
  IF (noMoreColumns)
  THEN
   CLOSE columnNameCursor;
   LEAVE columnNameCursorLoop;
  END IF;
   
  SET @changeColStmt := CONCAT('ALTER TABLE ', tableName, ' ADD COLUMN ', columnName, ' text ', 'NULL');
  SELECT @changeColStmt;
  PREPARE changeColStmt FROM @changeColStmt;
  EXECUTE changeColStmt;
  DEALLOCATE PREPARE changeColStmt;
 END LOOP columnNameCursorLoop;
END $$
DELIMITER ;

