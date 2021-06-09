SELECT "ID","Project","Department name","Department code","Close date","Subject","FTE","Units","Rate","Cost","Account"
UNION
SELECT id
      ,project_code as "Project" 
      ,name as "Department name"
      ,lpad(ifnull(code,department_code),6,'0') as "Department code"
      ,date_format(close_date,'%m-%d-%Y') as "Close date"
      ,project as "Subject"
      ,ROUND(fte,2) as "FTE"
      ,ROUND(fte*40,2) as "Units"
      ,ROUND(rate,2) as "Rate"
      ,ROUND(fte*40*rate,2) as "Cost"
      ,51611 as "Account"
FROM chargeback.scientific_computing_chargeback
LEFT OUTER JOIN chargeback.department ON ( chargeback.scientific_computing_chargeback.department_code = department.code)
WHERE ifnull(name,'null')  not in ('admin','scicomp')
INTO OUTFILE '/tmp/scientific-computing.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
