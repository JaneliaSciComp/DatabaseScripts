-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON meetingroom.* TO meetingroomAdmin@'localhost' identified by 'meetingroomAdmin';
GRANT ALL PRIVILEGES ON meetingroom.* TO meetingroomAdmin@'%' identified by 'meetingroomAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON meetingroom.* TO meetingroomApp@'localhost' identified by 'meetingroomApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON meetingroom.* TO meetingroomApp@'%' identified by 'meetingroomApp';

GRANT SELECT ON meetingroom.* TO meetingroomRead@'localhost' identified by 'meetingroomRead';
GRANT SELECT ON meetingroom.* TO meetingroomRead@'%' identified by 'meetingroomRead';
