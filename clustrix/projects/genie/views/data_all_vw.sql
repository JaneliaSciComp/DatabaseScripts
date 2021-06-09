CREATE OR REPLACE VIEW data_all_vw AS
SELECT c.id AS construct_id
      ,c.category AS category
      ,c.construct AS number
      ,c.name AS construct 
      ,c.constructdb_number AS constructdb_number
      ,MAX(IF(STRCMP(ct.name,'replicate_number'),null,cp.value)) AS 'replicate_number'
      ,MAX(IF(STRCMP(ct.name,'variant_type'),null,cp.value)) AS 'variant_type'
      ,MAX(IF(STRCMP(ct.name,'last_assay_date'),null,cp.value)) AS 'last_assay_date'
      ,MAX(IF(STRCMP(ct.name,'1_fp'),null,cp.value)) AS '1_fp'
      ,MAX(IF(STRCMP(ct.name,'2_fp'),null,cp.value)) AS '2_fp'
      ,MAX(IF(STRCMP(ct.name,'3_fp'),null,cp.value)) AS '3_fp'
      ,MAX(IF(STRCMP(ct.name,'5_fp'),null,cp.value)) AS '5_fp'
      ,MAX(IF(STRCMP(ct.name,'10_fp'),null,cp.value)) AS '10_fp'
      ,MAX(IF(STRCMP(ct.name,'20_fp'),null,cp.value)) AS '20_fp'
      ,MAX(IF(STRCMP(ct.name,'40_fp'),null,cp.value)) AS '40_fp'
      ,MAX(IF(STRCMP(ct.name,'80_fp'),null,cp.value)) AS '80_fp'
      ,MAX(IF(STRCMP(ct.name,'160_fp'),null,cp.value)) AS '160_fp'
      ,MAX(IF(STRCMP(ct.name,'decay_10_fp'),null,cp.value)) AS 'decay_10_fp'
      ,MAX(IF(STRCMP(ct.name,'norm_f0'),null,cp.value)) AS 'norm_f0'
      ,MAX(IF(STRCMP(ct.name,'1_fp_p'),null,cp.value)) AS '1_fp_p'
      ,MAX(IF(STRCMP(ct.name,'2_fp_p'),null,cp.value)) AS '2_fp_p'
      ,MAX(IF(STRCMP(ct.name,'3_fp_p'),null,cp.value)) AS '3_fp_p'
      ,MAX(IF(STRCMP(ct.name,'5_fp_p'),null,cp.value)) AS '5_fp_p'
      ,MAX(IF(STRCMP(ct.name,'10_fp_p'),null,cp.value)) AS '10_fp_p'
      ,MAX(IF(STRCMP(ct.name,'20_fp_p'),null,cp.value)) AS '20_fp_p'
      ,MAX(IF(STRCMP(ct.name,'40_fp_p'),null,cp.value)) AS '40_fp_p'
      ,MAX(IF(STRCMP(ct.name,'80_fp_p'),null,cp.value)) AS '80_fp_p'
      ,MAX(IF(STRCMP(ct.name,'160_fp_p'),null,cp.value)) AS '160_fp_p'
      ,MAX(IF(STRCMP(ct.name,'decay_10_fp_p'),null,cp.value)) AS 'decay_10_fp_p'
      ,MAX(IF(STRCMP(ct.name,'norm_f0_p'),null,cp.value)) AS 'norm_f0_p'
FROM construct c 
JOIN construct_property cp ON (cp.construct_id = c.id)
JOIN cv_term ct ON (cp.type_id = ct.id)
JOIN cv cv ON (ct.cv_id = cv.id and cv.name = 'data_all')
GROUP BY c.id;
