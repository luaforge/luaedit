unit FunctionList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvListBox, JvDotNetControls, ShellAPI,
  JvComponent, JvDockControlForm, ComCtrls, JvExComCtrls, JvListView,
  ImgList, ToolWin, Misc;

type
  TfrmFunctionList = class(TForm)
    JvDockClient1: TJvDockClient;
    lvwFunctions: TJvDotNetListView;
    tblFunctionList: TToolBar;
    tbtnRefresh: TToolButton;
    imlFunctionList: TImageList;
    ToolButton1: TToolButton;
    tbtnGotoDef: TToolButton;
    procedure lvwFunctionsDblClick(Sender: TObject);
    procedure tbtnRefreshClick(Sender: TObject);
    procedure tbtnGotoDefClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshList(sFileName: String);
  end;

var
  frmFunctionList: TfrmFunctionList;

implementation

uses Main;

{$R *.dfm}

procedure TfrmFunctionList.RefreshList(sFileName: String);
var
  CTagAppPath, TagFile, CTagParams: String;
  sTag: String;
  cmdLine: String;
  x: Integer;
  lstTags: TStringList;
  pFctInfo: TFctInfo;
  pItem: TListItem;
  si: TStartupInfo;
  pi: TProcessInformation;
begin
  // Create temp directory if required
  if not DirectoryExists(TempFolder) then
    CreateDir(TempFolder);

  // Free previously created TFctInfo objects...
  for x := 0 to lvwFunctions.Items.Count - 1 do
    TFctInfo(lvwFunctions.Items[x].Data).Free;

  lstTags := TStringList.Create;
  lvwFunctions.Items.Clear;
  lvwFunctions.Items.BeginUpdate;
                                   
  // Build executable and its parameters strings
  CTagAppPath := '"' + GetLuaEditInstallPath() + '\ctags.exe"';
  TagFile := TempFolder + '\' + ExtractFileName(ChangeFileExt(sFileName, '.tag'));
  CTagParams := '"-f' + TagFile + '" "--fields=+n+S+K" "' + sFileName + '"';

  // Initialize createprocess variables for call
  FillChar(si, sizeof(si), 0);
  si.cb := sizeof(si);
  cmdLine := CTagAppPath + ' ' + CTagParams;

  // get the tags from the source
  CreateProcess(nil, PChar(cmdLine), nil, nil, True, CREATE_NO_WINDOW, nil, nil, si, pi);

  // Wait until the process is done
  WaitForSingleObject(pi.hProcess, INFINITE);

  // Closing handles
  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);

  // Read the created tag file
  lstTags.LoadFromFile(TagFile);

  // searching for tags
  for x := 0 to lstTags.Count - 1 do
  begin
    sTag := lstTags.Strings[x];

    // make sure this line is not a comment
    if Pos('!_', sTag) <> 1 then
    begin
      pFctInfo := TFctInfo.Create;

      // Get the definition
      pFctInfo.FctDef := StringReplace(Copy(sTag, Pos('/^', sTag) + 2, Pos('$/;"', sTag) - Pos('/^', sTag) - 2), 'function ', '', [rfReplaceAll, rfIgnoreCase]);
      // Get the function's parameters
      pFctInfo.Params := Copy(pFctInfo.FctDef, Pos('(', pFctInfo.FctDef) + 1, Length(pFctInfo.FctDef) - 1 - Pos('(', pFctInfo.FctDef));
      // Get the line definition
      pFctInfo.Line := StrToInt(Copy(sTag, Pos('line:', sTag) + 5, Length(sTag) - Pos('line:', sTag) - 4));

      // Add function definition in list
      pItem := lvwFunctions.Items.Add;
      pItem.Caption := pFctInfo.FctDef;
      pItem.Data := pFctInfo;
      pItem.SubItems.Add(IntToStr(pFctInfo.Line));
    end;
  end;

  lvwFunctions.Items.EndUpdate;
  lstTags.Free;
end;

procedure TfrmFunctionList.lvwFunctionsDblClick(Sender: TObject);
begin
  tbtnGotoDef.Click;
end;

procedure TfrmFunctionList.tbtnRefreshClick(Sender: TObject);
begin
  if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
  begin
    if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab.Data) then
    begin
      RefreshList(TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).Path);
    end;
  end;
end;

procedure TfrmFunctionList.tbtnGotoDefClick(Sender: TObject);
begin
  if Assigned(lvwFunctions.Selected) then
    frmLuaEditMain.PopUpUnitToScreen(TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).Path, TFctInfo(lvwFunctions.Selected.Data).Line, False, HIGHLIGHT_STACK)
end;

end.
