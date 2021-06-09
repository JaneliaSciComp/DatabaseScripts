DELIMITER //

DROP PROCEDURE IF EXISTS climbTreeList
//

CREATE DEFINER = annotationAdmin PROCEDURE climbTreeList
(IN context CHAR(255), IN term CHAR(255))
DETERMINISTIC
BEGIN
  DECLARE v_id int DEFAULT 0;
  DECLARE v_level int DEFAULT 0;
  DECLARE v_position int DEFAULT 1;
  DECLARE v_row_count int DEFAULT 0;
  DECLARE v_connection_id int DEFAULT 0;

  DECLARE v_name text DEFAULT '';
  DECLARE v_in_clause text DEFAULT '';
  DECLARE done int DEFAULT 0;
  DECLARE cur_1 CURSOR FOR SELECT name FROM tmp_adjacency_list WHERE connection = v_connection_id ORDER BY path;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  -- table for storing the result
  CREATE TABLE IF NOT EXISTS tmp_adjacency_list( pk int unsigned not null auto_increment -- insertion order
                                               , id int unsigned                         -- id of the record
                                               , name char(255)                          -- name of record
                                               , path text                               -- path of record
                                               , level int unsigned                      -- level of search (depth)
                                               , position int unsigned                   -- position of this record within this level
                                               , connection int unsigned
                                               , primary key(pk)
                                               );

  -- get id of term passed in 
  SELECT cv_term.id FROM cv_term, cv WHERE cv.id = cv_term.cv_id AND cv.name = context AND cv_term.name = term INTO v_id;

  -- get database connection id
  SELECT CONNECTION_ID() INTO v_connection_id;

  -- discard contents from prior calls with same database connection id
  DELETE FROM tmp_adjacency_list WHERE connection = v_connection_id;

  -- insert our entrty record which acts as the root record
  INSERT INTO tmp_adjacency_list( id ,name , path, level , position, connection)
         VALUES (v_id,term,concat(term,'/'),v_level,v_position,v_connection_id);

  -- initialize our loop control variable
  SET v_row_count := row_count();

  -- iterate, breadth first
  WHILE v_row_count != 0 DO

    -- iterate, breadth first
    SET @position := 0;

    -- insert all children for the current level
    INSERT INTO tmp_adjacency_list( id , name, path, level , position, connection)
    SELECT al.object_id
         , cv_term.name
         , concat(tal.path,cv_term.name,'/')
         , v_level + 1
         , @position := @position+1
         , v_connection_id
    FROM cv_relationship al
    INNER JOIN cv_term ON al.object_id = cv_term.id
    INNER JOIN cv_term cv_term2 ON (al.type_id = cv_term2.id and cv_term2.name = 'part_of')
    INNER JOIN tmp_adjacency_list tal ON al.subject_id = tal.id
    WHERE tal.level = v_level
      AND tal.connection = v_connection_id
    ORDER BY al.id;

    -- update loop control.
    -- if there weren't any children of this level,
    -- no new rows were inserted, and the loop will terminate
    SET v_row_count := row_count();

    -- update the level
    SET v_level := v_level + 1;
  END WHILE;

  -- show the result
  OPEN cur_1;
    REPEAT
      FETCH cur_1 INTO v_name;
      IF NOT done THEN
         SET v_in_clause := CONCAT(v_in_clause,"'",v_name,"'");
      END IF;
    UNTIL done END REPEAT;
  CLOSE cur_1;

  SELECT REPLACE(v_in_clause,"''","','") as List;

  -- discard contents from prior calls with same database connection id
  DELETE FROM tmp_adjacency_list WHERE connection = v_connection_id;

END;
//

DELIMITER ;
