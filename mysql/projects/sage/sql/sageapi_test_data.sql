insert into cv_term (cv_id,name,definition,is_current)
values (7,'sageapi_test_vw','table ref for testing sage web service',true)
      ,(7,'sageapi_test_vw2','table ref for testing sage web service',true);

insert into data_set_family (name,description,display_name,lab_id)
values ('sage_ws_test','test sage web service','sage_ws_test','1473');

insert into data_set (name,description,display_name,family_id)
values ('sage_ws_test_1','test 1 view','sage_ws_test_1',(select id from data_set_family where name = 'sage_ws_test'))
      ,('sage_ws_test_2','test 2 views','sage_ws_test_2',(select id from data_set_family where name = 'sage_ws_test'));

insert into data_set_view (data_set_id,view_id)
values ((select id from data_set where name ='sage_ws_test_1'),(select id from cv_term where name = 'sageapi_test_vw'))
       ,((select id from data_set where name ='sage_ws_test_2'),(select id from cv_term where name = 'sageapi_test_vw'))
       ,((select id from data_set where name ='sage_ws_test_2'),(select id from cv_term where name = 'sageapi_test_vw2'));

insert into data_set_field (name,display_name,data_set_id,value,deprecated)
values ('name','test values',(select id from data_set where name ='sage_ws_test_1'),'A, B',0)
      ,('definition','test deprecated',(select id from data_set where name ='sage_ws_test_1'),null,1);

insert into data_set_field_value (data_set_field_id,value)
values ((select id from data_set_field where name = 'name'),'A')
      ,((select id from data_set_field where name = 'name'),'B');
