SELECT "ID", "Project","Department name","Department code","Owner","Close date","Usage Date","Wallclock","Units","Rate","Cost","Account"
UNION
SELECT id
      ,IF(STRCMP(project,'NONE'),project,'') as "Project" 
      ,name as "Department name"
      ,lpad(code,6,'0') as "Department code"
      ,owner as "Owner"
      ,date_format(close_date,'%m-%d-%Y') as "Close date"
      ,date_format(end_time,'%m-%d-%Y') as "Usage Date"
      ,wallclock as "Wallclock"
      ,units as "Units"
      ,ROUND(rate,2) as "Rate"
      ,ROUND(cost,2) as "Cost"
      ,51612 as "Account"
FROM chargeback.compute_chargeback, chargeback.department
WHERE department_code = code
  AND name  not in ('admin','scicomp')
INTO OUTFILE '/tmp/compute-farm.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
