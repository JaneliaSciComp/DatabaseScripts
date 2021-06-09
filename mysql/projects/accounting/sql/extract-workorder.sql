SELECT "Ticket Id","Project","Department code","Shared resource","Owner","Close date","Tech","Units","Cost","Subject","Question","Problem type","Tech note","Account"
UNION
SELECT
  JOB_TICKET.JOB_TICKET_ID  as "Ticket Id"
 ,cost.project as Project
 ,DEPARTMENT.name as "Department code"
 ,x.shared_resource as "Shared resource"
 ,CLIENT.USER_NAME as "Owner"
 ,date_format(CLOSE_DATE,'%m-%d-%Y')  as "Close date"                    
 ,TECH.USER_NAME as "Tech"
 ,REPLACE(IFNULL(cost.units,''),',',' ') as "Units"
 ,REPLACE(IFNULL(cost.cost,''),',',' ')  as "Cost"
 ,REPLACE(REPLACE(REPLACE(IFNULL(SUBJECT,''),'\r',' '),'\n',' '),',',' ') as "Subject"                       
 ,REPLACE(REPLACE(REPLACE(IFNULL(QUESTION_TEXT,''),'\r',' '),'\n',' '),',',' ') as "Question"
 ,x.problem_type_name as "Problem type"
 ,REPLACE(REPLACE(REPLACE(IFNULL(notes.note_text,''),'\r',' '),'\n',' '),',',' ') as "Tech note"
 ,(IF(STRCMP( x.shared_resource,'Molecular Biology')
  ,(IF(STRCMP( x.shared_resource,'Cell Culture Facility')
  ,(IF(STRCMP( x.shared_resource,'Histology/anatomy Facility')
  ,(IF(STRCMP( x.shared_resource,'Vivarium')
  ,(IF(STRCMP( x.shared_resource,'Media Facility')
  ,(IF(STRCMP( x.shared_resource,'Light Microscopy')
  ,(IF(STRCMP( x.shared_resource,'Instrument Development')
  ,(IF(STRCMP( x.shared_resource,'Fly Lab')
  ,(IF(STRCMP( x.shared_resource,'Electron Microscopy')
  ,(IF(STRCMP( x.shared_resource,'Transgenics')
  ,null,'51603')),'51614')),'51608')),'51607')),'51606')),'51609')),'51613')),'51605')),'51604')),'51602')) as "Account"
FROM JOB_TICKET 
LEFT JOIN (SELECT NOTE_TEXT,JOB_TICKET_ID as id
           FROM TECH_NOTE
           WHERE (TECH_NOTE_ID,JOB_TICKET_ID) IN (SELECT max(TECH_NOTE_ID),JOB_TICKET_ID 
                                                  FROM TECH_NOTE 
                                                  WHERE ((NOTE_TEXT like '%$%' ) OR (NOTE_TEXT like '%hour%' ) OR (NOTE_TEXT like '%hr%' ))
                                                  GROUP BY JOB_TICKET_ID
                                                 )
          ) notes on (notes.id = JOB_TICKET.JOB_TICKET_ID)
,DEPARTMENT
,CLIENT
,STATUS_TYPE
,TECH
,(SELECT TICKET_CUSTOM_FIELD.ENTITY_ID as id
        ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Cost'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,'0'))) as cost
        ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Units'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,'1'))) as units
        ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Project Code (leave blank for default)'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,''))) as project
  FROM TICKET_CUSTOM_FIELD
      ,CUSTOM_FIELD_DEFINITION
  WHERE TICKET_CUSTOM_FIELD.DEFINITION_ID = CUSTOM_FIELD_DEFINITION.ID
  GROUP BY TICKET_CUSTOM_FIELD.ENTITY_ID
 ) cost
,(SELECT a.PROBLEM_TYPE_NAME as shared_resource,a.PROBLEM_TYPE_ID as problem_type_id,a.PROBLEM_TYPE_NAME as problem_type_name
  FROM PROBLEM_TYPE a
  WHERE a.PARENT_ID is NULL
  UNION
  SELECT a.PROBLEM_TYPE_NAME as shared_resource,a.PROBLEM_TYPE_ID as problem_type_id,a.PROBLEM_TYPE_NAME as problem_type_name
  FROM PROBLEM_TYPE a
  WHERE a.PARENT_ID = 3
  UNION
  SELECT b.PROBLEM_TYPE_NAME as shared_resource,a.PROBLEM_TYPE_ID as problem_type_id,a.PROBLEM_TYPE_NAME as problem_type_name
  FROM PROBLEM_TYPE a
      ,PROBLEM_TYPE b
  WHERE a.PARENT_ID = b.PROBLEM_TYPE_ID
    AND b.PARENT_ID = 3
  UNION
  SELECT c.PROBLEM_TYPE_NAME,a.PROBLEM_TYPE_ID,a.PROBLEM_TYPE_NAME as problem_type_name
  FROM PROBLEM_TYPE a
      ,PROBLEM_TYPE b
      ,PROBLEM_TYPE c
  WHERE a.PARENT_ID = b.PROBLEM_TYPE_ID
    AND b.PARENT_ID = c.PROBLEM_TYPE_ID
    AND c.PARENT_ID = 3
  UNION
  SELECT d.PROBLEM_TYPE_NAME,a.PROBLEM_TYPE_ID,a.PROBLEM_TYPE_NAME as problem_type_name
  FROM PROBLEM_TYPE a
      ,PROBLEM_TYPE b
      ,PROBLEM_TYPE c
      ,PROBLEM_TYPE d
  WHERE a.PARENT_ID = b.PROBLEM_TYPE_ID
    AND b.PARENT_ID = c.PROBLEM_TYPE_ID
    AND c.PARENT_ID = d.PROBLEM_TYPE_ID
    AND d.PARENT_ID = 3
  ) x
WHERE JOB_TICKET.PROBLEM_TYPE_ID = x.problem_type_id
  AND JOB_TICKET.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
  AND JOB_TICKET.JOB_TICKET_ID = cost.id
  AND JOB_TICKET.CLIENT_ID = CLIENT.CLIENT_ID
  AND JOB_TICKET.STATUS_TYPE_ID = STATUS_TYPE.STATUS_TYPE_ID
  AND STATUS_TYPE.STATUS_TYPE_NAME = 'Closed'
  AND DEPARTMENT.NAME != 'Test Dept'
  AND JOB_TICKET.ASSIGNED_TECH_ID = TECH.CLIENT_ID
  AND CLOSE_DATE < '2009-08-28'
INTO OUTFILE '/tmp/workorder.csv'
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
