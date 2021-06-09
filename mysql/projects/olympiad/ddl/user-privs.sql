-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON olympiad.* TO olympiadAdmin@'localhost' identified by '0lymp1@dAdm1n';
GRANT ALL PRIVILEGES ON olympiad.* TO olympiadAdmin@'%' identified by '0lymp1@dAdm1n';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON olympiad.* TO olympiadApp@'localhost' identified by '0lymp1@dApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON olympiad.* TO olympiadApp@'%' identified by '0lymp1@dApp';

GRANT SELECT ON olympiad.* TO olympiadRead@'localhost' identified by 'olympiadRead';
GRANT SELECT ON olympiad.* TO olympiadRead@'%' identified by 'olympiadRead';
