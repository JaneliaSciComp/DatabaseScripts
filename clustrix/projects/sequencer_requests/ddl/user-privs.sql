-- =================== --
-- Grant Privs         --
-- =================== --
GRANT ALL PRIVILEGES ON sequencer_requests.* TO sequencerAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW  ON sequencer_requests.* TO sequencerApp@'%';
GRANT SELECT ON sequencer_requests.* TO sequencerRead@'%';

GRANT SELECT ON information_schema.* TO sequencerAdmin@'%';
GRANT SELECT ON information_schema.* TO sequencerApp@'%';
GRANT SELECT ON information_schema.* TO sequencerRead@'%';

GRANT SELECT ON system.* TO sequencerAdmin@'%';
GRANT SELECT ON system.* TO sequencerApp@'%';
GRANT SELECT ON system.* TO sequencerRead@'%';
