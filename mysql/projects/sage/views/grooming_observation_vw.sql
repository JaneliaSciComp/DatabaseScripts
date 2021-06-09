CREATE OR REPLACE VIEW grooming_observation_vw AS
SELECT line.name, 
       MAX(IF(STRCMP(cv_term.name,'behavioral'),null,(IF(STRCMP(cv_term2.name,'courtship'),null,observation.value)))) AS 'behavioral_courtship',
       MAX(IF(STRCMP(cv_term.name,'behavioral'),null,(IF(STRCMP(cv_term2.name,'hyper'),null,observation.value)))) AS 'behavioral_hyper',
       MAX(IF(STRCMP(cv_term.name,'behavioral'),null,(IF(STRCMP(cv_term2.name,'intersegmental'),null,observation.value)))) AS 'behavioral_intersegmental',
       MAX(IF(STRCMP(cv_term.name,'behavioral'),null,(IF(STRCMP(cv_term2.name,'paralyzed'),null,observation.value)))) AS 'behavioral_paralyzed',
       MAX(IF(STRCMP(cv_term.name,'behavioral'),null,(IF(STRCMP(cv_term2.name,'uncoordinated'),null,observation.value)))) AS 'behavioral_uncoordinated',
       MAX(IF(STRCMP(cv_term.name,'cross'),null,(IF(STRCMP(cv_term2.name,'lethal'),null,observation.value)))) AS 'cross_lethal',
       MAX(IF(STRCMP(cv_term.name,'overgrooming'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'overgrooming_defect',
       MAX(IF(STRCMP(cv_term.name,'head_selective'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'head_selective_defect',
       MAX(IF(STRCMP(cv_term.name,'leg_rub'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'leg_rub_defect' ,      
       MAX(IF(STRCMP(cv_term.name,'permissive'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'permissive_defect',
       MAX(IF(STRCMP(cv_term.name,'restrictive'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'restrictive_defect',
       MAX(IF(STRCMP(cv_term.name,'restrictive'),null,(IF(STRCMP(cv_term2.name,'screened'),null,observation.value)))) AS 'restrictive_screened',    
       MAX(IF(STRCMP(cv_term.name,'stock_control'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'stock_control_defect',
       MAX(IF(STRCMP(cv_term.name,'stock'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'stock_defect',
       MAX(IF(STRCMP(cv_term.name,'tnt'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'tnt_defect',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'screened'),null,observation.value)))) AS 'trpa_screened',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'defect'),null,observation.value)))) AS 'trpa_defect',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'reversal'),null,observation.value)))) AS 'trpa_reversal',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'proboscisextension'),null,observation.value)))) AS 'trpa_proboscisextension',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'feedingbehavior'),null,observation.value)))) AS 'trpa_feedingbehavior',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'increasedgrooming'),null,observation.value)))) AS 'trpa_increasedgrooming',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'headgrooming'),null,observation.value)))) AS 'trpa_headgrooming',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'wingcleaning'),null,observation.value)))) AS 'trpa_wingcleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'legrubbing'),null,observation.value)))) AS 'trpa_legrubbing',
       MAX(IF(STRCMP(cv_term.name,'expression'),null,(IF(STRCMP(cv_term2.name,'bristle'),null,observation.value)))) AS 'expression_bristle',
       MAX(IF(STRCMP(cv_term.name,'expression'),null,(IF(STRCMP(cv_term2.name,'chordotonal'),null,observation.value)))) AS 'expression_chordotonal',
       MAX(IF(STRCMP(cv_term3.name,'interesting'),null,session_property.value)) AS 'interesting',
       MAX(IF(STRCMP(cv_term3.name,'expression_imaged'),null,session_property.value)) AS 'expression_imaged',
       MAX(IF(STRCMP(cv_term3.name,'experimental_imaged'),null,session_property.value)) AS 'experimental_imaged',
       MAX(IF(STRCMP(cv_term3.name,'evidence_imaged'),null,session_property.value)) AS 'evidence_imaged',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'probosciscleaning'),null,observation.value)))) AS 'trpa_probosciscleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'abdominalcleaning'),null,observation.value)))) AS 'trpa_abdominalcleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'genitalcleaning'),null,observation.value)))) AS 'trpa_genitalcleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'halterecleaning'),null,observation.value)))) AS 'trpa_halterecleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'ventralthoraxcleaning'),null,observation.value)))) AS 'trpa_ventralthoraxcleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'antennalcleaning'),null,observation.value)))) AS 'trpa_antennalcleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'notumcleaning'),null,observation.value)))) AS 'trpa_notumcleaning',
       MAX(IF(STRCMP(cv_term.name,'expression'),null,(IF(STRCMP(cv_term2.name,'eyebristle'),null,observation.value)))) AS 'expression_eyebristle',
       MAX(IF(STRCMP(cv_term.name,'chr2'),null,(IF(STRCMP(cv_term2.name,'stimulated'),null,observation.value)))) AS 'chr2_stimulated',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'courtship'),null,observation.value)))) AS 'trpa_courtship',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'posteriorcleaning'),null,observation.value)))) AS 'trpa_posteriorcleaning',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'decap_screened'),null,observation.value)))) AS 'trpa_decap_screened',
       MAX(IF(STRCMP(cv_term.name,'trpa'),null,(IF(STRCMP(cv_term2.name,'decap_phenotype'),null,observation.value)))) AS 'trpa_decap_phenotype',
       MAX(IF(STRCMP(cv_term.name,'expression'),null,(IF(STRCMP(cv_term2.name,'connected'),null,observation.value)))) AS 'expression_connected'
FROM line
JOIN session on (line.id = session.line_id)
JOIN cv_term on (session.type_id = cv_term.id)
JOIN cv on (cv_term.cv_id = cv.id and cv.name = 'grooming')
LEFT OUTER JOIN session_property on (session.id = session_property.session_id)
LEFT OUTER JOIN cv_term cv_term3 on (session_property.type_id = cv_term3.id)
LEFT OUTER JOIN cv cv3 on (cv_term3.cv_id = cv3.id and cv3.name = 'grooming')
LEFT OUTER JOIN observation on (session.id = observation.session_id)
LEFT OUTER JOIN cv_term cv_term2 on (observation.type_id = cv_term2.id)
LEFT OUTER JOIN cv cv2 on (cv_term2.cv_id = cv2.id and cv2.name = 'grooming')
GROUP BY line.name;
