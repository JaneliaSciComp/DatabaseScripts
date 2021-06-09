/* 
    name: billing periods

    mv:   

    app:  
    
    note: 
*/

-- =================================================== 
-- create temp table
-- =================================================== 
DROP TABLE IF EXISTS billing_periods_mv_temp;

CREATE TABLE billing_periods_mv_temp
select date_start,
ifnull(date_end,date_add(date_start, interval 1 month)) as date_end
from
    (select distinct date_billed as date_start from WorkOrder where date_billed is not null) as s
    left outer join
    (select distinct date_billed as date_end from WorkOrder where date_billed is not null) as e
    on year(DATE_SUB(e.date_end, interval 1 month)) = year(s.date_start) and month(DATE_SUB(e.date_end, interval 1 month)) = month(s.date_start)
where date_start > '20100601'
order by date_start;

ALTER TABLE
    job_manager.billing_periods_mv_temp ADD PRIMARY KEY (date_start, date_end);
ALTER TABLE
    job_manager.billing_periods_mv_temp ADD INDEX ix1 (date_start);
ALTER TABLE
    job_manager.billing_periods_mv_temp ADD INDEX ix2 (date_end);
ALTER TABLE
    job_manager.billing_periods_mv_temp DEFAULT CHARSET=BINARY;


-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS billing_periods_mv;
RENAME TABLE billing_periods_mv_temp TO billing_periods_mv;

-- =================================================== 
-- create API view
-- =================================================== 
CREATE OR REPLACE VIEW billing_periods_vw AS
SELECT *
FROM billing_periods_mv;

