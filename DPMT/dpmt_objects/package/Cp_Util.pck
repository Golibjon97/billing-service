create or replace package Cp_Util is

  -- Author  : Nurbek
  -- Created : 20.10.2018 15:00:39
  -- Purpose : 

  c_Inv_s_Formed constant number := 1; -- Сформирован
  --  c_Inv_s_Attached constant number := 2; -- Закреплен
  c_Inv_s_Canceled constant number := 3; -- Отменен
  c_Inv_s_Payed    constant number := 4; -- Оплачено
  c_Inv_s_Closed   constant number := 5; -- Закрыт
  -----------------------------------------------------------------------------------------------------
  Procedure Select_Invoice
  (
    i_Invoice_Id number,
    o_Rec        out Cp_Invoices%rowtype
  );
  --------------------------------------------------------------------------------------------------------
  Function Full_Name(i_Invoice_Id number) return varchar2;
  --------------------------------------------------------------------------------------------------------
  Function Invoice_Date(i_Invoice_Id number) return date;
  --------------------------------------------------------------------------------------------------------
  Function Invoice_Number(i_Invoice_Id number) return varchar2;
  --------------------------------------------------------------------------------------------------------
  Function Invoice_State_Id(i_Invoice_Id number) return number;
  --------------------------------------------------------------------------------------------------------
  Function Invoice_Payer_Type_Id(i_Invoice_Id number) return number;
  -----------------------------------------------------------------------------------------------------
  Function State_Name(i_State_Id number) return varchar2;
  -----------------------------------------------------------------------------------------------------
  Function State_Icon(i_State_Id number) return varchar2;
  -----------------------------------------------------------------------------------------------------
  Function All_Child_Invoice_Amount(i_Parent_Id number) return number;

end Cp_Util;
/
create or replace package body Cp_Util is

  -----------------------------------------------------------------------------------------------------
  Procedure Select_Invoice
  (
    i_Invoice_Id number,
    o_Rec        out Cp_Invoices%rowtype
  ) is
  begin
    select *
      into o_Rec
      from Cp_Invoices t
     where t.Invoice_Id = i_Invoice_Id;
  exception
    when No_Data_Found then
      Em.Raise_No_Data_Found('CP',
                             'Квитанция № $1 не найден',
                             Array_Varchar2(i_Invoice_Id));
  end;

  --------------------------------------------------------------------------------------------------------
  Function Full_Name(i_Invoice_Id number) return varchar2 is
    v_Rec Cp_Invoices%rowtype;
  begin
    Select_Invoice(i_Invoice_Id, v_Rec);
    return Cur_Nls(v_Rec.Last_Name, 2) || ' ' || Cur_Nls(v_Rec.First_Name, 2) || ' ' || Cur_Nls(v_Rec.Patronymic,
                                                                                                2);
  end;

  --------------------------------------------------------------------------------------------------------
  Function Invoice_Date(i_Invoice_Id number) return date is
    v_Rec Cp_Invoices%rowtype;
  begin
    Select_Invoice(i_Invoice_Id, v_Rec);
    return v_Rec.Invoice_Date;
  end;

  --------------------------------------------------------------------------------------------------------
  Function Invoice_Number(i_Invoice_Id number) return varchar2 is
    v_Rec Cp_Invoices%rowtype;
  begin
    Select_Invoice(i_Invoice_Id, v_Rec);
    return v_Rec.Invoice_No;
  end;

  --------------------------------------------------------------------------------------------------------
  Function Invoice_State_Id(i_Invoice_Id number) return number is
    v_Rec Cp_Invoices%rowtype;
  begin
    Select_Invoice(i_Invoice_Id, v_Rec);
    return v_Rec.State_Id;
  end;

  --------------------------------------------------------------------------------------------------------
  Function Invoice_Payer_Type_Id(i_Invoice_Id number) return number is
    v_Rec Cp_Invoices%rowtype;
  begin
    Select_Invoice(i_Invoice_Id, v_Rec);
    return v_Rec.Payer_Type_Id;
  end;

  -----------------------------------------------------------------------------------------------------
  Function State_Name(i_State_Id number) return varchar2 is
    v_Result Cp_Invoice_States.Name%type;
  begin
    select t.Name
      into v_Result
      from Cp_Invoice_States t
     where t.State_Id = i_State_Id;
    return Cur_Nls(v_Result);
  end;

  -----------------------------------------------------------------------------------------------------
  Function State_Icon(i_State_Id number) return varchar2 is
    v_Result Cp_Invoice_States.Icon%type;
  begin
    select t.Icon
      into v_Result
      from Cp_Invoice_States t
     where t.State_Id = i_State_Id;
    return v_Result;
  end;

  -----------------------------------------------------------------------------------------------------
  Function All_Child_Invoice_Amount(i_Parent_Id number) return number is
    v_Result number(20) := 0;
  begin
    select Nvl(sum(t.Amount), 0)
      into v_Result
      from Cp_Invoices t
     where t.Parent_Id = i_Parent_Id
       and t.State_Id >= Cp_Util.c_Inv_s_Payed;
    return v_Result;
  end;

end Cp_Util;
/
