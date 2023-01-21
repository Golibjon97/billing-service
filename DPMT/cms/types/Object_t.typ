create or replace type Object_t force as object
(
-- Author  : AZAMAT
-- Created : 05.05.2016 11:08:16
-- Purpose : This is parent object of any objects

-- Attributes
  type varchar2(30),
------------------------------------------------------------------------------------------------------
  final static Function Json_Escape(v varchar2) return varchar2,
------------------------------------------------------------------------------------------------------
  final static Function Json_Escape(v clob) return clob,
----------------------------------------------------------------------------------------------------
  final static Function Format_Number
  (
    i_Val      number,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
----------------------------------------------------------------------------------------------------
  final static Function Format_Number
  (
    i_Val      varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
----------------------------------------------------------------------------------------------------
  final static Function Format_Date
  (
    i_Val      date,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
----------------------------------------------------------------------------------------------------
  final static Function Format_Date
  (
    i_Val      varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
----------------------------------------------------------------------------------------------------
  final static Function Format_Timestamp
  (
    i_Val      timestamp,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
----------------------------------------------------------------------------------------------------
  final static Function Format_Timestamp
  (
    i_Val      varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Varchar2
  (
    i_Val      Array_Number,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Varchar2
  (
    i_Val      Array_Date,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Varchar2
  (
    i_Val      Array_Timestamp,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Number
  (
    i_Val      Array_Varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Date
  (
    i_Val      Array_Varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Date(i_Val Array_Timestamp) return Array_Date,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Timestamp
  (
    i_Val      Array_Varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Timestamp(i_Val Array_Date) return Array_Timestamp,
------------------------------------------------------------------------------------------------------
  member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,

-----------------------------------------------------------------------------------------------------
  member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
------------------------------------------------------------------------------------------------------
  member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
------------------------------------------------------------------------------------------------------
  member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
------------------------------------------------------------------------------------------------------
  member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
------------------------------------------------------------------------------------------------------
  member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
------------------------------------------------------------------------------------------------------
  member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
------------------------------------------------------------------------------------------------------
  member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
-----------------------------------------------------------------------------------------------------
  member Function As_Long_String
  
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Long_String,
------------------------------------------------------------------------------------------------------
  member Function Is_Varchar2 return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Number return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Date return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Timestamp return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Varchar2 return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Number return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Date return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Timestamp return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Arraylist return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Hashmap return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Clob return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Blob return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Long_String return boolean,
------------------------------------------------------------------------------------------------------
  not instantiable member Function Json return varchar2,
------------------------------------------------------------------------------------------------------
  not instantiable member Function Json_Clob return clob,
------------------------------------------------------------------------------------------------------
  not instantiable member Function Json_Long_String return Long_String
)
not instantiable not final;
/
create or replace type body Object_t is

  ------------------------------------------------------------------------------------------------------
  final static Function Json_Escape(v varchar2) return varchar2 is
  begin
    return replace(replace(replace(replace(replace(replace(replace(replace(v, '\', '\\'),
                                                                   '/',
                                                                   '\/'),
                                                           '"',
                                                           '\"'),
                                                   Chr(8),
                                                   '\b'),
                                           Chr(9),
                                           '\t'),
                                   Chr(10),
                                   '\r'),
                           Chr(12),
                           '\f'),
                   Chr(13),
                   '\n');
  end;
  ------------------------------------------------------------------------------------------------------
  final static Function Json_Escape(v clob) return clob is
  begin
    return replace(replace(replace(replace(replace(replace(replace(replace(v, '\', '\\'),
                                                                   '/',
                                                                   '\/'),
                                                           '"',
                                                           '\"'),
                                                   Chr(8),
                                                   '\b'),
                                           Chr(9),
                                           '\t'),
                                   Chr(10),
                                   '\r'),
                           Chr(12),
                           '\f'),
                   Chr(13),
                   '\n');
  end;
  ----------------------------------------------------------------------------------------------------
  final static Function Format_Number
  (
    i_Val      number,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  
    v_Result varchar2(2000);
  begin
    if i_Format is not null then
      if i_Nlsparam is not null then
        return to_char(i_Val, i_Format, i_Nlsparam);
      else
        return to_char(i_Val, i_Format);
      end if;
    else
      if i_Nlsparam is not null then
        raise Value_Error;
      else
        v_Result := to_char(i_Val, 'TM9', 'NLS_NUMERIC_CHARACTERS=''. ''');
        if i_Val < 1 and i_Val > -1 then
          v_Result := replace(v_Result, '.', '0.');
        end if;
        return v_Result;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Number
  (
    i_Val      varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    if i_Format is not null then
      if i_Nlsparam is not null then
        return to_number(i_Val, i_Format, i_Nlsparam);
      else
        return to_number(i_Val, i_Format);
      end if;
    else
      if i_Nlsparam is not null then
        raise Value_Error;
      else
        return to_number(i_Val,
                         '99999999999999999999D99999999999999999999',
                         'NLS_NUMERIC_CHARACTERS=''. ''');
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Date
  (
    i_Val      date,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    if i_Format is not null then
      if i_Nlsparam is not null then
        return to_char(i_Val, i_Format, i_Nlsparam);
      else
        return to_char(i_Val, i_Format);
      end if;
    else
      if i_Nlsparam is not null then
        raise Value_Error;
      else
        if Trunc(i_Val) = i_Val then
          return to_char(i_Val, 'dd.mm.yyyy');
        else
          return to_char(i_Val, 'dd.mm.yyyy hh24:mi:ss');
        end if;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Date
  (
    i_Val      varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    if i_Format is not null then
      if i_Nlsparam is not null then
        return to_date(i_Val, i_Format, i_Nlsparam);
      else
        return to_date(i_Val, i_Format);
      end if;
    else
      if i_Nlsparam is not null then
        raise Value_Error;
      else
        if Length(i_Val) = 10 then
          return to_date(i_Val, 'dd.mm.yyyy');
        else
          return to_date(i_Val, 'dd.mm.yyyy hh24:mi:ss');
        end if;
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Timestamp
  (
    i_Val      timestamp,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    if i_Format is not null then
      if i_Nlsparam is not null then
        return to_char(i_Val, i_Format, i_Nlsparam);
      else
        return to_char(i_Val, i_Format);
      end if;
    else
      if i_Nlsparam is not null then
        raise Value_Error;
      else
        return to_char(i_Val, 'yyyy.mm.dd hh24:mi:ss.ff');
      end if;
    end if;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Timestamp
  (
    i_Val      varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    if i_Format is not null then
      if i_Nlsparam is not null then
        return To_Timestamp(i_Val, i_Format, i_Nlsparam);
      else
        return To_Timestamp(i_Val, i_Format);
      end if;
    else
      if i_Nlsparam is not null then
        raise Value_Error;
      else
        return To_Timestamp(i_Val, 'yyyy.mm.dd hh24:mi:ss.ff');
      end if;
    end if;
  end;
  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Varchar2
  (
    i_Val      Array_Number,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
    result Array_Varchar2;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Varchar2();
    Result.Extend(i_Val.Count);
  
    for i in 1 .. i_Val.Count
    loop
      result(i) := Format_Number(i_Val(i), i_Format, i_Nlsparam);
    end loop;
  
    return result;
  end;
  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Varchar2
  (
    i_Val      Array_Date,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
    result Array_Varchar2;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Varchar2();
    Result.Extend(i_Val.Count);
  
    for i in 1 .. i_Val.Count
    loop
      result(i) := Format_Date(i_Val(i), i_Format, i_Nlsparam);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Varchar2
  (
    i_Val      Array_Timestamp,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
    result Array_Varchar2;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Varchar2();
    Result.Extend(i_Val.Count);
  
    for i in 1 .. i_Val.Count
    loop
      result(i) := Format_Timestamp(i_Val(i), i_Format, i_Nlsparam);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Number
  (
    i_Val      Array_Varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
    result Array_Number;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Number();
    Result.Extend(i_Val.Count);
  
    for i in 1 .. i_Val.Count
    loop
      result(i) := Format_Number(i_Val(i), i_Format, i_Nlsparam);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Date
  (
    i_Val      Array_Varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
    result Array_Date;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Date();
    Result.Extend(i_Val.Count);
  
    for i in 1 .. i_Val.Count
    loop
      result(i) := Format_Date(i_Val(i), i_Format, i_Nlsparam);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Date(i_Val Array_Timestamp) return Array_Date is
    result Array_Date;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Date();
    Result.Extend(i_Val.Count);
  
    for i in 1 .. i_Val.Count
    loop
      result(i) := cast(i_Val(i) as date);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Timestamp
  (
    i_Val      Array_Varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
    result Array_Timestamp;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Timestamp();
    Result.Extend(i_Val.Count);
  
    for i in 1 .. i_Val.Count
    loop
      result(i) := Format_Timestamp(i_Val(i), i_Format, i_Nlsparam);
    end loop;
  
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  final static Function Format_Array_Timestamp(i_Val Array_Date) return Array_Timestamp is
    result Array_Timestamp;
  begin
    if i_Val is null then
      return result;
    end if;
  
    result := Array_Timestamp();
    Result.Extend(i_Val.Count);
    for i in 1 .. i_Val.Count
    loop
      result(i) := cast(i_Val(i) as timestamp);
    end loop;
    return result;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    raise Value_Error;
    return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    raise Value_Error;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    raise Value_Error;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    raise Value_Error;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    raise Value_Error;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    raise Value_Error;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    raise Value_Error;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    raise Value_Error;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function As_Long_String
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Long_String is
  begin
    raise Value_Error;
    return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Varchar2 return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Number return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Date return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Timestamp return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Varchar2 return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Number return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Date return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Timestamp return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Arraylist return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Hashmap return boolean is
  begin
    return false;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Clob return boolean is
  begin
    return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Blob return boolean is
  begin
    return false;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Long_String return boolean is
  begin
    return false;
  end;
end;
/
