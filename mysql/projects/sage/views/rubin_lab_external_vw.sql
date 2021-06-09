CREATE OR REPLACE VIEW rubin_lab_external_vw AS
SELECT image_vw.name
      ,image_vw.family
      ,image_vw.representative
      ,x.created_by
      ,x.line 
      ,x.date
      ,x.disc
      ,x.stage
      ,x.external_lab
      ,x.width
      ,x.height
      ,image_vw.display
FROM rubin_lab_external_property_vw as x
JOIN image_vw on (x.id=image_vw.id);
