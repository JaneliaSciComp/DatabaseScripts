select yearweek(a.complete_date) as yearweek , u.name as user, c.name as assignment_type, count(an.value) as substacks, count(an.value)*125 as volume, cast(sum(an.value)as unsigned) as total
      from annotation an
      join assignment a on a.id = an.assignment_id
      join cv_term c on c.id = a.type_id
      join media_vw m on m.id = an.media_id
      join media_property mp on mp.media_id = m.id
      join cv_term c2 on c2.id = mp.type_id 
      join user u on an.user_id = u.id
      where a.is_complete = 1
      and c2.name = 'medulla_column'
      and m.type='substack'
      group by c.name, yearweek(a.complete_date), an.user_id
      order by 1
