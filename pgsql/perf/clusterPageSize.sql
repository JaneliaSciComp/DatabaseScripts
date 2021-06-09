SELECT sum(relpages) as pages 
FROM pg_class, pg_shadow 
WHERE relowner = usesysid 
ORDER BY pages DESC;
