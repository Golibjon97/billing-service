create or replace package Service_Methods is

  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_1_Json
  (
    i_Request_Id    varchar2,
    i_Service_Id    number,
    i_Department_Id varchar2,
    i_Amount        number,
    i_Note          varchar2,
    i_Discounts     varchar2,
    i_Name          varchar2,
    i_Phone         varchar2,
    i_Type          varchar2,
    o_Json          out Array_Varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_1
  (
    i_Filial_Code    varchar2,
    i_Name           varchar2,
    i_Payer_Type_Id  number,
    i_Pay_Type_Id    number,
    o_Invoice_Id     out number,
    o_Invoice_Serial out varchar2,
    o_Invoice_Summa  out number,
    o_Invoice_Date   out date,
    o_Msg            out varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_2
  (
    i_Json Array_Varchar2,
    o_Msg  out varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_3
  (
    i_Serial_Number varchar2,
    o_Msg           out varchar2,
    o_Invoice_State out varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_4
  (
    i_Date date,
    o_Msg  out varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_5
  (
    i_Invoice_Id number,
    o_Msg        out varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_6
  (
    i_Invoice_Id number,
    o_Msg        out varchar2
  );
  ---------------------------------------------------------------------------------------------------
end Service_Methods;
/
create or replace package body Service_Methods is
  ---------------------------------------------------------------------------------------------------
  Procedure Update_Invoice_State
  (
    i_Invoice_Id       in number,
    i_Invoice_State_Id in number
  ) is
    v_Rec Cp_Invoices%rowtype;
  begin
    Cp_Util.Select_Invoice(i_Invoice_Id, v_Rec);
  
    if v_Rec.State_Id <> i_Invoice_State_Id then
    
      Adm_Setup.Logon('spc', 'spc');
    
      update Cp_Invoices t
         set t.State_Id    = i_Invoice_State_Id,
             t.Modified_On = sysdate,
             t.Modified_By = Adm_Setup.User_Id
       where t.Invoice_Id = i_Invoice_Id;
    
      commit;
    
    end if;
  
  end Update_Invoice_State;
  ---------------------------------------------------------------------------------------------------
  Procedure Save_Service_Methods_1_Responce(Io_Metod_1 in out nocopy Service_Methods_1_Responce%rowtype) is
  begin
  
    Io_Metod_1.Created_On := sysdate;
  
    insert into Service_Methods_1_Responce
    values Io_Metod_1;
  
    --commit;
  
  end Save_Service_Methods_1_Responce;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_1_Parse
  (
    i_Json           Array_Varchar2,
    o_Invoice_Id     out number,
    o_Invoice_Serial out varchar2,
    o_Invoice_Summa  out number,
    o_Invoice_Date   out date
  ) is
    v_Elements       Json_String_t := Json_String_t();
    v_Hash           Hashmap;
    v_Invoice_Id     number(12);
    v_Invoice_Serial varchar2(20);
    v_Invoice_Summa  number(20);
    v_Invoice_Date   date;
    v_Metod_1        Service_Methods_1_Responce%rowtype;
    v_Request_Id     varchar2(50);
  begin
    begin
      v_Hash           := Json_Parser.Parse_Json(i_Json);
      v_Invoice_Id     := v_Hash.Get_Number('id');
      v_Invoice_Serial := v_Hash.Get_Varchar2('serial');
      v_Invoice_Summa  := v_Hash.Get_Number('fee');
      v_Invoice_Date   := v_Hash.Get_Date('issueDate', 'yyyy-mm-dd');
      v_Request_Id     := v_Hash.Get_Varchar2('requestId');
      --v_Note           := v_Hash.Get_Varchar2('note');
    
      -- save table Service_Methods_1_Responce
    
      v_Metod_1.Invoice_Id := v_Invoice_Id;
      v_Metod_1.Requestid  := v_Request_Id;
      --v_Metod_1.Note           := v_Note;
      v_Metod_1.Invoice_Serial := v_Invoice_Serial;
    
      Save_Service_Methods_1_Responce(v_Metod_1);
    
      o_Invoice_Id     := v_Invoice_Id;
      o_Invoice_Serial := v_Invoice_Serial;
    
      o_Invoice_Summa := v_Invoice_Summa;
      o_Invoice_Date  := v_Invoice_Date;
    exception
      when others then
        v_Elements.Put('id', v_Invoice_Id);
        v_Elements.Put('result_code', 301);
        v_Elements.Put('msg', 'Обязательные поля отсутствуют');
        v_Elements.Close_Json;
        return;
    end;
  end Request_Method_1_Parse;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_2_Parse
  (
    i_Json Array_Varchar2,
    o_Msg  out varchar2
  ) is
    v_Hash           Hashmap := Hashmap();
    v_Payment_Hash   Hashmap := Hashmap();
    v_Invoice_Id     number(12);
    v_Answereid      integer;
    v_Answeremessage varchar2(32767);
    v_Answerecomment varchar2(100);
    v_Count          integer;
  begin
    begin
      v_Hash         := Json_Parser.Parse_Json(i_Json);
      v_Payment_Hash := v_Hash.Get_Optional_Hashmap('data');
      v_Invoice_Id   := v_Payment_Hash.Get_Number('id');
    
      /*
      1 Сформирована
      3 Отменена
      4 Оплачена
      5 Закрыта
      */
    
      Adm_Setup.Logon('spc', 'spc');
    
      select count(*)
        into v_Count
        from Cp_Invoices t
       where t.Invoice_Id = v_Invoice_Id
         and t.State_Id = 1;
    
      if v_Count <> 1 then
        v_Answereid      := 5;
        v_Answeremessage := '"Данные не найдены"';
        v_Answerecomment := '""';
      
      else
        update Cp_Invoices t
           set t.State_Id    = 4,
               t.Modified_On = sysdate,
               t.Modified_By = Adm_Setup.User_Id
         where t.Invoice_Id = v_Invoice_Id
           and t.State_Id = 1;
      
        commit;
      
        v_Answereid      := 1;
        v_Answeremessage := '"OK"';
        v_Answerecomment := '""';
      end if;
    
    exception
      when others then
        v_Answereid      := 0;
        v_Answeremessage := '"' || sqlerrm || '"';
        v_Answerecomment := '""';
    end;
    /*dbms_output.put_line(length(v_Answeremessage) || ' ' ||
    length(v_Answeremessage) || ' ' ||
    length(v_Answerecomment));*/
    o_Msg := '{
  "answerId":' || v_Answereid || ',
  "answerMessage":' || v_Answeremessage || ',
  "answerComment": ' || v_Answerecomment || '
}
';
  
  end Request_Method_2_Parse;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_3_Parse
  (
    i_Json          Array_Varchar2,
    o_Invoice_State out varchar2
  ) is
    v_Elements         Json_String_t := Json_String_t();
    v_Hash             Hashmap;
    v_Invoice_Id       number(12);
    v_Invoice_State    varchar2(20);
    v_Invoice_State_Id number(1);
  begin
    begin
      v_Hash          := Json_Parser.Parse_Json(i_Json);
      v_Invoice_Id    := v_Hash.Get_Number('id');
      v_Invoice_State := v_Hash.Get_Varchar2('status');
    
      if v_Invoice_State = 'OPEN' then
        v_Invoice_State_Id := 1;
        o_Invoice_State    := 'Not paid';
      elsif v_Invoice_State = 'PAID' then
        v_Invoice_State_Id := 4;
        o_Invoice_State    := 'Paid';
      elsif v_Invoice_State = 'EXPIRED' then
        v_Invoice_State_Id := 1;
        o_Invoice_State    := 'Not paid';
      elsif v_Invoice_State = 'CANCELED' then
        v_Invoice_State_Id := 3;
        o_Invoice_State    := 'Not paid';
      else
        v_Invoice_State_Id := null;
        o_Invoice_State    := 'Not paid';
      end if;
    
      /*  Expired – Просрочен
      Canceled - Отменен*/
    
      if v_Invoice_State_Id is not null then
        Update_Invoice_State(v_Invoice_Id, v_Invoice_State_Id);
      end if;
    
    exception
      when others then
        v_Elements.Put('id', v_Invoice_Id);
        v_Elements.Put('result_code', 301);
        v_Elements.Put('msg', 'Обязательные поля отсутствуют');
        v_Elements.Close_Json;
        return;
    end;
  end Request_Method_3_Parse;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_4_Parse
  (
    i_Json Array_Varchar2,
    o_Msg  out varchar2
  ) is
    v_Elements Json_String_t := Json_String_t();
    v_Hash     Hashmap;
    v_Data     varchar2(30000);
  begin
    begin
      v_Hash := Json_Parser.Parse_Json(i_Json);
      v_Data := v_Hash.Get_Optional_Varchar2('data');
      if v_Data is null then
        o_Msg := 'По данной дате нет не оплаченных инвойсов';
        return;
      end if;
    exception
      when others then
        null;
        v_Elements.Close_Json;
        return;
    end;
  end Request_Method_4_Parse;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_1_Json
  (
    i_Request_Id    varchar2,
    i_Service_Id    number,
    i_Department_Id varchar2,
    i_Amount        number,
    i_Note          varchar2,
    i_Discounts     varchar2,
    i_Name          varchar2,
    i_Phone         varchar2,
    i_Type          varchar2,
    o_Json          out Array_Varchar2
  ) is
    v_Element Json_String_t := Json_String_t();
  
  begin
    v_Element.Open_Json('invoice');
  
    v_Element.Put('requestId', i_Request_Id);
    v_Element.Put('serviceId', i_Service_Id);
    v_Element.Put('departmentId', i_Department_Id);
    v_Element.Put('amount', i_Amount);
    v_Element.Put('note', i_Note);
  
    if i_Discounts is not null then
    
      v_Element.Open_Array('discounts');
      v_Element.Add_Elem(i_Discounts);
      v_Element.Close_Array;
    
    end if;
  
    v_Element.Close_Json;
  
    v_Element.Open_Json('payer');
  
    v_Element.Put('name', i_Name);
    v_Element.Put('phone', i_Phone);
    v_Element.Put('type', i_Type);
  
    v_Element.Close_Json;
    v_Element.Close_Json;
  
    o_Json := v_Element.To_String_Array;
  
  end Request_Method_1_Json;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_1
  (
    i_Filial_Code    varchar2,
    i_Name           varchar2,
    i_Payer_Type_Id  number,
    i_Pay_Type_Id    number,
    o_Invoice_Id     out number,
    o_Invoice_Serial out varchar2,
    o_Invoice_Summa  out number,
    o_Invoice_Date   out date,
    o_Msg            out varchar2
  ) is
    v_Request_Id     varchar2(12);
    v_Service_Id     number(20);
    v_Department_Id  varchar2(12);
    v_Amount         number(12);
    v_Note           varchar2(200);
    v_Discounts      varchar2(200);
    v_Name           varchar2(100) := i_Name; --Regexp_Replace(i_Name, '[‘’`]', '''');
    v_Phone          varchar2(20);
    v_Type           varchar2(2) := '1';
    v_Json           Array_Varchar2;
    v_Metod_Id       integer := 1;
    v_Responce_Json  Array_Varchar2;
    v_Responce_Msg   varchar2(500);
    v_Invoice_Id     number(12);
    v_Invoice_Serial varchar2(20);
    v_Invoice_Summa  number(20);
    v_Invoice_Date   date;
  
  begin
  
    begin
      select t.Service_Id, t.Discount_Id
        into v_Service_Id, v_Discounts
        from Ref_Price_List t
       where t.Payer_Type_Id = i_Payer_Type_Id
         and t.Pay_Type_Id = i_Pay_Type_Id;
    exception
      when No_Data_Found then
        v_Service_Id := null;
        v_Discounts  := null;
    end;
  
    if v_Service_Id is null then
      o_Msg := 'Bu platelshikda servis id mavjud emas';
      return;
    end if;
  
    begin
      select t.Departament_Id
        into v_Department_Id
        from Adm_Filials t
       where t.Filial_Code = i_Filial_Code;
    exception
      when No_Data_Found then
        v_Department_Id := null;
    end;
  
    if v_Department_Id is null then
      o_Msg := 'Bu filialda departament id mavjud emas';
      return;
    end if;
  
    v_Request_Id := Request_Metod_1_Seq.Nextval;
  
    Request_Method_1_Json(v_Request_Id,
                          v_Service_Id,
                          v_Department_Id,
                          v_Amount,
                          v_Note,
                          v_Discounts,
                          v_Name,
                          v_Phone,
                          v_Type,
                          v_Json);
  
    for r in 1 .. v_Json.Count
    loop
      Dbms_Output.Put_Line(v_Json(r));
    end loop;
  
    Dbms_Output.Put_Line('----------------------------------');
  
    --G'olib procedurasi bo'ladi bu yerda
    Ws_Api.Income_Action(i_Request_Id => v_Request_Id,
                         i_Details    => v_Json,
                         i_Method_Id  => v_Metod_Id,
                         i_Param      => null,
                         o_Resp       => v_Responce_Json,
                         o_Msg        => v_Responce_Msg);
  
    if v_Responce_Msg is null then
      for r in 1 .. v_Responce_Json.Count
      loop
        Dbms_Output.Put_Line(v_Responce_Json(r));
      end loop;
    end if;
  
    if v_Responce_Msg is null then
      Request_Method_1_Parse(i_Json           => v_Responce_Json,
                             o_Invoice_Id     => v_Invoice_Id,
                             o_Invoice_Serial => v_Invoice_Serial,
                             o_Invoice_Summa  => v_Invoice_Summa,
                             o_Invoice_Date   => v_Invoice_Date);
    end if;
  
    o_Msg := v_Responce_Msg;
  
    o_Invoice_Id     := v_Invoice_Id;
    o_Invoice_Serial := v_Invoice_Serial;
    o_Invoice_Summa  := v_Invoice_Summa;
    o_Invoice_Date   := v_Invoice_Date;
  
  end Request_Method_1;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_2
  (
    i_Json Array_Varchar2,
    o_Msg  out varchar2
  ) is
  
    v_Msg varchar2(32767);
  begin
  
    /*for r in 1 .. i_Json.Count loop
      Dbms_Output.Put_Line(i_Json(r));
    end loop;*/
  
    begin
    
      Request_Method_2_Parse(i_Json => i_Json, o_Msg => v_Msg);
    
      o_Msg := v_Msg;
    end;
  end Request_Method_2;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_3
  (
    i_Serial_Number varchar2,
    o_Msg           out varchar2,
    o_Invoice_State out varchar2
  ) is
    v_Request_Id    varchar2(50);
    v_Metod_Id      integer := 3;
    v_Responce_Json Array_Varchar2;
    v_Responce_Msg  varchar2(100);
    v_Invoice_State varchar2(20);
  
  begin
  
    begin
      select t.Requestid
        into v_Request_Id
        from Service_Methods_1_Responce t
       where t.Invoice_Serial = i_Serial_Number;
    exception
      when No_Data_Found then
        o_Msg := 'Request ID по данному серийному номеру не существует';
        return;
    end;
  
    --G'olib procedurasi bo'ladi bu yerda
    Ws_Api.Income_Action(i_Request_Id => v_Request_Id,
                         i_Details    => null,
                         i_Method_Id  => v_Metod_Id,
                         i_Param      => i_Serial_Number,
                         o_Resp       => v_Responce_Json,
                         o_Msg        => v_Responce_Msg);
  
    /* for r in 1 .. v_Responce_Json.Count loop
      Dbms_Output.Put_Line(v_Responce_Json(r));
    end loop;*/
  
    if v_Responce_Msg = 'Успешно' then
      Request_Method_3_Parse(i_Json => v_Responce_Json, o_Invoice_State => v_Invoice_State);
    end if;
  
    o_Msg           := v_Responce_Msg;
    o_Invoice_State := v_Invoice_State;
  
  end Request_Method_3;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_4
  (
    i_Date date,
    o_Msg  out varchar2
  ) is
  
    v_Metod_Id      integer := 4;
    v_Responce_Json Array_Varchar2;
    v_Responce_Msg  varchar2(100);
    v_Date          varchar2(10);
    v_Msg           varchar2(100);
  
  begin
  
    v_Date := to_char(i_Date, 'yyyy-mm-dd');
  
    --G'olib procedurasi bo'ladi bu yerda
    Ws_Api.Income_Action(i_Request_Id => null,
                         i_Details    => null,
                         i_Method_Id  => v_Metod_Id,
                         i_Param      => v_Date,
                         o_Resp       => v_Responce_Json,
                         o_Msg        => v_Responce_Msg);
  
    for r in 1 .. v_Responce_Json.Count
    loop
      Dbms_Output.Put_Line(v_Responce_Json(r));
    end loop;
  
    if v_Responce_Msg is null then
      Request_Method_4_Parse(i_Json => v_Responce_Json, o_Msg => v_Msg);
    end if;
  
    if v_Responce_Msg is not null then
      o_Msg := v_Responce_Msg;
    end if;
  
    if v_Msg is not null then
      o_Msg := v_Msg;
    end if;
  
  end Request_Method_4;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_5
  (
    i_Invoice_Id number,
    o_Msg        out varchar2
  ) is
    v_Metod_Id      integer := 5;
    v_Responce_Json Array_Varchar2;
    v_Responce_Msg  varchar2(4000);
  
  begin
  
    --G'olib procedurasi bo'ladi bu yerda
    Ws_Api.Income_Action(i_Request_Id => null, --v_Request_Id,
                         i_Details    => null,
                         i_Method_Id  => v_Metod_Id,
                         i_Param      => i_Invoice_Id,
                         o_Resp       => v_Responce_Json,
                         o_Msg        => v_Responce_Msg);
  
    o_Msg := v_Responce_Msg;
  
  end Request_Method_5;
  ---------------------------------------------------------------------------------------------------
  Procedure Request_Method_6
  (
    i_Invoice_Id number,
    o_Msg        out varchar2
  ) is
  
    v_Metod_Id      integer := 6;
    v_Responce_Json Array_Varchar2;
    v_Responce_Msg  varchar2(4000);
  
  begin
  
    --G'olib procedurasi bo'ladi bu yerda
    Ws_Api.Income_Action(i_Request_Id => null,
                         i_Details    => null,
                         i_Method_Id  => v_Metod_Id,
                         i_Param      => i_Invoice_Id,
                         o_Resp       => v_Responce_Json,
                         o_Msg        => v_Responce_Msg);
  
    o_Msg := v_Responce_Msg;
  
  end Request_Method_6;
  ---------------------------------------------------------------------------------------------------
end Service_Methods;
/
