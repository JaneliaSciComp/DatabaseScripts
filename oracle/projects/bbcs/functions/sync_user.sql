CREATE OR REPLACE PROCEDURE sync_user
(
 v_userid              VARCHAR2,
 v_firstname           VARCHAR2,
 v_lastname            VARCHAR2,
 v_studentid           VARCHAR2,
 v_email               VARCHAR2
)
   
IS
  -- Local variable declaration
  v_usercount NUMBER := 0;
BEGIN
  -- Check if user with this userid already exists
  SELECT COUNT (*)
  INTO  v_usercount
  FROM  BB_BB60.USERS
  WHERE USER_ID = v_userid; 
  -- User does not exist
  IF v_usercount = 0 THEN
   -- Insert row into USERS based on arguments passed
   INSERT INTO BB_BB60.USERS ( PK1
                              ,DATA_SRC_PK1
                              ,SYSTEM_ROLE
                              ,USER_ID
                              ,BATCH_UID
                              ,PASSWD
                              ,FIRSTNAME
                              ,LASTNAME
                              ,EDUC_LEVEL
                              ,STUDENT_ID
                              ,EMAIL
                              ,SETTINGS
                             )
   VALUES
         ( BB_BB60.USERS_SEQ.nextval
          ,2
          ,'N'
          ,v_userid
          ,v_userid
          ,'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
          ,v_firstname
          ,v_lastname
          ,0
          ,v_studentid
          ,v_email
          ,''
         );

     INSERT INTO BB_BB60.PORTAL_VIEWER ( PK1
                                        ,PORTAL_VIEWER_TYPE
                                        ,USERS_PK1
                                       ) 
     VALUES
           ( BB_BB60.PORTAL_VIEWER_SEQ.nextval
            ,'U'
            ,BB_BB60.USERS_SEQ.currval
           );

     DBMS_OUTPUT.PUT_LINE('USERS record inserted for ' || v_lastname ||', '|| v_firstname);

     IF length(v_email) > 0 THEN

       INSERT INTO BB_BB60.USER_REGISTRY ( SOS_ID_PK2
                                          ,USERS_SOS_ID_PK2
                                          ,PK1
                                          ,ROW_STATUS
                                          ,REGISTRY_KEY
                                          ,REGISTRY_VALUE
                                          ,DTCREATED
                                          ,USERS_PK1
                                          ,DTMODIFIED
                                         )
       VALUES 
             ( 1
              ,1
              ,BB_BB60.USER_REGISTRY_SEQ.nextval
              ,0
              ,'olco.email_statement_availibility'
              ,'N'
              ,SYSDATE
              ,BB_BB60.USERS_SEQ.currval
              ,SYSDATE
             );

       INSERT INTO BB_BB60.USER_REGISTRY ( SOS_ID_PK2
                                          ,USERS_SOS_ID_PK2
                                          ,PK1
                                          ,ROW_STATUS
                                          ,REGISTRY_KEY
                                          ,REGISTRY_VALUE
                                          ,DTCREATED
                                          ,USERS_PK1
                                          ,DTMODIFIED
                                         )
       VALUES 
             ( 1
              ,1
              ,BB_BB60.USER_REGISTRY_SEQ.nextval
              ,0
              ,'olco.email_balance_sent'
              ,'Y'
              ,SYSDATE
              ,BB_BB60.USERS_SEQ.currval
              ,SYSDATE
             );

       INSERT INTO BB_BB60.USER_REGISTRY ( SOS_ID_PK2
                                          ,USERS_SOS_ID_PK2
                                          ,PK1
                                          ,ROW_STATUS
                                          ,REGISTRY_KEY
                                          ,REGISTRY_VALUE
                                          ,DTCREATED
                                          ,USERS_PK1
                                          ,DTMODIFIED
                                         )
       VALUES 
             ( 1
              ,1
              ,BB_BB60.USER_REGISTRY_SEQ.nextval
              ,0
              ,'olco.email_balance_low'
              ,'5'
              ,SYSDATE
              ,BB_BB60.USERS_SEQ.currval
              ,SYSDATE
             );

       DBMS_OUTPUT.PUT_LINE('USER_REGISTRY records inserted for ' || v_lastname ||', '|| v_firstname);
    END IF;


  -- User with this name already exists
  ELSIF v_usercount = 1 THEN
    -- Update the existing user with values passed as arguments
   UPDATE BB_BB60.USERS
   SET FIRSTNAME = v_firstname
      ,LASTNAME = v_lastname
      ,STUDENT_ID = v_studentid
      ,EMAIL = v_email
      ,PASSWD = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF' 
   WHERE USER_ID = v_userid;

   DBMS_OUTPUT.PUT_LINE('USERS record updated for ' || v_lastname ||', '|| v_firstname);

   IF v_email IS NULL THEN 
     DELETE BB_BB60.USER_REGISTRY WHERE USERS_PK1 = (SELECT PK1 FROM BB_BB60.USERS WHERE USER_ID = v_userid);
     DBMS_OUTPUT.PUT_LINE('USER_REGISTRY records deleted for ' || v_lastname ||', '|| v_firstname);
   END IF;


  END IF;
   
  -- No errors; perform COMMIT
  COMMIT;
   
-- Exception section -- the execution flow goes here
-- if an error occurs during the execution
EXCEPTION
  WHEN OTHERS THEN
    -- Put line into the standard output
    DBMS_OUTPUT.PUT_LINE('Error');
    -- Rollback all changes
    ROLLBACK;
END sync_user;
/
