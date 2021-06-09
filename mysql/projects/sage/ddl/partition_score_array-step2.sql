
INSERT INTO score_array_part ( id
                              ,session_id
                              ,phase_id
                              ,experiment_id
                              , term_id
                              , type_id
                              , value
                              , run
                              , data_type
                              , row_count
                              , column_count
                              , create_date
) SELECT    id            
           ,session_id
           ,phase_id
           ,experiment_id
           , term_id       
           , type_id       
           , value         
           , run           
           , data_type     
           , row_count     
           , column_count  
           , create_date
FROM score_array;

