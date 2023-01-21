create or replace package Rep_Util is

  -- Author  : ADMIN
  -- Created : 26.12.2018 15:23:05
  -- Purpose : No purpose

  ----------------------------------------------------------------------------------------------------
  Function Style return varchar2;
  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Tag;
  ----------------------------------------------------------------------------------------------------
  Procedure End_Tag;

end Rep_Util;
/
create or replace package body Rep_Util is

  ----------------------------------------------------------------------------------------------------
  Function Style return varchar2 is
    result varchar2(2000);
  begin
    result := '<style>table{mso-displayed-decimal-separator:"\.";mso-displayed-thousand-separator:" ";font-size:10.0pt; text-align:center;};';
    result := result || 'table.with-collapse{border-collapse:collapse;};';
    result := result ||
              'table.with-collapse, table.with-collapse th, table.with-collapse td{border:1px solid #000;}; ';
    result := result || '.txt{mso-number-format:"\@";text-align:left;};';
    result := result || '.txt_l{mso-number-format:"\@";text-align:left;};';
    result := result || '.txt_c{mso-number-format:"\@";text-align:center;};';
    result := result || '.txt_r{mso-number-format:"\@";text-align:right;};';
    result := result || '.num{white-space:nowrap;mso-number-format:Standard;text-align:right};';
    result := result ||
              '.num_bold{font-weight:bold; white-space:nowrap;mso-number-format:Standard;text-align:right};';
    result := result || '.head{background:#DCDCDC;valign:top};';
    result := result || '.bold_color{font-weight:bold;background:#dfdfdf};';
    result := result || '.bold{font-weight:bold};</style>';
    return result;
  end;

  ----------------------------------------------------------------------------------------------------
  Procedure Begin_Tag is
  begin
    Rep.Print('<html>');
    Rep.Print('<head>');
    Rep.Print('<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">');
    Rep.Print(Style);
    Rep.Print('</head>');
    Rep.Print('<body>');
  end Begin_Tag;

  ----------------------------------------------------------------------------------------------------
  Procedure End_Tag is
  begin
    Rep.Print('</body>');
    Rep.Print('</html>');
  end End_Tag;

end Rep_Util;
/
