-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON jainlab.* TO jainlabAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON jainlab.* TO jainlabApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON jainlab.* TO jainlabRead@'%';
