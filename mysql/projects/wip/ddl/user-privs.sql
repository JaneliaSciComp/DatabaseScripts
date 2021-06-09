-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON wip.* TO wipAdmin@'localhost' identified by 'w1pAdm1n';
GRANT ALL PRIVILEGES ON wip.* TO wipAdmin@'%' identified by 'w1pAdm1n';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON wip.* TO wipApp@'localhost' identified by 'w1pApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON wip.* TO wipApp@'%' identified by 'w1pApp';

GRANT SELECT ON wip.* TO wipRead@'localhost' identified by 'wipRead';
GRANT SELECT ON wip.* TO wipRead@'%' identified by 'wipRead';

GRANT ALL PRIVILEGES ON wip_geci.* TO wipAdmin@'localhost' identified by 'w1pAdm1n';
GRANT ALL PRIVILEGES ON wip_geci.* TO wipAdmin@'%' identified by 'w1pAdm1n';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON wip_geci.* TO wipApp@'localhost' identified by 'w1pApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON wip_geci.* TO wipApp@'%' identified by 'w1pApp';

GRANT SELECT ON wip_geci.* TO wipRead@'localhost' identified by 'wipRead';
GRANT SELECT ON wip_geci.* TO wipRead@'%' identified by 'wipRead';
