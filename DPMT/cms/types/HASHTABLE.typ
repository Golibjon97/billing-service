CREATE OR REPLACE TYPE "HASHTABLE"                                          as object
(
-- Author  : ARTIKALI
-- Created : 29.03.2010 19:53:56
-- Purpose :

-- Attributes
  Buckets Hash_Bucket_Array,

-- Member functions and procedures
  constructor Function Hashtable return self as result,

  member Procedure Put
  (
    Key   varchar2,
    Entry Hash_Entry
  ),
  member Function Get(Key varchar2) return Hash_Entry,
  member Procedure Remove(Key varchar2),
  member Function Has(Key varchar2) return boolean,
  member Function count return pls_integer,

------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    Key   varchar2,
    value varchar2
  ),
  member Procedure Put
  (
    Key   varchar2,
    value number
  ),
  member Procedure Put
  (
    Key   varchar2,
    value date
  ),
  member Procedure Put
  (
    Key   varchar2,
    value Array_Varchar2
  ),
  member Procedure Put
  (
    Key   varchar2,
    value Array_Number
  ),
  member Procedure Put
  (
    Key   varchar2,
    value Array_Date
  ),

------------------------------------------------------------------------------------------------------
  member Function Get_Varchar2(Key varchar2) return varchar2,
  member Function Get_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return number,
  member Function Get_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return date,
  member Function Get_Array_Varchar2(Key varchar2) return Array_Varchar2,
  member Function Get_Array_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Number,
  member Function Get_Array_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Date,

------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Varchar2(Key varchar2) return varchar2,
  member Function Get_Optional_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return number,
  member Function Get_Optional_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return date,
  member Function Get_Optional_Array_Varchar2(Key varchar2) return Array_Varchar2,
  member Function Get_Optional_Array_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Number,
  member Function Get_Optional_Array_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Date,

------------------------------------------------------------------------------------------------------
  member Function Get_Bucket return Hash_Bucket,

  member Procedure Print_To_Htp(self in Hashtable),

  static Function hash(Key varchar2) return pls_integer

)
/
CREATE OR REPLACE TYPE BODY "HASHTABLE" is

  -- Member procedures and functions
  constructor Function Hashtable(self in out nocopy Hashtable) return self as result as
  begin
    Self.Buckets := Hash_Bucket_Array();
    Self.Buckets.Extend(128);
    return;
  end Hashtable;

  -- put ENTRY
  member Procedure Put
  (
    self  in out nocopy Hashtable,
    Key   varchar2,
    Entry Hash_Entry
  ) is
    v_Hash pls_integer;
  begin
    Remove(Key);

    v_Hash := Hashtable.Hash(Key);

    if Buckets(v_Hash) is null then
      Buckets(v_Hash) := Hash_Bucket();
    end if;

    Buckets(v_Hash).Extend;
    Buckets(v_Hash)(Buckets(v_Hash).Count) := Entry;
  end Put;

  -- get ENTRY
  member Function Get(Key varchar2) return Hash_Entry is
    v_Hash  pls_integer;
    v_Count pls_integer;
    v_Entry Hash_Entry;
  begin
    v_Hash := Hashtable.Hash(Key);
    if Buckets(v_Hash) is null then
      raise No_Data_Found;
    end if;

    v_Count := Buckets(v_Hash).Count;
    for i in 1 .. v_Count
    loop
      v_Entry := Buckets(v_Hash) (i);
      if v_Entry.Key = Key then
        return v_Entry;
      end if;
    end loop;
    raise No_Data_Found;
  end Get;

  -- remove
  member Procedure Remove
  (
    self in out nocopy Hashtable,
    Key  varchar2
  ) is
    v_Hash  pls_integer;
    v_Count pls_integer;
    v_Entry Hash_Entry;
  begin
    v_Hash := Hashtable.Hash(Key);

    if Buckets(v_Hash) is null then
      return;
    end if;

    v_Count := Buckets(v_Hash).Count;
    for i in 1 .. v_Count
    loop
      v_Entry := Buckets(v_Hash) (i);
      if v_Entry.Key = Key then

        if i <> v_Count then
          Buckets(v_Hash)(i) := Buckets(v_Hash) (v_Count);
        end if;
        Buckets(v_Hash).Trim(1);
        return;

      end if;
    end loop;
  end Remove;

  -- has
  member Function Has(Key varchar2) return boolean as
    v_Entry Hash_Entry;
  begin
    v_Entry := Get(Key);
    return true;
  exception
    when No_Data_Found then
      return false;
  end Has;

  -- count
  member Function count return pls_integer is
    v_Count pls_integer;
  begin
    for i in 1 .. Buckets.Count
    loop
      if Buckets(i) is not null then
        v_Count := v_Count + Buckets(i).Count;
      end if;
    end loop;
    return v_Count;
  end;

  ------------------------------------------------------------------------------------------------------
  -- put VARCHAR2
  member Procedure Put
  (
    self  in out nocopy Hashtable,
    Key   varchar2,
    value varchar2
  ) is
  begin
    Put(Key, Array_Varchar2(value));
  end;

  -- put NUMBER
  member Procedure Put
  (
    self  in out nocopy Hashtable,
    Key   varchar2,
    value number
  ) is
  begin
    Put(Key, Array_Number(value));
  end Put;

  -- put DATE
  member Procedure Put
  (
    self  in out nocopy Hashtable,
    Key   varchar2,
    value date
  ) is
  begin
    Put(Key, Array_Date(value));
  end Put;

  -- put ARRAY_VARCHAR2
  member Procedure Put
  (
    self  in out nocopy Hashtable,
    Key   varchar2,
    value Array_Varchar2
  ) as
  begin
    Put(Key, Hash_Entry(Key, value, Hash_Entry.Varchar2_Type));
  end Put;

  -- put ARRAY_NUMBER
  member Procedure Put
  (
    self  in out nocopy Hashtable,
    Key   varchar2,
    value Array_Number
  ) is
    Temp Array_Varchar2 := Array_Varchar2();
  begin
    Temp.Extend(Value.Count);
    for i in 1 .. Value.Count
    loop
      Temp(i) := to_char(value(i), 'TM9', Hash_Entry.Nls_Numeric_Characters);
    end loop;
    Put(Key, Hash_Entry(Key, Temp, Hash_Entry.Number_Type));
  end Put;

  -- put ARRAY_DATE
  member Procedure Put
  (
    self  in out nocopy Hashtable,
    Key   varchar2,
    value Array_Date
  ) is
    Temp Array_Varchar2 := Array_Varchar2();
  begin
    Temp.Extend(Value.Count);
    for i in 1 .. Value.Count
    loop
      Temp(i) := to_char(value(i), Hash_Entry.Date_Format);
    end loop;
    Put(Key, Hash_Entry(Key, Temp, Hash_Entry.Date_Type));
  end Put;

  ------------------------------------------------------------------------------------------------------
  -- get VARCHAR2
  member Function Get_Varchar2(Key varchar2) return varchar2 is
  begin
    return Get(Key).Get_Varchar2();
  end Get_Varchar2;

  -- get NUMBER
  member Function Get_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return number is
  begin
    return Get(Key).Get_Number(Format);
  end Get_Number;

  -- get DATE
  member Function Get_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return date is
  begin
    return Get(Key).Get_Date(Format);
  end Get_Date;

  -- get ARRAY_VARCHAR2
  member Function Get_Array_Varchar2(Key varchar2) return Array_Varchar2 is
  begin
    return Get(Key).Value;
  end Get_Array_Varchar2;

  -- get ARRAY_NUMBER
  member Function Get_Array_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Number is
  begin
    return Get(Key).Get_Array_Number(Format);
  end Get_Array_Number;

  -- get ARRAY_DATE
  member Function Get_Array_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Date is
  begin
    return Get(Key).Get_Array_Date(Format);
  end Get_Array_Date;

  ------------------------------------------------------------------------------------------------------
  -- get VARCHAR2
  member Function Get_Optional_Varchar2(Key varchar2) return varchar2 is
  begin
    return Get(Key).Get_Varchar2();
  exception
    when No_Data_Found then
      return null;
  end Get_Optional_Varchar2;

  -- get NUMBER
  member Function Get_Optional_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return number is
  begin
    return Get(Key).Get_Number(Format);
  exception
    when No_Data_Found then
      return null;
  end Get_Optional_Number;

  -- get DATE
  member Function Get_Optional_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return date is
  begin
    return Get(Key).Get_Date(Format);
  exception
    when No_Data_Found then
     return null;
  end Get_Optional_Date;

  -- get ARRAY_VARCHAR2
  member Function Get_Optional_Array_Varchar2(Key varchar2) return Array_Varchar2 is
  begin
    return Get(Key).Value;
  exception
    when No_Data_Found then
      return null;
  end Get_Optional_Array_Varchar2;

  -- get ARRAY_NUMBER
  member Function Get_Optional_Array_Number
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Number is
  begin
    return Get(Key).Get_Array_Number(Format);
  exception
    when No_Data_Found then
      return null;
  end Get_Optional_Array_Number;

  -- get ARRAY_DATE
  member Function Get_Optional_Array_Date
  (
    Key    varchar2,
    Format varchar2 := null
  ) return Array_Date is
  begin
    return Get(Key).Get_Array_Date(Format);
  exception
    when No_Data_Found then
      return null;
  end Get_Optional_Array_Date;

  ------------------------------------------------------------------------------------------------------
  member Function Get_Bucket return Hash_Bucket is
    result Hash_Bucket := Hash_Bucket();
  begin
    for i in 1 .. Buckets.Count
    loop
      if Buckets(i) is not null then
        for j in 1 .. Buckets(i).Count
        loop
          Result.Extend;
          result(Result.Count) := Buckets(i) (j);
        end loop;
      end if;
    end loop;
    return result;
  end Get_Bucket;

  -- print to htp
  member Procedure Print_To_Htp(self in Hashtable) is
    Function Nvlt(s varchar2) return varchar2 is
    begin
      return Nvl(s, '&nbsp;');
    end Nvlt;
  begin
    Htp.Print('<table border=1 bordercolor=#cccccc cellspacing=0 cellpadding=2><tr><th>Key<th>Values');
    for i in 1 .. Buckets.Count
    loop
      if Buckets(i) is not null then
        for j in 1 .. Buckets(i).Count
        loop
          Htp.Print('<tr><td valign=top>' || Buckets(i)(j)
                    .Key || '<td>' || Nvlt(Buckets(i)(j).Value(1)));
          for k in 2 .. Buckets(i)(j).Value.Count
          loop
            Htp.Print('<tr><td>&nbsp;<td>' || Nvlt(Buckets(i)(j).Value(k)));
          end loop;
        end loop;
      end if;

    end loop;
    Htp.Print('</table>');
  end Print_To_Htp;

  static Function hash(Key varchar2) return pls_integer as
  begin
    return Dbms_Utility.Get_Hash_Value(Key, 1, 128);
  end hash;

end;
/
