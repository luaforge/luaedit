library LuaEditDebug;

uses
  SysUtils,
  Classes,
  Windows,
  Controls,
  Forms,
  lua,
  LuaUtils,
  RTDebug,
  About in '..\About.pas' {frmAbout},
  GoToLine in '..\GoToLine.pas' {frmGotoLine},
  Main in '..\Main.pas' {frmMain},
  ProjectTree in '..\ProjectTree.pas' {frmProjectTree},
  Replace in '..\Replace.pas' {frmReplace},
  ReplaceQuerry in '..\ReplaceQuerry.pas' {frmReplaceQuerry},
  Search in '..\Search.pas' {frmSearch},
  Stack in '..\Stack.pas' {frmStack},
  Splash in '..\Splash.pas' {frmSplash},
  Watch in '..\Watch.pas' {frmWatch},
  FunctionList in '..\FunctionList.pas' {frmFunctionList},
  AddToPrj in '..\AddToPrj.pas' {frmAddToPrj},
  RemFromPrj in '..\RemFromPrj.pas' {frmRemoveFile},
  ErrorLookup in '..\ErrorLookup.pas' {frmErrorLookup},
  LuaStack in '..\LuaStack.pas' {frmLuaStack},
  PrintSetup in '..\PrintSetup.pas' {frmPrintSetup},
  PrjSettings in '..\PrjSettings.pas' {frmPrjOptions},
  CntString in '..\CntString.pas' {frmCntString},
  Connecting in '..\Connecting.pas' {frmConnecting},
  Contributors in '..\Contributors.pas' {frmContributors},
  LuaOutput in '..\LuaOutput.pas' {frmLuaOutput},
  Breakpoints in '..\Breakpoints.pas' {frmBreakpoints},
  RegSetFileType in '..\RegSetFileType.pas',
  LuaLocals in '..\LuaLocals.pas' {frmLuaLocals},
  LuaEditMessages in '..\LuaEditMessages.pas' {frmLuaEditMessages},
  AddBreakpoint in '..\AddBreakpoint.pas' {frmAddBreakpoint},
  LuaGlobals in '..\LuaGlobals.pas' {frmLuaGlobals},
  EditorSettings in '..\EditorSettings.pas' {frmEditorSettings},
  ExSaveExit in '..\ExSaveExit.pas' {frmExSaveExit},
  AsciiTable in '..\AsciiTable.pas' {frmAsciiTable},
  ReadOnlyMsgBox in '..\ReadOnlyMsgBox.pas' {frmReadOnlyMsgBox},
  Rings in '..\Rings.pas' {frmRings};

{$R *.res}

function InitForms :TfrmMain;
begin
  RTAssert(0, true, 'LuaEditDebug Application='+IntToHex(Integer(Application), 8), '', 0);
  RTAssert(0, true, 'Creating...', '', 0);
  
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmGotoLine, frmGotoLine);
  Application.CreateForm(TfrmReplace, frmReplace);
  Application.CreateForm(TfrmReplaceQuerry, frmReplaceQuerry);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.CreateForm(TfrmAddToPrj, frmAddToPrj);
  Application.CreateForm(TfrmRemoveFile, frmRemoveFile);
  Application.CreateForm(TfrmErrorLookup, frmErrorLookup);
  Application.CreateForm(TfrmPrintSetup, frmPrintSetup);
  Application.CreateForm(TfrmPrjOptions, frmPrjOptions);
  Application.CreateForm(TfrmCntString, frmCntString);
  Application.CreateForm(TfrmConnecting, frmConnecting);
  Application.CreateForm(TfrmContributors, frmContributors);
  Application.CreateForm(TfrmAddBreakpoint, frmAddBreakpoint);
  Application.CreateForm(TfrmEditorSettings, frmEditorSettings);
  Application.CreateForm(TfrmAsciiTable, frmAsciiTable);
  
  RTAssert(0, true, 'Creating done', '', 0);
  frmMain.CheckButtons;
  frmMain.LoadEditorSettings;
   //LoadDockTreeFromFile(ExtractFilePath(Application.ExeName) + 'LuaEdit.dck');
  Result :=frmMain;
end;

procedure UnInitForms;
Var
   MainFormHandle :HWnd;

begin
try
  frmAbout.Close; frmAbout :=Nil;
  frmGotoLine.Close; frmGotoLine :=Nil;
  frmReplace.Close; frmReplace :=Nil;
  frmReplaceQuerry.Close; frmReplaceQuerry :=Nil;
  frmSearch.Close; frmSearch  :=Nil;
  frmAddToPrj.Close; frmAddToPrj :=Nil;
  frmRemoveFile.Close; frmRemoveFile :=Nil;
  frmErrorLookup.Close; frmErrorLookup :=Nil;
  frmPrintSetup.Close; frmPrintSetup :=Nil;
  frmPrjOptions.Close; frmPrjOptions :=Nil;
  frmCntString.Close; frmCntString :=Nil;
  frmConnecting.Close; frmConnecting :=Nil;
  frmContributors.Close; frmContributors :=Nil;
  frmAddBreakpoint.Close; frmAddBreakpoint :=Nil;
  frmEditorSettings.Close; frmEditorSettings :=Nil;
  frmAsciiTable.Close; frmAsciiTable :=Nil;
RTAssert(0, true, ' frmMain.Close', '', 0);
  MainFormHandle :=frmMain.Handle;
  frmMain.Close;
  repeat
     Sleep(200);
  Until IsWindow(MainFormHandle);
  Sleep(200);
RTAssert(0, true, ' frmMain.Close Done', '', 0);

except

end;
end;


function LuaEditDebugOpen :Plua_State;
begin
     Result :=lua_open;
     //Store in LuaRegistry Only!!!!!
     LuaSetTableLightUserData(Result, LUA_REGISTRYINDEX, 'LuaEditDebug_MainForm',
                              InitForms);
end;

function LuaEditDebugStartFile(LState :Plua_State; Filename :PChar):Integer;
Var
   MainForm :TfrmMain;
   pLuaUnit: TLuaUnit;

begin
   RTAssert(0, true, 'Starting '+Filename, '', 0);
     Result :=LUA_ERRRUN;
     MainForm :=LuaGetTableLightUserData(LState, LUA_REGISTRYINDEX, 'LuaEditDebug_MainForm');
     if (MainForm<>Nil)
     then with MainForm do
          begin

               MainForm.Visible :=True;
               MainForm.Show;
               repeat
                     Sleep(200);
               Until IsWindowVisible(MainForm.Handle);
               Sleep(200);

               RTAssert(0, true, ' AddFileInProject', '', 0);
               pLuaUnit := AddFileInProject(FileName, False, LuaSingleUnits);

               RTAssert(0, true, ' AddFileInTab', '', 0);
               pLuaUnit.IsLoaded := True;
               AddFileInTab(pLuaUnit);
               MonitorFile(FileName);
               RTAssert(0, true, ' CheckButtons', '', 0);
               CheckButtons;
               MainForm.LuaState :=LState;
               ExecuteCurrent(True, 0, '', -1);
         end;
end;

function LuaEditDebugStart(LuaState :Plua_State; Code :PChar):Integer;
Var
   xTempFile     :TFileStream;
   xTempFileName,
   TempPath      :String;

   function UniqueFileName(BasePath :String) :String;
   Var
      loopCounter :Integer;

   begin
     if (BasePath[Length(BasePath)]<>'\')
     then BasePath :=BasePath + '\';
     loopCounter :=30;
     repeat
           sleep(250);
           DateTimeToString(Result, 'yyyy-mm-dd-hh-nn-ss-z', Now);
           Result :=BasePath+Result+'.lua';
           Dec(loopCounter);
     Until not(FileExists(Result)) or (loopCounter=-1);
     if (loopCounter=-1)
     then raise Exception.Create('Cannot Work on '+BasePath);
end;


begin
     try
        SetLength(TempPath, MAX_PATH);
        GetTempPath(MAX_PATH, PChar(TempPath));
        TempPath :=PChar(TempPath); //adjust Length to reflect the new real size

        xTempFilename :=UniqueFileName(TempPath);

        RTAssert(0, true, 'Filling '+xTempFilename, '', 0);

        xTempFile :=TFileStream.Create(xTempFilename, fmCreate);
        xTempFile.Write(Code^, Length(Code^));
        xTempFile.Free;
        Result :=LuaEditDebugStartFile(LuaState, PChar(xTempFileName));
     except
        Result := LUA_ERRRUN;
     end;
end;

procedure LuaEditDebugClose(LuaState :Plua_State);
Var
   MainForm :TfrmMain;

begin
     MainForm :=LuaGetTableLightUserData(LuaState, LUA_REGISTRYINDEX, 'LuaEditDebug_MainForm');
     if (MainForm<>Nil)
     then UnInitForms;

   RTAssert(0, true, 'lua_close', '', 0);
     lua_close(LuaState);
   RTAssert(0, true, 'lua_done', '', 0);
end;

exports
       LuaEditDebugOpen,
       LuaEditDebugStartFile,
       LuaEditDebugStart,
       LuaEditDebugClose;

begin
end.
 
