create or replace view single_neuron_driver_vw AS
select n.name as neuron
     ,l.name as line
     ,ct.name as term
     ,group_concat(concat(ct2.name, " (1)") SEPARATOR ", ") as expressed_regions
     ,max(l2.name) as line1
     ,IF(STRCMP(min(l2.name),max(l2.name)),min(l2.name),null) as line2
from neuron n
left join neuron_line nl on (nl.neuron_id = n.id)
left join line l on (l.id = nl.line_id)
left join line_relationship lr on (lr.subject_id = l.id)
left join line l2 on (lr.object_id = l2.id)
left join neuron_property np on (np.neuron_id = n.id) 
left join cv_term ct on (np.type_id = ct.id) 
left join cv on (cv.id = ct.cv_id) and cv.name='single_neuron_ontology'
left join neuron_property np2 on (np2.neuron_id = n.id) 
left join cv_term ct2 on (np2.type_id = ct2.id) 
left join cv cv2 on (cv2.id = ct2.cv_id) and cv2.name='single_neuron_ontology'
group by n.name, l.name, ct.name;

create or replace view image_data_neuron_vw AS
select
i.id,
i.name,
n.name as 'neuron',
ct.name as 'image_type',
MAX(IF(STRCMP(ct2.name, 'dimension_x'), NULL, ip.value)) AS 'dimension_x',
MAX(IF(STRCMP(ct2.name, 'dimension_y'), NULL, ip.value)) AS 'dimension_y',
MAX(IF(STRCMP(ct2.name, 'file_size'), NULL, ip.value)) AS 'file_size',
MAX(IF(STRCMP(ct2.name, 'release'), NULL, ip.value)) AS 'release'
from image i
join neuron n on n.id = i.neuron_id
join cv_term ct on ct.id = i.type_id
join image_property ip on i.id = ip.image_id
join cv_term ct2 on ct2.id = ip.type_id
group by i.id, i.name;
