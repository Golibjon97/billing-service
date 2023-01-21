create or replace type String_Object_T force under Object_t
(
-- Author  : Шаюсупов Ш.А.
-- Created : 26.11.2020 16:52:43
-- Purpose : Wrapper object of Long_String

  --
  v Long_String,

------------------------------------------------------------------------------------------------------
  constructor Function String_Object_T
  (
    self in out nocopy String_Object_T,
    v    Long_String
  ) return self as result,
------------------------------------------------------------------------------------------------------
  constructor Function String_Object_T
  (
    self in out nocopy String_Object_T,
    v    varchar2
  ) return self as result,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
  ------------------------------------------------------------------------------------------------------
  overriding member  Function As_Long_String
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Long_String,
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
  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Long_String return boolean,
   overriding member Function Json return varchar2,
   overriding member Function Json_Clob return clob,
------------------------------------------------------------------------------------------------------
  overriding member Function json_Long_String return Long_String

)
/
create or replace type body String_Object_T is

  ------------------------------------------------------------------------------------------------------
  constructor Function String_Object_T
  (
    self in out nocopy String_Object_T,
    v    Long_String
  ) return self as result is
  begin
    Self.Type := 'LONG_STRING';
    Self.v    := v;
    return;
  end;

  ------------------------------------------------------------------------------------------------------
  constructor Function String_Object_T
  (
    self in out nocopy String_Object_T,
    v    varchar2
  ) return self as result is
  begin
    Self.Type := 'LONG_STRING';
    Self.v    := Long_String(v);
    return;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    return v.To_String();
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Long_String
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Long_String is
  begin
    return Self.v;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    return Object_t.Format_Number(v.To_String(), i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    return Object_t.Format_Date(v.To_String(), i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    return Object_t.Format_Timestamp(v.To_String(), i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    return Array_Varchar2(v.To_String());
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    return Array_Number(Object_t.Format_Number(v.To_String(), i_Format, i_Nlsparam));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    return Array_Date(Object_t.Format_Date(v.To_String(), i_Format, i_Nlsparam));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    return Array_Timestamp(Object_t.Format_Timestamp(v.To_String(), i_Format, i_Nlsparam));
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Varchar2 return boolean is
  begin
    return true;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Long_String return boolean is
  begin
    return true;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2 is
  begin
    return '"' || Object_t.Json_Escape(v.To_String()) || '"';
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Clob return clob is
  begin
    if (v.Get_Length() <= 32767) then
      return Self.Json();
    else
      return Self.Json_Long_String().To_Clob();
    end if;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String
  is
    v_Result  Long_String;
  begin
    --
    if (v.Get_Length() <= 32767) then
      return Long_String(Self.Json());
    end if;
    --
    v_Result := Long_String('"');
    --
    v_Result.Append(v.Escape());
    v_Result.Append('"');
    --
    return v_Result;
  end;

end;
/
