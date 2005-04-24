program LuaEdit;

uses
  Forms,
  Dialogs,
  SysUtils,
  Classes,
  IniFiles,
  Windows,
  JvDockControlForm,
  JvComponent,
  JvDockVIDStyle,
  JvDockVSNetStyle,
  JvAppRegistryStorage,
  About in 'About.pas' {frmAbout},
  GoToLine in 'GoToLine.pas' {frmGotoLine},
  Main in 'Main.pas' {frmMain},
  ProjectTree in 'ProjectTree.pas' {frmProjectTree},
  Replace in 'Replace.pas' {frmReplace},
  ReplaceQuerry in 'ReplaceQuerry.pas' {frmReplaceQuerry},
  Search in 'Search.pas' {frmSearch},
  Stack in 'Stack.pas' {frmStack},
  Splash in 'Splash.pas' {frmSplash},
  Watch in 'Watch.pas' {frmWatch},
  FunctionList in 'FunctionList.pas' {frmFunctionList},
  AddToPrj in 'AddToPrj.pas' {frmAddToPrj},
  RemFromPrj in 'RemFromPrj.pas' {frmRemoveFile},
  ErrorLookup in 'ErrorLookup.pas' {frmErrorLookup},
  LuaStack in 'LuaStack.pas' {frmLuaStack},
  PrintSetup in 'PrintSetup.pas' {frmPrintSetup},
  PrjSettings in 'PrjSettings.pas' {frmPrjOptions},
  CntString in 'CntString.pas' {frmCntString},
  Connecting in 'Connecting.pas' {frmConnecting},
  Contributors in 'Contributors.pas' {frmContributors},
  LuaOutput in 'LuaOutput.pas' {frmLuaOutput},
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
  Rings in 'Rings.pas' {frmRings};

{$R *.res}

var
  i, x: Integer;
  FileName: String;
  pNewPrj: TLuaProject;
  pLuaUnit: TLuaUnit;

begin
  Application.Initialize;
  Application.Title := 'LuaEdit';
  Application.HelpFile := 'C:\Prog\Delphi\LuaEditor\Bin\Help\LuaEdit.chm';

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
  frmMain.CheckButtons;

  // show splash screen...
  frmSplash := TfrmSplash.Create(Application);
  frmSplash.Show;
  frmSplash.Update;

  for i := 0 to 2 do
  begin
    Application.ProcessMessages;
    Sleep(1000);
  end;

  frmSplash.Close;
  frmSplash.Free;

  LoadDockTreeFromFile(ExtractFilePath(Application.ExeName) + 'LuaEdit.dck');

  if ParamCount > 0 then
  begin
    for x := 1 to ParamCount do
    begin
      FileName := ParamStr(x);

      if FileExists(FileName) then
      begin
        if ExtractFileExt(FileName) = '.lua' then
        begin
          if not frmMain.FileIsInTree(FileName) then
          begin
            pLuaUnit := frmMain.AddFileInProject(FileName, False, LuaSingleUnits);
            pLuaUnit.IsLoaded := True;
            frmMain.AddFileInTab(pLuaUnit);
            frmMain.MonitorFile(FileName);
          end;
        end
        else if ExtractFileExt(FileName) = '.lpr' then
        begin
          if not frmMain.IsProjectOpened(FileName) then
          begin
            pNewPrj := TLuaProject.Create(FileName);
            pNewPrj.GetProjectFromDisk(FileName);
          end;
        end;
      end;
    end;
    
    // Rebuild the project tree and initialize stuff
    frmProjectTree.BuildProjectTree;
    frmMain.CheckButtons;
  end;

  Application.Run;
end.
