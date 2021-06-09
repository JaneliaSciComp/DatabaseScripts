-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON cms.* TO cmsAdmin@'localhost' identified by 'cmsAdm1n';
GRANT ALL PRIVILEGES ON cms.* TO cmsAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE ON cms.* TO cmsApp@'localhost' identified by 'm3g@tr0n';
GRANT SELECT,INSERT,UPDATE,DELETE ON cms.* TO cmsApp@'%';

GRANT SELECT ON cms.* TO cmsRead@'localhost' identified by 'cmsRead';
GRANT SELECT ON cms.* TO cmsRead@'%';
