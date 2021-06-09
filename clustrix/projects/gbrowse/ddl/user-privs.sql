-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON gbrowse_login.* TO gbrowseAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON gbrowse_login.* TO gbrowseApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON gbrowse_login.* TO gbrowseRead@'%';

GRANT SELECT ON information_schema.* TO gbrowseAdmin@'%';
GRANT SELECT ON system.* TO gbrowseAdmin@'%';
