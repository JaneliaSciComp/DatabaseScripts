-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON miner.* TO minerAdmin@'localhost' identified by 'm1n3rAdm1n';
GRANT ALL PRIVILEGES ON miner.* TO minerAdmin@'%' identified by 'm1n3rAdm1n';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON miner.* TO minerApp@'localhost' identified by 'm1n3rApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON miner.* TO minerApp@'%' identified by 'm1n3rApp';

GRANT SELECT,SHOW VIEW,EXECUTE ON miner.* TO minerRead@'localhost' identified by 'minerRead';
GRANT SELECT,SHOW VIEW,EXECUTE ON miner.* TO minerRead@'%' identified by 'minerRead';
