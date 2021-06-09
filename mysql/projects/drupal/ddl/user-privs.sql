-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON drupal.* TO drupalAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW, LOCK TABLES ON drupal.* TO drupalApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON drupal.* TO drupalRead@'%';

GRANT ALL PRIVILEGES ON drupal_fly_workstation.* TO drupalAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW, LOCK TABLES ON drupal_fly_workstation.* TO drupalApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON drupal_fly_workstation.* TO drupalRead@'%';
