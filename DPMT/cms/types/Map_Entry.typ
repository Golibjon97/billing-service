create or replace type Map_Entry force as object
(
-- Author  : AZAMAT
-- Created : 06.05.2016 20:15:34
-- Purpose : 
  key varchar2(100),
  val Object_t,

------------------------------------------------------------------------------------------------------
  constructor Function Map_Entry
  (
    self in out nocopy Map_Entry,
    key    varchar2,
    val    Object_t
  ) return self as result

)
/
create or replace type body Map_Entry is

  ------------------------------------------------------------------------------------------------------
  constructor Function Map_Entry
  (
    self in out nocopy Map_Entry,
    key    varchar2,
    val    Object_t
  ) return self as result is
  begin
    Self.key := key;
    Self.val := val;
    return;
  end;

end;
/
