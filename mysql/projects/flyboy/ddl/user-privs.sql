-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON flyboy.* TO flyfAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW, LOCK TABLES ON flyboy.* TO flyfApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON flyboy.* TO flyfRead@'%';

GRANT DROP ON flyboy.__Flystocks_Stock_Staging TO flyfApp@'%';
