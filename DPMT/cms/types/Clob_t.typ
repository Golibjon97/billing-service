create or replace type Clob_t under Object_t
(
-- Author  : AZAMAT
-- Created : 23.06.2020 13:11:18
-- Purpose : 

  v clob,
------------------------------------------------------------------------------------------------------
  constructor Function Clob_t
  (
    self in out nocopy Clob_t,
    v    clob
  ) return self as result,

------------------------------------------------------------------------------------------------------
  overriding member Function Is_Clob return boolean,
------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2,
  overriding member Function Json_Clob return clob,
------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String
)
/
create or replace type body Clob_t is
  ------------------------------------------------------------------------------------------------------
  constructor Function Clob_t
  (
    self in out nocopy Clob_t,
    v    clob
  ) return self as result is
  begin
    Self.Type := 'CLOB';
    Self.v    := v;
    return;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Clob return boolean is
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
