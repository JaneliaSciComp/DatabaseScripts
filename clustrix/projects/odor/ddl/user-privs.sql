-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON odor.* TO odorAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE ON odor.* TO odorApp@'%';
GRANT SELECT ON odor.* TO odorRead@'%';
