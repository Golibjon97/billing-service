CREATE OR REPLACE TYPE JSON_String_T force as Object (
--
-- Author   : Шаюсупов Ш.А.
-- Created  : 22.09.2019 06:14:18
-- Version  : ->>22102019<<-
-- System   : ИАБС 6.5.0
-- Subsystem: Ядро ИАБС 6.5.0
-- Purpose  : Объектный тип для возможности поддержки в PL/SQL длинных JSON-строк
--            Позволяет создать, хранить и обработать в памяти длинных строк в формате JSON
--            Позволяет сжатие больших строк при хранении в памяти, что позволяет многократно
--            уменьшить потребляемую память
  
  
  -- Приватные реквизиты строки (заключены в кавычки, чтобы усложнять
  -- использование извне)
  "Length "       Integer(12),      -- Общая длина строки
  "Level "        Integer(5),       -- Уровень глубины текущего блока данных (не более 32767)
  "Levels "       Varchar2(32767),  -- Типы блоков данных вложенных уровней (O-Объект, L-Список)
  "Is_Empty "     Varchar2(1),      -- Текущий уровень еще пуст
  "Compress "     Varchar2(1),      -- Сжатие строки для экономии памяти
  "Max_Length "   Integer(12),      -- Допустимая длина строки
  "Buf "          Varchar2(32767),  -- Основной буфер для хранения JSON-строки
  "Raw_Data "     Array_Raw,        -- Постранично-организованный буфер для хранения большой строки
  --
  -- Соглашения о параметрах форматирования
  "Def_CharSet "  Varchar2(15),     -- Кодировка символов по умолчанию
  "Fmt_Number "   Varchar2(43),     -- Формат значений числового типа
  "Fmt_Date "     Varchar2(10),     -- Формат значений типа дата
  "Fmt_Time "     Varchar2(21),     -- Формат значений типа дата и время
  --
  -- Соглашения о значениях по умолчению
  "Null_Number "  Varchar2(4),      -- Строка для замены числового значения NULL
  "Null_Boolean " Varchar2(5),      -- Строка для замены логического значения NULL
  "Null_Date "    Varchar2(12),     -- Строка для замены NULL-значения типа дата и время
  
  
  
  -- Статический метод для получения версии тела объектного типа
  -- Потомственые типы должны определять собственные методы для
  -- получения версии
  static function GetVersion return Varchar2,
  
  
  -- Конструктор для создания нового пустого экземпляра типа
  Constructor Function JSON_String_T (
    Self in out nocopy JSON_String_T
  )
  Return Self as Result,
  
  -- Инициализировать атрибуты новой строки
  final member procedure Init (Self in out nocopy JSON_String_T),
  
  -- Инициализировать соглашения по форматированию данных
  final member procedure Set_Formats (
    Self in out nocopy JSON_String_T,
    i_Def_CharSet  Varchar2 := NULL,     -- Кодировка символов по умолчанию
    i_Fmt_Number   Varchar2 := NULL,     -- Формат значений числового типа
    i_Fmt_Date     Varchar2 := NULL,     -- Формат значений типа дата
    i_Fmt_Time     Varchar2 := NULL      -- Формат значений типа дата и время
  ),
  
  -- Инициализировать соглашения о значениях по умолчению
  final member procedure Set_Defaults (
    Self in out nocopy JSON_String_T,
    i_Null_Number  Varchar2 := NULL,     -- Значение для замены NULL-числа
    i_Null_Boolean Varchar2 := NULL,     -- Значение для замены NULL-Boolean
    i_Null_Date    Varchar2 := NULL      -- Значение для замены NULL-даты
  ),
  
  -- Задать признак сжатии строки при переносе на расширенный буфер
  -- Установка данного значения в "Y" (по умолчанию) позволяет экономить
  -- оперативную память при незначительном снижении производительности
  final member procedure Set_Compress (
    Self in out nocopy JSON_String_T,
    i_Compress  Varchar2 := 'Y'
  ),
  
  -- Генерировать исключение с заданным  кодом ошибки и сообщением об ошибке
  final member procedure Error (
    Self          in JSON_String_T,
    i_Error_Code  in PLS_Integer := 0,
    i_Error_Msg   in Varchar2
  ),
  
  -- Возвращать длину строки
  final member function Get_Length Return Integer,
  
  -- Возвращать уровень вложенности текущего блока
  final member function Get_Level Return Integer,
  
  -- Возвращать количество внутренних буферов для хранения строки,
  -- включая основной и расширенные буфера
  final member function Get_Buf_Count Return Integer,
  
  -- Клонировать текущую длинную строку
  final member function Cast_To_Raw (i_Str Varchar2) Return Raw,
  
  -- Клонировать текущую длинную строку
  final member function Cast_To_String (i_Raw Raw) Return Varchar2,
  
  -- Преобразовать заданную строку в JSON-совместимый формат
  -- Преобразует специальные символы в Escape-последовательности
  final static function Cast_To_JSON (i_Str Varchar2) return Varchar2,
  
  -- Упаковать строку в бинарном представлении
  final member function Compress_Raw (i_Raw Raw) Return Raw,
  
  -- Упаковать строку в символьном представлении
  final member function Compress_Str (i_Str Varchar2) Return Raw,
  
  -- Распаковать сжатую строку и возвращать результат в бинарном представлении
  final member function Uncompress_To_Raw (i_Raw Raw) Return Raw,
  
  -- Распаковать сжатую строку и возвращать результат в символьном представлении
  final member function Uncompress_To_Str (i_Raw Raw) Return Varchar2,
  
  
  -- Преобразовать значение символьного типа в формат JSON
  -- Вставит двойные кавычки на начало и конец строки
  -- Существующие в строке кавычки и специальные символы превращает в JSON-совместимые символы
  final member function Format (i_Str Varchar2) Return Varchar2,
  
  -- Преобразовать значение числового типа в формат JSON
  final member function Format (i_Value Number, i_Fmt Varchar2 := NULL) Return Varchar2,
  
  -- Преобразовать значение типа дата и время в формат JSON
  final member function Format (i_Value Date, i_Fmt Varchar2 := NULL) Return Varchar2,
  
  -- Преобразовать значение типа дата и время в формат JSON
  final member function Format (i_Value Boolean) Return Varchar2,
  
  
  -- Формировать пару ключ-значение для вставки в формате JSON
  -- При необходимостии вставить лидирующий запятой 
  -- Только для внутреннего назначения
  final member function "_Make_Comma_Name " (i_Name Varchar2) Return Varchar2,
  
  -- Возвращать значение в виде коллекции строк
  -- Только для внутреннего назначения
  final member function "_Extract_Raw_Data " (
    i_Index      Integer,
    i_Compress   Varchar2 := 'Y',
    i_Debugging  Boolean  := False
  )
  Return Raw,
  
  --
  -- Только для внутреннего назначения
  final member procedure "_Flash_Buf " (Self in out nocopy JSON_String_T),
  
  -- 
  -- Только для внутреннего назначения
  final member procedure "_Append_Str " (
    Self in out nocopy JSON_String_T,
    i_Str  Varchar2
  ),
  
  -- Открыть новый блок данных JSON
  -- Только для внутреннего назначения
  final member procedure "_Open_New_Level " (
    Self in out nocopy JSON_String_T,
    i_Open_Char  Varchar2,
    i_Type_Char  Varchar2,
    i_Name       Varchar2 := NULL
  ),
  
  -- Закрыть текущий блок данных JSON
  -- Только для внутреннего назначения
  final member procedure "_Close_Cur_Level " (
    Self in out nocopy JSON_String_T,
    i_Close_Char  Varchar2,
    i_Type_Char   Varchar2
  ),
  
  -- Добавить подготовленное значение в список
  -- Только для внутреннего назначения
  final member procedure "_Put_In_List " (
    Self in out nocopy JSON_String_T,
    i_Quoted_Value  Varchar2
  ),
  
  -- Добавить подготовленную пару ключ-значение в объект JSON
  -- Только для внутреннего назначения
  final member procedure "_Put_In_Object " (
    Self in out nocopy JSON_String_T,
    i_Quoted_Key    Varchar2,
    i_Quoted_Value  Varchar2
  ),
  
  -- Проверить, закрыть ли JSON-строка
  -- Запрещается добавление новых элементов в закрытую строку
  final member function Is_Closed Return Boolean,
  
  -- Проверить, открыть ли JSON-строка для добавления новых элементов
  final member function Is_Open Return Boolean,
  
  -- Удостовериться, JSON-строка закрыта
  -- Запрещается извлечение содержимого буфера при не закрытой строке
  -- Из-за критичности на скорость допускается дублирование кода других методов
  final member procedure Check_Closed (Self in JSON_String_T),
  
  -- Удостовериться, JSON-строка открыта для добавления новых элементов
  -- Запрещается добавление новых элементов в закрытую строку
  -- Из-за критичности на скорость допускается дублирование кода других методов
  final member procedure Check_Open (Self in JSON_String_T),
  
  -- Удостовериться, что заданный тип блока данных соответствует заданному типу блока
  -- Из-за критичности на скорость допускается дублирование кода других методов
  final member procedure Check_Level (
    Self in JSON_String_T,
    i_Level_Type  Varchar2,
    i_Level       Integer := NULL,
    i_Msg         Varchar2 := NULL
  ),
  
  
  -- Закрыть JSON-строку
  -- В отличие от метода Close_JSON, который закрывает текущий JSON-объект,
  -- попытается закрыть основной блок JSON-строки
  -- При обнаружении незакрытого вложенного блока любого типа генерирует исключение
  final member procedure Close (Self in out nocopy JSON_String_T),
  
  -- Открыть новый объект JSON с заданным именем
  final member procedure Open_JSON (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  ),
  
  -- Закрыть текущий объект JSON
  final member procedure Close_JSON (Self in out nocopy JSON_String_T),
  
  -- Открыть новый список значений с заданным именем
  final member procedure Open_Array (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  ),
  
  -- Закрыть текущий объект JSON
  final member procedure Close_Array (Self in out nocopy JSON_String_T),
  
  -- Добавть пару ключ-значение стротного типа в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Varchar2
  ),
  
  -- Добавть пару ключ-значение числового типа в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- Добавть пару ключ-значение типа дата и время в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- Добавть пару ключ-значение логического типа в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Boolean
  ),
  
  -- Добавть значение нуль по ключу в текущий объект JSON
  final member procedure Put_Null (
    Self in out nocopy JSON_String_T,
    i_Key  Varchar2
  ),
  
  
  -- Добавть символьное значение в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Varchar2
  ),
  
  -- Добавть числовое значение в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- Добавть значение типа дата и время в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  ),
  
  -- Добавить логическое значение в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Boolean
  ),
  
  -- Добавить значение "null" в текущий список
  final member procedure Add_Null (Self in out nocopy JSON_String_T),
  
  
  -- Возвращать значение в виде строки
  -- Если длина строки превышает 32К, то генерирует исключение
  final member function To_String Return Varchar2,
  
  -- Возвращать значение в виде коллекции данных в двоичном представлении
  final member function To_Raw_Array (i_Compress Varchar2 := NULL) Return Array_Raw,
  
  -- Возвращать значение в виде коллекции строк
  final member function To_String_Array Return Array_Varchar2,
  
  -- Возвращать значение в виде объекта CLOB
  final member function To_CLob Return CLob,
  
  -- Возвращать значение в виде объекта BLOB
  final member function To_BLob Return BLob,
  
  -- Возвращать значение в виде коллекции строк для отладочных целей
  final member function Debug Return Array_Varchar2
  
)
final;
/
CREATE OR REPLACE TYPE BODY JSON_String_T
is

  -- Статический метод для получения версии тела объектного типа
  -- Потомственые типы должны определять собственные методы для
  -- получения версии
  static function GetVersion return Varchar2
  is
  begin
    return '->>22102019<<-';
  end GetVersion;
  
  -- Конструктор для создания пустого экземпляра типа
  Constructor Function JSON_String_T (
    Self in out nocopy JSON_String_T
  )
  Return Self as Result
  is
  begin
    Self.Init();      -- Инициализировать атрибуты новой строки
    return;           -- Возврат
  end JSON_String_T;
  
  -- Инициализировать атрибуты новой строки
  final member procedure Init (Self in out nocopy JSON_String_T)
  is
  begin
    Self."Level "       := 1;              -- Уровень глубины текущего блока данных
    Self."Levels "      := 'O';            -- Типы блоков данных вложенных уровней
    Self."Length "      := 0;              -- Общая длина строки
    Self."Is_Empty "    := 'Y';            -- Текущий уровень еще пуст
    Self."Compress "    := 'Y';            -- Сжать строку при переносе на расширенный буфер
    Self."Max_Length "  := 256*1024*1024;  -- Допустимая длина строки (по умолчанию 256М)
    Self."Buf "         := '{';            -- Основной буфер для хранения JSON-строки
    Self."Raw_Data "    := NULL;           -- Расширенный буфер (инициализируется только при необходимости)
    --
    -- Инициализировать соглашения по форматированию данных
    Self.Set_Formats (
      i_Def_CharSet => 'CL8MSWIN1251',
      i_Fmt_Number  => 'FM99999999999999999990.99999999999999999999',
      i_Fmt_Date    => 'dd.mm.yyyy',
      i_Fmt_Time    => 'dd.mm.yyyy hh24:mi:ss');
    -- Инициализировать соглашения по значениям по умолчению
    Self.Set_Defaults (
      i_Null_Number  => '""',     -- Заменить числовое значение NULL на "0"
      i_Null_Boolean => '""',     -- Заменить булевское значение NULL на "false"
      i_Null_Date    => '""');    -- Заменить NULL-дату на пустую строку
  end Init;
  
  -- Инициализировать соглашения по форматированию данных
  final member procedure Set_Formats (
    Self in out nocopy JSON_String_T,
    i_Def_CharSet  Varchar2 := NULL,     -- Кодировка символов по умолчанию
    i_Fmt_Number   Varchar2 := NULL,     -- Формат значений числового типа
    i_Fmt_Date     Varchar2 := NULL,     -- Формат значений типа дата
    i_Fmt_Time     Varchar2 := NULL      -- Формат значений типа дата и время
  )
  is
  begin
    -- Инициализировать соглашения по форматированию данных
    Self."Def_CharSet " := NVL(i_Def_CharSet, Self."Def_CharSet ");  -- Кодировка символов по умолчанию
    Self."Fmt_Number "  := NVL(i_Fmt_Number,  Self."Fmt_Number ");   -- Формат значений числового типа
    Self."Fmt_Date "    := NVL(i_Fmt_Date,    Self."Fmt_Date ");     -- Формат значений типа дата
    Self."Fmt_Time "    := NVL(i_Fmt_Time,    Self."Fmt_Time ");     -- Формат значений типа дата и время
  end Set_Formats;
  
  -- Инициализировать соглашения о значениях по умолчению
  final member procedure Set_Defaults (
    Self in out nocopy JSON_String_T,
    i_Null_Number  Varchar2 := NULL,     -- Значение для замены NULL-числа
    i_Null_Boolean Varchar2 := NULL,     -- Значение для замены NULL-Boolean
    i_Null_Date    Varchar2 := NULL      -- Значение для замены NULL-даты
  )
  is
  begin
    -- Инициализировать соглашения по значениям по умолчению
    Self."Null_Number "  := NVL(i_Null_Number,  Self."Null_Number ");
    Self."Null_Boolean " := NVL(i_Null_Boolean, Self."Null_Boolean ");
    Self."Null_Date "    := NVL(i_Null_Date,    Self."Null_Date ");
  end Set_Defaults;
  
  -- Задать признак сжатии строки при переносе на расширенный буфер
  -- Установка данного значения в "Y" (по умолчанию) позволяет экономить
  -- оперативную память при незначительном снижении производительности
  final member procedure Set_Compress (
    Self in out nocopy JSON_String_T,
    i_Compress  Varchar2 := 'Y'
  )
  is
  begin
    -- Инициализировать соглашения по форматированию данных
    Self."Compress " := i_Compress;
  end Set_Compress;
  
  -- Генерировать исключение с заданным  кодом ошибки и сообщением об ошибке
  final member procedure Error (
    Self          in JSON_String_T,
    i_Error_Code  in PLS_Integer := 0,
    i_Error_Msg   in Varchar2
  )
  is
  begin
    -- Генерировать исключение с заданным  кодом ошибки и сообщением об ошибке
    Raise_Application_Error(-20000 - i_Error_Code, i_Error_Msg || Chr(10) || 'Позиция: ' || Self."Length ");
    --
    -- Добавим невыполняемый код, чтобы сделать компилятор довольным
    if Self is NULL then
      NULL;  -- Никогда не будет выполняться, но сделает компилятор довольным
    end if;
  end Error;
  
  -- Возвращать длину строки
  final member function Get_Length Return Integer
  is
  begin
    return Self."Length ";
  end Get_Length;
  
  -- Возвращать уровень вложенности текущего блока
  final member function Get_Level Return Integer
  is
  begin
    return Self."Level ";
  end Get_Level;
  
  -- Возвращать количество внутренних буферов для хранения строки,
  -- включая основной и расширенные буфера
  final member function Get_Buf_Count Return Integer
  is
  begin
    return case when Self."Raw_Data " is NULL
             then 1 else Self."Raw_Data ".Count + 1
           end;
  end Get_Buf_Count;
  
  -- Клонировать текущую длинную строку
  final member function Cast_To_Raw (i_Str Varchar2) Return Raw
  is
  begin
    return UTL_i18n.String_To_Raw(i_Str, Self."Def_CharSet ");
  end Cast_To_Raw;
  
  -- Клонировать текущую длинную строку
  final member function Cast_To_String (i_Raw Raw) Return Varchar2
  is
  begin
    return UTL_i18n.Raw_To_Char(i_Raw, Self."Def_CharSet ");
  end Cast_To_String;
  
  -- Преобразовать заданную строку в JSON-совместимый формат
  -- Преобразует специальные символы в Escape-последовательности
  final static function Cast_To_JSON (i_Str Varchar2) return Varchar2
  is
  begin
    return Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(i_Str,
      '\', '\\'), '/', '\/'), '"', '\"'), Chr(8), '\b'), Chr(9), '\t'),
      Chr(10), '\r'), Chr(12), '\f'), Chr(13), '\n');
  end Cast_To_JSON;
  
  -- Упаковать строку в бинарном представлении
  final member function Compress_Raw (i_Raw Raw) Return Raw
  is
  begin
    return UTL_Compress.LZ_Compress(i_Raw);
  end Compress_Raw;
  
  -- Упаковать строку в символьном представлении
  final member function Compress_Str (i_Str Varchar2) Return Raw
  is
  begin
    return Self.Compress_Raw(UTL_i18n.String_To_Raw(i_Str, Self."Def_CharSet "));
  end Compress_Str;
  
  -- Распаковать сжатую строку и возвращать результат в бинарном представлении
  final member function Uncompress_To_Raw (i_Raw Raw) Return Raw
  is
  begin
    return UTL_Compress.LZ_Uncompress(i_Raw);
  end Uncompress_To_Raw;
  
  -- Распаковать сжатую строку и возвращать результат в символьном представлении
  final member function Uncompress_To_Str (i_Raw Raw) Return Varchar2
  is
  begin
    return UTL_i18n.Raw_To_Char(Self.Uncompress_To_Raw(i_Raw), Self."Def_CharSet ");
  end Uncompress_To_Str;
  
  -- Преобразовать значение символьного типа в формат JSON
  -- Вставит двойные кавычки на начало и конец строки
  -- Существующие в строке кавычки и специальные символы превращает в JSON-совместимые символы
  final member function Format (i_Str Varchar2) Return Varchar2
  is
  begin
    return '"' || JSON_String_T.Cast_To_JSON(i_Str) || '"';
  end Format;
  
  -- Преобразовать значение числового типа в формат JSON
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
  
  -- Преобразовать значение типа дата и время в формат JSON
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
  
  -- Преобразовать значение типа дата и время в формат JSON
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
  
  
  -- Формировать пару ключ-значение для вставки в формате JSON
  -- При необходимостии вставить лидирующий запятой 
  -- Только для внутреннего назначения
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
  
  -- Возвращать значение в виде коллекции строк
  -- Только для внутреннего назначения
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
      Self.Error(1, 'Для извлечения данных необходимо закрыть объект JSON!');
    elsif Self."Length " <= 0 or i_Index < 1 or i_Index > v_Buf_Count then
      -- Строка пуста, или задан неверный номер блока
      return NULL;     -- Возвращать пустое значение
    elsif i_Index = v_Buf_Count then
      -- Возвращать содержимое основного буфера
      return case when v_Out_Compr
               then Self.Compress_Str(Self."Buf ")
               else Self.Cast_To_Raw(Self."Buf ")
             end;
    elsif v_Buf_Compr = v_Out_Compr then
      -- Буфер уже упакован или упаковка не требуется
      return Self."Raw_Data "(i_Index);
    elsif v_Buf_Compr then
      -- Буфер упакован, необходимо распаковать
      return Self.Uncompress_To_Raw(Self."Raw_Data "(i_Index));
    else
      -- Буфер не упакован, необходимо упаковать
      return Self.Compress_Raw(Self."Raw_Data "(i_Index));
    end if;
  end "_Extract_Raw_Data ";
  
  -- Инициализировать атрибуты новой строки
  -- Только для внутреннего назначения
  final member procedure "_Flash_Buf " (Self in out nocopy JSON_String_T)
  is
    v_Ind  PLS_Integer;
  begin
    -- Ничего не делать, если основной буфер пуст
    if Self."Buf " is NULL then
      return;
    elsif Self."Length " + 32767 > Self."Max_Length " then
      -- Превышена максимально допустимая длина JSON-строки
      Raise_Application_Error(-20000, 'Превышена допустимая длина JSON-строки (' || Self."Max_Length " || ')!');
    elsif Self."Raw_Data " is NULL then
      -- Инициализировать расширенный буфер
      Self."Raw_Data " := Array_Raw();
    end if;
    -- Расширить расширенный буфер
    Self."Raw_Data ".Extend;
    v_Ind := Self."Raw_Data ".Count;
    --
    -- Перенести содержимое основного буфера в расширенный буфер
    if Self."Compress " = 'Y' then
      -- Перенести со сжатием
      Self."Raw_Data "(v_Ind) := UTL_Compress.LZ_Compress(Self.Cast_To_Raw(Self."Buf "));
    else
      -- Перенести без сжатия
      Self."Raw_Data "(v_Ind) := UTL_i18n.String_To_Raw(Self."Buf ");
    end if;
    -- Сбросить основной буфер
    Self."Buf " := '';
  end "_Flash_Buf ";
  
  -- Инициализировать атрибуты новой строки
  -- Только для внутреннего назначения
  final member procedure "_Append_Str " (
    Self in out nocopy JSON_String_T,
    i_Str  Varchar2
  )
  is
    v_Str_Len  PLS_Integer := NVL(Lengthb(i_Str), 0);
  begin
    -- Удостовериться, что строка открыта
    Self.Check_Open();
    -- Если размер буфера не позволяет вставку строки
    if v_Str_Len + Lengthb(Self."Buf ") > 32767 then
      -- Перенести содержимое основного буфера в расширенный буфер
      Self."_Flash_Buf "();
      -- Вставить строку в основной буфер
      Self."Buf " := i_Str;
    else
      -- Добавить строку в конец основного буфера
      Self."Buf " := Self."Buf " || i_Str;
    end if;
    -- Изменить размер JSON-строки
    Self."Length " := Self."Length " + v_Str_Len;
  end "_Append_Str ";
  
  -- Открыть новый блок данных JSON
  -- Только для внутреннего назначения
  final member procedure "_Open_New_Level " (
    Self in out nocopy JSON_String_T,
    i_Open_Char  Varchar2,
    i_Type_Char  Varchar2,
    i_Name       Varchar2 := NULL
  )
  is
  begin
    -- Проверить количество уровней вложенности
    if Self."Level " >= 32767 then
      Self.Error(6, 'Слишком много уровней вложенности объектов!');
    end if;
    -- Открыть новый блок данных JSON
    Self."_Append_Str "(Self."_Make_Comma_Name "(i_Name) || i_Open_Char);
    --
    Self."Level "      := Self."Level " + 1;
    Self."Levels "     := Self."Levels " || i_Type_Char;
    -- Установить признак пустоты уровня
    Self."Is_Empty "   := 'Y';
  end "_Open_New_Level ";
  
  -- Закрыть текущий блок данных JSON
  -- Только для внутреннего назначения
  final member procedure "_Close_Cur_Level " (
    Self in out nocopy JSON_String_T,
    i_Close_Char  Varchar2,
    i_Type_Char   Varchar2
  )
  is
  begin
    -- Проверить тип и состояние уровня
    Self.Check_Level(i_Type_Char, i_Msg => 'попытка закрытия блока несоответствующего типа');
    -- Закрыть текущий блок данных JSON
    Self."_Append_Str "(i_Close_Char);
    --
    Self."Level "      := Self."Level " - 1;
    Self."Levels "     := SubStr(Self."Levels ", 1, Self."Level ");
    -- Отменить признак пустоты уровня
    Self."Is_Empty "   := 'N';
  end "_Close_Cur_Level ";
  
  -- Добавить подготовленное значение в список
  -- Только для внутреннего назначения
  final member procedure "_Put_In_List " (
    Self in out nocopy JSON_String_T,
    i_Quoted_Value  Varchar2
  )
  is
    v_Comma  Varchar2(1) := case Self."Is_Empty "
                              when 'N' then ',' else ''
                            end;
  begin
    -- Удостовериться, что значение вставляется в список
    Self.Check_Level('L', i_Msg => 'попытка вставки пары атрибут-значение, когда ожидается скалярное значение');
    --
    -- Добавить значение в конец буфера
    Self."_Append_Str " (v_Comma || i_Quoted_Value);
    -- Отменить признак пустоты списка
    Self."Is_Empty " := 'N';
  end "_Put_In_List ";
  
  -- Добавить подготовленную пару ключ-значение в объект JSON
  -- Только для внутреннего назначения
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
    -- Удостовериться, что пара ключ-значение вставляется в JSON-объект
    Self.Check_Level('O', i_Msg => 'попытка вставки скалярного значения, когда ожидается артибут-значение');
    --
    -- Добавить пару ключ-значение в конец буфера
    Self."_Append_Str " (v_Comma || i_Quoted_Key || ':' || i_Quoted_Value);
    -- Отменить признак пустоты объекта
    Self."Is_Empty " := 'N';
  end "_Put_In_Object ";
  
  -- Проверить, закрыть ли JSON-строка
  -- Запрещается добавление новых элементов в закрытую строку
  final member function Is_Closed Return Boolean
  is
  begin
    -- Для закрытой строки текущий урвен равняется "0"
    return (Self."Level " <= 0);
  end Is_Closed;
  
  -- Проверить, открыть ли JSON-строка для добавления новых элементов
  final member function Is_Open Return Boolean
  is
  begin
    -- Для открытой строки текущий урвен больше "0"
    return (Self."Level " > 0);
  end Is_Open;
  
  -- Удостовериться, JSON-строка закрыта
  -- Запрещается извлечение содержимого буфера при не закрытой строке
  -- Из-за критичности на скорость допускается дублирование кода других методов
  final member procedure Check_Closed (Self in JSON_String_T)
  is
  begin
    -- Если строка не закрыта
    if Self."Level " > 0 then  -- Специально дублирован код метода Is_Open
      Self.Error(11, 'JSON-строка еще не закрыта!');  -- Строка не закрыта
    elsif Self."Length " <= 0 or Self."Buf " is NULL then
      Self.Error(12, 'JSON-строка пуста!');           -- Строка не может быть пустым
    end if;
  end Check_Closed;
  
  -- Удостовериться, JSON-строка открыта для добавления новых элементов
  -- Запрещается добавление новых элементов в закрытую строку
  -- Из-за критичности на скорость допускается дублирование кода других методов
  final member procedure Check_Open (Self in JSON_String_T)
  is
  begin
    -- Для открытой строки текущий урвен больше "0"
    if Self."Level " <= 0 then  -- Специально дублирован код метода Is_Closed
      Self.Error(13, 'JSON-строка уже закрыта!');
    end if;
  end Check_Open;
  
  -- Удостовериться, что заданный тип блока данных соответствует заданному типу блока
  -- Из-за критичности на скорость допускается дублирование кода других методов
  final member procedure Check_Level (
    Self in JSON_String_T,
    i_Level_Type  Varchar2,
    i_Level       Integer  := NULL,
    i_Msg         Varchar2 := NULL
  )
  is
    v_Level  Integer := NVL(i_Level, Self."Level ");
  begin
    -- Проверить тип и возможность закрытия уровня
    if Self."Level " <= 0 then  -- Специально дублирован код метода Is_Closed
      Check_Open();             -- Для генерации ошибки используем метод Check_Open
    elsif SubStr(Self."Levels ", v_Level, 1) != i_Level_Type then
      if i_Msg is NULL then
        Self.Error(8, 'Синтаксическая ошибка!');
      else
        Self.Error(8, 'Синтаксическая ошибка: ' || i_Msg || '!');
      end if;
    end if;
  end Check_Level;
  
  -- Закрыть JSON-строку
  -- В отличие от метода Close_JSON, который закрывает текущий JSON-объект,
  -- попытается закрыть основной блок JSON-строки
  -- При обнаружении незакрытого вложенного блока любого типа генерирует исключение
  final member procedure Close (Self in out nocopy JSON_String_T)
  is
  begin
    --
    if Self."Level " > 1 then
      Self.Error(9, 'Синтаксическая ошибка: попытка закрытия незавершенного объекта JSON!');
    end if;
    -- Закрыть JSON-строку
    Self.Close_JSON();
  end Close;
  
  -- Открыть новый объект JSON с заданным именем
  final member procedure Open_JSON (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  )
  is
  begin
    -- Открыть новый объект JSON
    Self."_Open_New_Level "('{', 'O', i_Name);
  end Open_JSON;
  
  -- Закрыть текущий объект JSON
  final member procedure Close_JSON (Self in out nocopy JSON_String_T)
  is
  begin
    -- Закрыть текущий объект JSON
    Self."_Close_Cur_Level "('}', 'O');
  end Close_JSON;
  
  -- Открыть новый список значений с заданным именем
  final member procedure Open_Array (
    Self in out nocopy JSON_String_T,
    i_Name  Varchar2 := NULL
  )
  is
  begin
    -- Открыть новый объект JSON
    Self."_Open_New_Level "('[', 'L', i_Name);
  end Open_Array;
  
  -- Закрыть текущий объект JSON
  final member procedure Close_Array (Self in out nocopy JSON_String_T)
  is
  begin
    -- Закрыть текущий объект JSON
    Self."_Close_Cur_Level "(']', 'L');
  end Close_Array;
  
  -- Добавть пару ключ-значение стротного типа в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Varchar2
  )
  is
  begin
    -- Добавить подготовленную пару ключ-значение в объект JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value));
  end Put;
  
  -- Добавть пару ключ-значение числового типа в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- Добавить подготовленную пару ключ-значение в объект JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value, i_Fmt));
  end Put;
  
  -- Добавть пару ключ-значение типа дата и время в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- Добавить подготовленную пару ключ-значение в объект JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value, i_Fmt));
  end Put;
  
  -- Добавть пару ключ-значение логического типа в текущий объект JSON
  final member procedure Put (
    Self in out nocopy JSON_String_T,
    i_Key    Varchar2,
    i_Value  Boolean
  )
  is
  begin
    -- Добавить подготовленную пару ключ-значение в объект JSON
    Self."_Put_In_Object " (Self.Format(i_Key), Self.Format(i_Value));
  end Put;
  
  -- Добавть значение нуль по ключу в текущий объект JSON
  final member procedure Put_Null (
    Self in out nocopy JSON_String_T,
    i_Key  Varchar2
  )
  is
  begin
    -- Добавить подготовленную пару ключ-значение в объект JSON
    Self."_Put_In_Object " (Self.Format(i_Key), 'null');
  end Put_Null;
  
  
  -- Добавть символьное значение в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Varchar2
  )
  is
  begin
    -- Добавить значение в текущий список
    Self."_Put_In_List " (Self.Format(i_Value));
  end Add_Elem;
  
  -- Добавть числовое значение в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Number,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- Добавить значение в текущий список
    Self."_Put_In_List " (Self.Format(i_Value, i_Fmt));
  end Add_Elem;
  
  -- Добавть значение типа дата и время в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Date,
    i_Fmt    Varchar2 := NULL
  )
  is
  begin
    -- Добавить значение в текущий список
    Self."_Put_In_List " (Self.Format(i_Value, i_Fmt));
  end Add_Elem;
  
  -- Добавить логическое значение в текущий список
  final member procedure Add_Elem (
    Self in out nocopy JSON_String_T,
    i_Value  Boolean
  )
  is
  begin
    -- Добавить логическое значение в список
    Self."_Put_In_List " (Self.Format(i_Value));
  end Add_Elem;
  
  -- Добавить значение "null" в текущий список
  final member procedure Add_Null (Self in out nocopy JSON_String_T)
  is
  begin
    -- Добавить "null" в список
    Self."_Put_In_List " ('null');
  end Add_Null;
  
  
  -- Возвращать значение в виде строки
  -- Если длина строки превышает 32К, то генерирует исключение
  final member function To_String Return Varchar2
  is
  begin
    -- Удостовериться, что строка закрыта
    Self.Check_Closed();
    -- Если расширенный буфер не пуст
    if Self."Raw_Data " is not NULL and Self."Raw_Data ".Count > 0 then
      -- Подстрока не помещается в буфер
      Error(99, 'Строка не помещается в буфере!');
    end if;
    -- Возвращать значение в виде строки
    return Self."Buf ";
  end To_String;
  
  -- Возвращать значение в виде коллекции данных в двоичном представлении
  final member function To_Raw_Array (i_Compress Varchar2 := NULL) Return Array_Raw
  is
    Result  Array_Raw := Array_Raw();
  begin
    -- Удостовериться, что строка закрыта
    Self.Check_Closed();
    --
    -- Вставить в буфер содержимое буфера (включая основной буфер)
    for I in 1..Self.Get_Buf_Count
    loop
      Result.Extend;
      Result(Result.Count) := Self."_Extract_Raw_Data "(I, i_Compress);
    end loop;
    -- Возвращать результат
    return Result;
  end To_Raw_Array;
  
  -- Возвращать значение в виде коллекции строк
  final member function To_String_Array Return Array_Varchar2
  is
    Result       Array_Varchar2 := Array_Varchar2();
    v_Buf_Count  PLS_Integer    := Self.Get_Buf_Count;
  begin
    -- Удостовериться, что строка закрыта
    Self.Check_Closed();
    --
    for I in 1..v_Buf_Count
    loop
      -- Добавить очередной блок в результат
      Result.Extend;
      if I = v_Buf_Count then
        Result(I) := Self."Buf ";
      else
        Result(I) := Self.Cast_To_String(Self."_Extract_Raw_Data "(I, 'N'));
      end if;
    end loop;
    -- Возвращать результат
    return Result;
  end To_String_Array;
  
  -- Возвращать значение в виде объекта CLOB
  final member function To_CLob Return CLob
  is
    Result  CLob;
    v_Buf   Varchar2(32767);
  begin
    -- Удостовериться, что строка закрыта
    Self.Check_Closed();
    --
    -- Присвоить первую страницу буфера в результат
    Result := Self.Cast_To_String(Self."_Extract_Raw_Data "(1, 'N'));
    --
    -- Возвращать значение в виде объекта CLOB
    for I in 2..Self.Get_Buf_Count
    loop
      -- Извлекать очередной блок буфера
      v_Buf := Self.Cast_To_String(Self."_Extract_Raw_Data "(I, 'N'));
      -- Добавить страницу буфера в результат
      DBMS_Lob.WriteAppend(Result, Lengthb(v_Buf), v_Buf);
    end loop;
    -- Возвращать значение в виде объекта CLOB
    return Result;
  end To_CLob;
  
  -- Возвращать значение в виде объекта BLOB
  final member function To_BLob Return BLob
  is
    Result  BLob;
    v_Buf   Raw(32767);
  begin
    -- Удостовериться, что строка закрыта
    Self.Check_Closed();
    --
    -- Присвоить первую страницу буфера в результат
    Result := Self."_Extract_Raw_Data "(1, 'N');
    --
    -- Возвращать значение в виде объекта CLOB
    for I in 2..Self.Get_Buf_Count
    loop
      -- Извлекать очередной блок буфера
      v_Buf := Self."_Extract_Raw_Data "(I, 'N');
      -- Добавить страницу буфера в результат
      DBMS_Lob.WriteAppend(Result, UTL_Raw.Length(v_Buf), v_Buf);
    end loop;
    -- Возвращать значение в виде объекта CLOB
    return Result;
  end To_BLob;
  
  
  -- Возвращать значение в виде коллекции строк для отладочных целей
  final member function Debug Return Array_Varchar2
  is
    Result  Array_Varchar2 := Array_Varchar2();
  begin
    for I in 1..Self.Get_Buf_Count
    loop
      -- Добавить очередной блок в результат
      Result.Extend;
      Result(I) := Self.Cast_To_String(Self."_Extract_Raw_Data "(I, 'N', True));
    end loop;
    -- Возвращать результат
    return Result;
  end Debug;
  
  
  
end;
/
