create or replace type Hashmap Force under Object_t
(
-- Author  : AZAMAT
-- Created : 06.05.2016 20:26:26
-- Purpose :

  Buckets Map_Bucket_Array,
----------------------------------------------------------------------------------------------------
  constructor Function Hashmap(self in out nocopy Hashmap) return self as result,
----------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    Entry Map_Entry
  ),
----------------------------------------------------------------------------------------------------
  member Function Get(Key varchar2) return Map_Entry,
----------------------------------------------------------------------------------------------------
  member Procedure Remove
  (
    self in out nocopy Hashmap,
    Key  varchar2
  ),
----------------------------------------------------------------------------------------------------
  member Function Has(Key varchar2) return boolean,
----------------------------------------------------------------------------------------------------
  member Function count return pls_integer,
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Object_t
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value varchar2
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value number
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value date
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value timestamp
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Varchar2
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Number
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Date
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Timestamp
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Arraylist
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value clob
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    value Hashtable
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Long_String
  ),
------------------------------------------------------------------------------------------------------
  member Function Is_Varchar2(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Number(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Date(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Timestamp(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Varchar2(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Number(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Date(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Timestamp(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Arraylist(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Hashmap(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Long_String(Key varchar2) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Get_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
------------------------------------------------------------------------------------------------------
  member Function Get_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
------------------------------------------------------------------------------------------------------
  member Function Get_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_Array_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_Array_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
------------------------------------------------------------------------------------------------------
  member Function Get_Array_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
------------------------------------------------------------------------------------------------------
  member Function Get_Array_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_Arraylist(Key varchar2) return Arraylist,
------------------------------------------------------------------------------------------------------
  member Function Get_Hashmap(Key varchar2) return Hashmap,
------------------------------------------------------------------------------------------------------
  member Function Get_Long_String
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Long_String,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Arraylist(Key varchar2) return Arraylist,
------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Hashmap(Key varchar2) return Hashmap,
------------------------------------------------------------------------------------------------------
  member Function Get_Bucket return Map_Bucket,
------------------------------------------------------------------------------------------------------
  static Function hash(Key varchar2) return pls_integer,
------------------------------------------------------------------------------------------------------
  overriding member Function Is_Hashmap return boolean,
------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2,
  overriding member Function Json_Long_String return Long_String,
  overriding member Function Json_Clob return clob
)
/
create or replace type body Hashmap is
  ----------------------------------------------------------------------------------------------------
  constructor Function Hashmap(self in out nocopy Hashmap) return self as result as
  begin
    Self.Buckets := Map_Bucket_Array();
    Self.Buckets.Extend(128);
    return;
  end;
  ----------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    Entry Map_Entry
  ) is
    v_Hash pls_integer := Hashmap.Hash(Key);
  begin
    if Self.Buckets(v_Hash) is null then
      Self.Buckets(v_Hash) := Map_Bucket(Entry);
      return;
    end if;
    --
    for i in 1 .. Self.Buckets(v_Hash).Count
    loop
      if Self.Buckets(v_Hash)(i).Key = Key then
        Self.Buckets(v_Hash)(i) := Entry;
        return;
      end if;
    end loop;
    --
    Self.Buckets(v_Hash).Extend;
    Self.Buckets(v_Hash)(Buckets(v_Hash).Count) := Entry;
  end;
  ----------------------------------------------------------------------------------------------------
  member Function Get(Key varchar2) return Map_Entry is
    v_Hash pls_integer := Hashmap.Hash(Key);
    --v_Entry Map_Entry;
  begin
  
    if Self.Buckets(v_Hash) is not null then
      for i in 1 .. Self.Buckets(v_Hash).Count
      loop
        --v_Entry := Self.Buckets(v_Hash) (i);
        if Self.Buckets(v_Hash)(i).Key = Key then
          return Self.Buckets(v_Hash)(i);
        end if;
      end loop;
    end if;
    raise No_Data_Found;
  end;
  ----------------------------------------------------------------------------------------------------
  member Procedure Remove
  (
    self in out nocopy Hashmap,
    Key  varchar2
  ) is
    v_Hash  pls_integer := Hashmap.Hash(Key);
    v_Count pls_integer;
    v_Entry Map_Entry;
  begin
  
    if Self.Buckets(v_Hash) is null then
      return;
    end if;
  
    v_Count := Self.Buckets(v_Hash).Count;
    for i in 1 .. v_Count
    loop
      v_Entry := Self.Buckets(v_Hash) (i);
      if v_Entry.Key = Key then
      
        if i <> v_Count then
          Self.Buckets(v_Hash)(i) := Self.Buckets(v_Hash) (v_Count);
        end if;
        Buckets(v_Hash).Trim(1);
        return;
      
      end if;
    end loop;
  end Remove;
  ----------------------------------------------------------------------------------------------------
  member Function Has(Key varchar2) return boolean as
    v_Entry Map_Entry;
  begin
    v_Entry := Get(Key);
    if v_Entry is null then
      null; -- compiled successfully
    end if;
    return true;
  exception
    when No_Data_Found then
      return false;
  end;
  ----------------------------------------------------------------------------------------------------
  member Function count return pls_integer is
    v_Count pls_integer := 0;
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
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Object_t
  ) is
  begin
    Self.Put(Key, Map_Entry(Key, value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value varchar2
  ) is
  begin
    Self.Put(Key, Varchar2_t(value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value number
  ) is
  begin
    Self.Put(Key, Number_t(value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value date
  ) is
  begin
    Self.Put(Key, Date_t(value));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value timestamp
  ) is
  begin
    Self.Put(Key, Timestamp_t(value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Varchar2
  ) as
  begin
    Self.Put(Key, Array_Varchar2_t(value));
  end Put;

  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Number
  ) is
  begin
    Self.Put(Key, Array_Number_t(value));
  end Put;

  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Date
  ) is
  begin
    Self.Put(Key, Array_Date_t(value));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Array_Timestamp
  ) is
  begin
    Self.Put(Key, Array_Timestamp_t(value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Arraylist
  ) is
  begin
    Self.Put(Key, Map_Entry(Key, value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value clob
  ) is
  begin
    Self.Put(Key, Clob_t(value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    value Hashtable
  ) is
    v_Hash_Buket Hash_Bucket;
  begin
    v_Hash_Buket := Value.Get_Bucket;
    for i in 1 .. v_Hash_Buket.Count
    loop
      Self.Put(v_Hash_Buket(i).Key, Array_Varchar2_t(v_Hash_Buket(i).Value));
    end loop;
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Put
  (
    self  in out nocopy Hashmap,
    Key   varchar2,
    value Long_String
  ) is
  begin
    Self.Put(Key, String_Object_t(value));
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Varchar2(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Varchar2;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Number(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Number;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Date(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Date;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Timestamp(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Timestamp;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Varchar2(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Array_Varchar2;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Number(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Array_Number;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Date(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Array_Date;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Timestamp(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Array_Timestamp;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Arraylist(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Arraylist;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Hashmap(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Hashmap;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Long_String(Key varchar2) return boolean is
  begin
    return Self.Get(Key).Val.Is_Long_String;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    return Get(Key).Val.As_Varchar2(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    return Get(Key).Val.As_Number(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    return Get(Key).Val.As_Date(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    return Get(Key).Val.As_Timestamp(i_Format, i_Nlsparam);
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Array_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    return Get(Key).Val.As_Array_Varchar2(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_Array_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    return Get(Key).Val.As_Array_Number(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_Array_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    return Get(Key).Val.As_Array_Date(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_Array_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    return Get(Key).Val.As_Array_Timestamp(i_Format, i_Nlsparam);
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Arraylist(Key varchar2) return Arraylist is
  begin
    return Treat(Get(Key).Val as Arraylist);
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Hashmap(Key varchar2) return Hashmap is
  begin
    return Treat(Get(Key).Val as Hashmap);
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Long_String
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Long_String is
  begin
    if Get(Key).Val.Is_Long_String then
      return Get(Key).Val.As_Long_String(i_Format, i_Nlsparam);
    else
      return Long_String(Get(Key).Val.As_Varchar2(i_Format, i_Nlsparam));
    end if;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    return Get(Key).Val.As_Varchar2(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    return Get(Key).Val.As_Number(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    return Get(Key).Val.As_Date(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    return Get(Key).Val.As_Timestamp(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Varchar2
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    return Get(Key).Val.As_Array_Varchar2(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end Get_Optional_Array_Varchar2;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Number
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    return Get(Key).Val.As_Array_Number(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Date
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    return Get(Key).Val.As_Array_Date(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Array_Timestamp
  (
    Key        varchar2,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    return Get(Key).Val.As_Array_Timestamp(i_Format, i_Nlsparam);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Arraylist(Key varchar2) return Arraylist is
  begin
    return Treat(Get(Key).Val as Arraylist);
  exception
    when No_Data_Found then
      return null;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Optional_Hashmap(Key varchar2) return Hashmap is
  begin
    return Treat(Get(Key).Val as Hashmap);
  exception
    when No_Data_Found then
      return null;
    
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Get_Bucket return Map_Bucket is
    result Map_Bucket := Map_Bucket();
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

  ------------------------------------------------------------------------------------------------------
  static Function hash(Key varchar2) return pls_integer as
  begin
    return Dbms_Utility.Get_Hash_Value(Key, 1, 128);
  end hash;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Hashmap return boolean is
  begin
    return true;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2 is
    result  varchar2(32767) := '{';
    v_First boolean := true;
  begin
    for i in 1 .. Buckets.Count
    loop
      if Buckets(i) is not null then
        for j in 1 .. Buckets(i).Count
        loop
          if v_First then
            result  := result || '"' || Buckets(i)(j).Key || '":' || Buckets(i)(j).Val.Json;
            v_First := false;
          else
            result := result || ',"' || Buckets(i)(j).Key || '":' || Buckets(i)(j).Val.Json;
          end if;
        end loop;
      end if;
    end loop;
    return result || '}';
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String is
    result  Long_String := Long_String('{');
    v_First boolean := true;
  begin
    for i in 1 .. Buckets.Count
    loop
      if Buckets(i) is not null then
        for j in 1 .. Buckets(i).Count
        loop
          if v_First then
            Result.Append('"' || Buckets(i)(j).Key || '":');
            v_First := false;
          else
            Result.Append(',"' || Buckets(i)(j).Key || '":');
          end if;
          Result.Append(Buckets(i)(j).Val.Json_Long_String());
        end loop;
      end if;
    end loop;
    Result.Append('}');
    return result;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Clob return clob is
  begin
    return Self.Json_Long_String().To_Clob();
  end;

end;
/
