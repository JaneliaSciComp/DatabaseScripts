-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON niko.* TO nikoAdmin@'%';
GRANT SELECT ON information_schema.* TO nikoAdmin@'%';
GRANT SELECT ON system.* TO nikoAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON niko.* TO nikoApp@'%';
GRANT SELECT ON information_schema.* TO nikoApp@'%';
GRANT SELECT ON system.* TO nikoApp@'%';
GRANT SELECT ON niko.* TO nikoRead@'%';
GRANT SELECT ON information_schema.* TO nikoRead@'%';
GRANT SELECT ON system.* TO nikoRead@'%';
