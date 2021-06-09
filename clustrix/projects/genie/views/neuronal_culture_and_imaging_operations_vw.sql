CREATE OR REPLACE VIEW neuronal_culture_and_imaging_operations_vw AS
SELECT  pw.plate_id AS plate_id
       ,p.name AS plate
       ,pw.id AS well_id
       ,pw.well AS well
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_protocol'),null,pwp.value)) AS 'field_stimulation_protocol'
       ,MAX(IF(STRCMP(ct.name,'imaging_protocol'),null,pwp.value)) AS 'imaging_protocol'
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_request_date'),null,pwp.value)) AS 'field_stimulation_request_date'
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_complete_date'),null,pwp.value)) AS 'field_stimulation_complete_date'
       ,MAX(IF(STRCMP(ct.name,'field_stimulation_operator'),null,pwp.value)) AS 'field_stimulation_operator'
FROM plate p
JOIN plate_well pw ON (pw.plate_id = p.id)
JOIN plate_well_property pwp ON (pwp.plate_well_id = pw.id)
JOIN cv_term ct ON (pwp.type_id = ct.id)
GROUP BY pw.plate_id,pw.id;
