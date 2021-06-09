-- insert into image_incremental_data_mv;
-- old insert statement that does not guarantee column ordering
-- caused offset issue on Feb 5 2015
-- INSERT INTO image_data_mv SELECT * FROM tmp_image_incremental_data_mv;
--
-- new dynamic insert which prevents data offset by explicitly listing out columns in insert statement

SET SESSION group_concat_max_len = 100000;

SELECT CONCAT('INSERT INTO image_data_mv (',GROUP_CONCAT(CONCAT('`',c.COLUMN_NAME,'`')), ')', '  SELECT ', GROUP_CONCAT(CONCAT('`',c.COLUMN_NAME,'`')), ' FROM tmp_image_incremental_data_mv;') 
INTO @insert_stmt 
FROM INFORMATION_SCHEMA.COLUMNS c 
WHERE c.TABLE_NAME = 'tmp_image_incremental_data_mv'
ORDER BY c.ORDINAL_POSITION;

SELECT @insert_stmt;

PREPARE stmt FROM @insert_stmt;
EXECUTE stmt;
