DELIMITER //

DROP PROCEDURE IF EXISTS getTreeList
//

CREATE DEFINER = voxelproofAdmin PROCEDURE getTreeList
(IN id INT, IN term_id INT)
DETERMINISTIC
BEGIN
  DECLARE v_id int DEFAULT id;
  DECLARE v_term_id int DEFAULT term_id;
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

  -- get database connection id
  SELECT CONNECTION_ID() INTO v_connection_id;

  -- discard contents from prior calls with same database connection id
  DELETE FROM tmp_adjacency_list WHERE connection = v_connection_id;

  -- insert our entrty record which acts as the root record
  INSERT INTO tmp_adjacency_list( id ,name , path, level , position, connection)
         VALUES (v_id,v_id,concat(v_id,'/'),v_level,v_position,v_connection_id);

  -- initialize our loop control variable
  SET v_row_count := row_count();

  -- iterate, breadth first
  WHILE v_row_count != 0 DO

    -- iterate, breadth first
    SET @position := 0;

    -- insert all children for the current level
    INSERT INTO tmp_adjacency_list( id , name, path, level , position, connection)
    SELECT al.subject_id
         , split_node1.id
         , concat(tal.path,split_node1.id,'/')
         , v_level + 1
         , @position := @position+1
         , v_connection_id
    FROM split_node_relationship al
    INNER JOIN split_node split_node1 ON al.subject_id = split_node1.id
    INNER JOIN cv_term split_node2 ON (al.type_id = split_node2.id)
    INNER JOIN tmp_adjacency_list tal ON al.object_id = tal.id
    WHERE tal.level = v_level
      AND tal.connection = v_connection_id
      AND al.type_id = v_term_id
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
