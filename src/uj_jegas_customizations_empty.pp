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
// This is Where customization code begins for
// integration with the JEGAS information system.
Unit uj_jegas_customizations_empty;
//=============================================================================

//=============================================================================
// Global Directives
//=============================================================================
{$INCLUDE i_jegas_macros.pp}
{$DEFINE SOURCEFILE:='uj_jegas_customizations_empty.pp'}
{$SMARTLINK ON}
{$PACKRECORDS 4}
{$MODE objfpc}

{$IFDEF DEBUGLOGBEGINEND}
  {$INFO | DEBUGLOGBEGINEND: TRUE}
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
classes
,syncobjs
,sysutils
//,ug_common
,ug_jegas
//,ug_jfc_dl
//,ug_jfc_xdl
//,ug_jfc_xxdl
,ug_jfc_xml
//,ug_jfc_tokenizer
//,ug_jfc_dir
,ug_cgiin
,ug_cgiout
//,ug_jado
//,uj_definitions
,uj_context
//,uj_ui_stock
//,uj_fileserv
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
procedure UserCustomizations(Var p_Context: TCONTEXT);
procedure UserAPI_Dispatch(p_Context: TCONTEXT);  //< Runs User API functions

//*****************************************************************************
//=============================================================================
//*****************************************************************************
//
                              Implementation
//             
//*****************************************************************************
//=============================================================================
//*****************************************************************************

//=============================================================================
procedure userapi_helloworld(p_Context: TCONTEXT);
//=============================================================================
var 
  xmlnode: JFC_XML;
  xmlnode2: JFC_XML;
  {$IFDEF ROUTINENAMES}sTHIS_ROUTINE_NAME: String;{$ENDIF}
Begin
{$IFDEF ROUTINENAMES}sTHIS_ROUTINE_NAME:='userapi_helloworld(p_Context: TCONTEXT);';{$ENDIF}
{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201203102365,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201203102366, sTHIS_ROUTINE_NAME);{$ENDIF}

  with p_Context do begin
    // The dataxdl is where ouput data goes
    p_Context.XML.AppendItem_saName_n_saValue('helloworld','hello world!');

    // Here we interrogate the CGIENV class which contains the kinds of things 
    // required for web application development: cookies, form parameters,    
    // environment information etc. 
    // So.. that said, we are iterating through all the cookies that may have 
    // come in and our sending them out as part of this functions result. 
    p_Context.XML.AppendItem_saName('CKYIN');    
    if(p_Context.CGIENV.CKYIN.MoveFirst)then
    begin
      xmlnode:=JFC_XML.Create;
      p_Context.XML.Item_lpPtr:=xmlnode;
      repeat
        xmlnode.AppendItem_saName_n_saValue(
          p_Context.CGIENV.CKYIN.Item_saName,
          p_Context.CGIENV.CKYIN.Item_saValue
        );
      until not p_Context.CGIENV.CKYIN.movenext;
    end;

    // Here we interrogate any and all parameters that came in either through
    // POST method or GET (and if post, we still collect parameters from the URL
    // effectively making POST a dual role :) 
    p_Context.XML.AppendItem_saName('DATAIN');
    if(p_Context.CGIENV.DATAIN.MoveFirst)then
    begin
      xmlnode:=JFC_XML.Create;
      p_Context.XML.Item_lpPtr:=xmlnode;
      repeat
        xmlnode.appenditem_saName(p_Context.CGIENV.DATAIN.Item_saName);
        xmlnode2:=JFC_XML.Create;
        xmlnode.Item_lpPtr:=xmlnode2;
        xmlnode2.AppendItem_saName_n_saValue('value',p_Context.CGIENV.DATAIN.Item_saValue);
        xmlnode2.AppendItem_saName_n_saValue('desc',p_Context.CGIENV.DATAIN.Item_saDesc);
      until not p_Context.CGIENV.DATAIN.movenext;
    end;

    // Now we add a cookie for the output. You should see it when you call
    // this function a second time. First call it's sent, after it might 
    // come in with the other cookies :)
    p_Context.CGIENV.AddCookie(
      'cookiename',
      'cookievalue',
      p_Context.CGIENV.saRequestURIWithoutparam,
      dtAddMinutes(now,grJASConfig.iSessionTimeOutInMinutes),
      false
    );
  end;
  p_Context.CGIENV.iHTTPResponse:=200;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOut(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201203102367,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================

//=============================================================================
procedure userapi_returnhtml(p_Context: TCONTEXT);
//=============================================================================
var
  sa: ansistring;
  {$IFDEF ROUTINENAMES}sTHIS_ROUTINE_NAME: String;{$ENDIF}
Begin
{$IFDEF ROUTINENAMES}sTHIS_ROUTINE_NAME:='userapi_returnhtml(p_Context: TCONTEXT);';{$ENDIF}
{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201203102368,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201203102369, sTHIS_ROUTINE_NAME);{$ENDIF}

  with p_Context do begin
    // return html
    sa:='<![CDATA[<div><h1>returnhtml</h1><p><b>bold</b>&nbsp;[@USERNAME@]<i>italic</i>&nbsp;<u>underline</u> Cool - <br />I think its working</p></div>]]>';
    
    // If we wanted to return javascript code to fire on the client we do this:
    //p_Context.saActionType:='javascript';
    //sa:='alert("hello dude");';
    
    
    // The dataxdl is where ouput data goes
    p_Context.XML.AppendItem_saName_n_saValue('returnhtml',sa);
    p_Context.CGIENV.iHTTPResponse:=200;// Not setting this will cause an error.
  end;
{$IFDEF DEBUGLOGBEGINEND}
  DebugOut(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOut(201203102370,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================



//=============================================================================
// Runs User API functions and wraps the results in IWF friendly xml
Procedure UserAPI_Dispatch(p_Context: TCONTEXT);  // Runs Jegas API functions
//=============================================================================
label done_userapi;
{$IFDEF ROUTINENAMES}var  sTHIS_ROUTINE_NAME: String;{$ENDIF}
Begin
{$IFDEF ROUTINENAMES}sTHIS_ROUTINE_NAME:='UserAPI_Dispatch(p_Context: TCONTEXT);';{$ENDIF}
{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201203102371,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201203102372, sTHIS_ROUTINE_NAME);{$ENDIF}


  // The IWF framework has a few values we need to populate. The one that changes how the 
  // result is used on the client receiving the file is the actiontype value. IWF has the 
  // ability to dynamically deliver javascript. Normally this value will be "xml" but for
  // some fancy client interactions, it can be changed as required. See IWF documentation
  // for more instruction.
  if (p_Context.saFileNameOnlyNoExt='helloworld')then 
  begin 
    userapi_helloworld(p_Context); 
    goto done_userapi; 
  end;

  if (p_Context.saFileNameOnlyNoExt='returnhtml')then 
  begin 
    userapi_returnhtml(p_Context); 
    goto done_userapi; 
  end;

  done_userapi:
{$IFDEF DEBUGLOGBEGINEND}
  DebugOut(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201203102373,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================







//=============================================================================
procedure UserCustomizations(Var p_Context: TContext);
//=============================================================================
label donehere;
//var i: integer;
  {$IFDEF ROUTINENAMES}var sTHIS_ROUTINE_NAME: String;{$ENDIF}
Begin
{$IFDEF ROUTINENAMES}sTHIS_ROUTINE_NAME:='UserCustomizations(Var p_Context: TContext);';{$ENDIF}
{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201203102374,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201203102375, sTHIS_ROUTINE_NAME);{$ENDIF}

donehere: ;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOut(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201203102376,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
End;
//=============================================================================









//=============================================================================
// Initialization
//=============================================================================
Begin
//=============================================================================
//=============================================================================
End.
//=============================================================================


//*****************************************************************************
// eof
//*****************************************************************************
