create or replace package ws_api is

  -- Author  : G'olibjon
  -- Created : 07.11.2022 15:43:44
  -- Purpose :

  -- Public type declarations
  --------------------------------------------------------------
  Procedure Income_action(i_request_id   varchar2,
                          i_method_id    number,
                          i_param        VARCHAR2,
                          i_details      Array_Varchar2,
                          o_resp         out Array_Varchar2,
                          o_msg          out varchar2);
  --------------------------------------------------------------

end ws_api;
/
create or replace package body ws_api is

  ----------------------------------------------------------------------------------

  Procedure Income_action(i_request_id varchar2,
                          i_method_id  number,
                          i_param      VARCHAR2,
                          i_details    Array_Varchar2,
                          o_resp       out Array_Varchar2,
                          o_msg        out varchar2) is
    Ex exception;
    v_Req         Utl_Http.Req;
    v_Res         Utl_Http.Resp;
    v_Length      pls_integer := 0;
    v_crud        varchar2(10);
    v_protocol_id number;
    v_method_name varchar2(150) := 'http://10.50.70.67:8090';   -- v_method_name varchar2(150) := 'http://10.130.12.100:5555/BS-test';
    v_Hash        Hashmap := Hashmap();
    v_request_id  varchar2(12);
    v_status      varchar2(500);
    v_clob_http   clob;
  begin
    ------
    /*Exception handling*/
  
    if i_method_id is null then
      o_msg := 'Метод не может быть пустым';
      raise Ex;
    end if;
  
    if i_method_id = 1 or i_method_id = 3 then
      if i_request_id is null then
        o_msg := 'ID заявки не может быть пустым';
        raise Ex;
      end if;
    end if;
  
    v_crud        := ws_kernel.get_crud_operation(i_method_id);
    v_method_name := v_method_name ||
                     ws_kernel.get_method_name(i_method_id);
  
    ----------------//Method N1. POST//----------------
    if i_method_id = 1 then
      begin
      
        if i_details is null then
          o_msg := 'Детали не могут быть пустыми';
          raise Ex;
        end if;
      
        --
      
        v_Hash := json_parser.parse_json(i_details);
      
        v_clob_http := v_Hash.Json_Clob;
      
        for i in 1 .. i_details.Count loop
          v_Length := v_Length + Lengthb(i_details(i));
        end loop;
      
        /*state 1 = received request*/
      
        v_protocol_id := ws_kernel.write_protocol(i_action_id => 1,
                                                  i_method_id => i_method_id,
                                                  i_request   => v_clob_http);
      
        begin
          v_req := Utl_Http.begin_request(v_method_name, v_crud, 'HTTP/1.1');
        
        Exception
          when others then
            raise_application_error(-20000,
                                    'Не возможно подключиться в URI адрес');
        end;
      
        --
      
        /*state 2 = request sent*/
      
        v_protocol_id := ws_kernel.write_protocol(i_id        => v_protocol_id,
                                                  i_action_id => 2);
      
        Utl_Http.Set_Body_Charset(v_Req, 'UTF-8');
        Utl_Http.Set_Header(v_Req, 'content-type', 'application/json');
        Utl_Http.Set_Transfer_Timeout(30);
        Utl_Http.Set_Header(v_Req, 'Content-Length', v_Length);
        Utl_Http.Set_Header(v_Req, 'Accept', 'application/json');
      
        for i in 1 .. i_details.Count loop
          Utl_Http.Write_Text(v_Req, i_details(i)); -- Writes the text into content
        end loop;
      
        v_Res  := Utl_Http.Get_Response(v_Req); -- Getting response
        o_Resp := Array_Varchar2();
      
        begin
          loop
            o_resp.extend;
            Utl_Http.Read_Text(v_Res, o_resp(o_resp.count), 32000);
          end loop;
        end;
        --
      
      exception
        when Utl_Http.End_Of_Body then
          Utl_Http.End_Response(v_Res);
        
          for r in 1 .. o_resp.count loop
            Dbms_Output.Put_Line(o_resp(r));
          end loop;
        
          /*state 3 = response received*/
          v_Hash := json_parser.parse_json(o_resp);
        
          -- Проверка на ошибочный запрос
          if v_Res.status_code != UTL_HTTP.HTTP_OK then
            o_msg := v_Hash.Get_Varchar2('message');
            raise Ex;
          end if;
        
          v_clob_http := v_Hash.Json_Clob;
          Utl_Http.End_Response(v_Res);
          v_request_id := v_Hash.Get_Varchar2('requestId');
          --
        
          if v_request_id != i_request_id then
            o_msg := 'ID принятой заявки не соответсвует ID отправленной заявки';
            raise Ex;
          end if;
          --
        
          v_protocol_id := ws_kernel.write_protocol(i_id        => v_protocol_id,
                                                    i_action_id => 3,
                                                    i_response  => v_clob_http);
      end;
    
      ----------------//Method N3 - N4 - N5 - N6. GET GET DELETE PUT//----------------
    else
    
      begin
      
        if i_param is null then
          o_msg := 'Параметр данной заявки не может быть пустым';
          raise Ex;
        end if;
      
        /*state 1 = received request*/
      
        v_protocol_id := ws_kernel.write_protocol(i_action_id => 1,
                                                  i_method_id => i_method_id,
                                                  i_request   => v_clob_http);
      
        v_method_name := v_method_name || i_param;
      
        begin
          v_req := Utl_Http.begin_request(v_method_name, v_crud, 'HTTP/1.1');
        Exception
          when others then
            raise_application_error(-20000,
                                    'Не возможно подключиться в URI адрес');
        end;
      
        --
      
        /*state 2 = request sent*/
        v_protocol_id := ws_kernel.write_protocol(i_id        => v_protocol_id,
                                                  i_action_id => 2);
      
        Utl_Http.Set_Body_Charset(v_Req, 'UTF-8');
        if i_method_id = 3 or i_method_id = 4 then
          Utl_Http.Set_Header(v_Req, 'content-type', 'application/json'); -- used for request (Only 3 and 4methods)
        end if;
        Utl_Http.Set_Transfer_Timeout(30);
        Utl_Http.Set_Header(v_Req, 'Accept', 'application/json'); -- used for response (All)
      
        v_Res  := Utl_Http.Get_Response(v_Req); -- Getting response
        o_Resp := Array_Varchar2();
      
        begin
          loop
            o_resp.extend;
            Utl_Http.Read_Text(v_Res, o_resp(o_resp.count), 32000);
          end loop;
        end;
        --
      
      exception
        when Utl_Http.End_Of_Body then
          Utl_Http.End_Response(v_Res);
        
          /*state 3 = response received*/
        
          /*Get methods*/
          if i_method_id = 3 or i_method_id = 4 then
          
            v_Hash := json_parser.parse_json(o_resp);
          
            if i_method_id = 3 and (v_Res.status_code = UTL_HTTP.HTTP_Ok) then
              --compare the requestIDs in ok code 3rd method
              v_request_id := v_Hash.Get_Varchar2('requestId');
              if v_request_id != i_request_id then
                o_msg := 'ID принятой заявки не соответсвует ID отправленной заявки';
                raise Ex;
              end if;
            end if;
          
            if (v_Res.status_code != UTL_HTTP.HTTP_Ok) then
              if i_method_id = 3 then
                o_msg := 'Инвойс не найден'; -- 3rd method. Wrong input
                raise Ex;
              else
                o_msg := 'Не правильный формат даты'; -- 4th method. Wrong input
                raise Ex;
              end if;
            end if;
          
            -- inserting list of results into details table
            v_clob_http := v_Hash.Json_Clob();
          else
            /*Put or Delete methods*/
            if v_Res.status_code = Utl_http.HTTP_BAD_REQUEST then
              --UTL_HTTP.HTTP_OK or v_Res.status_code <> 200 or v_Res.status_code != UTL_HTTP.HTTP_ACCEPTED then
              v_Hash := json_parser.parse_json(o_resp);
              o_msg  := v_Hash.Get_Optional_Varchar2('message');
              raise Ex;
            end if;
          end if;

          v_protocol_id := ws_kernel.write_protocol(i_id        => v_protocol_id,
                                                    i_action_id => 3,
                                                    i_response  => v_clob_http);
          if (i_method_id = 3 or i_method_id = 4) and
             v_Res.status_code = UTL_HTTP.HTTP_OK then
            o_msg := 'Успешно';
          end if;
        
          if i_method_id = 5 and
             (v_Res.status_code = UTL_HTTP.HTTP_ACCEPTED or
             v_Res.status_code = Utl_Http.HTTP_OK) then
            o_msg := 'Инвойс успешно аннулировано';
          end if;
        
          if i_method_id = 6 and
             (v_Res.status_code = UTL_HTTP.HTTP_ACCEPTED or
             v_Res.status_code = Utl_Http.HTTP_OK) then
            o_msg := 'Инвойс успешно восстановлено';
          end if;
        
          Utl_Http.End_Response(v_Res);
          --
      
      end;
    end if;
  
  Exception
    When ex then
      return;
    When Others then
      o_msg := substr('Системная ошибка: ' || sqlerrm, 2000);
      return;
  end;
  -------------------------------------------------------------------------------------------------------------------------------------------------

end ws_api;
/
