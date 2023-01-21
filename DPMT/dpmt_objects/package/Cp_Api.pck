create or replace package Cp_Api is

  -- Author  : Nurbek
  -- Created : 20.10.2018 15:51:23
  -- Purpose : 

  ---------------------------------------------------------------------------------------------------
  Procedure Save_Invoice
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
    i_Invoice_Id      in number,
    i_Invoice_Serial  varchar2,
    i_Invoice_Summa   number,
    i_Invoice_Date    date
  );
  -----------------------------------------------------------------------------------------------------
  Function Invoice_Model(Request Hashtable) return varchar2;
  -----------------------------------------------------------------------------------------------------
  Procedure Edit_Invoice(Request Hashtable);
  -----------------------------------------------------------------------------------------------------
  Procedure Manual_Invoice(Request Hashtable);
  -----------------------------------------------------------------------------------------------------
  Function Manual_Model(Request Hashtable) return varchar2;

end Cp_Api;
/
create or replace package body Cp_Api is

  -----------------------------------------------------------------------------------------------------
  Procedure Save_Invoice
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
    i_Invoice_Id      in number,
    i_Invoice_Serial  varchar2,
    i_Invoice_Summa   number,
    i_Invoice_Date    date
  ) is
    v_Rec Cp_Invoices%rowtype;
  begin
    v_Rec.Filial_Code     := Lpad(i_Filial_Code, 5, 0);
    v_Rec.First_Name      := s_Nsi_Nvt(Upper(i_First_Name_Ru), Upper(i_First_Name_Uz));
    v_Rec.Last_Name       := s_Nsi_Nvt(Upper(i_Last_Name_Ru), Upper(i_Last_Name_Uz));
    v_Rec.Patronymic      := s_Nsi_Nvt(Upper(i_Patronymic_Ru), Upper(i_Patronymic_Uz));
    v_Rec.Birth_Date      := i_Birth_Date;
    v_Rec.Sign_Birthdate  := i_Sign_Birthdate;
    v_Rec.Doc_Id          := i_Doc_Id;
    v_Rec.Doc_Se          := i_Doc_Se;
    v_Rec.Doc_No          := i_Doc_No;
    v_Rec.Invoice_Type_Id := i_Invoice_Type_Id;
    v_Rec.Parent_Id       := i_Parent_Id;
    v_Rec.Invoice_No      := i_Invoice_Serial;
    v_Rec.Invoice_Date    := i_Invoice_Date;
    v_Rec.Payer_Type_Id   := i_Payer_Type_Id;
    v_Rec.Pay_Type_Id     := i_Pay_Type_Id;
    v_Rec.Amount          := i_Invoice_Summa * 100;
    v_Rec.Order_No        := i_Order_No;
    v_Rec.Order_Date      := i_Order_Date;
    v_Rec.Order_Time      := i_Order_Time;
    v_Rec.Invoice_Id      := i_Invoice_Id;
  
    Cp_Kernel.Save_Invoice(v_Rec);
  
  end;

  -----------------------------------------------------------------------------------------------------
  Function Invoice_Model(Request Hashtable) return varchar2 is
    v_Form j_Hash := j_Hash();
    v_Data j_Hash := j_Hash();
    v_Rec  Cp_Invoices%rowtype;
  begin
    v_Rec.Invoice_Id := Request.Get_Number('invoiceId');
    Cp_Util.Select_Invoice(v_Rec.Invoice_Id, v_Rec);
  
    v_Form.Put('invoice_id', v_Rec.Invoice_Id);
    v_Form.Put('last_name', Cur_Nls(v_Rec.Last_Name, 2));
    v_Form.Put('first_name', Cur_Nls(v_Rec.First_Name, 2));
    v_Form.Put('patronymic', Cur_Nls(v_Rec.Patronymic, 2));
    v_Form.Put('birth_date', v_Rec.Birth_Date);
    v_Form.Put('sign_birthdate', v_Rec.Sign_Birthdate);
  
    v_Data.Put('fm', v_Form);
    return v_Data.To_String();
  end;

  -----------------------------------------------------------------------------------------------------
  Procedure Edit_Invoice(Request Hashtable) is
  begin
    Cp_Kernel.Edit_Invoice(i_Invoice_Id     => Request.Get_Number('invoice_id'),
                           i_Last_Name      => Request.Get_Varchar2('last_name'),
                           i_First_Name     => Request.Get_Varchar2('first_name'),
                           i_Patronymic     => Request.Get_Varchar2('patronymic'),
                           i_Birth_Date     => to_date(Request.Get_Varchar2('birth_date'),
                                                       'dd.mm.yyyy'),
                           i_Sign_Birthdate => Request.Get_Optional_Number('sign_birthdate'));
  end;

  -----------------------------------------------------------------------------------------------------
  Procedure Manual_Invoice(Request Hashtable) is
    v_Rec Cp_Invoices%rowtype;
  begin
    v_Rec.Invoice_Id      := Request.Get_Optional_Number('invoice_id');
    v_Rec.Last_Name       := s_Nsi_Nvt(Upper(Request.Get_Varchar2('payer_name')),
                                       Upper(Request.Get_Varchar2('payer_name')));
    v_Rec.First_Name      := s_Nsi_Nvt(Upper(Request.Get_Varchar2('doc_number')),
                                       Upper(Request.Get_Varchar2('doc_number')));
    v_Rec.Patronymic      := s_Nsi_Nvt(' ', ' ');
    v_Rec.Birth_Date      := Request.Get_Date('doc_date', 'dd.mm.yyyy');
    v_Rec.Filial_Code     := Adm_Setup.Filial_Code;
    v_Rec.Invoice_Type_Id := 1; -- основной
    v_Rec.Invoice_Date    := Trunc(sysdate);
    v_Rec.Payer_Type_Id   := 5; -- организаци§
    v_Rec.Pay_Type_Id     := Request.Get_Number('pay_type_id'); -- загран паспорт
    v_Rec.Invoice_No      := Ref_Util.Payer_Type_Resident(v_Rec.Payer_Type_Id); -- ZA
    v_Rec.Sign_Birthdate  := 0;
    v_Rec.Doc_Id          := 1;
    v_Rec.Doc_Se          := ' ';
    v_Rec.Doc_No          := ' ';
    v_Rec.Amount          := (Request.Get_Number('amount')) * 100;
    v_Rec.Order_No        := 1;
    v_Rec.Order_Date      := v_Rec.Invoice_Date;
    v_Rec.Order_Time      := '10:00';
  
    Em.Raise_Error_If(v_Rec.Amount <= 0,
                      'CP',
                      'Чумма квитанци§ должно быть больше 0');
    if v_Rec.Invoice_Id is null then
      Cp_Kernel.Save_Invoice(v_Rec);
    else
      Cp_Kernel.Manual_Edit_Invoice(v_Rec);
    end if;
  end;

  -----------------------------------------------------------------------------------------------------
  Function Manual_Model(Request Hashtable) return varchar2 is
    v_Form j_Hash := j_Hash();
    v_Data j_Hash := j_Hash();
    v_Rec  Cp_Invoices%rowtype;
  begin
    v_Rec.Invoice_Id := Request.Get_Number('invoiceId');
    Cp_Util.Select_Invoice(v_Rec.Invoice_Id, v_Rec);
  
    v_Form.Put('invoice_id', v_Rec.Invoice_Id);
    v_Form.Put('payer_name', Cur_Nls(v_Rec.Last_Name, 2));
    v_Form.Put('doc_number', Cur_Nls(v_Rec.First_Name, 2));
    v_Form.Put('pay_type_id', v_Rec.Pay_Type_Id);
    v_Form.Put('doc_date', v_Rec.Birth_Date);
    v_Form.Put('amount', v_Rec.Amount / 100);
  
    v_Data.Put('fm', v_Form);
    return v_Data.To_String();
  end;

end Cp_Api;
/
