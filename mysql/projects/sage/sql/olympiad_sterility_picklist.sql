call getPickListCSV(@values,'experimenter','olympiad_sterility_instance_vw');
update data_set_field set value = @values  where name = 'experimenter' and data_set_id IN (select id from data_set_vw where family = 'sterility' and name = 'instance');
call getPickListCSV(@values,'gender','olympiad_sterility_instance_vw');
update data_set_field set value = @values  where name = 'gender' and data_set_id IN (select id from data_set_vw where family = 'sterility' and name = 'instance');
call getPickListCSV(@values,'effector','olympiad_sterility_instance_vw');
update data_set_field set value = @values  where name = 'effector' and data_set_id IN (select id from data_set_vw where family = 'sterility' and name = 'instance');
call getPickListCSV(@values,'rearing','olympiad_sterility_instance_vw');
update data_set_field set value = @values  where name = 'rearing' and data_set_id IN (select id from data_set_vw where family = 'sterility' and name = 'instance');
call getPickListCSV(@values,'data_type','olympiad_sterility_instance_vw');
update data_set_field set value = @values  where name = 'data_type' and data_set_id IN (select id from data_set_vw where family = 'sterility' and name = 'instance');


call getDataSetFieldValue('olympiad','sterility','instance','experimenter','olympiad_sterility_instance_vw');
call getDataSetFieldValue('olympiad','sterility','instance','gender','olympiad_sterility_instance_vw');
call getDataSetFieldValue('olympiad','sterility','instance','effector','olympiad_sterility_instance_vw');
call getDataSetFieldValue('olympiad','sterility','instance','rearing','olympiad_sterility_instance_vw');
call getDataSetFieldValue('olympiad','sterility','instance','data_type','olympiad_sterility_instance_vw');
