select cjob,sum(amountlabor/85 ) from workorder 
where "_fk_department" = 'DEPT2' 
and date_billed between {d'2011-09-01'} and {d'2012-08-25'} 
group by cjob;