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
{}
// Program to test filename parsing routines in Jegas' uxxg_jegas unit.
program test_filename_parse;
//=============================================================================


//=============================================================================
// Global Directives
//=============================================================================
{$INCLUDE i_jegas_macros.pp}
//=============================================================================


//=============================================================================
uses
//=============================================================================
  sysutils,
  ug_common,
  ug_jegas;
//=============================================================================

//=============================================================================
var safileSought: ansistring;
var saFileSoughtExt: ansistring;
var saFileSoughtNoExt: ansistring;
//=============================================================================

//=============================================================================
begin
//=============================================================================
  safileSought:='f:/test/somefile.txt';
  saFileSoughtNoExt:=LowerCase(saFileNameNoExt(saFileSought));
  saFileSoughtExt:=LowerCase(ExtractFileExt(saFileSought));
  saFileSoughtExt:=RightStr(saFileSoughtExt,length(saFileSoughtExt));
  writeln('saFileSought:',saFileSought);
  writeln('saFileSoughtNoExt:',saFileSoughtNoExt);
  writeln('saFileSoughtExt:',saFileSoughtExt);
end.
//=============================================================================

//*****************************************************************************
// EOF
//*****************************************************************************

