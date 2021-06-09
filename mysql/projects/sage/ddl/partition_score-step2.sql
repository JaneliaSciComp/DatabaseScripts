/*
  step 2 of 4 for converting score to a partitioned table.
  insert data into partitioned table from unpartitioned
  score table.
*/
INSERT INTO score_part ( id
                        ,session_id
                        ,phase_id
                        ,experiment_id
                        ,term_id
                        ,type_id
                        ,value
                        ,run
                        ,create_date
) SELECT id
        ,session_id
        ,phase_id
        ,experiment_id
        ,term_id
        ,type_id
        ,value
        ,run
        ,create_date
FROM score;
