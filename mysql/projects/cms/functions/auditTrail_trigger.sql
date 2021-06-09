-- ===========================================================================
-- Audit Table from Tom
-- ===========================================================================

DROP TABLE IF EXISTS `auditTrail`;

CREATE TABLE auditTrail (
  id BIGINT NOT NULL AUTO_INCREMENT,
  tableName  VARCHAR(50) NOT NULL,
  columnName VARCHAR(50) NOT NULL,
  dataType   VARCHAR(50) NOT NULL,
  primaryIdentifier BIGINT NOT NULL,
  oldValue   VARCHAR(500),
  newValue   VARCHAR(500),
  modifyDate DATETIME NOT NULL,
  PRIMARY KEY(id)
)
ENGINE INNODB;

DELIMITER //

-- DROP TRIGGER auditTrail_user;


CREATE TRIGGER auditTrail_user AFTER UPDATE ON user
FOR EACH ROW
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_table_name, v_column_name, v_data_type CHAR(64);
  DECLARE table_def_cur CURSOR FOR  SELECT table_name, column_name, column_type FROM information_schema.columns WHERE table_name='user';
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;

  OPEN table_def_cur;

  REPEAT
    FETCH table_def_cur INTO v_table_name, v_column_name, v_data_type;
     IF NOT done THEN
        IF v_column_name = 'nameTitle' THEN
           IF (STRCMP(IFNULL(LOWER(old.nameTitle),''),IFNULL(LOWER(new.nameTitle),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.nameTitle,new.nameTitle,now());
           END IF;
        END IF;
        IF v_column_name = 'firstName' THEN
           IF (STRCMP(IFNULL(LOWER(old.firstName),''),IFNULL(LOWER(new.firstName),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.firstName,new.firstName,now());
           END IF;
        END IF;
        IF v_column_name = 'middleInitial' THEN
           IF (STRCMP(IFNULL(LOWER(old.middleInitial),''),IFNULL(LOWER(new.middleInitial),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.middleInitial,new.middleInitial,now());
           END IF;
        END IF;
        IF v_column_name = 'lastName' THEN
           IF (STRCMP(IFNULL(LOWER(old.lastName),''),IFNULL(LOWER(new.lastName),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.lastName,new.lastName,now());
           END IF;
        END IF;
        IF v_column_name = 'positionTitle' THEN
           IF (STRCMP(IFNULL(LOWER(old.positionTitle),''),IFNULL(LOWER(new.positionTitle),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.positionTitle,new.positionTitle,now());
           END IF;
        END IF;
        IF v_column_name = 'institution' THEN
           IF (STRCMP(IFNULL(LOWER(old.institution),''),IFNULL(LOWER(new.institution),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.institution,new.institution,now());
           END IF;
        END IF;
        IF v_column_name = 'department' THEN
           IF (STRCMP(IFNULL(LOWER(old.department),''),IFNULL(LOWER(new.department),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.department,new.department,now());
           END IF;
        END IF;
        IF v_column_name = 'address1' THEN
           IF (STRCMP(IFNULL(LOWER(old.address1),''),IFNULL(LOWER(new.address1),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.address1,new.address1,now());
           END IF;
        END IF;
        IF v_column_name = 'address2' THEN
           IF (STRCMP(IFNULL(LOWER(old.address2),''),IFNULL(LOWER(new.address2),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.address2,new.address2,now());
           END IF;
        END IF;
        IF v_column_name = 'address3' THEN
           IF (STRCMP(IFNULL(LOWER(old.address3),''),IFNULL(LOWER(new.address3),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.address3,new.address3,now());
           END IF;
        END IF;
        IF v_column_name = 'city' THEN
           IF (STRCMP(IFNULL(LOWER(old.city),''),IFNULL(LOWER(new.city),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.city,new.city,now());
           END IF;
        END IF;
        IF v_column_name = 'state' THEN
           IF (STRCMP(IFNULL(LOWER(old.state),''),IFNULL(LOWER(new.state),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.state,new.state,now());
           END IF;
        END IF;
        IF v_column_name = 'country' THEN
           IF (STRCMP(IFNULL(LOWER(old.country),''),IFNULL(LOWER(new.country),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.country,new.country,now());
           END IF;
        END IF;
        IF v_column_name = 'postalCode' THEN
           IF (STRCMP(IFNULL(LOWER(old.postalCode),''),IFNULL(LOWER(new.postalCode),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.postalCode,new.postalCode,now());
           END IF;
        END IF;
        IF v_column_name = 'email' THEN
           IF (STRCMP(IFNULL(LOWER(old.email),''),IFNULL(LOWER(new.email),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.email,new.email,now());
           END IF;
        END IF;
        IF v_column_name = 'alternateEmail' THEN
           IF (STRCMP(IFNULL(LOWER(old.alternateEmail),''),IFNULL(LOWER(new.alternateEmail),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.alternateEmail,new.alternateEmail,now());
           END IF;
        END IF;
        IF v_column_name = 'workPhone' THEN
           IF (STRCMP(IFNULL(LOWER(old.workPhone),''),IFNULL(LOWER(new.workPhone),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.workPhone,new.workPhone,now());
           END IF;
        END IF;
        IF v_column_name = 'otherPhone' THEN
           IF (STRCMP(IFNULL(LOWER(old.otherPhone),''),IFNULL(LOWER(new.otherPhone),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.otherPhone,new.otherPhone,now());
           END IF;
        END IF;
        IF v_column_name = 'fax' THEN
           IF (STRCMP(IFNULL(LOWER(old.fax),''),IFNULL(LOWER(new.fax),'')) != 0 ) THEN
              INSERT INTO auditTrail (tableName,columnName,dataType,primaryIdentifier,oldValue,newValue,modifyDate)
                   VALUES (v_table_name,v_column_name,v_data_type,old.id,old.fax,new.fax,now());
           END IF;
        END IF;
     END IF;
  UNTIL done END REPEAT;

  CLOSE table_def_cur;
     
END;//

DELIMITER ;
