-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON job_manager.* TO job_managerAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW,TRUNCATE ON job_manager.* TO job_managerApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON job_manager.* TO job_managerRead@'%';

GRANT SELECT ON information_schema.* TO job_managerAdmin@'%';
GRANT SELECT ON system.* TO job_managerAdmin@'%';
GRANT SELECT ON information_schema.* TO job_managerApp@'%';
GRANT SELECT ON system.* TO job_managerApp@'%';
GRANT SELECT ON information_schema.* TO job_managerRead@'%';
GRANT SELECT ON system.* TO job_managerRead@'%';
