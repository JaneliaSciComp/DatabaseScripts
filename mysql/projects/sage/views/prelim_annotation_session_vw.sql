CREATE OR REPLACE VIEW  prelim_annotation_session_vw AS
SELECT session_id as id
      ,MAX(IF(STRCMP(session_property_type.name,'age'),null,session_property.value)) AS 'age'
      ,MAX(IF(STRCMP(session_property_type.name,'organ'),null,session_property.value)) AS 'organ'
      ,MAX(IF(STRCMP(session_property_type.name,'projection_all_url'),null,session_property.value)) AS 'projection_all_url'
      ,MAX(IF(STRCMP(session_property_type.name,'image_name'),null,session_property.value)) AS 'image_name'
      ,MAX(IF(STRCMP(session_property_type.name,'extraordinary'),null,session_property.value)) AS 'extraordinary'
      ,MAX(IF(STRCMP(session_property_type.name,'specimen_quality'),null,session_property.value)) AS 'specimen_quality'
      ,MAX(IF(STRCMP(session_property_type.name,'very_broad'),null,session_property.value)) AS 'very_broad'
      ,MAX(IF(STRCMP(session_property_type.name,'done'),null,session_property.value)) AS 'done'
      ,MAX(IF(STRCMP(session_property_type.name,'empty'),null,session_property.value)) AS 'empty'
      ,MAX(IF(STRCMP(session_property_type.name,'panneural'),null,session_property.value)) AS 'panneural'
      ,MAX(IF(STRCMP(session_property_type.name,'substructure'),null,session_property.value)) AS 'substructure'
      ,MAX(IF(STRCMP(session_property_type.name,'heat_shock_age'),null,session_property.value)) AS 'heat_shock_age'
      ,MAX(IF(STRCMP(session_property_type.name,'representative'),null,session_property.value)) AS 'representative'
      ,MAX(IF(STRCMP(session_property_type.name,'expression_regions'),null,session_property.value)) AS 'expression_regions'
FROM session_property
JOIN cv_term session_property_type on ( session_property.type_id = session_property_type.id)
JOIN session on ( session_property.session_id = session.id)
JOIN cv_term session_type on ( session.type_id = session_type.id)
JOIN cv on ( session_type.cv_id = cv.id)
WHERE cv.name='prelim_annotation'
GROUP BY session_id
;
