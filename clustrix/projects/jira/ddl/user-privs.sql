-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON jira44.* TO jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON jira44.* TO jiraApp@'%';
GRANT SELECT ON jira44.* TO jiraRead@'%';

GRANT ALL PRIVILEGES ON val_jira44.* TO val_jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON val_jira44.* TO val_jiraApp@'%';
GRANT SELECT ON val_jira44.* TO val_jiraRead@'%';
