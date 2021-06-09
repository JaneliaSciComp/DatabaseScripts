-- ============== --
-- Grant Privs    --
-- ============== --
GRANT ALL PRIVILEGES ON wiki.* TO wikiAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON wiki.* TO wikiApp@'%';
GRANT SELECT ON wiki.* TO wikiRead@'%';

GRANT ALL PRIVILEGES ON open_wiki.* TO wikiAdmin@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON open_wiki.* TO wikiApp@'%';
GRANT SELECT ON open_wiki.* TO wikiRead@'%';
