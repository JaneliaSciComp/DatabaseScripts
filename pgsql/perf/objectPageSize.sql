SELECT relname as object, relfilenode as fileId, relpages as pages, reltuples as tuples 
FROM pg_class, pg_shadow 
WHERE relowner = usesysid 
AND usename != 'postgres' 
ORDER BY pages DESC;

