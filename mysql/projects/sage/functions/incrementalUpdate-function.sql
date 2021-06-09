DELIMITER $$
DROP PROCEDURE IF EXISTS `dynamicCursorFix` $$
CREATE DEFINER = sageAdmin PROCEDURE `dynamicCursorFix`(tableName1 CHAR(255), tableName2 CHAR(255))
BEGIN
 DECLARE columnName TEXT;
 DECLARE noMoreColumns BOOLEAN DEFAULT FALSE;
 DECLARE columnNameCursor CURSOR FOR
 SELECT `COLUMN_NAME`
  FROM `information_schema`.`COLUMNS`
  WHERE (`TABLE_SCHEMA` = 'sage')
   AND (`TABLE_NAME` = tableName2);
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
   
  SET @changeColStmt := CONCAT('UPDATE ', tableName1, ',', tableName2, ' SET ', tableName1, '.', columnName, ' = ', tableName2, '.', columnName, ' WHERE ', tableName1, '.', 'id', ' = ', tableName2, '.', 'id');
  SELECT @changeColStmt;
  PREPARE changeColStmt FROM @changeColStmt;
  EXECUTE changeColStmt;
  DEALLOCATE PREPARE changeColStmt;
 END LOOP columnNameCursorLoop;
END $$
DELIMITER ;


