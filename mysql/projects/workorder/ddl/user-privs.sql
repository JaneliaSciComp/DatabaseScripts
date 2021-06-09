-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON workorder.* TO workorderAdmin@'localhost' identified by 'workorderAdmin';
GRANT ALL PRIVILEGES ON workorder.* TO workorderAdmin@'%' identified by 'workorderAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE ON workorder.* TO workorderApp@'localhost' identified by 'workorderApp';
GRANT SELECT,INSERT,UPDATE,DELETE ON workorder.* TO workorderApp@'%' identified by 'workorderApp';

GRANT FILE ON *.* TO workorderApp@'localhost' identified by 'workorderApp';
GRANT FILE ON *.* TO workorderApp@'%' identified by 'workorderApp';

GRANT SELECT ON workorder.* TO workorderRead@'localhost' identified by 'workorderRead';
GRANT SELECT ON workorder.* TO workorderRead@'%' identified by 'workorderRead';
