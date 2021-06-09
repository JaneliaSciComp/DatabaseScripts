/* 
    olympiad_gap_analysis_vw
    
*/

CREATE OR REPLACE VIEW olympiad_gap_analysis_vw AS


SELECT
	straight_join
	l.id as line_id, 
	l.name as line_name, 
	e.id as experiment_id,
	e.name as experiment_name,
	s.id as session_id,
	s.name as session_name,
	first_frame_disk6_occupied.value as first_frame_disk6_occupied,
	first_max_mean_disk_frame.value as first_max_mean_disk_frame,
	uncompress(first_max_mean_disk_frame_window.value) as first_max_mean_disk_frame_window,
	last_mean_disk.value as last_mean_disk,
	max_mean_disk.value as max_mean_disk,
	min_arena_total.value as min_arena_total,
	max_arena_total.value as max_arena_total,
	mean_arena_total.value as mean_arena_total,
	median_arena_total.value as median_arena_total,
	std_arena_total.value as std_arena_total
FROM
	experiment e 
	join session s on s.experiment_id = e.id and s.type_id = getCvTermId('fly_olympiad_gap', 'gap_crossing', NULL)
	join line l on s.line_id = l.id   
	join score first_frame_disk6_occupied on first_frame_disk6_occupied.session_id = s.id and first_frame_disk6_occupied.type_id = getCvTermId('fly_olympiad_gap', 'first_frame_disk6_occupied', NULL)
	join score first_max_mean_disk_frame on first_max_mean_disk_frame.session_id = s.id and first_max_mean_disk_frame.type_id = getCvTermId('fly_olympiad_gap', 'first_max_mean_disk_frame', NULL)
	join score last_mean_disk on last_mean_disk.session_id = s.id and last_mean_disk.type_id = getCvTermId('fly_olympiad_gap', 'last_mean_disk', NULL)
	join score max_arena_total on max_arena_total.session_id = s.id and max_arena_total.type_id = getCvTermId('fly_olympiad_gap', 'max_arena_total', NULL)
	join score min_arena_total on min_arena_total.session_id = s.id and min_arena_total.type_id = getCvTermId('fly_olympiad_gap', 'min_arena_total', NULL)
	join score max_mean_disk on max_mean_disk.session_id = s.id and max_mean_disk.type_id = getCvTermId('fly_olympiad_gap', 'max_mean_disk', NULL)
	join score mean_arena_total on mean_arena_total.session_id = s.id and mean_arena_total.type_id = getCvTermId('fly_olympiad_gap', 'mean_arena_total', NULL)
	join score median_arena_total on median_arena_total.session_id = s.id and median_arena_total.type_id = getCvTermId('fly_olympiad_gap', 'median_arena_total', NULL)
	join score std_arena_total on std_arena_total.session_id = s.id and std_arena_total.type_id = getCvTermId('fly_olympiad_gap', 'std_arena_total', NULL)
	join score_array first_max_mean_disk_frame_window on first_max_mean_disk_frame_window.session_id = s.id and first_max_mean_disk_frame_window.type_id = getCvTermId('fly_olympiad_gap', 'first_max_mean_disk_frame_window', NULL)
WHERE 
	e.type_id = getCvTermId('fly_olympiad_gap', 'gap_crossing', NULL)
;
