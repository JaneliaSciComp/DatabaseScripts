CREATE OR REPLACE VIEW  prelim_annotation_vw AS
SELECT prelim_annotation_session_vw.*
      ,line.name as line
      ,gene.name as gene
      ,session.name
      ,lab.name lab
      ,IF(STRCMP(prelim_annotation_observation_vw.name,'supergroup'),observation.name,null) as region
      ,IF(STRCMP(prelim_annotation_observation_vw.name,'expressed'),null,prelim_annotation_observation_vw.value) as expressed
      ,IF(STRCMP(prelim_annotation_observation_vw.name,'supergroup'),null,observation.name) as supergroup
FROM prelim_annotation_session_vw
JOIN session on (prelim_annotation_session_vw.id = session.id)
JOIN prelim_annotation_observation_vw ON (prelim_annotation_observation_vw.session_id = session.id)
JOIN cv_term observation on (prelim_annotation_observation_vw.term_id = observation.id)
JOIN line on (session.line_id = line.id)
JOIN gene on (line.gene_id = gene.id)
JOIN cv_term lab on (session.lab_id = lab.id)
;
