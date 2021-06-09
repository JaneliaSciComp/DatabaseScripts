-- accounting
select project as "Project" ,name as "Department name",lpad(code,6,'0') as "Department code",owner as "Owner",close_date as "Close date", end_time as "Usage Date", wallclock as "Wallclock", units as "Units", rate as "Rate",cost as "Cost",51612 as "Account"
 from chargeback.compute_chargeback, chargeback.department
where department_code = code
and name  not in ('admin','scicomp');

-- software stats
select project, sum(fte*40)
from chargeback.scientific_computing_chargeback
where close_date >=  '2008-08-27 00:00:00' 
--and close_date <=  '2009-03-31 00:00:00' 
group by project;


-- storage stats
select name, sum(IF(STRCMP( service,'Direct Attached storage (TB)'),null,unit)),sum(IF(STRCMP( service,'Primary storage (TB)'),null,unit)),sum(IF(STRCMP( service,'Secondary storage (TB)'),null,unit)),sum(IF(STRCMP( service,'Servers'),null,unit))
from chargeback.computing_services_chargeback,chargeback.department
where lpad(department.code,6,'0') = computing_services_chargeback.department_code
and close_date >= '2008-11-01 00:00:00' 
and close_date <= '2008-11-31 23:59:59' 
group by name;

-- cluster stats
select name,sum(compute_chargeback.wallclock)/3600
 from chargeback.compute_chargeback, chargeback.department
where department_code = code
and name  not in ('admin','scicomp')
and close_date >= '2009-04-01 00:00:00' 
and close_date <= '2009-04-30 23:59:59' 
group by name;


-- compare to arco
select name,sum(compute_chargeback.wallclock/3600) as wallclock_hours, sum(compute_chargeback.wallclock/3600*.11) as wallclock_dollars
 from chargeback.compute_chargeback, chargeback.department
where department_code = code
and end_time >= '2009-01-01 00:00:00' 
        and end_time <= '2009-01-31 23:59:59'
group by name;

select  group_name,sum(ru_wallclock/3600) as wallclock_hours, sum(ru_wallclock/3600*.11) as wallclock_dollars,sum(cpu/3600) as cpu_hours, sum(cpu/3600*.11) as cpu_dollars
      from compute_accounting
      where end_time >= '2009-01-01 00:00:00' 
        and end_time <= '2009-01-31 23:59:59'
group by  group_name;

-- cluster 093400
select * from chargeback.compute_chargeback 
where compute_chargeback.department_code = '93400' 
and end_time >= '2009-01-01 00:00:00' 
order by owner,project;