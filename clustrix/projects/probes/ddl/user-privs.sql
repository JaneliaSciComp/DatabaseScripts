-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON probes.* TO probesAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON probes.* TO probesApp@'%';
GRANT SELECT ON probes.* TO probesRead@'%';

GRANT SELECT ON information_schema.* TO probesAdmin@'%';
GRANT SELECT ON information_schema.* TO probesApp@'%';
GRANT SELECT ON information_schema.* TO probesRead@'%';

GRANT SELECT ON system.* TO probesAdmin@'%';
GRANT SELECT ON system.* TO probesApp@'%';
GRANT SELECT ON system.* TO probesRead@'%';
