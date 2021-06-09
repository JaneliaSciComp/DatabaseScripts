-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON qstatworld.* TO qstatworldAdmin@'%';
GRANT SELECT ON information_schema.* TO qstatworldAdmin@'%';
GRANT SELECT ON system.* TO qstatworldAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON qstatworld.* TO qstatworldApp@'%';
GRANT SELECT ON information_schema.* TO qstatworldApp@'%';
GRANT SELECT ON system.* TO qstatworldApp@'%';

GRANT SELECT ON qstatworld.* TO qstatworldRead@'%';
GRANT SELECT ON information_schema.* TO qstatworldRead@'%';
GRANT SELECT ON system.* TO qstatworldRead@'%';
