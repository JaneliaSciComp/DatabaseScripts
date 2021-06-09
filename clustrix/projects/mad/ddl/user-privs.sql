-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON mad.* TO madAdmin@'%';
GRANT SELECT ON information_schema.* TO madAdmin@'%';
GRANT SELECT ON system.* TO madAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON mad.* TO madApp@'%';
GRANT SELECT ON information_schema.* TO madApp@'%';
GRANT SELECT ON system.* TO madApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON mad.* TO madRead@'%';
GRANT SELECT ON information_schema.* TO madRead@'%';
GRANT SELECT ON system.* TO madRead@'%';

