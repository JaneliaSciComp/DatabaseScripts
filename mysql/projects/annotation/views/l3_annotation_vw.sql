CREATE OR REPLACE VIEW  l3_annotation_observation_vw AS
SELECT session_id
      ,term_id
      ,observation_type.name
      ,o.value
FROM observation o
JOIN cv_term observation_type ON (o.type_id = observation_type.id and observation_type.name in ('hemilineages','intensity'))
;


CREATE OR REPLACE VIEW  l3_annotation_session_vw AS
SELECT session_id as id
      ,MAX(IF(STRCMP(session_property_type.name,'projection_all_url'),null,session_property.value)) AS 'projection_all_url'
      ,MAX(IF(STRCMP(session_property_type.name,'image_name'),null,session_property.value)) AS 'image_name'
FROM session_property
JOIN cv_term session_property_type on ( session_property.type_id = session_property_type.id)
JOIN session on ( session_property.session_id = session.id)
JOIN cv_term session_type on ( session.type_id = session_type.id)
JOIN cv on ( session_type.cv_id = cv.id)
WHERE cv.name='l3_annotation'
GROUP BY session_id
;

CREATE OR REPLACE VIEW  l3_annotation_vw AS
SELECT l3_annotation_session_vw.*
      ,line.name as line
      ,line.gene
      ,session.name
      ,session.lab
      ,cv_term.name as region
      ,IF(STRCMP(l3_annotation_observation_vw.name,'hemilineages'),null,l3_annotation_observation_vw.value) as hemilineages
      ,IF(STRCMP(l3_annotation_observation_vw.name,'intensity'),null,l3_annotation_observation_vw.value) as intensity
FROM l3_annotation_session_vw
JOIN session on (l3_annotation_session_vw.id = session.id)
JOIN l3_annotation_observation_vw ON (l3_annotation_observation_vw.session_id = session.id)
JOIN cv_term on (l3_annotation_observation_vw.term_id = cv_term.id)
JOIN line on (session.line_id = line.id)
;

