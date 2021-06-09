-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON bonita_journal.* TO bonitaAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON bonita_journal.* TO bonitaApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON bonita_journal.* TO bonitaRead@'%';

GRANT ALL PRIVILEGES ON bonita_history.* TO bonitaAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON bonita_history.* TO bonitaApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON bonita_history.* TO bonitaRead@'%';

GRANT ALL PRIVILEGES ON xcmis.* TO bonitaAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON xcmis.* TO bonitaApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON xcmis.* TO bonitaRead@'%';

GRANT ALL PRIVILEGES ON val_bonita_journal.* TO val_bonitaAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON val_bonita_journal.* TO val_bonitaApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON val_bonita_journal.* TO val_bonitaRead@'%';

GRANT ALL PRIVILEGES ON val_bonita_history.* TO val_bonitaAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON val_bonita_history.* TO val_bonitaApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON val_bonita_history.* TO val_bonitaRead@'%';

GRANT ALL PRIVILEGES ON val_xcmis.* TO val_bonitaAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON val_xcmis.* TO val_bonitaApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON val_bonita_history.* TO val_xcmis@'%';
