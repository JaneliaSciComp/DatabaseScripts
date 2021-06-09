-- !!! client with null department
select user_name 
from CLIENT
where department_name is null
     and user_name not in ('client','mousem','sge','svnadmin','application','admin','jboss','smbadmin','flyrobot','matlab','pfam','tomcat','monellxfer','zimbratest','calladmin','mgmt','em','johnsonst','karpovalab','vmbackup','linuxtest','simmonsd','youngj','phmmer');
-- !!! client with 9***** department
select user_name,DEPARTMENT_NAME
from CLIENT
where department_name like '9%'
    and user_name not in ('gilberth','rahmanns','simmonsf','pastalkovae');
-- !!! ticket with non-6digit department
select JOB_TICKET.JOB_TICKET_ID, JOB_TICKET.CLOSE_DATE,DEPARTMENT.NAME
from workorder.JOB_TICKET, workorder.DEPARTMENT
where JOB_TICKET.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
and length(DEPARTMENT.NAME) != 6
and DEPARTMENT.NAME != 'Test Dept';
-- !!! cost with characters
select JOB_TICKET.JOB_TICKET_ID,CUSTOM_FIELD_DEFINITION.LABEL,TICKET_CUSTOM_FIELD.STRING_VALUE
from JOB_TICKET
             ,TICKET_CUSTOM_FIELD
             ,CUSTOM_FIELD_DEFINITION
where JOB_TICKET.JOB_TICKET_ID = TICKET_CUSTOM_FIELD.ENTITY_ID
      and TICKET_CUSTOM_FIELD.DEFINITION_ID = CUSTOM_FIELD_DEFINITION.ID
      and JOB_TICKET.CLOSE_DATE >=  '2008-11-01 00:00:00'  
      and  STRING_VALUE REGEXP '\\$|,|[[:blank:]]|\\n|\\.\\.'
      and CUSTOM_FIELD_DEFINITION.LABEL != 'Units';
--
select * 
from TICKET_CUSTOM_FIELD
where STRING_VALUE REGEXP '\\$|,|[[:blank:]]|\\n|\\.\\.'
and definition_id = 1;
--
select * 
from TICKET_CUSTOM_FIELD
where STRING_VALUE REGEXP '\\$|,|[[:blank:]]|\\n|\\.\\.'
and TICKET_CUSTOM_FIELD.ENTITY_ID in (12473,12447,12245,11956)
and definition_id = 4;
-- !!! tickets closed with no closed date
select JOB_TICKET.JOB_TICKET_ID,JOB_TICKET.REPORT_DATE, JOB_TICKET.CLOSE_DATE , JOB_TICKET.*
 from JOB_TICKET 
where JOB_TICKET.STATUS_TYPE_ID = 3 
and JOB_TICKET.JOB_TICKET_ID not in (8174,8351,8782)
and JOB_TICKET.CLOSE_DATE is null;
-- !!! tickets closed with no assigned tech
select JOB_TICKET.JOB_TICKET_ID,JOB_TICKET.REPORT_DATE, JOB_TICKET.*
 from JOB_TICKET 
where JOB_TICKET.STATUS_TYPE_ID = 3 
and JOB_TICKET.ASSIGNED_TECH_ID is null
and JOB_TICKET.CLOSE_DATE >=  '2009-07-01 00:00:00';
-- !!! cost null
select DEPARTMENT.NAME, JOB_TICKET.JOB_TICKET_ID,CUSTOM_FIELD_DEFINITION.LABEL,TICKET_CUSTOM_FIELD.STRING_VALUE
from JOB_TICKET
    ,TICKET_CUSTOM_FIELD
    ,CUSTOM_FIELD_DEFINITION
    ,workorder.DEPARTMENT
where JOB_TICKET.JOB_TICKET_ID = TICKET_CUSTOM_FIELD.ENTITY_ID
      and TICKET_CUSTOM_FIELD.DEFINITION_ID = CUSTOM_FIELD_DEFINITION.ID
  and JOB_TICKET.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
      and JOB_TICKET.CLOSE_DATE >=  '2009-07-01 00:00:00'  
      and  STRING_VALUE is null
      and definition_id = 1
      and name not in ('093097');
--
-- !!! ticket cost for client
select CLIENT.DEPARTMENT_NAME, JOB_TICKET.CLOSE_DATE, JOB_TICKET.SUBJECT, CLIENT.USER_NAME, TICKET_CUSTOM_FIELD.STRING_VALUE
from workorder.JOB_TICKET, CLIENT, workorder.TICKET_CUSTOM_FIELD
where JOB_TICKET.CLIENT_ID = CLIENT.CLIENT_ID 
    and CLIENT.USER_NAME like 'gal%'
    and JOB_TICKET.JOB_TICKET_ID = TICKET_CUSTOM_FIELD.ENTITY_ID
    and TICKET_CUSTOM_FIELD.DEFINITION_ID = 1;
-- !!! tickets for depts that don't start with a 09
select count(1), DEPARTMENT.NAME
from workorder.DEPARTMENT, workorder.JOB_TICKET
where DEPARTMENT.DEPARTMENT_ID = JOB_TICKET.DEPARTMENT_ID
and DEPARTMENT.NAME not like '09%';
-- !!! clients for depts that don't start with a 09
select  CLIENT.LAST_NAME, CLIENT.DEPARTMENT_NAME, DEPARTMENT.NAME
from workorder.CLIENT, workorder.DEPARTMENT
where CLIENT.DEPARTMENT_ID  = DEPARTMENT.DEPARTMENT_ID
and DEPARTMENT.NAME not like '09%';
-- !!! depts that don't start with a 09
select DEPARTMENT.DEPARTMENT_ID,DEPARTMENT.NAME,DEPARTMENT.DELETED
from workorder.DEPARTMENT
where DEPARTMENT.DELETED = 0
and DEPARTMENT.NAME not like '09%';
-- !!! ticket project code
select * 
from TICKET_CUSTOM_FIELD
where  definition_id = 4
and TICKET_CUSTOM_FIELD.ENTITY_ID in (11108,10238,11032,10786);
--
select JOB_TICKET.JOB_TICKET_ID,CUSTOM_FIELD_DEFINITION.LABEL,TICKET_CUSTOM_FIELD.STRING_VALUE
from JOB_TICKET
             ,TICKET_CUSTOM_FIELD
             ,CUSTOM_FIELD_DEFINITION
where JOB_TICKET.JOB_TICKET_ID = TICKET_CUSTOM_FIELD.ENTITY_ID
      and TICKET_CUSTOM_FIELD.DEFINITION_ID = CUSTOM_FIELD_DEFINITION.ID 
      and JOB_TICKET.JOB_TICKET_ID = 10238;
-- !!! 093400 Project codes
SELECT DEPARTMENT.NAME dept_code, CLIENT.USER_NAME as user_name,
               JOB_TICKET.CLOSE_DATE as bill_date, JOB_TICKET.JOB_TICKET_ID as work_order_id,jobs.project_code
FROM JOB_TICKET, DEPARTMENT, CLIENT, STATUS_TYPE
              ,(
                 SELECT JOB_TICKET.JOB_TICKET_ID as id
                                 ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Cost'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,'0'))) as price
                                 ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Units'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,'1'))) as units
                                 ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Project Code (leave blank for default)'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,''))) as project_code
                 FROM JOB_TICKET
                              ,TICKET_CUSTOM_FIELD
                              ,CUSTOM_FIELD_DEFINITION
                  WHERE JOB_TICKET.JOB_TICKET_ID = TICKET_CUSTOM_FIELD.ENTITY_ID
                       AND TICKET_CUSTOM_FIELD.DEFINITION_ID = CUSTOM_FIELD_DEFINITION.ID
                  GROUP BY JOB_TICKET.JOB_TICKET_ID
                   ) jobs
WHERE JOB_TICKET.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
       AND JOB_TICKET.CLIENT_ID = CLIENT.CLIENT_ID
       AND JOB_TICKET.JOB_TICKET_ID = jobs.id
       AND JOB_TICKET.STATUS_TYPE_ID = STATUS_TYPE.STATUS_TYPE_ID
       AND STATUS_TYPE.STATUS_TYPE_NAME = 'Closed'
       AND DEPARTMENT.NAME != 'Test Dept'
       and JOB_TICKET.CLOSE_DATE >=  '2009-07-01 00:00:00'  
       and DEPARTMENT.NAME >= '093400'
       and DEPARTMENT.NAME not in ('093402','093403')
ORDER BY CLIENT.USER_NAME,DEPARTMENT.NAME; 
-- !!!  FLY project codes
SELECT DEPARTMENT.NAME dept_code, CLIENT.USER_NAME as user_name,
               JOB_TICKET.CLOSE_DATE as bill_date, JOB_TICKET.JOB_TICKET_ID as work_order_id,jobs.project_code
FROM JOB_TICKET, DEPARTMENT, CLIENT, STATUS_TYPE
              ,(
                 SELECT JOB_TICKET.JOB_TICKET_ID as id
                                 ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Cost'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,'0'))) as price
                                 ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Units'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,'1'))) as units
                                 ,max(if(STRCMP(CUSTOM_FIELD_DEFINITION.LABEL,'Project Code (leave blank for default)'),null,ifnull(TICKET_CUSTOM_FIELD.STRING_VALUE,''))) as project_code
                 FROM JOB_TICKET
                              ,TICKET_CUSTOM_FIELD
                              ,CUSTOM_FIELD_DEFINITION
                  WHERE JOB_TICKET.JOB_TICKET_ID = TICKET_CUSTOM_FIELD.ENTITY_ID
                       AND TICKET_CUSTOM_FIELD.DEFINITION_ID = CUSTOM_FIELD_DEFINITION.ID
                  GROUP BY JOB_TICKET.JOB_TICKET_ID
                   ) jobs
WHERE JOB_TICKET.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
       AND JOB_TICKET.CLIENT_ID = CLIENT.CLIENT_ID
       AND JOB_TICKET.JOB_TICKET_ID = jobs.id
       AND JOB_TICKET.STATUS_TYPE_ID = STATUS_TYPE.STATUS_TYPE_ID
       AND STATUS_TYPE.STATUS_TYPE_NAME = 'Closed'
       AND DEPARTMENT.NAME != 'Test Dept'
       and jobs.project_code in ('JVS003900','JVS002800','JVS002900','JVS005200','JVS001901','JVS003800','JVS000901','JVS001600','JVS001702','JVS001400','JVS002200')
       and JOB_TICKET.CLOSE_DATE >=  '2009-06-01 00:00:00'  
ORDER BY CLIENT.USER_NAME,DEPARTMENT.NAME; 
       
