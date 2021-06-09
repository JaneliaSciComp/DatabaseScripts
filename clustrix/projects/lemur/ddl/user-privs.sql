-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON ahrens_lemur.* TO lemurAdmin@'%';
GRANT ALL PRIVILEGES ON geci_lemur.* TO lemurAdmin@'%';
GRANT ALL PRIVILEGES ON looger_lemur.* TO lemurAdmin@'%';
GRANT ALL PRIVILEGES ON simpson_lemur.* TO lemurAdmin@'%';
GRANT ALL PRIVILEGES ON smith_lemur.* TO lemurAdmin@'%';
GRANT ALL PRIVILEGES ON sternson_lemur.* TO lemurAdmin@'%';
GRANT ALL PRIVILEGES ON zhang_lemur.* TO lemurAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON ahrens_lemur.* TO lemurApp@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON geci_lemur.* TO lemurApp@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON looger_lemur.* TO lemurApp@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON simpson_lemur.* TO lemurApp@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON smith_lemur.* TO lemurApp@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON sternson_lemur.* TO lemurApp@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON zhang_lemur.* TO lemurApp@'%';

GRANT SELECT ON ahrens_lemur.* TO lemurRead@'%';
GRANT SELECT ON geci_lemur.* TO lemurRead@'%';
GRANT SELECT ON looger_lemur.* TO lemurRead@'%';
GRANT SELECT ON simpson_lemur.* TO lemurRead@'%';
GRANT SELECT ON smith_lemur.* TO lemurRead@'%';
GRANT SELECT ON sternson_lemur.* TO lemurRead@'%';
GRANT SELECT ON zhang_lemur.* TO lemurRead@'%';

GRANT SELECT ON system.* TO lemurAdmin@'%';
GRANT SELECT ON system.* TO lemurApp@'%';
GRANT SELECT ON system.* TO lemurRead@'%';

GRANT SELECT ON information_schema.* TO lemurAdmin@'%';
GRANT SELECT ON information_schema.* TO lemurApp@'%';
GRANT SELECT ON information_schema.* TO lemurRead@'%';
