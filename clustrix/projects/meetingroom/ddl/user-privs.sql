-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON meetingroom.* TO meetingroomAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON meetingroom.* TO meetingroomApp@'%';
GRANT SELECT ON meetingroom.* TO meetingroomRead@'%';

GRANT SELECT ON information_schema.* TO  meetingroomAdmin@'%';
GRANT SELECT ON information_schema.* TO  meetingroomApp@'%';
GRANT SELECT ON information_schema.* TO  meetingroomRead@'%';

GRANT SELECT ON system.* TO  meetingroomAdmin@'%';
GRANT SELECT ON system.* TO  meetingroomApp@'%';
GRANT SELECT ON system.* TO  meetingroomRead@'%';

