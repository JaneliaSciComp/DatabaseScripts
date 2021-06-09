SELECT "ID","Project","Department name","Department code","Close date","Subject","Units","Rate","Cost","Account"
UNION
SELECT id
      ,project_code as "Project" 
      ,name as "Department name"
      ,lpad(code,6,'0') as "Department code"
      ,date_format(close_date,'%m-%d-%Y') as "Close date"
      ,service as "Subject"
      ,ROUND(unit,1) as "Units"
      ,ROUND(rate,2) as "Rate"
      ,ROUND(unit*rate,2) as "Cost"
      ,IF(STRCMP(service,'Servers'),'51610','51615') as "Account"
FROM chargeback.computing_services_chargeback, chargeback.department
WHERE department_code = lpad(code,6,'0')
  AND name  not in ('scicomp')
INTO OUTFILE '/tmp/storage.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
