-- ====================== --
-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON niko.* TO nikoAdmin@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON niko.* TO nikoApp@'%';

GRANT SELECT ON niko.* TO nikoRead@'%';
