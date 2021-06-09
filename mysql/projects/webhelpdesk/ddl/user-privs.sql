-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON webhelpdesk.* TO webhelpdeskAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON webhelpdesk.* TO webhelpdeskApp@'%';
GRANT SELECT ON webhelpdesk.* TO webhelpdeskRead@'%';
