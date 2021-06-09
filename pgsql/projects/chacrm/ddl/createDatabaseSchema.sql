-- ********
-- Chacrm 
-- ********
create role "chacrmAdmin" login encrypted password 'chacrmAdmin';
create role "chacrmApp" login encrypted password 'chacrmApp';
create role "chacrmRead" login encrypted password 'chacrmRead';
create tablespace flybasedata owner "chacrmAdmin" location '/opt/pgsql-data/chacrm/flybase_data';
create database chacrm owner "chacrmAdmin" tablespace flybasedata;
create LANGUAGE plpgsql;

create role chacrm_select nologin ;
create role chacrm_insert nologin ;
create role chacrm_delete nologin ;
create role chacrm_update nologin ;
create role chacrm_execute nologin ;

create role apache login ;
create role apollo login ;
create role ims login encrypted password 'ims';
create role "gbrowseApp" login encrypted password 'gbr0ws3App';

create role svirskasr login encrypted password 'svirskasr';
create role umayaml login encrypted password 'umayaml';
create role dolafit login encrypted password 'dolafit' superuser;

grant chacrm_select,chacrm_insert,chacrm_delete,chacrm_update,chacrm_execute to apache,apollo,ims,"chacrmApp","gbrowseApp",svirskasr,umayaml;

grant chacrm_select to "chacrmRead";
