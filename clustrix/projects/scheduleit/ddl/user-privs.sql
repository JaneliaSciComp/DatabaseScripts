-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON scheduleit.* TO scheduleitAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON scheduleit.* TO scheduleitApp@'%';
GRANT SELECT ON scheduleit.* TO scheduleitRead@'%';
