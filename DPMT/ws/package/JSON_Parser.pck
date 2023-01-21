create or replace package JSON_Parser
is
  Version  Constant Char(14) := '->>09082022<<-';  -- Версия спецификации пакета

  -- Author  : Шаюсупов Ш.А.
  -- Created : 19.09.2019 14:50:12
  -- Purpose : Пакет для парсинга строки JSON
  --           Предназначен для использования в интерфейсах ИАБС с внешними системами




-- *****************************************************************************
-- ***                    Сервисные функции и процедуры                      ***
-- *****************************************************************************

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in Varchar2,
    io_JSON    in out nocopy HashMap
  );

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in Long_String,
    io_JSON    in out nocopy HashMap
  );

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in Array_Varchar2,
    io_JSON    in out nocopy HashMap
  );

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in CLob,
    io_JSON    in out nocopy HashMap
  );


  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str Varchar2) Return HashMap;

  -- Разбирать длинную строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str Long_String) Return HashMap;

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str Array_Varchar2) Return HashMap;

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str CLob) Return HashMap;



  ----------------------------------------------------------------------------
  --             Служебные (специальные) функции и процедуры                --
  ----------------------------------------------------------------------------

  -- Получить версию заголовка (спецификации) пакета
  Function GetVersion Return Varchar2;

  -- Получить версию тела пакета
  Function GetVersionOfBody Return Varchar2;

end JSON_Parser;
/
create or replace package body json_parser
is
VersionOfBody  Constant Char(14) := '->>11012021<<-';  -- Версия тела пакета


  -- Коллекция для хранения подставляемых переменных
  --Type Variable_List_T is Table of Varchar2(32767) index by Varchar2(31);



  -- Типы идентификаторов
  c_TT_Error        constant PLS_Integer :=  0;   -- Однострочный комментарий
  c_TT_Ident        constant PLS_Integer :=  1;   -- Имя (идентификатор) поля
  c_TT_Number       constant PLS_Integer :=  2;   -- Числовое значение
  c_TT_Number_E     constant PLS_Integer := 20;   -- Числовое значение в E-нотации
  c_TT_String       constant PLS_Integer :=  3;   -- Строка
  c_TT_Long_String  constant PLS_Integer := 30;   -- Длинная строка (с длиной более 32767 символов)
  c_TT_Boolean      constant PLS_Integer :=  4;   -- Логическое значение (Истина, Ложь)
  c_TT_Null         constant PLS_Integer :=  5;   -- Логическое значение (Истина, Ложь)
  c_TT_JSON_Beg     constant PLS_Integer :=  6;   -- Объект JSON
  c_TT_JSON_End     constant PLS_Integer :=  7;   -- Объект JSON
  c_TT_Array_Beg    constant PLS_Integer :=  8;   -- Массив JSON
  c_TT_Array_End    constant PLS_Integer :=  9;   -- Массив JSON
  c_TT_Comma        constant PLS_Integer := 10;   -- Запятая
  c_TT_Dbl_Point    constant PLS_Integer := 11;   -- Запятая
  --
  c_TT_Buffer_End   constant PLS_Integer := 99;   -- Конец буфера


  -- Типы символов
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

  -- Константа для форматирования чисел
  c_Fmt_Number       constant Varchar2(43) := '99999999999999999999.99999999999999999999';   --
  c_Fmt_Number_E     constant varchar2(26) := '9.99999999999999999999EEEE'; --



-- *****************************************************************************
-- ***            Функции и процедуры для внутреннего назначения             ***
-- *****************************************************************************

  -- Генерировать синтаксическую ошибку
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
    -- Определить номер текущей строки
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
    -- Генерировать синтаксическую ошибку
    Raise_Application_Error(-20000, 'Синтаксическая ошибка (строка: ' || v_Line
      || ', символ: ' || v_Symb || ')!' || Chr(10) || i_Msg);
  end Raise_Syntax_Error;

  -- Генерировать синтаксическую ошибку
  Procedure Raise_Syntax_Error (
    i_Buf  Varchar2,
    i_Pos  PLS_Integer,
    i_Msg  Varchar2 := ''
  )
  is
  begin
    -- Вызвать перегруженную процедуру
    Raise_Syntax_Error (NULL, i_Buf, i_Pos, i_Msg);
  end Raise_Syntax_Error;

  -- Генерировать синтаксическую ошибку
  Procedure Raise_Syntax_Error (
    i_Buf  Long_String,
    i_Pos  PLS_Integer,
    i_Msg  Varchar2 := ''
  )
  is
  begin
    -- Вызвать перегруженную процедуру
    Raise_Syntax_Error (i_Buf, NULL, i_Pos, i_Msg);
  end Raise_Syntax_Error;

  -- Преобразовать Escape-последовательности обратно в специальные символы
  -- Изменён от 27.11.2020
  function Unescape (i_Str Varchar2) return Varchar2
  is
  begin
    -- Оптимизировать на скорость обработки строк, не содержащих Escape-последовательностей
    -- Оптимизирован в версии от 27.11.2020
    if InStr(i_Str, '\') = 0 then
      return i_Str;
    else
      return Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(i_Str,
        '\\', '\'), '\/', '/'), '\"', '"'), '\b', Chr(8)), '\t', Chr(9)),
        '\r', Chr(10)), '\f', Chr(12)), '\n', Chr(13));
    end if;
  end Unescape;

  -- Преобразовать Escape-последовательности обратно в специальные символы
  -- Добавлен от 27.11.2020
  function Unescape (i_Str Long_String) return Long_String
  is
  begin
    return i_Str.Unescape();
  end Unescape;


  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  -- Только для внутреннего назначения
  Procedure Internal_Parse_JSON (
    i_Buf   in     Varchar2,
    io_Pos  in out PLS_Integer,
    io_JSON in out nocopy HashMap
  )
  is
    v_Buf_Size    PLS_Integer;                  -- Позиция идентификатора
    v_Token       Varchar2(32767);              -- Идентификатор
    v_Buf_Index   PLS_Integer;                  -- Позиция идентификатора
    v_Token_Pos   PLS_Integer;                  -- Позиция идентификатора
    v_Token_Type  PLS_Integer;                  -- Позиция идентификатора
    v_Field_Name  Varchar2(32767);              -- Имя объекта


    -- Генерировать синтаксическую ошибку
    Procedure Syntax_Error (i_Msg Varchar2 := '', i_Pos PLS_Integer := NULL)
    is
    begin
      -- Вызвать перегруженную функцию
      Raise_Syntax_Error (i_Buf, NVL(i_Pos, v_Token_Pos), i_Msg);
    end Syntax_Error;


    -- Проверить, является ли символ "\", обнаруженный в позиции i_Pos, парным
    -- для обозначения в JSON-строке собственно самого символа "\"
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

    -- Игнорировать текст в кавычках
    Procedure Get_Ident (i_Is_Value Boolean)
    is
      P      PLS_Integer := v_Buf_Index;
      v_Sym  PLS_Integer;
    begin
      -- Цикл для игнорирования парных кавычек
      loop
        -- Перейти следующему символу
        P := P + 1;
        -- Найти закрывающиеся кавычку
        v_Sym := ASCII(SubStr(i_Buf, P, 1));
        --
        exit when
          not ((v_Sym >= c_CH_Numb_0   and v_Sym <= c_CH_Numb_9) or
               (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ) or
               (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or
               (v_Sym = c_CH_UnderLine));
      end loop;
      --
      -- Получить строку
      v_Token := SubStr(i_Buf, v_Buf_Index, P - v_Buf_Index);
      --
      -- Если лексема является значением
      if i_Is_Value then
        -- Проверить корректность значения
        if v_Token = 'true' or v_Token = 'false' then
          v_Token_Type := c_TT_Boolean;                -- Логическое значение
        elsif v_Token = 'null' then
          v_Token_Type := c_TT_Null;                   -- Нуль-значение
        else
          Syntax_Error(i_Pos => v_Buf_Index);          -- Недопустимое значение
        end if;
      else
        v_Token_Type := c_TT_Ident;                    -- Ключ значения или объекта
      end if;
      -- Позиционировать текущий указатель после текста в кавычках
      v_Buf_Index := P;
    end Get_Ident;

    -- Игнорировать текст в кавычках
    Procedure Get_Number (i_First_Sym PLS_Integer)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Start  PLS_Integer := v_Buf_Index;
      v_Point  Boolean     := (i_First_Sym = c_CH_Point);
      v_Sym    PLS_Integer;
    begin
      -- Если лексема является знаком "+" или "-"
      if i_First_Sym = c_CH_Minus or i_First_Sym = c_CH_Plus then
        -- Игнорировать знак "+"
        if i_First_Sym = c_CH_Plus then
          v_Start := v_Start + 1;
        end if;
        -- Игнорировать пробелы
        while ASCII(SubStr(i_Buf, P + 1, 1)) in (c_CH_Space, c_CH_Tab)
        loop
          P := P + 1;
        end loop;
      end if;
      -- Цикл для игнорирования парных кавычек
      loop
        -- Перейти следующему символу
        P := P + 1;
        -- Извлекать символ
        v_Sym := ASCII(SubStr(i_Buf, P, 1));
        --
        if v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9 then
          -- Цифровой символ
          continue;
        elsif v_Sym = c_CH_Point then
          -- Плавающая точка
          if v_Point then
            -- Повторная плавающая точка
            Syntax_Error('Синтаксическая ошибка: повторная плавающая точка!', i_Pos => v_Buf_Index);
          else
            v_Point := True;
            continue;
          end if;
        else
          -- Конец цифры
          exit;
        end if;
      end loop;
      --
      v_Token_Type := c_TT_Number;
      --
      -- Начало: Добавлен от 27.11.2020
      -- Если символ является признаком E-нотации
      if v_Sym = c_CH_E_Notation or v_Sym = c_CH_E_Notation_L then
        -- Перейти к следующему символу
        P := P + 1;
        -- Извлекать символ
        v_Sym := ASCII(SubStr(i_Buf, P, 1));
        -- Пропустить знаки "+" или "-"
        if (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
          P := P + 1;
          v_Sym := ASCII(SubStr(i_Buf, P, 1));
        end if;
        -- Проверить наличие степени
        if v_Sym not between c_CH_Numb_0 and c_CH_Numb_9 then
          -- Синтаксическая ошибка
          Syntax_Error('Синтаксическая ошибка: некорректный формат числового значения!',
                       i_Pos => v_Buf_Index);
        end if;
        -- Извлекать степенную компоненту числа в E-нотации
        loop
          -- Перейти к следующему символу
          P := P + 1;
          -- Выйти, если символ не является цифром
          exit when ASCII(SubStr(i_Buf, P, 1)) not between c_CH_Numb_0 and c_CH_Numb_9;
        end loop;
        --
        v_Token_Type := c_TT_Number_E;
      end if;
      -- Конец: Добавлен от 27.11.2020
      --
      -- Получить строку
      v_Token := SubStr(i_Buf, v_Start, P - v_Start);
      -- Позиционировать текущий указатель после текста в кавычках
      v_Buf_Index := P;
    end Get_Number;

    -- Игнорировать текст в кавычках
    Procedure Get_String (i_Quote Varchar2)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Quotes Boolean     := False;
    begin
      -- Цикл для игнорирования парных кавычек
      loop
        -- Найти закрывающиеся кавычку
        P := InStr(i_Buf, i_Quote, P + 1);
        --
        if P = 0 then
          -- Пропущена закрывающая кавычка!
          Syntax_Error('Синтаксическая ошибка: пропущена закрывающая кавычка!');
        elsif P > 1 and SubStr(i_Buf, P - 1, 1) = '\' then
          -- Выйти из цикла, если это не Escape-пара символов для кавычки
          if Is_Paired_Escape_Sym(P - 1) then
            exit;
          end if;
        elsif SubStr(i_Buf, P + 1, 1) = i_Quote then
          -- Игнорировать парные кавычки одинакового с внешними кавычками типа
          v_Quotes := True;    -- Запомнить наличие двойных кавычек для дальнейшего удаления
          P := P + 1;          -- Игнорировать парные кавычек
        else
          exit;
        end if;
      end loop;
      --
      v_Token_Type := c_TT_String;
      -- Получить строку
      v_Token := SubStr(i_Buf, v_Buf_Index + 1, P - v_Buf_Index - 1);
      -- Если имеются парные кавычки, то заменить их на одинарные
      if v_Quotes then
        v_Token := Replace(v_Token, i_Quote || i_Quote, i_Quote);
      end if;
      -- Преобразовать Escape-последовательности обратно в специальные символы
      if InStr(v_Token, '\') > 0 then
        v_Token := Unescape(v_Token);
      end if;
      -- Позиционировать текущий указатель после текста в кавычках
      v_Buf_Index := P + 1;
    end Get_String;

    -- Игнорировать блочный комментарий
    Procedure Skip_Block_Comment
    is
      P  PLS_Integer;
    begin
      -- Найти закрывающиеся кавычку
      P := InStr(i_Buf, '*'||'/', v_Buf_Index + 2);
      --
      if P = 0 then
        -- Не закрыть блочный комментарий!
        Syntax_Error('Синтаксическая ошибка: не закрыть блочный комментарий!');
      end if;
      -- Позиционировать текущий указатель после комментарии
      v_Buf_Index := P + 2;
    end Skip_Block_Comment;

    -- Игнорировать строчный комментарий
    Procedure Skip_Line_Comment
    is
    begin
      -- Найти символ или пару символов конца строки
      while ASCII(SubStr(i_Buf, v_Buf_Index, 1)) not in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      -- Игнорировать всех последующих символов конца строки
      while ASCII(SubStr(i_Buf, v_Buf_Index, 1)) in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
    end Skip_Line_Comment;

    -- Извлекать очередную лексему
    -- Оптимизирован на скорость с учетом частоты встречания символов в стандартной JSON-строке
    Procedure Get_Token (i_Is_Value Boolean := False)
    is
      v_Sym  PLS_Integer;
    begin
      -- Пропустить пробелы и получить очередной символ из буфера
      loop
        v_Token := SubStr(i_Buf, v_Buf_Index, 1);          -- Получить очередной символ
        v_Sym   := ASCII(v_Token);                         -- Получить код символа
        -- Если символ пустой
        if v_Sym in (c_CH_Space, c_CH_Tab, c_CH_CR, c_CH_LF) then
          v_Buf_Index := v_Buf_Index + 1;                  -- Пропустить пустой символ
          exit when (v_Buf_Index > v_Buf_Size);            -- Выйти из цикла, если достигнут конец буфера
        elsif v_Sym = c_CH_Comment and v_Buf_Index < v_Buf_Size then
          -- Комментарий?
          case ASCII(SubStr(i_Buf, v_Buf_Index + 1, 1))
            when c_CH_Comment then Skip_Line_Comment;      -- Игнорировать строчный коментарий
            when c_CH_Star    then Skip_Block_Comment;     -- Игнорировать блочный коментарий
            else                   exit;                   -- Не коментарий, выйти из цикла
          end case;
        else
          exit;                                            -- Непустой символ, выйти из цикла
        end if;
      end loop;
      --
      v_Token_Pos := v_Buf_Index;                      -- Сохранить позицию начала лексемы
      --
      if v_Buf_Index > v_Buf_Size then                 -- Если достигнут конец буфера
        v_Token_Type := c_TT_Buffer_End;               -- Достигнут конец буфера
        return;                                        -- Возврат
      end if;
      --
      -- Разбор лексемы
      if v_Sym = c_CH_Sngl_Quote or v_Sym = c_CH_Dbl_Quote then
        -- Получить лексему-строку
        Get_String(v_Token);
        return;
      elsif v_Sym = c_CH_Comma then
        -- Запятая
        v_Token_Type := c_TT_Comma;
      elsif v_Sym = c_CH_DPoint then
        -- Двоеточие
        v_Token_Type := c_TT_Dbl_Point;
      elsif v_Sym = c_CH_JSon_Beg then
        -- Начало объекта JSON
        v_Token_Type := c_TT_JSON_Beg;
      elsif v_Sym = c_CH_JSon_End then
        -- Конец объекта JSON
        v_Token_Type := c_TT_JSON_End;
      elsif v_Sym = c_CH_Array_Beg then
        -- Начало массива JSON
        v_Token_Type := c_TT_Array_Beg;
      elsif v_Sym = c_CH_Array_End then
        -- Конец массива JSON
        v_Token_Type := c_TT_Array_End;
      elsif (v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9) or (v_Sym = c_CH_Point) or
            (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
        -- Получить лексему-число
        Get_Number(v_Sym);
        return;
      elsif (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ)
         or (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or v_Sym = c_CH_UnderLine then
        -- Получить лексему-идентификатор
        Get_Ident(i_Is_Value);
        return;
      else
        -- Синтаксическая ошибка
        v_Token_Type := c_TT_Error;
        return;
      end if;
      --
      v_Buf_Index := v_Buf_Index + 1;
    end Get_Token;

    -- Удостовериться, что следующий непустой символ является заданным символом
    Procedure Find_Symbol (i_Symbol Varchar2)
    is
    begin
      -- Игнорировать пробелы, табуляции и символы конца строки
      while ASCII(SubStr(i_Buf, v_Buf_Index, 1)) in (c_CH_Space, c_CH_Tab, c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      --
      -- Проверить наличие заданного символа в текущей позиции
      if v_Buf_Index > v_Buf_Size or SubStr(i_Buf, v_Buf_Index, 1) != i_Symbol then
        -- Синтаксическая ошибка: Неожиданный символ
        Syntax_Error();                   -- Синтаксическая ошибка
      end if;
    end Find_Symbol;

    -- Извлекать вложенный оъект JSON
    Function Get_JSON Return Hashmap
    is
      v_JSON  Hashmap;
    begin
      -- Рекурсивный вызов родительской функции
      Internal_Parse_JSON(i_Buf, v_Buf_Index, v_JSON);
      -- Возвращать оъект JSON
      return v_JSON;
    end Get_JSON;

    -- Извлекать последовательность значений
    Function Parse_Array Return Arraylist
    is
      v_Array  Arraylist := Arraylist();
    begin
      v_Buf_Index := v_Buf_Index;                           -- Пропустить символ "["
      -- Извлекать последовательность значений
      loop
        -- Получить лексему для очередного значения
        Get_Token(True);
        -- Проверить лексему
        if v_Token_Type = c_TT_String then
          v_Array.Push(v_Token);                            -- Вставить строку
        elsif v_Token_Type = c_TT_Number then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number));   -- Вставить числовое значение
          --v_Array.Push(Object_T.Format_Number(v_Token));  -- Вставить числовое значение
        --
        -- Начало: Добавлен от 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number_E)); -- Вставить числовое значение
        --
        -- Конец: Добавлен от 27.11.2020
        --
        elsif v_Token_Type = c_TT_JSON_Beg then
          v_Buf_Index := v_Token_Pos;                       -- Подать лексему обратно на вход
          v_Array.Push(Get_JSON());                         -- Вставить вложенный объект JSON
        elsif v_Token_Type = c_TT_Array_Beg then
          v_Array.Push(Parse_Array());                      -- Вставить список значений
        elsif v_Token_Type = c_TT_Null then
          v_Array.Push('');                                 -- Вставить Нуль-значение
        elsif v_Token_Type = c_TT_Boolean then
          v_Array.Push(v_Token);                            -- Вставить логическое значение
        --v_Array.Push(v_Token = 'true');                   -- Вставить логическое значение
        elsif v_Token_Type = c_TT_Array_End then            -- Конец списка?
          exit;                                             -- Выход из цикла
        else
          Syntax_Error();                                   -- Синтаксическая ошибка
        end if;
        -- Получить очередную лексему
        Get_Token;
        -- Если не запятая
        if v_Token_Type = c_TT_Array_End then               -- Конец списка?
          exit;                                             -- Выход из цикла
        elsif v_Token_Type != c_TT_Comma then
          Syntax_Error();                                   -- Синтаксическая ошибка
        end if;
      end loop;
      --
      return v_Array;                                       -- Возвращать результат
    end Parse_Array;

  begin
    -- Генерировать исключение, если буфер пуст
    if i_Buf is NULL then
      Raise_Application_Error(-20000, 'Не задана JSON-строка!');
    end if;
    --
    -- Установить начальные значения
    io_JSON     := HashMap();                   -- Создать новый объект JSON
    v_Buf_Index := io_Pos;                      -- Инициализировать текущий указатель
    v_Token_Pos := io_Pos;                      -- Инициализировать позицию лексемы
    v_Buf_Size  := Length(i_Buf);               -- Длина (размер) входного буфера
    --
    Find_Symbol('{');                           -- Удостовериться, что следующая лексема является символом "{"
    v_Buf_Index := v_Buf_Index + 1;             -- Переместить текущий указатель на следующий символ
    --
    -- Разборка содержимого буфера
    while v_Buf_Index <= v_Buf_Size
    loop
      Get_Token;                                -- Получить очередную лексему
      --
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- Конец объекта JSON
      elsif v_Token_Type != c_TT_String and v_Token_Type != c_TT_Ident then
        Syntax_Error();                         -- Синтаксическая ошибка
      end if;
      --
      v_Field_Name := v_Token;                  -- Запомнить ключ
      Find_Symbol(':');                         -- Удостовериться, что следующая лексема является символом ":"
      v_Buf_Index := v_Buf_Index + 1;           -- Переместить текущий указатель на следующий символ
      Get_Token(True);                          -- Получить лексему для значения
      --
      if v_Token_Type = c_TT_String then
        -- Вставить пару "Атрибут-Значение" со значением символьного типа в результат
        io_JSON.Put(v_Field_Name, v_Token);
      elsif v_Token_Type = c_TT_Number then
        -- Вставить пару "Атрибут-Значение" со значением числового типа в результат
        io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number));  -- Object_T.Format_Number(v_Token));
        --
        -- Начало: Добавлен от 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number_E)); -- Вставить числовое значение
        --
        -- Конец: Добавлен от 27.11.2020
        --
      elsif v_Token_Type = c_TT_JSON_Beg then
        -- Подать лексему обратно на вход
        v_Buf_Index := v_Token_Pos;
        -- Вставить пару "Атрибут-Значение" со значением объектного типа в результат
        io_JSON.Put(v_Field_Name, Get_JSON());
      elsif v_Token_Type = c_TT_Array_Beg then
        -- Вставить пару "Атрибут-Значение" со списком значений в результат
        io_JSON.Put(v_Field_Name, Parse_Array());
      elsif v_Token_Type = c_TT_Null then
        -- Нуль-значение
        io_JSON.Put(v_Field_Name, '');          -- Изменён от 01.02.2020
      --io_JSON.Put(v_Field_Name, 'null');      -- Закомментирован от 01.02.2020
      --io_JSON.Put_Null(v_Field_Name);
      elsif v_Token_Type = c_TT_Boolean then
        -- Логическое значение
        io_JSON.Put(v_Field_Name, v_Token);
      --io_JSON.Put(v_Field_Name, (v_Token = 'true'));
      else
        Syntax_Error();                         -- Синтаксическая ошибка
      end if;
      --
      Get_Token;                                -- Получить очередную лексему
      -- Проверить лексему
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- Конец объекта JSON
      elsif v_Token_Type = c_TT_Comma then
        continue;                               -- Конец объекта JSON
      else
        Syntax_Error();                         -- Синтаксическая ошибка
      end if;
    end loop;
    --
    io_Pos := v_Buf_Index;                      -- Возвращать указатель на следующий символ
  end Internal_Parse_JSON;


  -- Разбирать длинной строку JSON и возвращать в виде хэш-таблицы
  -- Только для внутреннего назначения
  Procedure Internal_Parse_JSON (
    i_Buf   in     Long_String,
    io_Pos  in out PLS_Integer,
    io_JSON in out nocopy HashMap
  )
  is
    v_Buf_Size    PLS_Integer;                  -- Позиция идентификатора
    v_Token       Varchar2(32767);              -- Идентификатор
    v_Token_Long  Long_String;                  -- Длинная строка
    v_Buf_Index   PLS_Integer;                  -- Позиция идентификатора
    v_Token_Pos   PLS_Integer;                  -- Позиция идентификатора
    v_Token_Type  PLS_Integer;                  -- Позиция идентификатора
    v_Field_Name  Varchar2(32767);              -- Имя объекта


    -- Генерировать синтаксическую ошибку
    Procedure Syntax_Error (i_Msg Varchar2 := '', i_Pos PLS_Integer := NULL)
    is
    begin
      -- Вызвать перегруженную функцию
      Raise_Syntax_Error (i_Buf, NVL(i_Pos, v_Token_Pos), i_Msg);
    end Syntax_Error;


    -- Проверить, является ли символ "\", обнаруженный в позиции i_Pos, парным
    -- для обозначения в JSON-строке собственно самого символа "\"
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

    -- Игнорировать текст в кавычках
    Procedure Get_Ident (i_Is_Value Boolean)
    is
      P      PLS_Integer := v_Buf_Index;
      v_Sym  PLS_Integer;
    begin
      -- Цикл для игнорирования парных кавычек
      loop
        -- Перейти следующему символу
        P := P + 1;
        -- Найти закрывающиеся кавычку
        v_Sym := i_Buf.Get_Char_Code(P);
        --
        exit when
          not ((v_Sym >= c_CH_Numb_0   and v_Sym <= c_CH_Numb_9) or
               (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ) or
               (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or
               (v_Sym = c_CH_UnderLine));
      end loop;
      --
      -- Получить строку
      v_Token := i_Buf.Sub_Str(v_Buf_Index, P - v_Buf_Index);
      --
      -- Если лексема является значением
      if i_Is_Value then
        -- Проверить корректность значения
        if v_Token = 'true' or v_Token = 'false' then
          v_Token_Type := c_TT_Boolean;                -- Логическое значение
        elsif v_Token = 'null' then
          v_Token_Type := c_TT_Null;                   -- Нуль-значение
        else
          Syntax_Error(i_Pos => v_Buf_Index);          -- Недопустимое значение
        end if;
      else
        v_Token_Type := c_TT_Ident;                    -- Ключ значения или объекта
      end if;
      -- Позиционировать текущий указатель после текста в кавычках
      v_Buf_Index := P;
    end Get_Ident;

    -- Игнорировать текст в кавычках
    Procedure Get_Number (i_First_Sym PLS_Integer)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Start  PLS_Integer := v_Buf_Index;
      v_Point  Boolean     := (i_First_Sym = c_CH_Point);
      v_Sym    PLS_Integer;
    begin
      -- Если лексема является знаком "+" или "-"
      if i_First_Sym = c_CH_Minus or i_First_Sym = c_CH_Plus then
        -- Игнорировать знак "+"
        if i_First_Sym = c_CH_Plus then
          v_Start := v_Start + 1;
        end if;
        -- Игнорировать пробелы
        while i_Buf.Get_Char_Code(P + 1) in (c_CH_Space, c_CH_Tab)
        loop
          P := P + 1;
        end loop;
      end if;
      -- Цикл для игнорирования парных кавычек
      loop
        -- Перейти следующему символу
        P := P + 1;
        -- Извлекать символ
        v_Sym := i_Buf.Get_Char_Code(P);
        --
        if v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9 then
          -- Цифровой символ
          continue;
        elsif v_Sym = c_CH_Point then
          -- Плавающая точка
          if v_Point then
            -- Повторная плавающая точка
            Syntax_Error('Синтаксическая ошибка: повторная плавающая точка!', i_Pos => v_Buf_Index);
          else
            v_Point := True;
            continue;
          end if;
        else
          -- Конец цифры
          exit;
        end if;
      end loop;
      --
      v_Token_Type := c_TT_Number;
      --
      -- Начало: Добавлен от 27.11.2020
      -- Если символ является признаком E-нотации
      if v_Sym = c_CH_E_Notation or v_Sym = c_CH_E_Notation_L then
        -- Перейти к следующему символу
        P := P + 1;
        -- Извлекать символ
        v_Sym := i_Buf.Get_Char_Code(P);
        -- Пропустить знаки "+" или "-"
        if (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
          P := P + 1;
          v_Sym := i_Buf.Get_Char_Code(P);
        end if;
        -- Проверить наличие степени
        if v_Sym not between c_CH_Numb_0 and c_CH_Numb_9 then
          -- Синтаксическая ошибка
          Syntax_Error('Синтаксическая ошибка: некорректный формат числового значения!',
                       i_Pos => v_Buf_Index);
        end if;
        -- Извлекать степенную компоненту числа в E-нотации
        loop
          -- Перейти к следующему символу
          P := P + 1;
          -- Выйти, если символ не является цифром
          exit when i_Buf.Get_Char_Code(P) not between c_CH_Numb_0 and c_CH_Numb_9;
        end loop;
        --
        v_Token_Type := c_TT_Number_E;
      end if;
      -- Конец: Добавлен от 27.11.2020
      --
      -- Получить строку
      v_Token := i_Buf.Sub_Str(v_Start, P - v_Start);
      -- Позиционировать текущий указатель после текста в кавычках
      v_Buf_Index := P;
    end Get_Number;

    -- Игнорировать текст в кавычках
    Procedure Get_String (i_Quote Varchar2)
    is
      P        PLS_Integer := v_Buf_Index;
      v_Quotes Boolean     := False;
      v_Length PLS_Integer;
    begin
      -- Цикл для игнорирования парных кавычек
      loop
        -- Найти закрывающиеся кавычку
        P := i_Buf.Find_SubStr(i_Quote, P + 1);
        --
        if P = 0 then
          -- Пропущена закрывающая кавычка!
          Syntax_Error('Синтаксическая ошибка: пропущена закрывающая кавычка!');
        elsif P > 1 and i_Buf.Get_Char(P - 1) = '\' then
          -- Выйти из цикла, если это не Escape-пара символов для кавычки
          if Is_Paired_Escape_Sym(P - 1) then
            exit;
          end if;
        elsif i_Buf.Get_Char(P + 1) = i_Quote then
          -- Игнорировать парные кавычки одинакового с внешними кавычками типа
          v_Quotes := True;    -- Запомнить наличие двойных кавычек для дальнейшего удаления
          P := P + 1;          -- Игнорировать парные кавычек
        else
          exit;
        end if;
      end loop;
      --
      -- Начало: Переписан от 27.11.2020
      --
      v_Length := P - v_Buf_Index - 1;
      --
      if v_Length <= 32767 then
        v_Token_Type := c_TT_String;
        -- Получить строку
        v_Token := i_Buf.Sub_Str(v_Buf_Index + 1, v_Length);
        -- Если имеются парные кавычки, то заменить их на одинарные
        if v_Quotes then
          v_Token := Replace(v_Token, i_Quote || i_Quote, i_Quote);
        end if;
        -- Преобразовать Escape-последовательности обратно в специальные символы
        if InStr(v_Token, '\') > 0 then
          v_Token := Unescape(v_Token);
        end if;
      else
        v_Token_Type := c_TT_Long_String;
        -- Получить строку
        v_Token_Long := i_Buf.Sub_Str_Long(v_Buf_Index + 1, v_Length);
        -- Если имеются парные кавычки, то заменить их на одинарные
        if v_Quotes then
          v_Token_Long := v_Token_Long.Replace(i_Quote || i_Quote, i_Quote);
        end if;
        -- Преобразовать Escape-последовательности обратно в специальные символы
        if v_Token_Long.Find_SubStr('\', 1) > 0 then  -- Исправлен 11.01.2021
          v_Token_Long := v_Token_Long.Unescape();
        end if;
      end if;
      --
      -- Конец: Переписан от 27.11.2020
      --
      -- Позиционировать текущий указатель после текста в кавычках
      v_Buf_Index := P + 1;
    end Get_String;

    -- Игнорировать блочный комментарий
    Procedure Skip_Block_Comment
    is
      P  PLS_Integer;
    begin
      -- Найти закрывающиеся кавычку
      P := i_Buf.Find_SubStr('*'||'/', v_Buf_Index + 2);
      --
      if P = 0 then
        -- Не закрыть блочный комментарий!
        Syntax_Error('Синтаксическая ошибка: не закрыть блочный комментарий!');
      end if;
      -- Позиционировать текущий указатель после комментарии
      v_Buf_Index := P + 2;
    end Skip_Block_Comment;

    -- Игнорировать строчный комментарий
    Procedure Skip_Line_Comment
    is
    begin
      -- Найти символ или пару символов конца строки
      while i_Buf.Get_Char_Code(v_Buf_Index) not in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      -- Игнорировать всех последующих символов конца строки
      while i_Buf.Get_Char_Code(v_Buf_Index) in (c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
    end Skip_Line_Comment;

    -- Извлекать очередную лексему
    -- Оптимизирован на скорость с учетом частоты встречания символов в стандартной JSON-строке
    Procedure Get_Token (i_Is_Value Boolean := False)
    is
      v_Sym  PLS_Integer;
    begin
      -- Пропустить пробелы и получить очередной символ из буфера
      loop
        v_Token := i_Buf.Get_Char(v_Buf_Index);            -- Получить очередной символ
        v_Sym   := ASCII(v_Token);                         -- Получить код символа
        -- Если символ пустой
        if v_Sym in (c_CH_Space, c_CH_Tab, c_CH_CR, c_CH_LF) then
          v_Buf_Index := v_Buf_Index + 1;                  -- Пропустить пустой символ
          exit when (v_Buf_Index > v_Buf_Size);            -- Выйти из цикла, если достигнут конец буфера
        elsif v_Sym = c_CH_Comment and v_Buf_Index < v_Buf_Size then
          -- Комментарий?
          case i_Buf.Get_Char_Code(v_Buf_Index + 1)
            when c_CH_Comment then Skip_Line_Comment;      -- Игнорировать строчный коментарий
            when c_CH_Star    then Skip_Block_Comment;     -- Игнорировать блочный коментарий
            else                   exit;                   -- Не коментарий, выйти из цикла
          end case;
        else
          exit;                                            -- Непустой символ, выйти из цикла
        end if;
      end loop;
      --
      v_Token_Pos := v_Buf_Index;                      -- Сохранить позицию начала лексемы
      --
      if v_Buf_Index > v_Buf_Size then                 -- Если достигнут конец буфера
        v_Token_Type := c_TT_Buffer_End;               -- Достигнут конец буфера
        return;                                        -- Возврат
      end if;
      --
      -- Разбор лексемы
      if v_Sym = c_CH_Sngl_Quote or v_Sym = c_CH_Dbl_Quote then
        -- Получить лексему-строку
        Get_String(v_Token);
        return;
      elsif v_Sym = c_CH_Comma then
        -- Запятая
        v_Token_Type := c_TT_Comma;
      elsif v_Sym = c_CH_DPoint then
        -- Двоеточие
        v_Token_Type := c_TT_Dbl_Point;
      elsif v_Sym = c_CH_JSon_Beg then
        -- Начало объекта JSON
        v_Token_Type := c_TT_JSON_Beg;
      elsif v_Sym = c_CH_JSon_End then
        -- Конец объекта JSON
        v_Token_Type := c_TT_JSON_End;
      elsif v_Sym = c_CH_Array_Beg then
        -- Начало массива JSON
        v_Token_Type := c_TT_Array_Beg;
      elsif v_Sym = c_CH_Array_End then
        -- Конец массива JSON
        v_Token_Type := c_TT_Array_End;
      elsif (v_Sym >= c_CH_Numb_0 and v_Sym <= c_CH_Numb_9) or (v_Sym = c_CH_Point) or
            (v_Sym = c_CH_Minus or v_Sym = c_CH_Plus) then
        -- Получить лексему-число
        Get_Number(v_Sym);
        return;
      elsif (v_Sym >= c_CH_Alpha_HA and v_Sym <= c_CH_Alpha_HZ)
         or (v_Sym >= c_CH_Alpha_A  and v_Sym <= c_CH_Alpha_Z) or v_Sym = c_CH_UnderLine then
        -- Получить лексему-идентификатор
        Get_Ident(i_Is_Value);
        return;
      else
        -- Синтаксическая ошибка
        v_Token_Type := c_TT_Error;
        return;
      end if;
      --
      v_Buf_Index := v_Buf_Index + 1;
    end Get_Token;

    -- Удостовериться, что следующий непустой символ является заданным символом
    Procedure Find_Symbol (i_Symbol Varchar2)
    is
    begin
      -- Игнорировать пробелы, табуляции и символы конца строки
      while i_Buf.Get_Char_Code(v_Buf_Index) in (c_CH_Space, c_CH_Tab, c_CH_LF, c_CH_CR)
      loop
        v_Buf_Index := v_Buf_Index + 1;
      end loop;
      --
      -- Проверить наличие заданного символа в текущей позиции
      if v_Buf_Index > v_Buf_Size or i_Buf.Get_Char(v_Buf_Index) != i_Symbol then
        -- Синтаксическая ошибка: Неожиданный символ
        Syntax_Error();                   -- Синтаксическая ошибка
      end if;
    end Find_Symbol;

    -- Извлекать вложенный оъект JSON
    Function Get_JSON Return Hashmap
    is
      v_JSON  Hashmap;
    begin
      -- Рекурсивный вызов родительской функции
      Internal_Parse_JSON(i_Buf, v_Buf_Index, v_JSON);
      -- Возвращать оъект JSON
      return v_JSON;
    end Get_JSON;

    -- Извлекать последовательность значений
    Function Parse_Array Return Arraylist
    is
      v_Array  Arraylist := Arraylist();
    begin
      v_Buf_Index := v_Buf_Index;                           -- Пропустить символ "["
      -- Извлекать последовательность значений
      loop
        -- Получить лексему для очередного значения
        Get_Token(True);
        -- Проверить лексему
        if v_Token_Type = c_TT_String then
          v_Array.Push(v_Token);                            -- Вставить строку
        elsif v_Token_Type = c_TT_Number then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number));   -- Вставить числовое значение
          --v_Array.Push(Object_T.Format_Number(v_Token));  -- Вставить числовое значение
        --
        -- Начало: Добавлен от 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          v_Array.Push(To_Number(v_Token, c_Fmt_Number_E)); -- Вставить числовое значение
        --
        elsif v_Token_Type = c_TT_Long_String then
          v_Array.Push(String_Object_T(v_Token_Long));      -- Вставить числовое значение
          v_Token_Long := NULL;                             -- Очистить буфер длинной строки
        --
        -- Конец: Добавлен от 27.11.2020
        --
        elsif v_Token_Type = c_TT_JSON_Beg then
          v_Buf_Index := v_Token_Pos;                       -- Подать лексему обратно на вход
          v_Array.Push(Get_JSON());                         -- Вставить вложенный объект JSON
        elsif v_Token_Type = c_TT_Array_Beg then
          v_Array.Push(Parse_Array());                      -- Вставить список значений
        elsif v_Token_Type = c_TT_Null then
          v_Array.Push('');                                 -- Вставить Нуль-значение
        elsif v_Token_Type = c_TT_Boolean then
          v_Array.Push(v_Token);                            -- Вставить логическое значение
        --v_Array.Push(v_Token = 'true');                   -- Вставить логическое значение
        elsif v_Token_Type = c_TT_Array_End then            -- Конец списка?
          exit;                                             -- Выход из цикла
        else
          Syntax_Error();                                   -- Синтаксическая ошибка
        end if;
        -- Получить очередную лексему
        Get_Token;
        -- Если не запятая
        if v_Token_Type = c_TT_Array_End then               -- Конец списка?
          exit;                                             -- Выход из цикла
        elsif v_Token_Type != c_TT_Comma then
          Syntax_Error();                                   -- Синтаксическая ошибка
        end if;
      end loop;
      --
      return v_Array;                                       -- Возвращать результат
    end Parse_Array;

  begin
    -- Генерировать исключение, если буфер пуст
    if i_Buf is NULL then
      Raise_Application_Error(-20000, 'Не задана JSON-строка!');
    end if;
    --
    -- Установить начальные значения
    io_JSON     := HashMap();                   -- Создать новый объект JSON
    v_Buf_Index := io_Pos;                      -- Инициализировать текущий указатель
    v_Token_Pos := io_Pos;                      -- Инициализировать позицию лексемы
    v_Buf_Size  := i_Buf.Get_Length();          -- Длина (размер) входного буфера
    --
    Find_Symbol('{');                           -- Удостовериться, что следующая лексема является символом "{"
    v_Buf_Index := v_Buf_Index + 1;             -- Переместить текущий указатель на следующий символ
    --
    -- Разборка содержимого буфера
    while v_Buf_Index <= v_Buf_Size
    loop
      Get_Token;                                -- Получить очередную лексему
      --
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- Конец объекта JSON
      elsif v_Token_Type != c_TT_String and v_Token_Type != c_TT_Ident then
        Syntax_Error();                         -- Синтаксическая ошибка
      end if;
      --
      v_Field_Name := v_Token;                  -- Запомнить ключ
      Find_Symbol(':');                         -- Удостовериться, что следующая лексема является символом ":"
      v_Buf_Index := v_Buf_Index + 1;           -- Переместить текущий указатель на следующий символ
      Get_Token(True);                          -- Получить лексему для значения
      --
      if v_Token_Type = c_TT_String then
        -- Вставить пару "Атрибут-Значение" со значением символьного типа в результат
        io_JSON.Put(v_Field_Name, v_Token);
      elsif v_Token_Type = c_TT_Number then
        -- Вставить пару "Атрибут-Значение" со значением числового типа в результат
        io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number));  -- Object_T.Format_Number(v_Token));
        --
        -- Начало: Добавлен от 27.11.2020
        --
        elsif v_Token_Type = c_TT_Number_E then
          io_JSON.Put(v_Field_Name, To_Number(v_Token, c_Fmt_Number_E)); -- Вставить числовое значение
        --
        elsif v_Token_Type = c_TT_Long_String then
          io_JSON.Put(v_Field_Name, String_Object_T(v_Token_Long));      -- Вставить числовое значение
          v_Token_Long := NULL;                                          -- Очистить буфер длинной строки
        --
        -- Конец: Добавлен от 27.11.2020
        --
      elsif v_Token_Type = c_TT_JSON_Beg then
        -- Подать лексему обратно на вход
        v_Buf_Index := v_Token_Pos;
        -- Вставить пару "Атрибут-Значение" со значением объектного типа в результат
        io_JSON.Put(v_Field_Name, Get_JSON());
      elsif v_Token_Type = c_TT_Array_Beg then
        -- Вставить пару "Атрибут-Значение" со списком значений в результат
        io_JSON.Put(v_Field_Name, Parse_Array());
      elsif v_Token_Type = c_TT_Null then
        -- Нуль-значение
        io_JSON.Put(v_Field_Name, '');          -- Изменён от 01.02.2020
      --io_JSON.Put(v_Field_Name, 'null');      -- Закомментирован от 01.02.2020
      --io_JSON.Put_Null(v_Field_Name);
      elsif v_Token_Type = c_TT_Boolean then
        -- Логическое значение
        io_JSON.Put(v_Field_Name, v_Token);
      --io_JSON.Put(v_Field_Name, (v_Token = 'true'));
      else
        Syntax_Error();                         -- Синтаксическая ошибка
      end if;
      --
      Get_Token;                                -- Получить очередную лексему
      -- Проверить лексему
      if v_Token_Type = c_TT_JSON_End then
        exit;                                   -- Конец объекта JSON
      elsif v_Token_Type = c_TT_Comma then
        continue;                               -- Конец объекта JSON
      else
        Syntax_Error();                         -- Синтаксическая ошибка
      end if;
    end loop;
    --
    io_Pos := v_Buf_Index;                      -- Возвращать указатель на следующий символ
  end Internal_Parse_JSON;




-- *****************************************************************************
-- ***                    Сервисные функции и процедуры                      ***
-- *****************************************************************************

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in Varchar2,
    io_JSON    in out nocopy HashMap
  )
  is
    v_Pos  PLS_Integer := 1;
  begin
    -- Разбирать строку JSON
    Internal_Parse_JSON (i_JSON_Str, v_Pos, io_JSON);
  end Parse_JSON;

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in Long_String,
    io_JSON    in out nocopy HashMap
  )
  is
    v_Pos  PLS_Integer := 1;
  begin
    -- Для JSON размером до 32К вызвать более эффективную процедура разборки
    if i_JSON_Str.Get_Length() <= 32767 then
      Internal_Parse_JSON (i_JSON_Str.To_String(), v_Pos, io_JSON);
    else
      Internal_Parse_JSON (i_JSON_Str, v_Pos, io_JSON);
    end if;
  end Parse_JSON;

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in Array_Varchar2,
    io_JSON    in out nocopy HashMap
  )
  is
    v_Pos  PLS_Integer := 1;
  begin
    -- Для коллекции с единственным элементом вызвать более эффективную процедура разборки
    if i_JSON_Str is not NULL and i_JSON_Str.Count = 1 then
      -- Вызвать более эффективную процедура разборки
      Internal_Parse_JSON (i_JSON_Str(1), v_Pos, io_JSON);
    else
      -- Вызвать процедура разборки для длинных строк
      Parse_JSON (Long_String(i_JSON_Str), io_JSON);
    end if;
  end Parse_JSON;

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Procedure Parse_JSON (
    i_JSON_Str in CLob,
    io_JSON    in out nocopy HashMap
  )
  is
  begin
    -- Вызвать перегруженную процедуру
    Parse_JSON (Long_String(i_JSON_Str), io_JSON);
  end Parse_JSON;


  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str Varchar2) Return HashMap
  is
    v_Pos   PLS_Integer := 1;
    v_JSON  HashMap;
  begin
    -- Разбирать строку JSON
    Internal_Parse_JSON (i_JSON_Str, v_Pos, v_JSON);
    -- Возвращать результтат
    return v_JSON;
  end Parse_JSON;

  -- Разбирать длинную строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str Long_String) Return HashMap
  is
    v_JSON  HashMap;
  begin
    -- Разбирать строку JSON
    Parse_JSON (i_JSON_Str, v_JSON);
    -- Возвращать результтат
    return v_JSON;
  end Parse_JSON;

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str Array_Varchar2) Return HashMap
  is
    v_JSON  HashMap;
  begin
    -- Разбирать строку JSON
    Parse_JSON (i_JSON_Str, v_JSON);
    -- Возвращать результтат
    return v_JSON;
  end Parse_JSON;

  -- Разбирать строку JSON и возвращать в виде хэш-таблицы
  Function Parse_JSON (i_JSON_Str CLob) Return HashMap
  is
  begin
    -- Вызвать перегруженную функцию
    return Parse_JSON (Long_String(i_JSON_Str));
  end Parse_JSON;



  ----------------------------------------------------------------------------
  --             Служебные (специальные) функции и процедуры                --
  ----------------------------------------------------------------------------

  -- Получить версию заголовка (спецификации) пакета
  Function GetVersion Return Varchar2
  is
  begin
    return Version;
  end GetVersion;

  -- Получить версию тела пакета
  Function GetVersionOfBody Return Varchar2
  is
  begin
    return VersionOfBody;
  end GetVersionOfBody;

end JSON_Parser;
/
