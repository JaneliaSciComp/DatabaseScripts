CREATE OR REPLACE VIEW
    query_report_data_vw
     AS
SELECT
    `p`.`name`                                                                        AS `plate`,
    `pw`.`id`                                                                         AS `well_id`,
    `pw`.`well`                                                                       AS `well`,
    `c`.`id`                                                                      AS `construct_id`,
    `c`.`category`                                                                    AS `category`,
    `c`.`name`                                                                       AS `construct`,
    `c`.`constructdb_number`                                                  AS `construct_number`,
    IFNULL(`r`.`name`,'')                                                                       AS `replicate`,
    MAX(IF(strcmp(`ct`.`name`,'b27_lot'),NULL,`pwp`.`value`))                         AS `b27_lot`,
    MAX(IF(strcmp(`ct`.`name`,'counting_dilution'),NULL,`pwp`.`value`))      AS `counting_dilution`,
    MAX(IF(strcmp(`ct`.`name`,'field_stimulation_complete_date'),NULL,`pwp`.`value`)) AS
    `field_stimulation_complete_date`,
    MAX(IF(strcmp(`ct`.`name`,'field_stimulation_operator'),NULL,`pwp`.`value`)) AS
    `field_stimulation_operator`,
    MAX(IF(strcmp(`ct`.`name`,'field_stimulation_protocol'),NULL,`pwp`.`value`)) AS
    `field_stimulation_protocol`,
    MAX(IF(strcmp(`ct`.`name`,'field_stimulation_request_date'),NULL,`pwp`.`value`)) AS
    `field_stimulation_request_date`,
    MAX(IF(strcmp(`ct`.`name`,'first_count_time'),NULL,`pwp`.`value`))        AS `first_count_time`,
    MAX(IF(strcmp(`ct`.`name`,'growth_medium_prep_date'),NULL,`pwp`.`value`)) AS
    `growth_medium_prep_date`,
    MAX(IF(strcmp(`ct`.`name`,'imaging_protocol'),NULL,`pwp`.`value`))        AS `imaging_protocol`,
    MAX(IF(strcmp(`ct`.`name`,'matrigel_lot'),NULL,`pwp`.`value`))               AS `matrigel_lot`,
    MAX(IF(strcmp(`ct`.`name`,'nds_prep_date'),NULL,`pwp`.`value`))              AS `nds_prep_date`,
    MAX(IF(strcmp(`ct`.`name`,'neuronal_culture_operator1'),NULL,`pwp`.`value`)) AS
    `neuronal_culture_operator1`,
    MAX(IF(strcmp(`ct`.`name`,'neuronal_culture_operator2'),NULL,`pwp`.`value`)) AS
    `neuronal_culture_operator2`,
    MAX(IF(strcmp(`ct`.`name`,'neuronal_culture_protocol'),NULL,`pwp`.`value`)) AS
    `neuronal_culture_protocol`,
    MAX(IF(strcmp(`ct`.`name`,'papain_lot'),NULL,`pwp`.`value`))               AS `papain_lot`,
    MAX(IF(strcmp(`ct`.`name`,'plate_complete_date'),NULL,`pwp`.`value`))  AS `plate_complete_date`,
    MAX(IF(strcmp(`ct`.`name`,'plate_request_date'),NULL,`pwp`.`value`))    AS `plate_request_date`,
    MAX(IF(strcmp(`ct`.`name`,'plating_medium_prep_date'),NULL,`pwp`.`value`)) AS
    `plating_medium_prep_date`,
    MAX(IF(strcmp(`ct`.`name`,'second_count_time'),NULL,`pwp`.`value`))     AS `second_count_time`,
    MAX(IF(strcmp(`ct`.`name`,'viable_cells'),NULL,`pwp`.`value`))          AS `viable_cells`,
    MAX(IF(strcmp(`ct2`.`name`,'arac_preparation_date'),NULL,`rp`.`value`)) AS
    `arac_preparation_date`,
    MAX(IF(strcmp(`ct2`.`name`,'construct_operator'),NULL,`rp`.`value`))    AS `construct_operator`,
    MAX(IF(strcmp(`ct2`.`name`,'date_packaging_cells_plated'),NULL,`rp`.`value`)) AS
    `date_packaging_cells_plated`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_conc_packaging_plasmid_2'),NULL,`rp`.`value`)) AS
    `dna_conc_packaging_plasmid_2`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_conc_packaging_plasmid_3'),NULL,`rp`.`value`)) AS
    `dna_conc_packaging_plasmid_3`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_conc_packaging_plasmid_4'),NULL,`rp`.`value`)) AS
    `dna_conc_packaging_plasmid_4`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_lot_packaging_plasmid_2'),NULL,`rp`.`value`)) AS
    `dna_lot_packaging_plasmid_2`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_lot_packaging_plasmid_3'),NULL,`rp`.`value`)) AS
    `dna_lot_packaging_plasmid_3`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_lot_packaging_plasmid_4'),NULL,`rp`.`value`)) AS
    `dna_lot_packaging_plasmid_4`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_preparation_concentration'),NULL,`rp`.`value`)) AS
    `dna_preparation_concentration`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_preparation_volume'),NULL,`rp`.`value`)) AS
    `dna_preparation_volume`,
    MAX(IF(strcmp(`ct2`.`name`,'dna_transfection_micrograms'),NULL,`rp`.`value`)) AS
    `dna_transfection_micrograms`,
    MAX(IF(strcmp(`ct2`.`name`,'electroporation_protocol'),NULL,`rp`.`value`)) AS
    `electroporation_protocol`,
    MAX(IF(strcmp(`ct2`.`name`,'infection_completed_date'),NULL,`rp`.`value`)) AS
    `infection_completed_date`,
    MAX(IF(strcmp(`ct2`.`name`,'infection_process_operator'),NULL,`rp`.`value`)) AS
    `infection_process_operator`,
    MAX(IF(strcmp(`ct2`.`name`,'infection_protocol'),NULL,`rp`.`value`))    AS `infection_protocol`,
    MAX(IF(strcmp(`ct2`.`name`,'lentiviral_construct_cloned_date'),NULL,`rp`.`value`)) AS
    `lentiviral_construct_cloned_date`,
    MAX(IF(strcmp(`ct2`.`name`,'lentiviral_dna_production_complete_date'),NULL,`rp`.`value`)) AS
    `lentiviral_dna_production_complete_date`,
    MAX(IF(strcmp(`ct2`.`name`,'lentiviral_dna_production_operator'),NULL,`rp`.`value`)) AS
    `lentiviral_dna_production_operator`,
    MAX(IF(strcmp(`ct2`.`name`,'lentiviral_particle_production_protocol'),NULL,`rp`.`value`)) AS
    `lentiviral_particle_production_protocol`,
    MAX(IF(strcmp(`ct2`.`name`,'lentiviral_particle_production_operator'),NULL,`rp`.`value`)) AS
    `lentiviral_particle_production_operator`,
    MAX(IF(strcmp(`ct2`.`name`,'lentiviral_preparation_volume'),NULL,`rp`.`value`)) AS
    `lentiviral_preparation_volume`,
    MAX(IF(strcmp(`ct2`.`name`,'lentivirus_production_complete_date'),NULL,`rp`.`value`)) AS
    `lentivirus_production_complete_date`,
    MAX(IF(strcmp(`ct2`.`name`,'lentivirus_production_request_date'),NULL,`rp`.`value`)) AS
    `lentivirus_production_request_date`,
    MAX(IF(strcmp(`ct2`.`name`,'packaging_cell_density_plating'),NULL,`rp`.`value`)) AS
    `packaging_cell_density_plating`,
    MAX(IF(strcmp(`ct2`.`name`,'packaging_cell_density_transfection'),NULL,`rp`.`value`)) AS
    `packaging_cell_density_transfection`,
    MAX(IF(strcmp(`ct2`.`name`,'packaging_cell_operator'),NULL,`rp`.`value`)) AS
    `packaging_cell_operator`,
    MAX(IF(strcmp(`ct2`.`name`,'packaging_cell_passage'),NULL,`rp`.`value`)) AS
    `packaging_cell_passage`,
    MAX(IF(strcmp(`ct2`.`name`,'transfection_efficiency_green'),NULL,`rp`.`value`)) AS
    `transfection_efficiency_green`,
    MAX(IF(strcmp(`ct2`.`name`,'transfection_efficiency_red'),NULL,`rp`.`value`)) AS
    `transfection_efficiency_red`,
    MAX(IF(strcmp(`ct3`.`name`,'replicate_number'),NULL,`cp`.`value`)) AS `replicate_number`,
    MAX(IF(strcmp(`ct3`.`name`,'variant_type'),NULL,`cp`.`value`))     AS `variant_type`,
    MAX(IF(strcmp(`ct3`.`name`,'last_assay_date'),NULL,`cp`.`value`))  AS `last_assay_date`,
    MAX(IF(strcmp(`ct3`.`name`,'1_fp'),NULL,`cp`.`value`))             AS `1_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'2_fp'),NULL,`cp`.`value`))             AS `2_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'3_fp'),NULL,`cp`.`value`))             AS `3_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'5_fp'),NULL,`cp`.`value`))             AS `5_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'10_fp'),NULL,`cp`.`value`))            AS `10_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'20_fp'),NULL,`cp`.`value`))            AS `20_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'40_fp'),NULL,`cp`.`value`))            AS `40_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'80_fp'),NULL,`cp`.`value`))            AS `80_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'160_fp'),NULL,`cp`.`value`))           AS `160_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'decay_10_fp'),NULL,`cp`.`value`))      AS `decay_10_fp`,
    MAX(IF(strcmp(`ct3`.`name`,'norm_f0'),NULL,`cp`.`value`))          AS `nf0`,
    MAX(IF(strcmp(`ct3`.`name`,'1_fp_p'),NULL,`cp`.`value`))           AS `1_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'2_fp_p'),NULL,`cp`.`value`))           AS `2_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'3_fp_p'),NULL,`cp`.`value`))           AS `3_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'5_fp_p'),NULL,`cp`.`value`))           AS `5_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'10_fp_p'),NULL,`cp`.`value`))          AS `10_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'20_fp_p'),NULL,`cp`.`value`))          AS `20_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'40_fp_p'),NULL,`cp`.`value`))          AS `40_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'80_fp_p'),NULL,`cp`.`value`))          AS `80_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'160_fp_p'),NULL,`cp`.`value`))         AS `160_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'decay_10_fp_p'),NULL,`cp`.`value`))    AS `decay_10_fp_p`,
    MAX(IF(strcmp(`ct3`.`name`,'norm_f0_p'),NULL,`cp`.`value`))        AS `norm_f0_p`
FROM
    ((((((((((`plate` `p`
LEFT JOIN
    `plate_well` `pw`
ON
    ((
            `pw`.`plate_id` = `p`.`id`)))
LEFT JOIN
    `plate_well_property` `pwp`
ON
    ((
            `pwp`.`plate_well_id` = `pw`.`id`)))
LEFT JOIN
    `cv_term` `ct`
ON
    ((
            `pwp`.`type_id` = `ct`.`id`)))
LEFT JOIN
    `replicate` `r`
ON
    ((
            `pw`.`replicate_id` = `r`.`id`)))
LEFT JOIN
    `construct` `c`
ON
    ((
            `c`.`id` = `r`.`construct_id`)))
LEFT JOIN
    `replicate_property` `rp`
ON
    ((
            `rp`.`replicate_id` = `r`.`id`)))
LEFT JOIN
    `cv_term` `ct2`
ON
    ((
            `rp`.`type_id` = `ct2`.`id`)))
LEFT JOIN
    `construct_property` `cp`
ON
    ((
            `cp`.`construct_id` = `c`.`id`)))
LEFT JOIN
    `cv_term` `ct3`
ON
    ((
            `cp`.`type_id` = `ct3`.`id`)))
LEFT JOIN
    `cv`
ON
    (((
                `ct3`.`cv_id` = `cv`.`id`)
        AND (
                `cv`.`name` = 'data_all'))))
GROUP BY
    `pw`.`plate_id`,
    `pw`.`id`
ORDER BY
    `c`.`category`,
    `c`.`construct`
;

DROP TABLE IF EXISTS tmp_query_report_mv;

CREATE TABLE tmp_query_report_mv AS
SELECT * FROM query_report_data_vw WHERE 1 = 2;

ALTER TABLE tmp_query_report_mv MODIFY COLUMN `replicate` varchar(255) CHARACTER SET latin1;

INSERT INTO tmp_query_report_mv SELECT * from query_report_data_vw;

CREATE INDEX query_report_mv_plate_well_id_ind ON tmp_query_report_mv(well_id);
CREATE INDEX query_report_mv_well_ind ON tmp_query_report_mv(well);
CREATE INDEX query_report_mv_plate_ind ON tmp_query_report_mv(plate);
CREATE INDEX query_report_mv_construct_id_ind ON tmp_query_report_mv(construct_id);
CREATE INDEX query_report_mv_construct_ind ON tmp_query_report_mv(construct);

DROP TABLE IF EXISTS query_report_mv;
RENAME TABLE tmp_query_report_mv TO query_report_mv;

CREATE OR REPLACE VIEW query_report_vw AS
SELECT * FROM query_report_mv;
