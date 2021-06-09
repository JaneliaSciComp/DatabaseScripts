DROP PROCEDURE IF EXISTS updateUsername;
DELIMITER //
CREATE DEFINER = wikiAdmin PROCEDURE updateUsername
(IN old_username CHAR(255), IN new_username CHAR(255))
DETERMINISTIC
BEGIN

  DECLARE _output TEXT DEFAULT '';
  DECLARE _count INT DEFAULT 0;


  -- ===================================
  -- run updates
  -- ===================================
   SELECT count(1) FROM ATTACHMENTS WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in ATTACHMENTS table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE ATTACHMENTS
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM ATTACHMENTS WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in ATTACHMENTS table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE ATTACHMENTS
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM CONTENT WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in CONTENT table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE CONTENT
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM CONTENT WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in CONTENT table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE CONTENT
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM CONTENT WHERE username = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in CONTENT table with a username of ",old_username,".");
   SELECT _output;

   UPDATE CONTENT
   SET username = new_username
   WHERE username = old_username;
   
   SELECT count(1) FROM EXTRNLNKS WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in EXTRNLNKS table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE EXTRNLNKS
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM EXTRNLNKS WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in EXTRNLNKS table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE EXTRNLNKS
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM LABEL WHERE owner = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in LABEL table with a owner of ",old_username,".");
   SELECT _output;

   UPDATE LABEL
   SET owner = new_username
   WHERE owner = old_username;
   
   SELECT count(1) FROM CONTENT_LABEL WHERE owner = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in CONTENT_LABEL table with a owner of ",old_username,".");
   SELECT _output;

   UPDATE CONTENT_LABEL
   SET owner = new_username
   WHERE owner = old_username;
   
   SELECT count(1) FROM LINKS WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in LINKS table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE LINKS
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM LINKS WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in LINKS table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE LINKS
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM NOTIFICATIONS WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in NOTIFICATIONS table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE NOTIFICATIONS
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM NOTIFICATIONS WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in NOTIFICATIONS table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE NOTIFICATIONS
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM PAGETEMPLATES WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in PAGETEMPLATES table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE PAGETEMPLATES
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM PAGETEMPLATES WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in PAGETEMPLATES table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE PAGETEMPLATES
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM SPACES WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in SPACES table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE SPACES
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM SPACES WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in SPACES table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE SPACES
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM SPACEPERMISSIONS WHERE permusername = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in SPACEPERMISSIONS table with a permusername of ",old_username,".");
   SELECT _output;

   UPDATE SPACEPERMISSIONS
   SET permusername = new_username
   WHERE permusername = old_username;
   
   SELECT count(1) FROM SPACEPERMISSIONS WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in SPACEPERMISSIONS table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE SPACEPERMISSIONS
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM SPACEPERMISSIONS WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in SPACEPERMISSIONS table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE SPACEPERMISSIONS
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM CONTENTLOCK WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in CONTENTLOCK table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE CONTENTLOCK
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM CONTENTLOCK WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in CONTENTLOCK table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE CONTENTLOCK
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
   SELECT count(1) FROM os_user WHERE username = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in os_user table with a username of ",old_username,".");
   SELECT _output;

   UPDATE os_user
   SET username = new_username
   WHERE username = old_username;
   
   SELECT count(1) FROM TRACKBACKLINKS WHERE creator = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in TRACKBACKLINKS table with a creator of ",old_username,".");
   SELECT _output;

   UPDATE TRACKBACKLINKS
   SET creator = new_username
   WHERE creator = old_username;
   
   SELECT count(1) FROM TRACKBACKLINKS WHERE lastmodifier = old_username INTO _count;
   SET _output = CONCAT("Updating ",_count," records in TRACKBACKLINKS table with a lastmodifier of ",old_username,".");
   SELECT _output;

   UPDATE TRACKBACKLINKS
   SET lastmodifier = new_username
   WHERE lastmodifier = old_username;
   
END//
DELIMITER ;
