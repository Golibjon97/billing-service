create or replace type Arraylist force under Object_t
(
-- Author  : AZAMAT
-- Created : 05.05.2016 16:26:07
-- Purpose :

  v Array_Object_t,
------------------------------------------------------------------------------------------------------
  constructor Function Arraylist(self in out nocopy Arraylist) return self as result,
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Object_t
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    varchar2
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    number
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    date
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    timestamp
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Varchar2
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Number
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Date
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Timestamp
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Push
  
  (
    self in out nocopy Arraylist,
    v    Long_String
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Object_t
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    varchar2
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    number
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    date
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    timestamp
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Varchar2
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Number
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Date
  ),
------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Timestamp
  ),
------------------------------------------------------------------------------------------------------
  member Function count return pls_integer,
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
  member Function Get_r_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Arraylist(i pls_integer) return Arraylist,
------------------------------------------------------------------------------------------------------
  member Function Get_r_Hashmap(i pls_integer) return Object_t,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Arraylist(i pls_integer) return Arraylist,
------------------------------------------------------------------------------------------------------
  member Function Get_o_Hashmap(i pls_integer) return Object_t,
------------------------------------------------------------------------------------------------------
  overriding member Function Is_Arraylist return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Varchar2(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Number(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Date(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Timestamp(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Varchar2(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Number(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Date(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Array_Timestamp(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Arraylist(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  member Function Is_Hashmap(i pls_integer) return boolean,
------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2,
------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String,
  overriding member Function Json_Clob return clob
)
/
create or replace type body Arraylist is

  ------------------------------------------------------------------------------------------------------
  constructor Function Arraylist(self in out nocopy Arraylist) return self as result is
  begin
    Self.Type := 'ARRAYLIST';
    Self.v    := Array_Object_t();
    return;
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Object_t
  ) is
  begin
    Self.v.Extend;
    Self.v(Self.v.Count) := v;
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    varchar2
  ) is
  begin
    Self.Push(Varchar2_t(v));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    number
  ) is
  begin
    Self.Push(Number_t(v));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    date
  ) is
  begin
    Self.Push(Date_t(v));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    timestamp
  ) is
  begin
    Self.Push(Timestamp_t(v));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Varchar2
  ) is
  begin
    Self.Push(Array_Varchar2_t(v));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Number
  ) is
  begin
    Self.Push(Array_Number_t(v));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Date
  ) is
  begin
    Self.Push(Array_Date_t(v));
  end;

  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Array_Timestamp
  ) is
  begin
    Self.Push(Array_Timestamp_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Push
  (
    self in out nocopy Arraylist,
    v    Long_String
  ) is
  begin
    Self.Push(String_Object_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Object_t
  ) is
  begin
    if (i < 1 or i > Self.v.Count) then
      Raise_Application_Error(-20000, 'Invalid index');
    end if;
    Self.v(i) := v;
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    varchar2
  ) is
  begin
    Self.Set_Val(i, Varchar2_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    number
  ) is
  begin
    Self.Set_Val(i, Number_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    date
  ) is
  begin
    Self.Set_Val(i, Date_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    timestamp
  ) is
  begin
    Self.Set_Val(i, Timestamp_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Varchar2
  ) is
  begin
    Self.Set_Val(i, Array_Varchar2_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Number
  ) is
  begin
    Self.Set_Val(i, Array_Number_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Date
  ) is
  begin
    Self.Set_Val(i, Array_Date_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Procedure Set_Val
  (
    self in out nocopy Arraylist,
    i    pls_integer,
    v    Array_Timestamp
  ) is
  begin
    Self.Set_Val(i, Array_Timestamp_t(v));
  end;
  ------------------------------------------------------------------------------------------------------
  member Function count return pls_integer is
  begin
    return v.Count;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    if v.Count = 1 then
      return v(1).As_Varchar2(i_Format, i_Nlsparam);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    if v.Count = 1 then
      return v(1).As_Number(i_Format, i_Nlsparam);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    if v.Count = 1 then
      return v(1).As_Date(i_Format, i_Nlsparam);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    if v.Count = 1 then
      return v(1).As_Timestamp(i_Format, i_Nlsparam);
    elsif v.Count = 0 then
      raise No_Data_Found;
    else
      raise Too_Many_Rows;
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Varchar2
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
    result Array_Varchar2 := Array_Varchar2();
  begin
    Result.Extend(v.Count);
    for i in 1 .. v.Count
    loop
      result(i) := v(i).As_Varchar2(i_Format, i_Nlsparam);
    end loop;
    return result;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Number
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
    result Array_Number := Array_Number();
  begin
    Result.Extend(v.Count);
    for i in 1 .. v.Count
    loop
      result(i) := v(i).As_Number(i_Format, i_Nlsparam);
    end loop;
    return result;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Date
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
    result Array_Date := Array_Date();
  begin
    Result.Extend(v.Count);
    for i in 1 .. v.Count
    loop
      result(i) := v(i).As_Date(i_Format, i_Nlsparam);
    end loop;
    return result;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function As_Array_Timestamp
  (
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
    result Array_Timestamp := Array_Timestamp();
  begin
    Result.Extend(v.Count);
    for i in 1 .. v.Count
    loop
      result(i) := v(i).As_Timestamp(i_Format, i_Nlsparam);
    end loop;
    return result;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    return v(i).As_Varchar2(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    return v(i).As_Number(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    return v(i).As_Date(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    return v(i).As_Timestamp(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    return v(i).As_Array_Varchar2(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    return v(i).As_Array_Number(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    return v(i).As_Array_Date(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Array_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    return v(i).As_Array_Timestamp(i_Format, i_Nlsparam);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Arraylist(i pls_integer) return Arraylist is
  begin
    return Treat(v(i) as Arraylist);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_r_Hashmap(i pls_integer) return Object_t is
  begin
    return v(i);
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return varchar2 is
  begin
    if 0 < i and i <= Self.v.Count then
      return v(i).As_Varchar2(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return number is
  begin
    if 0 < i and i <= v.Count then
      return v(i).As_Number(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return date is
  begin
    if 0 < i and i <= v.Count then
      return v(i).As_Date(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return timestamp is
  begin
    if 0 < i and i <= v.Count then
      return v(i).As_Timestamp(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Varchar2
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Varchar2 is
  begin
    if 0 < i and i <= v.Count then
      return v(i).As_Array_Varchar2(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Number
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Number is
  begin
    if 0 < i and i <= v.Count then
      return v(i).As_Array_Number(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Date
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Date is
  begin
    if 0 < i and i <= v.Count then
      return v(i).As_Array_Date(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Array_Timestamp
  (
    i          pls_integer,
    i_Format   varchar2 := null,
    i_Nlsparam varchar2 := null
  ) return Array_Timestamp is
  begin
    if 0 < i and i <= v.Count then
      return v(i).As_Array_Timestamp(i_Format, i_Nlsparam);
    end if;
    return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Arraylist(i pls_integer) return Arraylist is
  begin
    return Treat(v(i) as Arraylist);
  exception
    when others then
      return null;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Get_o_Hashmap(i pls_integer) return Object_t is
  begin
    return v(i);
  exception
    when others then
      return null;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Is_Arraylist return boolean is
  begin
    return true;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Varchar2(i pls_integer) return boolean is
  begin
    return v(i).Is_Varchar2;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Number(i pls_integer) return boolean is
  begin
    return v(i).Is_Number;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Date(i pls_integer) return boolean is
  begin
    return v(i).Is_Date;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Timestamp(i pls_integer) return boolean is
  begin
    return v(i).Is_Timestamp;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Varchar2(i pls_integer) return boolean is
  begin
    return v(i).Is_Array_Varchar2;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Number(i pls_integer) return boolean is
  begin
    return v(i).Is_Array_Number;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Date(i pls_integer) return boolean is
  begin
    return v(i).Is_Array_Date;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Array_Timestamp(i pls_integer) return boolean is
  begin
    return v(i).Is_Array_Timestamp;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  member Function Is_Arraylist(i pls_integer) return boolean is
  begin
    return v(i).Is_Arraylist;
  exception
    when others then
      return false;
  end;
  ------------------------------------------------------------------------------------------------------
  member Function Is_Hashmap(i pls_integer) return boolean is
  begin
    return v(i).Is_Hashmap;
  exception
    when others then
      return false;
  end;

  ------------------------------------------------------------------------------------------------------
  overriding member Function Json return varchar2 is
    result varchar2(32767);
  begin
    result := '[';
  
    for i in 1 .. v.Count
    loop
    
      result := result || v(i).Json;
    
      if i <> v.Count then
        result := result || ',';
      end if;
    
    end loop;
  
    return result || ']';
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Long_String return Long_String is
    result Long_String := Long_String('[');
  begin
    for i in 1 .. v.Count
    loop
      if i = 1 then
        Result.Append(v(i).Json_Long_String());
      else
        Result.Append(',');
        Result.Append(v(i).Json_Long_String());
      end if;
    end loop;
    Result.Append(']');
    return result;
  end;
  ------------------------------------------------------------------------------------------------------
  overriding member Function Json_Clob return clob is
  begin
    return Self.Json_Long_String().To_Clob();
  end;

end;
/
