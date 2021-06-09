-- Function: security_policy()

-- DROP FUNCTION security_policy();

CREATE OR REPLACE FUNCTION security_policy()
  RETURNS int4 AS
$BODY$
DECLARE

  v_owner character varying = 'cjm';

  c_revoke_public_table_privs  CURSOR FOR SELECT 'revoke all on '||nspname||'.'||relname||
                                                 ' from public;' as revoke_stmt 
                                 FROM pg_class
                                     ,pg_authid
                                     ,pg_namespace 
                                WHERE relowner = pg_authid.oid 
                                  AND rolname = v_owner
                                  AND relkind = 'r'
                                  AND relnamespace = pg_namespace.oid;

  c_grant_insert_table_privs  CURSOR FOR SELECT 'grant insert on '||nspname||'.'||relname||
                                                ' to chacrm_insert;' as grant_insert_stmt 
                                 FROM pg_class
                                     ,pg_authid
                                     ,pg_namespace 
                                WHERE relowner = pg_authid.oid 
                                  AND rolname = v_owner
                                  AND relkind = 'r'
                                  AND relnamespace = pg_namespace.oid;

  c_grant_update_table_privs  CURSOR FOR SELECT 'grant update on '||nspname||'.'||relname||
                                                ' to chacrm_update;' as grant_update_stmt 
                                 FROM pg_class
                                     ,pg_authid
                                     ,pg_namespace 
                                WHERE relowner = pg_authid.oid 
                                  AND rolname = v_owner
                                  AND relkind = 'r'
                                  AND relnamespace = pg_namespace.oid;

  c_grant_delete_table_privs  CURSOR FOR SELECT 'grant delete on '||nspname||'.'||relname||
                                                ' to chacrm_delete;' as grant_delete_stmt 
                                 FROM pg_class
                                     ,pg_authid
                                     ,pg_namespace 
                                WHERE relowner = pg_authid.oid 
                                  AND rolname = v_owner
                                  AND relkind = 'r'
                                  AND relnamespace = pg_namespace.oid;

  c_grant_select_table_privs  CURSOR FOR SELECT 'grant select on '||nspname||'.'||relname||
                                                ' to public;' as grant_select_stmt 
                                 FROM pg_class
                                     ,pg_authid
                                     ,pg_namespace 
                                WHERE relowner = pg_authid.oid 
                                  AND rolname = v_owner
                                  AND relkind = 'r'
                                  AND relnamespace = pg_namespace.oid;

  priv_dml_stmt RECORD;
  priv_counter integer = 0;

BEGIN


  OPEN c_revoke_public_table_privs;

  LOOP
   FETCH c_revoke_public_table_privs INTO priv_dml_stmt;
   EXIT WHEN NOT FOUND;
   RAISE NOTICE '%',priv_dml_stmt.revoke_stmt;
   EXECUTE priv_dml_stmt.revoke_stmt;
   priv_counter = priv_counter +1;
  END LOOP;

  CLOSE c_revoke_public_table_privs;

  OPEN c_grant_select_table_privs; 

  LOOP
   FETCH c_grant_select_table_privs INTO priv_dml_stmt;
   EXIT WHEN NOT FOUND;
   RAISE NOTICE '%',priv_dml_stmt.grant_select_stmt;
   EXECUTE priv_dml_stmt.grant_select_stmt;
   priv_counter = priv_counter +1;
  END LOOP;

  CLOSE c_grant_select_table_privs;

  OPEN c_grant_insert_table_privs; 

  LOOP
   FETCH c_grant_insert_table_privs INTO priv_dml_stmt;
   EXIT WHEN NOT FOUND;
   RAISE NOTICE '%',priv_dml_stmt.grant_insert_stmt;
   EXECUTE priv_dml_stmt.grant_insert_stmt;
   priv_counter = priv_counter +1;
  END LOOP;

  CLOSE c_grant_insert_table_privs;

  OPEN c_grant_update_table_privs; 

  LOOP
   FETCH c_grant_update_table_privs INTO priv_dml_stmt;
   EXIT WHEN NOT FOUND;
   RAISE NOTICE '%',priv_dml_stmt.grant_update_stmt;
   EXECUTE priv_dml_stmt.grant_update_stmt;
   priv_counter = priv_counter +1;
  END LOOP;

  CLOSE c_grant_update_table_privs;

  OPEN c_grant_delete_table_privs; 

  LOOP
   FETCH c_grant_delete_table_privs INTO priv_dml_stmt;
   EXIT WHEN NOT FOUND;
   RAISE NOTICE '%',priv_dml_stmt.grant_delete_stmt;
   EXECUTE priv_dml_stmt.grant_delete_stmt;
   priv_counter = priv_counter +1;
  END LOOP;

  CLOSE c_grant_delete_table_privs;
 
  EXECUTE 'grant chacrm_insert,chacrm_update,chacrm_delete to apache';
  EXECUTE 'grant insert,update,delete on public.featureprop to ims';

  RETURN priv_counter;

END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
ALTER FUNCTION security_policy() OWNER TO cjm;
