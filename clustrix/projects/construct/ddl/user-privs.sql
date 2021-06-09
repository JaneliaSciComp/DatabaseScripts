-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON construct.* TO constructAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW, LOCK TABLES ON construct.* TO constructApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON construct.* TO constructRead@'%';

GRANT SELECT ON information_schema.* TO constructAdmin@'%';
GRANT SELECT ON information_schema.* TO constructApp@'%';
GRANT SELECT ON information_schema.* TO constructRead@'%';

GRANT SELECT ON system.* TO constructAdmin@'%';
GRANT SELECT ON system.* TO constructApp@'%';
GRANT SELECT ON system.* TO constructRead@'%';
