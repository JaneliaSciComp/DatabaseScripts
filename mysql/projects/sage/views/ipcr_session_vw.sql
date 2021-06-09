CREATE OR REPLACE VIEW ipcr_session_vw AS
SELECT session_property_vw.session_id                                                              AS id
      ,MAX(IF(strcmp(session_property_vw.type,'alternative'),NULL,session_property_vw.value))      AS alternative
      ,MAX(IF(strcmp(session_property_vw.type,'balancer_status'),NULL,session_property_vw.value))  AS balancer_status
      ,MAX(IF(strcmp(session_property_vw.type,'comments'),NULL,session_property_vw.value))         AS comments
      ,MAX(IF(strcmp(session_property_vw.type,'confidence'),NULL,session_property_vw.value))       AS confidence
      ,MAX(IF(strcmp(session_property_vw.type,'cytology'),NULL,session_property_vw.value))         AS cytology
      ,MAX(IF(strcmp(session_property_vw.type,'insert_viability'),NULL,session_property_vw.value)) AS insert_viability
      ,MAX(IF(strcmp(session_property_vw.type,'mapped_date'),NULL,session_property_vw.value))      AS mapped_date
      ,MAX(IF(strcmp(session_property_vw.type,'mspi_trimmed'),NULL,session_property_vw.value))     AS mspi_trimmed
      ,MAX(IF(strcmp(session_property_vw.type,'pelement'),NULL,session_property_vw.value))         AS pelement
      ,MAX(IF(strcmp(session_property_vw.type,'sau3a_trimmed'),NULL,session_property_vw.value))    AS sau3a_trimmed
FROM session_property_vw
WHERE session_property_vw.cv = 'ipcr'
GROUP BY session_property_vw.session_id
;
