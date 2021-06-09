DROP PROCEDURE IF EXISTS xtab;
DELIMITER //
CREATE DEFINER = nighthawkAdmin PROCEDURE xtab(`table_name` VARCHAR(32), `col_field` VARCHAR(32), `agg_func` VARCHAR(32),`value_field` VARCHAR(32)
                                               , `row_field` VARCHAR(256), `join` VARCHAR(256), `mv_name` VARCHAR(256))
    DETERMINISTIC
    READS SQL DATA
    COMMENT 'Generate dynamic crosstabs'
BEGIN
    DECLARE `xtab_col_name`  VARCHAR(32)    DEFAULT '';
    DECLARE `xtab_col_alias` VARCHAR(32)    DEFAULT '';
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
                              `join`, '\n GROUP BY ',
                              row_field);
    
    -- Uncomment the following line if you want to see the
    -- generated crosstab query for debugging purposes
    SELECT `xtab_query`;
    
    -- Execute crosstab
     SET @xtab_query = `xtab_query`;
     PREPARE `xtab` FROM @xtab_query;
     EXECUTE `xtab`;
     DEALLOCATE PREPARE `xtab`;

    SET @`vw_ddl` = 'CREATE OR REPLACE VIEW image_property_vw AS SELECT gene, image_property_mv.* FROM image_property_mv LEFT OUTER JOIN image_gene_vw ON (image_gene_vw.image_id  = image_property_mv.id)';
    PREPARE `vw_ddl` FROM @vw_ddl;
    EXECUTE `vw_ddl`;
    DEALLOCATE PREPARE `vw_ddl`;


    DROP TABLE IF EXISTS `xtab_index`;
    SET index_query := CONCAT('CREATE TEMPORARY TABLE `xtab_index` (`temp_index_ddl` text)',
                              'SELECT CONCAT(\'CREATE INDEX \', table_name, \'_\', column_name, \'_ind ON \', table_name, \'(`\', column_name,',
                              ' \'`\', IF(STRCMP(data_type,\'longtext\'),\'\',\'(767)\'), \')\') AS temp_index_ddl ',
                              ' FROM information_schema.columns where table_name = \'', `mv_name`,'\''); 

    SET @index_query = `index_query`;
    PREPARE `index_query` FROM @index_query;
    EXECUTE `index_query`;
    DEALLOCATE PREPARE `index_query`;

    OPEN `index_cursor`;
    index_loop: LOOP
  
         FETCH `index_cursor` INTO `index_ddl`;
         IF `done` THEN LEAVE index_loop; END IF;

         SET @`index_ddl` = `index_ddl`;
         PREPARE `create_index` FROM @index_ddl;
         EXECUTE `create_index`;
         DEALLOCATE PREPARE `create_index`;

    END LOOP index_loop;
    CLOSE `index_cursor`;


END//
DELIMITER ;

