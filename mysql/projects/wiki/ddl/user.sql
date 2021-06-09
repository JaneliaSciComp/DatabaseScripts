-- ============== --
-- Create Users   --
-- ============== --
-- internal wiki
CREATE USER wikiAdmin identified by 'dino name';

CREATE USER wikiApp identified by 'dino write';

CREATE USER wikiRead identified by 'usual';

-- external wiki and open wiki
CREATE USER wikiAdmin identified by 'dino name';
CREATE USER wikiApp identified by 'dino name write';
CREATE USER wikiRead identified by 'usual';
