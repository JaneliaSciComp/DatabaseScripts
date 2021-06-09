select date_add(max(end_time),INTERVAL 1 DAY)  into @start_time from compute_usage;
select date_add(max(end_time),INTERVAL 6 MONTH)  into @end_time from compute_usage;

insert into compute_usage (type, project, code, owner, end_time, wallclock, wallclock_hours)
-- hadoop jobs * slots * 16
select 'spark' type
      ,project
      ,code
      ,case account when 'sge' then owner else account end as owner
      ,date_format(end_time,'%Y-%m-%d') as end_time
      ,sum(ru_wallclock*slots*16) as wallclock
      ,round(sum(ru_wallclock*slots*16)/3600,2) as wallclock_hours
from compute_accounting_fy15,department
where name = group_name
  and end_time >= concat(@start_time, ' 00:00:00')
  and end_time <= concat(@end_time, ' 23:59:59')
  and qname like 'hadoop%'
group by project, code, owner, account, date_format(end_time,'%Y-%m-%d')
union
-- non-impi jobs * slots
select 'non-impi'
      ,project
      ,code
      ,case account when 'sge' then owner else account end as owner
      ,date_format(end_time,'%Y-%m-%d') as end_time
      ,sum(ru_wallclock*slots) as wallclock
      ,round(sum(ru_wallclock*slots)/3600,2) as wallclock_hours
from compute_accounting_fy15,department
where name = group_name
  and end_time >= concat(@start_time, ' 00:00:00')
  and end_time <= concat(@end_time, ' 23:59:59')
  and granted_pe not like 'impi%'
  and (category not like '%exclusive=true%' or ( category like '%exclusive=true%' and slots !=1 ))
group by project, code, owner, account, date_format(end_time,'%Y-%m-%d')
union
-- impi jobs (distinct job * slots)
select 'impi'
      ,project
      ,code
      ,case account when 'sge' then owner else account end as owner
      ,date_format(end_time,'%Y-%m-%d') as end_time
      ,sum(ru_wallclock*slots) as wallclock
      , round(sum(ru_wallclock*slots)/3600,2) as wallclock_hours
from (
      select  project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,max(ru_wallclock) ru_wallclock, max(slots) slots,jobnumber,account
      from compute_accounting_fy15,department
      where name = group_name
        and end_time >= concat(@start_time, ' 00:00:00')
        and end_time <= concat(@end_time, ' 23:59:59')
        and granted_pe like 'impi%'
      group by jobnumber) x
group by project, code, owner, account, date_format(end_time,'%Y-%m-%d');
