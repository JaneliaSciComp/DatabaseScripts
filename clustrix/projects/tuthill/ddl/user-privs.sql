-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON tuthill.* TO tuthillAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON tuthill.* TO tuthillApp@'%';

GRANT SELECT ON tuthill.* TO tuthillRead@'%';
