CREATE OR REPLACE VIEW image_gene_vw AS
SELECT image.id as image_id,
       image.family,
       image_property.value as 'gene'
FROM image 
JOIN image_property ON (image.id = image_id AND image_property.type = 'gene');
