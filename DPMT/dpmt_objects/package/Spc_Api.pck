create or replace package Spc_Api is

  -- Author  : Nurbek
  -- Created : 24.10.2018 11:15:29
  -- Purpose : 

  ---------------------------------------------------------------------------------------------------
  Procedure Order_Invoice
  (
    i_Filial_Code     in varchar2,
    i_First_Name_Ru   in varchar2,
    i_Last_Name_Ru    in varchar2,
    i_Patronymic_Ru   in varchar2,
    i_First_Name_Uz   in varchar2,
    i_Last_Name_Uz    in varchar2,
    i_Patronymic_Uz   in varchar2,
    i_Doc_Id          in number,
    i_Doc_Se          in varchar2,
    i_Doc_No          in varchar2,
    i_Birth_Date      in date,
    i_Sign_Birthdate  in number,
    i_Invoice_Type_Id in number,
    i_Parent_Id       in number := null,
    i_Payer_Type_Id   in number,
    i_Pay_Type_Id     in number,
    i_Order_No        in number,
    i_Order_Date      in date,
    i_Order_Time      in varchar2,
    o_Invoice_Id      out number,
    o_Code            out varchar2,
    o_Msg             out varchar2
  );
  -------------------------------------------------------------------------------------------------
  Procedure Change_Order_Invoice
  (
    i_Invoice_Id number,
    i_Order_No   number,
    i_Order_Date date,
    i_Order_Time varchar2,
    o_Code       out varchar2,
    o_Msg        out varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Check_Invoice
  (
    i_Invoice_Id in number,
    o_Code       out varchar2,
    o_Msg        out varchar2
  );
  -------------------------------------------------------------------------------------------------
  Procedure Cancel_Invoice
  (
    i_Invoice_Id in number,
    o_Code       out varchar2,
    o_Msg        out varchar2
  );
  -------------------------------------------------------------------------------------------------
  Procedure Status_Invoice
  (
    i_Invoice_Id in number,
    o_Status     out varchar2,
    o_Code       out varchar2,
    o_Msg        out varchar2
  );
  -------------------------------------------------------------------------------------------------
  Procedure Status_Invoice_Verified
  (
    i_Invoice_Id in number,
    o_Code       out varchar2,
    o_Msg        out varchar2
  );
  -------------------------------------------------------------------------------------------------
  Procedure Check_Price
  (
    i_Invoice_Id in number,
    i_Appl_Date  in date,
    o_Code       out varchar2,
    o_Msg        out varchar2
  );
  -------------------------------------------------------------------------------------------------
  Function Print_Invoice_Varchar(i_Invoice_Id in number) return varchar2;
  -------------------------------------------------------------------------------------------------
  Function Qrcode_Base64
  (
    i_Text varchar2,
    i_Size varchar2
  ) return varchar2;

end Spc_Api;
/
create or replace package body Spc_Api is

  ---------------------------------------------------------------------------------------------------
  Procedure Order_Invoice
  (
    i_Filial_Code     in varchar2,
    i_First_Name_Ru   in varchar2,
    i_Last_Name_Ru    in varchar2,
    i_Patronymic_Ru   in varchar2,
    i_First_Name_Uz   in varchar2,
    i_Last_Name_Uz    in varchar2,
    i_Patronymic_Uz   in varchar2,
    i_Doc_Id          in number,
    i_Doc_Se          in varchar2,
    i_Doc_No          in varchar2,
    i_Birth_Date      in date,
    i_Sign_Birthdate  in number,
    i_Invoice_Type_Id in number,
    i_Parent_Id       in number := null,
    i_Payer_Type_Id   in number,
    i_Pay_Type_Id     in number,
    i_Order_No        in number,
    i_Order_Date      in date,
    i_Order_Time      in varchar2,
    o_Invoice_Id      out number,
    o_Code            out varchar2,
    o_Msg             out varchar2
  ) is
    --v_Count          number := 0;
    v_Msg            varchar2(2000);
    v_Invoice_Id     integer;
    v_Name           varchar2(100) := i_First_Name_Uz || ' ' || i_Last_Name_Uz || ' ' ||
                                      i_Patronymic_Uz;
    v_Invoice_Serial varchar2(20);
    v_Invoice_Summa  number(20);
    v_Invoice_Date   date;
    v_Filial_Code    varchar2(5);
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    if i_Invoice_Type_Id = 2 then
      o_Code := 1;
      o_Msg  := 'Доп. квитанция не создаётся';
      return;
    end if;
  
    if Length(i_Filial_Code) = 4 then
      v_Filial_Code := '0' || i_Filial_Code;
    else
      v_Filial_Code := i_Filial_Code;
    end if;
  
    /*if i_Parent_Id is not null then
      select count(*)
        into v_Count
        from Cp_Invoices t
       where t.Parent_Id = i_Parent_Id;
      if v_Count > 0 then
        o_Code := 1;
        o_Msg  := 'Уже сформирована доп. квитанция';
        return;
      end if;
    end if;*/
  
    Service_Methods.Request_Method_1(i_Filial_Code    => v_Filial_Code,
                                     i_Name           => v_Name,
                                     i_Payer_Type_Id  => i_Payer_Type_Id,
                                     i_Pay_Type_Id    => i_Pay_Type_Id,
                                     o_Invoice_Id     => v_Invoice_Id,
                                     o_Invoice_Serial => v_Invoice_Serial,
                                     o_Invoice_Summa  => v_Invoice_Summa,
                                     o_Invoice_Date   => v_Invoice_Date,
                                     o_Msg            => v_Msg);
  
    if v_Msg is not null then
      o_Code := 1;
      o_Msg  := v_Msg;
      return;
    end if;
  
    if v_Invoice_Id is null then
      o_Code := 1;
      o_Msg  := 'Billing: F.I.Sh. da taqiqlangan simvollar mavjud(Billingdan json javobi kelmadi)';
      return;
    end if;
  
    Cp_Api.Save_Invoice(i_Filial_Code     => v_Filial_Code,
                        i_First_Name_Ru   => i_First_Name_Ru,
                        i_Last_Name_Ru    => i_Last_Name_Ru,
                        i_Patronymic_Ru   => i_Patronymic_Ru,
                        i_First_Name_Uz   => i_First_Name_Uz,
                        i_Last_Name_Uz    => i_Last_Name_Uz,
                        i_Patronymic_Uz   => i_Patronymic_Uz,
                        i_Doc_Id          => i_Doc_Id,
                        i_Doc_Se          => i_Doc_Se,
                        i_Doc_No          => i_Doc_No,
                        i_Birth_Date      => i_Birth_Date,
                        i_Sign_Birthdate  => i_Sign_Birthdate,
                        i_Invoice_Type_Id => i_Invoice_Type_Id,
                        i_Parent_Id       => i_Parent_Id,
                        i_Payer_Type_Id   => i_Payer_Type_Id,
                        i_Pay_Type_Id     => i_Pay_Type_Id,
                        i_Order_No        => i_Order_No,
                        i_Order_Date      => i_Order_Date,
                        i_Order_Time      => i_Order_Time,
                        i_Invoice_Id      => v_Invoice_Id,
                        i_Invoice_Serial  => v_Invoice_Serial,
                        i_Invoice_Summa   => v_Invoice_Summa,
                        i_Invoice_Date    => v_Invoice_Date);
  
    o_Invoice_Id := v_Invoice_Id;
  
    o_Code := 0;
    o_Msg  := 'Success';
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm || '---' || i_Doc_Se || '---' || i_Doc_No);
      o_Code := 1;
      o_Msg  := sqlerrm;
  end Order_Invoice;

  -------------------------------------------------------------------------------------------------
  Procedure Change_Order_Invoice
  (
    i_Invoice_Id number,
    i_Order_No   number,
    i_Order_Date date,
    i_Order_Time varchar2,
    o_Code       out varchar2,
    o_Msg        out varchar2
  ) is
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    Cp_Kernel.Change_Order_Invoice(i_Invoice_Id => i_Invoice_Id,
                                   i_Order_No   => i_Order_No,
                                   i_Order_Date => i_Order_Date,
                                   i_Order_Time => i_Order_Time);
    o_Code := 0;
    o_Msg  := 'Success';
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      o_Code := 1;
      o_Msg  := sqlerrm;
  end;

  -------------------------------------------------------------------------------------------------
  Procedure Check_Invoice
  (
    i_Invoice_Id in number,
    o_Code       out varchar2,
    o_Msg        out varchar2
  ) is
    v_Rec Cp_Invoices%rowtype;
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    Cp_Util.Select_Invoice(i_Invoice_Id, v_Rec);
  
    o_Code := 0;
    o_Msg  := 'Success';
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      o_Code := 1;
      o_Msg  := sqlerrm;
  end Check_Invoice;

  -------------------------------------------------------------------------------------------------
  Procedure Cancel_Invoice
  (
    i_Invoice_Id in number,
    o_Code       out varchar2,
    o_Msg        out varchar2
  ) is
    v_Inv Cp_Invoices%rowtype;
    v_Msg varchar2(4000);
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    Cp_Util.Select_Invoice(i_Invoice_Id, v_Inv);
    if v_Inv.State_Id >= Cp_Util.c_Inv_s_Payed then
      o_Code := 1;
      o_Msg  := 'The invoice=' || v_Inv.Invoice_No || ' is paid';
      return;
    end if;
  
    if Substr(v_Inv.Invoice_No, 1, 2) in ('XA', 'PA', 'ZA') then
    
      Cp_Kernel.Set_Status_Invoice_His(i_Invoice_Id, Cp_Util.c_Inv_s_Canceled);
      o_Code := 0;
      o_Msg  := 'Success';
    
    else
      Service_Methods.Request_Method_5(i_Invoice_Id => i_Invoice_Id, o_Msg => v_Msg);
    
      if v_Msg = '1' then
        Cp_Kernel.Set_Status_Invoice(i_Invoice_Id, Cp_Util.c_Inv_s_Canceled);
        o_Code := 0;
        o_Msg  := 'Success';
      else
        o_Code := 1;
        o_Msg  := v_Msg;
      end if;
    end if;
  
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      o_Code := 1;
      o_Msg  := sqlerrm;
  end Cancel_Invoice;

  -------------------------------------------------------------------------------------------------
  Procedure Revoke_Invoice
  (
    i_Invoice_Id in number,
    o_Code       out varchar2,
    o_Msg        out varchar2
  ) is
    v_Inv Cp_Invoices%rowtype;
    v_Msg varchar2(4000);
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    Cp_Util.Select_Invoice(i_Invoice_Id, v_Inv);
    if v_Inv.State_Id <> Cp_Util.c_Inv_s_Canceled then
      o_Code := 1;
      o_Msg  := 'The invoice=' || v_Inv.Invoice_No || ' not canceled';
      return;
    end if;
  
    if Substr(v_Inv.Invoice_No, 1, 2) in ('XA', 'PA', 'ZA') then
    
      Cp_Kernel.Set_Status_Invoice_His(i_Invoice_Id, Cp_Util.c_Inv_s_Formed);
      o_Code := 0;
      o_Msg  := 'Success';
    
    else
    
      Service_Methods.Request_Method_6(i_Invoice_Id => i_Invoice_Id, o_Msg => v_Msg);
    
      if v_Msg = '1' then
        Cp_Kernel.Set_Status_Invoice(i_Invoice_Id, Cp_Util.c_Inv_s_Formed);
        o_Code := 0;
        o_Msg  := 'Success';
      else
        o_Code := 1;
        o_Msg  := v_Msg;
      end if;
    
    end if;
  
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      o_Code := 1;
      o_Msg  := sqlerrm;
  end Revoke_Invoice;

  -------------------------------------------------------------------------------------------------
  Procedure Status_Invoice
  (
    i_Invoice_Id in number,
    o_Status     out varchar2,
    o_Code       out varchar2,
    o_Msg        out varchar2
  ) is
    v_Rec           Cp_Invoices%rowtype;
    v_Invoice_State varchar2(20);
    v_Msg           varchar2(4000);
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    Cp_Util.Select_Invoice(i_Invoice_Id, v_Rec);
  
    if v_Rec.State_Id >= Cp_Util.c_Inv_s_Payed then
      o_Status := 'Paid';
      -- проверка доп.квитанции
      /*select count(*)
        into v_count
        from (select *
                from Cp_Invoices t
               where t.Parent_Id = v_Rec.Invoice_Id
                 and t.State_Id = Cp_Util.c_Inv_s_Formed
              union all
              select *
                from Cp_Invoices_his t
               where t.Parent_Id = v_Rec.Invoice_Id
                 and t.State_Id = Cp_Util.c_Inv_s_Formed);
      
      if v_Count > 0 then
        o_Status := 'Not paid';
      end if;*/
    
      o_Code := 0;
      o_Msg  := 'Success';
      return;
    
    else
    
      if Substr(v_Rec.Invoice_No, 1, 2) in ('XA', 'PA', 'ZA') then
      
        o_Status := 'Not paid';
        o_Code   := 0;
        o_Msg    := 'Success';
        return;
      else
      
        Service_Methods.Request_Method_3(v_Rec.Invoice_No, v_Msg, v_Invoice_State);
      
        o_Status := v_Invoice_State;
      
        if v_Msg = 'Успешно' then
          o_Code := 0;
          o_Msg  := 'Success';
          return;
        else
          o_Code := 1;
          o_Msg  := v_Msg;
          return;
        end if;
      
      end if;
    
    end if;
  
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      o_Code := 1;
      o_Msg  := sqlerrm;
  end;

  -------------------------------------------------------------------------------------------------
  Procedure Status_Invoice_Verified
  (
    i_Invoice_Id in number,
    o_Code       out varchar2,
    o_Msg        out varchar2
  ) is
    v_Rec         Cp_Invoices%rowtype;
    v_Count       number := 0;
    v_Add_Amounts number(20) := 0;
    v_Amount      number(20) := 0;
    v_Pay_Amounts number(20) := 0;
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    Cp_Util.Select_Invoice(i_Invoice_Id, v_Rec);
  
    if v_Rec.State_Id >= Cp_Util.c_Inv_s_Payed then
    
      select count(*)
        into v_Count
        from Ep_Payments t
       where Substr(t.Invoice_Id, -10) = v_Rec.Invoice_Id
         and t.State_Id = Ep_Util.c_Pay_s_Verified;
    
      if v_Count = 0 then
        o_Code := 1;
        o_Msg  := 'Not verified';
        return;
      end if;
    
      -- проверка доп.кв
      for n in (select *
                  from Cp_Invoices t
                 where t.Parent_Id = v_Rec.Invoice_Id)
      loop
        v_Add_Amounts := v_Add_Amounts + n.Amount;
      
        select Nvl(t.Pay_Amount, 0)
          into v_Amount
          from Ep_Payments t
         where Substr(t.Invoice_Id, -10) = n.Invoice_Id
           and t.State_Id = Ep_Util.c_Pay_s_Verified;
      
        v_Pay_Amounts := v_Pay_Amounts + v_Amount;
      end loop;
    
      if v_Add_Amounts = v_Pay_Amounts then
        o_Code := 0;
        o_Msg  := 'Verified';
      else
        o_Code := 1;
        o_Msg  := 'Not verified';
      end if;
    
    else
      o_Code := 1;
      o_Msg  := 'Not verified';
    end if;
  
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      o_Code := 1;
      o_Msg  := sqlerrm;
  end;

  -------------------------------------------------------------------------------------------------
  Procedure Check_Price
  (
    i_Invoice_Id in number,
    i_Appl_Date  in date,
    o_Code       out varchar2,
    o_Msg        out varchar2
  ) is
    v_Inv Cp_Invoices%rowtype;
    --v_Sett Adm_Settings_Of_Systems%rowtype;
    --v_Cur_Price  number(20) := 0;
    --v_Add_Amount number(20) := 0;
    --v_Count    number := 0;
    --v_Pay_Date date;
  begin
    Adm_Setup.Logon('spc', 'spc');
  
    Cp_Util.Select_Invoice(i_Invoice_Id, v_Inv);
    -- проверка тип квитанция
    if v_Inv.Invoice_Type_Id = 2 then
      o_Code := 1; -- нет
      o_Msg  := 'Нельзя подать ID доп.квитанция';
      return;
    end if;
    /*-- проверка есть доп.квитанция
    select count(*)
      into v_Count
      from Cp_Invoices t
     where t.Parent_Id = i_Invoice_Id;
    if v_Count > 0 then
      o_Code := 1; -- нет
      o_Msg  := 'Доп.квитанция уже создана';
      return;
    end if;
    
    Adm_Util.Select_Settings_Of_Systems(v_Sett);
    v_Pay_Date := Ep_Util.Get_Pay_Date_By_Invoice_Id(v_Inv.Invoice_Id);
    
    -- 3 дата до 01.08.2019
    if v_Inv.Invoice_Date < v_Sett.Min_Salary_Date and
       (v_Pay_Date is not null and v_Pay_Date < v_Sett.Min_Salary_Date) and
       (i_Appl_Date is not null and i_Appl_Date < v_Sett.Min_Salary_Date) then
      o_Code := 1;
    end if;
    -- 3 дата после 01.08.2019  
    if v_Inv.Invoice_Date >= v_Sett.Min_Salary_Date and
       (v_Pay_Date is not null and v_Pay_Date >= v_Sett.Min_Salary_Date) and
       (i_Appl_Date is not null and i_Appl_Date >= v_Sett.Min_Salary_Date) then
      o_Code := 1;
    end if;
    
    -- 21.06.2021 zayavka minimalka oldin yaratilgan lekin kvitansiya va to'lov minimalkadan keyin bo'gan
    -- Shuhrat
    
    if v_Inv.Invoice_Date >= v_Sett.Min_Salary_Date and
       (v_Pay_Date is not null and v_Pay_Date >= v_Sett.Min_Salary_Date) and
       (i_Appl_Date is not null and i_Appl_Date < v_Sett.Min_Salary_Date) then
      o_Code := 1;
    end if;
    
    if o_Code is null then
      o_Code := 0;
    end if;
    \*if v_Inv.State_Id = Cp_Util.c_Inv_s_Payed then
    
      Adm_Util.Select_Settings_Of_Systems(v_Sett);
      -- дата оплата
      if Ep_Util.Get_Pay_Date_By_Invoice_Id(v_Inv.Invoice_Id) >= v_Sett.Min_Salary_Date then
        o_Code := 1; -- нет
      else
        o_Code := 0;
      end if;
    
    else
    
      v_Cur_Price := Ref_Api.Price(v_Inv.Invoice_Type_Id, v_Inv.Payer_Type_Id, v_Inv.Pay_Type_Id);
    
      v_Add_Amount := Cp_Util.All_Child_Invoice_Amount(v_Inv.Invoice_Id);
    
      -- проверка суммы
      if v_Cur_Price <= (v_Inv.Amount + v_Add_Amount) then
        o_Code := 1; -- нет
      else
        o_Code := 0;
      end if;
    
    end if;*\
    
    if o_Code = 0 then
      o_Msg := 'Вы должны создать доп.квитанцию';
    else
      o_Msg := 'Не должны';
    end if;*/
  
    o_Code := 1;
    o_Msg  := 'Не должны';
  
  end;

  -------------------------------------------------------------------------------------------------
  Function Print_Invoice_Varchar(i_Invoice_Id in number) return varchar2 is
  begin
    return Rep_Cp.Draw_Invoice(i_Invoice_Id);
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      return null;
  end;

  -------------------------------------------------------------------------------------------------
  Function To_Base64(t in varchar2) return varchar2 is
  begin
    return Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Encode(Utl_Raw.Cast_To_Raw(t)));
  end To_Base64;

  -------------------------------------------------------------------------------------------------
  Function Qrcode_Base64
  (
    i_Text varchar2,
    i_Size varchar2
  ) return varchar2 is
  begin
    return To_Base64(Utl_Raw.Cast_To_Varchar2(Pf_Qrcode.Generate_Qrcode(i_Text, i_Size)));
  exception
    when others then
      Sql_Util.Trace_Text('SPC', sqlerrm);
      return null;
  end;

end Spc_Api;
/
