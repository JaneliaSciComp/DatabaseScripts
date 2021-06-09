CREATE OR REPLACE VIEW  prelim_annotation_observation_vw AS
SELECT session_id
      ,term_id
      ,term.name term
      ,observation_type.name
      ,o.value
FROM observation o
JOIN cv_term observation_type ON (o.type_id = observation_type.id and observation_type.name in ('expressed','supergroup','intensity_0004'))
JOIN cv_term term ON (o.term_id = term.id)
;
