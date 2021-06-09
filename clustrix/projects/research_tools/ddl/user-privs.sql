-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON research_tools.* TO toolsAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW, LOCK TABLES ON research_tools.* TO toolsApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON research_tools.* TO toolsRead@'%';
