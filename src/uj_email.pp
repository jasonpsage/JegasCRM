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
Unit uj_email;
//=============================================================================


//=============================================================================
// Global Directives
//=============================================================================
{$INCLUDE i_jegas_macros.pp}
{$DEFINE SOURCEFILE:='uj_email.pp'}
{$SMARTLINK ON}
{$PACKRECORDS 4}
{$MODE objfpc}

{$IFDEF DEBUGLOGBEGINEND}
  {$INFO | DEBUGLOGBEGINEND: TRUE}
{$ENDIF}

{DEFINE DEBUGTHREADBEGINEND} // used for thread debugging, like begin and end sorta
                  // showthreads shows the threads progress with this.
                  // whereas debuglogbeginend is ONE log file for all.
                  // a bit messy for threads. See uxxg_jfc_threadmgr for
                  // mating define - to use this here, needs to be declared
                  // in uxxg_jfc_threadmgr also.
{$IFDEF DEBUGTHREADBEGINEND}
  {$INFO | DEBUGTHREADBEGINEND: TRUE}
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
,sysutils
,smtpsend_jas
,ug_common
,ug_misc
,ug_jegas
,ug_jfc_tokenizer
,uj_definitions
,uj_context
,uj_tables_loadsave
,ug_jado
,uj_locking
;

//=============================================================================


//*****************************************************************************
//=============================================================================
//*****************************************************************************
// !@!Declarations 
//*****************************************************************************
//=============================================================================
//*****************************************************************************
//To: ToField@jegas.com
//From: FromField@jegas.com
//Subject: testing windows sendmail thing
//Content-Transfer-Encoding: quoted-printable
//Content-Type: text/html; charset="utf-8"
//
//<h1>Hello</h1>
//<h2>This is html!</h2>



//=============================================================================
{}
// Sends p_saMsg via Sendmail.
function bJAS_Sendmail(p_Context: TContext; p_sFrom:string; p_sTo: string; p_sSubject: string; p_saMsg: ansistring): boolean;
//=============================================================================
{}
// Sends Specific kind of email: e.g. Task Reminder
// example: .?jasapi=email&type=taskreminder&uid=123456789
procedure JASAPI_Email(p_Context: TCONTEXT);
//=============================================================================
{}
function bEmail_TaskReminder(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
{}
function bEmail_ValidateUser(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
{}
function bEmail_ProcessEvent(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
{}
function bEmail_ResetPassword(
  p_Context: TCONTEXT;
  p_saUID,
  p_saKey: ansistring;
  p_saEmail: ansistring;
  p_saTopMessage: ansistring;
  p_saAlias: ansistring
): boolean;
//=============================================================================
{}
// .?jasapi=email&type=sharevideo&videoid='+encodeURI(p_VideoUID)+'&email='+sEmail;
function bEmail_ShareVideo(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
{}
// This is used to send email when a background export has completed launched
// from a Filter+Grid Screen. Note - UID is jfile UID. From there we get task,
// then person.
function bEmail_DataExportComplete(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
{}
// This Allows Sending email to current user using the Work Email Address
// using content you specify.
function bEmail_Generic(
  p_Context: TCONTEXT;
  p_saSubject: ansistring;
  p_saMessage: ansistring
): boolean;
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


//=============================================================================
{}
// Sends p_saMsg via Sendmail.
function bJAS_Sendmail(p_Context: TContext; p_sFrom:string; p_sTo: string; p_sSubject: string; p_saMsg: ansistring): boolean;
//=============================================================================
var
  bOk: boolean;
  SL: TSTRINGLIST;
  TK: JFC_TOKENIZER;
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bJAS_Sendmail(p_Context: string; p_sFrom:string; p_sTo: string; p_sSubject: string; p_saMsg: ansistring)'; {$ENDIF}
{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201203102738,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201203102739, sTHIS_ROUTINE_NAME);{$ENDIF}
  SL:=TSTRINGLIST.create;
  TK:=JFC_TOKENIZER.Create;
  TK.saSeparators:=#13+#10;
  TK.saWhitespace:=#13+#10;
  TK.Tokenize(p_saMsg);
  if TK.MoveFirst then
  begin
    repeat
      SL.Add(TK.Item_saToken);
    until not TK.MoveNext;
  end;
  //SendToEx('jasonpsage@jegas.com', 'jasonpsage@jegas.com', 'Testing synapse', 'smtp.comcast.net',  t, 'jasonpsage@comcast', 'password')
  bOk:=SendToEx(saDecodeURI(p_sFrom), saDecodeURI(p_sTo), p_sSubject, grJASConfig.sSMTPHost,SL, grJASConfig.sSMTPUserName, grJASConfig.sSMTPPassword);
  if not bOk then
  begin
    JAS_LOG(p_Context, cnLog_Error, 201204171210, 'Unable to Send Email. '+
    'From: '+p_sFrom+' To: '+p_sTo+' Subject: '+p_sSubject+' Host: '+grJASConfig.sSMTPHost+' '+
    'Username: '+grJASConfig.sSMTPUserName+//' Password: '+grJASConfig.sSMTPPassword+' '+
    'Msg: '+SL.Text,'',SOURCEFILE);
  end;

  SL.destroy;
  TK.Destroy;
  result:=bOk;
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201203662740,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================





















//=============================================================================
{}
// Sends Specific kind of email: Task Reminder
// example: 
procedure JASAPI_Email(p_Context: TCONTEXT);
//=============================================================================
var
  bOk: boolean;
  saUID: ansistring;
  saType: ansistring;
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='JASAPI_TaskEmail(p_Context: TCONTEXT);'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201203102741,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201203102742, sTHIS_ROUTINE_NAME);{$ENDIF}

  p_Context.CGIENV.iHTTPResponse:=200;// Not setting this will cause an error.

  bOk:=p_Context.bSessionValid;
  if not bOk then
  begin
    JAS_LOG(p_Context, cnLog_Error, 201204140418, 'jasapi_taskemail - Invalid Session','',SOURCEFILE);
  end;

  if bOk then
  begin
    // extra conversion is a safe guard against injection attack
    saUID:=inttostr(u8Val(trim(p_Context.CGIENV.DataIn.Get_saValue('UID'))));
    saType:=upcase(trim(p_Context.CGIENV.DataIn.Get_saValue('type')));
    if saType='TASKREMINDER' then
    begin
      bOk:=bEmail_TaskReminder(p_Context,saUID);
    end else

    if saType='VALIDATEUSER' then
    begin
      bOk:=bEmail_ValidateUser(p_Context,saUID);
    end else

    if saType='PROCESSEVENT' then
    begin
      bOk:=bEmail_ProcessEvent(p_Context,saUID);
    end else

    if saType='RESETPASSWORD' then
    begin
      bOk:=bEmail_ProcessEvent(p_Context,saUID);
    end else

    if saType='SHAREVIDEO' then
    begin
      bOk:=bEmail_ShareVideo(p_Context,saUID);
    end else

    if saType='DATAEXPORTCOMPLETE' then
    begin
      bOk:=bEmail_DataExportComplete(p_Context,saUID);
    end else

    if saType='GENERIC' then
    begin
      bOk:=bEmail_Generic(
        p_Context,
        p_Context.CGIENV.DataIn.Get_saValue('SUBJECT'),
        p_Context.CGIENV.DataIn.Get_saValue('MESSAGE')
      );
    end else

    begin
      bOk:=false;
      JAS_LOG(p_Context, cnLog_Error, 201204171345, 'Invalid Type sent to JASAPI_Email: '+saType,'',SOURCEFILE);
    end;
  end;

  // with that compose the Task Reminder Email and then we call sendmail
  p_Context.XML.AppendItem_saName_N_saValue(
    'result',lowercase( trim(saTrueFalse( bok)))
  );
  p_Context.iErrorReportingMode:=cnSYS_INFO_MODE_SECURE;// Prevent debug info being appended

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201203102743,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================




















//=============================================================================
{}
// Sends Specific kind of email: Task Reminder
function bEmail_TaskReminder(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
var
  bOk: boolean;
  rJTask: rtJTask;
  saMsg: ansistring;
  rJUser: rtJUser;
  rJPerson: rtJPerson;
  DBC: JADO_CONNECTION;

{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bEmail_TaskReminder'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201203102744,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201203102745, sTHIS_ROUTINE_NAME);{$ENDIF}


  //AS_Log(p_Context,cnLog_debug, 201503170007, 'bemail_taskreminder called', '', SOURCEFILE);


  DBC:=p_Context.VHDBC;
  clear_JTask(rJTask);
  rJTask.JTask_JTask_UID:=p_saUID;

  // load jtask here and get owner id then load their primary email address
  bOk:=bJAS_Load_JTask(p_Context, DBC, rJTask,true);
  if not bOk then
  begin
    p_Context.u8ErrNo:=201110122056;
    p_Context.saErrMsg:='bEmail_TaskReminder - trouble loading JTask record. Task UID: '+ p_saUID;
    JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
  end;

  if bOk then
  begin
    bOk := (bVal(rJTask.JTask_ReminderSent_b)=false);
    if not bOk then
    begin
      p_Context.u8ErrNo:=201202072017;
      p_Context.saErrMsg:='bEmail_TaskReminder - Email Already Sent - Aborting.';
      JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
    end;
  end;

  if bok then
  begin
    clear_JUser(rJUser);
    rJUser.JUser_JUser_UID:=u8Val(rJTask.JTask_Owner_JUser_ID);
    bOk:=bJas_Load_JUser(p_Context, DBC, rJUser,false);
    if not bOk then
    begin
      p_Context.u8ErrNo:=201110122057;
      p_Context.saErrMsg:='bEmail_TaskReminder - trouble loading JUser record.';
      JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
    end;
  end;

  if bok then
  begin
    clear_JPerson(rJPerson);
    rJPerson.JPers_JPerson_UID:=InttoStr(rJUser.JUser_JPerson_ID);
    bOk:=bJas_Load_JPerson(p_Context, DBC, rJPerson,false);
    if not bOk then
    begin
      p_Context.u8ErrNo:=201110122058;
      p_Context.saErrMsg:='bEmail_TaskReminder - trouble loading JPerson record.';
      JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
    end;
  end;

  saMsg:='';
  if bOk then
  begin
    saMsg+='<h2><a href="'+grJASConfig.saServerURL+p_COntext.saAlias+'?UID&#61;'+rJTask.JTask_JTask_UID+
      '&amp;screenid&#61;86" target="_blank">Task Reminder</a></h2>'+csCRLF;
    saMsg+='<p>'+rJTask.JTask_Start_DT+'</p>'+csCRLF;
    saMsg+='<h3>'+rJTask.JTask_Name+'</h3>'+csCRLF;
    if length(trim(rJTask.JTask_Desc))>0 then
    begin
      saMsg+='<h3>Description</h3>'+csCRLF;
      saMsg+='<p>'+trim(rJTask.JTask_Desc)+'</p>'+csCRLF;
    end;
    saMsg+=csCRLF;
    bOk:=bJAS_Sendmail(p_Context,garJVHostLight[p_Context.i4VHost].sSystemEmailFromAddress,rJPerson.JPers_Work_Email,'JAS Reminder',saMsg);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201204171209, 'Unable to Send Email from JobQ. Task ID: '+rJTask.JTask_JTask_UID,'',SOURCEFILE);
    end;
  end;

  if bOk then
  begin
    rJTask.JTask_ReminderSent_b:='1';
    bOk:=bJAS_Save_JTask(p_Context, DBC, rJTask, true, false);
    if not bok then
    begin
      p_Context.u8ErrNo:=201110131150;
      p_Context.saErrMsg:='bEmail_TaskReminder - trouble saving '+
        'JTask (task) record: '+rJTask.JTask_JTask_UID+' Intended Recipient: '+rJPerson.JPers_Work_Email;
      JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
    end;
  end;

  result:=bOk;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201203102746,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================









//=============================================================================
{}
// Sends Specific kind of email: Validate User (Registration Step)
function bEmail_ValidateUser(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
var
  bOk: boolean;
  saMsg: ansistring;
  rJUser: rtJUser;
  rJPerson: rtJPerson;
  DBC: JADO_CONNECTION;

{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bEmail_ValidateUser'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201206181714,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201206181715, sTHIS_ROUTINE_NAME);{$ENDIF}

  DBC:=p_Context.VHDBC;
  clear_JUser(rJUser);
  rJUser.JUser_JUser_UID:=u8Val(p_saUID);


  //JAS_Log(p_Context, cnLog_Debug, 201208181623,'begin bEmail_ValidateUser JUser Locked: '+
  //  saTrueFalse(bJAS_RecordLockValid(p_Context,DBC.ID, 'juser',rJUser.JUser_JUser_UID,'0')
  //),'',SOURCEFILE);

  bOk:=bJAS_Load_JUser(p_Context, DBC, rJUser,false);
  if not bOk then
  begin
    p_Context.u8ErrNo:=201206181716;
    p_Context.saErrMsg:='bEmail_ValidateUser - trouble loading JUser record.';
    JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
  end;

  if bok then
  begin
    clear_JPerson(rJPerson);
    rJPerson.JPers_JPerson_UID:=inttostr(rJUser.JUser_JPerson_ID);
    bOk:=bJas_Load_JPerson(p_Context, DBC, rJPerson,false);
    if not bOk then
    begin
      p_Context.u8ErrNo:=201206181718;
      p_Context.saErrMsg:='bEmail_ValidateUser - trouble loading JPerson record.';
      JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
    end;
  end;

  saMsg:='';
  if bOk then
  begin
    saMsg+='<h3>Welcome to '+grJASConfig.saServerName+'</h3>'+csCRLF;
    saMsg+='<h2><a href="'+grJASConfig.saServerURL+p_Context.saAlias+'?Action=verifyemail&amp;UID&#61;'+
      inttostr(rJUser.JUser_JUser_UID)+
      '" target="_blank">Click to validate your email address.</a></h2><br /><br />'+csCRLF+csCRLF;
    saMsg+='If the link above does not work, copy and paste the URL below into your browser:<br /><br />'+csCRLF+csCRLF;
    saMsg+=grJASConfig.saServerURL+'/?Action=verifyemail&amp;UID&#61;'+inttostr(rJUser.JUser_JUser_UID)+'<br /><br />'+csCRLF+csCRLF;
    bOk:=bJAS_Sendmail(p_Context,garJVHostLight[p_Context.i4VHost].sSystemEmailFromAddress,rJPerson.JPers_Work_Email,grJASConfig.saServerName + ' Email Verification',saMsg);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201206181719, 'Unable to Send Email from JobQ. User ID: '+inttostr(rJUser.JUser_JUser_UID),'',SOURCEFILE);
    end;
  end;
  result:=bOk;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201206181720,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================






//=============================================================================
{}
// Sends results of vRooster ProcessEvent userapi function
function bEmail_ProcessEvent(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
var
  bOk: boolean;
  saMsg: ansistring;
  rJUser: rtJUser;
  rJPerson: rtJPerson;
  DBC: JADO_CONNECTION;

{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bEmail_ProcessEvent'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201209072359,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201209080000, sTHIS_ROUTINE_NAME);{$ENDIF}

  DBC:=p_Context.VHDBC;
  clear_JUser(rJUser);
  rJUser.JUser_JUser_UID:=u8Val(p_saUID);


  //JAS_Log(p_Context, cnLog_Debug, 201208181623,'begin bEmail_ProcessEvent JUser Locked: '+
  //  saTrueFalse(bJAS_RecordLockValid(p_Context,DBC.ID, 'juser',rJUser.JUser_JUser_UID,'0')
  //),'',SOURCEFILE);

  bOk:=bJAS_Load_JUser(p_Context, DBC, rJUser,false);
  if not bOk then
  begin
    p_Context.u8ErrNo:=201209080001;
    p_Context.saErrMsg:='bEmail_ProcessEvent - trouble loading JUser record.';
    JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
  end;

  if bok then
  begin
    clear_JPerson(rJPerson);
    rJPerson.JPers_JPerson_UID:=inttostr(rJUser.JUser_JPerson_ID);
    bOk:=bJas_Load_JPerson(p_Context, DBC, rJPerson,false);
    if not bOk then
    begin
      p_Context.u8ErrNo:=201209080002;
      p_Context.saErrMsg:='bEmail_ProcessEvent - trouble loading JPerson record.';
      JAS_Log(
        p_Context,
        cnLog_ERROR,
        p_Context.u8ErrNo,
        p_Context.saErrMsg,
        'rJUser.JUser_Name: '+rJUser.JUser_Name+' '+
          'rJUser.JUser_JPerson_ID: '+inttostR(rJUser.JUser_JPerson_ID),
        SOURCEFILE);
    end;
  end;

  saMsg:='';
  if bOk then
  begin
    saMsg:=p_Context.CGIENV.DataIn.Get_saValue('RESULTS')+csCRLF+csCRLF;
    //AS_LOG(p_Context, cnLog_Debug, 201209081504, 'CGIENV.DataIn: '+p_Context.CGIENV.DataIn.saHTMLTable,'',SOURCEFILE);
    bOk:=bJAS_Sendmail(p_Context,garJVHostLight[p_Context.i4VHost].sSystemEmailFromAddress,rJPerson.JPers_Work_Email,grJASConfig.saServerName + ' Create Video Results',saMsg);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209080003, 'Unable to Send Email from JobQ. User ID: '+inttostR(rJUser.JUser_JUser_UID),'',SOURCEFILE);
    end;
  end;
  result:=bOk;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201209080004,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================









//=============================================================================
{}
function bEmail_ResetPassword(
  p_Context: TCONTEXT;
  p_saUID,
  p_saKey: ansistring;
  p_saEmail: ansistring;
  p_saTopMessage: ansistring;
  p_saAlias: ansistring
): boolean;
//=============================================================================
var
  bOk: boolean;
  saMsg: ansistring;
  saLink: ansistring;
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bEmail_ProcessEvent'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201209131629,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201209131630, sTHIS_ROUTINE_NAME);{$ENDIF}

  saMsg:='';
  if bOk then
  begin
    if (saRightStr(p_saAlias,1)<>'/') then p_saAlias+='/';
    if (saLeftStr(p_saAlias,1)<>'/') then p_saAlias:='/'+p_saAlias;
    if p_saAlias='//' then p_saAlias:='/';
  
    saLink:=grJASConfig.saServerURL+p_saAlias+'?Action&#61;resetpassword&amp;uid&#61;'+p_saUID+'&amp;key&#61;'+p_saKey;

    if length(trim(p_saTopMessage))>0 then
    begin
      saMsg+=p_saTopMessage;
    end;
    
    saMsg+=
      '<h3>Password Reset</h3><br /><br />'+csCRLF+
      'Link: <a href="'+saLink+'">'+saLink+'</a><br /><br />'+csCRLF+
      'If the link above does not work, copy and paste the URL below into your browser:<br /><br />'+csCRLF+csCRLF+
      saLink;
    bOk:=bJAS_Sendmail(p_Context,garJVHostLight[p_Context.i4VHost].sSystemEmailFromAddress,p_saEmail,grJASConfig.saServerName + ' Password Reset',saMsg);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209131631, 'Unable to Send Password Reset Email: '+ saMsg,'',SOURCEFILE);
    end;
  end;
  result:=bOk;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201209131632,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================



//=============================================================================
{}
// .?jasapi=email&type=sharevideo&videoid='+encodeURI(p_VideoUID)+'&email='+sEmail;
function bEmail_ShareVideo(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
var
  bOk: boolean;
  saMsg: ansistring;
  saLink: ansistring;
  saLink2: ansistring;
  saFilename: ansistring;
  DBC: JADO_CONNECTION;
  rs: JADO_RECORDSET;
  saQry: ansistring;
  saJPersonUID: ansistring;
  saJPersonName: ansistring;
  saEmail: ansistring;
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bEmail_ShareVideo'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201209271116,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201209271117, sTHIS_ROUTINE_NAME);{$ENDIF}
  saMsg:='';
  DBC:=p_Context.VHDBC;
  rs:=JADO_RECORDSET.Create;

  saEmail:=p_Context.CGIENV.DataIn.Get_saValue('email');
  bOk:=bGoodEmail(saEmail);
  if not bOk then
  begin
    JAS_LOG(p_Context, cnLog_Error, 201209271247, 'Bad Email:'+saEmail,'',SOURCEFILE);
  end;

  if bOk then
  begin
    saFileName:=DBC.saGetValue('vrvideo','VRVID_Filename',
      '(VRVID_VRVideo_UID='+DBC.saDBMSUIntScrub(p_saUID)+') AND '+
      '((VRVID_Deleted_b<>'+DBC.saDBMSBoolScrub(true)+') or '+
      ' (VRVID_Deleted_b IS NULL))');
    bOk:=length(safilename)>0;
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209271124, 'Unable to aquire video filename','',SOURCEFILE);
    end;
  end;

  if bOk then
  begin
    saQry:='SELECT JUser_JPerson_ID FROM juser WHERE '+
      'JUser_JUser_UID='+DBC.saDBMSUIntScrub(p_Context.rJUser.JUser_JUser_UID)+' AND '+
      '((JUser_Deleted_b<>'+DBC.saDBMSBoolScrub(true)+') OR (JUser_Deleted_b IS NOT NULL))';
    bOK:=rs.Open(saQry, DBC,201503161180);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209271120, 'Trouble with query.','Query: '+saQry,SOURCEFILE,DBC,rs);
    end;
  end;

  if bOk then
  begin
    bOk:=rs.eol=FALSE;
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209271121, 'Zero rows returned - missing user record.','Query: '+saQry,SOURCEFILE);
    end;
  end;

  if bOk then
  begin
    saJPersonUID:=rs.fields.Get_saValue('JUser_JPerson_ID');
  end;
  rs.close;

  if bOk then
  begin
    saQry:='SELECT JPers_NameFirst, JPers_NameLast FROM jperson WHERE '+
      'JPers_JPerson_UID='+DBC.saDBMSScrub(saJPersonUID)+' AND '+
      '((JPers_Deleted_b<>'+DBC.saDBMSBoolScrub(true)+') OR (JPers_Deleted_b IS NOT NULL))';
    bOK:=rs.Open(saQry, DBC,201503161181);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209271122, 'Trouble with query.','Query: '+saQry,SOURCEFILE,DBC,rs);
    end;
  end;

  if bOk then
  begin
    bOk:=rs.eol=FALSE;
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209271123, 'Zero rows returned - missing person record.','',SOURCEFILE);
    end;
  end;

  if bOk then
  begin
    saJPersonName:=rs.fields.Get_saValue('JPers_NameFirst')+' '+rs.fields.Get_saValue('JPers_NameLast');
  end;
  rs.close;

  if bOk then
  begin
    saLink:=saFileToTreeDos(p_saUID+'E',4,5)+saFilename;
    saLink2:='http://streamegg.vrooster.com/'+saLink;
    saLink:=grJASConfig.saServerURL+'/download/'+saLink;
    saMsg+=
      '<h3>'+saJPersonName+' has shared this video with you!</h3><br /><br />'+csCRLF+
      'Here is a Download Link: <a href="'+saLink+'">'+saLink+'</a><br /><br />'+csCRLF+
      'Here is the Streaming Link: <a href="'+saLink2+'">'+saLink2+'</a><br /><br />'+csCRLF+
      'If the links above do not work, copy and paste the URLs below into your browser:<br /><br />'+csCRLF+csCRLF+
      saLink+'<br /><br />'+csCRLF+csCRLF+
      saLink2+'<br /><br />'+csCRLF+csCRLF;
    bOk:=bJAS_Sendmail(p_Context,garJVHostLight[p_Context.i4VHost].sSystemEmailFromAddress,saEmail,grJASConfig.saServerName + ' '+saJPersonName+' has shared a video with you.',saMsg);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201209271119, 'Unable to Send Share Video Email','',SOURCEFILE);
    end;
  end;

  rs.destroy;
  result:=bOk;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201209271118,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================










//=============================================================================
{}
function bEmail_DataExportComplete(p_Context: TCONTEXT; p_saUID: ansistring): boolean;
//=============================================================================
var
  bOk: boolean;
  rJTask: rtJTask;
  rJFile: rtJFile;
  saMsg: ansistring;
  rJUser: rtJUser;
  rJPerson: rtJPerson;
  DBC: JADO_CONNECTION;
  saURLTask: ansistring;
  saURLFile: ansistring;

{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bEmail_DataExportComplete'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201210232013,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201210232014, sTHIS_ROUTINE_NAME);{$ENDIF}

  DBC:=p_Context.VHDBC;

  clear_JFile(rJFile);
  rJFile.JFile_JFile_UID:=p_saUID;
  bOk:=bJAS_Load_Jfile(p_Context,DBC,rJFile,false);
  if not bOk then
  begin
    JAS_LOG(p_Context, cnLog_Error, 201210141406, 'Unable to load JFile Record','UID: '+p_saUID,SOURCEFILE);
  end;

  if bOk then
  begin
    rJTask.JTask_JTask_UID:=rJFile.JFile_Row_ID;
    bOk:=bJAS_Load_JTask(p_Context, DBC, rJTask, true);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201210141407, 'Unable to load JTask Record','UID: '+rJFile.JFile_Row_ID,SOURCEFILE);
    end;
  end;

  if bok then
  begin
    clear_JUser(rJUser);
    rJUser.JUser_JUser_UID:=u8Val(rJTask.JTask_Owner_JUser_ID);
    bOk:=bJas_Load_JUser(p_Context, DBC, rJUser,false);
    if not bOk then
    begin
      p_Context.u8ErrNo:=201210141409;
      p_Context.saErrMsg:='bEmail_DataExportComplete - trouble loading JUser record.';
      JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
    end;
  end;

  if bok then
  begin
    clear_JPerson(rJPerson);
    rJPerson.JPers_JPerson_UID:=InttoStr(rJUser.JUser_JPerson_ID);
    bOk:=bJas_Load_JPerson(p_Context, DBC, rJPerson,false);
    if not bOk then
    begin
      p_Context.u8ErrNo:=201210141410;
      p_Context.saErrMsg:='bEmail_DataExportComplete - trouble loading JPerson record.';
      JAS_Log(p_Context,cnLog_ERROR, p_Context.u8ErrNo, p_Context.saErrMsg, '', SOURCEFILE);
    end;
  end;

  saMsg:='';
  if bOk then
  begin
    saURLTask:=grJASConfig.saServerURL+p_Context.saAlias+'?UID&#61;'+rJTask.JTask_JTask_UID+'&amp;screen&#61;jtask+Data';
    saURLFile:=grJASConfig.saServerURL+p_Context.saAlias+'?UID&#61;'+rJFile.JFile_JFile_UID+'&amp;Action&#61;filedownload'; //&#102;&#105;&#108;&#101;download';

    saMsg+='<h2>Your Data export is complete.</h2>'+
      '<p><strong><a href="'+saURLFile+'" target="_blank">Download your exported file.</a></strong></p>'+
      '<br />'+
      '<p><strong><a href="'+saURLTask+'" target="_blank">Export Information</a></strong></p>'+
      '<br /><br />'+
      '<p>Some email clients might not render the above links correctly rendering them unusable by you. '+
      ' Below we have both links in plain text so you can copy them into your browsers address bar and '+
      ' hopefully access them like that.</p><br />'+csCRLF+csCRLF+
      ' Download Link:   '+saURLFile+'<br /></p>'+csCRLF+csCRLF+
      ' Export Info: '+saURLTask+'<br />'+csCRLF+csCRLF;
    bOk:=bJAS_Sendmail(p_Context,garJVHostLight[p_Context.i4VHost].sSystemEmailFromAddress,
      rJPerson.JPers_Work_Email,'JAS Export Complete: '+rJTask.JTask_Name,saMsg);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201210232019, 'Unable to Send Email from JobQ. File ID: '+p_saUID,'',SOURCEFILE);
    end;
  end;

  result:=bOk;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201203102746,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
//=============================================================================






















//=============================================================================
{}
// This Allows Sending email to current user using the Work Email Address
// using content you specify.
function bEmail_Generic(
  p_Context: TCONTEXT;
  p_saSubject: ansistring;
  p_saMessage: ansistring
): boolean;
//=============================================================================
var
  bOk: boolean;
  saMsg: ansistring;
  rJUser: rtJUser;
  rJPerson: rtJPerson;
  DBC: JADO_CONNECTION;

{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME: String; {$ENDIF}
Begin
{$IFDEF ROUTINENAMES}  sTHIS_ROUTINE_NAME:='bEmail_Generic'; {$ENDIF}

{$IFDEF DEBUGLOGBEGINEND}
  DebugIn(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBIN(201211241128,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
{$IFDEF TRACKTHREAD}p_Context.JThread.TrackThread(201211241129, sTHIS_ROUTINE_NAME);{$ENDIF}

  DBC:=p_Context.VHDBC;
  bOk:=true;
  if bok then
  begin
    clear_JUser(rJUser);
    rJUser.JUser_JUser_UID:=p_Context.rJUser.JUser_JUser_UID;
    bOk:=bJas_Load_JUser(p_Context, DBC, rJUser,false);
    if not bOk then
    begin
      JAS_Log(p_Context,cnLog_ERROR, 201211241130, 'bEmail_Generic - trouble loading JUser record.', '', SOURCEFILE);
    end;
  end;

  if bok then
  begin
    clear_JPerson(rJPerson);
    rJPerson.JPers_JPerson_UID:=InttoStr(rJUser.JUser_JPerson_ID);
    bOk:=bJas_Load_JPerson(p_Context, DBC, rJPerson,false);
    if not bOk then
    begin
      JAS_Log(p_Context,cnLog_ERROR, 201211241131, 'bEmail_Generic - trouble loading JPerson record.', '', SOURCEFILE);
    end;
  end;

  saMsg:='';
  if bOk then
  begin
    saMsg+=p_saMessage;
    bOk:=bJAS_Sendmail(p_Context,garJVHostLight[p_Context.i4VHost].sSystemEmailFromAddress,
      rJPerson.JPers_Work_Email,p_saSubject,saMsg);
    if not bOk then
    begin
      JAS_LOG(p_Context, cnLog_Error, 201211241132, 'bEmail_Generic - Unable to Send Email','',SOURCEFILE);
    end;
  end;

  result:=bOk;

{$IFDEF DEBUGLOGBEGINEND}
  DebugOUT(sTHIS_ROUTINE_NAME,SourceFile);
{$ENDIF}
{$IFDEF DEBUGTHREADBEGINEND}p_Context.JThread.DBOUT(201211241133,sTHIS_ROUTINE_NAME,SOURCEFILE);{$ENDIF}
end;
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
