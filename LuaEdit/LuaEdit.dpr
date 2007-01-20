////////////////////////////////////////////////////////////////
// IMPORTANT NOTICE:
//  Do not include ShareMem unit in the project. Faulting to
//  such thing would cause an EInvalidPointer error when
//  LuaEdit will close.
////////////////////////////////////////////////////////////////

program LuaEdit;

uses
  Forms,
  Dialogs,
  SysUtils,
  Classes,
  IniFiles,
  Windows,
  Messages,
  JvDockControlForm,
  JvComponent,
  JvDockVIDStyle,
  JvDockVSNetStyle,
  JvAppRegistryStorage,
  About in 'About.pas' {frmAbout},
  GoToLine in 'GoToLine.pas' {frmGotoLine},
  Main in 'Main.pas' {frmLuaEditMain},
  ProjectTree in 'ProjectTree.pas' {frmProjectTree},
  Replace in 'Replace.pas' {frmReplace},
  ReplaceQuerry in 'ReplaceQuerry.pas' {frmReplaceQuerry},
  Search in 'Search.pas' {frmSearch},
  Stack in 'Stack.pas' {frmStack},
  Splash in 'Splash.pas' {frmSplash},
  Watch in 'Watch.pas' {frmWatch},
  FunctionList in 'FunctionList.pas' {frmFunctionList},
  AddToPrj in 'AddToPrj.pas' {frmAddToPrj},
  ErrorLookup in 'ErrorLookup.pas' {frmErrorLookup},
  LuaStack in 'LuaStack.pas' {frmLuaStack},
  PrintSetup in 'PrintSetup.pas' {frmPrintSetup},
  PrjSettings in 'PrjSettings.pas' {frmPrjOptions},
  Contributors in 'Contributors.pas' {frmContributors},
  LuaUtils in 'LuaCore\LuaUtils.pas',
  Breakpoints in 'Breakpoints.pas' {frmBreakpoints},
  RegSetFileType in 'RegSetFileType.pas',
  LuaLocals in 'LuaLocals.pas' {frmLuaLocals},
  LuaEditMessages in 'LuaEditMessages.pas' {frmLuaEditMessages},
  AddBreakpoint in 'AddBreakpoint.pas' {frmAddBreakpoint},
  LuaGlobals in 'LuaGlobals.pas' {frmLuaGlobals},
  EditorSettings in 'EditorSettings.pas' {frmEditorSettings},
  ExSaveExit in 'ExSaveExit.pas' {frmExSaveExit},
  AsciiTable in 'AsciiTable.pas' {frmAsciiTable},
  ReadOnlyMsgBox in 'ReadOnlyMsgBox.pas' {frmReadOnlyMsgBox},
  Rings in 'Rings.pas' {frmRings},
  SearchPath in 'SearchPath.pas' {frmSearchPath},
  InternalBrowser in 'InternalBrowser.pas' {frmInternalBrowser},
  FindInFiles in 'FindInFiles.pas' {frmFindInFiles},
  SIFReport in 'SIFReport.pas' {frmSIFReport},
  FindWindow1 in 'FindWindow1.pas' {frmFindWindow1},
  FindWindow2 in 'FindWindow2.pas' {frmFindWindow2},
  Misc in 'Misc.pas',
  UploadFiles in 'UploadFiles.pas' {frmUploadFiles},
  Profiler in 'Profiler.pas' {frmProfiler},
  PrecisionTimer in 'PrecisionTimer.pas',
  ComponentList in 'ComponentList.pas' {frmComponentList},
  GUID in 'GUID.pas' {frmGUID},
  LEMacros in 'LEMacros.pas',
  MacroManager in 'MacroManager.pas' {frmMacroManager},
  GUIInspector in 'GUIInspector.pas' {frmGUIInspector},
  GUIDesigner in 'GUIDesigner.pas' {GUIForm1},
  GUIControls in 'GUIControls.pas' {frmGUIControls},
  GUIFormType in 'GUIFormType.pas' {frmGUIFormType},
  ConvertPath in 'ConvertPath.pas' {frmConvertPath},
  LuaConsole in 'LuaConsole.pas' {frmLuaConsole};

{$R *.res}

function GetRunningProcesses(): PChar; cdecl; external 'LuaEditSys.dll';

var
  i, x: Integer;
  hChild, hParent: HWND;
  FileName: String;
  pFiles: TStringList;
  copyDataStruct: TCopyDataStruct;

  // This function look for another instance of LuaEdit
  function CheckAppInstance(): Boolean;
  var
    pProcesses: TStringList;
    i, AppCount: Integer;
  begin
    AppCount := 0;
    pProcesses := TStringList.Create;
    pProcesses.Text := GetRunningProcesses();

    for i := 0 to pProcesses.Count - 1 do
    begin
      if pProcesses.Strings[i] = 'LuaEdit.exe' then
        Inc(AppCount);
    end;

    Result := (AppCount > 1);
    pProcesses.Free;
  end;

begin
  // Insure only one single instance of the application
  // If another instance is detected, we send the command line to it
  if CheckAppInstance() then
  begin
    copyDataStruct.dwData := Integer(cdtAnsiString);
    copyDataStruct.cbData := Length(CmdLine) + 1; // +1 NULL
    copyDataStruct.lpData := CmdLine;


    hChild := FindWindow('TfrmLuaEditMain',nil);
    
    if hChild <> 0 then
    begin
      hParent := GetWindowLong(hChild, GWL_HWNDPARENT);
      
      if hParent <> 0 then
      begin
        SendMessage(hParent, WM_SYSCOMMAND, SC_RESTORE, 0);
        SetForegroundWindow(hParent);
      end;

      SetForegroundWindow(hChild);
      SendMessage(hChild, WM_COPYDATA, Application.Handle, Integer(@copyDataStruct));
    end;

    Halt(1);
  end;

  Application.Initialize;
  Application.Title := 'LuaEdit';
  Application.HelpFile := 'C:\Prog\Delphi\LuaEditor\Bin\Help\LuaEdit.chm';

  Application.CreateForm(TfrmLuaEditMain, frmLuaEditMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmGotoLine, frmGotoLine);
  Application.CreateForm(TfrmReplace, frmReplace);
  Application.CreateForm(TfrmReplaceQuerry, frmReplaceQuerry);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.CreateForm(TfrmAddToPrj, frmAddToPrj);
  Application.CreateForm(TfrmErrorLookup, frmErrorLookup);
  Application.CreateForm(TfrmPrintSetup, frmPrintSetup);
  Application.CreateForm(TfrmPrjOptions, frmPrjOptions);
  Application.CreateForm(TfrmContributors, frmContributors);
  Application.CreateForm(TfrmAddBreakpoint, frmAddBreakpoint);
  Application.CreateForm(TfrmEditorSettings, frmEditorSettings);
  Application.CreateForm(TfrmAsciiTable, frmAsciiTable);
  Application.CreateForm(TfrmFindInFiles, frmFindInFiles);
  Application.CreateForm(TfrmSIFReport, frmSIFReport);
  Application.CreateForm(TfrmComponentList, frmComponentList);
  Application.CreateForm(TfrmGUID, frmGUID);
  Application.CreateForm(TfrmMacroManager, frmMacroManager);
  Application.CreateForm(TfrmConvertPath, frmConvertPath);
  frmLuaEditMain.CheckButtons;

  // show splash screen...
  frmSplash := TfrmSplash.Create(Application);
  frmSplash.Show;
  frmSplash.Update;

  for i := 0 to 3 do
  begin
    Application.ProcessMessages;
    Sleep(1000);
  end;

  frmSplash.Close;
  frmSplash.Free;

  LoadDockTreeFromFile(ExtractFilePath(Application.ExeName) + 'LuaEdit.dck');

  // Backward compatibility with the ini file (versions < 3.0)
  if FileExistsAbs(GetLuaEditInstallPath()+'\LuaEdit.ini') then
  begin
    frmLuaEditMain.LoadEditorSettingsFromReg;
    frmLuaEditMain.LoadEditorSettingsFromIni;
  end
  else
    frmLuaEditMain.LoadEditorSettingsFromReg;

  if ParamCount() > 0 then
  begin
    pFiles := TStringList.Create;

    for x := 1 to ParamCount() do
    begin
      FileName := ParamStr(x);

      if FileExistsAbs(FileName) then
      begin
        pFiles.Add(FileName);
        frmLuaEditMain.DoOpenFileExecute(pFiles);
      end;
    end;
    
    // Rebuild the project tree and initialize stuff
    frmProjectTree.BuildProjectTree;
    frmLuaEditMain.CheckButtons;
    pFiles.Free;
  end;

  Application.Run;
end.
