DROP PROCEDURE IF EXISTS xtab;
DELIMITER //
CREATE DEFINER = sageAdmin PROCEDURE xtab(`table_name` VARCHAR(32), `col_field` VARCHAR(32), `agg_func` VARCHAR(32),`value_field` VARCHAR(32)
                                               , `row_field` VARCHAR(256), `join` VARCHAR(1024), `mv_name` VARCHAR(256))
    DETERMINISTIC
    READS SQL DATA
    COMMENT 'Generate dynamic crosstabs'
BEGIN
    DECLARE `xtab_col_name`  VARCHAR(64)    DEFAULT '';
    DECLARE `xtab_col_alias` VARCHAR(64)    DEFAULT '';
    DECLARE `index_ddl`      text  DEFAULT '';
    DECLARE `xtab_query`     text  DEFAULT '';
    DECLARE `index_query`    text  DEFAULT '';
    DECLARE `done`           BIT(1)         DEFAULT 0;
    
    DECLARE `column_cursor` CURSOR FOR
        SELECT `temp_col_name`, `temp_col_alias` FROM `xtab_columns`;
    
    DECLARE `index_cursor` CURSOR FOR
             SELECT *  FROM `xtab_index`;


    DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = 1;

    -- We have to use a temporary table here as MySQL doesn't
    -- allow us to declare a cursor in prepared statements
    DROP TABLE IF EXISTS `xtab_columns`;
    SET @column_query := CONCAT('CREATE TEMPORARY TABLE `xtab_columns` ',
                                'SELECT DISTINCT ',
                                '`', `col_field`, '` AS `temp_col_name`, ',
                                '`', `col_field`, '` AS `temp_col_alias` FROM ',
                                `table_name`, 
                                ' WHERE ', `col_field`, '!=  \'gene\'');
    
    PREPARE `column_query` FROM @column_query;
    EXECUTE `column_query`;
    DEALLOCATE PREPARE `column_query`;
    

    SET `xtab_query` = CONCAT('SELECT ', row_field);

    OPEN `column_cursor`;
    column_loop: LOOP
        FETCH `column_cursor` INTO `xtab_col_name`, `xtab_col_alias`;
        IF `done` THEN LEAVE column_loop; END IF;
        SET `xtab_query` = CONCAT(`xtab_query`,',\n\t',
                                  `agg_func`, '(IF(`', `col_field`, '` = \'',
                                  `xtab_col_name`, '\', ',
                                  `value_field`, ', null)) AS `',
                                  `xtab_col_alias`,  '`');

    END LOOP column_loop;
    CLOSE `column_cursor`;
    
    SET `done` = 0;


    DROP TABLE IF EXISTS `xtab_columns`;

    SET @`mv_query` = CONCAT('DROP TABLE IF EXISTS ', `mv_name`);
    PREPARE `mv_query` FROM @mv_query;
    EXECUTE `mv_query`;
    DEALLOCATE PREPARE `mv_query`;
      
  
    SET `xtab_query` = CONCAT('CREATE TABLE ',`mv_name`, ' AS\n',
                              `xtab_query`, '\n FROM ',
                              `table_name`, '\t',
                              `join`, '\n GROUP BY image_vw.id'); -- TND only group by image_vw.id
    
    -- Uncomment the following line if you want to see the
    -- generated crosstab query for debugging purposes
    SELECT `xtab_query`;
    
    -- Execute crosstab
     SET @xtab_query = `xtab_query`;
     PREPARE `xtab` FROM @xtab_query;
     EXECUTE `xtab`;
     DEALLOCATE PREPARE `xtab`;

    SET @`idx_ddl` =  CONCAT('CREATE INDEX ',`mv_name`,'_id_ind on ',`mv_name`,'(id)');
    PREPARE `idx_ddl` FROM  @`idx_ddl`;
    EXECUTE `idx_ddl`;
    DEALLOCATE PREPARE `idx_ddl`;

END//
DELIMITER ;

