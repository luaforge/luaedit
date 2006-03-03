unit Misc;

interface

uses
  Registry, SysUtils, SynEdit, SynEditTypes, SynEditMiscClasses, Graphics,
  SynCompletionProposal, Variants, Classes, Windows, Messages, Lua, LuaLib,
  LauxLib, LuaUtils, IniFiles, Forms, Dialogs, Controls, WinSock;

const
  otLuaProject  = 1;
  otLuaUnit     = 2;

  LUA_DBGSTEPOVER = 1;
  LUA_DBGSTEPINTO = 2;
  LUA_DBGSTOP     = 3;
  LUA_DBGPLAY     = 4;
  LUA_DBGPAUSE    = 5;

  HIGHLIGHT_STACK = 0;
  HIGHLIGHT_ERROR = 1;
  HIGHLIGHT_BREAKLINE = 2;

  BKPT_DISABLED = 0;
  BKPT_ENABLED  = 1;

  SIF_ACTPROJECT = 0;
  SIF_OPENED = 1;
  SIF_DIRECTORY = 2;

  JVPAGE_RING_FILES       = 0;
  JVPAGE_RING_CLIPBOARD   = 1;
  JVPAGE_RING_BRWHISTORY  = 2;

  HOOK_MASK    = LUA_MASKCALL or LUA_MASKRET or LUA_MASKLINE;
  PRINT_SIZE   = 2048;
  ArgIdent     = 'arg';

type
  //////////////////////////////////////////////////////////////////////////////
  // Miscellaneous forwards and definitions
  //////////////////////////////////////////////////////////////////////////////

  ELuaEditException = class(Exception);
  ESocketException = class(Exception);

  TInitializer = function(L: PLua_State): Integer; stdcall;
  PTInitializer = ^TInitializer;

  TLuaProject = class;

  //////////////////////////////////////////////////////////////////////////////
  // Remote debugging function templates (for "plugin" oriented logic)
  //////////////////////////////////////////////////////////////////////////////

  TInitiateServer = function(var S: TSocket; var SCom: TSocket; Port: Integer; TimeOut: Integer): Boolean; stdcall;
  PTInitiateServer = ^TInitiateServer;

  TInitiateClient = function(var S: TSocket; RemoteIP: PChar; Port: Integer; UploadDir: PChar; TimeOut: Integer): Boolean; stdcall;
  PTInitiateClient = ^TInitiateClient;

  TGetLocalIP = function(): PChar; stdcall;
  PTGetLocalIP = ^TGetLocalIP;

  TSocketCreate = function(IsClient: Boolean; ErrorMessage: PChar): TSocket; stdcall;
  PTSocketCreate = ^TSocketCreate;

  TSocketConnect = function(S: TSocket; RemotePort: Integer; RemoteIP, ErrorMessage: PChar; Silent: Boolean = False): Boolean; stdcall;
  PTSocketConnect = ^TSocketConnect;

  TSocketDisconnect = function(S: TSocket; ErrorMessage: PChar): Boolean; stdcall;
  PTSocketDisconnect = ^TSocketDisconnect;

  TSocketSend = function(S: TSocket; var Buf; Len, Flags: Integer; ErrorMessage: PChar): Boolean; stdcall;
  PTSocketSend = ^TSocketSend;

  TSocketReceive = function(S: TSocket; var Buf; Flags: Integer; ErrorMessage: PChar): Boolean; stdcall;
  PTSocketReceive = ^TSocketReceive;

  TSendFile = function(S: TSocket; LocalPath, RemotePath, ErrMsg: PChar): Boolean; stdcall;
  PTSendFile = ^TSendFile;

  TReceiveFile = function(S: TSocket; ErrMsg: PChar): Boolean; stdcall;
  PTReceiveFile = ^TReceiveFile;

  TSendDebugInfos = function(S: TSocket; L: PLua_State; AR: Plua_Debug; ErrMsg: PChar): Boolean; stdcall;
  PTSendDebugInfos = ^TSendDebugInfos;

  TReceiveDebugInfos = function(S: TSocket; var L: PLua_State; var AR: Plua_Debug; var Locals, Globals: PChar; ErrMsg: PChar): Boolean; stdcall;
  PTReceiveDebugInfos = ^TReceiveDebugInfos;

  TSendIsBreakpointAtLineRemote = function(S: TSocket; Line: Integer; ErrMsg: PChar): Boolean; stdcall;
  PTSendIsBreakpointAtLineRemote = ^TSendIsBreakpointAtLineRemote;

  TReceiveIsBreakpointAtLineLocal = function(S: TSocket; var Line: Integer; ErrMsg: PChar): Boolean; stdcall;
  PTReceiveIsBreakpointAtLineLocal = ^TReceiveIsBreakpointAtLineLocal;

  TSendIsBreakpointAtLineLocal = function(S: TSocket; Line, HitCount: Integer; Condition, ErrMsg: PChar): Boolean; stdcall;
  PTSendIsBreakpointAtLineLocal = ^TSendIsBreakpointAtLineLocal;

  TReceiveIsBreakpointAtLineRemote = function(S: TSocket; var Line: Integer; var HitCount; var Condition: PChar; ErrMsg: PChar): Boolean; stdcall;
  PTReceiveIsBreakpointAtLineRemote = ^TReceiveIsBreakpointAtLineRemote;

  //////////////////////////////////////////////////////////////////////////////
  // Miscellaneous class
  //////////////////////////////////////////////////////////////////////////////

  {Implementation of TRegistry but featuring default values for Read* functions}
  TAdvanceRegistry = class(TRegistry)
  public
    function ReadCurrency(const Name: String; Default: Currency): Currency; overload;
    function ReadBinaryData(const Name: String; var Buffer; BufSize: Integer; Default: Integer): Integer; overload;
    function ReadBool(const Name: String; Default: Boolean): Boolean; overload;
    function ReadDate(const Name: String; Default: TDateTime): TDateTime; overload;
    function ReadDateTime(const Name: String; Default: TDateTime): TDateTime; overload;
    function ReadFloat(const Name: String; Default: Double): Double; overload;
    function ReadInteger(const Name: String; Default: Integer): Integer; overload;
    function ReadString(const Name: String; Default: String): String; overload;
    function ReadTime(const Name: String; Default: TDateTime): TDateTime; overload;
  end;

  TEditorColors = class(TObject)
    IsItalic: Boolean;
    IsBold: Boolean;
    IsUnderline: Boolean;
    Foreground: String;
    Background: String;
  private
    constructor Create;
  end;

  TFctInfo = class(TObject)
    FctDef:   String;
    Params:   String;
    Line:     Integer;
  public
    constructor Create;
  end;

  TBreakInfo = class(TObject)
    FileName: String;
    Call:     String;
    LineOut:  String;   // Line number to display
    Line:     Integer;  // Actual line definition in script
  public
    constructor Create;
  end;

  TDebugSupportPlugin = class(TSynEditPlugin)
  protected
    procedure PaintDebugGlyphs(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
    procedure AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: integer); override;
    procedure LinesInserted(FirstLine, Count: integer); override;
    procedure LinesDeleted(FirstLine, Count: integer); override;
  end;

  TBreakpoint = class
    iHitCount:    Integer;
    iLine:        Integer;
    iStatus:      Integer;
    sCondition:   String;
  public
    constructor Create;
  end;

  TLineDebugInfos = class
    lstBreakpoint: TList;
    iLineError: Integer;
    iCurrentLineDebug: Integer;
    iStackMarker: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    function IsBreakPointLine(iLine: Integer): Boolean;
    function GetBreakpointStatus(iLine: Integer): Integer;
    procedure AddBreakpointAtLine(iLine: Integer);
    procedure EnableDisableBreakpointAtLine(iLine: Integer);
    function GetBreakpointAtLine(iLine: Integer): TBreakpoint;
    procedure RemoveBreakpointAtLine(iLine: Integer);
    function GetLineCondition(iLine: Integer): String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  // Editor's class
  //////////////////////////////////////////////////////////////////////////////

  {Base class for all major file classes}
  {TLuaFile = class

  end;}

  {Class containing informations and functions about lua script files}
  TLuaUnit = class
    sName:            String;
    sUnitPath:        String;
    LastTimeModified: TDateTime;
    IsReadOnly:       Boolean;
    IsNew:            Boolean;
    HasChanged:       Boolean;
    IsLoaded:         Boolean;
    synUnit:          TSynEdit;
    LastEditedLine:   Integer;
    PrevLineNumber:   Integer;
    pPrjOwner:        TLuaProject;
    lstFunctions:     TStringList;
    synCompletion:    TSynCompletionProposal;
    synParams:        TSynCompletionProposal;
    pDebugPlugin:     TDebugSupportPlugin;
    pDebugInfos:      TLineDebugInfos;
  public
    constructor Create(sPath: String);
    destructor  Destroy; override;

    function SaveUnit(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
    function SaveUnitInc(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
    procedure SaveBreakpoints();
    procedure GetBreakpoints();
  end;

  {Class containing informations and functions about project files}
  TLuaProject = class
    sPrjName:           String;
    sPrjPath:           String;
    sInitializer:       String;
    sRemoteIP:          String;
    sRemoteDirectory:   String;
    sRuntimeDirectory:  String;
    sTargetLuaUnit:     String;
    LastTimeModified:   TDateTime;
    IsReadOnly:         Boolean;
    IsNew:              Boolean;
    HasChanged:         Boolean;
    AutoIncRevNumber:   Boolean;
    iVersionMajor:      Integer;
    iVersionMinor:      Integer;
    iVersionRelease:    Integer;
    iVersionRevision:   Integer;
    iRemotePort:        Integer;
    iConnectTimeOut:    Integer;
    lstUnits:           TList;
    pTargetLuaUnit:     TLuaUnit;
  public
    constructor Create(sPath: String);
    destructor  Destroy; override;

    procedure GetProjectFromDisk(sPath: String);
    function SaveProject(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
    function SaveProjectInc(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
    procedure RealoadProject();
  end;
  
implementation

uses
  Main, Breakpoints, ReadOnlyMsgBox, ProjectTree;

///////////////////////////////////////////////////////////////////
// TAdvanceRegistry class
///////////////////////////////////////////////////////////////////
function TAdvanceRegistry.ReadCurrency(const Name: String; Default: Currency): Currency;
begin
  try
    Result := ReadCurrency(Name);
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadBinaryData(const Name: String; var Buffer; BufSize: Integer; Default: Integer): Integer;
begin
  try
    Result := ReadBinaryData(Name, Buffer, BufSize);
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadBool(const Name: String; Default: Boolean): Boolean;
begin
  try
    Result := ReadBool(Name);
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadDate(const Name: String; Default: TDateTime): TDateTime;
begin
  try
    Result := ReadDate(Name);
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadDateTime(const Name: String; Default: TDateTime): TDateTime;
begin
  try
    Result := ReadDateTime(Name);
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadFloat(const Name: String; Default: Double): Double;
begin
  try
    Result := ReadFloat(Name);
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadInteger(const Name: String; Default: Integer): Integer;
begin
  try
    Result := ReadInteger(Name);
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadString(const Name: String; Default: String): String;
begin
  try
    Result := ReadString(Name);
    
    if Result = '' then
      Result := Default;
  except
    Result := Default;
  end;
end;

function TAdvanceRegistry.ReadTime(const Name: String; Default: TDateTime): TDateTime;
begin
  try
    Result := ReadTime(Name);
  except
    Result := Default;
  end;
end;

///////////////////////////////////////////////////////////////////
// TEditorColors class
///////////////////////////////////////////////////////////////////
constructor TEditorColors.Create;
begin
  IsItalic := False;
  IsBold := False;
  IsUnderline := False;
  Foreground := 'clBlack';
  Background := 'clBlack';
end;

///////////////////////////////////////////////////////////////////
//TFctInfo
///////////////////////////////////////////////////////////////////
constructor TFctInfo.Create;
begin
  FctDef := '';
  Params := '';
  Line := -1;
end;

///////////////////////////////////////////////////////////////////
//TBreakInfo
///////////////////////////////////////////////////////////////////
constructor TBreakInfo.Create;
begin
  FileName := '';
  Call := '';
  LineOut := '';
  Line := -1;
end;

///////////////////////////////////////////////////////////////////
//TBreakpoint class
///////////////////////////////////////////////////////////////////
constructor TBreakpoint.Create;
begin
  iHitCount := 0;
  iLine := -1;
  iStatus := BKPT_ENABLED;
  sCondition := '';
end;

///////////////////////////////////////////////////////////////////
//TLineDebugInfos class
///////////////////////////////////////////////////////////////////
constructor TLineDebugInfos.Create;
begin
  lstBreakpoint := TList.Create;
  iLineError := -1;
  iStackMarker := -1;
  iCurrentLineDebug := -1;
end;

destructor TLineDebugInfos.Destroy;
var
  x: Integer;
begin
  for x := 0 to lstBreakpoint.Count - 1 do
  begin
    lstBreakpoint.Delete(x);
  end;

  lstBreakpoint.Free;
end;

function TLineDebugInfos.IsBreakPointLine(iLine: Integer): Boolean;
var
  x: Integer;
begin
  Result := False;
  for x := 0 to lstBreakpoint.Count - 1 do
  begin
    if iLine = TBreakpoint(lstBreakpoint.Items[x]).iLine then
    begin
      Result := True;
      break;
    end;
  end;
end;

function TLineDebugInfos.GetBreakpointStatus(iLine: Integer): Integer;
var
  x: Integer;
begin
  Result := -1;
  for x := 0 to lstBreakpoint.Count - 1 do
  begin
    if iLine = TBreakpoint(lstBreakpoint.Items[x]).iLine then
    begin
      Result := TBreakpoint(lstBreakpoint.Items[x]).iStatus;
      break;
    end;
  end;
end;

function TLineDebugInfos.GetBreakpointAtLine(iLine: Integer): TBreakpoint;
var
  x: Integer;
begin
  Result := nil;

  for x := 0 to lstBreakpoint.Count - 1 do
  begin
    if iLine = TBreakpoint(lstBreakpoint.Items[x]).iLine then
    begin
      Result := TBreakpoint(lstBreakpoint.Items[x]);
      break;
    end;
  end;
end;

procedure TLineDebugInfos.AddBreakpointAtLine(iLine: Integer);
var
  pNewBreakpoint: TBreakpoint;
begin
  pNewBreakpoint := TBreakpoint.Create;
  pNewBreakpoint.iLine := iLine;
  lstBreakpoint.Add(pNewBreakpoint);
end;

procedure TLineDebugInfos.EnableDisableBreakpointAtLine(iLine: Integer);
var
  x: Integer;
begin
  for x := 0 to lstBreakpoint.Count - 1 do
  begin
    if TBreakpoint(lstBreakpoint.Items[x]).iLine = iLine then
    begin
      if TBreakpoint(lstBreakpoint.Items[x]).iStatus = BKPT_ENABLED then
        TBreakpoint(lstBreakpoint.Items[x]).iStatus := BKPT_DISABLED
      else
        TBreakpoint(lstBreakpoint.Items[x]).iStatus := BKPT_ENABLED;

      Break;
    end;
  end;
end;

procedure TLineDebugInfos.RemoveBreakpointAtLine(iLine: Integer);
var
  x: Integer;
begin
  for x := 0 to lstBreakpoint.Count - 1 do
  begin
    if TBreakpoint(lstBreakpoint.Items[x]).iLine = iLine then
    begin
      lstBreakpoint.Delete(x);
      Break;
    end;
  end;
end;

function TLineDebugInfos.GetLineCondition(iLine: Integer): String;
var
  x: Integer;
begin
  for x := 0 to lstBreakpoint.Count - 1 do
  begin
    if TBreakpoint(lstBreakpoint.Items[x]).iLine = iLine then
    begin
      Result := TrimLeft(TBreakpoint(lstBreakpoint.Items[x]).sCondition);
      Break;
    end;
  end;
end;

///////////////////////////////////////////////////////////////////
//TDebugSupportPlugin class
///////////////////////////////////////////////////////////////////
procedure TDebugSupportPlugin.AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: integer);
begin
  PaintDebugGlyphs(ACanvas, AClip, FirstLine, LastLine);
end;

procedure TDebugSupportPlugin.PaintDebugGlyphs(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
var
  LH, X, Y: integer;
  ImgIndex: integer;
  pLuaUnit: TLuaUnit;
begin
  pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  FirstLine := pLuaUnit.synUnit.RowToLine(FirstLine);
  LastLine := pLuaUnit.synUnit.RowToLine(LastLine);
  X := 1;
  LH := pLuaUnit.synUnit.LineHeight;
  while FirstLine <= LastLine do
  begin
    ImgIndex := -1;
    Y := (LH - frmMain.imlActions.Height) div 2 + LH * (pLuaUnit.synUnit.LineToRow(FirstLine) - pLuaUnit.synUnit.TopLine);

    if pLuaUnit.pDebugInfos.IsBreakPointLine(FirstLine) then
    begin
      if pLuaUnit.pDebugInfos.GetBreakpointStatus(FirstLine) = BKPT_ENABLED then
        ImgIndex := 27
      else
        ImgIndex := 28;
    end;

    if TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug = FirstLine then
      ImgIndex := 29;

    if ((pLuaUnit.pDebugInfos.IsBreakPointLine(FirstLine)) and (TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug = FirstLine)) then
    begin
      if pLuaUnit.pDebugInfos.GetBreakpointStatus(FirstLine) = BKPT_ENABLED then
        ImgIndex := 30
      else
        ImgIndex := 43;
    end;

    if ImgIndex > 0 then
      frmMain.imlActions.Draw(ACanvas, X, Y, ImgIndex);

    Inc(FirstLine);
  end;
end;

procedure TDebugSupportPlugin.LinesInserted(FirstLine, Count: integer);
var
  pLuaUnit: TLuaUnit;
  x: Integer;
begin
  pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  for x := 0 to pLuaUnit.pDebugInfos.lstBreakpoint.Count - 1 do
  begin
    if TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[x]).iLine >= FirstLine then
    begin
      TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[x]).iLine := TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[x]).iLine + Count;
    end;
  end;

  pLuaUnit.synUnit.Refresh;
  frmBreakpoints.RefreshBreakpointList;
end;

procedure TDebugSupportPlugin.LinesDeleted(FirstLine, Count: integer);
var
  pLuaUnit: TLuaUnit;
  x: Integer;
begin
  pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  for x := 0 to pLuaUnit.pDebugInfos.lstBreakpoint.Count - 1 do
  begin
    if TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[x]).iLine >= FirstLine then
    begin
      TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[x]).iLine := TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[x]).iLine - Count; 
    end;
  end;

  pLuaUnit.synUnit.Refresh;
  frmBreakpoints.RefreshBreakpointList;
end;

///////////////////////////////////////////////////////////////////
//TLuaProject class
///////////////////////////////////////////////////////////////////
constructor TLuaProject.Create(sPath: String);
begin
  lstUnits := TList.Create;
  iVersionMajor := 1;
  iVersionMinor := 0;
  iVersionRelease := 0;
  iVersionRevision := 0;
  AutoIncRevNumber := False;
  iRemotePort := 1024;
  sRemoteIP := '0.0.0.0';
  sRemoteDirectory := '';

  // Get Last Time accessed and readonly state
  if sPath <> '' then
  begin
    LastTimeModified := GetFileLastTimeModified(PChar(sPath));
    IsReadOnly := GetFileReadOnlyAttr(PChar(sPath));
  end
  else
  begin
    LastTimeModified := Now;
    IsReadOnly := False;
  end;
end;

destructor TLuaProject.Destroy;
begin
  lstUnits.Free;
end;

procedure TLuaProject.GetProjectFromDisk(sPath: String);
var
  x: Integer;
  pLuaUnit: TLuaUnit;
  fFile: TIniFile;
  lstTmpFiles: TStringList;
  sUnitName: String;
begin
  fFile := TIniFile.Create(sPath);
  lstTmpFiles := TStringList.Create;

  // Read the [Description] section
  sPrjName := fFile.ReadString('Description', 'Name', 'LuaProject');
  iVersionMajor := fFile.ReadInteger('Description', 'VersionMajor', 1);
  iVersionMinor := fFile.ReadInteger('Description', 'VersionMinor', 0);
  iVersionRelease := fFile.ReadInteger('Description', 'VersionRelease', 0);
  iVersionRevision := fFile.ReadInteger('Description', 'VersionRevision', 0);
  AutoIncRevNumber := fFile.ReadBool('Description', 'AutoIncRevNumber', False);

  // Read the [Options] section
  // None for now...

  // Read the [Debug] section
  sInitializer := fFile.ReadString('Debug', 'Initializer', '');
  sRemoteIP := fFile.ReadString('Debug', 'RemoteIP', '0.0.0.0');
  sRemoteDirectory := fFile.ReadString('Debug', 'RemoteDirectory', '');
  iRemotePort := fFile.ReadInteger('Debug', 'RemotePort', 1024);
  iConnectTimeOut := fFile.ReadInteger('Debug', 'ConnectTimeOut', 10);
  sRuntimeDirectory := fFile.ReadString('Debug', 'RuntimeDirectory', 'C:\');
  sTargetLuaUnit := fFile.ReadString('Debug', 'TargetLuaUnit', '[Current Unit]');
  pTargetLuaUnit := nil; // Will be filled later 

  // Initialize project variables and global variables
  sPrjPath := sPath;
  IsNew := False;
  HasChanged := False;
  LuaProjects.Add(Self);
  ActiveProject := Self;
  frmMain.MonitorFileToRecent(sPrjPath);

  // Read [Files] section
  fFile.ReadSection('Files', lstTmpFiles);

  if lstTmpFiles.Count > 0 then
  begin
    // Open each individual
    for x := 0 to lstTmpFiles.Count - 1 do
    begin
      sUnitName :=  ExpandUNCFileName(ExtractFilePath(sPrjPath) + fFile.ReadString('Files', lstTmpFiles.Strings[x], ''));

      if FileExists(sUnitName) then
      begin
        // Initialize unit and global variables considering the fact that open was a success
        pLuaUnit := frmMain.AddFileInProject(sUnitName, False, Self);
        pLuaUnit.sUnitPath := sUnitName;
        pLuaUnit.sName := ExtractFileName(sUnitName);
        pLuaUnit.IsLoaded := True;

        // Add first loaded file in the tabs
        if x = 0 then
          frmMain.AddFileInTab(pLuaUnit);
      end
      else
      begin
        // Initialize unit and global variables considering the fact that open was a failure
        Application.MessageBox(PChar('The file "'+sUnitName+'" is innexistant!'), 'LuaEdit', MB_OK+MB_ICONERROR);
        pLuaUnit := frmMain.AddFileInProject(sUnitName, False, Self);
        pLuaUnit.IsLoaded := False;
      end;

      if pLuaUnit.sName = sTargetLuaUnit then
        pTargetLuaUnit := pLuaUnit;
    end;
  end;

  fFile.Free;
  lstTmpFiles.Free;
end;

function TLuaProject.SaveProjectInc(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  pFile: TIniFile;
  x, xPos, IncValue, iAnswer, TempIncValue: integer;
  bResult: Boolean;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmMain.jvchnNotifier.Active := False;
  Result := True;

  // Popup a open dialog according to parameters and the state of the file
  if ((IsNew and not bNoDialog) or (bForceDialog)) then
  begin
    frmMain.sdlgSaveAsPrj.FileName := sPrjName + '.lpr';
    
    if frmMain.sdlgSaveAsPrj.Execute then
    begin
      sPath := frmMain.sdlgSaveAsPrj.FileName;
    end
    else
    begin
      // Return false because action was cancel and quit function
      Result := False;
      Exit;
    end;
  end;

  // Getting currently assigned number
  IncValue := -1;  // For future testing
  xPos := Length(ExtractFileExt(sPath)) + 1;  // Assign initial try position
  bResult := True;  // For a first try
  while bResult do
  begin
    bResult := TryStrToInt(Copy(sPath, Length(sPath) - xPos + 1, xPos - Length(ExtractFileExt(sPath))), TempIncValue);
    if bResult then
    begin
      IncValue := TempIncValue;
      Inc(XPos);
    end;
  end;

  if IncValue = -1 then
    IncValue := 1 // Give an initial value
  else
    Inc(IncValue);  // Increment actual value

  sPath := Copy(sPath, 1, Length(sPath) - xPos + 1) + IntToStr(IncValue) + ExtractFileExt(sPath);  // Build the new name

  // Check if file is read only first
  while (GetFileReadOnlyAttr(PChar(sPath)) and (FileExists(sPath))) do
  begin
    pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
    iAnswer := pMsgBox.MessageBox('The project '+sPath+' is read-only. Save anyway?      ', 'LuaEdit');
    pMsgBox.Free;
    if iAnswer = mrOk then
    begin
      ToggleFileReadOnlyAttr(PChar(sPath));
      // Now we wrote on the disk we may retrieve the time it has been writen
      LastTimeModified := GetFileLastTimeModified(PChar(sPath));
    end
    else if iAnswer = mrYes then
    begin
      // Popup a open dialog according to parameters and the state of the file
      frmMain.sdlgSaveAsPrj.FileName := sPrjName + '.lpr';

      if frmMain.sdlgSaveAsPrj.Execute then
      begin
        sPath := frmMain.sdlgSaveAsPrj.FileName;

        if IsNew then
          frmMain.MonitorFileToRecent(sPath);
      end
      else
      begin
        // Return false because action was cancel and quit function
        Result := False;
        Exit;
      end;
    end
    else
    begin
      Result := False;
      Exit;
    end;
  end;

  // Erase existing file if any to ensure a new clean project
  // NOTE: IniFiles append stuff to it when they already exists
  if FileExists(sPath) then
    DeleteFile(PChar(sPath));

  pFile := TIniFile.Create(sPath);  // Create project file writer engine (using *.ini files way)

  // Increasing Revision Number if feature is selected
  if AutoIncRevNumber then
    Inc(iVersionRevision);

  // Write data for [Description] section
  pFile.WriteString('Description', 'Name', sPrjName);
  pFile.WriteInteger('Description', 'VersionMajor', iVersionMajor);
  pFile.WriteInteger('Description', 'VersionMinor', iVersionMinor);
  pFile.WriteInteger('Description', 'VersionRelease', iVersionRelease);
  pFile.WriteInteger('Description', 'VersionRevision', iVersionRevision);
  pFile.WriteBool('Description', 'AutoIncRevNumber', AutoIncRevNumber);

  // Write data for [Options] section
  // None for now...

  // Write data for [Debug] section
  pFile.WriteString('Debug', 'Initializer', sInitializer);
  pFile.WriteString('Debug', 'RemoteIP', sRemoteIP);
  pFile.WriteString('Debug', 'RemoteDirectory', sRemoteDirectory);
  pFile.WriteInteger('Debug', 'RemotePort', iRemotePort);
  pFile.WriteInteger('Debug', 'ConnectTimeOut', iConnectTimeOut);
  pFile.WriteString('Debug', 'RuntimeDirectory', sRuntimeDirectory);
  pFile.WriteString('Debug', 'TargetLuaUnit', sTargetLuaUnit);

  // Wrtie data for [Files] section
  for x := 0 to lstUnits.Count - 1 do
  begin
    // Write the file with a relative path
    pFile.WriteString('Files', 'File'+IntToStr(x), ExtractRelativePath(ExtractFilePath(sPrjPath), TLuaUnit(lstUnits.Items[x]).sUnitPath));
  end;

  if sPrjPath <> sPath then
    sPrjPath := sPath;

  // Initialize stuff...   
  IsNew := False;
  HasChanged := False;
  frmProjectTree.BuildProjectTree;
  pFile.UpdateFile;
  pFile.Free;
  frmMain.BuildReopenMenu;

  // Now we wrote on the disk we may retrieve the time it has been writen
  LastTimeModified := GetFileLastTimeModified(PChar(sPath));
  frmMain.jvchnNotifier.Active := True;
end;

function TLuaProject.SaveProject(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  pFile: TIniFile;
  x, iAnswer: integer;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmMain.jvchnNotifier.Active := False;
  Result := True;

  // Popup an open dialog according to parameters and the state of the file
  if ((IsNew and not bNoDialog) or (bForceDialog)) then
  begin
    frmMain.sdlgSaveAsPrj.FileName := sPrjName + '.lpr';

    if frmMain.sdlgSaveAsPrj.Execute then
    begin
      sPath := frmMain.sdlgSaveAsPrj.FileName;

      if IsNew then
        frmMain.MonitorFileToRecent(sPath);
    end
    else
    begin
      // Return false because action was cancel and quit function
      Result := False;
      Exit;
    end;
  end;

  // Check if file is read only first
  while (GetFileReadOnlyAttr(PChar(sPath)) and (FileExists(sPath))) do
  begin
    pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
    iAnswer := pMsgBox.MessageBox('The project '+sPath+' is read-only. Save anyway?      ', 'LuaEdit');
    pMsgBox.Free;
    if iAnswer = mrOk then
    begin
      ToggleFileReadOnlyAttr(PChar(sPath));
      // Now we wrote on the disk we may retrieve the time it has been writen
      LastTimeModified := GetFileLastTimeModified(PChar(sPath));
    end
    else if iAnswer = mrYes then
    begin
      // Popup a open dialog according to parameters and the state of the file
      frmMain.sdlgSaveAsPrj.FileName := sPrjName + '.lpr';

      if frmMain.sdlgSaveAsPrj.Execute then
      begin
        sPath := frmMain.sdlgSaveAsPrj.FileName;
      end
      else
      begin
        // Return false because action was cancel and quit function
        Result := False;
        Exit;
      end;
    end
    else
    begin
      Result := False;
      Exit;
    end;
  end;

  // Erase existing file if any to ensure a new clean project
  // NOTE: IniFiles append datas when they already exists
  if FileExists(sPath) then
    DeleteFile(PChar(sPath));

  if sPrjPath <> sPath then
    sPrjPath := sPath;

  pFile := TIniFile.Create(sPath);  // Create project file writer engine (using *.ini files way)

  // Increasing Revision Number if feature is selected
  if AutoIncRevNumber then
    Inc(iVersionRevision);

  // Write data for [Description] section
  pFile.WriteString('Description', 'Name', sPrjName);
  pFile.WriteInteger('Description', 'VersionMajor', iVersionMajor);
  pFile.WriteInteger('Description', 'VersionMinor', iVersionMinor);
  pFile.WriteInteger('Description', 'VersionRelease', iVersionRelease);
  pFile.WriteInteger('Description', 'VersionRevision', iVersionRevision);
  pFile.WriteBool('Description', 'AutoIncRevNumber', AutoIncRevNumber);

  // Write data for [Options] section
  // None for now...

  // Write data for [Debug] section
  pFile.WriteString('Debug', 'Initializer', sInitializer);
  pFile.WriteString('Debug', 'RemoteIP', sRemoteIP);
  pFile.WriteString('Debug', 'RemoteDirectory', sRemoteDirectory);
  pFile.WriteInteger('Debug', 'RemotePort', iRemotePort);
  pFile.WriteInteger('Debug', 'ConnectTimeOut', iConnectTimeOut);
  pFile.WriteString('Debug', 'RuntimeDirectory', sRuntimeDirectory);
  pFile.WriteString('Debug', 'TargetLuaUnit', sTargetLuaUnit);

  // Wrtie data for [Files] section  
  for x := 0 to lstUnits.Count - 1 do
    // Write the file with a relative path
    pFile.WriteString('Files', 'File'+IntToStr(x), ExtractRelativePath(ExtractFilePath(sPrjPath), TLuaUnit(lstUnits.Items[x]).sUnitPath));

  // Initialize stuff...   
  IsNew := False;
  HasChanged := False;
  frmProjectTree.BuildProjectTree;
  frmMain.BuildReopenMenu;
  pFile.UpdateFile;
  pFile.Free;

  // Now we wrote on the disk we may retrieve the time it has been writen
  LastTimeModified := GetFileLastTimeModified(PChar(sPath));
  frmMain.jvchnNotifier.Active := True;
end;

procedure TLuaProject.RealoadProject();
var
  x: Integer;
  pLuaUnit: TLuaUnit;
begin
  // remove files from project
  for x := lstUnits.Count - 1 downto 0 do
  begin
    pLuaUnit := TLuaUnit(lstUnits.Items[x]);

    // Prompt user to save file if modified or new
    if pLuaUnit.HasChanged or pLuaUnit.IsNew then
    begin
      if Application.MessageBox(PChar('Save changes to file '+pLuaUnit.sUnitPath+'?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
      begin
        if SaveUnitsInc then
          pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
        else
          pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
      end;
    end;

    // Remove file from tabs
    if Assigned(frmMain.GetAssociatedTab(pLuaUnit)) then
    begin
      frmMain.jvUnitBar.Tabs.Delete(frmMain.GetAssociatedTab(pLuaUnit).Index);
      LuaOpenedUnits.Remove(pLuaUnit);
    end;

    pLuaUnit.pPrjOwner.lstUnits.Remove(pLuaUnit);
  end;

  // Remove projects from current project list
  LuaProjects.Remove(Self);
  // Reload the project...
  GetProjectFromDisk(sPrjPath);
end;

///////////////////////////////////////////////////////////////////
//TLuaUnit class
///////////////////////////////////////////////////////////////////
constructor TLuaUnit.Create(sPath: String);
begin
  pDebugInfos := TLineDebugInfos.Create;
  lstFunctions := TStringList.Create;

  // Get Last Time accessed and readonly state
  if ((sPath <> '') and FileExists(sPath)) then
  begin
    LastTimeModified := GetFileLastTimeModified(PChar(sPath));
    IsReadOnly := GetFileReadOnlyAttr(PChar(sPath));
  end
  else
  begin
    LastTimeModified := Now;
    IsReadOnly := False;
  end;
end;

destructor TLuaUnit.Destroy;
begin
  synCompletion.Free;
  synParams.Free;
  pDebugPlugin.Free;
  pDebugInfos.Free;
  lstFunctions.Free;
  synUnit.Free;
end;

function TLuaUnit.SaveUnitInc(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  xPos, IncValue, iAnswer, TempIncValue: Integer;
  bResult: Boolean;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmMain.jvchnNotifier.Active := False;
  Result := True;

  // save only if the file is opened in the tab...
  // if not, there is no way that the file was modified so no needs to save
  if Assigned(frmMain.GetAssociatedTab(Self)) then
  begin
    // Popup a open dialog according to parameters and the state of the file
    if ((IsNew and not bNoDialog) or (bForceDialog)) then
    begin
      frmMain.sdlgSaveAsUnit.FileName := ExtractFileName(sName);

      if frmMain.sdlgSaveAsUnit.Execute then
      begin
        sPath := frmMain.sdlgSaveAsUnit.FileName;

        if IsNew then
          frmMain.MonitorFileToRecent(sPath);
      end
      else
      begin
        // Return false because action was cancel and quit function
        Result := False;
        Exit;
      end;
    end;

    // Getting currently assigned number
    IncValue := -1;  // For future testing
    xPos := Length(ExtractFileExt(sPath)) + 1;  // Assign initial try position
    bResult := True;  // For a first try
    while bResult do
    begin
      bResult := TryStrToInt(Copy(sPath, Length(sPath) - xPos + 1, xPos - Length(ExtractFileExt(sPath))), TempIncValue);
      if bResult then
      begin
        IncValue := TempIncValue;
        Inc(XPos);
      end;
    end;

    if IncValue = -1 then
      IncValue := 1 // Give an initial value
    else
      Inc(IncValue);  // Increment actual value

    // Build the new name
    sPath := Copy(sPath, 1, Length(sPath) - xPos + 1) + IntToStr(IncValue) + ExtractFileExt(sPath);

    // Check if file is read only first
    while (GetFileReadOnlyAttr(PChar(sPath)) and (FileExists(sPath))) do
    begin
      pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
      iAnswer := pMsgBox.MessageBox('The project '+sPath+' is read-only. Save anyway?      ', 'LuaEdit');
      pMsgBox.Free;
      if iAnswer = mrOk then
      begin
        ToggleFileReadOnlyAttr(PChar(sPath));
        // Now we wrote on the disk we may retrieve the time it has been writen
        LastTimeModified := GetFileLastTimeModified(PChar(sPath));
      end
      else if iAnswer = mrYes then
      begin
        // Popup a open dialog according to parameters and the state of the file
        frmMain.sdlgSaveAsUnit.FileName := ExtractFileName(sName);

        if frmMain.sdlgSaveAsUnit.Execute then
        begin
          sPath := frmMain.sdlgSaveAsUnit.FileName;
        end
        else
        begin
          // Return false because action was cancel and quit function
          Result := False;
          Exit;
        end;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end;

    sUnitPath := sPath;
    pPrjOwner.HasChanged := True;  // Since the name has changed, the project must be saved
    synUnit.Lines.SaveToFile(sUnitPath);  // Save to file to hard drive
    sName := ExtractFileName(sUnitPath);  // Get short name for fast display
    IsNew := False;  // The file is no more new
    HasChanged := False;  // The has no more changes
    synUnit.Modified := False;  // The actual editor must not notice any changes now
    pDebugInfos.iLineError := -1;  // Do not display anymore the current line error
    LastTimeModified := GetFileLastTimeModified(PChar(sPath));  // Now we wrote on the disk we may retrieve the time it has been writen

    // Save breakpoints if feature is enabled
    if Main.SaveBreakpoints then
      SaveBreakpoints();

    // Reinitialize stuff...
    frmMain.RefreshOpenedUnits;
    frmProjectTree.BuildProjectTree;
    frmMain.BuildReopenMenu;
    frmMain.stbMain.Panels[5].Text := '';
    frmMain.stbMain.Refresh;
    synUnit.Refresh;
  end;

  frmMain.jvchnNotifier.Active := True;
end;

function TLuaUnit.SaveUnit(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  iAnswer: Integer;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmMain.jvchnNotifier.Active := False;
  Result := True;

  // save only if the file is opened in the tab...
  // if not, there is no way that the file was modified so no needs to save
  if Assigned(frmMain.GetAssociatedTab(Self)) then
  begin
    // Popup a open dialog according to parameters and the state of the file
    if ((IsNew and not bNoDialog) or (bForceDialog)) then
    begin
      frmMain.sdlgSaveAsUnit.FileName := ExtractFileName(sName);

      if frmMain.sdlgSaveAsUnit.Execute then
      begin
        sPath := frmMain.sdlgSaveAsUnit.FileName;
        pPrjOwner.HasChanged := True;

        if IsNew then
          frmMain.MonitorFileToRecent(sPath);
      end
      else
      begin
        // Return false because action was cancel and quit function
        Result := False;
        Exit;
      end;
    end;

    // Check if file is read only first
    while (GetFileReadOnlyAttr(PChar(sPath)) and (FileExists(sPath))) do
    begin
      pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
      iAnswer := pMsgBox.MessageBox('The project '+sPath+' is read-only. Save anyway?      ', 'LuaEdit');
      pMsgBox.Free;
      if iAnswer = mrOk then
      begin
        ToggleFileReadOnlyAttr(PChar(sPath));
        // Now we wrote on the disk we may retrieve the time it has been writen
        LastTimeModified := GetFileLastTimeModified(PChar(sPath));
      end
      else if iAnswer = mrYes then
      begin
        // Popup a open dialog according to parameters and the state of the file
        frmMain.sdlgSaveAsUnit.FileName := ExtractFileName(sName);

        if frmMain.sdlgSaveAsUnit.Execute then
        begin
          sPath := frmMain.sdlgSaveAsUnit.FileName;
          pPrjOwner.HasChanged := True;
        end
        else
        begin
          // Return false because action was cancel and quit function
          Result := False;
          Exit;
        end;
      end
      else
      begin
        Result := False;
        Exit;
      end;
    end;

    synUnit.Lines.SaveToFile(sPath);  // Save the file to hard drive
    sName := ExtractFileName(sPath);  // Get short name for fast display
    sUnitPath := sPath;  // Assign filepath to class filepath
    IsNew := False;  // The file is not new anymore
    HasChanged := False;  // The file does't have anymore changes
    synUnit.Modified := False;  // The actual editor must not notice any changes now
    pDebugInfos.iLineError := -1;  // Do not display anymore the current line error
    LastTimeModified := GetFileLastTimeModified(PChar(sPath));  // Now we wrote on the disk we may retrieve the time it has been writen

    // Save breakpoints if feature is enabled
    if Main.SaveBreakpoints then
      SaveBreakpoints();

    // Initialize stuff...
    frmMain.RefreshOpenedUnits;
    frmProjectTree.BuildProjectTree;
    frmMain.BuildReopenMenu;
    frmMain.stbMain.Panels[5].Text := '';
    frmMain.stbMain.Refresh;
    synUnit.Refresh;
  end;

  frmMain.jvchnNotifier.Active := True;
end;

procedure TLuaUnit.SaveBreakpoints();
var
  x, iBreakpointInc: Integer;
  sSectionName: String;
  pBreakpointFile: TIniFile;
  pBreakpoint: TBreakpoint;
begin
  // Only if at least on breakpoint is present
  if pDebugInfos.lstBreakpoint.Count > 0 then
  begin
    // Erase existing file if any to ensure a new clean breakpoint file
    // NOTE: IniFiles append datas when they already exists
    if FileExists(ChangeFileExt(sUnitPath, '.lbf')) then
      DeleteFile(PChar(ChangeFileExt(sUnitPath, '.lbf')));

    // Create the ini file engine and the file on the hard drive
    pBreakpointFile := TIniFile.Create(ChangeFileExt(sUnitPath, '.lbf'));

    // Initialize stuff...
    iBreakpointInc := 0;

    // Go through all breakpoints and save them in the file
    for x := 0 to pDebugInfos.lstBreakpoint.Count - 1 do
    begin
      pBreakpoint := TBreakpoint(pDebugInfos.lstBreakpoint[x]);  // Assign list object pointer to local pointer for easier usage

      Inc(iBreakpointInc);  // Increase local incrementer number for unique section name
      sSectionName := 'Breakpoint' + IntToStr(iBreakpointInc);  // Build unique section name

      // Write datas
      pBreakpointFile.WriteInteger(sSectionName, 'Line', pBreakpoint.iLine);
      pBreakpointFile.WriteInteger(sSectionName, 'Status', pBreakpoint.iStatus);
      pBreakpointFile.WriteString(sSectionName, 'Condition', pBreakpoint.sCondition);
    end;

    // Commit data in the file and free local pointer
    pBreakpointFile.UpdateFile;
    pBreakpointFile.Free;
  end;
end;

procedure TLuaUnit.GetBreakpoints();
var
  x: Integer;
  lstSections: TStringList;
  pBreakpointFile: TIniFile;
  pBreakpoint: TBreakpoint;
begin
  // Only if a .lbf file with the same name as the .lua file is existing
  if FileExists(ChangeFileExt(sUnitPath, '.lbf')) then
  begin
    lstSections := TStringList.Create;  // Create the section list
    pBreakpointFile := TIniFile.Create(ChangeFileExt(sUnitPath, '.lbf'));  // Create the ini file engine and the file on the hard drive

    // Read all sections name
    pBreakpointFile.ReadSections(lstSections);

    // Empty actual list of breakpoints if any
    for x := pDebugInfos.lstBreakpoint.Count - 1 downto 0 do
    begin
      pBreakpoint := TBreakpoint(pDebugInfos.lstBreakpoint[x]);
      pDebugInfos.lstBreakpoint.Delete(x);
      pBreakpoint.Free;
    end;

    // Go through all section (one section = one breakpoint)
    for x := 0 to lstSections.Count - 1 do
    begin
      // Create new object
      pBreakpoint := TBreakpoint.Create;

      // Read data from file and assign it to new object
      pBreakpoint.iLine := pBreakpointFile.ReadInteger(lstSections.Strings[x], 'Line', 1);
      pBreakpoint.iStatus := pBreakpointFile.ReadInteger(lstSections.Strings[x], 'Status', BKPT_ENABLED);
      pBreakpoint.sCondition := pBreakpointFile.ReadString(lstSections.Strings[x], 'Condition', '');

      // Add breakpoint object to unit breakpoint list
      pDebugInfos.lstBreakpoint.Add(pBreakpoint);
    end;

    // Free local pointers and refresh associated synedit
    lstSections.Free;
    pBreakpointFile.Free;
    if Assigned(synUnit) then
      synUnit.Refresh;
  end;
end;

end.
