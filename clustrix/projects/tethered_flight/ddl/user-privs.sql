-- Apply User Privileges
-- ====================== --
GRANT ALL PRIVILEGES ON tethered_flight.* TO tethered_flightAdmin@'%';
GRANT SELECT ON information_schema.* TO tethered_flightAdmin@'%';
GRANT SELECT ON system.* TO tethered_flightAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE,SHOW VIEW ON tethered_flight.* TO tethered_flightApp@'%';
GRANT SELECT ON information_schema.* TO tethered_flightApp@'%';
GRANT SELECT ON system.* TO tethered_flightApp@'%';
GRANT SELECT,SHOW VIEW,EXECUTE ON tethered_flight.* TO tethered_flightRead@'%';
GRANT SELECT ON information_schema.* TO tethered_flightRead@'%';
GRANT SELECT ON system.* TO tethered_flightRead@'%';
