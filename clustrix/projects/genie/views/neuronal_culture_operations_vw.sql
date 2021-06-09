CREATE OR REPLACE VIEW neuronal_culture_operations_vw AS
SELECT  pw.plate_id AS plate_id
       ,p.name AS plate
       ,pw.id AS well_id
       ,pw.well AS well
       ,MAX(IF(STRCMP(ct.name,'b27_lot'),null,pwp.value)) AS 'b27_lot'
       ,MAX(IF(STRCMP(ct.name,'counting_dilution'),null,pwp.value)) AS 'counting_dilution'
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_complete_date'),null,pwp.value)) AS 'field_stimulation_complete_date'
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_operator'),null,pwp.value)) AS 'field_stimulation_operator'
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_protocol'),null,pwp.value)) AS 'field_stimulation_protocol'
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_request_date'),null,pwp.value)) AS 'field_stimulation_request_date'
       ,MAX(IF(STRCMP(ct.name,'first_count_time'),null,pwp.value)) AS 'first_count_time'
       ,MAX(IF(STRCMP(ct.name,'growth_medium_prep_date'),null,pwp.value)) AS 'growth_medium_prep_date'
       ,MAX(IF(STRCMP(ct.name,'imaging_protocol'),null,pwp.value)) AS 'imaging_protocol'
       ,MAX(IF(STRCMP(ct.name,'matrigel_lot'),null,pwp.value)) AS 'matrigel_lot'
       ,MAX(IF(STRCMP(ct.name,'nds_prep_date'),null,pwp.value)) AS 'nds_prep_date'
       ,MAX(IF(STRCMP(ct.name,'neuronal_culture_operator1'),null,pwp.value)) AS 'neuronal_culture_operator1'
       ,MAX(IF(STRCMP(ct.name,'neuronal_culture_operator2'),null,pwp.value)) AS 'neuronal_culture_operator2'
       ,MAX(IF(STRCMP(ct.name,'neuronal_culture_protocol'),null,pwp.value)) AS 'neuronal_culture_protocol'
       ,MAX(IF(STRCMP(ct.name,'papain_lot'),null,pwp.value)) AS 'papain_lot'
       ,MAX(IF(STRCMP(ct.name,'plate_complete_date'),null,pwp.value)) AS 'plate_complete_date'
       ,MAX(IF(STRCMP(ct.name,'plate_request_date'),null,pwp.value)) AS 'plate_request_date'
       ,MAX(IF(STRCMP(ct.name,'plating_medium_prep_date'),null,pwp.value)) AS 'plating_medium_prep_date'
       ,MAX(IF(STRCMP(ct.name,'second_count_time'),null,pwp.value)) AS 'second_count_time'
       ,MAX(IF(STRCMP(ct.name,'viable_cells'),null,pwp.value)) AS 'viable_cells'
FROM plate p
JOIN plate_well pw ON (pw.plate_id = p.id)
JOIN plate_well_property pwp ON (pwp.plate_well_id = pw.id)
JOIN cv_term ct ON (pwp.type_id = ct.id)
GROUP BY pw.id;
