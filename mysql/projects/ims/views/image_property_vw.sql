CREATE OR REPLACE VIEW image_property_vw AS
SELECT gene,
       image_property_mv.*
FROM image_property_mv
LEFT OUTER JOIN image_gene_vw ON (image_gene_vw.image_id  = image_property_mv.id)
;
