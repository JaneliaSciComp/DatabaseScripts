-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON raveler.* TO ravelerAdmin@'localhost' identified by 'ravelerAdmin';
GRANT ALL PRIVILEGES ON raveler.* TO ravelerAdmin@'%' identified by 'ravelerAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE ON raveler.* TO ravelerApp@'localhost' identified by 'ravelerApp';
GRANT SELECT,INSERT,UPDATE,DELETE ON raveler.* TO ravelerApp@'%' identified by 'ravelerApp';

GRANT SELECT ON raveler.* TO ravelerRead@'localhost' identified by 'ravelerRead';
GRANT SELECT ON raveler.* TO ravelerRead@'%' identified by 'ravelerRead';

