CREATE OR REPLACE VIEW ipcr_vw AS
SELECT line_vw.name                     AS line
      ,line_vw.lab                      AS lab
      ,line_vw.gene                     AS gene
      ,ipcr_session_vw.id               AS id
      ,ipcr_session_vw.alternative      AS alternative
      ,ipcr_session_vw.balancer_status  AS balancer_status
      ,ipcr_session_vw.comments         AS comments
      ,ipcr_session_vw.confidence       AS confidence
      ,ipcr_session_vw.cytology         AS cytology
      ,ipcr_session_vw.insert_viability AS insert_viability
      ,ipcr_session_vw.mapped_date      AS mapped_date
      ,ipcr_session_vw.mspi_trimmed     AS mspi_trimmed
      ,ipcr_session_vw.pelement         AS pelement
      ,ipcr_session_vw.sau3a_trimmed    AS sau3a_trimmed
FROM line_vw
JOIN session ON (line_vw.id = session.line_id)
JOIN ipcr_session_vw ON (ipcr_session_vw.id = session.id)
;
