/* 
    name: stock_event_history

    mv:   

    app:  
    
    note: 
*/

-- =================================================== 
-- create temp table
-- =================================================== 
DROP TABLE IF EXISTS stock_event_history_temp;

CREATE TABLE stock_event_history_temp
SELECT
    (
        CASE
            WHEN (`h`.`change_type` = _latin1'insert')
            THEN _latin1'orig'
            ELSE `h`.`change_type`
        END) AS `event`,
    (
        CASE
            WHEN (`h`.`change_type` = _latin1'flip a')
            THEN `h`.`last_flipped`
            WHEN (`h`.`change_type` = _latin1'flip b')
            THEN `h`.`last_flipped_b`
            ELSE `h`.`change_datetime`
        END)          AS `event_date`,
    `sf`.`Stock_Name` AS `stock_name`,
    `h`.`stock_id`    AS `robot_id`,
    _latin1''         AS `wish_list`,
    _latin1''         AS `lab_project`,
    _latin1''         AS `project`,
    _latin1''         AS `cross_type`,
    _latin1''         AS `cross_barcode`,
    _latin1''         AS `cross_effector`,
    _latin1''         AS `notes`,
    ''                AS `cross_stock_name2`
FROM
    (`flystocks_stock_history` `h`
LEFT JOIN
    `StockFinder` `sf`
ON
    ((
            `h`.`stock_id` = `sf`.`RobotID`)))
WHERE
    (
        `h`.`change_type` IN (_latin1'flip a',
                              _latin1'flip b'))
UNION
SELECT
    _latin1'cross'                                                            AS `event`,
    `all_project_crosses_w_stock_info_vw`.`Date_Crossed`                      AS `event_date`,
    `all_project_crosses_w_stock_info_vw`.`Stock_Name`                        AS `stock_name`,
    `all_project_crosses_w_stock_info_vw`.`RobotID`                           AS `robot_id`,
    `all_project_crosses_w_stock_info_vw`.`Wish_List`                         AS `wish_list`,
    `all_project_crosses_w_stock_info_vw`.`Lab_Project`                       AS `lab_project`,
    `all_project_crosses_w_stock_info_vw`.`Project`                           AS `project`,
    `all_project_crosses_w_stock_info_vw`.`Cross_Type`                        AS `cross_type`,
    `all_project_crosses_w_stock_info_vw`.`__kp_ProjectCrosses_Serial_Number` AS `barcode`,
    `all_project_crosses_w_stock_info_vw`.`Reporter`                          AS `reportor`,
    ''                                                                        AS `notes`,
    `all_project_crosses_w_stock_info_vw`.`Parent2_Stockname`                 AS `cross_stock_name2`
FROM
    `all_project_crosses_w_stock_info_vw`
UNION
SELECT
    concat('copy ',`R`.`copy`,' entered rehab') AS `event`,
    `R`.`timein`                                AS `event_date`,
    `S`.`Stock_Name`                            AS `stock_name`,
    `R`.`robotid`                               AS `robot_id`,
    ''                                          AS `wish_list`,
    ''                                          AS `lab_project`,
    ''                                          AS `project`,
    ''                                          AS `cross_type`,
    ''                                          AS `barcode`,
    ''                                          AS `reportor`,
    (
        CASE
            WHEN (`R`.`mix` = 'yes')
            THEN 'mixed'
            ELSE ''
        END) AS `notes`,
    ''                                          AS `cross_stock_name2`
FROM
    (`Rehab` `R`
JOIN
    `StockFinder` `S`
ON
    ((
            `R`.`kf_puid` = `S`.`__kp_UniqueID`)))
WHERE
    (
        `R`.`timein` IS NOT NULL)
UNION
SELECT
    concat('copy ',`R`.`copy`,' left rehab') AS `event`,
    `R`.`timeout`                            AS `event_date`,
    `S`.`Stock_Name`                         AS `stock_name`,
    `R`.`robotid`                            AS `robot_id`,
    ''                                       AS `wish_list`,
    ''                                       AS `lab_project`,
    ''                                       AS `project`,
    ''                                       AS `cross_type`,
    ''                                       AS `barcode`,
    ''                                       AS `reportor`,
    ''                                       AS `notes`,
    ''                                       AS `cross_stock_name2`
FROM
    (`Rehab` `R`
JOIN
    `StockFinder` `S`
ON
    ((
            `R`.`kf_puid` = `S`.`__kp_UniqueID`)))
WHERE
    (
        `R`.`timeout` IS NOT NULL);

ALTER TABLE stock_event_history_temp ADD INDEX stock_event_history_temp_ix1 (event);
ALTER TABLE stock_event_history_temp ADD INDEX stock_event_history_temp_ix2 (event_date);
ALTER TABLE stock_event_history_temp ADD INDEX stock_event_history_temp_ix3 (stock_name);
ALTER TABLE stock_event_history_temp ADD INDEX stock_event_history_temp_ix4 (robot_id);
ALTER TABLE stock_event_history_temp ADD INDEX stock_event_history_temp_ix5 (wish_list);

-- =================================================== 
-- create materialized view
-- =================================================== 
DROP TABLE IF EXISTS stock_event_history_mv;
RENAME TABLE stock_event_history_temp TO stock_event_history_mv;

-- =================================================== 
-- create API view
-- =================================================== 
CREATE OR REPLACE VIEW stock_event_history_vw AS
SELECT *
FROM stock_event_history_mv;

