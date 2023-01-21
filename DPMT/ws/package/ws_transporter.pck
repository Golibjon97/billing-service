create or replace package ws_transporter is

  -- Author  : G'olibjon
  -- Created : 07.11.2022 15:45:00
  -- Purpose :
  ---------------------------------------------------------------------------------- 
  procedure accept_request(notification in varchar2, resp out varchar2);
  ---------------------------------------------------------------------------------- 
end ws_transporter;
/
create or replace package body ws_transporter is
  ---------------------------------------------------------------------------------- 
  procedure accept_request(notification in varchar2, resp out varchar2) is
    -- accept_request
    v_clob_notif   clob;
    v_protocol_id  number;
    v_notification Array_Varchar2;
  
  begin
    v_clob_notif  := to_clob(notification);
    v_protocol_id := ws_kernel.write_protocol(i_action_id => 4, -- 4 - Запрос отправлен
                                              i_method_id => 2,
                                              i_request   => v_clob_notif);
  
    v_notification := array_varchar2(notification);
  
    for r in 1 .. v_notification.count loop
      dbms_output.put_line(v_notification(r));
    end loop;
  
    Service_Methods.Request_Method_2(i_Json => v_notification, --------------------------------------------must be declared
                                     o_msg  => resp);
    --resp := 'test';
  
    v_clob_notif  := null;
    v_clob_notif  := to_clob(resp);
    v_protocol_id := ws_kernel.write_protocol(i_id        => v_protocol_id,
                                              i_action_id => 5, -- 5 - Запрос принят
                                              i_response  => v_clob_notif);
  
  end;
  ---------------------------------------------------------------------------------- 
end ws_transporter;
/
