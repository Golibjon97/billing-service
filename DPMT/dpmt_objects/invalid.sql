prompt
prompt Инвалидные объекты по CR
prompt
--
select t.object_name, t.object_type
  from user_objects t
 where t.object_name like 'CR\_%' escape '\'
   and t.status like 'I%'
 order by t.object_type, t.object_name;
--
prompt
prompt ********************************************************
prompt
