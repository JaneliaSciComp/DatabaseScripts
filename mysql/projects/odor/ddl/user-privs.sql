-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON odor.* TO odorAdmin@'localhost' identified by '0d0rAdm1n';
GRANT ALL PRIVILEGES ON odor.* TO odorAdmin@'%' identified by '0d0rAdm1n';

GRANT SELECT,INSERT,UPDATE,DELETE ON odor.* TO odorApp@'localhost' identified by '0d0rApp';
GRANT SELECT,INSERT,UPDATE,DELETE ON odor.* TO odorApp@'%' identified by '0d0rApp';

GRANT SELECT ON odor.* TO odorRead@'localhost' identified by '0d0rR3@d';
GRANT SELECT ON odor.* TO odorRead@'%' identified by '0d0rR3@d';
