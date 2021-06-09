-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON simpson_lemur.* TO lemurAdmin@'localhost' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON simpson_lemur.* TO lemurAdmin@'%' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON smith_lemur.* TO lemurAdmin@'localhost' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON smith_lemur.* TO lemurAdmin@'%' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON sternson_lemur.* TO lemurAdmin@'localhost' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON sternson_lemur.* TO lemurAdmin@'%' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON looger_lemur.* TO lemurAdmin@'localhost' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON looger_lemur.* TO lemurAdmin@'%' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON geci_lemur.* TO lemurAdmin@'localhost' identified by 'lemurAdmin';
GRANT ALL PRIVILEGES ON geci_lemur.* TO lemurAdmin@'%' identified by 'lemurAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON simpson_lemur.* TO lemurApp@'localhost' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON simpson_lemur.* TO lemurApp@'%' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON smith_lemur.* TO lemurApp@'localhost' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON smith_lemur.* TO lemurApp@'%' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON sternson_lemur.* TO lemurApp@'localhost' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON sternson_lemur.* TO lemurApp@'%' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON looger_lemur.* TO lemurApp@'localhost' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON looger_lemur.* TO lemurApp@'%' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON geci_lemur.* TO lemurApp@'localhost' identified by 'sweetsweetprimers';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON geci_lemur.* TO lemurApp@'%' identified by 'sweetsweetprimers';

GRANT SELECT ON simpson_lemur.* TO lemurRead@'localhost' identified by 'lemurRead';
GRANT SELECT ON simpson_lemur.* TO lemurRead@'%' identified by 'lemurRead';
GRANT SELECT ON smith_lemur.* TO lemurRead@'localhost' identified by 'lemurRead';
GRANT SELECT ON smith_lemur.* TO lemurRead@'%' identified by 'lemurRead';
GRANT SELECT ON sternson_lemur.* TO lemurRead@'localhost' identified by 'lemurRead';
GRANT SELECT ON sternson_lemur.* TO lemurRead@'%' identified by 'lemurRead';
GRANT SELECT ON looger_lemur.* TO lemurRead@'localhost' identified by 'lemurRead';
GRANT SELECT ON looger_lemur.* TO lemurRead@'%' identified by 'lemurRead';
GRANT SELECT ON geci_lemur.* TO lemurRead@'localhost' identified by 'lemurRead';
GRANT SELECT ON geci_lemur.* TO lemurRead@'%' identified by 'lemurRead';


