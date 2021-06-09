/* 
    name: image_data_flylight_flip_vw; image_data_flylight_collaborations_vw; image_data_flylight_rd_vw; image_data_rubin_chacrm_vw 

    mv:

    app:  SAGE REST API
    
    note:
*/
CREATE OR REPLACE VIEW image_data_flylight_flip_vw AS
SELECT mv.*
      ,i.url
      ,i.path
FROM image_data_mv mv
JOIN image i on mv.id = i.id
WHERE mv.family = 'flylight_flip';

CREATE OR REPLACE VIEW image_data_flylight_collaborations_vw AS
SELECT mv.*
      ,i.url
      ,i.path
FROM image_data_mv mv
JOIN image i on mv.id = i.id
WHERE mv.family = 'flylight_collaborations';

CREATE OR REPLACE VIEW image_data_flylight_rd_vw AS
SELECT mv.*
      ,i.url
      ,i.path
FROM image_data_mv mv
JOIN image i on mv.id = i.id
WHERE mv.family = 'flylight_rd';

CREATE OR REPLACE VIEW image_data_rubin_chacrm_vw AS
SELECT mv.*
      ,i.url
      ,i.path
FROM image_data_mv mv
JOIN image i on mv.id = i.id
WHERE mv.family = 'rubin_chacrm';
