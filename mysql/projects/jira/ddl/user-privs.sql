-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON jira.* TO jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON jira.* TO jiraApp@'%';
GRANT SELECT ON jira.* TO jiraRead@'%';

GRANT ALL PRIVILEGES ON issuetracker.* TO jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON issuetracker.* TO jiraApp@'%';
GRANT SELECT ON issuetracker.* TO jiraRead@'%';

GRANT ALL PRIVILEGES ON dbo.* TO jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON dbo.* TO jiraApp@'%';
GRANT SELECT ON dbo.* TO jiraRead@'%';

GRANT ALL PRIVILEGES ON jira44.* TO jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON jira44.* TO jiraApp@'%';
GRANT SELECT ON jira44.* TO jiraRead@'%';

GRANT ALL PRIVILEGES ON jira50.* TO jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON jira50.* TO jiraApp@'%';
GRANT SELECT ON jira50.* TO jiraRead@'%';

GRANT ALL PRIVILEGES ON jira505.* TO jiraAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON jira505.* TO jiraApp@'%';
GRANT SELECT ON jira505.* TO jiraRead@'%';
