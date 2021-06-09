-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON galaxy.* TO galaxyAdmin@'%';
GRANT SELECT ON information_schema.* TO galaxyAdmin@'%';
GRANT SELECT ON system.* TO galaxyAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON galaxy.* TO galaxyApp@'%';
GRANT SELECT ON information_schema.* TO galaxyApp@'%';
GRANT SELECT ON system.* TO galaxyApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON galaxy.* TO galaxyRead@'%';
GRANT SELECT ON information_schema.* TO galaxyRead@'%';
GRANT SELECT ON system.* TO galaxyRead@'%';
