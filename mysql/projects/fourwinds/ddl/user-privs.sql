-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON fourwinds.* TO fourwindsAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON fourwinds.* TO fourwindsApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON fourwinds.* TO fourwindsRead@'%';

