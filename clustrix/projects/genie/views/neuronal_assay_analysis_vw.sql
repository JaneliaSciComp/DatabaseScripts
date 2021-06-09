CREATE OR REPLACE VIEW
    neuronal_assay_analysis_vw
    (
        imaging_plate_id,
        imaging_plate,
        imaging_well_id,
        imaging_well,
        well_id,
        construct_id,
        construct,
        dff_10_ap,
        dff_160_ap,
        dff_1_ap,
        dff_20_ap,
        dff_2_ap,
        dff_3_ap,
        dff_40_ap,
        dff_5_ap,
        dff_80_ap,
        dff_max,
        dt1_2_10_ap,
        dt1_2_160_ap,
        es50,
        f0,
        fmax,
        mcherry,
        norm_f0,
        roi,
        rt1_2_10_ap,
        t1,
        t2,
        tpeak_10_ap
    ) AS
SELECT
    `ipw`.`imaging_plate_id`                                        AS `imaging_plate_id`,
    `ip`.`name`                                                     AS `imaging_plate`,
    `ipw`.`id`                                                      AS `imaging_well_id`,
    `ipw`.`well`                                                    AS `imaging_well`,
    `pw`.`id`                                                       AS `well_id`,
    `c`.`id`                                                        AS `construct_id`,
    `c`.`name`                                                      AS `construct`,
    MAX(IF(strcmp(`ct`.`name`,'dff_10_ap'),NULL,`ipwp`.`value`))    AS `dff_10_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_160_ap'),NULL,`ipwp`.`value`))   AS `dff_160_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_1_ap'),NULL,`ipwp`.`value`))     AS `dff_1_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_20_ap'),NULL,`ipwp`.`value`))    AS `dff_20_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_2_ap'),NULL,`ipwp`.`value`))     AS `dff_2_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_3_ap'),NULL,`ipwp`.`value`))     AS `dff_3_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_40_ap'),NULL,`ipwp`.`value`))    AS `dff_40_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_5_ap'),NULL,`ipwp`.`value`))     AS `dff_5_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_80_ap'),NULL,`ipwp`.`value`))    AS `dff_80_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dff_max'),NULL,`ipwp`.`value`))      AS `dff_max`,
    MAX(IF(strcmp(`ct`.`name`,'dt1_2_10_ap'),NULL,`ipwp`.`value`))  AS `dt1_2_10_ap`,
    MAX(IF(strcmp(`ct`.`name`,'dt1_2_160_ap'),NULL,`ipwp`.`value`)) AS `dt1_2_160_ap`,
    MAX(IF(strcmp(`ct`.`name`,'es50'),NULL,`ipwp`.`value`))         AS `es50`,
    MAX(IF(strcmp(`ct`.`name`,'f0'),NULL,`ipwp`.`value`))           AS `f0`,
    MAX(IF(strcmp(`ct`.`name`,'fmax'),NULL,`ipwp`.`value`))         AS `fmax`,
    MAX(IF(strcmp(`ct`.`name`,'mcherry'),NULL,`ipwp`.`value`))      AS `mcherry`,
    MAX(IF(strcmp(`ct`.`name`,'norm_f0'),NULL,`ipwp`.`value`))      AS `norm_f0`,
    MAX(IF(strcmp(`ct`.`name`,'roi'),NULL,`ipwp`.`value`))          AS `roi`,
    MAX(IF(strcmp(`ct`.`name`,'rt1_2_10_ap'),NULL,`ipwp`.`value`))  AS `rt1_2_10_ap`,
    MAX(IF(strcmp(`ct`.`name`,'t1'),NULL,`ipwp`.`value`))           AS `t1`,
    MAX(IF(strcmp(`ct`.`name`,'t2'),NULL,`ipwp`.`value`))           AS `t2`,
    MAX(IF(strcmp(`ct`.`name`,'tpeak_10_ap'),NULL,`ipwp`.`value`))  AS `tpeak_10_ap`
FROM
    ((((((`imaging_plate` `ip`
JOIN
    `imaging_plate_well` `ipw`
ON
    ((
            `ip`.`id` = `ipw`.`imaging_plate_id`)))
JOIN
    `plate_well` `pw`
ON
    ((
            `pw`.`id` = `ipw`.`plate_well_id`)))
JOIN
    `replicate` `r`
ON
    ((
            `pw`.`replicate_id` = `r`.`id`)))
JOIN
    `construct` `c`
ON
    ((
            `c`.`id` = `r`.`construct_id`)))
JOIN
    `imaging_plate_well_property` `ipwp`
ON
    ((
            `ipwp`.`imaging_plate_well_id` = `ipw`.`id`)))
JOIN
    `cv_term` `ct`
ON
    ((
            `ipwp`.`type_id` = `ct`.`id`)))
GROUP BY
    `ipw`.`id`