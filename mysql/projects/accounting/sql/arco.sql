SELECT username, department, SUM(cpu/3600) AS cpu_hours, SUM(wallclock_time/3600) AS wallclock_hours,  SUM(wallclock_time/3600*0.11) AS wallclock_dollars, SUM(cpu/3600*0.11) AS cpu_dollars 
FROM view_accounting 
WHERE start_time between '2008-12-01 00:00:00' and '2009-01-01 00:00:00' GROUP BY  username;


select groupname,sum(wallclock_time)/3600 AS wallclock_hours, SUM(wallclock_time/3600*0.11) AS wallclock_dollars, SUM(cpu/3600) AS cpu_hours, SUM(cpu/3600*.11) AS cpu_dollars
FROM view_accounting 
where department  not in ('admin','scicomp')
      and end_time >= '2009-01-01 00:00:00' 
        and end_time <= '2009-01-31 23:59:59'
group by groupname;

select distinct  view_accounting.department
from arco.view_accounting;

select distinct
    `sge_job`.`j_group`               AS `groupname`,
    `sge_job`.`j_owner`               AS `username`
from arco.sge_job;

select max(j_submission_time) from arco.sge_job;

select * from arco.sge_group;

