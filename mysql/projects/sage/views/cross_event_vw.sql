CREATE OR REPLACE VIEW cross_event_vw AS
SELECT e.id              AS id
      ,cv_term.name      AS process
      ,le.id             AS line_event_id 
      ,l.id              AS line_id
      ,l.name            AS line
      ,e.action          AS action
      ,e.operator        AS operator
      ,project.value     AS project
      ,lab.value         AS project_lab
      ,crossed.value     AS cross_type
      ,cross_barcode.value AS cross_barcode
      ,wish_list.value   AS wish_list
      ,effector.value    AS effector
      ,e.event_date      AS event_date
FROM event e
JOIN cv_term ON (e.process_id = cv_term.id AND cv_term.name = 'cross')
JOIN line_event le ON (e.id = le.event_id)
JOIN line l on (l.id = le.line_id)
JOIN event_property project ON (project.event_id = e.id)
JOIN cv_term project_term ON (project.type_id = project_term.id AND project_term.name = 'project')
JOIN event_property lab ON (lab.event_id = e.id)
JOIN cv_term lab_term ON (lab.type_id = lab_term.id AND lab_term.name = 'project_lab')
JOIN event_property crossed ON (crossed.event_id = e.id)
JOIN cv_term crossed_term ON (crossed.type_id = crossed_term.id AND crossed_term.name = 'cross_type')
JOIN line_event_property effector ON (le.id = effector.line_event_id)
JOIN cv_term effector_term ON (effector.type_id = effector_term.id AND effector_term.name='effector')
JOIN line_event_property wish_list ON (le.id = wish_list.line_event_id)
JOIN cv_term wish_list_term ON (wish_list.type_id = wish_list_term.id AND wish_list_term.name='wish_list')
JOIN line_event_property cross_barcode ON (le.id = cross_barcode.line_event_id)
JOIN cv_term cross_barcode_term ON (cross_barcode.type_id = cross_barcode_term.id AND cross_barcode_term.name='cross_barcode')
;
