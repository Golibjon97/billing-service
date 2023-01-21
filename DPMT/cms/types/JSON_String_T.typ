CREATE OR REPLACE TYPE JSON_String_T force as Object (
--
-- Author   : �������� �.�.
-- Created  : 22.09.2019 06:14:18
-- Version  : ->>22102019<<-
-- System   : ���� 6.5.0
-- Subsystem: ���� ���� 6.5.0
-- Purpose  : ��������� ��� ��� ����������� ��������� � PL/SQL ������� JSON-�����
--            ��������� �������, ������� � ���������� � ������ ������� ����� � ������� JSON
--            ��������� ������ ������� ����� ��� �������� � ������, ��� ��������� �����������
--            ��������� ������������ ������
  
  
  -- ��������� ��������� ������ (��������� � �������, ����� ���������
  -- ������������� �����)
  "Length "       Integer(12),      -- ����� ����� ������
  "Level "        Integer(5),       -- ������� ������� �������� ����� ������ (�� ����� 32767)
  "Levels "       Varchar2(32767),  -- ���� ������ ������ ��������� ������� (O-������, L-������)
  "Is_Empty "     Varchar2(1),      -- ������� ������� ��� ����
  "Compress "     Varchar2(1),      -- ������ ������ ��� �������� ������
  "Max_Length "   Integer(12),      -- ���������� ����� ������
  "Buf "          Varchar2(32767),  -- �������� ����� ��� �������� JSON-������
  "Raw_Data "     Array_Raw,        -- �����������-�������������� ����� ��� �������� ������� ������
  --
  -- ���������� � ���������� ��������������
  "Def_CharSet "  Varchar2(15),     -- ��������� �������� �� ���������
  "Fmt_Number "   Varchar2(43),     -- ������ �������� ��������� ����
  "Fmt_Date "     Varchar2(10),     -- ������ �������� ���� ����
  "Fmt_Time "     Varchar2(21),     -- ������ �������� ���� ���� � �����
  --
  -- ���������� � ��������� �� ���������
  "Null_Number "  Varchar2(4),      -- ������ ��� ������ ��������� �������� NULL
  "Null_Boolean " Varchar2(5),      -- ������ ��� ������ ����������� �������� NULL
  "Null_Date "    Varchar2(12),     -- ������ ��� ������ NULL-�������� ���� ���� � �����
  
  
  
  -- ����������� ����� ��� ��������� ������ ���� ���������� ����
  -- ������������ ���� ������ ���������� ����������� ������ ���
  -- ��������� ������
  static function GetVersion return Varchar2,
  
  
  -- ����������� ��� �������� ������ ������� ���������� ����
  Constructor Function JSON_String_T (
    Self in out nocopy JSON_String_T
  )
  Return Self as Result,
  
  -- ���������������� �������� ����� ������
  final member procedure Init (Self in out nocopy JSON_String_T),
  
  -- ���������������� ���������� �� �������������� ������
  final member procedure Set_Formats (
    Self in out nocopy JSON_String_T,
    i_Def_CharSet  Varchar2 := NULL,     -- ��������� �������� �� ���������
    i_Fmt_Number   Varchar2 := NULL,     -- ������ �������� ��������� ����
    i_Fmt_Date     Varchar2 := NULL,     -- ������ �������� ���� ����
    i_Fmt_Time     Varchar2 := NULL      -- ������ �������� ���� ���� � �����
  ),
  
  -- ���������������� ���������� � ��������� �� ���������
  final member procedure Set_Defaults (
    Self in out nocopy JSON_String_T,
    i_Null_Number  Varchar2 := NULL,     -- �������� ��� ������ NULL-�����
    i_Null_Boolean Varchar2 := NULL,     -- �������� ��� ������ NULL-Boolean
    i_Null_Date    Varchar2 := NULL      -- �������� ��� ������ NULL-����
  ),
  
  -- ������ ������� ������ ������ ��� �������� �� ����������� �����
  -- ��������� ������� �������� � "Y" (�� ���������) ��������� ���������
  -- ����������� ������ ��� �������������� �������� ������������������
  final member procedure Set_Compress (
    Self in out nocopy JSON_String_T,
    i_Compress  Varchar2 := 'Y'
  ),
  
  -- ������������ ���������� � ��������  ����� ������ � ���������� �� ������
  final member procedure Error (
    Self          in JSON_String_T,
    i_Error_Code  in PLS_Integer := 0,
    i_Error_Msg   in Varchar2
  ),
  
  -- ���������� ����� ������
  final member function Get_Length Return Integer,
  
  -- ���������� ������� ����������� �������� �����
  final member function Get_Level Return Integer,
  
  -- ���������� ���������� ���������� ������� ��� �������� ������,
  -- ������� �������� � ����������� ������
  final member function Get_Buf_Count Return Integer,
  
  -- ����������� ������� ������� ������
  final member function Cast_To_Raw (i_Str Varchar2) Return Raw,
  
  -- ����������� ������� ������� ������
  final member function Cast_To_String (i_Raw Raw) Return Varchar2,
  
  -- ������������� �������� ������ � JSON-����������� ������
  -- ����������� ����������� ������� � Escape-������������������
  final static function Cast_To_JSON (i_Str Varchar2) return Varchar2,
  
  -- ��������� ������ � �������� �������������
  final member function Compress_Raw (i_Raw Raw) Return Raw,
  
  -- ��������� ������ � ���������� �������������
  final member function Compress_Str (i_Str Varchar2) Return Raw,
  
  -- ����������� ������ ������ � ���������� ��������� � �������� �������������
  final member function Uncompress_To_Raw (i_Raw Raw) Return Raw,
  
  -- ����������� ������ ������ � ���������� ��������� � ���������� �������������
  final member function Uncompress_To_Str (i_Raw Raw) Return Varchar2,
  
  
  -- ������������� �������� ����������� ���� � ������ JSON
  -- ������� ������� ������� �� ������ � ����� ������
  -- ������������ � ������ ������� � ����������� ������� ���������� � JSON-����������� �������
  final member function Format (i_Str Varchar2) Return Varchar2,
  
  -- ������������� �������� ��������� ���� � ������ JSON
  final member function Format (i_Value Number, i_Fmt Varchar2 := NULL) Return Varchar2,
  
  -- ������������� �������� ���� ���� � ����� � ������ JSON
  final member function Format (i_Value Date, i_Fmt Varchar2 := NULL) Return Varchar2,
  
  -- ������������� �������� ���� ���� � ����� � ������ JSON
  final member function Format (i_Value Boolean) Return Varchar2,
  
  
  -- ����������� ���� ����-�������� ��� ������� � ������� JSON
  -- ��� �������������� �������� ���������� ������� 
  -- ������ ��� ����������� ����������
  final member function "_Make_Comma_Name " (i_Name Varchar2) Return Varchar2,
  
  -- ���������� �������� � ���� ��������� �����
  -- ������ ��� ����������� ����������
  final member function "_Extract_Raw_Data " (
    i_Index      Integer,
    i_Compress   Varchar2 := 'Y',
    i_Debugging  Boolean  := False
  )
  Return Raw,
  
  --
  -- ������ ��� ����������� ����������
  final member procedure "_Flash_Buf " (Self in out nocopy JSON_String_T),
  
  -- 
  -- ������ ��� ����������� ����������
  final member procedure "_Append_Str " (
    Self in out nocopy JSON_String_T,
    i_Str  Varchar2
  ),
  
  -- ������� ����� ���� ������ JSON
  -- ������ ��� ����������� ����������
  final member procedure "_Open_New_Level " (
    Self in out nocopy JSON_String_T,
    i_Open_Char  Varchar2,
    i_Type_Char  Varchar2,
    i_Name       Varchar2 := NULL
  ),
  
  -- ������� ������� ���� ������ JSON
  -- ������ ��� ����������� ����������
  final member procedure "_Close_Cur_Level " (
    Self in out nocopy JSON_String_T,
    i_Close_Char  Varchar2,
    i_Type_Char   Varchar2
  ),
  
  -- �������� �������������� �������� � ������
  -- ������ ��� ����������� ����������
  final member procedure "_Put_In_List " (
    Self in out nocopy JSON_String_T,
    i_Quoted_Value  Varchar2
  ),
  
  -- �������� �������������� ���� ����-�������� � ������ JSON
  -- ������ ��� ����������� ����������
  final member procedure "_Put_In_Object " (
    Self in out nocopy JSON_String_T,
    i_Quoted_Key    Varchar2,
    i_Quoted_Value  Varchar2
  ),
  
  -- ���������, ������� �� JSON-������
  -- ����������� ���������� ����� ��������� � �������� ������
  final member function Is_Closed Return Boolean,
  
  -- ���������, ������� �� JSON-������ ��� ���������� ����� ���������
  final member function Is_Open Return Boolean,
  
  -- ��������������, JSON-������ �������
  -- ����������� ���������� ����������� ������ ��� �� �������� ������
  -- ��-�� ����������� �� �������� ����������� ������������ ���� ������ �������
  final member procedure Check_Closed (Self in JSON_String_T),
  
  -- ��������������, JSON-������ ������� ��� ���������� ����� ���������
  -- ����������� ���������� ����� ��������� � �������� ������
  -- ��-�� ����������� �� �������� ����������� ������������ ���� ������ �������
  final member procedure Check_Open (Self in JSON_String_T),
  
  -- ��������������, ��� �������� ��� ����� ������ ������������� ��������� ���� �����
  -- ��-�� ����������� �� �������� ����������� ������������ ���� ������ �������
  final member procedure Check_Level (
    Self in JSON_String_T,
    i_Level_Type  Varchar2,
    i_Level       Integer := NULL,
    i_Msg         Varchar2 := NULL
  ),
  
  
  -- ������� JSON-������
  -- � ������� �� ������ Close_JSON, ������� ��������� ������� JSON-������,
  -- ���������� ������� �������� ���� JSON-������
  -- ��� ����������� ����������� ���������� ����� ������ ���� ���������� ����������
  final member procedure Close (Self in out nocopy JSON_String_T),
  
  -- ������� ����� ������ JSON � �������� ������
  final member procedure Open_JSON (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  ),
  
  -- ������� ������� ������ JSON
  final member procedure Close_JSON (Self in out nocopy JSON_String_T),
  
  -- ������� ����� ������ �������� � �������� ������
  final member procedure Open_Array (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  ),
  
  -- ������� ������� ������ JSON
  final member procedure Close_Array (Self in out nocopy JSON_String_T),
  
  -- ������� ���� ����-�������� ��������� ���� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Varchar2
  ),
  
  -- ������� ���� ����-�������� ��������� ���� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- ������� ���� ����-�������� ���� ���� � ����� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- ������� ���� ����-�������� ����������� ���� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Boolean
  ),
  
  -- ������� �������� ���� �� ����� � ������� ������ JSON
  final member procedure Put_Null (
    Self in out nocopy JSON_String_T,
    i_Key  Varchar2
  ),
  
  
  -- ������� ���������� �������� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Varchar2
  ),
  
  -- ������� �������� �������� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- ������� �������� ���� ���� � ����� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- �������� ���������� �������� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Boolean
  ),
  
  -- �������� �������� "null" � ������� ������
  final member procedure Add_Null (Self in out nocopy JSON_String_T),
  
  
  -- ���������� �������� � ���� ������
  -- ���� ����� ������ ��������� 32�, �� ���������� ����������
  final member function To_String Return Varchar2,
  
  -- ���������� �������� � ���� ��������� ������ � �������� �������������
  final member function To_Raw_Array (i_Compress Varchar2 := NULL) Return Array_Raw,
  
  -- ���������� �������� � ���� ��������� �����
  final member function To_String_Array Return Array_Varchar2,
  
  -- ���������� �������� � ���� ������� CLOB
  final member function To_CLob Return CLob,
  
  -- ���������� �������� � ���� ������� BLOB
  final member function To_BLob Return BLob,
  
  -- ���������� �������� � ���� ��������� ����� ��� ���������� �����
  final member function Debug Return Array_Varchar2
  
)
final;
/
CREATE OR REPLACE TYPE BODY JSON_String_T
is

  -- ����������� ����� ��� ��������� ������ ���� ���������� ����
  -- ������������ ���� ������ ���������� ����������� ������ ���
  -- ��������� ������
  static function GetVersion return Varchar2
  is
  begin
    return '->>22102019<<-';
  end GetVersion;
  
  -- ����������� ��� �������� ������� ���������� ����
  Constructor Function JSON_String_T (
    Self in out nocopy JSON_String_T
  )
  Return Self as Result
  is
  begin
    Self.Init();      -- ���������������� �������� ����� ������
    return;           -- �������
  end JSON_String_T;
  
  -- ���������������� �������� ����� ������
  final member procedure Init (Self in out nocopy JSON_String_T)
  is
  begin
    Self."Level "       := 1;              -- ������� ������� �������� ����� ������
    Self."Levels "      := 'O';            -- ���� ������ ������ ��������� �������
    Self."Length "      := 0;              -- ����� ����� ������
    Self."Is_Empty "    := 'Y';            -- ������� ������� ��� ����
    Self."Compress "    := 'Y';            -- ����� ������ ��� �������� �� ����������� �����
    Self."Max_Length "  := 256*1024*1024;  -- ���������� ����� ������ (�� ��������� 256�)
    Self."Buf "         := '{';            -- �������� ����� ��� �������� JSON-������
    Self."Raw_Data "    := NULL;           -- ����������� ����� (���������������� ������ ��� �������������)
    --
    -- ���������������� ���������� �� �������������� ������
    Self.Set_Formats (
      i_Def_CharSet => 'CL8MSWIN1251',
      i_Fmt_Number  => 'FM99999999999999999990.99999999999999999999',
      i_Fmt_Date    => 'dd.mm.yyyy',
      i_Fmt_Time    => 'dd.mm.yyyy hh24:mi:ss');
    -- ���������������� ���������� �� ��������� �� ���������
    Self.Set_Defaults (
      i_Null_Number  => '""',     -- �������� �������� �������� NULL �� "0"
      i_Null_Boolean => '""',     -- �������� ��������� �������� NULL �� "false"
      i_Null_Date    => '""');    -- �������� NULL-���� �� ������ ������
  end Init;
  
  -- ���������������� ���������� �� �������������� ������
  final member procedure Set_Formats (
    Self in out nocopy JSON_String_T,
    i_Def_CharSet  Varchar2 := NULL,     -- ��������� �������� �� ���������
    i_Fmt_Number   Varchar2 := NULL,     -- ������ �������� ��������� ����
    i_Fmt_Date     Varchar2 := NULL,     -- ������ �������� ���� ����
    i_Fmt_Time     Varchar2 := NULL      -- ������ �������� ���� ���� � �����
  )
  is
  begin
    -- ���������������� ���������� �� �������������� ������
    Self."Def_CharSet " := NVL(i_Def_CharSet, Self."Def_CharSet ");  -- ��������� �������� �� ���������
    Self."Fmt_Number "  := NVL(i_Fmt_Number,  Self."Fmt_Number ");   -- ������ �������� ��������� ����
    Self."Fmt_Date "    := NVL(i_Fmt_Date,    Self."Fmt_Date ");     -- ������ �������� ���� ����
    Self."Fmt_Time "    := NVL(i_Fmt_Time,    Self."Fmt_Time ");     -- ������ �������� ���� ���� � �����
  end Set_Formats;
  
  -- ���������������� ���������� � ��������� �� ���������
  final member procedure Set_Defaults (
    Self in out nocopy JSON_String_T,
    i_Null_Number  Varchar2 := NULL,     -- �������� ��� ������ NULL-�����
    i_Null_Boolean Varchar2 := NULL,     -- �������� ��� ������ NULL-Boolean
    i_Null_Date    Varchar2 := NULL      -- �������� ��� ������ NULL-����
  )
  is
  begin
    -- ���������������� ���������� �� ��������� �� ���������
    Self."Null_Number "  := NVL(i_Null_Number,  Self."Null_Number ");
    Self."Null_Boolean " := NVL(i_Null_Boolean, Self."Null_Boolean ");
    Self."Null_Date "    := NVL(i_Null_Date,    Self."Null_Date ");
  end Set_Defaults;
  
  -- ������ ������� ������ ������ ��� �������� �� ����������� �����
  -- ��������� ������� �������� � "Y" (�� ���������) ��������� ���������
  -- ����������� ������ ��� �������������� �������� ������������������
  final member procedure Set_Compress (
    Self in out nocopy JSON_String_T,
    i_Compress  Varchar2 := 'Y'
  )
  is
  begin
    -- ���������������� ���������� �� �������������� ������
    Self."Compress " := i_Compress;
  end Set_Compress;
  
  -- ������������ ���������� � ��������  ����� ������ � ���������� �� ������
  final member procedure Error (
    Self          in JSON_String_T,
    i_Error_Code  in PLS_Integer := 0,
    i_Error_Msg   in Varchar2
  )
  is
  begin
    -- ������������ ���������� � ��������  ����� ������ � ���������� �� ������
    Raise_Application_Error(-20000 - i_Error_Code, i_Error_Msg || Chr(10) || '�������: ' || Self."Length ");
    --
    -- ������� ������������� ���, ����� ������� ���������� ���������
    if Self is NULL then
      NULL;  -- ������� �� ����� �����������, �� ������� ���������� ���������
    end if;
  end Error;
  
  -- ���������� ����� ������
  final member function Get_Length Return Integer
  is
  begin
    return Self."Length ";
  end Get_Length;
  
  -- ���������� ������� ����������� �������� �����
  final member function Get_Level Return Integer
  is
  begin
    return Self."Level ";
  end Get_Level;
  
  -- ���������� ���������� ���������� ������� ��� �������� ������,
  -- ������� �������� � ����������� ������
  final member function Get_Buf_Count Return Integer
  is
  begin
    return case when Self."Raw_Data " is NULL
             then 1 else Self."Raw_Data ".Count + 1
           end;
  end Get_Buf_Count;
  
  -- ����������� ������� ������� ������
  final member function Cast_To_Raw (i_Str Varchar2) Return Raw
  is
  begin
    return UTL_i18n.String_To_Raw(i_Str, Self."Def_CharSet ");
  end Cast_To_Raw;
  
  -- ����������� ������� ������� ������
  final member function Cast_To_String (i_Raw Raw) Return Varchar2
  is
  begin
    return UTL_i18n.Raw_To_Char(i_Raw, Self."Def_CharSet ");
  end Cast_To_String;
  
  -- ������������� �������� ������ � JSON-����������� ������
  -- ����������� ����������� ������� � Escape-������������������
  final static function Cast_To_JSON (i_Str Varchar2) return Varchar2
  is
  begin
    return Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(i_Str,
      '\', '\\'), '/', '\/'), '"', '\"'), Chr(8), '\b'), Chr(9), '\t'),
      Chr(10), '\r'), Chr(12), '\f'), Chr(13), '\n');
  end Cast_To_JSON;
  
  -- ��������� ������ � �������� �������������
  final member function Compress_Raw (i_Raw Raw) Return Raw
  is
  begin
    return UTL_Compress.LZ_Compress(i_Raw);
  end Compress_Raw;
  
  -- ��������� ������ � ���������� �������������
  final member function Compress_Str (i_Str Varchar2) Return Raw
  is
  begin
    return Self.Compress_Raw(UTL_i18n.String_To_Raw(i_Str, Self."Def_CharSet "));
  end Compress_Str;
  
  -- ����������� ������ ������ � ���������� ��������� � �������� �������������
  final member function Uncompress_To_Raw (i_Raw Raw) Return Raw
  is
  begin
    return UTL_Compress.LZ_Uncompress(i_Raw);
  end Uncompress_To_Raw;
  
  -- ����������� ������ ������ � ���������� ��������� � ���������� �������������
  final member function Uncompress_To_Str (i_Raw Raw) Return Varchar2
  is
  begin
    return UTL_i18n.Raw_To_Char(Self.Uncompress_To_Raw(i_Raw), Self."Def_CharSet ");
  end Uncompress_To_Str;
  
  -- ������������� �������� ����������� ���� � ������ JSON
  -- ������� ������� ������� �� ������ � ����� ������
  -- ������������ � ������ ������� � ����������� ������� ���������� � JSON-����������� �������
  final member function Format (i_Str Varchar2) Return Varchar2
  is
  begin
    return '"' || JSON_String_T.Cast_To_JSON(i_Str) || '"';
  end Format;
  
  -- ������������� �������� ��������� ���� � ������ JSON
  final member function Format (i_Value Number, i_Fmt Varchar2 := NULL) Return Varchar2
  is
  begin
    if i_Value is NULL then
      return NVL(Self."Null_Number ", '""');
    elsif Trunc(i_Value) = i_Value then
      return To_Char(i_Value, NVL(i_Fmt, 'FM99999999999999999999'));
    else
      return To_Char(i_Value, NVL(i_Fmt, Self."Fmt_Number "));
    end if;
  end Format;
  
  -- ������������� �������� ���� ���� � ����� � ������ JSON
  final member function Format (i_Value Date, i_Fmt Varchar2 := NULL) Return Varchar2
  is
  begin
    if i_Value is NULL then
      return NVL(Self."Null_Date ", '""');
    elsif i_Fmt is NULL and i_Value = Trunc(i_Value) then
      return '"' || To_Char(i_Value, Self."Fmt_Date ") || '"';
    else
      return '"' || To_Char(i_Value, NVL(i_Fmt, Self."Fmt_Time ")) || '"';
    end if;
  end Format;
  
  -- ������������� �������� ���� ���� � ����� � ������ JSON
  final member function Format (i_Value Boolean) Return Varchar2
  is
  begin
    if i_Value is NULL then
      return NVL(Self."Null_Boolean ", '""');
    elsif i_Value then
      return 'true';
    else
      return 'false';
    end if;
  end Format;
  
  
  -- ����������� ���� ����-�������� ��� ������� � ������� JSON
  -- ��� �������������� �������� ���������� ������� 
  -- ������ ��� ����������� ����������
  final member function "_Make_Comma_Name " (i_Name Varchar2) Return Varchar2
  is
    v_Comma Varchar2(1) := case Self."Is_Empty "
                             when 'N' then ',' else ''
                           end;
  begin
    if SubStr(Self."Levels ", Self."Level ", 1) = 'O' then
      return v_Comma || Self.Format(i_Name) || ':';
    else
      return v_Comma;
    end if;
  end "_Make_Comma_Name ";
  
  -- ���������� �������� � ���� ��������� �����
  -- ������ ��� ����������� ����������
  final member function "_Extract_Raw_Data " (
    i_Index      Integer,
    i_Compress   Varchar2 := 'Y',
    i_Debugging  Boolean  := False
  )
  Return Raw
  is
    v_Buf_Compr  Boolean     := (NVL(Self."Compress ", 'N') in ('Y', 'y'));
    v_Out_Compr  Boolean     := (NVL(i_Compress, 'Y') in ('Y', 'y'));
    v_Buf_Count  PLS_Integer := Self.Get_Buf_Count;
  begin
    --
    if Self."Level " > 0 and not i_Debugging then
      Self.Error(1, '��� ���������� ������ ���������� ������� ������ JSON!');
    elsif Self."Length " <= 0 or i_Index < 1 or i_Index > v_Buf_Count then
      -- ������ �����, ��� ����� �������� ����� �����
      return NULL;     -- ���������� ������ ��������
    elsif i_Index = v_Buf_Count then
      -- ���������� ���������� ��������� ������
      return case when v_Out_Compr
               then Self.Compress_Str(Self."Buf ")
               else Self.Cast_To_Raw(Self."Buf ")
             end;
    elsif v_Buf_Compr = v_Out_Compr then
      -- ����� ��� �������� ��� �������� �� ���������
      return Self."Raw_Data "(i_Index);
    elsif v_Buf_Compr then
      -- ����� ��������, ���������� �����������
      return Self.Uncompress_To_Raw(Self."Raw_Data "(i_Index));
    else
      -- ����� �� ��������, ���������� ���������
      return Self.Compress_Raw(Self."Raw_Data "(i_Index));
    end if;
  end "_Extract_Raw_Data ";
  
  -- ���������������� �������� ����� ������
  -- ������ ��� ����������� ����������
  final member procedure "_Flash_Buf " (Self in out nocopy JSON_String_T)
  is
    v_Ind  PLS_Integer;
  begin
    -- ������ �� ������, ���� �������� ����� ����
    if Self."Buf " is NULL then
      return;
    elsif Self."Length " + 32767 > Self."Max_Length " then
      -- ��������� ����������� ���������� ����� JSON-������
      Raise_Application_Error(-20000, '��������� ���������� ����� JSON-������ (' || Self."Max_Length " || ')!');
    elsif Self."Raw_Data " is NULL then
      -- ���������������� ����������� �����
      Self."Raw_Data " := Array_Raw();
    end if;
    -- ��������� ����������� �����
    Self."Raw_Data ".Extend;
    v_Ind := Self."Raw_Data ".Count;
    --
    -- ��������� ���������� ��������� ������ � ����������� �����
    if Self."Compress " = 'Y' then
      -- ��������� �� �������
      Self."Raw_Data "(v_Ind) := UTL_Compress.LZ_Compress(Self.Cast_To_Raw(Self."Buf "));
    else
      -- ��������� ��� ������
      Self."Raw_Data "(v_Ind) := UTL_i18n.String_To_Raw(Self."Buf ");
    end if;
    -- �������� �������� �����
    Self."Buf " := '';
  end "_Flash_Buf ";
  
  -- ���������������� �������� ����� ������
  -- ������ ��� ����������� ����������
  final member procedure "_Append_Str " (
    Self in out nocopy JSON_String_T,
    i_Str  Varchar2
  )
  is
    v_Str_Len  PLS_Integer := NVL(Lengthb(i_Str), 0);
  begin
    -- ��������������, ��� ������ �������
    Self.Check_Open();
    -- ���� ������ ������ �� ��������� ������� ������
    if v_Str_Len + Lengthb(Self."Buf ") > 32767 then
      -- ��������� ���������� ��������� ������ � ����������� �����
      Self."_Flash_Buf "();
      -- �������� ������ � �������� �����
      Self."Buf " := i_Str;
    else
      -- �������� ������ � ����� ��������� ������
      Self."Buf " := Self."Buf " || i_Str;
    end if;
    -- �������� ������ JSON-������
    Self."Length " := Self."Length " + v_Str_Len;
  end "_Append_Str ";
  
  -- ������� ����� ���� ������ JSON
  -- ������ ��� ����������� ����������
  final member procedure "_Open_New_Level " (
    Self in out nocopy JSON_String_T,
    i_Open_Char  Varchar2,
    i_Type_Char  Varchar2,
    i_Name       Varchar2 := NULL
  )
  is
  begin
    -- ��������� ���������� ������� �����������
    if Self."Level " >= 32767 then
      Self.Error(6, '������� ����� ������� ����������� ��������!');
    end if;
    -- ������� ����� ���� ������ JSON
    Self."_Append_Str "(Self."_Make_Comma_Name "(i_Name) || i_Open_Char);
    --
    Self."Level "      := Self."Level " + 1;
    Self."Levels "     := Self."Levels " || i_Type_Char;
    -- ���������� ������� ������� ������
    Self."Is_Empty "   := 'Y';
  end "_Open_New_Level ";
  
  -- ������� ������� ���� ������ JSON
  -- ������ ��� ����������� ����������
  final member procedure "_Close_Cur_Level " (
    Self in out nocopy JSON_String_T,
    i_Close_Char  Varchar2,
    i_Type_Char   Varchar2
  )
  is
  begin
    -- ��������� ��� � ��������� ������
    Self.Check_Level(i_Type_Char, i_Msg => '������� �������� ����� ������������������ ����');
    -- ������� ������� ���� ������ JSON
    Self."_Append_Str "(i_Close_Char);
    --
    Self."Level "      := Self."Level " - 1;
    Self."Levels "     := SubStr(Self."Levels ", 1, Self."Level ");
    -- �������� ������� ������� ������
    Self."Is_Empty "   := 'N';
  end "_Close_Cur_Level ";
  
  -- �������� �������������� �������� � ������
  -- ������ ��� ����������� ����������
  final member procedure "_Put_In_List " (
    Self in out nocopy JSON_String_T,
    i_Quoted_Value  Varchar2
  )
  is
    v_Comma  Varchar2(1) := case Self."Is_Empty "
                              when 'N' then ',' else ''
                            end;
  begin
    -- ��������������, ��� �������� ����������� � ������
    Self.Check_Level('L', i_Msg => '������� ������� ���� �������-��������, ����� ��������� ��������� ��������');
    --
    -- �������� �������� � ����� ������
    Self."_Append_Str " (v_Comma || i_Quoted_Value);
    -- �������� ������� ������� ������
    Self."Is_Empty " := 'N';
  end "_Put_In_List ";
  
  -- �������� �������������� ���� ����-�������� � ������ JSON
  -- ������ ��� ����������� ����������
  final member procedure "_Put_In_Object " (
    Self in out nocopy JSON_String_T,
    i_Quoted_Key    Varchar2,
    i_Quoted_Value  Varchar2
  )
  is
    v_Comma  Varchar2(1) := case Self."Is_Empty "
                              when 'N' then ',' else ''
                            end;
  begin
    -- ��������������, ��� ���� ����-�������� ����������� � JSON-������
    Self.Check_Level('O', i_Msg => '������� ������� ���������� ��������, ����� ��������� �������-��������');
    --
    -- �������� ���� ����-�������� � ����� ������
    Self."_Append_Str " (v_Comma || i_Quoted_Key || ':' || i_Quoted_Value);
    -- �������� ������� ������� �������
    Self."Is_Empty " := 'N';
  end "_Put_In_Object ";
  
  -- ���������, ������� �� JSON-������
  -- ����������� ���������� ����� ��������� � �������� ������
  final member function Is_Closed Return Boolean
  is
  begin
    -- ��� �������� ������ ������� ����� ��������� "0"
    return (Self."Level " <= 0);
  end Is_Closed;
  
  -- ���������, ������� �� JSON-������ ��� ���������� ����� ���������
  final member function Is_Open Return Boolean
  is
  begin
    -- ��� �������� ������ ������� ����� ������ "0"
    return (Self."Level " > 0);
  end Is_Open;
  
  -- ��������������, JSON-������ �������
  -- ����������� ���������� ����������� ������ ��� �� �������� ������
  -- ��-�� ����������� �� �������� ����������� ������������ ���� ������ �������
  final member procedure Check_Closed (Self in JSON_String_T)
  is
  begin
    -- ���� ������ �� �������
    if Self."Level " > 0 then  -- ���������� ���������� ��� ������ Is_Open
      Self.Error(11, 'JSON-������ ��� �� �������!');  -- ������ �� �������
    elsif Self."Length " <= 0 or Self."Buf " is NULL then
      Self.Error(12, 'JSON-������ �����!');           -- ������ �� ����� ���� ������
    end if;
  end Check_Closed;
  
  -- ��������������, JSON-������ ������� ��� ���������� ����� ���������
  -- ����������� ���������� ����� ��������� � �������� ������
  -- ��-�� ����������� �� �������� ����������� ������������ ���� ������ �������
  final member procedure Check_Open (Self in JSON_String_T)
  is
  begin
    -- ��� �������� ������ ������� ����� ������ "0"
    if Self."Level " <= 0 then  -- ���������� ���������� ��� ������ Is_Closed
      Self.Error(13, 'JSON-������ ��� �������!');
    end if;
  end Check_Open;
  
  -- ��������������, ��� �������� ��� ����� ������ ������������� ��������� ���� �����
  -- ��-�� ����������� �� �������� ����������� ������������ ���� ������ �������
  final member procedure Check_Level (
    Self in JSON_String_T,
    i_Level_Type  Varchar2,
    i_Level       Integer  := NULL,
    i_Msg         Varchar2 := NULL
  )
  is
    v_Level  Integer := NVL(i_Level, Self."Level ");
  begin
    -- ��������� ��� � ����������� �������� ������
    if Self."Level " <= 0 then  -- ���������� ���������� ��� ������ Is_Closed
      Check_Open();             -- ��� ��������� ������ ���������� ����� Check_Open
    elsif SubStr(Self."Levels ", v_Level, 1) != i_Level_Type then
      if i_Msg is NULL then
        Self.Error(8, '�������������� ������!');
      else
        Self.Error(8, '�������������� ������: ' || i_Msg || '!');
      end if;
    end if;
  end Check_Level;
  
  -- ������� JSON-������
  -- � ������� �� ������ Close_JSON, ������� ��������� ������� JSON-������,
  -- ���������� ������� �������� ���� JSON-������
  -- ��� ����������� ����������� ���������� ����� ������ ���� ���������� ����������
  final member procedure Close (Self in out nocopy JSON_String_T)
  is
  begin
    --
    if Self."Level " > 1 then
      Self.Error(9, '�������������� ������: ������� �������� �������������� ������� JSON!');
    end if;
    -- ������� JSON-������
    Self.Close_JSON();
  end Close;
  
  -- ������� ����� ������ JSON � �������� ������
  final member procedure Open_JSON (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  )
  is
  begin
    -- ������� ����� ������ JSON
    Self."_Open_New_Level "('{', 'O', i_Name);
  end Open_JSON;
  
  -- ������� ������� ������ JSON
  final member procedure Close_JSON (Self in out nocopy JSON_String_T)
  is
  begin
    -- ������� ������� ������ JSON
    Self."_Close_Cur_Level "('}', 'O');
  end Close_JSON;
  
  -- ������� ����� ������ �������� � �������� ������
  final member procedure Open_Array (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  )
  is
  begin
    -- ������� ����� ������ JSON
    Self."_Open_New_Level "('[', 'L', i_Name);
  end Open_Array;
  
  -- ������� ������� ������ JSON
  final member procedure Close_Array (Self in out nocopy JSON_String_T)
  is
  begin
    -- ������� ������� ������ JSON
    Self."_Close_Cur_Level "(']', 'L');
  end Close_Array;
  
  -- ������� ���� ����-�������� ��������� ���� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Varchar2
  )
  is
  begin
    -- �������� �������������� ���� ����-�������� � ������ JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value));
  end Put;
  
  -- ������� ���� ����-�������� ��������� ���� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- �������� �������������� ���� ����-�������� � ������ JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value, i_Fmt));
  end Put;
  
  -- ������� ���� ����-�������� ���� ���� � ����� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- �������� �������������� ���� ����-�������� � ������ JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value, i_Fmt));
  end Put;
  
  -- ������� ���� ����-�������� ����������� ���� � ������� ������ JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Boolean
  )
  is
  begin
    -- �������� �������������� ���� ����-�������� � ������ JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value));
  end Put;
  
  -- ������� �������� ���� �� ����� � ������� ������ JSON
  final member procedure Put_Null (
    Self in out nocopy JSON_String_T,
    i_Key  Varchar2
  )
  is
  begin
    -- �������� �������������� ���� ����-�������� � ������ JSON
    Self."_Put_In_Object " (Self.Format(i_Key), 'null');
  end Put_Null;
  
  
  -- ������� ���������� �������� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Varchar2
  )
  is
  begin
    -- �������� �������� � ������� ������
    Self."_Put_In_List " (Self.Format(i_Value));
  end Add_Elem;
  
  -- ������� �������� �������� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- �������� �������� � ������� ������
    Self."_Put_In_List " (Self.Format(i_Value, i_Fmt));
  end Add_Elem;
  
  -- ������� �������� ���� ���� � ����� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- �������� �������� � ������� ������
    Self."_Put_In_List " (Self.Format(i_Value, i_Fmt));
  end Add_Elem;
  
  -- �������� ���������� �������� � ������� ������
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Boolean
  )
  is
  begin
    -- �������� ���������� �������� � ������
    Self."_Put_In_List " (Self.Format(i_Value));
  end Add_Elem;
  
  -- �������� �������� "null" � ������� ������
  final member procedure Add_Null (Self in out nocopy JSON_String_T)
  is
  begin
    -- �������� "null" � ������
    Self."_Put_In_List " ('null');
  end Add_Null;
  
  
  -- ���������� �������� � ���� ������
  -- ���� ����� ������ ��������� 32�, �� ���������� ����������
  final member function To_String Return Varchar2
  is
  begin
    -- ��������������, ��� ������ �������
    Self.Check_Closed();
    -- ���� ����������� ����� �� ����
    if Self."Raw_Data " is not NULL and Self."Raw_Data ".Count > 0 then
      -- ��������� �� ���������� � �����
      Error(99, '������ �� ���������� � ������!');
    end if;
    -- ���������� �������� � ���� ������
    return Self."Buf ";
  end To_String;
  
  -- ���������� �������� � ���� ��������� ������ � �������� �������������
  final member function To_Raw_Array (i_Compress Varchar2 := NULL) Return Array_Raw
  is
    Result  Array_Raw := Array_Raw();
  begin
    -- ��������������, ��� ������ �������
    Self.Check_Closed();
    --
    -- �������� � ����� ���������� ������ (������� �������� �����)
    for I in 1..Self.Get_Buf_Count
    loop
      Result.Extend;
      Result(Result.Count) := Self."_Extract_Raw_Data "(I, i_Compress);
    end loop;
    -- ���������� ���������
    return Result;
  end To_Raw_Array;
  
  -- ���������� �������� � ���� ��������� �����
  final member function To_String_Array Return Array_Varchar2
  is
    Result       Array_Varchar2 := Array_Varchar2();
    v_Buf_Count  PLS_Integer    := Self.Get_Buf_Count;
  begin
    -- ��������������, ��� ������ �������
    Self.Check_Closed();
    --
    for I in 1..v_Buf_Count
    loop
      -- �������� ��������� ���� � ���������
      Result.Extend;
      if I = v_Buf_Count then
        Result(I) := Self."Buf ";
      else
        Result(I) := Self.Cast_To_String(Self."_Extract_Raw_Data "(I, 'N'));
      end if;
    end loop;
    -- ���������� ���������
    return Result;
  end To_String_Array;
  
  -- ���������� �������� � ���� ������� CLOB
  final member function To_CLob Return CLob
  is
    Result  CLob;
    v_Buf   Varchar2(32767);
  begin
    -- ��������������, ��� ������ �������
    Self.Check_Closed();
    --
    -- ��������� ������ �������� ������ � ���������
    Result := Self.Cast_To_String(Self."_Extract_Raw_Data "(1, 'N'));
    --
    -- ���������� �������� � ���� ������� CLOB
    for I in 2..Self.Get_Buf_Count
    loop
      -- ��������� ��������� ���� ������
      v_Buf := Self.Cast_To_String(Self."_Extract_Raw_Data "(I, 'N'));
      -- �������� �������� ������ � ���������
      DBMS_Lob.WriteAppend(Result, Lengthb(v_Buf), v_Buf);
    end loop;
    -- ���������� �������� � ���� ������� CLOB
    return Result;
  end To_CLob;
  
  -- ���������� �������� � ���� ������� BLOB
  final member function To_BLob Return BLob
  is
    Result  BLob;
    v_Buf   Raw(32767);
  begin
    -- ��������������, ��� ������ �������
    Self.Check_Closed();
    --
    -- ��������� ������ �������� ������ � ���������
    Result := Self."_Extract_Raw_Data "(1, 'N');
    --
    -- ���������� �������� � ���� ������� CLOB
    for I in 2..Self.Get_Buf_Count
    loop
      -- ��������� ��������� ���� ������
      v_Buf := Self."_Extract_Raw_Data "(I, 'N');
      -- �������� �������� ������ � ���������
      DBMS_Lob.WriteAppend(Result, UTL_Raw.Length(v_Buf), v_Buf);
    end loop;
    -- ���������� �������� � ���� ������� CLOB
    return Result;
  end To_BLob;
  
  
  -- ���������� �������� � ���� ��������� ����� ��� ���������� �����
  final member function Debug Return Array_Varchar2
  is
    Result  Array_Varchar2 := Array_Varchar2();
  begin
    for I in 1..Self.Get_Buf_Count
    loop
      -- �������� ��������� ���� � ���������
      Result.Extend;
      Result(I) := Self.Cast_To_String(Self."_Extract_Raw_Data "(I, 'N', True));
    end loop;
    -- ���������� ���������
    return Result;
  end Debug;
  
  
  
end;
/
