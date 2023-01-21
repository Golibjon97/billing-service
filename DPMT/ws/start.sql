spool c:\ws_01.txt
--
set define off;
--
WHENEVER SQLERROR EXIT;
exec vcs_util.register_script_start('ws_01','19082022',array_varchar2('ws'),'dpmt','WS');
--
prompt ==================== 'ws_01','19082022' ====================
WHENEVER SQLERROR CONTINUE;
--
prompt =============================================================================
prompt STOPPING JOBS
prompt
--
exec Document_InOut.JOB_STOP;
exec nibbd.Job_Stop;
exec nibbd_end.Job_Stop;
exec nibbd_test.Job_Stop;
exec asa_iabs.Job_Stop;
exec oko_fast_cassa_loader.job_stop;
--
prompt =========================================
prompt SCRIPTS...
prompt
--
@@script\create.sql
@@script\insert.sql
--

prompt =========================================
prompt PACKAGES...
prompt
--
@@package\JSON_Parser.pck
@@package\ws_api.pck
@@package\ws_kernel.pck
@@package\ws_transporter.pck
--


prompt =========================================
prompt Compiling..
prompt
--
exec uu.compile;
--
prompt =========================================
prompt STARTING JOBS..
prompt
--
exec Document_InOut.Job_Start;
exec Nibbd.Job_Start;
exec nibbd_end.Job_Start;
exec nibbd_test.Job_Start;
exec asa_iabs.Job_Start;
exec oko_fast_cassa_loader.job_start;
--
@@invalid.sql;
--
exec vcs_util.register_script_stop;
--
commit;
--
spool off;