create or replace package Cp_Kernel is

  -- Author  : Nurbek
  -- Created : 20.10.2018 15:51:43
  -- Purpose : 

  ---------------------------------------------------------------------------------------------------
  Procedure Save_Invoice(Io_Rec in out nocopy Cp_Invoices%rowtype);
  ---------------------------------------------------------------------------------------------------
  Procedure Edit_Invoice
  (
    i_Invoice_Id     number,
    i_Last_Name      varchar2,
    i_First_Name     varchar2,
    i_Patronymic     varchar2 := null,
    i_Birth_Date     date,
    i_Sign_Birthdate number := null
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Set_Status_Invoice
  (
    i_Invoice_Id number,
    i_State_Id   number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Set_Status_Invoice_His
  (
    i_Invoice_Id number,
    i_State_Id   number
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Restore_Status_Invoice(i_Invoice_Id number);
  ---------------------------------------------------------------------------------------------------
  Procedure Change_Order_Invoice
  (
    i_Invoice_Id number,
    i_Order_No   number,
    i_Order_Date date,
    i_Order_Time varchar2
  );
  ---------------------------------------------------------------------------------------------------
  Procedure Manual_Edit_Invoice(i_Rec Cp_Invoices%rowtype);

end Cp_Kernel;
/
create or replace package body Cp_Kernel is

  ---------------------------------------------------------------------------------------------------
  Procedure Save_Invoice(Io_Rec in out nocopy Cp_Invoices%rowtype) is
  begin
    Io_Rec.State_Id    := 1;
    Io_Rec.Created_On  := sysdate;
    Io_Rec.Created_By  := Adm_Setup.User_Id;
    Io_Rec.Modified_On := sysdate;
    Io_Rec.Modified_By := Adm_Setup.User_Id;
  
    insert into Cp_Invoices
    values Io_Rec;
  
    --commit;
  
  exception
    when others then
      raise;
  end;

  Procedure Edit_Invoice
  (
    i_Invoice_Id     number,
    i_Last_Name      varchar2,
    i_First_Name     varchar2,
    i_Patronymic     varchar2 := null,
    i_Birth_Date     date,
    i_Sign_Birthdate number := null
  ) is
    v_Cur_Payer_Type number;
    v_Payer_Type     number;
    v_Birth_Date     date := i_Birth_Date;
    v_Sign_Birthdate number;
  begin
    v_Cur_Payer_Type := Cp_Util.Invoice_Payer_Type_Id(i_Invoice_Id);
  
    -- проверка, если не детдомский  
    if v_Cur_Payer_Type <> 4 then
    
      if Trunc((Trunc(sysdate) - i_Birth_Date) / 365) < 16 then
        v_Payer_Type := 2;
      else
        v_Payer_Type := 1;
      end if;
      Em.Raise_Error_If(v_Payer_Type <> v_Cur_Payer_Type,
                        'CP',
                        'Тип плательщика не совпадает!');
    end if;
  
    if i_Sign_Birthdate = 1 then
      v_Birth_Date     := Trunc(v_Birth_Date, 'YEAR');
      v_Sign_Birthdate := 1;
    else
      v_Sign_Birthdate := 0;
    end if;
  
    Ref_Kernel.Before_Editing('Cp_Invoices', i_Invoice_Id);
  
    update Cp_Invoices t
       set t.Last_Name      = s_Nsi_Nvt(Cur_Nls(t.Last_Name), Upper(i_Last_Name)),
           t.First_Name     = s_Nsi_Nvt(Cur_Nls(t.First_Name), Upper(i_First_Name)),
           t.Patronymic     = s_Nsi_Nvt(Cur_Nls(t.Patronymic), Upper(i_Patronymic)),
           t.Birth_Date     = v_Birth_Date,
           t.Sign_Birthdate = v_Sign_Birthdate,
           t.Modified_On    = sysdate,
           t.Modified_By    = Adm_Setup.User_Id
     where t.Invoice_Id = i_Invoice_Id;
  
    Ref_Kernel.After_Editing('Cp_Invoices', i_Invoice_Id);
  
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Set_Status_Invoice
  (
    i_Invoice_Id number,
    i_State_Id   number
  ) is
  begin
    if Cp_Util.Invoice_State_Id(i_Invoice_Id) <> 1 then
      Em.Raise_Error('CP', 'Данную квитанцию отменить нельзя');
    end if;
  
    update Cp_Invoices t
       set t.State_Id    = i_State_Id,
           t.Modified_On = sysdate,
           t.Modified_By = Adm_Setup.User_Id
     where t.Invoice_Id = i_Invoice_Id;
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Set_Status_Invoice_His
  (
    i_Invoice_Id number,
    i_State_Id   number
  ) is
  begin
    if Cp_Util.Invoice_State_Id(i_Invoice_Id) <> 1 then
      Em.Raise_Error('CP', 'Данную квитанцию отменить нельзя');
    end if;
  
    update Cp_Invoices_His t
       set t.State_Id    = i_State_Id,
           t.Modified_On = sysdate,
           t.Modified_By = Adm_Setup.User_Id
     where t.Invoice_Id = i_Invoice_Id;
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Restore_Status_Invoice(i_Invoice_Id number) is
  begin
    update Cp_Invoices t
       set t.State_Id    = Cp_Util.c_Inv_s_Formed,
           t.Modified_On = sysdate,
           t.Modified_By = Adm_Setup.User_Id
     where t.Invoice_Id = i_Invoice_Id;
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Change_Order_Invoice
  (
    i_Invoice_Id number,
    i_Order_No   number,
    i_Order_Date date,
    i_Order_Time varchar2
  ) is
  begin
    update Cp_Invoices t
       set t.Order_No    = i_Order_No,
           t.Order_Date  = i_Order_Date,
           t.Order_Time  = i_Order_Time,
           t.Modified_On = sysdate,
           t.Modified_By = Adm_Setup.User_Id
     where t.Invoice_Id = i_Invoice_Id;
  end;

  ---------------------------------------------------------------------------------------------------
  Procedure Manual_Edit_Invoice(i_Rec Cp_Invoices%rowtype) is
  begin
    Ref_Kernel.Before_Editing('Cp_Invoices', i_Rec.Invoice_Id);
  
    update Cp_Invoices t
       set t.Last_Name   = i_Rec.Last_Name,
           t.First_Name  = i_Rec.First_Name,
           t.Birth_Date  = i_Rec.Birth_Date,
           t.Pay_Type_Id = i_Rec.Pay_Type_Id,
           t.Amount      = i_Rec.Amount,
           t.Modified_On = sysdate,
           t.Modified_By = Adm_Setup.User_Id
     where t.Invoice_Id = i_Rec.Invoice_Id;
  
    Ref_Kernel.After_Editing('Cp_Invoices', i_Rec.Invoice_Id);
  end;

end Cp_Kernel;
/
