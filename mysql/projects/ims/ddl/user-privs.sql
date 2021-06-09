-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON nighthawk.* TO nighthawkAdmin@'localhost' identified by 'nighthawkAdmin';
GRANT ALL PRIVILEGES ON nighthawk.* TO nighthawkAdmin@'%' identified by 'nighthawkAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON nighthawk.* TO nighthawkApp@'localhost' identified by 'nighthawkApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON nighthawk.* TO nighthawkApp@'%' identified by 'nighthawkApp';

GRANT SELECT ON nighthawk.* TO nighthawkRead@'localhost' identified by 'nighthawkRead';
GRANT SELECT ON nighthawk.* TO nighthawkRead@'%' identified by 'nighthawkRead';
