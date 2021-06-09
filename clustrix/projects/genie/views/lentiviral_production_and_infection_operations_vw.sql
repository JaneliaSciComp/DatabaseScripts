CREATE OR REPLACE VIEW lentiviral_production_and_infection_operations_vw AS
SELECT  c.id AS construct_id
       ,c.name AS construct
       ,r.id AS replicate_id
       ,r.name AS replicate
       ,pw.plate_id AS plate_id
       ,p.name AS plate
       ,pw.id AS well_id
       ,pw.well AS well
       ,MAX(IF(STRCMP(ct.name,'arac_preparation_date'),null,rp.value)) AS 'arac_preparation_date'
       ,MAX(IF(STRCMP(ct.name,'construct_operator'),null,rp.value)) AS 'construct_operator'
       ,MAX(IF(STRCMP(ct.name,'date_packaging_cells_plated'),null,rp.value)) AS 'date_packaging_cells_plated'
       ,MAX(IF(STRCMP(ct.name,'dna_conc_packaging_plasmid_2'),null,rp.value)) AS 'dna_conc_packaging_plasmid_2'
       ,MAX(IF(STRCMP(ct.name,'dna_conc_packaging_plasmid_3'),null,rp.value)) AS 'dna_conc_packaging_plasmid_3'
       ,MAX(IF(STRCMP(ct.name,'dna_conc_packaging_plasmid_4'),null,rp.value)) AS 'dna_conc_packaging_plasmid_4'
       ,MAX(IF(STRCMP(ct.name,'dna_lot_packaging_plasmid_2'),null,rp.value)) AS 'dna_lot_packaging_plasmid_2'
       ,MAX(IF(STRCMP(ct.name,'dna_lot_packaging_plasmid_3'),null,rp.value)) AS 'dna_lot_packaging_plasmid_3'
       ,MAX(IF(STRCMP(ct.name,'dna_lot_packaging_plasmid_4'),null,rp.value)) AS 'dna_lot_packaging_plasmid_4'
       ,MAX(IF(STRCMP(ct.name,'dna_preparation_concentration'),null,rp.value)) AS 'dna_preparation_concentration'
       ,MAX(IF(STRCMP(ct.name,'dna_preparation_volume'),null,rp.value)) AS 'dna_preparation_volume'
       ,MAX(IF(STRCMP(ct.name,'dna_transfection_micrograms'),null,rp.value)) AS 'dna_transfection_micrograms'
       ,MAX(IF(STRCMP(ct.name,'infection_completed_date'),null,rp.value)) AS 'infection_completed_date'
       ,MAX(IF(STRCMP(ct.name,'infection_process_operator'),null,rp.value)) AS 'infection_process_operator'
       ,MAX(IF(STRCMP(ct.name,'infection_protocol'),null,rp.value)) AS 'infection_protocol'
       ,MAX(IF(STRCMP(ct.name,'lentiviral_construct_cloned_date'),null,rp.value)) AS 'lentiviral_construct_cloned_date'
       ,MAX(IF(STRCMP(ct.name,'lentiviral_dna_production_complete_date'),null,rp.value)) AS 'lentiviral_dna_production_complete_date'
       ,MAX(IF(STRCMP(ct.name,'lentiviral_dna_production_operator'),null,rp.value)) AS 'lentiviral_dna_production_operator'
       ,MAX(IF(STRCMP(ct.name,'lentiviral_particle_production_protocol'),null,rp.value)) AS 'lentiviral_particle_production_protocol'
       ,MAX(IF(STRCMP(ct.name,'lentiviral_preparation_volume'),null,rp.value)) AS 'lentiviral_preparation_volume'
       ,MAX(IF(STRCMP(ct.name,'lentivirus_production_complete_date'),null,rp.value)) AS 'lentivirus_production_complete_date'
       ,MAX(IF(STRCMP(ct.name,'lentivirus_production_request_date'),null,rp.value)) AS 'lentivirus_production_request_date'
       ,MAX(IF(STRCMP(ct.name,'packaging_cell_density_plating'),null,rp.value)) AS 'packaging_cell_density_plating'
       ,MAX(IF(STRCMP(ct.name,'packaging_cell_density_transfection'),null,rp.value)) AS 'packaging_cell_density_transfection'
       ,MAX(IF(STRCMP(ct.name,'packaging_cell_operator'),null,rp.value)) AS 'packaging_cell_operator'
       ,MAX(IF(STRCMP(ct.name,'packaging_cell_passage'),null,rp.value)) AS 'packaging_cell_passage'
       ,MAX(IF(STRCMP(ct.name,'transfection_efficiency_green'),null,rp.value)) AS 'transfection_efficiency_green'
       ,MAX(IF(STRCMP(ct.name,'transfection_efficiency_red'),null,rp.value)) AS 'transfection_efficiency_red'
FROM construct c
join replicate r on (c.id = r.construct_id)
JOIN plate_well pw ON (pw.replicate_id = r.id)
JOIN plate p ON (pw.plate_id = p.id)
JOIN replicate_property rp ON (rp.replicate_id = r.id)
JOIN cv_term ct ON (rp.type_id = ct.id)
GROUP BY pw.id
;
