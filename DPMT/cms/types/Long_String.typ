CREATE OR REPLACE TYPE Long_String force as Object (
--
-- Author   : �������� �.�.
-- Created  : 18.01.2018 04:21:17
-- Version  : ->>27112020<<-
-- System   : ���� 6.5.0
-- Subsystem: ���� ���� 6.5.0
-- Purpose  : ��������� ��� ��� ����������� ��������� � PL/SQL ������� �����
--            ��������� ������� � ���������� � ������ ������� �����
--            �������� ������� �������, ��� ������ ���� CLOB
--            ����� ����������� ������ ������� String, StringBuffer � StringBuilder
--            ����� Java
  
  
  -- ��������� ��������� ������ (��������� � �������, ����� ���������
  -- ������������� �����)
  "Cur_Pos "   Integer,         -- ������� ���������
  "Buf_Size "  Integer,         -- ����� ����� ������
  "Buf "       Array_Varchar2,  -- �����������-�������������� ����� ��� ������
  
  
  -- ����������� ����� ��� ��������� ������ ���� ���������� ����
  -- ������������ ���� ������ ���������� ����������� ������ ���
  -- ��������� ������
  static function GetVersion return Varchar2,
  
  
  -- ����������� ��� �������� ������ ������� ���������� ����
  Constructor Function Long_String (
    Self in out nocopy Long_String
  )
  Return Self as Result,
  
  -- ����������� ��� �������� ������ ���������� ���� �� ������
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Varchar2
  )
  Return Self as Result,
  
  -- ����������� ��� �������� ������ ���������� ���� �� ��������� �����
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Array_Varchar2
  )
  Return Self as Result,
  
  -- ����������� ��� �������� ������ ���������� ���� �� LOB-�������
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in CLob
  )
  Return Self as Result,
  
  -- ���������������� �������� ����� ������
  final member procedure Init (Self in out nocopy Long_String),
  
  -- ����������� ������� ������� ������
  final member function Clone Return Long_String,
  
  -- ��������� ������ ������ ������� ������ ������
  final member procedure Recalc_Size (Self in out nocopy Long_String),
  
  
  -- ������������ ���������� � ��������  ����� ������ � ���������� �� ������
  final member procedure Error (
    Self          in Long_String,
    i_Error_Msg   in Varchar2,
    i_Error_Code  in PLS_Integer := 0
  ),
  
  
  -- ���������� ������� ������ � ������
  final member function Get_Index Return Integer,
  
  -- ���������� ����� ������
  final member function Get_Length Return Integer,
  
  -- ���������� �������� � ���� ������
  -- ���� ����� ������ ��������� 32�, �� ���������� ����������
  final member function To_String Return Varchar2,
  
  -- ���������� �������� � ���� ��������� �����
  final member function To_String_Array Return Array_Varchar2,
  
  -- ���������� �������� � ���� ������� CLOB
  final member function To_CLob Return CLob,
  
  
  -- �������� �������� ������ � ����� ������ ������� ������
  final member procedure Append (
    Self  in out nocopy Long_String,
    i_Str in Varchar2
  ),
  
  -- �������� �������� ��������� ����� � ����� ������ ������� ������
  final member procedure Append (
    Self   in out nocopy Long_String,
    i_List in Array_Varchar2
  ),
  
  -- �������� �������� ������� ������ � ����� ������ ������� ������
  final member procedure Append (
    Self     in out nocopy Long_String,
    i_String in Long_String
  ),
  
  -- �������� ���������� ������� CLOB � ����� ������ ������� ������
  final member procedure Append (
    Self      in out nocopy Long_String,
    i_Lob_Loc in CLob
  ),
  
  
  -- ���������� ������ �� ��������� ������� � ������
  final member function Get_Char (i_Pos Integer := NULL) Return Varchar2,
  
  -- ���������� ASCII-��� ������� �� ��������� ������� � ������
  final member function Get_Char_Code (i_Pos Integer := NULL) Return PLS_Integer,
  
  -- �������� ������, � ������� ��������� ������ � �������� �������
  final member function Get_Line (
    i_Pos        Integer := NULL,
    i_Whole_Line Boolean := False
  )
  Return Varchar2,
  
  -- �������� ������, � ������� ��������� ������ � �������� �������
  -- � ������ ������� � ��������� ������ � ������ � ����� ������
  final member function Get_Line_Trim (
    i_Pos        Integer  := NULL,
    i_Whole_Line Boolean  := False,
    i_TSet       Varchar2 := ' ' || Chr(9)
  )
  Return Varchar2,
  
  -- ���������� ������ ������ ������� ������
  final member function Get_First_Char Return Varchar2,
  
  -- ���������� ��������� ������ ������� ������
  final member function Get_Last_Char Return Varchar2,
  
  -- ���������� �� ������ ��������� ������ � ��������� �������
  final member function Get_Next_Char (i_Pos Integer := NULL) Return Varchar2,
  
  -- ���������� �� ������ ���������� ������ � ��������� �������
  final member function Get_Prev_Char (i_Pos Integer := NULL) Return Varchar2,
  
  -- ������� � ���������� ������� � ������
  -- ���������� ���������������� ������� ��������� Next � ������� Get_Char
  final member function Go_To_Next_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2,
  
  -- ������� � ����������� ������� � ������
  -- ���������� ���������������� ������� ��������� Prev � ������� Get_Char
  final member function Go_To_Prev_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2,
  
  -- ���������, ��������� �� ����� ������
  final member function Is_Line_End (i_Pos Integer := NULL) Return Boolean,
  
  -- ���������, ��������� �� ����� ������
  final member function Is_End (i_Pos Integer := NULL) Return Boolean,
  
  -- ������� � ������� �������
  final member procedure First (Self in out nocopy Long_String),
  
  -- ������� � ������ ������ ������
  final member procedure First_Line (Self in out nocopy Long_String),
  
  -- ������� � ���������� �������
  final member procedure Last (Self in out nocopy Long_String),
  
  -- ������� � ������ ��������� ������
  final member procedure Last_Line (Self in out nocopy Long_String),
  
  -- ���������� ������� ������ �� �������� �������
  final member procedure Move_Pos (
    Self in out nocopy Long_String,
    i_New_Pos  Integer
  ),
  
  -- ����������� ������� ������ �� �������� ���������� ��������
  final member procedure Move_Pos_By (
    Self in out nocopy Long_String,
    i_Increment  Integer
  ),
  
  -- ������� � ���������� �������
  final member procedure Next (Self in out nocopy Long_String),
  
  -- ������� � ��������� ������
  final member procedure Next_Line (Self in out nocopy Long_String),
  
  -- ������� � ����������� �������
  final member procedure Prev (Self in out nocopy Long_String),
  
  -- ������� � ���������� ������
  final member procedure Prev_Line (Self in out nocopy Long_String),
  
  
  -- ����� � ������� ������ ��������� � �������� �������
  final member function Find_SubStr (
    i_SubStr  Varchar2,
    i_Pos     Integer := NULL
  )
  Return Integer,
  
  -- ����� � ������� ������ ��������� � �������� �������
  final member function Find_SubStr_Back (
    i_SubStr  Varchar2,
    i_Pos     Integer := NULL
  )
  Return Integer,
  
  
  -- ����� � ������ ��������� ������, ����������� ������� ������
  -- ������ ��� ����������� ����������
  final member function Find_Char_For_Set (
    i_Set     Varchar2,
    i_Pos     Integer := NULL,
    i_In_Set  Boolean := True
  )
  Return Integer,
  
  -- ����� � ������ ���������� ������, ����������� ������� ������
  final member function Find_Char_For_Set_Back (
    i_Set     Varchar2,
    i_Pos     Integer := NULL,
    i_In_Set  Boolean := True
  )
  Return Integer,
  
  -- ����� � ������ ������, �������� � �������� ����� ��������
  final member function Find_Char_In_Set  (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer,
  
  -- ����� � ������ ������, �� �������� � �������� ����� ��������
  final member function Find_Char_Not_In_Set  (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer,
  
  -- ����� ������� ���������� �� ������������ �������� �������
  final member function Find_None_Blank_Char (i_Pos Integer := NULL) Return Integer,
  
  -- ����� � ������ ��������� �� "�����" ������
  final member function Find_None_White_Char (i_Pos Integer := NULL) Return Integer,
  
  -- ����� � ��������� �� ������ ��������� ��� ��������������
  -- ���������� ������� ������� ������� ����� ����� ��������������
  -- ��� ������������� ���������� ������� � ������ "�����" �������
  final member function Find_Identifier (
    io_Pos      in out nocopy Integer,
    o_Token_Pos    out nocopy Integer,
    i_To_Upper_Case  Boolean  := True,
    i_Skip_Blanks    Varchar2 := 'B'
  )
  Return Varchar2,
  
  -- �������� ��������� �������
  -- ��� ������������� ���������� ������� � ������ "�����" �������
  final member procedure Find_Identifier (
    Self  in out nocopy Long_String,
    o_Token_Pos      out nocopy Integer,
    o_Token          out nocopy Varchar2,
    i_To_Upper_Case   Boolean  := True,
    i_Skip_Blanks     Varchar2 := 'B',
    i_Move_Before     Boolean  := True,
    i_Move_After      Boolean  := True,
    i_Pos             Integer  := NULL
  ),
  
  -- ������������ ������� � ������� ���������
  final member procedure Skip_Blanks (Self in out nocopy Long_String),
  
  -- ������������ "�����" �������
  -- ���������� �������, ��������� � ������� ����� ������
  final member procedure Skip_White_Chars (Self in out nocopy Long_String),
  
  -- �������� ��������� � �������� ������� � � �������� ������
  final member function Sub_Str (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Varchar2,
  
  -- �������� ������� ��������� � �������� ������� � � �������� ������
  -- � ���� ��������� �����
  final member function Sub_Str_Array (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Array_Varchar2,
  
  -- �������� ������� ��������� � �������� ������� � � �������� ������
  final member function Sub_Str_Long (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Long_String,
  
  -- ����������� �� ������� ������ ��������� �� ��������, ����������
  -- � ������� ������ �������� ����������-������������
  final member function Sub_Str_Items (
    i_Delimeter  Varchar2 := Chr(10),
    i_Pos        Integer  := 1,
    i_Len        Integer  := NULL
  )
  Return Array_Varchar2,
  
  -- �������� �� ������� ������ ��������� �� �������� � �������� ���������,
  -- ���������� � ������� ������ �������� ����������-������������
  final member function Sub_Str_Lines (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Array_Varchar2,
  
  -- ��������� ������� ������ � �������� �������
  final member function Concat (i_Str Varchar2) Return Long_String,
  
  -- ��������� ������� ������ � �������� ���������� �����
  final member function Concat (i_Str Array_Varchar2) Return Long_String,
  
  -- ��������� ������� ������ � �������� ������� �������
  final member function Concat (i_Str Long_String) Return Long_String,
  
  -- ������� � ������ �������� ���������� ��������, ������� � �������� �������
  -- � ���������� ���������
  final member function Remove (i_Pos Integer, i_Len Integer) Return Long_String,
  
  -- �������� � ������ �������� ��������� � �������� ������� � ���������� ���������
  final member function Insert_Str (i_Str Varchar2, i_Pos Integer) Return Long_String,
  
  -- �������� ������� ������ � �������� �������
  final member function Equals (i_Str Varchar2) Return Boolean,
  
  -- �������� ������� ������ � �������� ������� �������
  final member function Equals (i_Str Long_String) Return Boolean,
  
  -- �������� ������� ������ � �������� ������� ��� ����� �������� ����
  final member function Equals_Ignore_Case (i_Str Varchar2) Return Boolean,
  
  -- �������� ������� ������ � �������� ������� ������� ��� ����� �������� ����
  final member function Equals_Ignore_Case (i_Str Long_String) Return Boolean,
  
  -- ���������, ������������� �� ������� ������ � �������� ����������
  final member function Ends_With (i_Str Varchar2) Return Boolean,
  
  -- ���������, ������������� �� ������� ������ � �������� ����������
  -- ��� ����� �������� ����
  final member function Ends_With_Ignore_Case (i_Str Varchar2) Return Boolean,
  
  -- ���������, ���������� �� ������� ������ � �������� ����������
  final member function Starts_With (i_Str Varchar2) Return Boolean,
  
  -- ���������, ���������� �� ������� ������ � �������� ����������
  -- ��� ����� �������� ����
  final member function Starts_With_Ignore_Case (i_Str Varchar2) Return Boolean,
  
  -- �������� ��������� � �������� ������� � � �������� ������
  -- �� ����� ���������
  final member function Replace (
    i_New_Str  Varchar2,
    i_Pos      Integer,
    i_Len      Integer := NULL
  )
  Return Long_String,
  
  -- ����� � �������� ��� ��������� ������ ��������� �� ������ ���������
  final member function Replace (
    i_Old_Str  Varchar2,
    i_New_Str  Varchar2
  )
  Return Long_String,
  
  -- ������� �� ������ "�����" ������� �����
  final member function Left_Trim (i_TSet Varchar2) Return Long_String,
  
  -- ������� �� ������ "�����" ������� ������
  final member function Right_Trim (i_TSet Varchar2) Return Long_String,
  
  -- ������� �� ������ "�����" ������� ����� � ������
  final member function Trim (i_TSet Varchar2) Return Long_String,
  
  -- ��������� ����� ������ �� �������� ����� �����
  final member function Trunc (i_New_Len Integer) Return Long_String,
  
  -- ������������� ����������� ������� � ������ � Escape-������������������
  -- �������� �� 27.11.2020
  final member function Escape Return Long_String,
  
  -- ������������� Escape-������������������ � ������ ������� � ����������� �������
  -- �������� �� 27.11.2020
  final member function Unescape return Long_String
  
  
)
final;
/
CREATE OR REPLACE TYPE BODY Long_String
is
  -- ����������� ����� ��� ��������� ������ ���� ���������� ����
  -- ������������ ���� ������ ���������� ����������� ������ ���
  -- ��������� ������
  static function GetVersion return Varchar2
  is
  begin
    return '->>27112020<<-';
  end GetVersion;

  -- ����������� ��� �������� ������� ���������� ����
  Constructor Function Long_String (
    Self in out nocopy Long_String
  )
  Return Self as Result
  is
  begin
    Self.Init;  -- ���������������� �������� ����� ������
    return;     -- �������
  end Long_String;

  -- ����������� ��� �������� ���������� ���� �� ������
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Varchar2
  )
  Return Self as Result
  is
  begin
    Self.Init;             -- ���������������� �������� ����� ������
    Self.Append(i_Value);  -- �������� � ����� ������ ������
    return;                -- �������
  end Long_String;

  -- ����������� ��� �������� ���������� ���� �� ��������� �����
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Array_Varchar2
  )
  Return Self as Result
  is
  begin
    Self.Init;             -- ���������������� �������� ����� ������
    Self.Append(i_Value);  -- �������� � ����� ������ ��������� �����
    return;                -- �������
  end Long_String;

  -- ����������� ��� �������� ���������� ���� �� LOB-�������
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in CLob
  )
  Return Self as Result
  is
  begin
    Self.Init;             -- ���������������� �������� ����� ������
    Self.Append(i_Value);  -- �������� � ����� ������ CLOB-������
    return;                -- �������
  end Long_String;

  -- ���������������� �������� ����� ������
  final member procedure Init (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos "  := 1;                   -- ������� ���������
    Self."Buf_Size " := 0;                   -- ����� ����� ������
    Self."Buf "      := Array_Varchar2('');  -- ����� ��� ������
  end Init;

  -- ����������� ������� ������� ������
  final member function Clone Return Long_String
  is
  begin
    -- ��� ������������ ���������� ��������� � ��������� ������� ������� ������
    return (Self);
  end Clone;

  -- ��������� ������ ������ ������� ������ ������
  final member procedure Recalc_Size (Self in out nocopy Long_String)
  is
    v_Size  Integer := 0;
  begin
    -- ��������� ������������ ��������� ������� ������
    if Self."Buf " is not NULL and Self."Buf ".Count > 0 then
      -- ��������� ������ ������
      for I in 1..Self."Buf ".Count
      loop
        v_Size := v_Size + NVL(Length(Self."Buf "(I)), 0);
      end loop;
    else
      -- ������: ���������������� ����� ������
      Self."Buf " := Array_Varchar2('');
    end if;
    -- ���������� ����� ������ ������
    Self."Buf_Size " := v_Size;
    -- ���������� ������� ������ �� ������ ������
    Self."Cur_Pos " := 1;
  end Recalc_Size;


  -- ������������ ���������� � ��������  ����� ������ � ���������� �� ������
  final member procedure Error (
    Self          in Long_String,
    i_Error_Msg   in Varchar2,
    i_Error_Code  in PLS_Integer := 0
  )
  is
  begin
    -- ������������ ���������� � ��������  ����� ������ � ���������� �� ������
    Raise_Application_Error(-20000 - i_Error_Code, i_Error_Msg);
    --
    -- ������� ������������� ���, ����� ������� ���������� ���������
    if Self is NULL then
      NULL;  -- ������� �� ����� �����������, �� ������� ���������� ���������
    end if;
  end Error;

  -- ���������� ������� ������ � ������
  final member function Get_Index Return Integer
  is
  begin
    return Self."Cur_Pos ";
  end Get_Index;

  -- ���������� ����� ������
  final member function Get_Length Return Integer
  is
  begin
    return Self."Buf_Size ";
  end Get_Length;

  -- ���������� �������� � ���� ������
  -- ���� ����� ������ ��������� 32�, �� ���������� ����������
  final member function To_String Return Varchar2
  is
  begin
    if Self."Buf_Size " > 32767 then
      -- ��������� �� ���������� � �����
      Error('��������� �� ���������� � ������!');
    end if;
    -- ���������� �������� � ���� ������
    return Self.Sub_Str(1, Self."Buf_Size ");
  end To_String;

  -- ���������� �������� � ���� ��������� �����
  final member function To_String_Array Return Array_Varchar2
  is
  begin
    -- ���������� �������� � ���� ��������� �����
    return Self."Buf ";
  end To_String_Array;

  -- ���������� �������� � ���� ������� CLOB
  final member function To_CLob Return CLob
  is
    v_Result  CLob;
  begin
    -- ���������� NULL, ���� ������ �����
    if Self."Buf_Size " = 0 then
      return NULL;
    end if;
    -- ��������� ������ �������� ������ � ���������
    v_Result := Self."Buf "(1);
    -- ���������� �������� � ���� ������� CLOB
    for I in 2..Self."Buf ".Count
    loop
      -- �������� �������� ������ � ���������
      DBMS_Lob.WriteAppend(v_Result, Length(Self."Buf "(I)), Self."Buf "(I));
    end loop;
    -- ���������� �������� � ���� ������� CLOB
    return v_Result;
  end To_CLob;



  -- �������� �������� ������ � ����� ������ ������� ������
  final member procedure Append (
    Self  in out nocopy Long_String,
    i_Str in Varchar2
  )
  is
    v_Page_Len  PLS_Integer;
  begin
    -- ���� ������� ������ �����
    if i_Str is NULL then
      return;  -- ������������ ������ ������
    elsif Self."Buf " is NULL or Self."Buf ".Count = 0 then
      -- ���������������� ����� ����� � �������� �������
      Self."Buf " := Array_Varchar2(i_Str);
    else
      -- ���������� ����� ��������� �������� ������
      v_Page_Len := NVL(Length(Self."Buf "("Buf ".Count)), 0);
      --
      -- ���� ������ ���������� � ��������� �������� ������
      if v_Page_Len + Length(i_Str) < 32767 then
        -- �������� ������ � ��������� �������� ������
        "Buf "("Buf ".Count) := "Buf "("Buf ".Count) || i_Str;
      else
        -- �������� ����� ������ � ��������� �������� ������
        "Buf "("Buf ".Count) := "Buf "("Buf ".Count)
                             || SubStr(i_Str, 1, 32767 - v_Page_Len);
        --
        -- �������� � ����� ����� ��������
        "Buf ".Extend;
        -- �������� ���������� ����� ������ � ����� �������� ������
        "Buf "(Self."Buf ".Count) := SubStr(i_Str, 32767 - v_Page_Len + 1);
      end if;
    end if;
    -- �������������� ������ ������
    Self."Buf_Size " := NVL(Self."Buf_Size ", 0) + Length(i_Str);
  end Append;

  -- �������� �������� ��������� ����� � ����� ������ ������� ������
  final member procedure Append (
    Self   in out nocopy Long_String,
    i_List in Array_Varchar2
  )
  is
  begin
    -- ������ �� ������, ���� ������ ������ ���������
    if i_List is NULL or i_List.Count = 0 then
      return;  -- ����� �� ���������
    end if;
    -- �������� �������� ��������� � ����� ������
    for I in 1..i_List.Count
    loop
      Self.Append(i_List(I));  -- �������� ������� � ����� ������
    end loop;
  end Append;

  -- �������� �������� ������� ������ � ����� ������ ������� ������
  final member procedure Append (
    Self     in out nocopy Long_String,
    i_String in Long_String
  )
  is
  begin
    -- �������� ������� ������ � ����� ������
    Self.Append(i_String."Buf ");
  end Append;

  -- �������� ���������� ������� CLOB � ����� ������ ������� ������
  final member procedure Append (
    Self      in out nocopy Long_String,
    i_Lob_Loc in CLob
  )
  is
    v_Lob_Length  Integer := Length(i_Lob_Loc);
    v_Lob_Offset  Integer := 1;
    v_Read_Count  Integer := 32767;
    v_Str         Varchar(32767);
  begin
    -- ���� �� ��� ���, ���� �� ����� ������� ������ 32� ��������
    while v_Lob_Offset < v_Lob_Length
    loop
      -- ��������� ������ � ��������� �����
      DBMS_Lob.Read(i_Lob_Loc, v_Read_Count, v_Lob_Offset, v_Str);
      -- �����, ���� �� ��������� ������
      exit when (v_Read_Count = 0);
      --
      -- �������� ��������� ������ ������ � �����
      Self.Append(v_Str);
      -- ��������� ����� ������
      v_Lob_Offset := v_Lob_Offset + v_Read_Count;
    end loop;
  end Append;


  -- ���������� ������ �� ��������� ������� � ������
  final member function Get_Char (i_Pos Integer := NULL) Return Varchar2
  is
    P  Integer := NVL(i_Pos, Self."Cur_Pos ") - 1;
  begin
    -- ���� ��������� ������� ������� �� ����� ������
    if P >= "Buf_Size " or P < 0 then
      return NULL;             -- ���������� NULL
    end if;
    -- ���������� ������ �� ��������� ������� � ������
    return SubStr("Buf "(floor(P / 32767) + 1), (P mod 32767 + 1), 1);
  end Get_Char;

  -- ���������� ASCII-��� ������� �� ��������� ������� � ������
  final member function Get_Char_Code (i_Pos Integer := NULL) Return PLS_Integer
  is
    P  Integer := NVL(i_Pos, Self."Cur_Pos ") - 1;
  begin
    -- ���� ��������� ������� ������� �� ����� ������
    if P >= "Buf_Size " or P < 0 then
      return NULL;             -- ���������� NULL
    end if;
    -- ���������� ������ �� ��������� ������� � ������
    return ASCII(SubStr("Buf "(floor(P / 32767) + 1), P mod 32767 + 1, 1));
  end Get_Char_Code;

  -- �������� ������, � ������� ��������� ������ � �������� �������
  final member function Get_Line (
    i_Pos        Integer := NULL,
    i_Whole_Line Boolean := False
  )
  Return Varchar2
  is
    v_Pos  Integer := NVL(i_Pos, Self."Cur_Pos ");
    v_Beg  Integer := v_Pos;
    v_End  Integer;
  begin
    -- ���� ��������� �������� ������ �������
    if i_Whole_Line then
      -- ���������� ����� ������� ������
      v_Beg := Self.Find_SubStr_Back(Chr(10), v_Pos) + 1;
    end if;
    -- ���������� ������ ������� ������
    v_End := Self.Find_SubStr(Chr(10), v_Pos);
    --
    -- ���� ������ �� �������� ��������� �������
    if v_End > 0 then
      -- ���������� ������ �� �������� ������� ������
      return Self.Sub_Str(v_Beg, v_End - v_Beg);
    else
      -- ���������� ��������� ������ ������� ������
      return Self.Sub_Str(v_Beg, Self."Buf_Size " - v_Beg + 1);
    end if;
  end Get_Line;

  -- �������� ������, � ������� ��������� ������ � �������� �������
  -- � ������ ������� � ��������� ������ � ������ � ����� ������
  final member function Get_Line_Trim (
    i_Pos        Integer  := NULL,
    i_Whole_Line Boolean  := False,
    i_TSet       Varchar2 := ' ' || Chr(9)
  )
  Return Varchar2
  is
  begin
    -- ������� ������� ��������� ������
    return LTrim(RTrim(Get_Line(i_Pos, i_Whole_Line), i_TSet), i_TSet);
  end Get_Line_Trim;

  -- ���������� ������ ������ ������� ������
  final member function Get_First_Char Return Varchar2
  is
  begin
    return Get_Char(1);  -- ���������� ������ ������
  end Get_First_Char;

  -- ���������� ��������� ������ ������� ������
  final member function Get_Last_Char Return Varchar2
  is
  begin
    return Get_Char(Self."Buf_Size ");  -- ���������� ��������� ������
  end Get_Last_Char;

  -- ���������� �� ������ ��������� ������ � ��������� �������
  final member function Get_Next_Char (i_Pos Integer := NULL) Return Varchar2
  is
  begin
    -- ������� �������, ������������ �� ������ ��������� ������ � ��������� �������
    return Get_Char(NVL(i_Pos, Self."Cur_Pos ") + 1);
  end Get_Next_Char;

  -- ���������� �� ������ ���������� ������ � ��������� �������
  final member function Get_Prev_Char (i_Pos Integer := NULL) Return Varchar2
  is
  begin
    -- ������� �������, ������������ �� ������ ��������� ������ � ��������� �������
    return Get_Char(NVL(i_Pos, Self."Cur_Pos ") - 1);
  end Get_Prev_Char;


  -- ������� � ���������� ������� � ������
  -- ���������� ���������������� ������� ��������� Next � ������� Get_Char
  final member function Go_To_Next_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2
  is
  begin
    -- ���� ��� �� ��������� ����� ������
    if Self."Cur_Pos " <= "Buf_Size " then
      Self."Cur_Pos " := Self."Cur_Pos " + 1;    -- ������� � ���������� �������
    end if;
    -- ������� �������, ������������ �� ������ ��������� ������ � ��������� �������
    return Self.Get_Char(Self."Cur_Pos ");
  end Go_To_Next_Char;

  -- ������� � ����������� ������� � ������
  -- ���������� ���������������� ������� ��������� Prev � ������� Get_Char
  final member function Go_To_Prev_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2
  is
  begin
    -- ���� ��� �� ��������� ������ ������
    if Self."Cur_Pos " > 0 then
      Self."Cur_Pos " := Self."Cur_Pos " - 1;      -- ������� � ����������� �������
    end if;
    -- ������� �������, ������������ �� ������ ��������� ������ � ��������� �������
    return Self.Get_Char(Self."Cur_Pos ");
  end Go_To_Prev_Char;

  -- ���������, ��������� �� ����� ������
  final member function Is_Line_End (i_Pos Integer := NULL) Return Boolean
  is
    v_Pos  Integer := NVL(i_Pos, Self."Cur_Pos ");
  begin
    -- ���� ��������� ����� ������, ���������� "������"
    if v_Pos > Self."Buf_Size " then
      return True;                    -- ��������� ����� ������
    end if;
    -- ���������, ��������� �� ����� ������
    return (Self.Get_Char(v_Pos) = Chr(10));
  end Is_Line_End;

  -- ���������, ��������� �� ����� ������
  final member function Is_End (i_Pos Integer := NULL) Return Boolean
  is
  begin
    return (NVL(i_Pos, Self."Cur_Pos ") > Self."Buf_Size ");
  end Is_End;


  -- ������� � ������� �������
  final member procedure First (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos " := 1;    -- ������� � ������� �������
  end First;

  -- ������� � ������ ������ ������
  final member procedure First_Line (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos " := 1;    -- ������� � ������ ������ ������
  end First_Line;

  -- ������� � ���������� �������
  final member procedure Last (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos " := Self."Buf_Size ";    -- ������� � ���������� �������
  end Last;

  -- ������� � ������ ��������� ������
  final member procedure Last_Line (Self in out nocopy Long_String)
  is
  begin
    -- ������� � ������ ��������� ������
    Self."Cur_Pos " := Self.Find_SubStr_Back(Chr(10), Self."Buf_Size ") + 1;
  end Last_Line;

  -- ���������� ������� ������ �� �������� �������
  final member procedure Move_Pos (
    Self in out nocopy Long_String,
    i_New_Pos  Integer
  )
  is
  begin
    -- ��������� ������������ ���������
    if i_New_Pos is NULL then
      return;                                  -- �� ������ ������� - ������ �� ������
    elsif i_New_Pos <= 1 then
      Self."Cur_Pos " := 1;                    -- ������� � ������ ������
    elsif i_New_Pos > Self."Buf_Size " then
      Self."Cur_Pos " := Self."Buf_Size " + 1; -- ������� � ����� ������
    else
      Self."Cur_Pos " := i_New_Pos;            -- ������� � ��������� �������
    end if;
  end Move_Pos;

  -- ����������� ������� ������ �� �������� ���������� ��������
  final member procedure Move_Pos_By (
    Self in out nocopy Long_String,
    i_Increment  Integer
  )
  is
  begin
    -- ����������� ������� ������ �� �������� ���������� ��������
    Self.Move_Pos(Self."Cur_Pos " + i_Increment);
  end Move_Pos_By;

  -- ������� � ���������� �������
  final member procedure Next (Self in out nocopy Long_String)
  is
  begin
    -- ���� ��� �� ��������� ����� ������
    if Self."Cur_Pos " <= Self."Buf_Size " then
      Self."Cur_Pos " := Self."Cur_Pos " + 1;      -- ������� � ���������� �������
    end if;
  end Next;

  -- ������� � ��������� ������
  final member procedure Next_Line (Self in out nocopy Long_String)
  is
    v_Pos  Integer := Self.Find_SubStr(Chr(10), Self."Cur_Pos ");
  begin
    -- ���� ������� ������ �� �������� ��������� �������
    if v_Pos > 0 then
      Self."Cur_Pos " := v_Pos + 1;             -- ������� � ��������� ������
    else
      Self."Cur_Pos " := Self."Buf_Size " + 1;  -- ������� � ����� ������
    end if;
  end Next_Line;

  -- ������� � ����������� �������
  final member procedure Prev (Self in out nocopy Long_String)
  is
  begin
    -- ���� ��� �� ��������� ������ ������
    if Self."Cur_Pos " > 0 then
      Self."Cur_Pos " := Self."Cur_Pos " - 1;      -- ������� � ����������� �������
    end if;
  end Prev;

  -- ������� � ���������� ������
  final member procedure Prev_Line (Self in out nocopy Long_String)
  is
  begin
    -- ������� � ���������� ������
    Self."Cur_Pos " := Self.Find_SubStr_Back(Chr(10), "Cur_Pos " - 1) + 1;
  end Prev_Line;


  -- ����� � ������� ������ ��������� � �������� �������
  final member function Find_SubStr (
    i_SubStr  Varchar2,
    i_Pos     Integer := NULL
  )
  Return Integer
  is
    v_Pos     Integer     := NVL(i_Pos, Self."Cur_Pos ");
    v_Page    Integer     := floor((v_Pos - 1) / 32767) + 1;
    v_At_Pos  PLS_Integer := (v_Pos - 1) mod 32767 + 1;
    v_SubLen  PLS_Integer := Length(i_SubStr);
    v_Ind     PLS_Integer;
    v_Find    PLS_Integer;
  begin
    -- ��������� ������������ ����� ��������� ��� ������
    if i_SubStr is NULL or v_Pos is NULL or v_Pos + v_SubLen > "Buf_Size " then
      return 0;           -- ��������� ������ ��� �� ����� ���� �������
    elsif v_SubLen > 16384 then
      -- ������ ������� ������� ������ ��� ������ (������ 16384 ��������)
      Error('������ ������� ������� ������ ��� ������ (������ 16384 ��������)!');
    elsif v_Pos < 1 then
      v_At_Pos := 1;      -- ������ � ������ ������
      v_Page   := 1;      -- � ������ ��������
    end if;
    --
    loop
      -- ������ ��������� � �������� ������
      v_Find := InStr("Buf "(v_Page), i_SubStr, v_At_Pos);
      -- ���� ��������� �������
      if v_Find > 0 then
        return ((v_Page - 1) * 32767 + v_Find);
      elsif v_Page = "Buf ".Count then
        return 0;
      elsif v_SubLen > 1 then
        -- ���� ��������� �������� ����� ���� ��������, �� ������ ����� �� �����
        -- ���� ������� ������
        v_Ind  := 32767 - v_SubLen + 2;
        v_Find := InStr(SubStr("Buf "(v_Page), v_Ind) || SubStr("Buf "(v_Page + 1),
                          1, v_SubLen - 1), i_SubStr);
        -- ���� ��������� �������
        if v_Find > 0 then
          return ((v_Page - 1) * 32767 + v_Ind + v_Find - 1);
        end if;
      end if;
      v_Page   := v_Page + 1;  -- ������� �� ��������� ��������
      v_At_Pos := 1;           -- � ��������� ��������� ������ � ������ �������
    end loop;
    -- �������� ���� ������� �� ���������� (�������� ��� �������� ����)
    return 0;
  end Find_SubStr;

  -- ����� � ������� ������ ��������� � �������� �������
  final member function Find_SubStr_Back (
    i_SubStr  Varchar2,
    i_Pos     Integer := NULL
  )
  Return Integer
  is
    v_Pos     Integer     := NVL(i_Pos, Self."Cur_Pos ");
    v_Page    Integer     := floor((v_Pos - 1) / 32767) + 1;
    v_At_Pos  PLS_Integer := (v_Pos - 1) mod 32767 + 1;
    v_SubLen  PLS_Integer := Length(i_SubStr);
    v_Ind     PLS_Integer;
    v_Find    PLS_Integer;
  begin
    -- ��������� ������������ ����� ��������� ��� ������
    if i_SubStr is NULL or v_Pos is NULL or v_Pos < v_SubLen then
      return 0;                   -- ��������� ������ ��� �� ����� ���� �������
    elsif v_SubLen > 16384 then
      -- ������ ������� ������� ������ ��� ������ (������ 16384 ��������)
      Error('������ ������� ������� ������ ��� ������ (������ 16384 ��������)!');
    elsif v_Pos > "Buf_Size " or v_Page > "Buf ".Count then
      v_At_Pos := -1;             -- ������ � ����� ������
      v_Page   := "Buf ".Count;   -- � ��������� ��������
    else
      -- ��������� ������� ��������� ��� ������ � ����� ��������
      v_At_Pos := - (Length("Buf "(v_Page)) - v_At_Pos + 1);
    end if;
    --
    loop
      -- ������ ��������� � �������� ������
      v_Find := InStr("Buf "(v_Page), i_SubStr, v_At_Pos);
      -- ���� ��������� �������
      if v_Find > 0 then
        return ((v_Page - 1) * 32767 + v_Find);
      end if;
      --
      if v_Page = 1 then
        return 0;
      elsif v_SubLen > 1 then
        -- ���� ��������� �������� ����� ���� ��������, �� ������ ����� �� �����
        -- ���� ������� ������
        v_Ind  := 32767 - v_SubLen + 2;
        v_Find := InStr(SubStr("Buf "(v_Page - 1), v_Ind) || SubStr("Buf "(v_Page),
                          1, v_SubLen - 1), i_SubStr, -1);
        -- ���� ��������� �������
        if v_Find > 0 then
          return ((v_Page - 1) * 32767 + v_Ind + v_Find - 1);
        end if;
      end if;
      v_Page   := v_Page - 1;  -- ������� �� ���������� ��������
      v_At_Pos := -1;          -- � ���������� ��������� ������ � ����� ��������
    end loop;
    -- �������� ���� ������� �� ���������� (�������� ��� �������� ����)
    return 0;
  end Find_SubStr_Back;


  -- ����� � ������ ��������� ������, ����������� ������� ������
  final member function Find_Char_For_Set (
    i_Set     Varchar2,
    i_Pos     Integer := NULL,
    i_In_Set  Boolean := True
  )
  Return Integer
  is
    v_Ind  PLS_Integer;
    v_Pos  Integer    := NVL(i_Pos, Self."Cur_Pos ");
  begin
    --
    if i_Set is NULL then
      return 0;
    elsif v_Pos > "Buf_Size " then
      return "Buf_Size " + 1;
    elsif v_Pos < 1 then
      v_Pos := 1;
    end if;
    -- ���� �� ��������� ����� ������
    while (v_Pos <= "Buf_Size ")
    loop
      -- ����� �������� ������� � �������� ������ ��������
      v_Ind := InStr(i_Set, SubStr("Buf "(floor((v_Pos - 1) / 32767) + 1),
                 (v_Pos - 1) mod 32767 + 1, 1));
      --
      -- ����� �� �����, ���� ��������� ��������� ������� ������
      exit when (v_Ind > 0 and i_In_Set) or (v_Ind = 0 and not i_In_Set);
      -- ������� �� ��������� �������
      v_Pos := v_Pos + 1;
    end loop;
    -- ���������� ������� �������, ��������� � �������� �����
    return v_Pos;
  end Find_Char_For_Set;

  -- ����� � ������ ���������� ������, ����������� ������� ������
  final member function Find_Char_For_Set_Back (
    i_Set     Varchar2,
    i_Pos     Integer := NULL,
    i_In_Set  Boolean := True
  )
  Return Integer
  is
    v_Ind  PLS_Integer;
    v_Pos  Integer    := NVL(i_Pos, Self."Cur_Pos ");
  begin
    --
    if i_Set is NULL then
      return 0;
    elsif v_Pos > "Buf_Size " then
      return "Buf_Size ";
    elsif v_Pos < 0 then
      v_Pos := 0;
    end if;
    -- ���� �� ��������� ����� ������
    while (v_Pos >= 1)
    loop
      -- ����� �������� ������� � �������� ������ ��������
      v_Ind := InStr(i_Set, SubStr("Buf "(floor((v_Pos - 1) / 32767) + 1),
                 (v_Pos - 1) mod 32767 + 1, 1));
      --
      -- ����� �� �����, ���� ��������� ��������� ������� ������
      exit when (v_Ind > 0 and i_In_Set) or (v_Ind = 0 and not i_In_Set);
      -- ������� �� ��������� �������
      v_Pos := v_Pos - 1;
    end loop;
    -- ���������� ������� �������, ��������� � �������� �����
    return v_Pos;
  end Find_Char_For_Set_Back;

  -- ����� ������� ���������� �������, ��������� � �������� ����� ��������
  final member function Find_Char_In_Set (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer
  is
  begin
    -- ���������� ������� �������, ��������� � �������� ����� ��������
    return Self.Find_Char_For_Set(i_Set, i_Pos, True);
  end Find_Char_In_Set;

  -- ����� ������� ���������� �������, �� ��������� � �������� ����� ��������
  final member function Find_Char_Not_In_Set  (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer
  is
  begin
    -- ���������� ������� �������, �� ��������� � �������� ����� ��������
    return Self.Find_Char_For_Set(i_Set, i_Pos, False);
  end Find_Char_Not_In_Set;

  -- ����� ������� ���������� �� ������������ �������� �������
  final member function Find_None_Blank_Char (i_Pos Integer := NULL) Return Integer
  is
  begin
    -- ���������� ������� ���������� �� ������������ �������� �������
    return Self.Find_Char_For_Set(' '||Chr(9), i_Pos, False);
  end Find_None_Blank_Char;

  -- ����� ������� ���������� �� ������������ "�����" �������
  final member function Find_None_White_Char (i_Pos Integer := NULL) Return Integer
  is
  begin
    -- ���������� ������� ���������� �� ������������ "�����" �������
    return Self.Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), i_Pos, False);
  end Find_None_White_Char;


  -- ����� � ��������� �� ������ ��������� ��� ��������������
  -- ���������� ������� ������� ������� ����� ����� ��������������
  -- ��� ������������� ���������� ������� � ������ "�����" �������
  final member function Find_Identifier (
    io_Pos      in out nocopy Integer,
    o_Token_Pos    out nocopy Integer,
    i_To_Upper_Case  Boolean  := True,
    i_Skip_Blanks    Varchar2 := 'B'
  )
  Return Varchar2
  is
    P        Integer := NVL(io_Pos, Self."Cur_Pos ");
    v_Sym    PLS_Integer;
    v_Block  Varchar2(32);
  begin
    -- ���� ��������� ������������ ��� "�����" �������
    if i_Skip_Blanks = 'B' or i_Skip_Blanks = 'b' then
      -- ���������� ������� � ������� ���������
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    elsif i_Skip_Blanks = 'W' or i_Skip_Blanks = 'w' then
      -- ���������� ��� "�����" �������
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    end if;
    -- ��������� ������� ������ �������
    o_Token_Pos := P;
    --
    -- ����������� �����
    <<outer_loop>>
    while (P <= Self."Buf_Size ")
    loop
      -- ��������� �� ������ ��������� ����
      v_Block := SubStr("Buf "(floor((P - 1) / 32767) + 1), (P - 1) mod 32767 + 1, 32);
      -- ���� ���� ����
      if v_Block is NULL then
        exit;                  -- ��������� ����� ������ - ����� �� �����
      end if;
      --
      for I in 1..Length(v_Block)
      loop
        -- ��������� ASCII-��� ������� �� �������
        v_Sym := ASCII(SubStr(v_Block, I, 1));
        -- �����, ���� ������ �� ��������:
        --   ��� ������� �������   : ������ ��� �������� "_"
        --   ��� ��������� ��������: ������, ������ ��� ����� �� ��������
        --   "_", "$", "." (������ "." ��������� ��� ��������� �������� �������)
        if P = o_Token_Pos and not ((v_Sym >= 65 and v_Sym <= 90) or
            (v_Sym >= 97 and v_Sym <= 122) or v_Sym = 95) then
          -- �� ������� ��� �������������� - ���������� ������ ������
          return '';
        elsif not ((v_Sym >= 65 and v_Sym <= 90) or (v_Sym >= 97 and v_Sym <= 122)
                or (v_Sym >= 48 and v_Sym <= 57)
                or v_Sym = 95 or v_Sym = 36 or v_Sym = 46) then
          --
          exit outer_loop;   -- ����� �� �������� �����
        end if;
        P := P + 1;          -- ����������� ��������� �� ��������� ������
      end loop;
    end loop;
    io_Pos := P;             -- ���������� ������� �������
    --
    -- ��������� �� ������ ��� ��������������
    if o_Token_Pos > Self."Buf_Size " then
      return Chr(0);              -- ����� ������� - ���������� ����-����������
    elsif P = o_Token_Pos then
      return '';                  -- ���������� ������ ������
    elsif i_To_Upper_Case then
      -- ���������� ��� ��������������
      return Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
    else
      -- ���������� ��� ��������������
      return Self.Sub_Str(o_Token_Pos, P - o_Token_Pos);
    end if;
  end Find_Identifier;

/*
  -- ����� � ��������� �� ������ ��������� ��� ��������������
  -- ���������� ������� ������� ������� ����� ����� ��������������
  -- ��� ������������� ���������� ������� � ������ "�����" �������
  final member function Find_Identifier (
    i_To_Upper_Case  Boolean  := True,
    i_Skip_Blanks    Varchar2 := 'B',
    i_Pos            Integer  := NULL
  )
  Return Varchar2
  is
    P        Integer := NVL(i_Pos, Self."Cur_Pos ");
    v_Begin  Integer;
    v_Sym    PLS_Integer;
  begin
    -- ���� ��������� ������������ ��� "�����" �������
    if i_Skip_Blanks = 'B' or i_Skip_Blanks = 'b' then
      -- ���������� ������� � ������� ���������
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    elsif i_Skip_Blanks = 'W' or i_Skip_Blanks = 'w' then
      -- ���������� ��� "�����" �������
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    end if;
    -- ��������� ������� ������ �������
    v_Begin := P;
    --
    -- ����������� �����
    while (P <= Self."Buf_Size ")
    loop
      -- ��������� ASCII-��� ������� �� �������
      v_Sym := ASCII(SubStr("Buf "(floor((P - 1) / 32767) + 1), (P - 1) mod 32767 + 1, 1));
      -- �����, ���� ������ �� �������� ������
      if P = v_Begin and not ((v_Sym >= 65 and v_Sym <= 90) or
          (v_Sym >= 97 and v_Sym <= 122) or v_Sym  = 95) then
        -- ���������� ������ ������
        return '';
      elsif not ((v_Sym >= 65 and v_Sym <= 90) or (v_Sym >= 97 and v_Sym <= 122)
              or (v_Sym >= 48 and v_Sym <= 57) or v_Sym = 95 or v_Sym = 36) then
        -- ����� �� �����
        exit;
      end if;
      -- ������� �� ��������� ������
      P := P + 1;
    end loop;
    --
    -- ��������� �� ������ ��� ��������������
    if P > Self."Buf_Size " then
      -- ����� ������� - ���������� ����-����������
      return Chr(0);
    elsif P = v_Begin then
      -- ���������� �������-������
      return '';
    elsif i_To_Upper_Case then
      -- ���������� �������-�������������
      return Upper(Self.Sub_Str(v_Begin, P - v_Begin));
    else
      -- ���������� �������-�������������
      return Self.Sub_Str(v_Begin, P - v_Begin);
    end if;
  end Find_Identifier;
*/

  -- �������� ��������� �������
  -- ��� ������������� ���������� ������� � ������ "�����" �������
  final member procedure Find_Identifier (
    Self  in out nocopy Long_String,
    o_Token_Pos      out nocopy Integer,
    o_Token          out nocopy Varchar2,
    i_To_Upper_Case   Boolean  := True,
    i_Skip_Blanks     Varchar2 := 'B',
    i_Move_Before     Boolean  := True,
    i_Move_After      Boolean  := True,
    i_Pos             Integer  := NULL
  )
  is
    P  Integer := NVL(i_Pos, Self."Cur_Pos ");
  begin
    -- ������� ������������� �������
    o_Token := Find_Identifier(P, o_Token_Pos, i_To_Upper_Case, i_Skip_Blanks);
    -- ���� ��� �������������� �� ����
    if o_Token is not NULL then
      -- ��� ������������� ���������� ������� ������ � ������ �������
      if i_Move_After then
        -- ���������� �������
        Self."Cur_Pos " := P;
      elsif i_Move_Before then
        Self."Cur_Pos " := o_Token_Pos;
      end if;
    end if;
  end Find_Identifier;

/*
  -- �������� ��������� �������
  -- ��� ������������� ���������� ������� � ������ "�����" �������
  final member procedure Find_Identifier (
    Self  in out nocopy Long_String,
    o_Token_Pos      out nocopy Integer,
    o_Token          out nocopy Varchar2,
    i_To_Upper_Case   Boolean  := True,
    i_Skip_Blanks     Varchar2 := 'B',
    i_Move_Before     Boolean  := True,
    i_Move_After      Boolean  := True,
    i_Pos             Integer  := NULL
  )
  is
    P      Integer    := NVL(i_Pos, Self."Cur_Pos ");
    v_Sym  PLS_Integer;
  begin
    -- ���� ��������� ������������ ��� "�����" �������
    if i_Skip_Blanks = 'B' or i_Skip_Blanks = 'b' then
      -- ���������� ������� � ������� ���������
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    elsif i_Skip_Blanks = 'W' or i_Skip_Blanks = 'w' then
      -- ���������� ��� "�����" �������
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    end if;
    -- ��� ������������� ���������� ������� ������ � ������ �������
    if i_Move_Before then
      Self."Cur_Pos " := P;
    end if;
    --
    o_Token_Pos := P;  -- ��������� ������� ������ �������
    --
    -- ����������� �����
    while (P <= Self."Buf_Size ")
    loop
      -- ��������� ASCII-��� ������� �� �������
      v_Sym := ASCII(SubStr("Buf "(floor((P - 1) / 32767) + 1), (P - 1) mod 32767 + 1, 1));
      --
      if P = o_Token_Pos then
        -- �����, ���� ������ �� �������� ������
        exit when not ((v_Sym >= 65 and v_Sym <=  90) or
                       (v_Sym >= 97 and v_Sym <= 122) or
                        v_Sym  = 95);
      else
        -- �����, ���� ������ �� �������� ������
        exit when not ((v_Sym >= 65 and v_Sym <=  90) or
                       (v_Sym >= 97 and v_Sym <= 122) or
                       (v_Sym >= 48 and v_Sym <=  57) or
                        v_Sym  = 95 or  v_Sym  =  36);
      end if;
      -- ������� �� ��������� ������
      P := P + 1;
    end loop;
    --
    -- ��� ������������� ���������� ������� ������ � ����� �������
    if i_Move_After then
      Self."Cur_Pos " := P;
    end if;
    --
    if P > Self."Buf_Size " then
      -- ����� ������� - ���������� ����-����������
      o_Token := Chr(0);
    elsif P = o_Token_Pos then
      -- ���������� �������-������
      o_Token := '';  -- Self.Get_Char(P);
    elsif i_To_Upper_Case then
      -- ���������� �������-�������������
      o_Token := Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
    else
      -- ���������� �������-�������������
      o_Token := Self.Sub_Str(o_Token_Pos, P - o_Token_Pos);
    end if;
  end Find_Identifier;

  -- �������� ��������� �������
  -- ��� ������������� ���������� ������� � ������ "�����" �������
  final member procedure Find_Identifier (
    Self  in out nocopy Long_String,
    o_Token_Pos      out nocopy Integer,
    o_Token          out nocopy Varchar2,
    i_To_Upper_Case   Boolean := True,
    i_Skip_Any_White  Boolean := False,
    i_Move_Before     Boolean := True,
    i_Move_After      Boolean := True,
    i_Pos             Integer := NULL
  )
  is
    P      Integer    := NVL(i_Pos, Self."Cur_Pos ");
    v_Sym  PLS_Integer;

    -- ������� ��� ��-�������� ������ ����� ����� ��������������
    Function Find_Token_End (i_Pos Integer) Return Integer
    is
      v_Sym   PLS_Integer;
      v_Str   Varchar2(32) := SubStr("Buf "(floor((i_Pos-1)/32767)+1), (i_Pos-1) mod 32767 + 1, 32);
      v_Len   PLS_Integer  := NVL(Length(v_Str), 0);
    begin
      -- ������ ����� ����� � �����
      for I in 1..v_Len
      loop
        -- ��������� ASCII-��� ������� �� �������
        v_Sym := ASCII(SubStr(v_Str, I, 1));
        -- �����, ���� ������ �� �������� ������
        if not ((v_Sym >= 65 and v_Sym <=  90) or (v_Sym >= 97 and v_Sym <= 122) or
                (v_Sym >= 48 and v_Sym <=  57) or  v_Sym  = 95 or  v_Sym  =  36) then
          -- ���������� ������� �������
          return i_Pos + I - 1;
        end if;
      end loop;
      --
      if i_Pos + v_Len <= Self."Buf_Size " and v_Len > 0 then
        -- ����������� ����� ��� ������������ ���������� �����
        return Find_Token_End(i_Pos + v_Len);
      else
        -- ����� ��������
        return (i_Pos + v_Len);
      end if;
    end Find_Token_End;

  begin
    -- ���� ��������� ������������ ��� "�����" �������
    if i_Skip_Any_White then
      -- ���������� ��� "�����" �������
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    else
      -- ���������� ������� � ������� ���������
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    end if;
    -- ��� ������������� ���������� ������� ������ � ������ �������
    if i_Move_Before then
      Self."Cur_Pos " := P;
    end if;
    --
    o_Token_Pos := P;  -- ��������� ������� ������ �������
    --
    -- ��������� ASCII-��� ������� �� �������
    v_Sym := ASCII(SubStr("Buf "(floor((P-1) / 32767) + 1), (P - 1) mod 32767 + 1, 1));
    -- �����, ���� ������ �� �������� ������
    if ((v_Sym >= 65 and v_Sym <=  90) or
                   (v_Sym >= 97 and v_Sym <= 122) or
                    v_Sym  = 95) then
      -- ������� ��� ��-�������� ������ ����� ����� ��������������
      P := Find_Token_End(P + 1);
    end if;
    --
    -- ��� ������������� ���������� ������� ������ � ����� �������
    if i_Move_After then
      Self."Cur_Pos " := P;
    end if;
    --
    if P > Self."Buf_Size " then
      -- ����� ������� - ���������� ����-����������
      o_Token := Chr(0);
    elsif P = o_Token_Pos then
      -- ���������� �������-������
      o_Token := '';  -- Self.Get_Char(P);
    elsif i_To_Upper_Case then
      -- ���������� �������-�������������
      o_Token := Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
--
--      if v_Page = floor((P-1) / 32767) + 1 then
--        o_Token := Upper(SubStr(Self."Buf "(v_Page), (o_Token_Pos - 1) mod 32767 + 1, P - o_Token_Pos));
--      else
--      -- ���������� �������-�������������
--      o_Token := Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
--      end if;
--
    else
      -- ���������� �������-�������������
      o_Token := Self.Sub_Str(o_Token_Pos, P - o_Token_Pos);
    end if;
  end Find_Identifier;
*/


  -- ������������ ������� � ������� ���������
  final member procedure Skip_Blanks (Self in out nocopy Long_String)
  is
  begin
    -- ������� �� ��������� ������, �� ���������� ��������
    Self."Cur_Pos " := Self.Find_Char_For_Set(' '||Chr(9), Self."Cur_Pos ", False);
  end Skip_Blanks;

  -- ������������ "�����" �������
  -- ���������� �������, ��������� � ������� ����� ������
  final member procedure Skip_White_Chars (Self in out nocopy Long_String)
  is
  begin
    -- ������� �� ��������� ������, �� ���������� "�����"
    Self."Cur_Pos " := Self.Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13),
        Self."Cur_Pos ", False);
  end Skip_White_Chars;

  -- �������� ��������� � �������� ������� � � �������� ������
  final member function Sub_Str (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Varchar2
  is
    v_Pos     Integer := case when i_Pos > 0 then i_Pos else 1 end;
    v_Len     Integer := case when i_Len is NULL or v_Pos + i_Len > "Buf_Size "
                           then "Buf_Size " - v_Pos + 1 else i_Len
                         end;
    v_Page_1  Integer := floor((v_Pos - 1) / 32767) + 1;
    v_Page_2  Integer := floor((v_Pos + v_Len - 2) / 32767) + 1;
  begin
    -- ��������� ������������ ����������
    if i_Pos is NULL or v_Len < 1 or i_Pos > "Buf_Size " then
      return '';                 -- ���������� ������ ������
    elsif v_Len > 32767 then
      -- ��������� �� ���������� � �����
      Error('��������� �� ���������� � �����!');
    elsif v_Page_1 = v_Page_2 then
      -- ��������� ��������� �� ����� �������� ������
      return SubStr("Buf "(v_Page_1), (v_Pos - 1) mod 32767 + 1, v_Len);
    end if;
    -- ��������� ��������� �� ���� ������� ������
    return SubStr("Buf "(v_Page_1), (v_Pos - 1) mod 32767 + 1) ||
           SubStr("Buf "(v_Page_2), 1, (v_Pos + v_Len - 2) mod 32767 + 1);
  end Sub_Str;

  -- �������� ������� ��������� � �������� ������� � � �������� ������
  -- � ���� ��������� �����
  final member function Sub_Str_Array (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Array_Varchar2
  is
    v_Pos     Integer := case when i_Pos > 0 then i_Pos else 1 end;
    v_Len     Integer := case when i_Len is NULL or v_Pos + i_Len > "Buf_Size "
                           then "Buf_Size " - v_Pos + 1 else i_Len
                         end;
    v_Page_1  PLS_Integer;
    v_Page_2  PLS_Integer;
    v_Sub     Array_Varchar2;
  begin
    -- ��������� ������������ ����������
    if i_Pos is NULL or v_Len < 1 or v_Pos > "Buf_Size " then
      -- ���������� ������ ��������� �����
      return Array_Varchar2();
    elsif v_Len <= 32767 then
      -- ���������� ������ ��������� �����
      return Array_Varchar2(Self.Sub_Str(v_Pos, v_Len));
    end if;
    -- ���������������� ��������� ��� ����������
    v_Sub := Array_Varchar2();
    -- ��������� ��������� � �������� ��������
    v_Page_1 := floor((v_Pos - 1) / 32767) + 1;
    v_Page_2 := floor((v_Pos + v_Len - 2) / 32767) + 1;
    --
    -- ���� �� ��������� ���������
    for I in v_Page_1..v_Page_2
    loop
      -- ��������� ���������
      v_Sub.Extend;
      -- �������� ��������� ������ ��������� � ���������
      if I = v_Page_1 then
        -- ����� ��������� �� ��������� ��������
        v_Sub(v_Sub.Count) := SubStr("Buf "(I), (v_Pos - 1) mod 32767 + 1);
      elsif I = v_Page_2 then
        -- ����� ��������� �� ��������� ��������
        v_Sub(v_Sub.Count) := SubStr("Buf "(I), 1, (v_Pos + v_Len - 2) mod 32767 + 1);
      else
        -- ������� �������� �������� �������
        v_Sub(v_Sub.Count) := "Buf "(I);
      end if;
    end loop;
    -- ���������� ��������� � ���� ��������� �����
    return v_Sub;
  end Sub_Str_Array;

  -- �������� ������� ��������� � �������� ������� � � �������� ������
  final member function Sub_Str_Long (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Long_String
  is
  begin
    -- ���������� ������� ��������� �� ��������� � ���� ��������� �����
    return Long_String(Sub_Str_Array(i_Pos, i_Len));
  end Sub_Str_Long;

  -- ����������� �� ������� ������ ��������� �� ��������, ����������
  -- � ������� ������ �������� ����������-������������
  final member function Sub_Str_Items (
    i_Delimeter  Varchar2 := Chr(10),
    i_Pos        Integer  := 1,
    i_Len        Integer  := NULL
  )
  Return Array_Varchar2
  is
    v_Index     Integer := 1;
    v_End_Pos   Integer := Self."Buf_Size ";
    v_Next_Pos  Integer;
    v_Result    Array_Varchar2 := Array_Varchar2();
  begin
    -- ���������� ������ ���������, ���� ����� ����
    if Self."Buf_Size " = 0 or Self."Buf " is NULL or Self."Buf ".Count = 0 or
        i_Len <= 0 then
      -- ���������� ������ ���������
      return v_Result;
    elsif i_Pos > 1 then
      v_Index := i_Pos;
    end if;
    -- ���� ������ ����� ���������, �� ��������� ���
    if i_Len is not NULL then
      v_End_Pos := v_Index + i_Len - 1;
    end if;
    -- ���� �� ���������
    while v_Index <= v_End_Pos
    loop
      -- �������� ������� ���������� ����������� ���������
      v_Next_Pos := Find_SubStr(i_Delimeter, v_Index);
      -- ��������� ���������
      v_Result.Extend;
      -- �������� ����� ������� ���������
      if v_Next_Pos = 0 or v_Next_Pos > v_End_Pos then
        -- �������� � ��������� ��������� �������
        v_Result(v_Result.Count) := Sub_Str(v_Index, v_End_Pos - v_Index + 1);
        -- ����� �� �����
        exit;
      else
        -- �������� ������� � ���������
        v_Result(v_Result.Count) := Sub_Str(v_Index, v_Next_Pos - v_Index);
        -- ������� � ����������� ��������
        v_Index := v_Next_Pos + 1;
      end if;
    end loop;
    -- ���������� ���������
    return v_Result;
  end Sub_Str_Items;

  -- �������� �� ������� ������ ��������� �� �������� � �������� ���������,
  -- ���������� � ������� ������ �������� ����������-������������
  final member function Sub_Str_Lines (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Array_Varchar2
  is
  begin
    -- ���������� ������� ��������� �� ��������� � ���� ��������� �����
    return Sub_Str_Items(Chr(10), i_Pos, i_Len);
  end Sub_Str_Lines;

  -- ��������� ������� ������ � �������� �������
  final member function Concat (i_Str Varchar2) Return Long_String
  is
    v_Result  Long_String;
  begin
    -- ����������� ������� ������
    v_Result := Self.Clone;
    -- �������� � ��������� �������� ������
    v_Result.Append(i_Str);
    -- ���������� ���������
    return v_Result;
  end Concat;

  -- ��������� ������� ������ � �������� ���������� �����
  final member function Concat (i_Str Array_Varchar2) Return Long_String
  is
    v_Result  Long_String;
  begin
    -- ����������� ������� ������
    v_Result := Self.Clone;
    -- �������� � ��������� �������� ������
    v_Result.Append(i_Str);
    -- ���������� ���������
    return v_Result;
  end Concat;

  -- ��������� ������� ������ � �������� ������� �������
  final member function Concat (i_Str Long_String) Return Long_String
  is
    v_Result  Long_String;
  begin
    -- ����������� ������� ������
    v_Result := Self.Clone;
    -- �������� � ��������� �������� ������
    v_Result.Append(i_Str);
    -- ���������� ���������
    return v_Result;
  end Concat;

  -- ������� � ������ �������� ���������� ��������, ������� � �������� �������
  -- � ���������� ���������
  final member function Remove (i_Pos Integer, i_Len Integer) Return Long_String
  is
  begin
    -- ������� ������� ������ ���������
    return Self.Replace('', i_Pos, i_Len);
  end Remove;

  -- �������� � ������ �������� ��������� � �������� ������� � ���������� ���������
  final member function Insert_Str (i_Str Varchar2, i_Pos Integer) Return Long_String
  is
  begin
    -- ������� ������� ������ ���������
    return Self.Replace(i_Str, i_Pos, 0);
  end Insert_Str;

  final member function Equals (i_Str Varchar2) Return Boolean
  is
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if NVL(Length(i_Str), 0) != Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    elsif Self."Buf ".Count > 1 then
      return False;                                    -- ������ ������ ������ 32�
    elsif i_Str = Self."Buf "(1) then
      return True;                                     -- ������ ���������
    end if ;
    -- ���������� "����"
    return False;                                      -- ������ �� ���������
  end Equals;

  -- �������� ������� ������ � �������� ������� �������
  final member function Equals (i_Str Long_String) Return Boolean
  is
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if i_Str."Buf_Size " = 0 and Self."Buf_Size " = 0 then
      return True;                                     -- ��� ������ �����
    elsif i_Str."Buf_Size " != Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    end if ;
    -- �������� ������ ����� ��-���������
    for I in 1..Self."Buf ".Count
    loop
      -- �����, ���� �������� �� ���������
      if i_Str."Buf "(I) is NULL and Self."Buf "(I) is NULL then
        continue;                                      -- ������� � ��������� ��������
      elsif i_Str."Buf "(I) != Self."Buf "(I) then
        return False;                                  -- �������� �� ���������
      end if;
    end loop;
    -- ���������� "������"
    return True;                                       -- ������ ���������
  end Equals;

  -- �������� ������� ������ � �������� ������� ��� ����� �������� ����
  final member function Equals_Ignore_Case (i_Str Varchar2) Return Boolean
  is
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if NVL(Length(i_Str), 0) != Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    elsif Self."Buf ".Count > 1 then
      return False;                                    -- ������ ������ ������ 32�
    elsif Upper(i_Str) = Upper(Self."Buf "(1)) then
      return True;                                     -- ������ ���������
    end if ;
    -- ���������� "����"
    return False;                                      -- ������ �� ���������
  end Equals_Ignore_Case;

  -- �������� ������� ������ � �������� ������� ������� ��� ����� �������� ����
  final member function Equals_Ignore_Case (i_Str Long_String) Return Boolean
  is
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if i_Str."Buf_Size " = 0 and Self."Buf_Size " = 0 then
      return True;                                     -- ��� ������ �����
    elsif i_Str."Buf_Size " != Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    end if ;
    -- �������� ������ ����� ��-���������
    for I in 1..Self."Buf ".Count
    loop
      -- �����, ���� �������� �� ���������
      if i_Str."Buf "(I) is NULL and Self."Buf "(I) is NULL then
        continue;                                      -- ������� � ��������� ��������
      elsif Upper(i_Str."Buf "(I)) != Upper(Self."Buf "(I)) then
        return False;                                  -- �������� �� ���������
      end if;
    end loop;
    -- ���������� "������"
    return True;                                       -- ������ ���������
  end Equals_Ignore_Case;

  -- ���������, ������������� �� ������� ������ � �������� ����������
  final member function Ends_With (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    elsif Length("Buf "("Buf ".Count)) >= v_Len then
      return (i_Str = SubStr("Buf "("Buf ".Count), -v_Len));
    elsif i_Str = Self.Sub_Str("Buf_Size " - v_Len + 1, v_Len) then
      return True;                                     -- ������ ���������
    end if ;
    -- ���������� "����"
    return False;                                      -- ������ �� ���������
  end Ends_With;

  -- ���������, ������������� �� ������� ������ � �������� ����������
  -- ��� ����� �������� ����
  final member function Ends_With_Ignore_Case (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    elsif Length("Buf "("Buf ".Count)) >= v_Len then
      return (Upper(i_Str) = Upper(SubStr("Buf "("Buf ".Count), -v_Len)));
    elsif Upper(i_Str) = Upper(Self.Sub_Str("Buf_Size " - v_Len + 1, v_Len)) then
      return True;                                     -- ������ ���������
    end if ;
    -- ���������� "����"
    return False;                                      -- ������ �� ���������
  end Ends_With_Ignore_Case;

  -- ���������, ���������� �� ������� ������ � �������� ����������
  final member function Starts_With (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    elsif i_Str = SubStr(Self."Buf "(1), 1, v_Len) then
      return True;                                     -- ������ ���������
    end if ;
    -- ���������� "����"
    return False;                                      -- ������ �� ���������
  end Starts_With;

  -- ���������, ���������� �� ������� ������ � �������� ����������
  -- ��� ����� �������� ����
  final member function Starts_With_Ignore_Case (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- �������� �������� ������ �� ��������� ������ ������
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- ����� ����� ������
    elsif Upper(i_Str) = Upper(SubStr(Self."Buf "(1), 1, v_Len)) then
      return True;                                     -- ������ ���������
    end if ;
    -- ���������� "����"
    return False;                                      -- ������ �� ���������
  end Starts_With_Ignore_Case;

  -- �������� ��������� � �������� ������� � � �������� ������
  -- �� ����� ���������
  final member function Replace (
    i_New_Str  Varchar2,
    i_Pos      Integer,
    i_Len      Integer := NULL
  )
  Return Long_String
  is
    v_Result   Long_String;
    v_At_Pos   PLS_Integer := (i_Pos - 1) mod 32767 + 1;
    v_New_Len  PLS_Integer := NVL(Length(i_New_Str), 0);
    v_Old_Len  PLS_Integer := NVL(i_Len, v_New_Len);
  begin
    -- ��������� ������������ ����������
    if i_Pos is NULL or i_Pos < 1 then
      -- ��������� NULL
      return NULL;
    elsif (v_New_Len = 0 and v_Old_Len = 0) or
          (i_Pos > Self."Buf_Size " and v_New_Len = 0) then
      -- ������ ��������� ���������, ������ �� ������
      return Self.Clone();
    elsif "Buf ".Count = 1 and "Buf_Size " + v_New_Len - v_Old_Len <= 32767 then
      -- ���������� ������� ������, ��������� ����� ������ ���������
      -- � ������������ �������� ������
      return Long_String(SubStr("Buf "(1), 1, v_At_Pos - 1) || i_New_Str ||
                         SubStr("Buf "(1), v_At_Pos + v_Old_Len));
    end if;
    --
    -- ���������� � ��������� ����� ������� ������ �� �������� �������
    v_Result := Self.Sub_Str_Long(1, i_Pos - 1);
    --
    -- �������� � ��������� ����� ���������
    v_Result.Append(i_New_Str);
    --
    if i_Pos <= Self."Buf_Size " then
      -- �������� � ��������� ����� ������� ������ ����� ���������� ���������
      v_Result.Append(Self.Sub_Str_Array(i_Pos + v_Old_Len));
    end if;
    --
    -- ���������� ���������
    return v_Result;
  end Replace;

  -- ����� � �������� ��� ��������� ������ ��������� �� ������ ���������
  final member function Replace (
    i_Old_Str  Varchar2,
    i_New_Str  Varchar2
  )
  Return Long_String
  is
    v_Result   Long_String;
    v_Index    Integer;
    v_Copied   Integer     := 0;
    v_New_Len  PLS_Integer := NVL(Length(i_New_Str), 0);
    v_Old_Len  PLS_Integer := NVL(Length(i_Old_Str), 0);
  begin
    -- ��������� ������������ ����������
    if i_Old_Str is NULL or Self."Buf_Size " < v_Old_Len then
      -- ���������� ������ ��� ���������
      return Self.Clone();
    elsif "Buf ".Count = 1 and "Buf_Size " + v_New_Len - v_Old_Len <= 32767 then
      -- ���������� ������� ������, ��������� ����� ������ ���������
      -- � ������������ �������� ������
      return Long_String(STANDARD.Replace(Self."Buf "(1), i_Old_Str, i_New_Str));
    end if;
    -- ������� ����� ������� ������
    v_Result := Long_String();
    --
    loop
      -- ����� ��������� ������� ���������
      v_Index := Self.Find_SubStr(i_Old_Str, v_Copied + 1);
      -- �����, ���� ��������� �� �������
      exit when (v_Index = 0);
      --
      -- �������� � ��������� ����� ������ �� ����� ����������
      v_Result.Append(Self.Sub_Str_Array(v_Copied + 1, v_Index - v_Copied - 1));
      --
      if i_New_Str is not NULL then
        -- �������� ��� ���������� �� ��� ��������
        v_Result.Append(i_New_Str);
      end if;
      --
      v_Copied := v_Index + v_Old_Len - 1;
    end loop;
    --
    -- ���������� ���������� ����� ������� � ���������
    v_Result.Append(Self.Sub_Str_Array(v_Copied + 1));
    --
    -- ���������� ���������
    return v_Result;
  end Replace;


  -- ������� �� ������ "�����" ������� �����
  final member function Left_Trim (i_TSet Varchar2) Return Long_String
  is
    P  Integer;
  begin
    -- ���� ����� ������� �� ����� ��������
    if Self."Buf ".Count = 1 then
      -- ������������ ����������� �������
      return Long_String(LTrim(Self."Buf "(1), i_TSet));
    else
      -- ���������� "�����" ������� �����
      P := Self.Find_Char_For_Set(i_TSet, 1, False);
      -- ���� ������� "�����" ������� �����
      if P > 1 then
        -- ���������� ������ ��� "�����" �������� �����
        return Self.Sub_Str_Long(P);
      end if;
      -- ���������� ������ ��� ���������
      return Self.Clone;
    end if;
  end Left_Trim;

  -- ������� �� ������ "�����" ������� ������
  final member function Right_Trim (i_TSet Varchar2) Return Long_String
  is
    P  Integer;
  begin
    -- ���� ����� ������� �� ����� ��������
    if Self."Buf ".Count = 1 then
      -- ������������ ����������� �������
      return Long_String(RTrim(Self."Buf "(1), i_TSet));
    else
      -- ���������� "�����" ������� ������
      P := Self.Find_Char_For_Set_Back(i_TSet, Self."Buf_Size ", False);
      -- ���� ������� "�����" ������� ������
      if P < Self."Buf_Size " then
        -- ���������� ������ ��� "�����" �������� ������
        return Self.Sub_Str_Long(1, P);
      end if;
      -- ���������� ������ ��� ���������
      return Self.Clone;
    end if;
  end Right_Trim;

  -- ������� �� ������ "�����" ������� ����� � ������
  final member function Trim (i_TSet Varchar2) Return Long_String
  is
    L  Integer;
    R  Integer;
  begin
    -- ���� ����� ������� �� ����� ��������
    if Self."Buf ".Count = 1 then
      -- ������������ ����������� �������
      return Long_String(LTrim(RTrim(Self."Buf "(1), i_TSet), i_TSet));
    else
      -- ���������� "�����" ������� ����� � ������
      L := Self.Find_Char_For_Set(i_TSet, 1, False);
      R := Self.Find_Char_For_Set_Back(i_TSet, Self."Buf_Size ", False);
      -- ��������� ������� "�����" �������� ����� � ������
      if L <= 1 and R >= Self."Buf_Size " then
        return Self.Clone;      -- ���������� ������ ��� ���������
      elsif R < L then
        return Long_String();   -- ���������� ������ ������
      elsif L < 1 then
        L := 1;                 -- ���������� � ������� 1
      elsif R > Self."Buf_Size " then
        R := Self."Buf_Size ";  -- ���������� �� ����� ������
      end if;
      -- ���������� ������ ��� "�����" �������� ����� � ������
      return Self.Sub_Str_Long(L, R - L + 1);
    end if;
  end Trim;


  -- ��������� ����� ������ �� �������� ����� �����
  final member function Trunc (i_New_Len Integer) Return Long_String
  is
  begin
    return Self.Sub_Str_Long(1, i_New_Len);
  end Trunc;

  -- ������������� ����������� ������� � ������ � Escape-������������������
  -- �������� �� 27.11.2020
  final member function Escape Return Long_String
  is
    v_Result  Long_String := Long_String();

    -- ������������� ����������� ������� � ������ � Escape-������������������
    Function Escape_Str (i_Str Varchar2) Return Varchar2
    is
    begin
      -- ���������� ��������������� ������
      return STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(
          STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(i_Str,
          '\', '\\'), '/', '\/'), '"', '\"'), Chr(8), '\b'), Chr(9), '\t'),
          Chr(10), '\r'), Chr(12), '\f'), Chr(13), '\n');
    end Escape_Str;

  begin
    -- ����������� ������������� � �������� ����� � ���������
    for I in 1..Self."Buf ".Count
    loop
      -- ��� ��������� ������������, ������������� ��� �������� �������� ���������
      v_Result.Append(Escape_Str(SubStr(Self."Buf "(I), 1, 16384)));
      v_Result.Append(Escape_Str(SubStr(Self."Buf "(I), 16385)));
    end loop;
    -- ���������� ���������
    return v_Result;
  end Escape;

  -- ������������� Escape-������������������ � ������ ������� � ����������� �������
  -- �������� �� 27.11.2020
  final member function Unescape return Long_String
  is
    v_Beg    PLS_Integer := 1;
    v_Pos    PLS_Integer;
    v_Result Long_String;

    -- ������������� Escape-������������������ � ������ ������� � ����������� �������
    Function Unescape_Str (i_Str Varchar2) Return Varchar2
    is
    begin
      -- ���������� ��������������� ������
      return STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(
          STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(i_Str,
          '\\', '\'), '\/', '/'), '\"', '"'), '\b', Chr(8)), '\t', Chr(9)),
          '\r', Chr(10)), '\f', Chr(12)), '\n', Chr(13));
    end Unescape_Str;

    -- �������� ��������� � �����
    Procedure Put_Sub_Str (i_Pos PLS_Integer, i_End PLS_Integer)
    is
      v_Len  PLS_Integer := i_End - i_Pos;
    begin
      -- ���� ����� ��������� ������ 32�
      if v_Len <= 32767 then
        v_Result.Append(Self.Sub_Str(i_Pos, v_Len));
      else
        v_Result.Append(Self.Sub_Str_Array(i_Pos, v_Len));
      end if;
    end Put_Sub_Str;

  begin
    -- ���� ����� ������ ������ 32�
    if Self."Buf_Size " <= 32767 then
      -- ��� �������� ����� ������������ ����� ����������� ��������
      return Long_String(Unescape_Str(Self.To_String()));
    end if;
    -- ����� ������ Escape-������������������
    v_Pos := Self.Find_SubStr('\', 1);
    -- ���������� �������� ������, ���� ������ �� �������� Escape-�������������������
    if v_Pos = 0 then
      return Self;
    end if;
    -- ������� ������� ������ ��� ����������
    v_Result := Long_String();
    -- �������� Escape-������������������ �� ������� �������
    loop
      -- �������� � ����� ���������
      Put_Sub_Str(v_Beg, v_Pos);
      -- ������������� � �������� � ����� ����������� ������
      v_Result.Append(Translate(Self.Get_Char(v_Pos + 1), '\/"btrfn', '\/"'
        || Chr(8) || Chr(9) || Chr(10) || Chr(12) || Chr(13)));
      -- ������ ��������� Escap-������
      v_Beg := v_Pos + 2;
      v_Pos := Self.Find_SubStr('\', v_Beg);
      -- ����� �� �����, ���� ��� ������ Escap-��������
      exit when (v_Pos = 0);
    end loop;
    -- �������� ������� ������ � �����
    Put_Sub_Str(v_Beg, Self."Buf_Size " + 1);
    --
    -- ���������� ���������
    return v_Result;
  end Unescape;



end;
/
