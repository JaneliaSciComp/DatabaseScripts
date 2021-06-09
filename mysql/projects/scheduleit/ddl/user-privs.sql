-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON scheduleit.* TO scheduleitAdmin@'localhost' identified by 'scheduleitAdmin';
GRANT ALL PRIVILEGES ON scheduleit.* TO scheduleitAdmin@'%' identified by 'scheduleitAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON scheduleit.* TO scheduleitApp@'localhost' identified by 'scheduleitApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON scheduleit.* TO scheduleitApp@'%' identified by 'scheduleitApp';

GRANT SELECT ON scheduleit.* TO scheduleitRead@'localhost' identified by 'scheduleitRead';
GRANT SELECT ON scheduleit.* TO scheduleitRead@'%' identified by 'scheduleitRead';
