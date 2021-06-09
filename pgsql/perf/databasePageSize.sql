SELECT sum(relpages) as pages 
FROM pg_class, pg_shadow 
WHERE relowner = usesysid 
AND usename != 'postgres' 
ORDER BY pages DESC;
