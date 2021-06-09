-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON campus_security.* TO securityAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON campus_security.* TO securityApp@'%';

GRANT SELECT ON campus_security.* TO securityRead@'%';
