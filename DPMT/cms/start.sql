spool c:\CMS_IBS.txt

set define off;
set serveroutput on;

WHENEVER SQLERROR EXIT;



prompt ================     Upgrade 'CMS','01042022' ================

WHENEVER SQLERROR CONTINUE;

@@invalid.sql;

prompt === types ===
drop type Object_t force;
@types/HASH_ENTRY.typ
@types/HASH_BUCKET.TPS
@types/HASH_BUCKET_ARRAY.TPS
@types/HASHTABLE.typ
@types/Long_String.typ;
@types/primitive.sql;
@types/Object_t.typ;
@types/Varchar2_t.typ;
@types/Number_t.typ;
@types/Date_t.typ;
@types/Clob_t.typ;
@types/Timestamp_t.typ;
@types/Array_Varchar2_t.typ;
@types/Array_Number_t.typ;
@types/Array_Date_t.typ;
@types/array_object_t.sql;
@types/Array_Timestamp_t.typ;
@types/String_Object_T.typ;
@types/Arraylist.typ;
@types/Map_Entry.typ;
@types/map_bucket.sql;
@types/map_bucket_array.sql;
@types/Hashmap.typ;
@types/ARRAY_RAW.tps;
@types/JSON_String_T.typ;

prompt === �����! ��� ����������� ���������� ��������! ===




@@invalid.sql;

set define on;



spool off;
