create or replace type Array_Varchar2_t Force under Object_t
(
-- Author  : AZAMAT
-- Created : 05.05.2016 15:23:20
-- Purpose : Wrapper object of array_varchar2
  v Array_Varchar2,
------------------------------------------------------------------------------------------------------
  constructor Function Array_Varchar2_t
  (
    self in out nocopy Array_Varchar2_t,
    v    Array_Varchar2
  ) return self as result,
------------------------------------------------------------------------------------------------------
  overriding member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
  overriding member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
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
  overriding member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
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
  overriding member Function Is_Array_Varchar2 return boolean,
------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2,
  overriding member Function json_Long_String return Long_String,
  overriding member Function Json_Clob return clob
------------------------------------------------------------------------------------------------------

)
/
create or replace type body Array_Varchar2_t is
  ------------------------------------------------------------------------------------------------------
  constructor Function Array_Varchar2_t
  (
    self in out nocopy Array_Varchar2_t,
    v    Array_Varchar2
  ) return self as result is
  begin
    Self.Type := 'ARRAY_VARCHAR2';
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
      return v(1);
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
      return Object_t.Format_Number(v(1), i_Format, i_Nlsparam);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    if v.Count = 1 then
      return Object_t.Format_Date(v(1), i_Format, i_Nlsparam);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    if v.Count = 1 then
      return Object_t.Format_Timestamp(v(1), i_Format, i_Nlsparam);
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
    return v;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    return Object_t.Format_Array_Number(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    return Object_t.Format_Array_Date(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    return Object_t.Format_Array_Timestamp(v, i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Array_Varchar2 return boolean is
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
        result := result || '"' || Object_t.Json_Escape(v(i)) || '"';
        if i <> v.Count then
          result := result || ',';
        end if;
      end loop;
    end if;
    result := result || ']';
    return result;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function json_Long_String return Long_String is
    result Long_String := Long_String('[');
  begin
    if v is not null then
      for i in 1 .. v.Count
      loop
        if i = 1 then
          Result.Append('"' || Object_t.Json_Escape(v(i)) || '"');
        else
          Result.Append(',"' || Object_t.Json_Escape(v(i)) || '"');
        end if;
      end loop;
    end if;
    Result.Append(']');
    return result;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Clob return clob is
    --result clob;
  begin
    /*result := '[';
    if v is not null then
      for i in 1 .. v.Count
      loop
        result := result || '"' || Object_t.Json_Escape(v(i)) || '"';
        if i <> v.Count then
          result := result || ',';
        end if;
      end loop;
    end if;
    result := result || ']';
    return result;*/
    return Self.json_Long_String().to_clob;
  end;
end;
/
