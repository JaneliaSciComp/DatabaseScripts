/*
  cache picklist fields in data set field value table
*/

-- aggression data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_aggression_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'effector'
        ),
        effector
FROM olympiad_aggression_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_aggression_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_aggression_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_reason'
        ),
        screen_reason
FROM olympiad_aggression_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_type'
        ),
        screen_type
FROM olympiad_aggression_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'aggression')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'wish_list'
        ),
        wish_list
FROM olympiad_aggression_vw
GROUP BY 1,2
;

-- bowl data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_bowl_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'gene'
        ),
        gene
FROM olympiad_bowl_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'effector'
        ),
        effector
FROM olympiad_bowl_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_bowl_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_bowl_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_reason'
        ),
        screen_reason
FROM olympiad_bowl_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_type'
        ),
        screen_type
FROM olympiad_bowl_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'bowl')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'wish_list'
        ),
        wish_list
FROM olympiad_bowl_vw
GROUP BY 1,2
;

-- box data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_box_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'protocol'
        ),
        protocol
FROM olympiad_box_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'effector'
        ),
        effector
FROM olympiad_box_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_box_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_box_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_reason'
        ),
        screen_reason
FROM olympiad_box_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_type'
        ),
        screen_type
FROM olympiad_box_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'box')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'wish_list'
        ),
        wish_list
FROM olympiad_box_vw
GROUP BY 1,2
;

-- climbing data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_climbing_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'gene'
        ),
        gene
FROM olympiad_climbing_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'effector'
        ),
        effector
FROM olympiad_climbing_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_climbing_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_climbing_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_reason'
        ),
        screen_reason
FROM olympiad_climbing_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_type'
        ),
        screen_type
FROM olympiad_climbing_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'climbing')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'wish_list'
        ),
        wish_list
FROM olympiad_climbing_vw
GROUP BY 1,2
;

-- gap data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_gap_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'gene'
        ),
        gene
FROM olympiad_gap_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'effector'
        ),
        effector
FROM olympiad_gap_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_gap_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_gap_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_reason'
        ),
        screen_reason
FROM olympiad_gap_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_type'
        ),
        screen_type
FROM olympiad_gap_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'gap')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'wish_list'
        ),
        wish_list
FROM olympiad_gap_vw
GROUP BY 1,2
;

-- observation data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT 
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_observation_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT 
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'gene'
        ),
        gene
FROM olympiad_observation_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT 
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'no_phenotypes'
        ),
        no_phenotypes
FROM olympiad_observation_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_observation_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_observation_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_reason'
        ),
        screen_reason
FROM olympiad_observation_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_type'
        ),
        screen_type
FROM olympiad_observation_vw
GROUP BY 1,2
;


INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'observation')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'wish_list'
        ),
        wish_list
FROM olympiad_observation_vw
GROUP BY 1,2
;

-- sterility data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'gene'
        ),
        gene
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'effector'
        ),
        effector
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'sterile'
        ),
        sterile
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_reason'
        ),
        screen_reason
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'screen_type'
        ),
        screen_type
FROM olympiad_sterility_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'sterility')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'wish_list'
        ),
        wish_list
FROM olympiad_sterility_vw
GROUP BY 1,2
; 

-- trikinetics data set
DELETE FROM data_set_field_value
WHERE data_set_field_id IN (SELECT dsf.id
                            FROM data_set_field dsf
                            JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'trikinetics')
                            JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
                            JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
                            JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
                           );

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'trikinetics')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'line'
        ),
        line
FROM olympiad_trikinetics_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'trikinetics')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'gene'
        ),
        gene
FROM olympiad_trikinetics_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'trikinetics')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'effector'
        ),
        effector
FROM olympiad_trikinetics_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'trikinetics')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'manual_pf'
        ),
        manual_pf
FROM olympiad_trikinetics_vw
GROUP BY 1,2
;

INSERT INTO data_set_field_value (data_set_field_id,value)
SELECT  DISTINCT
        (SELECT dsf.id
         FROM data_set_field dsf
         JOIN data_set ds on (dsf.data_set_id = ds.id and ds.name = 'trikinetics')
         JOIN data_set_family df on (ds.family_id = df.id and df.name = 'line_summary')
         JOIN cv_term lab ON (df.lab_id = lab.id and lab.name = 'olympiad' collate latin1_general_cs)
         JOIN cv lab_cv ON (lab.cv_id = lab_cv.id and lab_cv.name = 'lab')
         WHERE dsf.name = 'automated_pf'
        ),
        automated_pf
FROM olympiad_trikinetics_vw
GROUP BY 1,2
;

