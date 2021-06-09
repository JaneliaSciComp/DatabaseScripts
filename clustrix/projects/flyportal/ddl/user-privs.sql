-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON flyportal.* TO flyportalAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON flyportal.* TO flyportalApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON flyportal.* TO flyportalRead@'%';

GRANT ALL PRIVILEGES ON flyportal.* TO val_flyportalAdmin@'%';
GRANT SELECT ON information_schema.* TO val_flyportalAdmin@'%';
GRANT SELECT ON system.* TO val_flyportalAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON flyportal.* TO val_flyportalApp@'%';
GRANT SELECT ON information_schema.* TO val_flyportalApp@'%';
GRANT SELECT ON system.* TO val_flyportalApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON flyportal.* TO val_flyportalRead@'%';
GRANT SELECT ON information_schema.* TO val_flyportalRead@'%';
GRANT SELECT ON system.* TO val_flyportalRead@'%';
