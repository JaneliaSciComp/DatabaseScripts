#!/bin/sh

cat << EOF | mysql -h clustrix2 --database=job_manager_reloaded -u job_managerAdmin  -pm@1@s@ur@ 
#DROP TABLE new_job_manager_reloaded_mv;
CREATE TABLE tmp_new_job_manager_reloaded_mv AS SELECT
    WO.id          AS _pk_workorder ,
    J.id          AS _fk_job ,
    'n/a'          AS _fk_phase ,
    IFNULL(REQ.id,0)          AS _fk_requesttype ,
    IFNULL(REQ.id,0)          AS _fk_requestsubtype ,
    IFNULL(REQ.id,0)          AS _fk_requestspecifictype ,
    CASE
    WHEN ISNULL(ASSN.id) THEN ASSN3.id 
    END  AS _fk_submitter ,
    DEPTWO.id          AS _fk_department ,
    IFNULL(ASSN.id,0)          AS _fk_staffassigned ,
    ASSN2.id          AS _fk_mainrequester ,
    DBILLTO.id  AS _fk_deptbillto ,
    WO.description AS WO_description ,
    WO.status      AS WO_status ,
    cast(wo_aggr.total as decimal)  AS WO_ctotal ,
    'n/a'          AS budgetamount ,
    WO.date_complete ,
    WO.date_promised ,
    WO.date_promised AS datepromisedrevised ,
    WO.date_submitted ,
    WO.admin_code          AS admincode ,
    WL.qty                  AS amountlabor ,
    WL.qty                 AS amountmaterial ,
    WO.hhmi_project_id     AS hhmiprojectid ,
    WO.flag_has_been_split AS flaghasbeensplit ,
    WO.date_billed ,
    WL.id  AS _pk_workorderline ,
    WL.performed_by_id  AS WL_fk_user ,
    WL.qty AS quantity ,
    WL.cost,
    cast( CASE  
        WHEN WL.fixed_cost !=0
        THEN WL.fixed_cost
        ELSE WL.qty * WL.cost
    END as decimal)            AS WL_ctotal ,
    WL.line_type  AS linetype ,
    WL.fixed_cost AS fixedcost ,
    'n/a'         AS _fk_catalog ,
    WL.unit ,
    WL.description                                AS WL_description ,
    WL.note                                       AS note ,
    DBILLTO.name                                  AS DBILLTO_departmentname ,
    DBILLTO.number                                AS DBILLTO_departmentbillingcode ,
    DBILLTO.number                                AS DBILLTO_departmentnumber ,
    DBILLTO.id                                    AS DBILLTO_departmentid,
    DEPTWO.name                                   AS DEPTWO_departmentname ,
    DEPTWO.number                                 AS DEPTWO_departmentbillingcode ,
    DEPTWO.number                                 AS DEPTWO_departmentnumber ,
    ASSN2.username                                AS MGR_DBILLTO_staffname ,
    WL.performed_by_id                            AS performed_by ,
    'n/a'                                         AS MGR_DBILLTO_positionname ,
    ASSN2.email                                   AS MGR_DBILLTO_email ,
    'n/a'                                         AS MGR_DEPTWO_staffname ,
    'n/a'                                         AS MGR_DEPTWO_positionname ,
    'n/a'                                          AS MGR_DEPTWO_email ,
    CASE WHEN ISNULL(ASSN.last_name) THEN concat(ASSN3.last_name, ', ', ASSN3.first_name) ELSE
    concat(ASSN.last_name, ', ', ASSN.first_name) END                      AS ASSN_staffname ,
    IFNULL(ASSN.username,' ')                                                      AS ASSN_positionname ,
    CASE WHEN ISNULL(ASSN.email) THEN ASSN3.email ELSE ASSN.email END AS ASSN_email ,
    J.name                                                             AS jobname ,
    J.status                                                           AS job_status ,
    J.description                                                      AS job_description,
    J.job_class                                                        AS class,
    CAST(concat(YEAR(b2.date_end) , '-' , MONTH(b2.date_end)) AS CHAR(50)) AS date_submitted_period,
    CAST(concat(YEAR(b1.date_end) , '-' , MONTH(b1.date_end)) AS CHAR(50)) AS date_complete_period,
    IFNULL(REQ.name,' ')                                                           AS requesttype,
    b1.date_end                                                        AS date_complete_date_end,
    ASSN2.username                                                     AS REQUESTER_staffname ,
    'n/a'                                                              AS REQUESTER_positionname ,
    'n/a'                                                              AS REQUESTER_email,
    IFNULL(b2.hours_covered_excl_holidays,b1.hours_covered_excl_holidays) AS hours_covered_excl_holidays_submitted_period,
    b1.hours_covered_excl_holidays                                     AS hours_covered_excl_holidays_completed_period,
    CAST(concat(YEAR(b1.date_end) , LPAD(MONTH(b1.date_end),2,'0')) AS CHAR(50)) AS
    date_complete_period_for_ranges
FROM
    TimeMatrix_workorderline WL
LEFT JOIN
    TimeMatrix_workorder WO
ON
    WL.wo_id_id = WO.id
LEFT JOIN
    TimeMatrix_department DBILLTO
ON
    WO.bill_to_id = DBILLTO.id
LEFT JOIN
    TimeMatrix_department DEPTWO
ON
    WO.department_id = DEPTWO.id
LEFT JOIN
    auth_user ASSN
ON
    WL.performed_by_id = ASSN.id
LEFT JOIN 
    auth_user ASSN2
ON
    WO.main_requestor_id = ASSN2.id  
LEFT JOIN 
    auth_user ASSN3
ON 
   WO.submitter_id = ASSN3.id      

LEFT JOIN
    TimeMatrix_job J
ON
    WO.job_id = J.id
LEFT JOIN
    TimeMatrix_request REQ
ON
    WO.request_type_id = REQ.id
LEFT JOIN
    TimeMatrix_billingperiod b1
ON
    WO.date_complete >= b1.date_start
AND WO.date_complete <= b1.date_end
LEFT JOIN
    TimeMatrix_billingperiod b2
ON
    WO.date_submitted >= b2.date_start
AND WO.date_submitted <= b2.date_end
    -- aggregate data
LEFT JOIN
    (
        SELECT
            wl1.wo_id_id,
            SUM(
                CASE
                    WHEN wl1.fixed_cost !=0
                    THEN wl1.fixed_cost
                    ELSE wl1.qty * wl1.cost
                END) AS total
        FROM
            TimeMatrix_workorderline wl1
        GROUP BY
            wl1.wo_id_id) wo_aggr
ON
    WO.id=wo_aggr.wo_id_id
;
alter table tmp_new_job_manager_reloaded_mv modify column WO_ctotal double;
alter table tmp_new_job_manager_reloaded_mv modify column WL_ctotal double;

-- drop new_job_manager_reloaded_mv data table
DROP TABLE IF EXISTS new_job_manager_reloaded_mv;

-- rename tmp_new_job_manager_reloaded_mv data temporary table to new_job_manager_reloaded_mv table
RENAME TABLE tmp_new_job_manager_reloaded_mv to new_job_manager_reloaded_mv;

create or replace view new_job_manager_reloaded_view as select * from new_job_manager_reloaded_mv;
EOF

