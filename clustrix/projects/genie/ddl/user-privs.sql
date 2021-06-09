-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON genie.* TO genieAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON genie.* TO genieApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON genie.* TO genieRead@'%';

