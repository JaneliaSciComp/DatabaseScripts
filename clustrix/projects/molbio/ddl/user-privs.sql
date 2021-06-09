-- ===================== --
-- Apply User Privileges --
-- ===================== --
GRANT ALL PRIVILEGES ON ror.* TO rorAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON ror.* TO rorApp@'%';
GRANT SELECT ON ror.* TO rorRead@'%';

GRANT ALL PRIVILEGES ON molbio.* TO molbioAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON molbio.* TO molbioApp@'%';
GRANT SELECT ON molbio.* TO molbioRead@'%';

GRANT ALL PRIVILEGES ON val_ror.* TO val_rorAdmin@'%';
GRANT SELECT ON information_schema.* TO val_rorAdmin@'%';
GRANT SELECT ON system.* TO val_rorAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON val_ror.* TO val_rorApp@'%';
GRANT SELECT ON information_schema.* TO val_rorApp@'%';
GRANT SELECT ON system.* TO val_rorApp@'%';
GRANT SELECT ON val_ror.* TO val_rorRead@'%';
GRANT SELECT ON information_schema.* TO val_rorRead@'%';
GRANT SELECT ON system.* TO val_rorRead@'%';
