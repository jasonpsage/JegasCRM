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
// Zebra compatible EPL2 Printing Support
Unit ug_zebra;
//=============================================================================



//=============================================================================
// Global Directives
//=============================================================================
{$INCLUDE i_jegas_macros.pp}
{$DEFINE SOURCEFILE:='ug_zebra.pp'}
{$SMARTLINK ON}
{$PACKRECORDS 4}
{$MODE objfpc}

{$IFDEF DEBUGLOGBEGINEND}
  {$INFO | DEBUGLOGBEGINEND}
{$ENDIF}
//=============================================================================



//*****************************************************************************
//=============================================================================
//*****************************************************************************
//
                               Interface
//             
//*****************************************************************************
//=============================================================================
//*****************************************************************************

//=============================================================================
Uses 
//=============================================================================
  ug_common
 ,ug_jegas
 ,sysutils
;
//=============================================================================


//*****************************************************************************
//=============================================================================
//*****************************************************************************
// !@!Declarations 
//*****************************************************************************
//=============================================================================
//*****************************************************************************
{}
Type rtZebra=Record
  iXOffSet: Integer;
  iYOffSet: Integer;
End;  
Var grZebra: rtZebra;


//=============================================================================
{}
Function saZNewLabel: AnsiString; 
//=============================================================================
{}
Function saZDoneLabel: AnsiString; 
//=============================================================================
{}
Function saZResetPrinter: AnsiString;
//=============================================================================
{}
Function saZCmdXY(
  p_saCMD: AnsiString; 
  p_iX: Integer; 
  p_iY: Integer; 
  p_saOther: AnsiString
): AnsiString;
//=============================================================================
{}
Procedure ZSetOffSet(p_iXOffSet: Integer; p_iYOffSet: Integer);
//=============================================================================
{}
Procedure testmsi;
//=============================================================================


//*****************************************************************************
//=============================================================================
//*****************************************************************************
//
                              Implementation
//            
//*****************************************************************************
//=============================================================================
//*****************************************************************************


//*****************************************************************************
//=============================================================================
//*****************************************************************************
// !#!Declarations 
//*****************************************************************************
//=============================================================================
//*****************************************************************************
//=============================================================================
Procedure ZSetOffSet(p_iXOffSet: Integer; p_iYOffSet: Integer);
//=============================================================================
Begin
  grZebra.iXOffset:=p_iXOffSet;
  grZebra.iYOffset:=p_iYOffSet;
End;
//=============================================================================

//=============================================================================
Function saZNewLabel: AnsiString; 
//=============================================================================
Begin 
  Result:=#10+'N'+#10;
End;
//=============================================================================

//=============================================================================
Function saZResetPrinter: AnsiString;
//=============================================================================
Begin
  Result:='^@'+#10;
End;
//=============================================================================

//=============================================================================
Function saZDoneLabel: AnsiString;
//=============================================================================
Begin 
  Result:='P1'+#10;
End;
//=============================================================================

//=============================================================================
Function saZCmdXY(
  p_saCMD: AnsiString; 
  p_iX: Integer; 
  p_iY: Integer; 
  p_saOther: AnsiString
): AnsiString;
//=============================================================================
Begin
  Result:=p_saCMD + inttostr(grZebra.iXOffSet+p_iX)+','+
                    inttostr(grZebra.iYOffSet+p_iY)+','+p_saOther+#10;
End;
//=============================================================================
//=============================================================================

//=============================================================================
Procedure testmsi;
Var ft: text;
Begin
  assign(ft,'lpt1:');
  rewrite(ft);
  Write(ft,saZNewLabel);
  ZSetOffSet(260,3);
  Write(ft,saZCmdXY('A',1,1, '0,2,1,1,N,"I Love you Springli Sage!"'));
  Write(ft,saZDoneLabel);
  close(Ft);
End;

//=============================================================================
// Initialization
//=============================================================================
Begin
//=============================================================================
  grZebra.iXOffSet:=0;
  grZebra.iYOffSet:=0;
//=============================================================================
End.
//=============================================================================

//=============================================================================
// History (Please Insert Historic Entries at top)
//=============================================================================
// Date        Who             Notes
//=============================================================================
//=============================================================================

//*****************************************************************************
// eof
//*****************************************************************************
