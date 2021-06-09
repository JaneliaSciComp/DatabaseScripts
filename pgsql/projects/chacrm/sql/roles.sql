select 'grant execute on '  || specific_name || ' to chacrm_execute;' from information_schema.routines where specific_schema='public'

select 'grant usage,select on ' || sequence_name || ' to chacrm_select;'  from information_schema.sequences where sequence_schema='public'

select 'grant update on '||tablename||' to chacrm_update;' from pg_tables where schemaname='public'

select 'grant delete on '||tablename||' to chacrm_delete;' from pg_tables where schemaname='public'

select 'grant insert on '||tablename||' to chacrm_insert;' from pg_tables where schemaname='public'

select 'grant select on '||tablename||' to PUBLIC;' from pg_tables where schemaname='public';

select 'grant select on '||viewname||' to PUBLIC;' from pg_views where schemaname='public';


