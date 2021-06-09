-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON guid.* TO GUIDAdmin@'localhost' identified by 'GUIDAdminPassword';
GRANT ALL PRIVILEGES ON guid.* TO GUIDAdmin@'%' identified by 'GUIDAdminPassword';

GRANT SELECT,INSERT ON guid.* TO GUIDClient@'localhost' identified by 'GUIDClientPassword';
GRANT SELECT,INSERT ON guid.* TO GUIDClient@'%' identified by 'GUIDClientPassword';

GRANT SELECT ON guid.* TO GUIDServerQuery@'localhost' identified by 'GUIDServerQueryPassword';
GRANT SELECT ON guid.* TO GUIDServerQuery@'%' identified by 'GUIDServerQueryPassword';

