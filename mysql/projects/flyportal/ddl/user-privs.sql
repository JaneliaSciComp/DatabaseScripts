-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON flyportal.* TO flyportalAdmin@'localhost' identified by 'flyp0rt@lAdm1n';
GRANT ALL PRIVILEGES ON flyportal.* TO flyportalAdmin@'%' identified by 'flyp0rt@lAdm1n';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON flyportal.* TO flyportalApp@'localhost' identified by 'flyp0rt@lApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON flyportal.* TO flyportalApp@'%' identified by 'flyp0rt@lApp';

GRANT SELECT,SHOW VIEW,EXECUTE ON flyportal.* TO flyportalRead@'localhost' identified by 'flyportalRead';
GRANT SELECT,SHOW VIEW,EXECUTE ON flyportal.* TO flyportalRead@'%' identified by 'flyportalRead';
