create or replace type Varchar2_t Force under Object_t
(
-- Author  : AZAMAT
-- Created : 05.05.2016 11:26:53
-- Purpose : Wrapper object of varchar2
  v varchar2(32767),
------------------------------------------------------------------------------------------------------
  constructor Function Varchar2_t
  (
    self in out nocopy Varchar2_t,
    v    varchar2
  ) return self as result,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
------------------------------------------------------------------------------------------------------
  overriding member Function Is_Varchar2 return boolean,
------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2,
  overriding member Function Json_Clob return clob,
------------------------------------------------------------------------------------------------------
  overriding member Function json_Long_String return Long_String

)
/
create or replace type body Varchar2_t is

  ------------------------------------------------------------------------------------------------------
  constructor Function Varchar2_t
  (
    self in out nocopy Varchar2_t,
    v    varchar2
  ) return self as result is
  begin
    Self.Type := 'VARCHAR2';
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
    return v;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    return Object_t.Format_Number(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    return Object_t.Format_Date(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    return Object_t.Format_Timestamp(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    return Array_Varchar2(v);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    return Array_Number(Object_t.Format_Number(v, i_Format, i_Nlsparam));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    return Array_Date(Object_t.Format_Date(v, i_Format, i_Nlsparam));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    return Array_Timestamp(Object_t.Format_Timestamp(v, i_Format, i_Nlsparam));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Varchar2 return boolean is
  begin
    return true;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2 is
  begin
    return '"' || Object_t.Json_Escape(v) || '"';
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Clob return clob is
  begin
    return '"' || Object_t.Json_Escape(v) || '"';
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String is
  begin
    return Long_String('"' || Object_t.Json_Escape(v) || '"');
  end;
end;
/
