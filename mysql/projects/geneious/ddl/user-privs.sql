-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON geneious.* TO geneiousAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON geneious.* TO geneiousApp@'%';

GRANT SELECT,SHOW VIEW,EXECUTE ON geneious.* TO geneiousRead@'%';

