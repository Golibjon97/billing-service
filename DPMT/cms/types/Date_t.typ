create or replace type Date_t Force under Object_t
(
-- Author  : AZAMAT
-- Created : 05.05.2016 15:03:50
-- Purpose : Wrapper object of date

  v date,
------------------------------------------------------------------------------------------------------
  constructor Function Date_t
  (
    self in out nocopy Date_t,
    v    date
  ) return self as result,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
  overriding member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
  overriding member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
  overriding member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
  overriding member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
  overriding member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
------------------------------------------------------------------------------------------------------
  overriding member Function Is_Date return boolean,
------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2,
  overriding member Function Json_Clob return clob,
  overriding member Function json_Long_String return Long_String
  
)
/
create or replace type body Date_t is

  ------------------------------------------------------------------------------------------------------
  constructor Function Date_t
  (
    self in out nocopy Date_t,
    v    date
  ) return self as result is
  begin
    Self.Type := 'DATE';
    Self.v    := v;
    return;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    return Object_t.Format_Date(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    return v;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    return cast(v as timestamp);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    return Array_Varchar2(Object_t.Format_Date(v, i_Format, i_Nlsparam));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    return Array_Date(v);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    return Array_Timestamp(cast(v as timestamp));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Date return boolean is
  begin
    return true;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2 is
  begin
    return '"' || Object_t.Format_Date(Self.v) || '"';
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Clob return clob is
  begin
    return '"' || Object_t.Format_Date(Self.v) || '"';
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function json_Long_String return Long_String is
  begin
    return Long_String('"' || Object_t.Format_Date(Self.v) || '"');
  end;
end;
/
