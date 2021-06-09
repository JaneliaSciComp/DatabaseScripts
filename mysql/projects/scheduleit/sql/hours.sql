select s.scheduletitle,l.logon_name, m.name,round(sum(r.endtime - r.starttime)/60,2)
from scheduleit.reservations r
         ,scheduleit.schedules s
         , scheduleit.reservation_users u
        ,scheduleit.login l
        ,scheduleit.resources m
where r.scheduleid = s.scheduleid
    and u.resid = r.resid
    and u.memberid = l.memberid
    and r.machid = m.machid
    and r.start_date >= UNIX_TIMESTAMP( '2008-09-01')
    and r.start_date <= UNIX_TIMESTAMP( '2009-01-31')
   and s.scheduletitle in ('Microscopy','Cell Culture','Anatomy/Histology')
group by  s.scheduletitle,l.logon_name, m.name with rollup