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
// Tests IP routes from source to destination. A Synapse Function.
Program testroute;
//=============================================================================

//=============================================================================
// GLOBAL DIRECTIVES
//=============================================================================
{$INCLUDE i_jegas_macros.pp}
{$MODE DELPHI}
//=============================================================================

//=============================================================================
uses
//=============================================================================
 pingsend;
//=============================================================================

//=============================================================================
begin
//=============================================================================
  Writeln (TracerouteHost(paramstr(1)));
end.
//=============================================================================

//*****************************************************************************
// EOF
//*****************************************************************************
