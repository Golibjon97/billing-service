create or replace type array_varchar2 force is table of varchar2(32767)
/
create or replace type array_number force is table of number;
/
create or replace type array_date force is table of date;
/
create or replace type array_timestamp force is table of timestamp;
/
create or replace type array_blob is table of blob;
/
create or replace type array_clob is table of clob;
/