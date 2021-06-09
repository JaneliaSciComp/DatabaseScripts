SELECT relname, seq_tup_read + idx_tup_fetch as total 
FROM pg_stat_user_tables 
WHERE seq_tup_read + idx_tup_fetch > 0 
ORDER BY total DESC LIMIT 10;
