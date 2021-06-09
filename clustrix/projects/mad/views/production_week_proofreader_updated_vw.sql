select yearweek(a.complete_date) as yearweek ,c.name as assignment_type, u.name as user, 
        count(an.value) as substacks, count(an.value)*125 as volume, cast(sum(an.value) as unsigned) as total,
        (sum(an.value)/sum(ap.value)) as rate_working,(sum(an.value)/sum(ap2.value)) as rate_session,(sum(ap.value)/sum(ap2.value)) *100 as percent_working,
        (count(an.value)*125/sum(ap.value)) as volume_rate_working,(count(an.value)*125/sum(ap2.value)) as volume_rate_session
       from annotation an
       join assignment a on an.assignment_id = a.id
       join annotation_property ap on an.id = ap.annotation_id
       join annotation_property ap2 on an.id = ap2.annotation_id
       join cv_term c on c.id = a.type_id
       join media m on m.id = an.media_id
       join media_property mp on mp.media_id = m.id
       join user u on an.user_id = u.id
       join cv_term c2 on c2.id = mp.type_id 
       join cv_term c3 on c3.id = ap.type_id
       join cv_term c4 on c4.id = ap2.type_id
       join cv_term c5 on c5.id = m.type_id
       where a.is_complete = 1
       and c2.name = 'medulla_column'
       and c5.name = 'substack'
       and c3.name = 'raveler_working_time'
       and c4.name = 'raveler_session_time'
       group by c.name, yearweek(a.complete_date), an.user_id
       order by 1
