CREATE OR REPLACE VIEW olympiad_box_sbfmf_stat_score_vw AS
SELECT session_id
      ,phase_id
      ,MAX(IF(STRCMP(score_type.name,'sbfmf_stat_meanerror'),null,score.value))       AS 'meanerror'
      ,MAX(IF(STRCMP(score_type.name,'sbfmf_stat_maxerror'),null,score.value))        AS 'maxerror'
      ,MAX(IF(STRCMP(score_type.name,'sbfmf_stat_meanwindowerror'),null,score.value)) AS 'meanwindowerror'
      ,MAX(IF(STRCMP(score_type.name,'sbfmf_stat_maxwindowerror'),null,score.value))  AS 'maxwindowerror'
      ,MAX(IF(STRCMP(score_type.name,'sbfmf_stat_compressionrate'),null,score.value)) AS 'compressionrate'
FROM score
JOIN cv_term score_type ON (score.type_id = score_type.id)
JOIN cv score_cv ON (score_cv.id = score_type.cv_id AND score_cv.name = 'fly_olympiad_qc_box')
GROUP BY session_id,phase_id;
