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
// This simple program was made to be used in POSIX and DOS Batch Files to
// pause a script and wait for the user to PRESS enter to continue. Other
// typed keys will be echoed to the screen but are not used in anyway.
program readline;
//=============================================================================

//=============================================================================
// GLOBAL DEFINES
//=============================================================================
{$INCLUDE i_jegas_splash.pp}
{$mode objfpc}
//=============================================================================


//=============================================================================
begin
write('Press [ENTER]:');  
readln;
end.
//=============================================================================

//*****************************************************************************
// EOF
//*****************************************************************************
