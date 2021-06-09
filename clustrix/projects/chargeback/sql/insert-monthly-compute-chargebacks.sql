select date_add(max(end_time),INTERVAL 1 DAY)  into @start_time from compute_chargeback;
select date_add(max(end_time),INTERVAL 1 MONTH)  into @end_time from compute_chargeback;
select date_add(date_format(date_add(max(close_date), INTERVAL 1 MONTH),'%Y-%m-01'), INTERVAL 14 DAY) into @close_date from compute_chargeback;
select '.07' into @rate;
select '.01' into @discount_rate;

-- spark jobs * slots * 16
insert into compute_chargeback (project, department_code, owner, end_time, wallclock, rate, units, cost, close_date)
select project
      ,code
      ,case account when 'sge' then owner else account end as owner
      ,date_format(end_time,'%Y-%m-%d') as end_time
      ,sum(ru_wallclock*slots*16) as wallclock
      ,(CASE
        WHEN (end_time between '2015-03-05 12:00:00' and '2015-03-06 06:00:00') THEN @discount_rate
        ELSE @rate
        END) as rate
      ,round(sum(ru_wallclock*slots*16)/3600,2) as units
      ,round(round(sum(ru_wallclock*slots*16)/3600,2)*@rate,2) as cost
      ,@close_date as close_date
from compute_accounting_fy15,department
where name = group_name
  and end_time >= concat(@start_time, ' 00:00:00')
  and end_time <= concat(@end_time, ' 23:59:59')
  and qname like 'hadoop%'
group by project, code, owner, account, date_format(end_time,'%Y-%m-%d')
union
-- non-impi jobs * slots
select project
      ,code
      ,case account when 'sge' then owner else account end as owner
      ,date_format(end_time,'%Y-%m-%d') as end_time
      ,sum(ru_wallclock*slots) as wallclock
      ,(CASE
        WHEN (end_time between '2015-03-05 12:00:00' and '2015-03-06 06:00:00') THEN @discount_rate
        ELSE @rate
        END) as rate
       ,round(sum(ru_wallclock*slots)/3600,2) as units
      ,(CASE
        WHEN (end_time between '2015-03-05 12:00:00' and '2015-03-06 06:00:00') THEN round(round(sum(ru_wallclock*slots)/3600,2)*@discount_rate,2)
        ELSE round(round(sum(ru_wallclock*slots)/3600,2)*@rate,2)
        END) as cost
      ,@close_date as close_date
      from compute_accounting_fy15,department
where name = group_name
  and end_time >= concat(@start_time, ' 00:00:00')
  and end_time <= concat(@end_time, ' 23:59:59')
  and granted_pe not like 'impi%'
group by project, code, owner, account, date_format(end_time,'%Y-%m-%d')
union
-- impi jobs (distinct job * slots)
select project
      ,code as department_code
      ,case account when 'sge' then owner else account end as owner
      ,date_format(end_time,'%Y-%m-%d') as end_time
      ,sum(ru_wallclock*slots) as wallclock
       ,(CASE
        WHEN (end_time between '2015-03-05 12:00:00' and '2015-03-06 06:00:00') THEN @discount_rate
        ELSE @rate
        END) as rate
        , round(sum(ru_wallclock*slots)/3600,2) as units
      , (CASE
        WHEN (end_time between '2015-03-05 12:00:00' and '2015-03-06 06:00:00') THEN round(round(sum(ru_wallclock*slots*16)/3600,2)*@discount_rate,2)
        ELSE round(round(sum(ru_wallclock*slots)/3600,2)*@rate,2)
        END) as cost
      ,@close_date as close_date
from (
      select  project, code, owner, date_format(end_time,'%Y-%m-%d') end_time ,max(ru_wallclock) ru_wallclock, max(slots) slots,jobnumber,account
      from compute_accounting_fy15,department
      where name = group_name
        and end_time >= concat(@start_time, ' 00:00:00')
        and end_time <= concat(@end_time, ' 23:59:59')
        and granted_pe like 'impi%'
      group by jobnumber) x
group by project, department_code, owner, account, date_format(end_time,'%Y-%m-%d')
