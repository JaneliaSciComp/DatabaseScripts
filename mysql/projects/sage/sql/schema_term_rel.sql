insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id 
       from session 
       where type_id not in (select subject_id 
                             from cv_term_relationship 
                             where type_id IN (select cv_term.id 
                                               from cv_term 
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='session')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='session') object
     )
;

insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from session_property
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='session_property')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='session_property') object
     )
;

insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from observation
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='observation')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='observation') object
     )
;    


insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from score
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='score')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='score') object
     )
;

insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from experiment
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='experiment')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='experiment') object
     )
;

insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from experiment_property
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='experiment_property')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='experiment_property') object
     )
;

insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from phase
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='phase')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='phase') object
     )
;

insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from phase_property
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='phase_property')                      
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='phase_property') object
     )
;

insert into cv_term_relationship (type_id,subject_id,object_id)
select type_id
      ,subject_id
      ,object_id
from (
      (select distinct type_id subject_id
       from score_array
       where type_id not in (select subject_id
                             from cv_term_relationship
                             where type_id IN (select cv_term.id
                                               from cv_term
                                               join cv on (cv_term.cv_id = cv.id and cv.name = 'schema')
                                               where cv_term.name='is_a'
                                              )
                               and object_id IN (select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='score_array')
                            )
      ) subject
     ,(select cv_term.id type_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='is_a') type
     ,(select cv_term.id object_id from cv_term join cv on (cv_term.cv_id = cv.id and cv.name = 'schema') where cv_term.name='score_array') object
     )
;
