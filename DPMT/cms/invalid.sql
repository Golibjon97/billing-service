prompt
prompt Все инвалидные объекты по IBS
prompt
--
select t.object_name, t.object_type
  from user_objects t
 where t.status like 'I%'
 order by t.object_type, t.object_name;
--
prompt
prompt ********************************************************
prompt
