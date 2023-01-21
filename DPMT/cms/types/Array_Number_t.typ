create or replace type Array_Number_t Force under Object_t
(
-- Author  : AZAMAT
-- Created : 05.05.2016 15:50:35
-- Purpose : Wrapper object of array_number

  v Array_Number,
------------------------------------------------------------------------------------------------------
  constructor Function Array_Number_t
  (
    self in out nocopy Array_Number_t,
    v    Array_Number
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
  overriding member Function Is_Array_Number return boolean,
------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2,
------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String,
  overriding member Function Json_Clob return clob
)
/
create or replace type body Array_Number_t is
  ------------------------------------------------------------------------------------------------------
  constructor Function Array_Number_t
  (
    self in out nocopy Array_Number_t,
    v    Array_Number
  ) return self as result is
  begin
    Self.Type := 'ARRAY_NUMBER';
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
    if v.Count = 1 then
      return Object_t.Format_Number(v(1), i_Format, i_Nlsparam);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    if v.Count = 1 then
      return v(1);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    return Object_t.Format_Array_Varchar2(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    return v;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Array_Number return boolean is
  begin
    return true;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2 is
    result varchar2(32767);
  begin
    result := '[';
    if v is not null then
      for i in 1 .. v.Count
      loop
        result := result || Object_t.Format_Number(v(i));
        if i <> v.Count then
          result := result || ',';
        end if;
      end loop;
    end if;
    result := result || ']';
    return result;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String is
    result Long_String := Long_String('[');
  begin
    if v is not null then
      for i in 1 .. v.Count
      loop
        if i = 1 then
          Result.Append(Object_t.Format_Number(v(i)));
        else
          Result.Append(',' || Object_t.Format_Number(v(i)));
        
        end if;
      end loop;
    end if;
    Result.Append(']');
    return result;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Clob return clob is
    -- result clob;
  begin
    /* result := '[';
    if v is not null then
      for i in 1 .. v.Count
      loop
        result := result || Object_t.Format_Number(v(i));
        if i <> v.Count then
          result := result || ',';
        end if;
      end loop;
    end if;
    result := result || ']';
    return result;*/
    return Self.Json_Long_String().To_Clob();
  end;
end;
/
