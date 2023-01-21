create or replace package JSON_Parser
is
  Version  Constant Char(14) := '->>09082022<<-';  -- ������ ������������ ������

  -- Author  : �������� �.�.
  -- Created : 19.09.2019 14:50:12
  -- Purpose : ����� ��� �������� ������ JSON
  --           ������������ ��� ������������� � ����������� ���� � �������� ���������




-- *****************************************************************************
-- ***                    ��������� ������� � ���������                      ***
-- *****************************************************************************

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in Varchar2,
    io_JSON    in out nocopy HashMap
  );

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in Long_String,
    io_JSON    in out nocopy HashMap
  );

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in Array_Varchar2,
    io_JSON    in out nocopy HashMap
  );

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in CLob,
    io_JSON    in out nocopy HashMap
  );


  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str Varchar2) Return HashMap;

  -- ��������� ������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str Long_String) Return HashMap;

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str Array_Varchar2) Return HashMap;

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str CLob) Return HashMap;



  ----------------------------------------------------------------------------
  --             ��������� (�����������) ������� � ���������                --
  ----------------------------------------------------------------------------

  -- �������� ������ ��������� (������������) ������
  Function GetVersion Return Varchar2;

  -- �������� ������ ���� ������
  Function GetVersionOfBody Return Varchar2;

end JSON_Parser;
/
create or replace package body json_parser
is
VersionOfBody  Constant Char(14) := '->>11012021<<-';  -- ������ ���� ������


  -- ��������� ��� �������� ������������� ����������
  --Type Variable_List_T is Table of Varchar2(32767) index by Varchar2(31);



  -- ���� ���������������
  c_TT_Error        constant PLS_Integer :=  0;   -- ������������ �����������
  c_TT_Ident        constant PLS_Integer :=  1;   -- ��� (�������������) ����
  c_TT_Number       constant PLS_Integer :=  2;   -- �������� ��������
  c_TT_Number_E     constant PLS_Integer := 20;   -- �������� �������� � E-�������
  c_TT_String       constant PLS_Integer :=  3;   -- ������
  c_TT_Long_String  constant PLS_Integer := 30;   -- ������� ������ (� ������ ����� 32767 ��������)
  c_TT_Boolean      constant PLS_Integer :=  4;   -- ���������� �������� (������, ����)
  c_TT_Null         constant PLS_Integer :=  5;   -- ���������� �������� (������, ����)
  c_TT_JSON_Beg     constant PLS_Integer :=  6;   -- ������ JSON
  c_TT_JSON_End     constant PLS_Integer :=  7;   -- ������ JSON
  c_TT_Array_Beg    constant PLS_Integer :=  8;   -- ������ JSON
  c_TT_Array_End    constant PLS_Integer :=  9;   -- ������ JSON
  c_TT_Comma        constant PLS_Integer := 10;   -- �������
  c_TT_Dbl_Point    constant PLS_Integer := 11;   -- �������
  --
  c_TT_Buffer_End   constant PLS_Integer := 99;   -- ����� ������


  -- ���� ��������
  c_CH_JSon_Beg      constant PLS_Integer := ASCII('{');   --
  c_CH_JSon_End      constant PLS_Integer := ASCII('}');   --
  c_CH_Array_Beg     constant PLS_Integer := ASCII('[');   --
  c_CH_Array_End     constant PLS_Integer := ASCII(']');   --
  c_CH_Space         constant PLS_Integer := ASCII(' ');   --
  c_CH_Tab           constant PLS_Integer := 9;            --
  c_CH_LF            constant PLS_Integer := 10;           --
  c_CH_CR            constant PLS_Integer := 13;           --
  c_CH_Numb_0        constant PLS_Integer := ASCII('0');   --
  c_CH_Numb_9        constant PLS_Integer := ASCII('9');   --
  c_CH_Minus         constant PLS_Integer := ASCII('-');   --
  c_CH_Plus          constant PLS_Integer := ASCII('+');   --
  c_CH_Alpha_A       constant PLS_Integer := ASCII('a');   --
  c_CH_Alpha_HA      constant PLS_Integer := ASCII('A');   --
  c_CH_Alpha_Z       constant PLS_Integer := ASCII('z');   --
  c_CH_Alpha_HZ      constant PLS_Integer := ASCII('Z');   --
  c_CH_E_Notation    constant PLS_Integer := ASCII('E');   --
  c_CH_E_Notation_L  constant PLS_Integer := ASCII('e');   --
  c_CH_UnderLine     constant PLS_Integer := ASCII('_');   --
  c_CH_Point         constant PLS_Integer := ASCII('.');   --
  c_CH_DPoint        constant PLS_Integer := ASCII(':');   --
  c_CH_Sngl_Quote    constant PLS_Integer := ASCII('''');  --
  c_CH_Dbl_Quote     constant PLS_Integer := ASCII('"');   --
  c_CH_Comma         constant PLS_Integer := ASCII(',');   --
  c_CH_Comment       constant PLS_Integer := ASCII('/');   --
  c_CH_Star          constant PLS_Integer := ASCII('*');   --

  -- ��������� ��� �������������� �����
  c_Fmt_Number       constant Varchar2(43) := '99999999999999999999.99999999999999999999';   --
  c_Fmt_Number_E     constant varchar2(26) := '9.99999999999999999999EEEE'; --



-- *****************************************************************************
-- ***            ������� � ��������� ��� ����������� ����������             ***
-- *****************************************************************************

  -- ������������ �������������� ������
  Procedure Raise_Syntax_Error (
    i_Long   Long_String,
    i_Short  Varchar2,
    i_Pos    PLS_Integer,
    i_Msg    Varchar2 := ''
  )
  is
    v_Ind   PLS_Integer := 0;
    v_Line  PLS_Integer := 1;
    v_Symb  PLS_Integer := i_Pos;
  begin
    -- ���������� ����� ������� ������
    while v_Ind < i_Pos
    loop
      --
      if i_Long is not NULL then
        v_Ind := i_Long.Find_SubStr(Chr(10), v_Ind + 1);
      else
        v_Ind := InStr(i_Short, Chr(10), v_Ind + 1);
      end if;
      --
      exit when (v_Ind = 0 or v_Ind > i_Pos);
      --
      v_Line := v_Line + 1;
      v_Symb := i_Pos - v_Ind + 1;
    end loop;
    --
    -- ������������ �������������� ������
    Raise_Application_Error(-20000, '�������������� ������ (������: ' || v_Line
      || ', ������: ' || v_Symb || ')!' || Chr(10) || i_Msg);
  end Raise_Syntax_Error;

  -- ������������ �������������� ������
  Procedure Raise_Syntax_Error (
    i_Buf  Varchar2,
    i_Pos  PLS_Integer,
    i_Msg  Varchar2 := ''
  )
  is
  begin
    -- ������� ������������� ���������
    Raise_Syntax_Error (NULL, i_Buf, i_Pos, i_Msg);
  end Raise_Syntax_Error;

  -- ������������ �������������� ������
  Procedure Raise_Syntax_Error (
    i_Buf  Long_String,
    i_Pos  PLS_Integer,
    i_Msg  Varchar2 := ''
  )
  is
  begin
    -- ������� ������������� ���������
    Raise_Syntax_Error (i_Buf, NULL, i_Pos, i_Msg);
  end Raise_Syntax_Error;

  -- ������������� Escape-������������������ ������� � ����������� �������
  -- ������ �� 27.11.2020
  function Unescape (i_Str Varchar2) return Varchar2
  is
  begin
    -- �������������� �� �������� ��������� �����, �� ���������� Escape-�������������������
    -- ������������� � ������ �� 27.11.2020
    if InStr(i_Str, '\') = 0 then
      return i_Str;
    else
      return Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(i_Str,
        '\\', '\'), '\/', '/'), '\"', '"'), '\b', Chr(8)), '\t', Chr(9)),
        '\r', Chr(10)), '\f', Chr(12)), '\n', Chr(13));
    end if;
  end Unescape;

  -- ������������� Escape-������������������ ������� � ����������� �������
  -- �������� �� 27.11.2020
  function Unescape (i_Str Long_String) return Long_String
  is
  begin
    return i_Str.Unescape();
  end Unescape;


  -- ��������� ������ JSON � ���������� � ���� ���-�������
  -- ������ ��� ����������� ����������
  Procedure Internal_Parse_JSON (
    i_Buf   in     Varchar2,
    io_Pos  in out PLS_Integer,
    io_JSON in out nocopy HashMap
  )
  is
    v_Buf_Size    PLS_Integer;                  -- ������� ��������������
    v_Token       Varchar2(32767);              -- �������������
    v_Buf_Index   PLS_Integer;                  -- ������� ��������������
    v_Token_Pos   PLS_Integer;                  -- ������� ��������������
    v_Token_Type  PLS_Integer;                  -- ������� ��������������
    v_Field_Name  Varchar2(32767);              -- ��� �������


    -- ������������ �������������� ������
    Procedure Syntax_Error (i_Msg Varchar2 := '', i_Pos PLS_Integer := NULL)
    is
    begin
      -- ������� ������������� �������
      Raise_Syntax_Error (i_Buf, NVL(i_Pos, v_Token_Pos), i_Msg);
    end Syntax_Error;


    -- ���������, �������� �� ������ "\", ������������ � ������� i_Pos, ������
    -- ��� ����������� � JSON-������ ���������� ������ ������� "\"
    Function Is_Paired_Escape_Sym (i_Pos PLS_Integer) return Boolean
    is
      v_Index PLS_Integer := i_Pos - 1;
      Result  Boolean     := False;
    begin
      while (v_Index > 0 and SubStr(i_Buf, v_Index, 1) = '\')
      loop
        Result  := not Result;
        v_Index := v_Index - 1;
      end loop;
      return Result;
    end Is_Paired_Escape_Sym;

    -- ������������ ����� � ��������
    Procedure Get_Ident (i_Is_Value Boolean)
    is
      P      PLS_Integer := v_Buf_Index;
      v_Sym  PLS_Integer;
    begin
      -- ���� ��� ������������� ������ �������
      loop
        -- ������� ���������� �������
        P := P + 1;
        -- ����� ������������� �������
        v_Sym := ASCII(SubStr(i_Buf, P, 1));
        --
        exit when
          not ((v_Sym >= c_CH_Numb_0   and v_Sym <= c_CH_Numb_9) or
               (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ) or
               (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or
               (v_Sym = c_CH_UnderLine));
      end loop;
      --
      -- �������� ������
      v_Token := SubStr(i_Buf, v_Buf_Index, P - v_Buf_Index);
      --
      -- ���� ������� �������� ���������
      if i_Is_Value then
        -- ��������� ������������ ��������
        if v_Token = 'true' or v_Token = 'false' then
          v_Token_Type := c_TT_Boolean;                -- ���������� ��������
        elsif v_Token = 'null' then
          v_Token_Type := c_TT_Null;                   -- ����-��������
        else
          Syntax_Error(i_Pos => v_Buf_Index);          -- ������������ ��������
        end if;
      else
        v_Token_Type := c_TT_Ident;                    -- ���� �������� ��� �������
      end if;
      -- ��������������� ������� ��������� ����� ������ � ��������
      v_Buf_Index := P;
    end Get_Ident;

    -- ������������ ����� � ��������
    Procedure Get_Number (i_First_Sym PLS_Integer)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Start  PLS_Integer := v_Buf_Index;
      v_Point  Boolean     := (i_First_Sym = c_CH_Point);
      v_Sym    PLS_Integer;
    begin
      -- ���� ������� �������� ������ "+" ��� "-"
      if i_First_Sym = c_CH_Minus or i_First_Sym = c_CH_Plus then
        -- ������������ ���� "+"
        if i_First_Sym = c_CH_Plus then
          v_Start := v_Start + 1;
        end if;
        -- ������������ �������
        while ASCII(SubStr(i_Buf, P + 1, 1)) in (c_CH_Space, c_CH_Tab)
        loop
          P := P + 1;
        end loop;
      end if;
      -- ���� ��� ������������� ������ �������
      loop
        -- ������� ���������� �������
        P := P + 1;
        -- ��������� ������
        v_Sym := ASCII(SubStr(i_Buf, P, 1));
        --
        if v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9 then
          -- �������� ������
          continue;
        elsif v_Sym = c_CH_Point then
          -- ��������� �����
          if v_Point then
            -- ��������� ��������� �����
            Syntax_Error('�������������� ������: ��������� ��������� �����!', i_Pos => v_Buf_Index);
          else
            v_Point := True;
            continue;
          end if;
        else
          -- ����� �����
          exit;
        end if;
      end loop;
      --
      v_Token_Type := c_TT_Number;
      --
      -- ������: �������� �� 27.11.2020
      -- ���� ������ �������� ��������� E-�������
      if v_Sym = c_CH_E_Notation or v_Sym = c_CH_E_Notation_L then
        -- ������� � ���������� �������
        P := P + 1;
        -- ��������� ������
        v_Sym := ASCII(SubStr(i_Buf, P, 1));
        -- ���������� ����� "+" ��� "-"
        if (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
          P := P + 1;
          v_Sym := ASCII(SubStr(i_Buf, P, 1));
        end if;
        -- ��������� ������� �������
        if v_Sym not between c_CH_Numb_0 and c_CH_Numb_9 then
          -- �������������� ������
          Syntax_Error('�������������� ������: ������������ ������ ��������� ��������!',
                       i_Pos => v_Buf_Index);
        end if;
        -- ��������� ��������� ���������� ����� � E-�������
        loop
          -- ������� � ���������� �������
          P := P + 1;
          -- �����, ���� ������ �� �������� ������
          exit when ASCII(SubStr(i_Buf, P, 1)) not between c_CH_Numb_0 and c_CH_Numb_9;
        end loop;
        --
        v_Token_Type := c_TT_Number_E;
      end if;
      -- �����: �������� �� 27.11.2020
      --
      -- �������� ������
      v_Token := SubStr(i_Buf, v_Start, P - v_Start);
      -- ��������������� ������� ��������� ����� ������ � ��������
      v_Buf_Index := P;
    end Get_Number;

    -- ������������ ����� � ��������
    Procedure Get_String (i_Quote Varchar2)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Quotes Boolean     := False;
    begin
      -- ���� ��� ������������� ������ �������
      loop
        -- ����� ������������� �������
        P := InStr(i_Buf, i_Quote, P + 1);
        --
        if P = 0 then
          -- ��������� ����������� �������!
          Syntax_Error('�������������� ������: ��������� ����������� �������!');
        elsif P > 1 and SubStr(i_Buf, P - 1, 1) = '\' then
          -- ����� �� �����, ���� ��� �� Escape-���� �������� ��� �������
          if Is_Paired_Escape_Sym(P - 1) then
            exit;
          end if;
        elsif SubStr(i_Buf, P + 1, 1) = i_Quote then
          -- ������������ ������ ������� ����������� � �������� ��������� ����
          v_Quotes := True;    -- ��������� ������� ������� ������� ��� ����������� ��������
          P := P + 1;          -- ������������ ������ �������
        else
          exit;
        end if;
      end loop;
      --
      v_Token_Type := c_TT_String;
      -- �������� ������
      v_Token := SubStr(i_Buf, v_Buf_Index + 1, P - v_Buf_Index - 1);
      -- ���� ������� ������ �������, �� �������� �� �� ���������
      if v_Quotes then
        v_Token := Replace(v_Token, i_Quote || i_Quote, i_Quote);
      end if;
      -- ������������� Escape-������������������ ������� � ����������� �������
      if InStr(v_Token, '\') > 0 then
        v_Token := Unescape(v_Token);
      end if;
      -- ��������������� ������� ��������� ����� ������ � ��������
      v_Buf_Index := P + 1;
    end Get_String;

    -- ������������ ������� �����������
    Procedure Skip_Block_Comment
    is
      P  PLS_Integer;
    begin
      -- ����� ������������� �������
      P := InStr(i_Buf, '*'||'/', v_Buf_Index + 2);
      --
      if P = 0 then
        -- �� ������� ������� �����������!
        Syntax_Error('�������������� ������: �� ������� ������� �����������!');
      end if;
      -- ��������������� ������� ��������� ����� �����������
      v_Buf_Index := P + 2;
    end Skip_Block_Comment;

    -- ������������ �������� �����������
    Procedure Skip_Line_Comment
    is
    begin
      -- ����� ������ ��� ���� �������� ����� ������
      while ASCII(SubStr(i_Buf, v_Buf_Index, 1)) not in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      -- ������������ ���� ����������� �������� ����� ������
      while ASCII(SubStr(i_Buf, v_Buf_Index, 1)) in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
    end Skip_Line_Comment;

    -- ��������� ��������� �������
    -- ������������� �� �������� � ������ ������� ���������� �������� � ����������� JSON-������
    Procedure Get_Token (i_Is_Value Boolean := False)
    is
      v_Sym  PLS_Integer;
    begin
      -- ���������� ������� � �������� ��������� ������ �� ������
      loop
        v_Token := SubStr(i_Buf, v_Buf_Index, 1);          -- �������� ��������� ������
        v_Sym   := ASCII(v_Token);                         -- �������� ��� �������
        -- ���� ������ ������
        if v_Sym in (c_CH_Space, c_CH_Tab, c_CH_CR, c_CH_LF) then
          v_Buf_Index := v_Buf_Index + 1;                  -- ���������� ������ ������
          exit when (v_Buf_Index > v_Buf_Size);            -- ����� �� �����, ���� ��������� ����� ������
        elsif v_Sym = c_CH_Comment and v_Buf_Index < v_Buf_Size then
          -- �����������?
          case ASCII(SubStr(i_Buf, v_Buf_Index + 1, 1))
            when c_CH_Comment then Skip_Line_Comment;      -- ������������ �������� ����������
            when c_CH_Star    then Skip_Block_Comment;     -- ������������ ������� ����������
            else                   exit;                   -- �� ����������, ����� �� �����
          end case;
        else
          exit;                                            -- �������� ������, ����� �� �����
        end if;
      end loop;
      --
      v_Token_Pos := v_Buf_Index;                      -- ��������� ������� ������ �������
      --
      if v_Buf_Index > v_Buf_Size then                 -- ���� ��������� ����� ������
        v_Token_Type := c_TT_Buffer_End;               -- ��������� ����� ������
        return;                                        -- �������
      end if;
      --
      -- ������ �������
      if v_Sym = c_CH_Sngl_Quote or v_Sym = c_CH_Dbl_Quote then
        -- �������� �������-������
        Get_String(v_Token);
        return;
      elsif v_Sym = c_CH_Comma then
        -- �������
        v_Token_Type := c_TT_Comma;
      elsif v_Sym = c_CH_DPoint then
        -- ���������
        v_Token_Type := c_TT_Dbl_Point;
      elsif v_Sym = c_CH_JSon_Beg then
        -- ������ ������� JSON
        v_Token_Type := c_TT_JSON_Beg;
      elsif v_Sym = c_CH_JSon_End then
        -- ����� ������� JSON
        v_Token_Type := c_TT_JSON_End;
      elsif v_Sym = c_CH_Array_Beg then
        -- ������ ������� JSON
        v_Token_Type := c_TT_Array_Beg;
      elsif v_Sym = c_CH_Array_End then
        -- ����� ������� JSON
        v_Token_Type := c_TT_Array_End;
      elsif (v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9) or (v_Sym = c_CH_Point) or
            (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
        -- �������� �������-�����
        Get_Number(v_Sym);
        return;
      elsif (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ)
         or (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or v_Sym = c_CH_UnderLine then
        -- �������� �������-�������������
        Get_Ident(i_Is_Value);
        return;
      else
        -- �������������� ������
        v_Token_Type := c_TT_Error;
        return;
      end if;
      --
      v_Buf_Index := v_Buf_Index + 1;
    end Get_Token;

    -- ��������������, ��� ��������� �������� ������ �������� �������� ��������
    Procedure Find_Symbol (i_Symbol Varchar2)
    is
    begin
      -- ������������ �������, ��������� � ������� ����� ������
      while ASCII(SubStr(i_Buf, v_Buf_Index, 1)) in (c_CH_Space, c_CH_Tab, c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      --
      -- ��������� ������� ��������� ������� � ������� �������
      if v_Buf_Index > v_Buf_Size or SubStr(i_Buf, v_Buf_Index, 1) != i_Symbol then
        -- �������������� ������: ����������� ������
        Syntax_Error();                   -- �������������� ������
      end if;
    end Find_Symbol;

    -- ��������� ��������� ����� JSON
    Function Get_JSON Return Hashmap
    is
      v_JSON  Hashmap;
    begin
      -- ����������� ����� ������������ �������
      Internal_Parse_JSON(i_Buf, v_Buf_Index, v_JSON);
      -- ���������� ����� JSON
      return v_JSON;
    end Get_JSON;

    -- ��������� ������������������ ��������
    Function Parse_Array Return Arraylist
    is
      v_Array  Arraylist := Arraylist();
    begin
      v_Buf_Index := v_Buf_Index;                           -- ���������� ������ "["
      -- ��������� ������������������ ��������
      loop
        -- �������� ������� ��� ���������� ��������
        Get_Token(True);
        -- ��������� �������
        if v_Token_Type = c_TT_String then
          v_Array.Push(v_Token);                            -- �������� ������
        elsif v_Token_Type = c_TT_Number then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number));   -- �������� �������� ��������
          --v_Array.Push(Object_T.Format_Number(v_Token));  -- �������� �������� ��������
        --
        -- ������: �������� �� 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number_E)); -- �������� �������� ��������
        --
        -- �����: �������� �� 27.11.2020
        --
        elsif v_Token_Type = c_TT_JSON_Beg then
          v_Buf_Index := v_Token_Pos;                       -- ������ ������� ������� �� ����
          v_Array.Push(Get_JSON());                         -- �������� ��������� ������ JSON
        elsif v_Token_Type = c_TT_Array_Beg then
          v_Array.Push(Parse_Array());                      -- �������� ������ ��������
        elsif v_Token_Type = c_TT_Null then
          v_Array.Push('');                                 -- �������� ����-��������
        elsif v_Token_Type = c_TT_Boolean then
          v_Array.Push(v_Token);                            -- �������� ���������� ��������
        --v_Array.Push(v_Token = 'true');                   -- �������� ���������� ��������
        elsif v_Token_Type = c_TT_Array_End then            -- ����� ������?
          exit;                                             -- ����� �� �����
        else
          Syntax_Error();                                   -- �������������� ������
        end if;
        -- �������� ��������� �������
        Get_Token;
        -- ���� �� �������
        if v_Token_Type = c_TT_Array_End then               -- ����� ������?
          exit;                                             -- ����� �� �����
        elsif v_Token_Type != c_TT_Comma then
          Syntax_Error();                                   -- �������������� ������
        end if;
      end loop;
      --
      return v_Array;                                       -- ���������� ���������
    end Parse_Array;

  begin
    -- ������������ ����������, ���� ����� ����
    if i_Buf is NULL then
      Raise_Application_Error(-20000, '�� ������ JSON-������!');
    end if;
    --
    -- ���������� ��������� ��������
    io_JSON     := HashMap();                   -- ������� ����� ������ JSON
    v_Buf_Index := io_Pos;                      -- ���������������� ������� ���������
    v_Token_Pos := io_Pos;                      -- ���������������� ������� �������
    v_Buf_Size  := Length(i_Buf);               -- ����� (������) �������� ������
    --
    Find_Symbol('{');                           -- ��������������, ��� ��������� ������� �������� �������� "{"
    v_Buf_Index := v_Buf_Index + 1;             -- ����������� ������� ��������� �� ��������� ������
    --
    -- �������� ����������� ������
    while v_Buf_Index <= v_Buf_Size
    loop
      Get_Token;                                -- �������� ��������� �������
      --
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- ����� ������� JSON
      elsif v_Token_Type != c_TT_String and v_Token_Type != c_TT_Ident then
        Syntax_Error();                         -- �������������� ������
      end if;
      --
      v_Field_Name := v_Token;                  -- ��������� ����
      Find_Symbol(':');                         -- ��������������, ��� ��������� ������� �������� �������� ":"
      v_Buf_Index := v_Buf_Index + 1;           -- ����������� ������� ��������� �� ��������� ������
      Get_Token(True);                          -- �������� ������� ��� ��������
      --
      if v_Token_Type = c_TT_String then
        -- �������� ���� "�������-��������" �� ��������� ����������� ���� � ���������
        io_JSON.Put(v_Field_Name, v_Token);
      elsif v_Token_Type = c_TT_Number then
        -- �������� ���� "�������-��������" �� ��������� ��������� ���� � ���������
        io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number));  -- Object_T.Format_Number(v_Token));
        --
        -- ������: �������� �� 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number_E)); -- �������� �������� ��������
        --
        -- �����: �������� �� 27.11.2020
        --
      elsif v_Token_Type = c_TT_JSON_Beg then
        -- ������ ������� ������� �� ����
        v_Buf_Index := v_Token_Pos;
        -- �������� ���� "�������-��������" �� ��������� ���������� ���� � ���������
        io_JSON.Put(v_Field_Name, Get_JSON());
      elsif v_Token_Type = c_TT_Array_Beg then
        -- �������� ���� "�������-��������" �� ������� �������� � ���������
        io_JSON.Put(v_Field_Name, Parse_Array());
      elsif v_Token_Type = c_TT_Null then
        -- ����-��������
        io_JSON.Put(v_Field_Name, '');          -- ������ �� 01.02.2020
      --io_JSON.Put(v_Field_Name, 'null');      -- ��������������� �� 01.02.2020
      --io_JSON.Put_Null(v_Field_Name);
      elsif v_Token_Type = c_TT_Boolean then
        -- ���������� ��������
        io_JSON.Put(v_Field_Name, v_Token);
      --io_JSON.Put(v_Field_Name, (v_Token = 'true'));
      else
        Syntax_Error();                         -- �������������� ������
      end if;
      --
      Get_Token;                                -- �������� ��������� �������
      -- ��������� �������
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- ����� ������� JSON
      elsif v_Token_Type = c_TT_Comma then
        continue;                               -- ����� ������� JSON
      else
        Syntax_Error();                         -- �������������� ������
      end if;
    end loop;
    --
    io_Pos := v_Buf_Index;                      -- ���������� ��������� �� ��������� ������
  end Internal_Parse_JSON;


  -- ��������� ������� ������ JSON � ���������� � ���� ���-�������
  -- ������ ��� ����������� ����������
  Procedure Internal_Parse_JSON (
    i_Buf   in     Long_String,
    io_Pos  in out PLS_Integer,
    io_JSON in out nocopy HashMap
  )
  is
    v_Buf_Size    PLS_Integer;                  -- ������� ��������������
    v_Token       Varchar2(32767);              -- �������������
    v_Token_Long  Long_String;                  -- ������� ������
    v_Buf_Index   PLS_Integer;                  -- ������� ��������������
    v_Token_Pos   PLS_Integer;                  -- ������� ��������������
    v_Token_Type  PLS_Integer;                  -- ������� ��������������
    v_Field_Name  Varchar2(32767);              -- ��� �������


    -- ������������ �������������� ������
    Procedure Syntax_Error (i_Msg Varchar2 := '', i_Pos PLS_Integer := NULL)
    is
    begin
      -- ������� ������������� �������
      Raise_Syntax_Error (i_Buf, NVL(i_Pos, v_Token_Pos), i_Msg);
    end Syntax_Error;


    -- ���������, �������� �� ������ "\", ������������ � ������� i_Pos, ������
    -- ��� ����������� � JSON-������ ���������� ������ ������� "\"
    Function Is_Paired_Escape_Sym (i_Pos PLS_Integer) return Boolean
    is
      v_Index PLS_Integer := i_Pos - 1;
      Result  Boolean     := False;
    begin
      while (v_Index > 0 and i_Buf.Get_Char(v_Index) = '\')
      loop
        Result  := not Result;
        v_Index := v_Index - 1;
      end loop;
      return Result;
    end Is_Paired_Escape_Sym;

    -- ������������ ����� � ��������
    Procedure Get_Ident (i_Is_Value Boolean)
    is
      P      PLS_Integer := v_Buf_Index;
      v_Sym  PLS_Integer;
    begin
      -- ���� ��� ������������� ������ �������
      loop
        -- ������� ���������� �������
        P := P + 1;
        -- ����� ������������� �������
        v_Sym := i_Buf.Get_Char_Code(P);
        --
        exit when
          not ((v_Sym >= c_CH_Numb_0   and v_Sym <= c_CH_Numb_9) or
               (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ) or
               (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or
               (v_Sym = c_CH_UnderLine));
      end loop;
      --
      -- �������� ������
      v_Token := i_Buf.Sub_Str(v_Buf_Index, P - v_Buf_Index);
      --
      -- ���� ������� �������� ���������
      if i_Is_Value then
        -- ��������� ������������ ��������
        if v_Token = 'true' or v_Token = 'false' then
          v_Token_Type := c_TT_Boolean;                -- ���������� ��������
        elsif v_Token = 'null' then
          v_Token_Type := c_TT_Null;                   -- ����-��������
        else
          Syntax_Error(i_Pos => v_Buf_Index);          -- ������������ ��������
        end if;
      else
        v_Token_Type := c_TT_Ident;                    -- ���� �������� ��� �������
      end if;
      -- ��������������� ������� ��������� ����� ������ � ��������
      v_Buf_Index := P;
    end Get_Ident;

    -- ������������ ����� � ��������
    Procedure Get_Number (i_First_Sym PLS_Integer)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Start  PLS_Integer := v_Buf_Index;
      v_Point  Boolean     := (i_First_Sym = c_CH_Point);
      v_Sym    PLS_Integer;
    begin
      -- ���� ������� �������� ������ "+" ��� "-"
      if i_First_Sym = c_CH_Minus or i_First_Sym = c_CH_Plus then
        -- ������������ ���� "+"
        if i_First_Sym = c_CH_Plus then
          v_Start := v_Start + 1;
        end if;
        -- ������������ �������
        while i_Buf.Get_Char_Code(P + 1) in (c_CH_Space, c_CH_Tab)
        loop
          P := P + 1;
        end loop;
      end if;
      -- ���� ��� ������������� ������ �������
      loop
        -- ������� ���������� �������
        P := P + 1;
        -- ��������� ������
        v_Sym := i_Buf.Get_Char_Code(P);
        --
        if v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9 then
          -- �������� ������
          continue;
        elsif v_Sym = c_CH_Point then
          -- ��������� �����
          if v_Point then
            -- ��������� ��������� �����
            Syntax_Error('�������������� ������: ��������� ��������� �����!', i_Pos => v_Buf_Index);
          else
            v_Point := True;
            continue;
          end if;
        else
          -- ����� �����
          exit;
        end if;
      end loop;
      --
      v_Token_Type := c_TT_Number;
      --
      -- ������: �������� �� 27.11.2020
      -- ���� ������ �������� ��������� E-�������
      if v_Sym = c_CH_E_Notation or v_Sym = c_CH_E_Notation_L then
        -- ������� � ���������� �������
        P := P + 1;
        -- ��������� ������
        v_Sym := i_Buf.Get_Char_Code(P);
        -- ���������� ����� "+" ��� "-"
        if (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
          P := P + 1;
          v_Sym := i_Buf.Get_Char_Code(P);
        end if;
        -- ��������� ������� �������
        if v_Sym not between c_CH_Numb_0 and c_CH_Numb_9 then
          -- �������������� ������
          Syntax_Error('�������������� ������: ������������ ������ ��������� ��������!',
                       i_Pos => v_Buf_Index);
        end if;
        -- ��������� ��������� ���������� ����� � E-�������
        loop
          -- ������� � ���������� �������
          P := P + 1;
          -- �����, ���� ������ �� �������� ������
          exit when i_Buf.Get_Char_Code(P) not between c_CH_Numb_0 and c_CH_Numb_9;
        end loop;
        --
        v_Token_Type := c_TT_Number_E;
      end if;
      -- �����: �������� �� 27.11.2020
      --
      -- �������� ������
      v_Token := i_Buf.Sub_Str(v_Start, P - v_Start);
      -- ��������������� ������� ��������� ����� ������ � ��������
      v_Buf_Index := P;
    end Get_Number;

    -- ������������ ����� � ��������
    Procedure Get_String (i_Quote Varchar2)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Quotes Boolean     := False;
      v_Length PLS_Integer;
    begin
      -- ���� ��� ������������� ������ �������
      loop
        -- ����� ������������� �������
        P := i_Buf.Find_SubStr(i_Quote, P + 1);
        --
        if P = 0 then
          -- ��������� ����������� �������!
          Syntax_Error('�������������� ������: ��������� ����������� �������!');
        elsif P > 1 and i_Buf.Get_Char(P - 1) = '\' then
          -- ����� �� �����, ���� ��� �� Escape-���� �������� ��� �������
          if Is_Paired_Escape_Sym(P - 1) then
            exit;
          end if;
        elsif i_Buf.Get_Char(P + 1) = i_Quote then
          -- ������������ ������ ������� ����������� � �������� ��������� ����
          v_Quotes := True;    -- ��������� ������� ������� ������� ��� ����������� ��������
          P := P + 1;          -- ������������ ������ �������
        else
          exit;
        end if;
      end loop;
      --
      -- ������: ��������� �� 27.11.2020
      --
      v_Length := P - v_Buf_Index - 1;
      --
      if v_Length <= 32767 then
        v_Token_Type := c_TT_String;
        -- �������� ������
        v_Token := i_Buf.Sub_Str(v_Buf_Index + 1, v_Length);
        -- ���� ������� ������ �������, �� �������� �� �� ���������
        if v_Quotes then
          v_Token := Replace(v_Token, i_Quote || i_Quote, i_Quote);
        end if;
        -- ������������� Escape-������������������ ������� � ����������� �������
        if InStr(v_Token, '\') > 0 then
          v_Token := Unescape(v_Token);
        end if;
      else
        v_Token_Type := c_TT_Long_String;
        -- �������� ������
        v_Token_Long := i_Buf.Sub_Str_Long(v_Buf_Index + 1, v_Length);
        -- ���� ������� ������ �������, �� �������� �� �� ���������
        if v_Quotes then
          v_Token_Long := v_Token_Long.Replace(i_Quote || i_Quote, i_Quote);
        end if;
        -- ������������� Escape-������������������ ������� � ����������� �������
        if v_Token_Long.Find_SubStr('\', 1) > 0 then  -- ��������� 11.01.2021
          v_Token_Long := v_Token_Long.Unescape();
        end if;
      end if;
      --
      -- �����: ��������� �� 27.11.2020
      --
      -- ��������������� ������� ��������� ����� ������ � ��������
      v_Buf_Index := P + 1;
    end Get_String;

    -- ������������ ������� �����������
    Procedure Skip_Block_Comment
    is
      P  PLS_Integer;
    begin
      -- ����� ������������� �������
      P := i_Buf.Find_SubStr('*'||'/', v_Buf_Index + 2);
      --
      if P = 0 then
        -- �� ������� ������� �����������!
        Syntax_Error('�������������� ������: �� ������� ������� �����������!');
      end if;
      -- ��������������� ������� ��������� ����� �����������
      v_Buf_Index := P + 2;
    end Skip_Block_Comment;

    -- ������������ �������� �����������
    Procedure Skip_Line_Comment
    is
    begin
      -- ����� ������ ��� ���� �������� ����� ������
      while i_Buf.Get_Char_Code(v_Buf_Index) not in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      -- ������������ ���� ����������� �������� ����� ������
      while i_Buf.Get_Char_Code(v_Buf_Index) in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
    end Skip_Line_Comment;

    -- ��������� ��������� �������
    -- ������������� �� �������� � ������ ������� ���������� �������� � ����������� JSON-������
    Procedure Get_Token (i_Is_Value Boolean := False)
    is
      v_Sym  PLS_Integer;
    begin
      -- ���������� ������� � �������� ��������� ������ �� ������
      loop
        v_Token := i_Buf.Get_Char(v_Buf_Index);            -- �������� ��������� ������
        v_Sym   := ASCII(v_Token);                         -- �������� ��� �������
        -- ���� ������ ������
        if v_Sym in (c_CH_Space, c_CH_Tab, c_CH_CR, c_CH_LF) then
          v_Buf_Index := v_Buf_Index + 1;                  -- ���������� ������ ������
          exit when (v_Buf_Index > v_Buf_Size);            -- ����� �� �����, ���� ��������� ����� ������
        elsif v_Sym = c_CH_Comment and v_Buf_Index < v_Buf_Size then
          -- �����������?
          case i_Buf.Get_Char_Code(v_Buf_Index + 1)
            when c_CH_Comment then Skip_Line_Comment;      -- ������������ �������� ����������
            when c_CH_Star    then Skip_Block_Comment;     -- ������������ ������� ����������
            else                   exit;                   -- �� ����������, ����� �� �����
          end case;
        else
          exit;                                            -- �������� ������, ����� �� �����
        end if;
      end loop;
      --
      v_Token_Pos := v_Buf_Index;                      -- ��������� ������� ������ �������
      --
      if v_Buf_Index > v_Buf_Size then                 -- ���� ��������� ����� ������
        v_Token_Type := c_TT_Buffer_End;               -- ��������� ����� ������
        return;                                        -- �������
      end if;
      --
      -- ������ �������
      if v_Sym = c_CH_Sngl_Quote or v_Sym = c_CH_Dbl_Quote then
        -- �������� �������-������
        Get_String(v_Token);
        return;
      elsif v_Sym = c_CH_Comma then
        -- �������
        v_Token_Type := c_TT_Comma;
      elsif v_Sym = c_CH_DPoint then
        -- ���������
        v_Token_Type := c_TT_Dbl_Point;
      elsif v_Sym = c_CH_JSon_Beg then
        -- ������ ������� JSON
        v_Token_Type := c_TT_JSON_Beg;
      elsif v_Sym = c_CH_JSon_End then
        -- ����� ������� JSON
        v_Token_Type := c_TT_JSON_End;
      elsif v_Sym = c_CH_Array_Beg then
        -- ������ ������� JSON
        v_Token_Type := c_TT_Array_Beg;
      elsif v_Sym = c_CH_Array_End then
        -- ����� ������� JSON
        v_Token_Type := c_TT_Array_End;
      elsif (v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9) or (v_Sym = c_CH_Point) or
            (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
        -- �������� �������-�����
        Get_Number(v_Sym);
        return;
      elsif (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ)
         or (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or v_Sym = c_CH_UnderLine then
        -- �������� �������-�������������
        Get_Ident(i_Is_Value);
        return;
      else
        -- �������������� ������
        v_Token_Type := c_TT_Error;
        return;
      end if;
      --
      v_Buf_Index := v_Buf_Index + 1;
    end Get_Token;

    -- ��������������, ��� ��������� �������� ������ �������� �������� ��������
    Procedure Find_Symbol (i_Symbol Varchar2)
    is
    begin
      -- ������������ �������, ��������� � ������� ����� ������
      while i_Buf.Get_Char_Code(v_Buf_Index) in (c_CH_Space, c_CH_Tab, c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      --
      -- ��������� ������� ��������� ������� � ������� �������
      if v_Buf_Index > v_Buf_Size or i_Buf.Get_Char(v_Buf_Index) != i_Symbol then
        -- �������������� ������: ����������� ������
        Syntax_Error();                   -- �������������� ������
      end if;
    end Find_Symbol;

    -- ��������� ��������� ����� JSON
    Function Get_JSON Return Hashmap
    is
      v_JSON  Hashmap;
    begin
      -- ����������� ����� ������������ �������
      Internal_Parse_JSON(i_Buf, v_Buf_Index, v_JSON);
      -- ���������� ����� JSON
      return v_JSON;
    end Get_JSON;

    -- ��������� ������������������ ��������
    Function Parse_Array Return Arraylist
    is
      v_Array  Arraylist := Arraylist();
    begin
      v_Buf_Index := v_Buf_Index;                           -- ���������� ������ "["
      -- ��������� ������������������ ��������
      loop
        -- �������� ������� ��� ���������� ��������
        Get_Token(True);
        -- ��������� �������
        if v_Token_Type = c_TT_String then
          v_Array.Push(v_Token);                            -- �������� ������
        elsif v_Token_Type = c_TT_Number then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number));   -- �������� �������� ��������
          --v_Array.Push(Object_T.Format_Number(v_Token));  -- �������� �������� ��������
        --
        -- ������: �������� �� 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number_E)); -- �������� �������� ��������
        --
        elsif v_Token_Type = c_TT_Long_String then
          v_Array.Push(String_Object_T(v_Token_Long));      -- �������� �������� ��������
          v_Token_Long := NULL;                             -- �������� ����� ������� ������
        --
        -- �����: �������� �� 27.11.2020
        --
        elsif v_Token_Type = c_TT_JSON_Beg then
          v_Buf_Index := v_Token_Pos;                       -- ������ ������� ������� �� ����
          v_Array.Push(Get_JSON());                         -- �������� ��������� ������ JSON
        elsif v_Token_Type = c_TT_Array_Beg then
          v_Array.Push(Parse_Array());                      -- �������� ������ ��������
        elsif v_Token_Type = c_TT_Null then
          v_Array.Push('');                                 -- �������� ����-��������
        elsif v_Token_Type = c_TT_Boolean then
          v_Array.Push(v_Token);                            -- �������� ���������� ��������
        --v_Array.Push(v_Token = 'true');                   -- �������� ���������� ��������
        elsif v_Token_Type = c_TT_Array_End then            -- ����� ������?
          exit;                                             -- ����� �� �����
        else
          Syntax_Error();                                   -- �������������� ������
        end if;
        -- �������� ��������� �������
        Get_Token;
        -- ���� �� �������
        if v_Token_Type = c_TT_Array_End then               -- ����� ������?
          exit;                                             -- ����� �� �����
        elsif v_Token_Type != c_TT_Comma then
          Syntax_Error();                                   -- �������������� ������
        end if;
      end loop;
      --
      return v_Array;                                       -- ���������� ���������
    end Parse_Array;

  begin
    -- ������������ ����������, ���� ����� ����
    if i_Buf is NULL then
      Raise_Application_Error(-20000, '�� ������ JSON-������!');
    end if;
    --
    -- ���������� ��������� ��������
    io_JSON     := HashMap();                   -- ������� ����� ������ JSON
    v_Buf_Index := io_Pos;                      -- ���������������� ������� ���������
    v_Token_Pos := io_Pos;                      -- ���������������� ������� �������
    v_Buf_Size  := i_Buf.Get_Length();          -- ����� (������) �������� ������
    --
    Find_Symbol('{');                           -- ��������������, ��� ��������� ������� �������� �������� "{"
    v_Buf_Index := v_Buf_Index + 1;             -- ����������� ������� ��������� �� ��������� ������
    --
    -- �������� ����������� ������
    while v_Buf_Index <= v_Buf_Size
    loop
      Get_Token;                                -- �������� ��������� �������
      --
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- ����� ������� JSON
      elsif v_Token_Type != c_TT_String and v_Token_Type != c_TT_Ident then
        Syntax_Error();                         -- �������������� ������
      end if;
      --
      v_Field_Name := v_Token;                  -- ��������� ����
      Find_Symbol(':');                         -- ��������������, ��� ��������� ������� �������� �������� ":"
      v_Buf_Index := v_Buf_Index + 1;           -- ����������� ������� ��������� �� ��������� ������
      Get_Token(True);                          -- �������� ������� ��� ��������
      --
      if v_Token_Type = c_TT_String then
        -- �������� ���� "�������-��������" �� ��������� ����������� ���� � ���������
        io_JSON.Put(v_Field_Name, v_Token);
      elsif v_Token_Type = c_TT_Number then
        -- �������� ���� "�������-��������" �� ��������� ��������� ���� � ���������
        io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number));  -- Object_T.Format_Number(v_Token));
        --
        -- ������: �������� �� 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number_E)); -- �������� �������� ��������
        --
        elsif v_Token_Type = c_TT_Long_String then
          io_JSON.Put(v_Field_Name, String_Object_T(v_Token_Long));      -- �������� �������� ��������
          v_Token_Long := NULL;                                          -- �������� ����� ������� ������
        --
        -- �����: �������� �� 27.11.2020
        --
      elsif v_Token_Type = c_TT_JSON_Beg then
        -- ������ ������� ������� �� ����
        v_Buf_Index := v_Token_Pos;
        -- �������� ���� "�������-��������" �� ��������� ���������� ���� � ���������
        io_JSON.Put(v_Field_Name, Get_JSON());
      elsif v_Token_Type = c_TT_Array_Beg then
        -- �������� ���� "�������-��������" �� ������� �������� � ���������
        io_JSON.Put(v_Field_Name, Parse_Array());
      elsif v_Token_Type = c_TT_Null then
        -- ����-��������
        io_JSON.Put(v_Field_Name, '');          -- ������ �� 01.02.2020
      --io_JSON.Put(v_Field_Name, 'null');      -- ��������������� �� 01.02.2020
      --io_JSON.Put_Null(v_Field_Name);
      elsif v_Token_Type = c_TT_Boolean then
        -- ���������� ��������
        io_JSON.Put(v_Field_Name, v_Token);
      --io_JSON.Put(v_Field_Name, (v_Token = 'true'));
      else
        Syntax_Error();                         -- �������������� ������
      end if;
      --
      Get_Token;                                -- �������� ��������� �������
      -- ��������� �������
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- ����� ������� JSON
      elsif v_Token_Type = c_TT_Comma then
        continue;                               -- ����� ������� JSON
      else
        Syntax_Error();                         -- �������������� ������
      end if;
    end loop;
    --
    io_Pos := v_Buf_Index;                      -- ���������� ��������� �� ��������� ������
  end Internal_Parse_JSON;




-- *****************************************************************************
-- ***                    ��������� ������� � ���������                      ***
-- *****************************************************************************

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in Varchar2,
    io_JSON    in out nocopy HashMap
  )
  is
    v_Pos  PLS_Integer := 1;
  begin
    -- ��������� ������ JSON
    Internal_Parse_JSON (i_JSON_Str, v_Pos, io_JSON);
  end Parse_JSON;

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in Long_String,
    io_JSON    in out nocopy HashMap
  )
  is
    v_Pos  PLS_Integer := 1;
  begin
    -- ��� JSON �������� �� 32� ������� ����� ����������� ��������� ��������
    if i_JSON_Str.Get_Length() <= 32767 then
      Internal_Parse_JSON (i_JSON_Str.To_String(), v_Pos, io_JSON);
    else
      Internal_Parse_JSON (i_JSON_Str, v_Pos, io_JSON);
    end if;
  end Parse_JSON;

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in Array_Varchar2,
    io_JSON    in out nocopy HashMap
  )
  is
    v_Pos  PLS_Integer := 1;
  begin
    -- ��� ��������� � ������������ ��������� ������� ����� ����������� ��������� ��������
    if i_JSON_Str is not NULL and i_JSON_Str.Count = 1 then
      -- ������� ����� ����������� ��������� ��������
      Internal_Parse_JSON (i_JSON_Str(1), v_Pos, io_JSON);
    else
      -- ������� ��������� �������� ��� ������� �����
      Parse_JSON (Long_String(i_JSON_Str), io_JSON);
    end if;
  end Parse_JSON;

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Procedure Parse_JSON (
    i_JSON_Str in CLob,
    io_JSON    in out nocopy HashMap
  )
  is
  begin
    -- ������� ������������� ���������
    Parse_JSON (Long_String(i_JSON_Str), io_JSON);
  end Parse_JSON;


  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str Varchar2) Return HashMap
  is
    v_Pos   PLS_Integer := 1;
    v_JSON  HashMap;
  begin
    -- ��������� ������ JSON
    Internal_Parse_JSON (i_JSON_Str, v_Pos, v_JSON);
    -- ���������� ����������
    return v_JSON;
  end Parse_JSON;

  -- ��������� ������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str Long_String) Return HashMap
  is
    v_JSON  HashMap;
  begin
    -- ��������� ������ JSON
    Parse_JSON (i_JSON_Str, v_JSON);
    -- ���������� ����������
    return v_JSON;
  end Parse_JSON;

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str Array_Varchar2) Return HashMap
  is
    v_JSON  HashMap;
  begin
    -- ��������� ������ JSON
    Parse_JSON (i_JSON_Str, v_JSON);
    -- ���������� ����������
    return v_JSON;
  end Parse_JSON;

  -- ��������� ������ JSON � ���������� � ���� ���-�������
  Function Parse_JSON (i_JSON_Str CLob) Return HashMap
  is
  begin
    -- ������� ������������� �������
    return Parse_JSON (Long_String(i_JSON_Str));
  end Parse_JSON;



  ----------------------------------------------------------------------------
  --             ��������� (�����������) ������� � ���������                --
  ----------------------------------------------------------------------------

  -- �������� ������ ��������� (������������) ������
  Function GetVersion Return Varchar2
  is
  begin
    return Version;
  end GetVersion;

  -- �������� ������ ���� ������
  Function GetVersionOfBody Return Varchar2
  is
  begin
    return VersionOfBody;
  end GetVersionOfBody;

end JSON_Parser;
/
