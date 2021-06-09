-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON campussecurity.* TO securityAdmin@'localhost' identified by 's3cur1tyAdm1n';
GRANT ALL PRIVILEGES ON campussecurity.* TO securityAdmin@'%' identified by 's3cur1tyAdm1n';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON campussecurity.* TO securityApp@'localhost' identified by 's3cur1tyApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON campussecurity.* TO securityApp@'%' identified by 's3cur1tyApp';

GRANT SELECT ON campussecurity.* TO securityRead@'localhost' identified by 'securityRead';
GRANT SELECT ON campussecurity.* TO securityRead@'%' identified by 'securityRead';
