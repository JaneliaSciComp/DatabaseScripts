------ 2006-09
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2006-09-30' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2006-09-01 00:00:00'   
----  and end_time <= '2006-09-30 23:59:59'   
------  and start_time >= '2006-09-01 00:00:00'   
------  and start_time <= '2006-09-30 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2006-10
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2006-10-31' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2006-10-01 00:00:00'   
----  and end_time <= '2006-10-31 23:59:59'   
------  and start_time >= '2006-10-01 00:00:00'   
------  and start_time <= '2006-10-31 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2006-11
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2006-11-30' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2006-11-01 00:00:00'   
----  and end_time <= '2006-11-30 23:59:59'   
------  and start_time >= '2006-11-01 00:00:00'   
------  and start_time <= '2006-11-30 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2006-12
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2006-12-31' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2006-12-01 00:00:00'   
----  and end_time <= '2006-12-31 23:59:59'   
------  and start_time >= '2006-12-01 00:00:00'   
------  and start_time <= '2006-12-31 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-01
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-01-31'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-01-01 00:00:00'
----  and end_time <= '2007-01-31 23:59:59'
------  and start_time >= '2007-01-01 00:00:00'
------  and start_time <= '2007-01-31 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-02
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-02-28'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-02-01 00:00:00'
----  and end_time <= '2007-02-28 23:59:59'
------  and start_time >= '2007-02-01 00:00:00'
------  and start_time <= '2007-02-28 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-03
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-03-31'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-03-01 00:00:00'
----  and end_time <= '2007-03-31 23:59:59'
------  and start_time >= '2007-03-01 00:00:00'
------  and start_time <= '2007-03-31 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-04
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-04-30'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-04-01 00:00:00'
----  and end_time <= '2007-04-30 23:59:59'
------  and start_time >= '2007-04-01 00:00:00'
------  and start_time <= '2007-04-30 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-05
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-05-31'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-05-01 00:00:00'
----  and end_time <= '2007-05-31 23:59:59'
------  and start_time >= '2007-05-01 00:00:00'
------  and start_time <= '2007-05-31 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-06
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-06-30'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-06-01 00:00:00'
----  and end_time <= '2007-06-30 23:59:59'
------  and start_time >= '2007-06-01 00:00:00'
------  and start_time <= '2007-06-30 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-07
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-07-31'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-07-01 00:00:00'
----  and end_time <= '2007-07-31 23:59:59'
------  and start_time >= '2007-07-01 00:00:00'
------  and start_time <= '2007-07-31 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-08
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-08-26'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-08-01 00:00:00'
----  and end_time <= '2007-08-26 23:59:59'
------  and start_time >= '2007-08-01 00:00:00'
------  and start_time <= '2007-08-26 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-09
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-09-30' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-08-27 00:00:00'   
----  and end_time <= '2007-10-01 23:59:59'   
----  and start_time >= '2007-08-27 00:00:00'   
----  and start_time <= '2007-09-30 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-10
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-10-31' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-10-01 00:00:00'   
----  and end_time <= '2007-11-01 23:59:59'   
----  and start_time >= '2007-10-01 00:00:00'   
----  and start_time <= '2007-10-31 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-11
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-11-30' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-11-01 00:00:00'   
----  and end_time <= '2007-12-13 23:59:59'   
----  and start_time >= '2007-11-01 00:00:00'   
----  and start_time <= '2007-11-30 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2007-12
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2007-12-31' 
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2007-12-01 00:00:00'   
----  and end_time <= '2008-01-02 23:59:59'   
----  and start_time >= '2007-12-01 00:00:00'   
----  and start_time <= '2007-12-31 23:59:59'   
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
------ 2008-01
----insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
----select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2008-01-31'
----from compute_accounting,department
----where name = group_name
----  and end_time >= '2008-01-01 00:00:00'
----  and end_time <= '2008-01-31 23:59:59'
----  and start_time >= '2008-01-01 00:00:00'
----  and start_time <= '2008-01-31 23:59:59'
----group by project, code, owner,date_format(end_time,'%Y-%m-%d');
---- 2008-02
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2008-02-29'
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-02-01 00:00:00'
--  and end_time <= '2008-02-29 23:59:59'
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2008-02-29' 
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2007-10-02 00:00:00'   
--  and end_time <= '2008-01-31 23:59:59'
--  and start_time >= '2007-08-27 00:00:00'   
--  and start_time <= '2007-09-30 23:59:59'   
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2008-02-29' 
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2007-11-02 00:00:00'   
--  and end_time <= '2008-01-31 23:59:59'
--  and start_time >= '2007-10-01 00:00:00'   
--  and start_time <= '2007-10-31 23:59:59'   
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2008-02-29' 
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2007-12-14 00:00:00'   
--  and end_time <= '2008-01-31 23:59:59'
--  and start_time >= '2007-11-01 00:00:00'   
--  and start_time <= '2007-11-30 23:59:59'   
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock), .11, round(sum(ru_wallclock)/3600,2), round(round(sum(ru_wallclock)/3600,2)*.11,2), '2008-02-29' 
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-01-01 00:00:00'   
--  and end_time <= '2008-01-31 23:59:59'
--  and start_time >= '2007-12-01 00:00:00'   
--  and start_time <= '2007-12-31 23:59:59'   
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-03
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
--round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-03-31'
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-03-01 00:00:00'
--  and end_time <= '2008-03-31 23:59:59'
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-04
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
--round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-04-30'
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-04-01 00:00:00'
--  and end_time <= '2008-04-30 23:59:59'
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-05
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
--round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-05-31'
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-05-01 00:00:00'
--  and end_time <= '2008-05-31 23:59:59'
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-06
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
--round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-06-30'
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-06-01 00:00:00'
--  and end_time <= '2008-06-30 23:59:59'
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-07
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
--round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-07-31'
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-07-01 00:00:00'
--  and end_time <= '2008-07-31 23:59:59'
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-08
--insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
--select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
--round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-08-25'
--from compute_accounting,department
--where name = group_name
--  and end_time >= '2008-08-01 00:00:00'
--  and end_time <= '2008-08-25 23:59:59'
--group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-09
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-09-30'
from compute_accounting,department
where name = group_name
  and end_time >= '2008-08-25 00:00:00'
  and end_time <= '2008-09-30 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-09 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-09-30' 
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber 
      from compute_accounting,department
      where name = group_name 
        and end_time >= '2008-08-25 00:00:00' 
        and end_time <= '2008-09-30 23:59:59' 
        and granted_pe = 'openmpi') x 
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2008-10
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-10-31'
from compute_accounting,department
where name = group_name
  and end_time >= '2008-10-01 00:00:00'
  and end_time <= '2008-10-31 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-10 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-10-31'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2008-10-01 00:00:00'
        and end_time <= '2008-10-31 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2008-11
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-11-30'
from compute_accounting,department
where name = group_name
  and end_time >= '2008-11-01 00:00:00'
  and end_time <= '2008-11-30 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-10 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-11-30'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2008-11-01 00:00:00'
        and end_time <= '2008-11-30 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2008-12
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-12-31'
from compute_accounting,department
where name = group_name
  and end_time >= '2008-12-01 00:00:00'
  and end_time <= '2008-12-31 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2008-12 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2008-12-31'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2008-12-01 00:00:00'
        and end_time <= '2008-12-31 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2009-01
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-01-31'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-01-01 00:00:00'
  and end_time <= '2009-01-31 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-01 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-01-31'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-01-01 00:00:00'
        and end_time <= '2009-01-31 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2009-02
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-02-28'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-02-01 00:00:00'
  and end_time <= '2009-02-28 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-02 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-02-28'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-02-01 00:00:00'
        and end_time <= '2009-02-28 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2009-03
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-03-31'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-03-01 00:00:00'
  and end_time <= '2009-03-31 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-03 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-03-31'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-03-01 00:00:00'
        and end_time <= '2009-03-31 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-04
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-04-30'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-04-01 00:00:00'
  and end_time <= '2009-04-30 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-04 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-04-30'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-04-01 00:00:00'
        and end_time <= '2009-04-30 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-05
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-05-31'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-05-01 00:00:00'
  and end_time <= '2009-05-31 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-05 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-05-31'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-05-01 00:00:00'
        and end_time <= '2009-05-31 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-06
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-06-30'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-06-01 00:00:00'
  and end_time <= '2009-06-30 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-06 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-06-30'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-06-01 00:00:00'
        and end_time <= '2009-06-30 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-07
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-07-31'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-07-01 00:00:00'
  and end_time <= '2009-07-31 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-07 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-07-31'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-07-01 00:00:00'
        and end_time <= '2009-07-31 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2009-08
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-08-30'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-08-01 00:00:00'
  and end_time <= '2009-08-30 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-08 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-08-30'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-08-01 00:00:00'
        and end_time <= '2009-08-30 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2009-09
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-09-28'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-09-01 00:00:00'
  and end_time <= '2009-09-27 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-09 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-09-28'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-09-01 00:00:00'
        and end_time <= '2009-09-27 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');




-- 2009-10
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-10-25'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-09-28 00:00:00'
  and end_time <= '2009-10-25 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-10 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-10-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-09-28 00:00:00'
        and end_time <= '2009-10-25 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2009-10
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-11-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-10-26 00:00:00'
  and end_time <= '2009-11-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-09 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-11-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-10-26 00:00:00'
        and end_time <= '2009-11-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2009-10
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-12-21'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-11-24 00:00:00'
  and end_time <= '2009-12-21 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2009-09 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2009-12-21'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-11-24 00:00:00'
        and end_time <= '2009-12-21 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-01
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-01-25'
from compute_accounting,department
where name = group_name
  and end_time >= '2009-12-22 00:00:00'
  and end_time <= '2010-01-25 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-01 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-01-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2009-12-22 00:00:00'
        and end_time <= '2010-01-25 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-02
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-02-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-01-26 00:00:00'
  and end_time <= '2010-02-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-02 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-02-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-01-26 00:00:00'
        and end_time <= '2010-02-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');






-- 2010-03
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-03-25'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-02-25 00:00:00'
  and end_time <= '2010-03-25 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-03 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-03-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-02-25 00:00:00'
        and end_time <= '2010-03-25 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-04
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-04-25'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-03-26 00:00:00'
  and end_time <= '2010-04-25 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-04 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-04-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-03-26 00:00:00'
        and end_time <= '2010-04-25 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-05
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-05-25'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-04-26 00:00:00'
  and end_time <= '2010-05-25 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-05 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-05-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-04-26 00:00:00'
        and end_time <= '2010-05-25 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-06
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-06-22'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-05-26 00:00:00'
  and end_time <= '2010-06-22 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-06 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-06-22'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-05-26 00:00:00'
        and end_time <= '2010-06-22 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-07
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-07-25'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-06-23 00:00:00'
  and end_time <= '2010-07-25 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-07 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-07-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-06-23 00:00:00'
        and end_time <= '2010-07-25 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-08
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-08-22'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-07-26 00:00:00'
  and end_time <= '2010-08-22 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-08 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-08-22'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-07-26 00:00:00'
        and end_time <= '2010-08-22 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2010-09
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-09-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-08-23 00:00:00'
  and end_time <= '2010-09-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-09 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-09-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-08-23 00:00:00'
        and end_time <= '2010-09-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2010-10
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-10-25'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-09-25 00:00:00'
  and end_time <= '2010-10-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-10 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-10-25'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-09-25 00:00:00'
        and end_time <= '2010-10-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2010-11
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-11-22'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-10-25 00:00:00'
  and end_time <= '2010-11-22 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-11 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-11-22'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-10-25 00:00:00'
        and end_time <= '2010-11-22 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2010-12
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-12-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-11-23 00:00:00'
  and end_time <= '2010-12-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-12 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2010-12-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-11-23 00:00:00'
        and end_time <= '2010-12-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2011-01
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-01-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2010-12-25 00:00:00'
  and end_time <= '2011-01-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- 2010-12 openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-01-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2010-12-25 00:00:00'
        and end_time <= '2011-01-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');

-- 2011-02
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-02-23'
from compute_accounting,department
where name = group_name
  and end_time >= '2011-01-25 00:00:00'
  and end_time <= '2011-02-23 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-02-23'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2011-01-25 00:00:00'
        and end_time <= '2011-02-23 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2011-03
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-03-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2011-02-24 00:00:00'
  and end_time <= '2011-03-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-03-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2011-02-24 00:00:00'
        and end_time <= '2011-03-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2011-04
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-04-21'
from compute_accounting,department
where name = group_name
  and end_time >= '2011-03-25 00:00:00'
  and end_time <= '2011-04-21 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-04-21'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2011-03-25 00:00:00'
        and end_time <= '2011-04-21 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');



-- 2011-05
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-05-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2011-04-22 00:00:00'
  and end_time <= '2011-05-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-05-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2011-04-22 00:00:00'
        and end_time <= '2011-05-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2011-06
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-06-23'
from compute_accounting,department
where name = group_name
  and end_time >= '2011-05-25 00:00:00'
  and end_time <= '2011-06-23 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-06-23'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2011-05-25 00:00:00'
        and end_time <= '2011-06-23 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2011-07
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-07-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2011-06-24 00:00:00'
  and end_time <= '2011-07-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-07-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2011-06-24 00:00:00'
        and end_time <= '2011-07-25 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');


-- 2011-08
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-08-24'
from compute_accounting,department
where name = group_name
  and end_time >= '2011-07-25 00:00:00'
  and end_time <= '2011-08-24 23:59:59'
  and granted_pe != 'openmpi'
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
-- openmpi
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project, code, owner, date_format(end_time,'%Y-%m-%d'), sum(ru_wallclock*slots), .11, round(sum(ru_wallclock*slots)/3600,2),
round(round(sum(ru_wallclock*slots)/3600,2)*.11,2), '2011-07-24'
from (
      select distinct project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,ru_wallclock, slots,jobnumber
      from compute_accounting,department
      where name = group_name
        and end_time >= '2011-07-25 00:00:00'
        and end_time <= '2011-08-24 23:59:59'
        and granted_pe = 'openmpi') x
group by project, code, owner,date_format(end_time,'%Y-%m-%d');
