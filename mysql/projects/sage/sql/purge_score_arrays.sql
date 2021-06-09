delete from score_array 
where cv_id = 30 
and not exists (select 1 from session s where s.id = session_id) and session_id is not null;

delete from score_array 
where cv_id = 31 
and not exists (select 1 from session s where s.id = session_id) and session_id is not null;

delete from score_array
where cv_id = 38
and not exists (select 1 from session s where s.id = session_id) and session_id is not null;

delete from score_array
where cv_id = 39
and not exists (select 1 from session s where s.id = session_id) and session_id is not null;

delete from score_array
where cv_id = 50
and not exists (select 1 from session s where s.id = session_id) and session_id is not null;


delete from score_array
where cv_id = 30
and not exists (select 1 from experiment e where e.id = experiment_id) and experiment_id is not null;

delete from score_array
where cv_id = 31
and not exists (select 1 from experiment e where e.id = experiment_id) and experiment_id is not null;

delete from score_array
where cv_id = 38
and not exists (select 1 from experiment e where e.id = experiment_id) and experiment_id is not null;

delete from score_array
where cv_id = 39
and not exists (select 1 from experiment e where e.id = experiment_id) and experiment_id is not null;

delete from score_array
where cv_id = 50
and not exists (select 1 from experiment e where e.id = experiment_id) and experiment_id is not null;

delete from score_array
where cv_id = 30
and not exists (select 1 from phase p where p.id = phase_id) and phase_id is not null;

delete from score_array
where cv_id = 31
and not exists (select 1 from phase p where p.id = phase_id) and phase_id is not null;

delete from score_array
where cv_id = 38
and not exists (select 1 from phase p where p.id = phase_id) and phase_id is not null;

delete from score_array
where cv_id = 39
and not exists (select 1 from phase p where p.id = phase_id) and phase_id is not null;

delete from score_array
where cv_id = 50
and not exists (select 1 from phase p where p.id = phase_id) and phase_id is not null;

