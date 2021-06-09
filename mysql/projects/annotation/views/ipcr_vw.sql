CREATE OR REPLACE VIEW  ipcr_session_vw AS
SELECT session_id as id
      ,MAX(IF(STRCMP(session_property_type.name,'alternative'),null,session_property.value)) AS 'alternative'
      ,MAX(IF(STRCMP(session_property_type.name,'comments'),null,session_property.value)) AS 'comments'
      ,MAX(IF(STRCMP(session_property_type.name,'confidence'),null,session_property.value)) AS 'confidence'
      ,MAX(IF(STRCMP(session_property_type.name,'cytology'),null,session_property.value)) AS 'cytology'
      ,MAX(IF(STRCMP(session_property_type.name,'description'),null,session_property.value)) AS 'description'
      ,MAX(IF(STRCMP(session_property_type.name,'mapped_date'),null,session_property.value)) AS 'mapped_date'
      ,MAX(IF(STRCMP(session_property_type.name,'pelement'),null,session_property.value)) AS 'pelement'
      ,MAX(IF(STRCMP(session_property_type.name,'trapped'),null,session_property.value)) AS 'trapped'
FROM session_property
JOIN cv_term session_property_type on ( session_property.type_id = session_property_type.id)
GROUP BY session_id
;

CREATE OR REPLACE VIEW ipcr_vw AS
SELECT line.name as line
      ,line.gene
      ,session.lab
      ,ipcr_session_vw.*
FROM ipcr_session_vw
JOIN session on (ipcr_session_vw.id = session.id)
JOIN line on (session.line_id = line.id)
JOIN cv_term on (session.type_id = cv_term.id)
JOIN cv on (cv_term.cv_id = cv.id)
WHERE cv_term.name='ipcr' AND cv.name='ipcr'
;

