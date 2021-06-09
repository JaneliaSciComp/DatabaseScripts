/* 
   This sql script contains insert statements to create data set family, 
   data sets, and data set fields
*/

-- Box Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id) 
       values ('box','Data sets for the box assay','The Box',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_box_analysis_results_vw','flatten view of box analysis results');
  insert into data_set (name,description,display_name,family_id) 
         values ('analysis_results','flatten view of box analysis results','Analysis Results',(select id from data_set_family where name ='box'));
   -- data set
  select createCvTermId('schema','olympiad_box_analysis_info_vw','flatten view of box analysis info');
  insert into data_set (name,description,display_name,family_id) 
         values ('analysis_info','flatten view of box analysis info','Analysis Info',(select id from data_set_family where name ='box'));
   -- data set
  select createCvTermId('schema','olympiad_box_environmental_vw','flatten view of box environmental data');
  insert into data_set (name,description,display_name,family_id) 
         values ('environmental','flatten view of box environmental data','Environmental Data',(select id from data_set_family where name ='box'));
     -- data set views
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='box') and name = 'analysis_results'),getcvTermId('schema','olympiad_box_analysis_results_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='box') and name = 'analysis_info'),getcvTermId('schema','olympiad_box_analysis_info_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='box') and name = 'environmental'),getcvTermId('schema','olympiad_box_environmental_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value) 
    values ('box_name','Box Name',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null)
          ,('top_plate_id','Top Plate Id',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null)
          ,('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null)
          ,('tube','Tube',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null)
          ,('sequence','Sequence',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null)
          ,('temperature','Temperature',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null)
          ,('box_name','Box Name',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null)
          ,('top_plate_id','Top Plate Id',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null)
          ,('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null)
          ,('tube','Tube',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null)
          ,('sequence','Sequence',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null)
          ,('temperature','Temperature',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null)
          ,('box_name','Box Name',(select id from data_set_vw where family = 'box' and name = 'environmental'),null)
          ,('top_plate_id','Top Plate Id',(select id from data_set_vw where family = 'box' and name = 'environmental'),null)
          ,('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'box' and name = 'environmental'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'box' and name = 'environmental'),null)
          ;
      insert into data_set_field (name,display_name,data_set_id,value,deprecated)
      values ('experiment_date_time','Experiment Datetime',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('operator','Operator',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('questionable_data','Questionable Data',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('redo_experiment','Redo Experiment',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('halt_early','Halt Early',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('n','n',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('n_dead','n Dead',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('rearing','Rearing',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('starved','Starved',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('experiment_date_time','Experiment Datetime',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('operator','Operator',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('questionable_data','Questionable Data',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('redo_experiment','Redo Experiment',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('halt_early','Halt Early',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('n','n',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('n_dead','n Dead',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('rearing','Rearing',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('starved','Starved',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('experiment_date_time','Experiment Datetime',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('operator','Operator',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('questionable_data','Questionable Data',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('redo_experiment','Redo Experiment',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('halt_early','Halt Early',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('n','n',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('n_dead','n Dead',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('rearing','Rearing',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('starved','Starved',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('box','Box',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('box','Box',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('box','Box',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('apparatus_id','Apparatus Id',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('apparatus_id','Apparatus Id',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('apparatus_id','Apparatus Id',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1)
            ,('temperature_setpoint','Temperature Setpoint',(select id from data_set_vw where family = 'box' and name = 'analysis_results'),null,1)
            ,('temperature_setpoint','Temperature Setpoint',(select id from data_set_vw where family = 'box' and name = 'analysis_info'),null,1)
            ,('temperature_setpoint','Temperature Setpoint',(select id from data_set_vw where family = 'box' and name = 'environmental'),null,1);
        

-- Aggression Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id) 
       values ('aggression','Data sets for the aggression assay','Aggression',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_aggression_feature_vw','flatten view of aggression features');
  insert into data_set (name,description,display_name,family_id) 
         values ('features','flatten view of aggression features','Features',(select id from data_set_family where name ='aggression'));
   -- data set
  select createCvTermId('schema','olympiad_aggression_tracking_vw','flatten view of aggression tracking');
  insert into data_set (name,description,display_name,family_id) 
         values ('tracking','flatten view of aggression tracking','Tracking',(select id from data_set_family where name ='aggression'));
   -- data set
  select createCvTermId('schema','olympiad_aggression_chamber_tracking_vw','flatten view of aggression chamber tracking');
  select createCvTermId('schema','olympiad_aggression_chamber_tracking_vw2','flatten view of aggression chamber tracking');
  select createCvTermId('schema','olympiad_aggression_chamber_tracking_vw3','flatten view of aggression chamber tracking');
  select createCvTermId('schema','olympiad_aggression_chamber_tracking_vw4','flatten view of aggression chamber tracking');
  insert into data_set (name,description,display_name,family_id) 
         values ('chamber_tracking','flatten view of aggression chamber tracking','Chamber Tracking',(select id from data_set_family where name ='aggression'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'features'),getcvTermId('schema','olympiad_aggression_feature_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'features'),getcvTermId('schema','olympiad_aggression_feature_vw2',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'tracking'),getcvTermId('schema','olympiad_aggression_tracking_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'tracking'),getcvTermId('schema','olympiad_aggression_tracking_vw2',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'chamber_tracking'),getcvTermId('schema','olympiad_aggression_chamber_tracking_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'chamber_tracking'),getcvTermId('schema','olympiad_aggression_chamber_tracking_vw2',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'chamber_tracking'),getcvTermId('schema','olympiad_aggression_chamber_tracking_vw3',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='aggression') and name = 'chamber_tracking'),getcvTermId('schema','olympiad_aggression_chamber_tracking_vw4',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('camera','Camera',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('arena','Arena',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('behavior','Behavior',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('fly','Fly',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('chamber','Chamber',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'aggression' and name = 'features'),null)
          ,('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('camera','Camera',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('arena','Arena',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('behavior','Behavior',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('fly','Fly',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('chamber','Chamber',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'aggression' and name = 'tracking'),null)
          ,('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ,('camera','Camera',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ,('arena','Arena',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ,('behavior','Behavior',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ,('fly','Fly',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ,('chamber','Chamber',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'aggression' and name = 'chamber_tracking'),null)
          ;

-- Gap Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id) 
       values ('gap','Data sets for the gap assay','Gap',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_gap_counts_vw','flatten view of gap counts');
  insert into data_set (name,description,display_name,family_id) 
         values ('counts','flatten view of gap counts','Counts',(select id from data_set_family where name ='gap'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('protocol','Protocol',(select id from data_set_vw where family = 'gap' and name = 'counts'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'gap' and name = 'counts'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'gap' and name = 'counts'),null)
          ,('rig','Rig',(select id from data_set_vw where family = 'gap' and name = 'counts'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'gap' and name = 'counts'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_gap_totals_vw','flatten view of gap totals');
  insert into data_set (name,description,display_name,family_id) 
         values ('totals','flatten view of gap totals','Totals',(select id from data_set_family where name ='gap'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='gap') and name = 'counts'),getcvTermId('schema','olympiad_gap_counts_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='gap') and name = 'counts'),getcvTermId('schema','olympiad_gap_counts_vw2',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='gap') and name = 'totals'),getcvTermId('schema','olympiad_gap_totals_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('protocol','Protocol',(select id from data_set_vw where family = 'gap' and name = 'totals'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'gap' and name = 'totals'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'gap' and name = 'totals'),null)
          ,('rig','Rig',(select id from data_set_vw where family = 'gap' and name = 'totals'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'gap' and name = 'totals'),null)
          ;
          

-- Trikinetics Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id) 
       values ('trikinetics','Data sets for the trikinetics assay','Trikinetics',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_trikinetics_analysis_vw','flatten view of trikinetics analysis');
  insert into data_set (name,description,display_name,family_id) 
         values ('analysis','flatten view of trikinetics analysis','Analysis',(select id from data_set_family where name ='trikinetics'));
   -- data set
  select createCvTermId('schema','olympiad_trikinetics_monitor_vw','flatten view of trikinetics monitor');
  insert into data_set (name,description,display_name,family_id) 
         values ('monitor_data','flatten view of trikinetics monitor','Monitor Data',(select id from data_set_family where name ='trikinetics'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='trikinetics') and name = 'analysis'),getcvTermId('schema','olympiad_trikinetics_analysis_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='trikinetics') and name = 'monitor_data'),getcvTermId('schema','olympiad_trikinetics_monitor_vw',null));

-- Sterility Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id)
       values ('sterility','Data sets for the sterility assay','Sterility',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_sterility_instance_vw','flatten view of sterility instance');
  insert into data_set (name,description,display_name,family_id) 
         values ('instance','flatten view of sterility instance','Instance',(select id from data_set_family where name ='sterility'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='sterility') and name = 'instance'),getcvTermId('schema','olympiad_sterility_instance_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experimenter','Experimenter',(select id from data_set_vw where family = 'sterility' and name = 'instance'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'sterility' and name = 'instance'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'sterility' and name = 'instance'),null)
          ,('rearing','Rearing',(select id from data_set_vw where family = 'sterility' and name = 'instance'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'sterility' and name = 'instance'),null)
          ;

-- Line Summary data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id) 
       values ('line_summary','Data sets for the line summary viewers of all assays','Line Summary',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_observation_vw','summary view of observation assay');
  insert into data_set (name,description,display_name,family_id) 
         values ('observation','summary view of observation assay','Observation',(select id from data_set_family where name ='line_summary'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ,('gene','Gene',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ,('no_phenotypes','No Phenotypes',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ,('screen_reason','Screen Reason',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ,('screen_type','Screen Type',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ,('wish_list','Wish List',(select id from data_set_vw where family = 'line_summary' and name = 'observation'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_box_vw','summary view of box assay');
  insert into data_set (name,description,display_name,family_id)
         values ('box','summary view of box assay','Box',(select id from data_set_family where name ='line_summary'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ,('protocol','Protocol',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ,('screen_reason','Screen Reason',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ,('screen_type','Screen Type',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ,('wish_list','Wish List',(select id from data_set_vw where family = 'line_summary' and name = 'box'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_climbing_vw','summary view of climbing assay');
  insert into data_set (name,description,display_name,family_id)
         values ('climbing','summary view of climbing assay','Climbing',(select id from data_set_family where name ='line_summary'));
     -- data set views
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'climbing'),getcvTermId('schema','olympiad_climbing_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ,('gene','Gene',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ,('screen_reason','Screen Reason',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ,('screen_type','Screen Type',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ,('wish_list','Wish List',(select id from data_set_vw where family = 'line_summary' and name = 'climbing'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_aggression_vw','summary view of aggression assay');
  insert into data_set (name,description,display_name,family_id)
         values ('aggression','summary view of aggression assay','Aggression',(select id from data_set_family where name ='line_summary'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'aggression'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'line_summary' and name = 'aggression'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'aggression'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'aggression'),null)
          ,('screen_reason','Screen Reason',(select id from data_set_vw where family = 'line_summary' and name = 'aggression'),null)
          ,('screen_type','Screen Type',(select id from data_set_vw where family = 'line_summary' and name = 'aggression'),null)
          ,('wish_list','Wish List',(select id from data_set_vw where family = 'line_summary' and name = 'aggression'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_gap_vw','summary view of gap assay');
  insert into data_set (name,description,display_name,family_id)
         values ('gap','summary view of gap assay','Gap Crossing',(select id from data_set_family where name ='line_summary'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ,('gene','Gene',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ,('screen_reason','Screen Reason',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ,('screen_type','Screen Type',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ,('wish_list','Wish List',(select id from data_set_vw where family = 'line_summary' and name = 'gap'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_sterility_vw','summary view of sterility assay');
  insert into data_set (name,description,display_name,family_id)
         values ('sterility','summary view of sterility assay','Sterility',(select id from data_set_family where name ='line_summary'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('gene','Gene',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('sterile','Sterile',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('screen_reason','Screen Reason',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('screen_type','Screen Type',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ,('wish_list','Wish List',(select id from data_set_vw where family = 'line_summary' and name = 'sterility'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_trikinetics_vw','summary view of trikinetics assay');
  insert into data_set (name,description,display_name,family_id)
         values ('trikinetics','summary view of trikinetics assay','Trikinetics',(select id from data_set_family where name ='line_summary'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'trikinetics'),null)
          ,('gene','Gene',(select id from data_set_vw where family = 'line_summary' and name = 'trikinetics'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'line_summary' and name = 'trikinetics'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'trikinetics'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'trikinetics'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_bowl_vw','summary view of bowl assay');
  insert into data_set (name,description,display_name,family_id)
         values ('bowl','summary view of bowl assay','Bowl',(select id from data_set_family where name ='line_summary'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('line','Line',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ,('gene','Gene',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ,('effector','effector',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ,('manual_pf','Manual PF',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ,('automated_pf','Automated PF',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ,('screen_reason','Screen Reason',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ,('screen_type','Screen Type',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ,('wish_list','Wish List',(select id from data_set_vw where family = 'line_summary' and name = 'bowl'),null)
          ;
     -- data set views
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'observation'),getcvTermId('schema','olympiad_observation_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'box'),getcvTermId('schema','olympiad_box_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'aggression'),getcvTermId('schema','olympiad_aggression_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'gap'),getcvTermId('schema','olympiad_gap_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'sterility'),getcvTermId('schema','olympiad_sterility_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'trikinetics'),getcvTermId('schema','olympiad_trikinetics_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='line_summary') and name = 'bowl'),getcvTermId('schema','olympiad_bowl_vw',null));

-- Bowl Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id) 
       values ('bowl','Data sets for the bowl assay','Bowl',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_bowl_data_vw','flatten view of bowl data');
  select createCvTermId('schema','olympiad_bowl_data_vw2','flatten view of bowl data');
  insert into data_set (name,description,display_name,family_id) 
         values ('data','flatten view of bowl data','Data',(select id from data_set_family where name ='bowl'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bowl' and name = 'data'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bowl' and name = 'data'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bowl' and name = 'data'),null)
          ,('bowl','Bowl',(select id from data_set_vw where family = 'bowl' and name = 'data'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'bowl' and name = 'data'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_bowl_meta_data_vw','flatten view of bowl metadata');
  insert into data_set (name,description,display_name,family_id)
         values ('metadata','flatten view of bowl metadata','Metadata',(select id from data_set_family where name ='bowl'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='bowl') and name = 'metadata'),getcvTermId('schema','olympiad_bowl_meta_data_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bowl' and name = 'metadata'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bowl' and name = 'metadata'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bowl' and name = 'metadata'),null)
          ,('bowl','Bowl',(select id from data_set_vw where family = 'bowl' and name = 'metadata'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'bowl' and name = 'metadata'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_bowl_score_data_vw','flatten view of bowl score data');
  insert into data_set (name,description,display_name,family_id)
         values ('score','flatten view of bowl score data','Score',(select id from data_set_family where name ='bowl'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bowl' and name = 'score'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bowl' and name = 'score'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bowl' and name = 'score'),null)
          ,('bowl','Bowl',(select id from data_set_vw where family = 'bowl' and name = 'score'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_bowl_histogram_vw','flatten view of bowl histogram data');
  insert into data_set (name,description,display_name,family_id)
         values ('histogram','flatten view of bowl histogram data','Histogram',(select id from data_set_family where name ='bowl'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='bowl') and name = 'data'),getcvTermId('schema','olympiad_bowl_data_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='bowl') and name = 'data'),getcvTermId('schema','olympiad_bowl_data_vw2',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='bowl') and name = 'score'),getcvTermId('schema','olympiad_bowl_score_data_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='bowl') and name = 'histogram'),getcvTermId('schema','olympiad_bowl_histogram_vw',null));
           
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bowl' and name = 'histogram'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bowl' and name = 'histogram'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bowl' and name = 'histogram'),null)
          ,('bowl','Bowl',(select id from data_set_vw where family = 'bowl' and name = 'histogram'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'bowl' and name = 'histogram'),null)
          ;

-- Bubble Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id)
       values ('bubble','Data sets for the bubble assay','Bubble',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_bubble_data_vw','flatten view of bubble data');
  select createCvTermId('schema','olympiad_bubble_data_vw2','flatten view of bubble data');
  insert into data_set (name,description,display_name,family_id)
         values ('data','flatten view of bubble data','Data',(select id from data_set_family where name ='bubble'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bubble' and name = 'data'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bubble' and name = 'data'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bubble' and name = 'data'),null)
          ,('bubble','Bubble',(select id from data_set_vw where family = 'bubble' and name = 'data'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'bubble' and name = 'data'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_bubble_meta_data_vw','flatten view of bubble metadata');
  insert into data_set (name,description,display_name,family_id)
         values ('metadata','flatten view of bubble metadata','Metadata',(select id from data_set_family where name ='bubble'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='bubble') and name = 'metadata'),getcvTermId('schema','olympiad_bubble_meta_data_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bubble' and name = 'metadata'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bubble' and name = 'metadata'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bubble' and name = 'metadata'),null)
          ,('bubble','Bubble',(select id from data_set_vw where family = 'bubble' and name = 'metadata'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'bubble' and name = 'metadata'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_bubble_score_data_vw','flatten view of bubble score data');
  insert into data_set (name,description,display_name,family_id)
         values ('score','flatten view of bubble score data','Score',(select id from data_set_family where name ='bubble'));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bubble' and name = 'score'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bubble' and name = 'score'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bubble' and name = 'score'),null)
          ,('bubble','Bubble',(select id from data_set_vw where family = 'bubble' and name = 'score'),null)
          ;
   -- data set
  select createCvTermId('schema','olympiad_bubble_histogram_vw','flatten view of bubble histogram data');
  insert into data_set (name,description,display_name,family_id)
         values ('histogram','flatten view of bubble histogram data','Histogram',(select id from data_set_family where name ='bubble'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='bubble') and name = 'data'),getcvTermId('schema','olympiad_bubble_data_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='bubble') and name = 'data'),getcvTermId('schema','olympiad_bubble_data_vw2',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='bubble') and name = 'score'),getcvTermId('schema','olympiad_bubble_score_data_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='bubble') and name = 'histogram'),getcvTermId('schema','olympiad_bubble_histogram_vw',null));

     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('experiment_protocol','Experiment Protocol',(select id from data_set_vw where family = 'bubble' and name = 'histogram'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'bubble' and name = 'histogram'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'bubble' and name = 'histogram'),null)
          ,('bubble','Bubble',(select id from data_set_vw where family = 'bubble' and name = 'histogram'),null)
          ,('data_type','Data Type',(select id from data_set_vw where family = 'bubble' and name = 'histogram'),null)
          ;

-- Climbing Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id)
       values ('climbing','Data sets for the climbing assay','Climbing',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_climbing_meta_data_vw','flatten view of climbing metadata');
  insert into data_set (name,description,display_name,family_id)
         values ('metadata','flatten view of climbing metadata','Metadata',(select id from data_set_family where name ='climbing'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='climbing') and name = 'metadata'),getcvTermId('schema','olympiad_climbing_meta_data_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('protocol','Protocol',(select id from data_set_vw where family = 'climbing' and name = 'metadata'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'climbing' and name = 'metadata'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'climbing' and name = 'metadata'),null)
           ;

  select createCvTermId('schema','olympiad_climbing_data_vw','flatten view of climbing data');
  insert into data_set (name,description,display_name,family_id)
         values ('data','flatten view of climbing data','Data',(select id from data_set_family where name ='climbing'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='climbing') and name = 'data'),getcvTermId('schema','olympiad_climbing_data_vw',null));
     -- data set fields
    insert into data_set_field (name,display_name,data_set_id,value)
    values ('protocol','Protocol',(select id from data_set_vw where family = 'climbing' and name = 'data'),null)
          ,('effector','Effector',(select id from data_set_vw where family = 'climbing' and name = 'data'),null)
          ,('gender','Gender',(select id from data_set_vw where family = 'climbing' and name = 'data'),null)
          ;

-- Observation Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id)
       values ('observation','Data sets for the observation assay','Observation',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_observation_data_vw','flatten view of observation data');
  insert into data_set (name,description,display_name,family_id)
         values ('data','flatten view of observation data','Data',(select id from data_set_family where name ='observation'));
    -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='observation') and name = 'data'),getcvTermId('schema','olympiad_observation_data_vw',null));

-- Sterility Assay data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id)
       values ('sterility','Data sets for the sterility assay','Sterility',getcvTermId('lab','olympiad',null));
   -- data set
  select createCvTermId('schema','olympiad_sterility_data_vw','flatten view of sterility data');
  insert into data_set (name,description,display_name,family_id)
         values ('data','flatten view of sterility data','Data',(select id from data_set_family where name ='sterility'));
    -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='sterility') and name = 'data'),getcvTermId('schema','olympiad_sterility_data_vw',null));

-- Imagery data sets
 -- family
insert into data_set_family (name,description,display_name,lab_id)
       values ('flylight_flip','Imagery data for flylight_flip family','Flylight Flip',getcvTermId('lab','flylight',null))
             ,('flylight_collaborations','Imagery data for flylight_collaborations family','Flylight Collaborations',getcvTermId('lab','flylight',null))
             ,('flylight_rd','Imagery data for flylight_rd family','Flylight RD',getcvTermId('lab','flylight',null));
             ,('rubin_chacrm','Imagery data for rubin_chacrm family','Rubin',getcvTermId('lab','rubin',null));
   -- data set
  select createCvTermId('schema','image_data_flylight_flip_vw','flatten view of flylight_flip image data');
  select createCvTermId('schema','image_data_flylight_collaborations_vw','flatten view of flylight_collaborations image data');
  select createCvTermId('schema','image_data_flylight_rd_vw','flatten view of flylight_rd image data');
  select createCvTermId('schema','image_data_rubin_chacrm_vw','flatten view of rubin_chacrm image data');
  insert into data_set (name,description,display_name,family_id)
         values ('imagery_data','flatten view of flylight_flip image data','Imagery Data',(select id from data_set_family where name ='flylight_flip'))
               ,('imagery_data','flatten view of flylight_collaborations image data','Imagery Data',(select id from data_set_family where name ='flylight_collaborations'))
               ,('imagery_data','flatten view of flylight_rd image data','Imagery Data',(select id from data_set_family where name ='flylight_rd'))
               ,('imagery_data','flatten view of rubin_chacrm image data','Imagery Data',(select id from data_set_family where name ='rubin_chacrm'));
     -- data set view
     insert into data_set_view (data_set_id,view_id)
     values ((select id from data_set where family_id = (select id from data_set_family where name ='flylight_flip') and name = 'imagery_data'),getcvTermId('schema','image_data_flylight_flip_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='flylight_collaborations') and name = 'imagery_data'),getcvTermId('schema','image_data_flylight_collaborations_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='flylight_rd') and name = 'imagery_data'),getcvTermId('schema','image_data_flylight_rd_vw',null))
           ,((select id from data_set where family_id = (select id from data_set_family where name ='rubin_chacrm') and name = 'imagery_data'),getcvTermId('schema','image_data_rubin_chacrm_vw',null));
