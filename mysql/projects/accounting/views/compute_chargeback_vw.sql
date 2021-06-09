CREATE VIEW
    compute_chargeback_vw ( id, project, department_name, department_code, owner, close_date, usage_date, wallclock, units, rate, cost ) AS
SELECT
    `compute_chargeback`.`id`                                                                         AS `id`,
    IF(strcmp(`compute_chargeback`.`project`,_latin1'NONE'),`compute_chargeback`.`project`,_latin1'') AS `project`,
    `department`.`name`                                                                               AS `department_name`,
    lpad(`department`.`code`,6,_latin1'0')                                                            AS `department_code`,
    `compute_chargeback`.`owner`                                                                      AS `owner`,
    date_format(`compute_chargeback`.`close_date`,_latin1'%Y-%m-%d')                                  AS `close_date`,
    date_format(`compute_chargeback`.`end_time`,_latin1'%Y-%m-%d')                                    AS `usage_date`,
    `compute_chargeback`.`wallclock`                                                                  AS `wallclock`,
    `compute_chargeback`.`units`                                                                      AS `units`,
    ROUND(`compute_chargeback`.`rate`,2)                                                              AS `rate`,
    ROUND(`compute_chargeback`.`cost`,2)                                                              AS `cost`
FROM `compute_chargeback`
JOIN `department` on (`compute_chargeback`.`department_code` = `department`.`code`)
WHERE `department`.`name` NOT IN (_latin1'admin',_latin1'scicomp');
