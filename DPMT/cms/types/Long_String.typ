CREATE OR REPLACE TYPE Long_String force as Object (
--
-- Author   : Шаюсупов Ш.А.
-- Created  : 18.01.2018 04:21:17
-- Version  : ->>27112020<<-
-- System   : ИАБС 6.5.0
-- Subsystem: Ядро ИАБС 6.5.0
-- Purpose  : Объектный тип для возможности поддержки в PL/SQL длинных строк
--            Позволяет хранить и обработать в памяти длинных строк
--            Работает гораздо быстрее, чем строки типа CLOB
--            Более расширенный аналог классов String, StringBuffer и StringBuilder
--            языка Java
  
  
  -- Приватные реквизиты строки (заключены в кавычки, чтобы усложнять
  -- использование извне)
  "Cur_Pos "   Integer,         -- Текущий указатель
  "Buf_Size "  Integer,         -- Общая длина строки
  "Buf "       Array_Varchar2,  -- Постранично-организованный буфер для строки
  
  
  -- Статический метод для получения версии тела объектного типа
  -- Потомственые типы должны определять собственные методы для
  -- получения версии
  static function GetVersion return Varchar2,
  
  
  -- Конструктор для создания нового пустого экземпляра типа
  Constructor Function Long_String (
    Self in out nocopy Long_String
  )
  Return Self as Result,
  
  -- Конструктор для создания нового экземпляра типа из строки
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Varchar2
  )
  Return Self as Result,
  
  -- Конструктор для создания нового экземпляра типа из коллекции строк
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Array_Varchar2
  )
  Return Self as Result,
  
  -- Конструктор для создания нового экземпляра типа из LOB-объекта
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in CLob
  )
  Return Self as Result,
  
  -- Инициализировать атрибуты новой строки
  final member procedure Init (Self in out nocopy Long_String),
  
  -- Клонировать текущую длинную строку
  final member function Clone Return Long_String,
  
  -- Вычислить размер буфера длинной строки заново
  final member procedure Recalc_Size (Self in out nocopy Long_String),
  
  
  -- Генерировать исключение с заданным  кодом ошибки и сообщением об ошибке
  final member procedure Error (
    Self          in Long_String,
    i_Error_Msg   in Varchar2,
    i_Error_Code  in PLS_Integer := 0
  ),
  
  
  -- Возвращать текущий индекс в строке
  final member function Get_Index Return Integer,
  
  -- Возвращать длину строки
  final member function Get_Length Return Integer,
  
  -- Возвращать значение в виде строки
  -- Если длина строки превышает 32К, то генерирует исключение
  final member function To_String Return Varchar2,
  
  -- Возвращать значение в виде коллекции строк
  final member function To_String_Array Return Array_Varchar2,
  
  -- Возвращать значение в виде объекта CLOB
  final member function To_CLob Return CLob,
  
  
  -- Добавить заданную строку в конец буфера длинной строки
  final member procedure Append (
    Self  in out nocopy Long_String,
    i_Str in Varchar2
  ),
  
  -- Добавить заданную коллекцию строк в конец буфера длинной строки
  final member procedure Append (
    Self   in out nocopy Long_String,
    i_List in Array_Varchar2
  ),
  
  -- Добавить заданную длинную строку в конец буфера длинной строки
  final member procedure Append (
    Self     in out nocopy Long_String,
    i_String in Long_String
  ),
  
  -- Добавить содержимое объекта CLOB в конец буфера длинной строки
  final member procedure Append (
    Self      in out nocopy Long_String,
    i_Lob_Loc in CLob
  ),
  
  
  -- Возвращать символ из указанной позиции в буфере
  final member function Get_Char (i_Pos Integer := NULL) Return Varchar2,
  
  -- Возвращать ASCII-код символа из указанной позиции в буфере
  final member function Get_Char_Code (i_Pos Integer := NULL) Return PLS_Integer,
  
  -- Получить строку, в которой находится символ с заданной позиции
  final member function Get_Line (
    i_Pos        Integer := NULL,
    i_Whole_Line Boolean := False
  )
  Return Varchar2,
  
  -- Получить строку, в которой находится символ с заданной позиции
  -- и убрать символы с заданного набора с начала и конца строки
  final member function Get_Line_Trim (
    i_Pos        Integer  := NULL,
    i_Whole_Line Boolean  := False,
    i_TSet       Varchar2 := ' ' || Chr(9)
  )
  Return Varchar2,
  
  -- Возвращать первый символ длинной строки
  final member function Get_First_Char Return Varchar2,
  
  -- Возвращать последний символ длинной строки
  final member function Get_Last_Char Return Varchar2,
  
  -- Возвращать из буфера следующий символ с указанной позиции
  final member function Get_Next_Char (i_Pos Integer := NULL) Return Varchar2,
  
  -- Возвращать из буфера предыдущий символ с указанной позиции
  final member function Get_Prev_Char (i_Pos Integer := NULL) Return Varchar2,
  
  -- Перейти к следующему символу в буфере
  -- Эквивалент последовательных вызовов процедуры Next и функции Get_Char
  final member function Go_To_Next_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2,
  
  -- Перейти к предыдущему символу в буфере
  -- Эквивалент последовательных вызовов процедуры Prev и функции Get_Char
  final member function Go_To_Prev_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2,
  
  -- Проверить, достигнут ли конец строки
  final member function Is_Line_End (i_Pos Integer := NULL) Return Boolean,
  
  -- Проверить, достигнут ли конец буфера
  final member function Is_End (i_Pos Integer := NULL) Return Boolean,
  
  -- Перейти к первому символу
  final member procedure First (Self in out nocopy Long_String),
  
  -- Перейти к началу первой строки
  final member procedure First_Line (Self in out nocopy Long_String),
  
  -- Перейти к последнему символу
  final member procedure Last (Self in out nocopy Long_String),
  
  -- Перейти к началу последней строки
  final member procedure Last_Line (Self in out nocopy Long_String),
  
  -- Установить текущий индекс на заданную позицию
  final member procedure Move_Pos (
    Self in out nocopy Long_String,
    i_New_Pos  Integer
  ),
  
  -- Переместить текущий индекс на заданное количество символов
  final member procedure Move_Pos_By (
    Self in out nocopy Long_String,
    i_Increment  Integer
  ),
  
  -- Перейти к следующему символу
  final member procedure Next (Self in out nocopy Long_String),
  
  -- Перейти к следующей строке
  final member procedure Next_Line (Self in out nocopy Long_String),
  
  -- Перейти к предыдущему символу
  final member procedure Prev (Self in out nocopy Long_String),
  
  -- Перейти к предыдущей строке
  final member procedure Prev_Line (Self in out nocopy Long_String),
  
  
  -- Найти в длинной строке подстроку с заданной позиции
  final member function Find_SubStr (
    i_SubStr  Varchar2,
    i_Pos     Integer := NULL
  )
  Return Integer,
  
  -- Найти в длинной строке подстроку с заданной позиции
  final member function Find_SubStr_Back (
    i_SubStr  Varchar2,
    i_Pos     Integer := NULL
  )
  Return Integer,
  
  
  -- Найти в строке следующий символ, выполняющий условие поиска
  -- Только для внутреннего назначения
  final member function Find_Char_For_Set (
    i_Set     Varchar2,
    i_Pos     Integer := NULL,
    i_In_Set  Boolean := True
  )
  Return Integer,
  
  -- Найти в строке предыдущий символ, выполняющий условие поиска
  final member function Find_Char_For_Set_Back (
    i_Set     Varchar2,
    i_Pos     Integer := NULL,
    i_In_Set  Boolean := True
  )
  Return Integer,
  
  -- Найти в буфере символ, входящий в заданный набор символов
  final member function Find_Char_In_Set  (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer,
  
  -- Найти в буфере символ, не входящий в заданный набор символов
  final member function Find_Char_Not_In_Set  (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer,
  
  -- Найти позицию следующего не являющиегося пробелом символа
  final member function Find_None_Blank_Char (i_Pos Integer := NULL) Return Integer,
  
  -- Найти в буфере следующий не "белый" символ
  final member function Find_None_White_Char (i_Pos Integer := NULL) Return Integer,
  
  -- Найти и извлекать из буфера следующее имя идентификатора
  -- Возвращает позицию первого символа после имени идентификатора
  -- При необходимости игнорирует пробелы и другие "белые" символы
  final member function Find_Identifier (
    io_Pos      in out nocopy Integer,
    o_Token_Pos    out nocopy Integer,
    i_To_Upper_Case  Boolean  := True,
    i_Skip_Blanks    Varchar2 := 'B'
  )
  Return Varchar2,
  
  -- Получить очередную лексему
  -- При необходимости игнорирует пробелы и другие "белые" символы
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
  
  -- Игнорировать пробелы и символы табуляции
  final member procedure Skip_Blanks (Self in out nocopy Long_String),
  
  -- Игнорировать "белые" символы
  -- Пропускает пробелы, табуляции и символы конца строки
  final member procedure Skip_White_Chars (Self in out nocopy Long_String),
  
  -- Получить подстроку с заданной позиции и с заданной длиной
  final member function Sub_Str (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Varchar2,
  
  -- Получить длинную подстроку с заданной позиции и с заданной длиной
  -- в виде коллекции строк
  final member function Sub_Str_Array (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Array_Varchar2,
  
  -- Получить длинную подстроку с заданной позиции и с заданной длиной
  final member function Sub_Str_Long (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Long_String,
  
  -- Формировать из длинной строки коллекцию из подстрок, разделённых
  -- в длинной строке заданной подстрокой-разделителем
  final member function Sub_Str_Items (
    i_Delimeter  Varchar2 := Chr(10),
    i_Pos        Integer  := 1,
    i_Len        Integer  := NULL
  )
  Return Array_Varchar2,
  
  -- Получить из длинной строки коллекцию из подстрок в заданном интервале,
  -- разделённых в длинной строке заданной подстрокой-разделителем
  final member function Sub_Str_Lines (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Array_Varchar2,
  
  -- Соединить длинную строку с заданной строкой
  final member function Concat (i_Str Varchar2) Return Long_String,
  
  -- Соединить длинную строку с заданной коллекцией строк
  final member function Concat (i_Str Array_Varchar2) Return Long_String,
  
  -- Соединить длинную строку с заданной длинной строкой
  final member function Concat (i_Str Long_String) Return Long_String,
  
  -- Удалить в строке заданное количество символов, начиная с заданной позиции
  -- и возвращать результат
  final member function Remove (i_Pos Integer, i_Len Integer) Return Long_String,
  
  -- Вставить в строку заданную подстроку с заданной позиции и возвращать результат
  final member function Insert_Str (i_Str Varchar2, i_Pos Integer) Return Long_String,
  
  -- Сравнить длинную строку с заданной строкой
  final member function Equals (i_Str Varchar2) Return Boolean,
  
  -- Сравнить длинную строку с заданной длинной строкой
  final member function Equals (i_Str Long_String) Return Boolean,
  
  -- Сравнить длинную строку с заданной строкой без учета регистра букв
  final member function Equals_Ignore_Case (i_Str Varchar2) Return Boolean,
  
  -- Сравнить длинную строку с заданной длинной строкой без учета регистра букв
  final member function Equals_Ignore_Case (i_Str Long_String) Return Boolean,
  
  -- Проверить, заканчивается ли длинная строка с заданной подстрокой
  final member function Ends_With (i_Str Varchar2) Return Boolean,
  
  -- Проверить, заканчивается ли длинная строка с заданной подстрокой
  -- без учета регистра букв
  final member function Ends_With_Ignore_Case (i_Str Varchar2) Return Boolean,
  
  -- Проверить, начинается ли длинная строка с заданной подстрокой
  final member function Starts_With (i_Str Varchar2) Return Boolean,
  
  -- Проверить, начинается ли длинная строка с заданной подстрокой
  -- без учета регистра букв
  final member function Starts_With_Ignore_Case (i_Str Varchar2) Return Boolean,
  
  -- Заменить подстроку с заданной позиции и с заданной длиной
  -- на новую подстроку
  final member function Replace (
    i_New_Str  Varchar2,
    i_Pos      Integer,
    i_Len      Integer := NULL
  )
  Return Long_String,
  
  -- Найти и заменить все схождения первой подстроки на вторую подстроку
  final member function Replace (
    i_Old_Str  Varchar2,
    i_New_Str  Varchar2
  )
  Return Long_String,
  
  -- Удалить из строки "белые" символа слева
  final member function Left_Trim (i_TSet Varchar2) Return Long_String,
  
  -- Удалить из строки "белые" символа справа
  final member function Right_Trim (i_TSet Varchar2) Return Long_String,
  
  -- Удалить из строки "белые" символа слева и справа
  final member function Trim (i_TSet Varchar2) Return Long_String,
  
  -- Уменьшить длину строки до заданной новой длины
  final member function Trunc (i_New_Len Integer) Return Long_String,
  
  -- Преобразовать специальные символы в строке в Escape-последовательности
  -- Добавлен от 27.11.2020
  final member function Escape Return Long_String,
  
  -- Преобразовать Escape-последовательности в строке обратно в специальные символы
  -- Добавлен от 27.11.2020
  final member function Unescape return Long_String
  
  
)
final;
/
CREATE OR REPLACE TYPE BODY Long_String
is
  -- Статический метод для получения версии тела объектного типа
  -- Потомственые типы должны определять собственные методы для
  -- получения версии
  static function GetVersion return Varchar2
  is
  begin
    return '->>27112020<<-';
  end GetVersion;

  -- Конструктор для создания пустого экземпляра типа
  Constructor Function Long_String (
    Self in out nocopy Long_String
  )
  Return Self as Result
  is
  begin
    Self.Init;  -- Инициализировать атрибуты новой строки
    return;     -- Возврат
  end Long_String;

  -- Конструктор для создания экземпляра типа из строки
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Varchar2
  )
  Return Self as Result
  is
  begin
    Self.Init;             -- Инициализировать атрибуты новой строки
    Self.Append(i_Value);  -- Добавить в конец буфера строку
    return;                -- Возврат
  end Long_String;

  -- Конструктор для создания экземпляра типа из коллекции строк
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in Array_Varchar2
  )
  Return Self as Result
  is
  begin
    Self.Init;             -- Инициализировать атрибуты новой строки
    Self.Append(i_Value);  -- Добавить в конец буфера коллекцию строк
    return;                -- Возврат
  end Long_String;

  -- Конструктор для создания экземпляра типа из LOB-объекта
  Constructor Function Long_String (
    Self    in out nocopy Long_String,
    i_Value in CLob
  )
  Return Self as Result
  is
  begin
    Self.Init;             -- Инициализировать атрибуты новой строки
    Self.Append(i_Value);  -- Добавить в конец буфера CLOB-строку
    return;                -- Возврат
  end Long_String;

  -- Инициализировать атрибуты новой строки
  final member procedure Init (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos "  := 1;                   -- Текущий указатель
    Self."Buf_Size " := 0;                   -- Общая длина строки
    Self."Buf "      := Array_Varchar2('');  -- Буфер для строки
  end Init;

  -- Клонировать текущую длинную строку
  final member function Clone Return Long_String
  is
  begin
    -- Для клонирования достаточно присвоить в результат текущую длинную строку
    return (Self);
  end Clone;

  -- Вычислить размер буфера длинной строки заново
  final member procedure Recalc_Size (Self in out nocopy Long_String)
  is
    v_Size  Integer := 0;
  begin
    -- Проверить корректность состояния длинной строки
    if Self."Buf " is not NULL and Self."Buf ".Count > 0 then
      -- Вычислить размер буфера
      for I in 1..Self."Buf ".Count
      loop
        v_Size := v_Size + NVL(Length(Self."Buf "(I)), 0);
      end loop;
    else
      -- Ошибка: инициализировать буфер заново
      Self."Buf " := Array_Varchar2('');
    end if;
    -- Установить новый размер буфера
    Self."Buf_Size " := v_Size;
    -- Установить текущий индекс на начало буфера
    Self."Cur_Pos " := 1;
  end Recalc_Size;


  -- Генерировать исключение с заданным  кодом ошибки и сообщением об ошибке
  final member procedure Error (
    Self          in Long_String,
    i_Error_Msg   in Varchar2,
    i_Error_Code  in PLS_Integer := 0
  )
  is
  begin
    -- Генерировать исключение с заданным  кодом ошибки и сообщением об ошибке
    Raise_Application_Error(-20000 - i_Error_Code, i_Error_Msg);
    --
    -- Добавим невыполняемый код, чтобы сделать компилятор довольным
    if Self is NULL then
      NULL;  -- Никогда не будет выполняться, но сделает компилятор довольным
    end if;
  end Error;

  -- Возвращать текущий индекс в строке
  final member function Get_Index Return Integer
  is
  begin
    return Self."Cur_Pos ";
  end Get_Index;

  -- Возвращать длину строки
  final member function Get_Length Return Integer
  is
  begin
    return Self."Buf_Size ";
  end Get_Length;

  -- Возвращать значение в виде строки
  -- Если длина строки превышает 32К, то генерирует исключение
  final member function To_String Return Varchar2
  is
  begin
    if Self."Buf_Size " > 32767 then
      -- Подстрока не помещается в буфер
      Error('Подстрока не помещается в буфере!');
    end if;
    -- Возвращать значение в виде строки
    return Self.Sub_Str(1, Self."Buf_Size ");
  end To_String;

  -- Возвращать значение в виде коллекции строк
  final member function To_String_Array Return Array_Varchar2
  is
  begin
    -- Возвращать значение в виде коллекции строк
    return Self."Buf ";
  end To_String_Array;

  -- Возвращать значение в виде объекта CLOB
  final member function To_CLob Return CLob
  is
    v_Result  CLob;
  begin
    -- Возвращать NULL, если строка пуста
    if Self."Buf_Size " = 0 then
      return NULL;
    end if;
    -- Присвоить первую страницу буфера в результат
    v_Result := Self."Buf "(1);
    -- Возвращать значение в виде объекта CLOB
    for I in 2..Self."Buf ".Count
    loop
      -- Добавить страницу буфера в результат
      DBMS_Lob.WriteAppend(v_Result, Length(Self."Buf "(I)), Self."Buf "(I));
    end loop;
    -- Возвращать значение в виде объекта CLOB
    return v_Result;
  end To_CLob;



  -- Добавить заданную строку в конец буфера длинной строки
  final member procedure Append (
    Self  in out nocopy Long_String,
    i_Str in Varchar2
  )
  is
    v_Page_Len  PLS_Integer;
  begin
    -- Если длинная строка пуста
    if i_Str is NULL then
      return;  -- Игнорировать пустую строку
    elsif Self."Buf " is NULL or Self."Buf ".Count = 0 then
      -- Инициализировать новый буфер с заданной строкой
      Self."Buf " := Array_Varchar2(i_Str);
    else
      -- Определить длину последней страницы буфера
      v_Page_Len := NVL(Length(Self."Buf "("Buf ".Count)), 0);
      --
      -- Если строка помещается в последней странице буфера
      if v_Page_Len + Length(i_Str) < 32767 then
        -- Добавить строку в последнюю страницу буфера
        "Buf "("Buf ".Count) := "Buf "("Buf ".Count) || i_Str;
      else
        -- Добавить часть строки в последнюю страницу буфера
        "Buf "("Buf ".Count) := "Buf "("Buf ".Count)
                             || SubStr(i_Str, 1, 32767 - v_Page_Len);
        --
        -- Добавить в буфер новую страницу
        "Buf ".Extend;
        -- Вставить оставшуюся часть строки в новую страницу буфера
        "Buf "(Self."Buf ".Count) := SubStr(i_Str, 32767 - v_Page_Len + 1);
      end if;
    end if;
    -- Корректировать размер буфера
    Self."Buf_Size " := NVL(Self."Buf_Size ", 0) + Length(i_Str);
  end Append;

  -- Добавить заданную коллекцию строк в конец буфера длинной строки
  final member procedure Append (
    Self   in out nocopy Long_String,
    i_List in Array_Varchar2
  )
  is
  begin
    -- Ничего не делать, если задана пустая коллекция
    if i_List is NULL or i_List.Count = 0 then
      return;  -- Выход из процедуры
    end if;
    -- Добавить элементы коллекции в конец буфера
    for I in 1..i_List.Count
    loop
      Self.Append(i_List(I));  -- Добавить элемент в конец буфера
    end loop;
  end Append;

  -- Добавить заданную длинную строку в конец буфера длинной строки
  final member procedure Append (
    Self     in out nocopy Long_String,
    i_String in Long_String
  )
  is
  begin
    -- Добавить длинную строку в конец буфера
    Self.Append(i_String."Buf ");
  end Append;

  -- Добавить содержимое объекта CLOB в конец буфера длинной строки
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
    -- Цикл до тех пор, пока не будет считано меньше 32К символов
    while v_Lob_Offset < v_Lob_Length
    loop
      -- Считывать данные в временный буфер
      DBMS_Lob.Read(i_Lob_Loc, v_Read_Count, v_Lob_Offset, v_Str);
      -- Выйти, если не считанных данных
      exit when (v_Read_Count = 0);
      --
      -- Добавить считанную порцию строки в буфер
      Self.Append(v_Str);
      -- Увеличить длину буфера
      v_Lob_Offset := v_Lob_Offset + v_Read_Count;
    end loop;
  end Append;


  -- Возвращать символ из указанной позиции в буфере
  final member function Get_Char (i_Pos Integer := NULL) Return Varchar2
  is
    P  Integer := NVL(i_Pos, Self."Cur_Pos ") - 1;
  begin
    -- Если указанная позиция выходит за рамки буфера
    if P >= "Buf_Size " or P < 0 then
      return NULL;             -- Возвращать NULL
    end if;
    -- Возвращать символ из указанной позиции в буфере
    return SubStr("Buf "(floor(P / 32767) + 1), (P mod 32767 + 1), 1);
  end Get_Char;

  -- Возвращать ASCII-код символа из указанной позиции в буфере
  final member function Get_Char_Code (i_Pos Integer := NULL) Return PLS_Integer
  is
    P  Integer := NVL(i_Pos, Self."Cur_Pos ") - 1;
  begin
    -- Если указанная позиция выходит за рамки буфера
    if P >= "Buf_Size " or P < 0 then
      return NULL;             -- Возвращать NULL
    end if;
    -- Возвращать символ из указанной позиции в буфере
    return ASCII(SubStr("Buf "(floor(P / 32767) + 1), P mod 32767 + 1, 1));
  end Get_Char_Code;

  -- Получить строку, в которой находится символ с заданной позиции
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
    -- Если требуется получить строку целиком
    if i_Whole_Line then
      -- Определить левую границу строки
      v_Beg := Self.Find_SubStr_Back(Chr(10), v_Pos) + 1;
    end if;
    -- Определить правую границу строки
    v_End := Self.Find_SubStr(Chr(10), v_Pos);
    --
    -- Если строка не является последней строкой
    if v_End > 0 then
      -- Возвращать строку из середины длинной строки
      return Self.Sub_Str(v_Beg, v_End - v_Beg);
    else
      -- Возвращать последнюю строку длинной строки
      return Self.Sub_Str(v_Beg, Self."Buf_Size " - v_Beg + 1);
    end if;
  end Get_Line;

  -- Получить строку, в которой находится символ с заданной позиции
  -- и убрать символы с заданного набора с начала и конца строки
  final member function Get_Line_Trim (
    i_Pos        Integer  := NULL,
    i_Whole_Line Boolean  := False,
    i_TSet       Varchar2 := ' ' || Chr(9)
  )
  Return Varchar2
  is
  begin
    -- Вызвать функцию получения строки
    return LTrim(RTrim(Get_Line(i_Pos, i_Whole_Line), i_TSet), i_TSet);
  end Get_Line_Trim;

  -- Возвращать первый символ длинной строки
  final member function Get_First_Char Return Varchar2
  is
  begin
    return Get_Char(1);  -- Возвращать первый символ
  end Get_First_Char;

  -- Возвращать последний символ длинной строки
  final member function Get_Last_Char Return Varchar2
  is
  begin
    return Get_Char(Self."Buf_Size ");  -- Возвращать последний символ
  end Get_Last_Char;

  -- Возвращать из буфера следующий символ с указанной позиции
  final member function Get_Next_Char (i_Pos Integer := NULL) Return Varchar2
  is
  begin
    -- Вызвать функцию, возвращающую из буфера следующий символ с указанной позиции
    return Get_Char(NVL(i_Pos, Self."Cur_Pos ") + 1);
  end Get_Next_Char;

  -- Возвращать из буфера предыдущий символ с указанной позиции
  final member function Get_Prev_Char (i_Pos Integer := NULL) Return Varchar2
  is
  begin
    -- Вызвать функцию, возвращающую из буфера следующий символ с указанной позиции
    return Get_Char(NVL(i_Pos, Self."Cur_Pos ") - 1);
  end Get_Prev_Char;


  -- Перейти к следующему символу в буфере
  -- Эквивалент последовательных вызовов процедуры Next и функции Get_Char
  final member function Go_To_Next_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2
  is
  begin
    -- Если еще не достигнут конец буфера
    if Self."Cur_Pos " <= "Buf_Size " then
      Self."Cur_Pos " := Self."Cur_Pos " + 1;    -- Перейти к следующему символу
    end if;
    -- Вызвать функцию, возвращающую из буфера следующий символ с указанной позиции
    return Self.Get_Char(Self."Cur_Pos ");
  end Go_To_Next_Char;

  -- Перейти к предыдущему символу в буфере
  -- Эквивалент последовательных вызовов процедуры Prev и функции Get_Char
  final member function Go_To_Prev_Char (
    Self in out nocopy Long_String
  )
  Return Varchar2
  is
  begin
    -- Если еще не достигнут начало буфера
    if Self."Cur_Pos " > 0 then
      Self."Cur_Pos " := Self."Cur_Pos " - 1;      -- Перейти к предыдущему символу
    end if;
    -- Вызвать функцию, возвращающую из буфера следующий символ с указанной позиции
    return Self.Get_Char(Self."Cur_Pos ");
  end Go_To_Prev_Char;

  -- Проверить, достигнут ли конец строки
  final member function Is_Line_End (i_Pos Integer := NULL) Return Boolean
  is
    v_Pos  Integer := NVL(i_Pos, Self."Cur_Pos ");
  begin
    -- Если достигнут конец буфера, возвращать "истина"
    if v_Pos > Self."Buf_Size " then
      return True;                    -- Достигнут конец буфера
    end if;
    -- Проверить, достигнут ли конец строки
    return (Self.Get_Char(v_Pos) = Chr(10));
  end Is_Line_End;

  -- Проверить, достигнут ли конец буфера
  final member function Is_End (i_Pos Integer := NULL) Return Boolean
  is
  begin
    return (NVL(i_Pos, Self."Cur_Pos ") > Self."Buf_Size ");
  end Is_End;


  -- Перейти к первому символу
  final member procedure First (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos " := 1;    -- Перейти к первому символу
  end First;

  -- Перейти к началу первой строки
  final member procedure First_Line (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos " := 1;    -- Перейти к началу первой строки
  end First_Line;

  -- Перейти к последнему символу
  final member procedure Last (Self in out nocopy Long_String)
  is
  begin
    Self."Cur_Pos " := Self."Buf_Size ";    -- Перейти к последнему символу
  end Last;

  -- Перейти к началу последней строки
  final member procedure Last_Line (Self in out nocopy Long_String)
  is
  begin
    -- Перейти к началу последней строки
    Self."Cur_Pos " := Self.Find_SubStr_Back(Chr(10), Self."Buf_Size ") + 1;
  end Last_Line;

  -- Установить текущий индекс на заданную позицию
  final member procedure Move_Pos (
    Self in out nocopy Long_String,
    i_New_Pos  Integer
  )
  is
  begin
    -- Проверить корректность параметра
    if i_New_Pos is NULL then
      return;                                  -- Не задана позиция - ничего не делать
    elsif i_New_Pos <= 1 then
      Self."Cur_Pos " := 1;                    -- Перейти к началу буфера
    elsif i_New_Pos > Self."Buf_Size " then
      Self."Cur_Pos " := Self."Buf_Size " + 1; -- Перейти к концу буфера
    else
      Self."Cur_Pos " := i_New_Pos;            -- Перейти к заданному позицию
    end if;
  end Move_Pos;

  -- Переместить текущий индекс на заданное количество символов
  final member procedure Move_Pos_By (
    Self in out nocopy Long_String,
    i_Increment  Integer
  )
  is
  begin
    -- Переместить текущий индекс на заданное количество символов
    Self.Move_Pos(Self."Cur_Pos " + i_Increment);
  end Move_Pos_By;

  -- Перейти к следующему символу
  final member procedure Next (Self in out nocopy Long_String)
  is
  begin
    -- Если еще не достигнут конец буфера
    if Self."Cur_Pos " <= Self."Buf_Size " then
      Self."Cur_Pos " := Self."Cur_Pos " + 1;      -- Перейти к следующему символу
    end if;
  end Next;

  -- Перейти к следующей строке
  final member procedure Next_Line (Self in out nocopy Long_String)
  is
    v_Pos  Integer := Self.Find_SubStr(Chr(10), Self."Cur_Pos ");
  begin
    -- Если текущая строка не является последней строкой
    if v_Pos > 0 then
      Self."Cur_Pos " := v_Pos + 1;             -- Перейти к следующей строке
    else
      Self."Cur_Pos " := Self."Buf_Size " + 1;  -- Перейти к концу буфера
    end if;
  end Next_Line;

  -- Перейти к предыдущему символу
  final member procedure Prev (Self in out nocopy Long_String)
  is
  begin
    -- Если еще не достигнут начало буфера
    if Self."Cur_Pos " > 0 then
      Self."Cur_Pos " := Self."Cur_Pos " - 1;      -- Перейти к предыдущему символу
    end if;
  end Prev;

  -- Перейти к предыдущей строке
  final member procedure Prev_Line (Self in out nocopy Long_String)
  is
  begin
    -- Перейти к предыдущей строке
    Self."Cur_Pos " := Self.Find_SubStr_Back(Chr(10), "Cur_Pos " - 1) + 1;
  end Prev_Line;


  -- Найти в длинной строке подстроку с заданной позиции
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
    -- Проверить допустимость длины подстроки для поиска
    if i_SubStr is NULL or v_Pos is NULL or v_Pos + v_SubLen > "Buf_Size " then
      return 0;           -- Подстрока пустая или не может быть найдена
    elsif v_SubLen > 16384 then
      -- Задана слишком длинная строка для поиска (больше 16384 символов)
      Error('Задана слишком длинная строка для поиска (больше 16384 символов)!');
    elsif v_Pos < 1 then
      v_At_Pos := 1;      -- Искать с начала буфера
      v_Page   := 1;      -- С первой страницы
    end if;
    --
    loop
      -- Искать подстроку в странице буфера
      v_Find := InStr("Buf "(v_Page), i_SubStr, v_At_Pos);
      -- Если плдстрока найдена
      if v_Find > 0 then
        return ((v_Page - 1) * 32767 + v_Find);
      elsif v_Page = "Buf ".Count then
        return 0;
      elsif v_SubLen > 1 then
        -- Если подстрока содержит более двух символом, то искать также на стыке
        -- двух страниц буфера
        v_Ind  := 32767 - v_SubLen + 2;
        v_Find := InStr(SubStr("Buf "(v_Page), v_Ind) || SubStr("Buf "(v_Page + 1),
                          1, v_SubLen - 1), i_SubStr);
        -- Если плдстрока найдена
        if v_Find > 0 then
          return ((v_Page - 1) * 32767 + v_Ind + v_Find - 1);
        end if;
      end if;
      v_Page   := v_Page + 1;  -- Перейти на следующую страницу
      v_At_Pos := 1;           -- В следующих страницах искать с первой позиции
    end loop;
    -- Оператор ниже никогда не выполнится (добавлен для хорошего тона)
    return 0;
  end Find_SubStr;

  -- Найти в длинной строке подстроку с заданной позиции
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
    -- Проверить допустимость длины подстроки для поиска
    if i_SubStr is NULL or v_Pos is NULL or v_Pos < v_SubLen then
      return 0;                   -- Подстрока пустая или не может быть найдена
    elsif v_SubLen > 16384 then
      -- Задана слишком длинная строка для поиска (больше 16384 символов)
      Error('Задана слишком длинная строка для поиска (больше 16384 символов)!');
    elsif v_Pos > "Buf_Size " or v_Page > "Buf ".Count then
      v_At_Pos := -1;             -- Искать с конца буфера
      v_Page   := "Buf ".Count;   -- С последней страницы
    else
      -- Вычислить позицию подстроки для поиска с конца страницы
      v_At_Pos := - (Length("Buf "(v_Page)) - v_At_Pos + 1);
    end if;
    --
    loop
      -- Искать подстроку в странице буфера
      v_Find := InStr("Buf "(v_Page), i_SubStr, v_At_Pos);
      -- Если плдстрока найдена
      if v_Find > 0 then
        return ((v_Page - 1) * 32767 + v_Find);
      end if;
      --
      if v_Page = 1 then
        return 0;
      elsif v_SubLen > 1 then
        -- Если подстрока содержит более двух символом, то искать также на стыке
        -- двух страниц буфера
        v_Ind  := 32767 - v_SubLen + 2;
        v_Find := InStr(SubStr("Buf "(v_Page - 1), v_Ind) || SubStr("Buf "(v_Page),
                          1, v_SubLen - 1), i_SubStr, -1);
        -- Если плдстрока найдена
        if v_Find > 0 then
          return ((v_Page - 1) * 32767 + v_Ind + v_Find - 1);
        end if;
      end if;
      v_Page   := v_Page - 1;  -- Перейти на предыдущую страницу
      v_At_Pos := -1;          -- В предыдущих страницах искать с конца страницы
    end loop;
    -- Оператор ниже никогда не выполнится (добавлен для хорошего тона)
    return 0;
  end Find_SubStr_Back;


  -- Найти в строке следующий символ, выполняющий условие поиска
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
    -- Пока не достигнут конец буфера
    while (v_Pos <= "Buf_Size ")
    loop
      -- Найти поззицию символа в заданном наборе символов
      v_Ind := InStr(i_Set, SubStr("Buf "(floor((v_Pos - 1) / 32767) + 1),
                 (v_Pos - 1) mod 32767 + 1, 1));
      --
      -- Выйти из цикла, если результат выполняет условие поиска
      exit when (v_Ind > 0 and i_In_Set) or (v_Ind = 0 and not i_In_Set);
      -- Перейти на следующую позицию
      v_Pos := v_Pos + 1;
    end loop;
    -- Возвращать позицию символа, входящего в заданный набор
    return v_Pos;
  end Find_Char_For_Set;

  -- Найти в строке предыдущий символ, выполняющий условие поиска
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
    -- Пока не достигнут конец буфера
    while (v_Pos >= 1)
    loop
      -- Найти поззицию символа в заданном наборе символов
      v_Ind := InStr(i_Set, SubStr("Buf "(floor((v_Pos - 1) / 32767) + 1),
                 (v_Pos - 1) mod 32767 + 1, 1));
      --
      -- Выйти из цикла, если результат выполняет условие поиска
      exit when (v_Ind > 0 and i_In_Set) or (v_Ind = 0 and not i_In_Set);
      -- Перейти на следующую позицию
      v_Pos := v_Pos - 1;
    end loop;
    -- Возвращать позицию символа, входящего в заданный набор
    return v_Pos;
  end Find_Char_For_Set_Back;

  -- Найти позицию следующего символа, входящего в заданный набор символов
  final member function Find_Char_In_Set (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer
  is
  begin
    -- Возвращать позицию символа, входящего в заданный набор символов
    return Self.Find_Char_For_Set(i_Set, i_Pos, True);
  end Find_Char_In_Set;

  -- Найти позицию следующего символа, не входящего в заданный набор символов
  final member function Find_Char_Not_In_Set  (
    i_Set  Varchar2,
    i_Pos  Integer := NULL
  )
  Return Integer
  is
  begin
    -- Возвращать позицию символа, не входящего в заданный набор символов
    return Self.Find_Char_For_Set(i_Set, i_Pos, False);
  end Find_Char_Not_In_Set;

  -- Найти позицию следующего не являющиегося пробелом символа
  final member function Find_None_Blank_Char (i_Pos Integer := NULL) Return Integer
  is
  begin
    -- Возвращать позицию следующего не являющиегося пробелом символа
    return Self.Find_Char_For_Set(' '||Chr(9), i_Pos, False);
  end Find_None_Blank_Char;

  -- Найти позицию следующего не являющиегося "белым" символа
  final member function Find_None_White_Char (i_Pos Integer := NULL) Return Integer
  is
  begin
    -- Возвращать позицию следующего не являющиегося "белым" символа
    return Self.Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), i_Pos, False);
  end Find_None_White_Char;


  -- Найти и извлекать из буфера следующее имя идентификатора
  -- Возвращает позицию первого символа после имени идентификатора
  -- При необходимости игнорирует пробелы и другие "белые" символы
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
    -- Если требуется игнорировать все "белые" символы
    if i_Skip_Blanks = 'B' or i_Skip_Blanks = 'b' then
      -- Пропустить пробелы и символы табуляции
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    elsif i_Skip_Blanks = 'W' or i_Skip_Blanks = 'w' then
      -- Пропустить все "белые" символы
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    end if;
    -- Сохранить позицию начала лексемы
    o_Token_Pos := P;
    --
    -- Сканировать буфер
    <<outer_loop>>
    while (P <= Self."Buf_Size ")
    loop
      -- Извлекать из буфера очередной блок
      v_Block := SubStr("Buf "(floor((P - 1) / 32767) + 1), (P - 1) mod 32767 + 1, 32);
      -- Если блок пуст
      if v_Block is NULL then
        exit;                  -- Достигнут конец буфера - выйти из цикла
      end if;
      --
      for I in 1..Length(v_Block)
      loop
        -- Извлекать ASCII-код символа по индексу
        v_Sym := ASCII(SubStr(v_Block, I, 1));
        -- Выйти, если символ не является:
        --   для первого символа   : буквой или символом "_"
        --   для следующих символов: буквой, цифрой или одним из символов
        --   "_", "$", "." (символ "." необходим для поддержки точечной нотации)
        if P = o_Token_Pos and not ((v_Sym >= 65 and v_Sym <= 90) or
            (v_Sym >= 97 and v_Sym <= 122) or v_Sym = 95) then
          -- Не найдена имя идентификатора - возвращать пустую строку
          return '';
        elsif not ((v_Sym >= 65 and v_Sym <= 90) or (v_Sym >= 97 and v_Sym <= 122)
                or (v_Sym >= 48 and v_Sym <= 57)
                or v_Sym = 95 or v_Sym = 36 or v_Sym = 46) then
          --
          exit outer_loop;   -- Выйти из внешнего цикла
        end if;
        P := P + 1;          -- Переместить указатель на следующий символ
      end loop;
    end loop;
    io_Pos := P;             -- Возвращать текущую позицию
    --
    -- Извлекать из буфера имя идентификатора
    if o_Token_Pos > Self."Buf_Size " then
      return Chr(0);              -- Конец скрипта - возвращать нуль-терминатор
    elsif P = o_Token_Pos then
      return '';                  -- Возвращать пустую строку
    elsif i_To_Upper_Case then
      -- Возвращать имя идентификатора
      return Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
    else
      -- Возвращать имя идентификатора
      return Self.Sub_Str(o_Token_Pos, P - o_Token_Pos);
    end if;
  end Find_Identifier;

/*
  -- Найти и извлекать из буфера следующее имя идентификатора
  -- Возвращает позицию первого символа после имени идентификатора
  -- При необходимости игнорирует пробелы и другие "белые" символы
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
    -- Если требуется игнорировать все "белые" символы
    if i_Skip_Blanks = 'B' or i_Skip_Blanks = 'b' then
      -- Пропустить пробелы и символы табуляции
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    elsif i_Skip_Blanks = 'W' or i_Skip_Blanks = 'w' then
      -- Пропустить все "белые" символы
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    end if;
    -- Сохранить позицию начала лексемы
    v_Begin := P;
    --
    -- Сканировать буфер
    while (P <= Self."Buf_Size ")
    loop
      -- Извлекать ASCII-код символа по индексу
      v_Sym := ASCII(SubStr("Buf "(floor((P - 1) / 32767) + 1), (P - 1) mod 32767 + 1, 1));
      -- Выйти, если символ не является буквой
      if P = v_Begin and not ((v_Sym >= 65 and v_Sym <= 90) or
          (v_Sym >= 97 and v_Sym <= 122) or v_Sym  = 95) then
        -- Возвращать пустую строку
        return '';
      elsif not ((v_Sym >= 65 and v_Sym <= 90) or (v_Sym >= 97 and v_Sym <= 122)
              or (v_Sym >= 48 and v_Sym <= 57) or v_Sym = 95 or v_Sym = 36) then
        -- Выйти из цикла
        exit;
      end if;
      -- Перейти на следующий символ
      P := P + 1;
    end loop;
    --
    -- Извлекать из буфера имя идентификатора
    if P > Self."Buf_Size " then
      -- Конец скрипта - возвращать нуль-терминатор
      return Chr(0);
    elsif P = v_Begin then
      -- Возвращать лексему-символ
      return '';
    elsif i_To_Upper_Case then
      -- Возвращать лексему-идентификатор
      return Upper(Self.Sub_Str(v_Begin, P - v_Begin));
    else
      -- Возвращать лексему-идентификатор
      return Self.Sub_Str(v_Begin, P - v_Begin);
    end if;
  end Find_Identifier;
*/

  -- Получить очередную лексему
  -- При необходимости игнорирует пробелы и другие "белые" символы
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
    -- Вызвать перегруженную функцию
    o_Token := Find_Identifier(P, o_Token_Pos, i_To_Upper_Case, i_Skip_Blanks);
    -- Если имя идентификатора не пуст
    if o_Token is not NULL then
      -- При необходимости установить текущий индекс к началу лексемы
      if i_Move_After then
        -- Установить позицию
        Self."Cur_Pos " := P;
      elsif i_Move_Before then
        Self."Cur_Pos " := o_Token_Pos;
      end if;
    end if;
  end Find_Identifier;

/*
  -- Получить очередную лексему
  -- При необходимости игнорирует пробелы и другие "белые" символы
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
    -- Если требуется игнорировать все "белые" символы
    if i_Skip_Blanks = 'B' or i_Skip_Blanks = 'b' then
      -- Пропустить пробелы и символы табуляции
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    elsif i_Skip_Blanks = 'W' or i_Skip_Blanks = 'w' then
      -- Пропустить все "белые" символы
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    end if;
    -- При необходимости установить текущий индекс к началу лексемы
    if i_Move_Before then
      Self."Cur_Pos " := P;
    end if;
    --
    o_Token_Pos := P;  -- Сохранить позицию начала лексемы
    --
    -- Сканировать буфер
    while (P <= Self."Buf_Size ")
    loop
      -- Извлекать ASCII-код символа по индексу
      v_Sym := ASCII(SubStr("Buf "(floor((P - 1) / 32767) + 1), (P - 1) mod 32767 + 1, 1));
      --
      if P = o_Token_Pos then
        -- Выйти, если символ не является буквой
        exit when not ((v_Sym >= 65 and v_Sym <=  90) or
                       (v_Sym >= 97 and v_Sym <= 122) or
                        v_Sym  = 95);
      else
        -- Выйти, если символ не является буквой
        exit when not ((v_Sym >= 65 and v_Sym <=  90) or
                       (v_Sym >= 97 and v_Sym <= 122) or
                       (v_Sym >= 48 and v_Sym <=  57) or
                        v_Sym  = 95 or  v_Sym  =  36);
      end if;
      -- Перейти на следующий символ
      P := P + 1;
    end loop;
    --
    -- При необходимости установить текущий индекс к концу лексемы
    if i_Move_After then
      Self."Cur_Pos " := P;
    end if;
    --
    if P > Self."Buf_Size " then
      -- Конец скрипта - возвращать нуль-терминатор
      o_Token := Chr(0);
    elsif P = o_Token_Pos then
      -- Возвращать лексему-символ
      o_Token := '';  -- Self.Get_Char(P);
    elsif i_To_Upper_Case then
      -- Возвращать лексему-идентификатор
      o_Token := Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
    else
      -- Возвращать лексему-идентификатор
      o_Token := Self.Sub_Str(o_Token_Pos, P - o_Token_Pos);
    end if;
  end Find_Identifier;

  -- Получить очередную лексему
  -- При необходимости игнорирует пробелы и другие "белые" символы
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

    -- Функция для по-блочного поиска конца имени идентификатора
    Function Find_Token_End (i_Pos Integer) Return Integer
    is
      v_Sym   PLS_Integer;
      v_Str   Varchar2(32) := SubStr("Buf "(floor((i_Pos-1)/32767)+1), (i_Pos-1) mod 32767 + 1, 32);
      v_Len   PLS_Integer  := NVL(Length(v_Str), 0);
    begin
      -- Искать конец имени в блоке
      for I in 1..v_Len
      loop
        -- Извлекать ASCII-код символа по индексу
        v_Sym := ASCII(SubStr(v_Str, I, 1));
        -- Выйти, если символ не является буквой
        if not ((v_Sym >= 65 and v_Sym <=  90) or (v_Sym >= 97 and v_Sym <= 122) or
                (v_Sym >= 48 and v_Sym <=  57) or  v_Sym  = 95 or  v_Sym  =  36) then
          -- Возвращать текущую позицию
          return i_Pos + I - 1;
        end if;
      end loop;
      --
      if i_Pos + v_Len <= Self."Buf_Size " and v_Len > 0 then
        -- Рекурсивный вызов для сканирования следующего блока
        return Find_Token_End(i_Pos + v_Len);
      else
        -- Поиск завершен
        return (i_Pos + v_Len);
      end if;
    end Find_Token_End;

  begin
    -- Если требуется игнорировать все "белые" символы
    if i_Skip_Any_White then
      -- Пропустить все "белые" символы
      P := Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13), P, False);
    else
      -- Пропустить пробелы и символы табуляции
      P := Find_Char_For_Set(' '||Chr(9), P, False);
    end if;
    -- При необходимости установить текущий индекс к началу лексемы
    if i_Move_Before then
      Self."Cur_Pos " := P;
    end if;
    --
    o_Token_Pos := P;  -- Сохранить позицию начала лексемы
    --
    -- Извлекать ASCII-код символа по индексу
    v_Sym := ASCII(SubStr("Buf "(floor((P-1) / 32767) + 1), (P - 1) mod 32767 + 1, 1));
    -- Выйти, если символ не является буквой
    if ((v_Sym >= 65 and v_Sym <=  90) or
                   (v_Sym >= 97 and v_Sym <= 122) or
                    v_Sym  = 95) then
      -- Функция для по-блочного поиска конца имени идентификатора
      P := Find_Token_End(P + 1);
    end if;
    --
    -- При необходимости установить текущий индекс к концу лексемы
    if i_Move_After then
      Self."Cur_Pos " := P;
    end if;
    --
    if P > Self."Buf_Size " then
      -- Конец скрипта - возвращать нуль-терминатор
      o_Token := Chr(0);
    elsif P = o_Token_Pos then
      -- Возвращать лексему-символ
      o_Token := '';  -- Self.Get_Char(P);
    elsif i_To_Upper_Case then
      -- Возвращать лексему-идентификатор
      o_Token := Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
--
--      if v_Page = floor((P-1) / 32767) + 1 then
--        o_Token := Upper(SubStr(Self."Buf "(v_Page), (o_Token_Pos - 1) mod 32767 + 1, P - o_Token_Pos));
--      else
--      -- Возвращать лексему-идентификатор
--      o_Token := Upper(Self.Sub_Str(o_Token_Pos, P - o_Token_Pos));
--      end if;
--
    else
      -- Возвращать лексему-идентификатор
      o_Token := Self.Sub_Str(o_Token_Pos, P - o_Token_Pos);
    end if;
  end Find_Identifier;
*/


  -- Игнорировать пробелы и символы табуляции
  final member procedure Skip_Blanks (Self in out nocopy Long_String)
  is
  begin
    -- Перейти на следующий символ, не являющейся пробелом
    Self."Cur_Pos " := Self.Find_Char_For_Set(' '||Chr(9), Self."Cur_Pos ", False);
  end Skip_Blanks;

  -- Игнорировать "белые" символы
  -- Пропускает пробелы, табуляции и символы конца строки
  final member procedure Skip_White_Chars (Self in out nocopy Long_String)
  is
  begin
    -- Перейти на следующий символ, не являющейся "белым"
    Self."Cur_Pos " := Self.Find_Char_For_Set(' '||Chr(9)||Chr(10)||Chr(13),
        Self."Cur_Pos ", False);
  end Skip_White_Chars;

  -- Получить подстроку с заданной позиции и с заданной длиной
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
    -- Проверить корректность параметров
    if i_Pos is NULL or v_Len < 1 or i_Pos > "Buf_Size " then
      return '';                 -- Возвращать пустую строку
    elsif v_Len > 32767 then
      -- Подстрока не помещается в буфер
      Error('Подстрока не помещается в буфер!');
    elsif v_Page_1 = v_Page_2 then
      -- Извлекать подстроку из одной страницы буфера
      return SubStr("Buf "(v_Page_1), (v_Pos - 1) mod 32767 + 1, v_Len);
    end if;
    -- Извлекать подстроку из двух страниц буфера
    return SubStr("Buf "(v_Page_1), (v_Pos - 1) mod 32767 + 1) ||
           SubStr("Buf "(v_Page_2), 1, (v_Pos + v_Len - 2) mod 32767 + 1);
  end Sub_Str;

  -- Получить длинную подстроку с заданной позиции и с заданной длиной
  -- в виде коллекции строк
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
    -- Проверить корректность параметров
    if i_Pos is NULL or v_Len < 1 or v_Pos > "Buf_Size " then
      -- Возвращать пустую коллекцию строк
      return Array_Varchar2();
    elsif v_Len <= 32767 then
      -- Возвращать пустую коллекцию строк
      return Array_Varchar2(Self.Sub_Str(v_Pos, v_Len));
    end if;
    -- Инициализировать коллекцию для результата
    v_Sub := Array_Varchar2();
    -- Вычислить начальную и конечную страницу
    v_Page_1 := floor((v_Pos - 1) / 32767) + 1;
    v_Page_2 := floor((v_Pos + v_Len - 2) / 32767) + 1;
    --
    -- Цикл по страницам интервала
    for I in v_Page_1..v_Page_2
    loop
      -- Расширить коллекцию
      v_Sub.Extend;
      -- Добавить очередную порцию подстроки в коллекцию
      if I = v_Page_1 then
        -- Часть подстроки из начальной страницы
        v_Sub(v_Sub.Count) := SubStr("Buf "(I), (v_Pos - 1) mod 32767 + 1);
      elsif I = v_Page_2 then
        -- Часть подстроки из последней страницы
        v_Sub(v_Sub.Count) := SubStr("Buf "(I), 1, (v_Pos + v_Len - 2) mod 32767 + 1);
      else
        -- Средние страницы добавить целиком
        v_Sub(v_Sub.Count) := "Buf "(I);
      end if;
    end loop;
    -- Вощвращать подстроку в виде коллекции строк
    return v_Sub;
  end Sub_Str_Array;

  -- Получить длинную подстроку с заданной позиции и с заданной длиной
  final member function Sub_Str_Long (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Long_String
  is
  begin
    -- Вощвращать длинную подстроку из подстроку в виде коллекции строк
    return Long_String(Sub_Str_Array(i_Pos, i_Len));
  end Sub_Str_Long;

  -- Формировать из длинной строки коллекцию из подстрок, разделённых
  -- в длинной строке заданной подстрокой-разделителем
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
    -- Возвращать пустую коллекцию, если буфер пуст
    if Self."Buf_Size " = 0 or Self."Buf " is NULL or Self."Buf ".Count = 0 or
        i_Len <= 0 then
      -- Возвращать пустую коллекцию
      return v_Result;
    elsif i_Pos > 1 then
      v_Index := i_Pos;
    end if;
    -- Если задана длина подстроки, то учитывать его
    if i_Len is not NULL then
      v_End_Pos := v_Index + i_Len - 1;
    end if;
    -- Цикл по элементам
    while v_Index <= v_End_Pos
    loop
      -- Получить позицию следующего разделителя элементов
      v_Next_Pos := Find_SubStr(i_Delimeter, v_Index);
      -- Расширить коллекцию
      v_Result.Extend;
      -- Добавить новый элемент коллекцию
      if v_Next_Pos = 0 or v_Next_Pos > v_End_Pos then
        -- Добавить в коллекцию последний элемент
        v_Result(v_Result.Count) := Sub_Str(v_Index, v_End_Pos - v_Index + 1);
        -- Выход из цикла
        exit;
      else
        -- Добавить элемент в коллекцию
        v_Result(v_Result.Count) := Sub_Str(v_Index, v_Next_Pos - v_Index);
        -- Перейти к следующемцу элементу
        v_Index := v_Next_Pos + 1;
      end if;
    end loop;
    -- Возвращать результат
    return v_Result;
  end Sub_Str_Items;

  -- Получить из длинной строки коллекцию из подстрок в заданном интервале,
  -- разделённых в длинной строке заданной подстрокой-разделителем
  final member function Sub_Str_Lines (
    i_Pos  Integer,
    i_Len  Integer := NULL
  )
  Return Array_Varchar2
  is
  begin
    -- Вощвращать длинную подстроку из подстроку в виде коллекции строк
    return Sub_Str_Items(Chr(10), i_Pos, i_Len);
  end Sub_Str_Lines;

  -- Соединить длинную строку с заданной строкой
  final member function Concat (i_Str Varchar2) Return Long_String
  is
    v_Result  Long_String;
  begin
    -- Клонировать текущую строку
    v_Result := Self.Clone;
    -- Добавить в результат заданную строку
    v_Result.Append(i_Str);
    -- Возвращать результат
    return v_Result;
  end Concat;

  -- Соединить длинную строку с заданной коллекцией строк
  final member function Concat (i_Str Array_Varchar2) Return Long_String
  is
    v_Result  Long_String;
  begin
    -- Клонировать текущую строку
    v_Result := Self.Clone;
    -- Добавить в результат заданную строку
    v_Result.Append(i_Str);
    -- Возвращать результат
    return v_Result;
  end Concat;

  -- Соединить длинную строку с заданной длинной строкой
  final member function Concat (i_Str Long_String) Return Long_String
  is
    v_Result  Long_String;
  begin
    -- Клонировать текущую строку
    v_Result := Self.Clone;
    -- Добавить в результат заданную строку
    v_Result.Append(i_Str);
    -- Возвращать результат
    return v_Result;
  end Concat;

  -- Удалить в строке заданное количество символов, начиная с заданной позиции
  -- и возвращать результат
  final member function Remove (i_Pos Integer, i_Len Integer) Return Long_String
  is
  begin
    -- Вызвать функцию замены подстроки
    return Self.Replace('', i_Pos, i_Len);
  end Remove;

  -- Вставить в строку заданную подстроку с заданной позиции и возвращать результат
  final member function Insert_Str (i_Str Varchar2, i_Pos Integer) Return Long_String
  is
  begin
    -- Вызвать функцию замены подстроки
    return Self.Replace(i_Str, i_Pos, 0);
  end Insert_Str;

  final member function Equals (i_Str Varchar2) Return Boolean
  is
  begin
    -- Сравнить заданную строку со значением данной строки
    if NVL(Length(i_Str), 0) != Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    elsif Self."Buf ".Count > 1 then
      return False;                                    -- Размер буфера больше 32К
    elsif i_Str = Self."Buf "(1) then
      return True;                                     -- Строки идентичны
    end if ;
    -- Возвращать "ложь"
    return False;                                      -- Строки не идентичны
  end Equals;

  -- Сравнить длинную строку с заданной длинной строкой
  final member function Equals (i_Str Long_String) Return Boolean
  is
  begin
    -- Сравнить заданную строку со значением данной строки
    if i_Str."Buf_Size " = 0 and Self."Buf_Size " = 0 then
      return True;                                     -- Обе строки пусты
    elsif i_Str."Buf_Size " != Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    end if ;
    -- Сравнить буфера строк по-странично
    for I in 1..Self."Buf ".Count
    loop
      -- Выйти, если страницы не идентичны
      if i_Str."Buf "(I) is NULL and Self."Buf "(I) is NULL then
        continue;                                      -- Перейти к следующей странице
      elsif i_Str."Buf "(I) != Self."Buf "(I) then
        return False;                                  -- Страницы не идентичны
      end if;
    end loop;
    -- Возвращать "истина"
    return True;                                       -- Строки идентичны
  end Equals;

  -- Сравнить длинную строку с заданной строкой без учета регистра букв
  final member function Equals_Ignore_Case (i_Str Varchar2) Return Boolean
  is
  begin
    -- Сравнить заданную строку со значением данной строки
    if NVL(Length(i_Str), 0) != Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    elsif Self."Buf ".Count > 1 then
      return False;                                    -- Размер буфера больше 32К
    elsif Upper(i_Str) = Upper(Self."Buf "(1)) then
      return True;                                     -- Строки идентичны
    end if ;
    -- Возвращать "ложь"
    return False;                                      -- Строки не идентичны
  end Equals_Ignore_Case;

  -- Сравнить длинную строку с заданной длинной строкой без учета регистра букв
  final member function Equals_Ignore_Case (i_Str Long_String) Return Boolean
  is
  begin
    -- Сравнить заданную строку со значением данной строки
    if i_Str."Buf_Size " = 0 and Self."Buf_Size " = 0 then
      return True;                                     -- Обе строки пусты
    elsif i_Str."Buf_Size " != Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    end if ;
    -- Сравнить буфера строк по-странично
    for I in 1..Self."Buf ".Count
    loop
      -- Выйти, если страницы не идентичны
      if i_Str."Buf "(I) is NULL and Self."Buf "(I) is NULL then
        continue;                                      -- Перейти к следующей странице
      elsif Upper(i_Str."Buf "(I)) != Upper(Self."Buf "(I)) then
        return False;                                  -- Страницы не идентичны
      end if;
    end loop;
    -- Возвращать "истина"
    return True;                                       -- Строки идентичны
  end Equals_Ignore_Case;

  -- Проверить, заканчивается ли длинная строка с заданной подстрокой
  final member function Ends_With (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- Сравнить заданную строку со значением данной строки
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    elsif Length("Buf "("Buf ".Count)) >= v_Len then
      return (i_Str = SubStr("Buf "("Buf ".Count), -v_Len));
    elsif i_Str = Self.Sub_Str("Buf_Size " - v_Len + 1, v_Len) then
      return True;                                     -- Строки идентичны
    end if ;
    -- Возвращать "ложь"
    return False;                                      -- Строки не идентичны
  end Ends_With;

  -- Проверить, заканчивается ли длинная строка с заданной подстрокой
  -- без учета регистра букв
  final member function Ends_With_Ignore_Case (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- Сравнить заданную строку со значением данной строки
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    elsif Length("Buf "("Buf ".Count)) >= v_Len then
      return (Upper(i_Str) = Upper(SubStr("Buf "("Buf ".Count), -v_Len)));
    elsif Upper(i_Str) = Upper(Self.Sub_Str("Buf_Size " - v_Len + 1, v_Len)) then
      return True;                                     -- Строки идентичны
    end if ;
    -- Возвращать "ложь"
    return False;                                      -- Строки не идентичны
  end Ends_With_Ignore_Case;

  -- Проверить, начинается ли длинная строка с заданной подстрокой
  final member function Starts_With (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- Сравнить заданную строку со значением данной строки
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    elsif i_Str = SubStr(Self."Buf "(1), 1, v_Len) then
      return True;                                     -- Строки идентичны
    end if ;
    -- Возвращать "ложь"
    return False;                                      -- Строки не идентичны
  end Starts_With;

  -- Проверить, начинается ли длинная строка с заданной подстрокой
  -- без учета регистра букв
  final member function Starts_With_Ignore_Case (i_Str Varchar2) Return Boolean
  is
    v_Len  PLS_Integer := Length(i_Str);
  begin
    -- Сравнить заданную строку со значением данной строки
    if i_Str is NULL then
      return NULL;
    elsif v_Len > Self."Buf_Size " then
      return False;                                    -- Длины строк разные
    elsif Upper(i_Str) = Upper(SubStr(Self."Buf "(1), 1, v_Len)) then
      return True;                                     -- Строки идентичны
    end if ;
    -- Возвращать "ложь"
    return False;                                      -- Строки не идентичны
  end Starts_With_Ignore_Case;

  -- Заменить подстроку с заданной позиции и с заданной длиной
  -- на новую подстроку
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
    -- Проверить корректность параметров
    if i_Pos is NULL or i_Pos < 1 then
      -- Возвращть NULL
      return NULL;
    elsif (v_New_Len = 0 and v_Old_Len = 0) or
          (i_Pos > Self."Buf_Size " and v_New_Len = 0) then
      -- Замена подстроки невозмоно, ничего не делать
      return Self.Clone();
    elsif "Buf ".Count = 1 and "Buf_Size " + v_New_Len - v_Old_Len <= 32767 then
      -- Возвращать длинную строку, созданную путем замены подстроки
      -- в единственной странице буфера
      return Long_String(SubStr("Buf "(1), 1, v_At_Pos - 1) || i_New_Str ||
                         SubStr("Buf "(1), v_At_Pos + v_Old_Len));
    end if;
    --
    -- Копировать в результат часть текущей строки до заданной позиции
    v_Result := Self.Sub_Str_Long(1, i_Pos - 1);
    --
    -- Добавить в результат новую подстроку
    v_Result.Append(i_New_Str);
    --
    if i_Pos <= Self."Buf_Size " then
      -- Добавить в результат часть текущей строки после заменяемой подстроки
      v_Result.Append(Self.Sub_Str_Array(i_Pos + v_Old_Len));
    end if;
    --
    -- Возвращать результат
    return v_Result;
  end Replace;

  -- Найти и заменить все схождения первой подстроки на вторую подстроку
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
    -- Проверить корректность параметров
    if i_Old_Str is NULL or Self."Buf_Size " < v_Old_Len then
      -- Возвращать строку без изменения
      return Self.Clone();
    elsif "Buf ".Count = 1 and "Buf_Size " + v_New_Len - v_Old_Len <= 32767 then
      -- Возвращать длинную строку, созданную путем замены подстроки
      -- в единственной странице буфера
      return Long_String(STANDARD.Replace(Self."Buf "(1), i_Old_Str, i_New_Str));
    end if;
    -- Создать новую длинную строку
    v_Result := Long_String();
    --
    loop
      -- Найти следующую позицию подстроки
      v_Index := Self.Find_SubStr(i_Old_Str, v_Copied + 1);
      -- Выйти, если подстрока не найдена
      exit when (v_Index = 0);
      --
      -- Добавить в результат часть строки до имени переменной
      v_Result.Append(Self.Sub_Str_Array(v_Copied + 1, v_Index - v_Copied - 1));
      --
      if i_New_Str is not NULL then
        -- Заменить имя переменной на его значение
        v_Result.Append(i_New_Str);
      end if;
      --
      v_Copied := v_Index + v_Old_Len - 1;
    end loop;
    --
    -- Копировать оставщуюся часть команды в результат
    v_Result.Append(Self.Sub_Str_Array(v_Copied + 1));
    --
    -- Возвращать результат
    return v_Result;
  end Replace;


  -- Удалить из строки "белые" символа слева
  final member function Left_Trim (i_TSet Varchar2) Return Long_String
  is
    P  Integer;
  begin
    -- Если буфер состоит из одной страницы
    if Self."Buf ".Count = 1 then
      -- Использовать стандартную функцию
      return Long_String(LTrim(Self."Buf "(1), i_TSet));
    else
      -- Пропустить "белые" символы слева
      P := Self.Find_Char_For_Set(i_TSet, 1, False);
      -- Если имеются "белые" символы слева
      if P > 1 then
        -- Возвращать строку без "белых" символов слева
        return Self.Sub_Str_Long(P);
      end if;
      -- Возвращать строку без изменения
      return Self.Clone;
    end if;
  end Left_Trim;

  -- Удалить из строки "белые" символа справа
  final member function Right_Trim (i_TSet Varchar2) Return Long_String
  is
    P  Integer;
  begin
    -- Если буфер состоит из одной страницы
    if Self."Buf ".Count = 1 then
      -- Использовать стандартную функцию
      return Long_String(RTrim(Self."Buf "(1), i_TSet));
    else
      -- Пропустить "белые" символы справа
      P := Self.Find_Char_For_Set_Back(i_TSet, Self."Buf_Size ", False);
      -- Если имеются "белые" символы справа
      if P < Self."Buf_Size " then
        -- Возвращать строку без "белых" символов справа
        return Self.Sub_Str_Long(1, P);
      end if;
      -- Возвращать строку без изменения
      return Self.Clone;
    end if;
  end Right_Trim;

  -- Удалить из строки "белые" символа слева и справа
  final member function Trim (i_TSet Varchar2) Return Long_String
  is
    L  Integer;
    R  Integer;
  begin
    -- Если буфер состоит из одной страницы
    if Self."Buf ".Count = 1 then
      -- Использовать стандартную функцию
      return Long_String(LTrim(RTrim(Self."Buf "(1), i_TSet), i_TSet));
    else
      -- Пропустить "белые" символы слева и справа
      L := Self.Find_Char_For_Set(i_TSet, 1, False);
      R := Self.Find_Char_For_Set_Back(i_TSet, Self."Buf_Size ", False);
      -- Проверить наличие "белых" символов слева и справа
      if L <= 1 and R >= Self."Buf_Size " then
        return Self.Clone;      -- Возвращать строку без изменения
      elsif R < L then
        return Long_String();   -- Возвращать пустую строку
      elsif L < 1 then
        L := 1;                 -- Комировать с позиции 1
      elsif R > Self."Buf_Size " then
        R := Self."Buf_Size ";  -- Комировать до конца буфера
      end if;
      -- Возвращать строку без "белых" символов слева и справа
      return Self.Sub_Str_Long(L, R - L + 1);
    end if;
  end Trim;


  -- Уменьшить длину строки до заданной новой длины
  final member function Trunc (i_New_Len Integer) Return Long_String
  is
  begin
    return Self.Sub_Str_Long(1, i_New_Len);
  end Trunc;

  -- Преобразовать специальные символы в строке в Escape-последовательности
  -- Добавлен от 27.11.2020
  final member function Escape Return Long_String
  is
    v_Result  Long_String := Long_String();

    -- Преобразовать специальные символы в строке в Escape-последовательности
    Function Escape_Str (i_Str Varchar2) Return Varchar2
    is
    begin
      -- Возвращать преобразованную строку
      return STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(
          STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(i_Str,
          '\', '\\'), '/', '\/'), '"', '\"'), Chr(8), '\b'), Chr(9), '\t'),
          Chr(10), '\r'), Chr(12), '\f'), Chr(13), '\n');
    end Escape_Str;

  begin
    -- Постранично преобразовать и вставить буфер в результат
    for I in 1..Self."Buf ".Count
    loop
      -- Для избежания переполнения, преобразовать две половины страницы раздельно
      v_Result.Append(Escape_Str(SubStr(Self."Buf "(I), 1, 16384)));
      v_Result.Append(Escape_Str(SubStr(Self."Buf "(I), 16385)));
    end loop;
    -- Возвращать результат
    return v_Result;
  end Escape;

  -- Преобразовать Escape-последовательности в строке обратно в специальные символы
  -- Добавлен от 27.11.2020
  final member function Unescape return Long_String
  is
    v_Beg    PLS_Integer := 1;
    v_Pos    PLS_Integer;
    v_Result Long_String;

    -- Преобразовать Escape-последовательности в строке обратно в специальные символы
    Function Unescape_Str (i_Str Varchar2) Return Varchar2
    is
    begin
      -- Возвращать преобразованную строку
      return STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(
          STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(STANDARD.Replace(i_Str,
          '\\', '\'), '\/', '/'), '\"', '"'), '\b', Chr(8)), '\t', Chr(9)),
          '\r', Chr(10)), '\f', Chr(12)), '\n', Chr(13));
    end Unescape_Str;

    -- Вставить подстроку в буфер
    Procedure Put_Sub_Str (i_Pos PLS_Integer, i_End PLS_Integer)
    is
      v_Len  PLS_Integer := i_End - i_Pos;
    begin
      -- Если длина подстроки меньше 32К
      if v_Len <= 32767 then
        v_Result.Append(Self.Sub_Str(i_Pos, v_Len));
      else
        v_Result.Append(Self.Sub_Str_Array(i_Pos, v_Len));
      end if;
    end Put_Sub_Str;

  begin
    -- Если длина строки меньше 32К
    if Self."Buf_Size " <= 32767 then
      -- Для коротких строк использовать более эффективный алгоритм
      return Long_String(Unescape_Str(Self.To_String()));
    end if;
    -- Найти индекс Escape-последовательности
    v_Pos := Self.Find_SubStr('\', 1);
    -- Возвращать исходную строку, если строка не содержит Escape-последовательностей
    if v_Pos = 0 then
      return Self;
    end if;
    -- Создать длинную строку для результата
    v_Result := Long_String();
    -- Заменить Escape-последовательности на обычные символы
    loop
      -- Вставить в буфер подстроку
      Put_Sub_Str(v_Beg, v_Pos);
      -- Преобразовать и вставить в буфер специальний символ
      v_Result.Append(Translate(Self.Get_Char(v_Pos + 1), '\/"btrfn', '\/"'
        || Chr(8) || Chr(9) || Chr(10) || Chr(12) || Chr(13)));
      -- Искать следующий Escap-символ
      v_Beg := v_Pos + 2;
      v_Pos := Self.Find_SubStr('\', v_Beg);
      -- Выйти из цикла, если нет больще Escap-символов
      exit when (v_Pos = 0);
    end loop;
    -- Вставить остаток строки в буфер
    Put_Sub_Str(v_Beg, Self."Buf_Size " + 1);
    --
    -- Возвращать результат
    return v_Result;
  end Unescape;



end;
/
