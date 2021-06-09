-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON flynet.* TO flynetAdmin@'%';
GRANT SELECT ON information_schema.* TO flynetAdmin@'%';
GRANT SELECT ON system.* TO flynetAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON flynet.* TO flynetApp@'%';
GRANT SELECT ON information_schema.* TO flynetApp@'%';
GRANT SELECT ON system.* TO flynetApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON flynet.* TO flynetRead@'%';
GRANT SELECT ON information_schema.* TO flynetRead@'%';
GRANT SELECT ON system.* TO flynetRead@'%';
