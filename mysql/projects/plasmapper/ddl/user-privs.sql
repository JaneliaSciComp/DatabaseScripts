-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON plasmapper.* TO plasmapperAdmin@'localhost' identified by 'plasmapperAdmin';
GRANT ALL PRIVILEGES ON plasmapper.* TO plasmapperAdmin@'%' identified by 'plasmapperAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE ON plasmapper.* TO plasmapperApp@'localhost' identified by 'plasmapperApp';
GRANT SELECT,INSERT,UPDATE,DELETE ON plasmapper.* TO plasmapperApp@'%' identified by 'plasmapperApp';

GRANT SELECT ON plasmapper.* TO plasmapperRead@'localhost' identified by 'plasmapperRead';
GRANT SELECT ON plasmapper.* TO plasmapperRead@'%' identified by 'plasmapperRead';
