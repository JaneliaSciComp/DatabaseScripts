-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON parts.* TO partsAdmin@'localhost' identified by 'partsAdmin';
GRANT ALL PRIVILEGES ON parts.* TO partsAdmin@'%' identified by 'partsAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE ON parts.* TO partsApp@'localhost' identified by 'partsApp';
GRANT SELECT,INSERT,UPDATE,DELETE ON parts.* TO partsApp@'%' identified by 'partsApp';

GRANT SELECT ON parts.* TO partsRead@'localhost' identified by 'partsRead';
GRANT SELECT ON parts.* TO partsRead@'%' identified by 'partsRead';
