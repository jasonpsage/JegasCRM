{==============================================================================
|    _________ _______  _______  ______  _______  Jegas, LLC                  |
|   /___  ___// _____/ / _____/ / __  / / _____/  JasonPSage@jegas.com        |
|      / /   / /__    / / ___  / /_/ / / /____                                |
|     / /   / ____/  / / /  / / __  / /____  /                                |
|____/ /   / /___   / /__/ / / / / / _____/ /                                 |
/_____/   /______/ /______/ /_/ /_/ /______/                                  |
|                 Under the Hood                                              |
===============================================================================
                       Copyright(c)2012 Jegas, LLC
==============================================================================}

//=============================================================================
program dev_pass;
//=============================================================================

//=============================================================================
// Global Directives
//=============================================================================
{$INCLUDE i_jegas_splash.pp}
{$SMARTLINK ON}
{$MODE objfpc}
{$PACKRECORDS 4}
//=============================================================================

//=============================================================================
uses
//=============================================================================
 sysutils
 ,ug_common
 ,ug_jegas
 ,ug_jado;
//=============================================================================

//=============================================================================
function bMyTest(): boolean;
//=============================================================================
var
  saQry: ansistring;
  bOK: boolean;
  rs: JADO_RECORDSET;
  JAS: JADO_CONNECTION;
  saPassword: ansistring;
    
begin
  JAS:=JADO_CONNECTION.Create;
  rs:=JADO_RECORDSET.Create;
  bOk:=JAS.bLoad('../config/database/jas.dsn');
  if not bOk then 
  begin 
    writeln('failed bLoad');
  end;

  if bOk then
  begin
    bOk:=JAS.bConnectTo;
    if not bOk then 
    begin 
      writeln('failed to connect');
    end;
  end;
  
  if bok then
  begin
    saQry:='select JUser_Password from juser where JUser_Name=''admin''';
    bok:=rs.open(saQry,JAS);
    if not bok then 
    begin
      write('query failed or eol');
    end;
  end;

  if bok then
  begin
    saPassword:=rs.fields.Get_saValue('JUser_Password');
    writeln('BEFORE:'+saPassword);
    saPassword:=saXorString(saPassword, grJASConfig.u1PasswordKey);
    writeln('AFTER:'+saPassword);
  end;

  rs.close;
  rs.destroy;
  JAS.Destroy; 
end;
//=============================================================================



//=============================================================================
Begin // Main Program
//=============================================================================
  bMyTest();
//=============================================================================
End.
//=============================================================================

//*****************************************************************************
// EOF
//*****************************************************************************