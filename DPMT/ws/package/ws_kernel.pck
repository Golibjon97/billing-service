create or replace package ws_kernel is

  -- Author  : G'olibjon
  -- Created : 07.11.2022 15:40:00
  -- Purpose :
  function write_protocol(i_id        number := null,
                          i_action_id number,
                          i_method_id number := null,
                          i_request   clob := null,
                          i_response  clob := null) return number;
------------------------------------------------------------------
  function get_method_name(i_method_id number) return varchar2;
------------------------------------------------------------------
  function get_crud_operation(i_method_id number) return varchar2;
------------------------------------------------------------------
end ws_kernel;
/
create or replace package body ws_kernel is
  ----------------------------------------------------------------------------------
  function get_method_name(i_method_id number) return varchar2 is
    v_method_name varchar2(500);
  begin
    select t.method_name
      into v_method_name
      from ws_method t
     where t.id = i_method_id;
    return v_method_name;
  end get_method_name;
  ----------------------------------------------------------------------------------
  function get_crud_operation(i_method_id number) return varchar2 is
    v_crud_operation varchar2(10);
  begin
    select t.crud_operation
      into v_crud_operation
      from ws_method t
     where t.id = i_method_id;
    return v_crud_operation;
  end get_crud_operation;
  ----------------------------------------------------------------------------------
  function write_protocol(i_id         number := null,
                          i_action_id  number,
                          i_method_id  number := null,
                          i_request    clob := null,
                          i_response   clob := null) return number is
    pragma autonomous_transaction;
    v_id    integer := i_id;
    v_error varchar2(4000) := substr(sqlerrm ||
                                     dbms_utility.format_error_backtrace,
                                     1,
                                     3999);
  begin
  
    if v_id is not null then
      --if i_request is null and i_response is null then
      if i_action_id = 3 or i_action_id = 5 then
         update ws_protocol u --    3-этап (ответ принят на запрос)
           set u.action_id     = i_action_id,
               u.response      = i_response,
               u.response_time = sysdate,
               u.system_err    = 'Успешно выполнено'
         where u.id = v_id;
      else
        update ws_protocol t  --    2-этап (после отправки запроса)
           set t.action_id  = i_action_id,
               t.system_err = 'Ошибка при получении ответа или не ожидаемый ответ : ' ||
                              v_error
         where t.id = v_id;
      end if;
    else
      v_id := ws_protocol_sq.nextval;
      insert into ws_protocol --   1-этап (До начало запроса)
        (id,
         action_id,
         method_id,
         request,
         request_time,
         response,
         response_time,
         system_err)
      values
        (v_id,
         i_action_id,
         i_method_id,
         i_request,
         sysdate,
         i_response,
         sysdate,
         'Ошибка при отправки запроса');
    
    end if;
    commit;
    return v_id;
  exception
    when others then
      v_id := ws_protocol_sq.nextval;
      insert into ws_protocol
        (id,
         action_id,
         request,
         request_time,
         response,
         response_time,
         system_err)
      values
        (v_id,
         i_action_id,
         i_request,
         sysdate,
         i_response,
         sysdate,
         v_error);
      commit;
      return v_id;
  end write_protocol;

----------------------------------------------------------------------------------

end ws_kernel;
/
