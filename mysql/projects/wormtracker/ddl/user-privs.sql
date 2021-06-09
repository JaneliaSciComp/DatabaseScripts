-- ===================== --
-- Grant Privs           --
-- ===================== --
GRANT ALL PRIVILEGES ON worm_tracker.* TO wormTrackerAdmin@'localhost' identified by 'wormTrackerAdmin';
GRANT ALL PRIVILEGES ON worm_tracker.* TO wormTrackerAdmin@'%' identified by 'wormTrackerAdmin';

GRANT SELECT,INSERT,UPDATE,DELETE ON worm_tracker.* TO wormTrackerApp@'localhost' identified by 'wormTrackerApp';
GRANT SELECT,INSERT,UPDATE,DELETE ON worm_tracker.* TO wormTrackerApp@'%' identified by 'wormTrackerApp';

GRANT SELECT ON worm_tracker.* TO wormTrackerRead@'localhost' identified by 'wormTrackerRead';
GRANT SELECT ON worm_tracker.* TO wormTrackerRead@'%' identified by 'wormTrackerRead';
