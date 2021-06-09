-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON parts.* TO partsAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON parts.* TO partsApp@'%';
GRANT SELECT ON parts.* TO partsRead@'%';

GRANT ALL PRIVILEGES ON val_parts.* TO val_partsAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON val_parts.* TO val_partsApp@'%';
GRANT SELECT ON val_parts.* TO val_partsRead@'%';
