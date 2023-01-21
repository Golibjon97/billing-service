CREATE OR REPLACE TYPE "HASH_ENTRY"                                          as object
(
-- Author  : ARTIKALI
-- Created : 31.03.2010 17:27:26
-- Purpose :

  Key   varchar2(50),
  value Array_Varchar2,
  type  varchar2(1),

  member Function Get_Varchar2 return varchar2,
  member Function Get_Number(Format varchar2 := null) return number,
  member Function Get_Date(Format varchar2 := null) return date,
  member Function Get_Array_Varchar2 return Array_Varchar2,
  member Function Get_Array_Number(Format varchar2 := null) return Array_Number,
  member Function Get_Array_Date(Format varchar2 := null) return Array_Date,

  static Function Nls_Numeric_Characters return varchar2,
  static Function Numeric_Format return varchar2,
  static Function Date_Format return varchar2,

  static Function Varchar2_Type return varchar2,
  static Function Number_Type return varchar2,
  static Function Date_Type return varchar2
)
/
CREATE OR REPLACE TYPE BODY "HASH_ENTRY" is

  -- get VARCHAR2
  member Function Get_Varchar2 return varchar2 is
  begin
    if value is null then
      return null;
    end if;

    if Value.Count <> 1 then
      raise Too_Many_Rows;
    end if;

    return value(1);
  end Get_Varchar2;

  -- get NUMBER
  member Function Get_Number(Format varchar2 := null) return number is
  begin
    if type = Hash_Entry.Number_Type then
      return To_Number(Get_Varchar2, Hash_Entry.Numeric_Format, Hash_Entry.Nls_Numeric_Characters);
    else
      return To_Number(Get_Varchar2,
                       Nvl(Format, Hash_Entry.Numeric_Format),
                       Hash_Entry.Nls_Numeric_Characters);
    end if;
  end Get_Number;

  -- get DATE
  member Function Get_Date(Format varchar2 := null) return date is
  begin
    if type = Hash_Entry.Date_Type then
      return To_Date(Get_Varchar2, Hash_Entry.Date_Format);
    else
      return To_Date(Get_Varchar2, Nvl(Format, Hash_Entry.Date_Format));
    end if;
  end Get_Date;

  -- get ARRAY_VARCHAR2
  member Function Get_Array_Varchar2 return Array_Varchar2 is
  begin
    return value;
  end Get_Array_Varchar2;

  -- get ARRAY_NUMBER
  member Function Get_Array_Number(Format varchar2 := null) return Array_Number is
    result Array_Number;
  begin

    if value is null then
      return null;
    end if;

    result := Array_Number();
    Result.Extend(Value.Count);
    for i in 1 .. Value.Count
    loop
      if type = Hash_Entry.Number_Type then
        result(i) := To_Number(value(i),
                               Hash_Entry.Numeric_Format,
                               Hash_Entry.Nls_Numeric_Characters);
      else
        result(i) := To_Number(value(i),
                               Nvl(Format, Hash_Entry.Numeric_Format),
                               Hash_Entry.Nls_Numeric_Characters);
      end if;
    end loop;

    return result;
  end Get_Array_Number;

  -- get ARRAY_DATE
  member Function Get_Array_Date(Format varchar2 := null) return Array_Date is
    result Array_Date;
  begin

    if value is null then
      return null;
    end if;

    result := Array_Date();
    Result.Extend(Value.Count);
    for i in 1 .. Value.Count
    loop
      if type = Hash_Entry.Date_Type then
        result(i) := To_Date(value(i), Hash_Entry.Date_Format);
      else
        result(i) := To_Date(value(i), Nvl(Format, Hash_Entry.Date_Format));
      end if;
    end loop;

    return result;
  end Get_Array_Date;

  static Function Nls_Numeric_Characters return varchar2 is
  begin
    return 'NLS_NUMERIC_CHARACTERS=''. ''';
  end Nls_Numeric_Characters;

  static Function Numeric_Format return varchar2 is
  begin
    return '99999999999999999999D99999999';
  end Numeric_Format;

  static Function Date_Format return varchar2 is
  begin
    return 'yyyymmddhh24miss';
  end Date_Format;

  static Function Varchar2_Type return varchar2 is
  begin
    return 'V';
  end Varchar2_Type;

  static Function Number_Type return varchar2 is
  begin
    return 'N';
  end Number_Type;

  static Function Date_Type return varchar2 is
  begin
    return 'D';
  end Date_Type;

end;
/
