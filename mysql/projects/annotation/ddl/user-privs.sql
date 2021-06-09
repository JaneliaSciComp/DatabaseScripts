-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON annotation.* TO annotationAdmin@'localhost' identified by 'annotationAdmin';
GRANT ALL PRIVILEGES ON annotation.* TO annotationAdmin@'%' identified by 'annotationAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON annotation.* TO annotationApp@'localhost' identified by 'annotationApp';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON annotation.* TO annotationApp@'%' identified by 'annotationApp';

GRANT SELECT ON annotation.* TO annotationRead@'localhost' identified by 'annotationRead';
GRANT SELECT ON annotation.* TO annotationRead@'%' identified by 'annotationRead';
