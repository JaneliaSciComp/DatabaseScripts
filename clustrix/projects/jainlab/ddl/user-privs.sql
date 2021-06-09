-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON jainlab.* TO jainlabAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON jainlab.* TO jainlabApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON jainlab.* TO jainlabRead@'%';

GRANT SELECT ON information_schema.* TO jainlabAdmin@'%';
GRANT SELECT ON system.* TO jainlabAdmin@'%';
GRANT SELECT ON information_schema.* TO jainlabApp@'%';
GRANT SELECT ON system.* TO jainlabApp@'%';
GRANT SELECT ON information_schema.* TO jainlabRead@'%';
GRANT SELECT ON system.* TO jainlabRead@'%';
