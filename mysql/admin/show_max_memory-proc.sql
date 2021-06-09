DROP PROCEDURE show_max_memory;

DELIMITER //

CREATE PROCEDURE show_max_memory ( IN v_max_connections int,OUT max_memory DECIMAL(7,4)) 
BEGIN 
SELECT ( @@key_buffer_size + @@query_cache_size + @@tmp_table_size + @@innodb_buffer_pool_size + @@innodb_additional_mem_pool_size + @@innodb_log_buffer_size + v_max_connections * ( @@read_buffer_size + @@read_rnd_buffer_size + @@sort_buffer_size + @@join_buffer_size + @@binlog_cache_size + @@thread_stack ) ) / 1073741824 AS MAX_MEMORY_GB INTO max_memory; 
END//

DELIMITER ;

CALL show_max_memory(1,@show_max_memory);
SELECT @show_max_memory;
