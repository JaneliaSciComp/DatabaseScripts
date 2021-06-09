SELECT
   m.name as substack_name,
   a.id as assignment_id,
   date(a.complete_date)          AS complete_date ,
   c.name                               AS assignment_type,
   u.name                               AS user,
   132.651                  AS volume,
   SUM(ap2.value) as session_hours,
   CAST(SUM(an.value) AS unsigned)      AS total,
   (SUM(an.value)/SUM(ap.value))        AS rate_working,
   (SUM(an.value)/SUM(ap2.value))       AS rate_session,
   (SUM(ap.value)/SUM(ap2.value)) *100  AS percent_working,
   (COUNT(an.value)*132.651/SUM(ap.value))  AS volume_rate_working,
   (COUNT(an.value)*132.651/SUM(ap2.value)) AS volume_rate_session
FROM annotation an
JOIN assignment a
ON an.assignment_id = a.id
JOIN annotation_property ap
ON an.id = ap.annotation_id
JOIN annotation_property ap2
ON an.id = ap2.annotation_id
JOIN
   cv_term c
ON
   c.id = a.type_id
JOIN
   media m
ON
   m.id = an.media_id
JOIN
   media_property mp
ON
   mp.media_id = m.id
JOIN
   USER u
ON
   an.user_id = u.id
JOIN
   cv_term c2
ON
   c2.id = mp.type_id
JOIN
   cv_term c3
ON
   c3.id = ap.type_id
JOIN
   cv_term c4
ON
   c4.id = ap2.type_id
JOIN
   cv_term c5
ON
   c5.id = m.type_id
WHERE
   a.is_complete = 1
AND c2.name = 'medulla_column'
AND c5.name = 'substack'
AND c3.name = 'raveler_working_time'
AND c4.name = 'raveler_session_time'
group by an.id
ORDER BY
   complete_date
