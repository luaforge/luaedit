////////////////////////////////////////////////////////////////
// IMPORTANT NOTICE:
//  Do not include ShareMem unit in the project. Faulting to
//  such thing would cause an EInvalidPointer error when
//  LuaEdit will close.
////////////////////////////////////////////////////////////////

unit Misc;

interface

uses
  Registry, SysUtils, SynEdit, SynEditTypes, SynEditMiscClasses, Graphics,
  SynCompletionProposal, Variants, Classes, Windows, Messages, Lua, LuaLib,
  LauxLib, LuaUtils, LuaSyntax, IniFiles, Forms, Dialogs, Controls, WinSock,
  StdCtrls, JvTabBar;

const
  LUAEDIT_HINT_MSG    = 1;
  LUAEDIT_WARNING_MSG = 2;
  LUAEDIT_ERROR_MSG   = 3;

  LUA_DBGSTEPOVER = 1;
  LUA_DBGSTEPINTO = 2;
  LUA_DBGSTOP     = 3;
  LUA_DBGPLAY     = 4;
  LUA_DBGPAUSE    = 5;

  HIGHLIGHT_STACK     = 0;
  HIGHLIGHT_ERROR     = 1;
  HIGHLIGHT_BREAKLINE = 2;
  HIGHLIGHT_SELECT    = 3;

  BKPT_DISABLED = 0;
  BKPT_ENABLED  = 1;

  SIF_ACTPROJECT  = 0;
  SIF_OPENED      = 1;
  SIF_DIRECTORY   = 2;

  JVPAGE_RING_FILES       = 0;
  JVPAGE_RING_CLIPBOARD   = 1;
  JVPAGE_RING_BRWHISTORY  = 2;

  RDBG_EMPTY = '@@N\A@@';

  HOOK_MASK     = LUA_MASKCALL or LUA_MASKRET or LUA_MASKLINE;
  PRINT_SIZE    = 16384;
  SUB_TABLE_MAX = 99;
  ArgIdent      = 'arg';

type

  //////////////////////////////////////////////////////////////////////////////
  // Copy data type
  //////////////////////////////////////////////////////////////////////////////
  TCopyDataType = (cdtAnsiString = 0, cdtWideString = 1, cdtBinary = 2);

  //////////////////////////////////////////////////////////////////////////////
  // Miscellaneous forwards and definitions
  //////////////////////////////////////////////////////////////////////////////

  ELuaEditException = class(Exception);
  ESocketException = class(Exception);

  TInitializer = function(L: PLua_State): Integer; stdcall;
  PTInitializer = ^TInitializer;

  TLuaEditProject = class;

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
    destructor  Destroy; override;
    
    function  IsBreakPointLine(iLine: Integer): Boolean;
    function  GetBreakpointStatus(iLine: Integer): Integer;
    procedure AddBreakpointAtLine(iLine: Integer);
    procedure EnableDisableBreakpointAtLine(iLine: Integer);
    function  GetBreakpointAtLine(iLine: Integer): TBreakpoint;
    procedure RemoveBreakpointAtLine(iLine: Integer);
    function  GetLineCondition(iLine: Integer): String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  // Editor's classes
  //////////////////////////////////////////////////////////////////////////////
  {
      ** CLASS DIAGRAM - Indentation is relevant of inheritance **

            TLuaEditFile .................................... Base class
             |
             |-TLuaEditGUIForm............................... GUI form file (linked with a lua file)
             |
             |-TLuaEditBasicTextFile ........................ Basic text file
             |  |
             |  |-TLuaEditDebugFile ......................... Basic text file which is debuggable
             |     |
             |     |-TLuaEditUnit ........................... Lua script file
             |     |
             |     |-TLuaEditMacro .......................... Lua script file used for user customized interface in LuaEdit
             |
             |-TLuaEditProject .............................. Lua project which contains other files
  }

  // Object type enumeration
  TLuaEditFileType = (otTextFile, otLuaEditUnit, otLuaEditProject, otLuaEditMacro, otLuaEditForm);
  TLuaEditDebugFilesTypeSet = set of TLuaEditFileType;
  TLuaEditTextFilesTypeSet = set of TLuaEditFileType;

  {Base class for all major file classes}
  TLuaEditFile = class
    FOTFileType:        TLuaEditFileType;
    FLastTimeModified:  TDateTime;
    FName:              String;
    FPath:              String;
    FIsReadOnly:        Boolean;
    FIsNew:             Boolean;
    FHasChanged:        Boolean;
    FIsLoaded:          Boolean;
    FPrjOwner:          TLuaEditProject;
  public
    constructor Create(Path: String; otType: TLuaEditFileType = otTextFile);
  published
    property FileType: TLuaEditFileType read FOTFileType write FOTFileType;
    property LastTimeModified: TDateTime read FLastTimeModified write FLastTimeModified;
    property Name: String read FName write FName;
    property Path: String read FPath write FPath;
    property IsReadOnly: Boolean read FIsReadOnly write FIsReadOnly;
    property IsNew: Boolean read FIsNew write FIsNew;
    property HasChanged: Boolean read FHasChanged write FHasChanged;
    property IsLoaded: Boolean read FIsLoaded write FIsLoaded;
    property PrjOwner: TLuaEditProject read FPrjOwner write FPrjOwner;
  end;

  // Forward declaration
  TLuaEditDebugFile = class;

  TLuaEditGUIForm = class(TLuaEditFile)
    FGUIDesignerForm: TForm;
    FLinkedDebugFile: TLuaEditDebugFile;
  public
    constructor Create(Path: String; otType: TLuaEditFileType = otLuaEditForm);
    destructor Destroy; override;
  published
    property GUIDesignerForm: TForm read FGUIDesignerForm write FGUIDesignerForm;
    property LinkedDebugFile: TLuaEditDebugFile read FLinkedDebugFile write FLinkedDebugFile;
  end;

  TLuaEditBasicTextFile = class(TLuaEditFile)
    FLastEditedLine:   Integer;
    FSynUnit:          TSynEdit;
    FAssociatedTab:    TJvTabBarItem;
  public
    constructor Create(Path: String; otType: TLuaEditFileType = otTextFile);
    destructor Destroy; override;

    function  SaveUnit(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean; virtual;
    function  SaveUnitInc(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean; virtual;
  published
    property LastEditedLine:   Integer read FLastEditedLine write FLastEditedLine;
    property SynUnit:          TSynEdit read FSynUnit write FSynUnit;
    property AssociatedTab:    TJvTabBarItem read FAssociatedTab write FAssociatedTab;
  end;

  TLuaEditDebugFile = class(TLuaEditBasicTextFile)
    FLinkedGUIForm:    TLuaEditGUIForm;
    FSynCompletion:    TSynCompletionProposal;
    FSynParams:        TSynCompletionProposal;
    FDebugPlugin:      TDebugSupportPlugin;
    FDebugInfos:       TLineDebugInfos;
    FPrevLineNumber:   Integer;
  public
    constructor Create(Path: String; otType: TLuaEditFileType = otTextFile);
    destructor Destroy; override;

    function  SaveUnit(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean; override;
    function  SaveUnitInc(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean; override;
    procedure SaveBreakpoints();
    procedure GetBreakpoints();
  published
    property LinkedGUIForm:   TLuaEditGUIForm read FLinkedGUIForm write FLinkedGUIForm;
    property SynCompletion:   TSynCompletionProposal read FSynCompletion write FSynCompletion;
    property SynParams:       TSynCompletionProposal read FSynParams write FSynParams;
    property DebugPlugin:     TDebugSupportPlugin read FDebugPlugin write FDebugPlugin;
    property DebugInfos:      TLineDebugInfos read FDebugInfos write FDebugInfos;
    property PrevLineNumber:  Integer read FPrevLineNumber write FPrevLineNumber;
  end;

  {Class containing informations and functions about lua script files}
  TLuaEditUnit = class(TLuaEditDebugFile)
    lstFunctions:     TStringList;
  public
    constructor Create(Path: String; otType: TLuaEditFileType = otLuaEditUnit);
    destructor  Destroy; override;
  end;

  {Class containing informations and functions about luaedit macro files}
  TLuaEditMacro = class(TLuaEditDebugFile)
    lstFunctions:     TStringList;
  public
    constructor Create(Path: String; otType: TLuaEditFileType = otLuaEditMacro);
    destructor  Destroy; override;
  end;

  {Class containing informations and functions about lua project files}
  TLuaEditProject = class(TLuaEditFile)
    sInitializer:       String;
    sRemoteIP:          String;
    sRemoteDirectory:   String;
    sRuntimeDirectory:  String;
    sTargetLuaUnit:     String;
    sCompileDirectory:  String;
    sCompileExtension:  String;
    AutoIncRevNumber:   Boolean;
    iVersionMajor:      Integer;
    iVersionMinor:      Integer;
    iVersionRelease:    Integer;
    iVersionRevision:   Integer;
    iRemotePort:        Integer;
    iConnectTimeOut:    Integer;
    lstUnits:           TList;
    pTargetLuaUnit:     TLuaEditUnit;
  public
    constructor Create(Path: String; otType: TLuaEditFileType = otLuaEditProject);
    destructor  Destroy; override;

    procedure GetProjectFromDisk(Path: String);
    function  SaveProject(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
    function  SaveProjectInc(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
    procedure RealoadProject();
  end;

// LuaEditSys.dll functions...
function  GetFileLastTimeModified(const sFileName: PChar): TDateTime; cdecl; external 'LuaEditSys.dll';
function  GetFileReadOnlyAttr(const sFileName: PChar): Boolean; cdecl; external 'LuaEditSys.dll';
function  GetFileSizeStr(Size: Cardinal): PChar; cdecl; external 'LuaEditSys.dll';
function  GetFileVersion(const FileName: PChar): PChar; cdecl; external 'LuaEditSys.dll';
function  GetOSInfo: PChar; cdecl; external 'LuaEditSys.dll';
function  SetPrivilege(sPrivilegeName : PChar; bEnabled : boolean): boolean; cdecl; external 'LuaEditSys.dll';
procedure ToggleFileReadOnlyAttr(const sFileName: PChar); cdecl; external 'LuaEditSys.dll';
function  WinExit(iFlags: integer): Boolean; cdecl; external 'LuaEditSys.dll';
function  BrowseURL(URL: PChar): Boolean; cdecl; external 'LuaEditSys.dll';
  
implementation

uses
  Main, Breakpoints, ReadOnlyMsgBox, ProjectTree, GUIDesigner;

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
// TDebugSupportPlugin class
///////////////////////////////////////////////////////////////////
procedure TDebugSupportPlugin.AfterPaint(ACanvas: TCanvas; const AClip: TRect; FirstLine, LastLine: integer);
begin
  PaintDebugGlyphs(ACanvas, AClip, FirstLine, LastLine);
end;

procedure TDebugSupportPlugin.PaintDebugGlyphs(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
var
  LH, X, Y: integer;
  ImgIndex: integer;
  pLuaUnit: TLuaEditUnit;
begin
  pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

  FirstLine := pLuaUnit.synUnit.RowToLine(FirstLine);
  LastLine := pLuaUnit.synUnit.RowToLine(LastLine);
  X := 1;
  LH := pLuaUnit.synUnit.LineHeight;
  while FirstLine <= LastLine do
  begin
    ImgIndex := -1;
    Y := (LH - frmLuaEditMain.imlActions.Height) div 2 + LH * (pLuaUnit.synUnit.LineToRow(FirstLine) - pLuaUnit.synUnit.TopLine);

    if pLuaUnit.DebugInfos.IsBreakPointLine(FirstLine) then
    begin
      if pLuaUnit.DebugInfos.GetBreakpointStatus(FirstLine) = BKPT_ENABLED then
        ImgIndex := 27
      else
        ImgIndex := 28;
    end;

    if TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.iCurrentLineDebug = FirstLine then
      ImgIndex := 29;

    if ((pLuaUnit.DebugInfos.IsBreakPointLine(FirstLine)) and (TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.iCurrentLineDebug = FirstLine)) then
    begin
      if pLuaUnit.DebugInfos.GetBreakpointStatus(FirstLine) = BKPT_ENABLED then
        ImgIndex := 30
      else
        ImgIndex := 43;
    end;

    if ImgIndex > 0 then
      frmLuaEditMain.imlActions.Draw(ACanvas, X, Y, ImgIndex);

    Inc(FirstLine);
  end;
end;

procedure TDebugSupportPlugin.LinesInserted(FirstLine, Count: integer);
var
  pLuaUnit: TLuaEditUnit;
  x: Integer;
begin
  pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

  for x := 0 to pLuaUnit.DebugInfos.lstBreakpoint.Count - 1 do
  begin
    if TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint.Items[x]).iLine >= FirstLine then
    begin
      TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint.Items[x]).iLine := TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint.Items[x]).iLine + Count;
    end;
  end;

  pLuaUnit.synUnit.Refresh;
  frmBreakpoints.RefreshBreakpointList;
end;

procedure TDebugSupportPlugin.LinesDeleted(FirstLine, Count: integer);
var
  pLuaUnit: TLuaEditUnit;
  x: Integer;
begin
  pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

  for x := 0 to pLuaUnit.DebugInfos.lstBreakpoint.Count - 1 do
  begin
    if TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint.Items[x]).iLine >= FirstLine then
    begin
      TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint.Items[x]).iLine := TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint.Items[x]).iLine - Count;
    end;
  end;

  pLuaUnit.synUnit.Refresh;
  frmBreakpoints.RefreshBreakpointList;
end;

///////////////////////////////////////////////////////////////////
// TLuaEditFile class
///////////////////////////////////////////////////////////////////

constructor TLuaEditFile.Create(Path: String; otType: TLuaEditFileType);
begin
  FOTFileType := otType;
  FPath := Path;

  // Get Last Time accessed and readonly state
  if ((Path <> '') and FileExists(Path)) then
  begin
    FLastTimeModified := GetFileLastTimeModified(PChar(Path));
    FIsReadOnly := GetFileReadOnlyAttr(PChar(Path));
  end
  else
  begin
    FLastTimeModified := Now;
    FIsReadOnly := False;
  end;
end;

///////////////////////////////////////////////////////////////////
// TLuaEditGUIForm class
///////////////////////////////////////////////////////////////////

constructor TLuaEditGUIForm.Create(Path: String; otType: TLuaEditFileType);
begin
  inherited Create(Path, otType);

  FLinkedDebugFile := nil;
  FGUIDesignerForm := TGUIForm1.Create(nil);
  TGUIForm1(FGUIDesignerForm).pLuaEditGUIForm := Self;
end;

destructor TLuaEditGUIForm.Destroy;
begin
  inherited Destroy;

  if Assigned(FGUIDesignerForm) then
    FGUIDesignerForm.Free;
end;

///////////////////////////////////////////////////////////////////
// TLuaEditBasicTextFile class
///////////////////////////////////////////////////////////////////

constructor TLuaEditBasicTextFile.Create(Path: String; otType: TLuaEditFileType);
begin
  inherited Create(Path, otType);

  FLastEditedLine := -1;
  FAssociatedTab := nil;
  FName := ExtractFileName(Path);

  // Set some properties
  FSynUnit := TSynEdit.Create(frmLuaEditMain.pnlMain);
  FSynUnit.Parent := frmLuaEditMain.pnlMain;
  FSynUnit.Visible := False;
  FSynUnit.Align := alClient;
  FSynUnit.MaxScrollWidth := 10000;
  FSynUnit.WantTabs := True;
  FSynUnit.ShowHint := True;
  FSynUnit.PopupMenu := frmLuaEditMain.ppmEditor;
  FSynUnit.BookMarkOptions.LeftMargin := 15;

  // Set event handlers
  FSynUnit.OnChange := frmLuaEditMain.synEditChange;
  FSynUnit.OnScroll := frmLuaEditMain.synEditScroll;
  FSynUnit.OnDblClick := frmLuaEditMain.synEditDblClick;
  FSynUnit.OnMouseMove := frmLuaEditMain.synEditMouseMove;
  FSynUnit.OnMouseCursor := frmLuaEditMain.synEditMouseCursor;
  FSynUnit.OnReplaceText := frmLuaEditMain.SynEditReplaceText;
  FSynUnit.OnKeyUp := frmLuaEditMain.synEditKeyUp;
  FSynUnit.OnClick := frmLuaEditMain.synEditClick;
  FSynUnit.OnSpecialLineColors := frmLuaEditMain.synEditSpecialLineColors;
  FSynUnit.OnGutterClick := frmLuaEditMain.synEditGutterClick;

  // Initialize lua highlighter engine
  if otType in LuaEditDebugFilesTypeSet then
    FSynUnit.Highlighter := TSynLuaSyn.Create(nil);

  // Load content in the synedit control if required
  if ((not IsNew) and FileExists(Path)) then
    SynUnit.Lines.LoadFromFile(Path);
end;

destructor TLuaEditBasicTextFile.Destroy;
begin
  inherited Destroy;

  FSynUnit.Free;
end;

function TLuaEditBasicTextFile.SaveUnitInc(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  xPos, IncValue, iAnswer, TempIncValue: Integer;
  bResult: Boolean;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmLuaEditMain.jvchnNotifier.Active := False;
  Result := True;

  // save only if the file is opened in the tab...
  // if not, there is no way that the file was modified so no needs to save
  if Assigned(Self.AssociatedTab) then
  begin
    // Popup a open dialog according to parameters and the state of the file
    if ((IsNew and not bNoDialog) or (bForceDialog)) then
    begin
      frmLuaEditMain.sdlgSaveAsUnit.FileName := ExtractFileName(FName);

      if ExtractFileExt(FPath) = '.lua' then
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 1
      else if ExtractFileExt(FPath) = '.lmc' then
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 2
      else if ExtractFileExt(FPath) = '.txt' then
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 3
      else
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 4;

      if frmLuaEditMain.sdlgSaveAsUnit.Execute then
      begin
        Path := frmLuaEditMain.sdlgSaveAsUnit.FileName;

        if IsNew then
          frmLuaEditMain.MonitorFileToRecent(Path);
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
    xPos := Length(ExtractFileExt(Path)) + 1;  // Assign initial try position
    bResult := True;  // For a first try
    while bResult do
    begin
      bResult := TryStrToInt(Copy(Path, Length(Path) - xPos + 1, xPos - Length(ExtractFileExt(Path))), TempIncValue);
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
    Path := Copy(Self.Path, 1, Length(Self.Path) - xPos + 1) + IntToStr(IncValue) + ExtractFileExt(Self.Path);

    // Check if file is read only first
    while (GetFileReadOnlyAttr(PChar(Path)) and (FileExists(Path))) do
    begin
      pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
      iAnswer := pMsgBox.MessageBox('The project '+Path+' is read-only. Save anyway?      ', 'LuaEdit');
      pMsgBox.Free;
      if iAnswer = mrOk then
      begin
        ToggleFileReadOnlyAttr(PChar(Path));
        // Now that we wrote on the disk we may retrieve the time it has been writen
        LastTimeModified := GetFileLastTimeModified(PChar(Path));
        IsReadOnly := False;
      end
      else if iAnswer = mrYes then
      begin
        // Popup an open dialog according to parameters and the state of the file
        frmLuaEditMain.sdlgSaveAsUnit.FileName := ExtractFileName(Self.Name);

        if frmLuaEditMain.sdlgSaveAsUnit.Execute then
        begin
          Path := frmLuaEditMain.sdlgSaveAsUnit.FileName;
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

    FPath := Path;
    PrjOwner.HasChanged := True;  // Since the name has changed, the project must be saved
    SynUnit.Lines.SaveToFile(FPath);  // Save to file to hard drive
    FName := ExtractFileName(FPath);  // Get short name for fast display
    IsNew := False;  // The file is no more new
    HasChanged := False;  // The has no more changes
    SynUnit.Modified := False;  // The actual editor must not notice any changes now
    LastTimeModified := GetFileLastTimeModified(PChar(Path));  // Now we wrote on the disk we may retrieve the time it has been writen

    // Reinitialize stuff...
    frmLuaEditMain.RefreshOpenedUnits;
    frmLuaEditMain.jvUnitBarChange(frmLuaEditMain.jvUnitBar);
    frmProjectTree.BuildProjectTree;
    frmLuaEditMain.BuildReopenMenu;
    frmLuaEditMain.stbMain.Panels[5].Text := '';
    frmLuaEditMain.stbMain.Refresh;
    SynUnit.Refresh;
  end;

  frmLuaEditMain.jvchnNotifier.Active := True;
end;

function TLuaEditBasicTextFile.SaveUnit(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  iAnswer: Integer;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmLuaEditMain.jvchnNotifier.Active := False;
  Result := True;

  // save only if the file is opened in the tab...
  // if not, there is no way that the file was modified so no needs to save
  if Assigned(Self.AssociatedTab) then
  begin
    // Popup a open dialog according to parameters and the state of the file
    if ((IsNew and not bNoDialog) or (bForceDialog)) then
    begin
      frmLuaEditMain.sdlgSaveAsUnit.FileName := ExtractFileName(Self.Name);

      if ExtractFileExt(FPath) = '.lua' then
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 1
      else if ExtractFileExt(FPath) = '.lmc' then
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 2
      else if ExtractFileExt(FPath) = '.txt' then
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 3
      else
        frmLuaEditMain.sdlgSaveAsUnit.FilterIndex := 4;

      if frmLuaEditMain.sdlgSaveAsUnit.Execute then
      begin
        Path := frmLuaEditMain.sdlgSaveAsUnit.FileName;
        PrjOwner.HasChanged := True;

        if IsNew then
          frmLuaEditMain.MonitorFileToRecent(Path);
      end
      else
      begin
        // Return false because action was cancel and quit function
        Result := False;
        Exit;
      end;
    end;

    // Check if file is read only first
    while (GetFileReadOnlyAttr(PChar(Path)) and (FileExists(Path))) do
    begin
      pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
      iAnswer := pMsgBox.MessageBox('The project '+Path+' is read-only. Save anyway?      ', 'LuaEdit');
      pMsgBox.Free;
      if iAnswer = mrOk then
      begin
        ToggleFileReadOnlyAttr(PChar(Path));
        // Now that we wrote on the disk we may retrieve the time it has been writen
        LastTimeModified := GetFileLastTimeModified(PChar(Path));
        IsReadOnly := False;
      end
      else if iAnswer = mrYes then
      begin
        // Popup an open dialog according to parameters and the state of the file
        frmLuaEditMain.sdlgSaveAsUnit.FileName := ExtractFileName(Self.Name);

        if frmLuaEditMain.sdlgSaveAsUnit.Execute then
        begin
          Path := frmLuaEditMain.sdlgSaveAsUnit.FileName;
          PrjOwner.HasChanged := True;
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

    synUnit.Lines.SaveToFile(Path);  // Save the file to hard drive
    Self.Name := ExtractFileName(Path);  // Get short name for fast display
    Self.Path := Path;  // Assign filepath to class filepath
    IsNew := False;  // The file is not new anymore
    HasChanged := False;  // The file does't have anymore changes
    synUnit.Modified := False;  // The actual editor must not notice any changes now
    LastTimeModified := GetFileLastTimeModified(PChar(Path));  // Now we wrote on the disk we may retrieve the time it has been writen

    // Initialize stuff...
    frmLuaEditMain.RefreshOpenedUnits;
    frmLuaEditMain.jvUnitBarChange(frmLuaEditMain.jvUnitBar);
    frmProjectTree.BuildProjectTree;
    frmLuaEditMain.BuildReopenMenu;
    frmLuaEditMain.stbMain.Panels[5].Text := '';
    frmLuaEditMain.stbMain.Refresh;
    synUnit.Refresh;
  end;

  frmLuaEditMain.jvchnNotifier.Active := True;
end;

///////////////////////////////////////////////////////////////////
// TLuaEditDebugFile class
///////////////////////////////////////////////////////////////////

constructor TLuaEditDebugFile.Create(Path: String; otType: TLuaEditFileType);
begin
  inherited Create(Path, otType);

  FLinkedGUIForm := nil;
  FDebugInfos := TLineDebugInfos.Create;
  FDebugPlugin := TDebugSupportPlugin.Create(SynUnit);
  FSynCompletion := frmLuaEditMain.GetBaseCompletionProposal();
  FSynCompletion.Editor := SynUnit;
  FSynParams := frmLuaEditMain.GetBaseParamsProposal();
  FSynParams.TriggerChars := '(';
  FSynParams.Editor := SynUnit;
  FPrevLineNumber := SynUnit.Lines.Count;
end;

destructor TLuaEditDebugFile.Destroy;
begin
  inherited Destroy;
  
  FDebugInfos.Free;
  FSynCompletion.Free;
  FSynParams.Free;
end;

function TLuaEditDebugFile.SaveUnit(Path: String; bNoDialog: Boolean; bForceDialog: Boolean): Boolean;
begin
  inherited SaveUnit(Path, bNoDialog, bForceDialog);

  // Reinitialize variables
  DebugInfos.iLineError := -1;  // Do not display anymore the current line error

  // Save breakpoints if feature is enabled
  if Main.SaveBreakpoints then
    SaveBreakpoints();

  // Refresh stuff...
  frmLuaEditMain.stbMain.Refresh;
  SynUnit.Refresh;
end;

function TLuaEditDebugFile.SaveUnitInc(Path: String; bNoDialog: Boolean; bForceDialog: Boolean): Boolean;
begin
  inherited SaveUnitInc(Path, bNoDialog, bForceDialog);

  // Reinitialize variables
  DebugInfos.iLineError := -1;  // Do not display anymore the current line error

  // Save breakpoints if feature is enabled
  if Main.SaveBreakpoints then
    SaveBreakpoints();

  // Refresh stuff...
  frmLuaEditMain.stbMain.Refresh;
  SynUnit.Refresh;
end;

procedure TLuaEditDebugFile.SaveBreakpoints();
var
  x, iBreakpointInc: Integer;
  sSectionName: String;
  pBreakpointFile: TIniFile;
  pBreakpoint: TBreakpoint;
begin
  // Only if at least on breakpoint is present
  if DebugInfos.lstBreakpoint.Count > 0 then
  begin
    // Erase existing file if any to ensure a new clean breakpoint file
    // NOTE: IniFiles append datas when they already exists
    if FileExists(ChangeFileExt(Path, '.lbf')) then
      DeleteFile(PChar(ChangeFileExt(Path, '.lbf')));

    // Create the ini file engine and the file on the hard drive
    pBreakpointFile := TIniFile.Create(ChangeFileExt(Path, '.lbf'));

    // Initialize stuff...
    iBreakpointInc := 0;

    // Go through all breakpoints and save them in the file
    for x := 0 to DebugInfos.lstBreakpoint.Count - 1 do
    begin
      pBreakpoint := TBreakpoint(DebugInfos.lstBreakpoint[x]);  // Assign list object pointer to local pointer for easier usage

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

procedure TLuaEditDebugFile.GetBreakpoints();
var
  x: Integer;
  lstSections: TStringList;
  pBreakpointFile: TIniFile;
  pBreakpoint: TBreakpoint;
begin
  // Only if a .lbf file with the same name as the .lua file is existing
  if FileExists(ChangeFileExt(Path, '.lbf')) then
  begin
    lstSections := TStringList.Create;  // Create the section list
    pBreakpointFile := TIniFile.Create(ChangeFileExt(Path, '.lbf'));  // Create the ini file engine and the file on the hard drive

    // Read all sections name
    pBreakpointFile.ReadSections(lstSections);

    // Empty actual list of breakpoints if any
    for x := DebugInfos.lstBreakpoint.Count - 1 downto 0 do
    begin
      pBreakpoint := TBreakpoint(DebugInfos.lstBreakpoint[x]);
      DebugInfos.lstBreakpoint.Delete(x);
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
      DebugInfos.lstBreakpoint.Add(pBreakpoint);
    end;

    // Free local pointers and refresh associated synedit
    lstSections.Free;
    pBreakpointFile.Free;
    if Assigned(synUnit) then
      synUnit.Refresh;
  end;
end;

///////////////////////////////////////////////////////////////////
// TLuaEditProject class
///////////////////////////////////////////////////////////////////

constructor TLuaEditProject.Create(Path: String; otType: TLuaEditFileType);
begin
  inherited Create(Path, otType);

  lstUnits := TList.Create;
  iVersionMajor := 1;
  iVersionMinor := 0;
  iVersionRelease := 0;
  iVersionRevision := 0;
  AutoIncRevNumber := False;
  iRemotePort := 1024;
  sRemoteIP := '0.0.0.0';
  sRemoteDirectory := '';
  sCompileDirectory := '';
  sCompileExtension := '.luac';
end;

destructor TLuaEditProject.Destroy;
begin
  inherited Destroy;
  
  lstUnits.Free;
end;

procedure TLuaEditProject.GetProjectFromDisk(Path: String);
var
  x: Integer;
  pLuaUnit: TLuaEditUnit;
  fFile: TIniFile;
  lstTmpFiles: TStringList;
  sUnitName: String;
begin
  fFile := TIniFile.Create(Path);
  lstTmpFiles := TStringList.Create;

  // Read the [Description] section
  FName := fFile.ReadString('Description', 'Name', 'LuaProject');
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
  sCompileDirectory := fFile.ReadString('Debug', 'CompileDirectory', '');
  sCompileExtension := fFile.ReadString('Debug', 'CompileExtension', '.luac');
  pTargetLuaUnit := nil; // Will be filled later 

  // Initialize project variables and global variables
  FPath := Path;
  IsNew := False;
  HasChanged := False;
  LuaProjects.Add(Self);
  ActiveProject := Self;
  frmLuaEditMain.MonitorFileToRecent(FPath);

  // Read [Files] section
  fFile.ReadSection('Files', lstTmpFiles);

  if lstTmpFiles.Count > 0 then
  begin
    // Open each individual
    for x := 0 to lstTmpFiles.Count - 1 do
    begin
      sUnitName :=  ExpandUNCFileName(ExtractFilePath(FPath) + fFile.ReadString('Files', lstTmpFiles.Strings[x], ''));

      if FileExists(sUnitName) then
      begin
        // Initialize unit and global variables considering the fact that open was a success
        pLuaUnit := TLuaEditUnit(frmLuaEditMain.AddFileInProject(sUnitName, False, Self));
        pLuaUnit.Path := sUnitName;
        pLuaUnit.Name := ExtractFileName(sUnitName);
        pLuaUnit.IsLoaded := True;

        // Add first loaded file in the tabs
        if x = 0 then
          frmLuaEditMain.AddFileInTab(pLuaUnit);
      end
      else
      begin
        // Initialize unit and global variables considering the fact that open was a failure
        Application.MessageBox(PChar('The file "'+sUnitName+'" is innexistant!'), 'LuaEdit', MB_OK+MB_ICONERROR);
        pLuaUnit := TLuaEditUnit(frmLuaEditMain.AddFileInProject(sUnitName, False, Self));
        pLuaUnit.IsLoaded := False;
      end;

      if pLuaUnit.Name = sTargetLuaUnit then
        pTargetLuaUnit := pLuaUnit;
    end;
  end;

  fFile.Free;
  lstTmpFiles.Free;
end;

function TLuaEditProject.SaveProjectInc(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  pFile: TIniFile;
  x, xPos, IncValue, iAnswer, TempIncValue: integer;
  bResult: Boolean;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmLuaEditMain.jvchnNotifier.Active := False;
  Result := True;

  // Popup a open dialog according to parameters and the state of the file
  if ((IsNew and not bNoDialog) or (bForceDialog)) then
  begin
    frmLuaEditMain.sdlgSaveAsPrj.FileName := Self.Name + '.lpr';
    
    if frmLuaEditMain.sdlgSaveAsPrj.Execute then
    begin
      Path := frmLuaEditMain.sdlgSaveAsPrj.FileName;
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
  xPos := Length(ExtractFileExt(Path)) + 1;  // Assign initial try position
  bResult := True;  // For a first try
  while bResult do
  begin
    bResult := TryStrToInt(Copy(Path, Length(Path) - xPos + 1, xPos - Length(ExtractFileExt(Path))), TempIncValue);
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

  Path := Copy(Path, 1, Length(Path) - xPos + 1) + IntToStr(IncValue) + ExtractFileExt(Path);  // Build the new name

  // Check if file is read only first
  while (GetFileReadOnlyAttr(PChar(Path)) and (FileExists(Path))) do
  begin
    pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
    iAnswer := pMsgBox.MessageBox('The project '+Path+' is read-only. Save anyway?      ', 'LuaEdit');
    pMsgBox.Free;
    
    if iAnswer = mrOk then
    begin
      ToggleFileReadOnlyAttr(PChar(Path));
      // Now that we wrote on the disk we may retrieve the time it has been writen
      LastTimeModified := GetFileLastTimeModified(PChar(Path));
      IsReadOnly := False;
    end
    else if iAnswer = mrYes then
    begin
      // Popup an open dialog according to parameters and the state of the file
      frmLuaEditMain.sdlgSaveAsPrj.FileName := Self.Name + '.lpr';

      if frmLuaEditMain.sdlgSaveAsPrj.Execute then
      begin
        Path := frmLuaEditMain.sdlgSaveAsPrj.FileName;

        if IsNew then
          frmLuaEditMain.MonitorFileToRecent(Path);
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
  if FileExists(Path) then
    DeleteFile(PChar(Path));

  pFile := TIniFile.Create(Path);  // Create project file writer engine (using *.ini files way)

  // Increasing Revision Number if feature is selected
  if AutoIncRevNumber then
    Inc(iVersionRevision);

  // Write data for [Description] section
  pFile.WriteString('Description', 'Name', Self.Name);
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
  pFile.WriteString('Debug', 'CompileDirectory', sCompileDirectory);
  pFile.WriteString('Debug', 'CompileExtension', sCompileExtension);

  // Wrtie data for [Files] section
  for x := 0 to lstUnits.Count - 1 do
  begin
    // Write the file with a relative path
    pFile.WriteString('Files', 'File'+IntToStr(x), ExtractRelativePath(ExtractFilePath(Self.Path), TLuaEditUnit(lstUnits.Items[x]).Path));
  end;

  if Self.Path <> Path then
    Self.Path := Path;

  // Initialize stuff...   
  IsNew := False;
  HasChanged := False;
  frmProjectTree.BuildProjectTree;
  pFile.UpdateFile;
  pFile.Free;
  frmLuaEditMain.jvUnitBarChange(frmLuaEditMain.jvUnitBar);
  frmLuaEditMain.BuildReopenMenu;

  // Now we wrote on the disk we may retrieve the time it has been writen
  LastTimeModified := GetFileLastTimeModified(PChar(Path));
  frmLuaEditMain.jvchnNotifier.Active := True;
end;

function TLuaEditProject.SaveProject(Path: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
var
  pFile: TIniFile;
  x, iAnswer: integer;
  pMsgBox: TfrmReadOnlyMsgBox;
begin
  frmLuaEditMain.jvchnNotifier.Active := False;
  Result := True;

  // Popup an open dialog according to parameters and the state of the file
  if ((IsNew and not bNoDialog) or (bForceDialog)) then
  begin
    frmLuaEditMain.sdlgSaveAsPrj.FileName := Self.Name + '.lpr';

    if frmLuaEditMain.sdlgSaveAsPrj.Execute then
    begin
      Path := frmLuaEditMain.sdlgSaveAsPrj.FileName;

      if IsNew then
        frmLuaEditMain.MonitorFileToRecent(Path);
    end
    else
    begin
      // Return false because action was cancel and quit function
      Result := False;
      Exit;
    end;
  end;

  // Check if file is read only first
  while (GetFileReadOnlyAttr(PChar(Path)) and (FileExists(Path))) do
  begin
    pMsgBox := TfrmReadOnlyMsgBox.Create(nil);
    iAnswer := pMsgBox.MessageBox('The project '+Path+' is read-only. Save anyway?      ', 'LuaEdit');
    pMsgBox.Free;
    if iAnswer = mrOk then
    begin
      ToggleFileReadOnlyAttr(PChar(Path));
      // Now that we wrote on the disk we may retrieve the time it has been writen
      LastTimeModified := GetFileLastTimeModified(PChar(Path));
      IsReadOnly := False;
    end
    else if iAnswer = mrYes then
    begin
      // Popup an open dialog according to parameters and the state of the file
      frmLuaEditMain.sdlgSaveAsPrj.FileName := Self.Name + '.lpr';

      if frmLuaEditMain.sdlgSaveAsPrj.Execute then
      begin
        Path := frmLuaEditMain.sdlgSaveAsPrj.FileName;
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
  if FileExists(Path) then
    DeleteFile(PChar(Path));

  if Self.Path <> Path then
    Self.Path := Path;

  pFile := TIniFile.Create(Path);  // Create project file writer engine (using *.ini files way)

  // Increasing Revision Number if feature is selected
  if AutoIncRevNumber then
    Inc(iVersionRevision);

  // Write data for [Description] section
  pFile.WriteString('Description', 'Name', Self.Name);
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
  pFile.WriteString('Debug', 'CompileDirectory', sCompileDirectory);
  pFile.WriteString('Debug', 'CompileExtension', sCompileExtension);

  // Wrtie data for [Files] section  
  for x := 0 to lstUnits.Count - 1 do
    // Write the file with a relative path
    pFile.WriteString('Files', 'File'+IntToStr(x), ExtractRelativePath(ExtractFilePath(Self.Path), TLuaEditUnit(lstUnits.Items[x]).Path));

  // Initialize stuff...   
  IsNew := False;
  HasChanged := False;
  frmProjectTree.BuildProjectTree;
  frmLuaEditMain.jvUnitBarChange(frmLuaEditMain.jvUnitBar);
  frmLuaEditMain.BuildReopenMenu;
  pFile.UpdateFile;
  pFile.Free;

  // Now we wrote on the disk we may retrieve the time it has been writen
  LastTimeModified := GetFileLastTimeModified(PChar(Path));
  frmLuaEditMain.jvchnNotifier.Active := True;
end;

procedure TLuaEditProject.RealoadProject();
var
  x: Integer;
  pLuaUnit: TLuaEditUnit;
begin
  // remove files from project
  for x := lstUnits.Count - 1 downto 0 do
  begin
    pLuaUnit := TLuaEditUnit(lstUnits.Items[x]);

    // Prompt user to save file if modified or new
    if pLuaUnit.HasChanged or pLuaUnit.IsNew then
    begin
      if Application.MessageBox(PChar('Save changes to file '+pLuaUnit.Path+'?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
      begin
        if SaveUnitsInc then
          pLuaUnit.SaveUnitInc(pLuaUnit.Path)
        else
          pLuaUnit.SaveUnit(pLuaUnit.Path);
      end;
    end;

    // Remove file from tabs
    if Assigned(pLuaUnit.AssociatedTab) then
    begin
      frmLuaEditMain.jvUnitBar.Tabs.Delete(pLuaUnit.AssociatedTab.Index);
      LuaOpenedFiles.Remove(pLuaUnit);
    end;

    pLuaUnit.PrjOwner.lstUnits.Remove(pLuaUnit);
  end;

  // Remove projects from current project list
  LuaProjects.Remove(Self);
  // Reload the project...
  GetProjectFromDisk(Self.Path);
end;

///////////////////////////////////////////////////////////////////
// TLuaEditUnit class
///////////////////////////////////////////////////////////////////

constructor TLuaEditUnit.Create(Path: String; otType: TLuaEditFileType);
begin
  inherited Create(Path, otType);

  lstFunctions := TStringList.Create;
end;

destructor TLuaEditUnit.Destroy;
begin
  inherited Destroy;

  lstFunctions.Free;
end;

///////////////////////////////////////////////////////////////////
// TLuaEditMacro class
///////////////////////////////////////////////////////////////////

constructor TLuaEditMacro.Create(Path: String; otType: TLuaEditFileType);
begin
  inherited Create(Path, otType);

  lstFunctions := TStringList.Create;
end;

destructor TLuaEditMacro.Destroy;
begin
  inherited Destroy;
  
  lstFunctions.Free;
end;

end.
