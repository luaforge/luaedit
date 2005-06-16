unit Main;

interface
//{$define RTASSERT}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CommCtrl, ExtCtrls, SynEdit, SynCompletionProposal,
  Menus, ActnList, ImgList, ToolWin, XPMan, IniFiles, Registry, lua, lualib,
  lauxlib, LuaUtils, SynEditMiscClasses, SynEditSearch, SynEditRegexSearch, SynEditTypes,
  ShellAPI, SynEditHighlighter, SynEditKeyCmds, SynEditPrint, WinSock,
  JvDockControlForm, JvComponent, JvDockVIDStyle, JvDockVSNetStyle, JvAppRegistryStorage,
  JvXPCore, JvTabBar, Mask, JvExMask, JvToolEdit, JvMaskEdit, JvDotNetControls,
  JvChangeNotify, JvClipboardMonitor, JvMenus, JvExComCtrls, JvToolBar,
  JvInspector, XPStyleActnCtrls, ActnMan, ActnCtrls, CustomizeDlg,
  ActnMenus, ActnColorMaps, StdStyleActnCtrls, XPMenu, Clipbrd, JvLookOut,
  JvExControls, FileCtrl
  {$ifdef RTASSERT}  , RTDebug  {$endif}
  , JvDragDrop, JvAppEvent;

const
  otLuaProject  = 1;
  otLuaUnit     = 2;

  LUA_DBGSTEPOVER = 1;
  LUA_DBGSTEPINTO = 2;
  LUA_DBGSTOP     = 3;
  LUA_DBGPLAY     = 4;
  LUA_DBGPAUSE    = 5;

  BKPT_DISABLED = 0;
  BKPT_ENABLED  = 1;

  JVPAGE_RING_FILES     = 0;
  JVPAGE_RING_CLIPBOARD = 1;

  HOOK_MASK    = LUA_MASKCALL or LUA_MASKRET or LUA_MASKLINE;
  PRINT_SIZE   = 32;
  ArgIdent     = 'arg';

type
  ELuaEditException = class(Exception);

  TInitializer = function(L: PLua_State): Integer; cdecl;
  PTInitializer = ^TInitializer;

  TLuaProject = class;

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
    function GetBreakpointAtLine(iLine: Integer): TBreakpoint;
    procedure RemoveBreakpointAtLine(iLine: Integer);
    function GetLineCondition(iLine: Integer): String;
  end;

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

  TLuaProject = class
    sPrjName:           String;
    sPrjPath:           String;
    sInitializer:       String;
    LastTimeModified:   TDateTime;
    IsReadOnly:         Boolean;
    IsNew:              Boolean;
    HasChanged:         Boolean;
    AutoIncRevNumber:   Boolean;
    iVersionMajor:      Integer;
    iVersionMinor:      Integer;
    iVersionRelease:    Integer;
    iVersionRevision:   Integer;
    lstUnits:           TList;
    public
      constructor Create(sPath: String);
      destructor  Destroy; override;

      procedure GetProjectFromDisk(sPath: String);
      function SaveProject(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
      function SaveProjectInc(sPath: String; bNoDialog: Boolean = False; bForceDialog: Boolean = False): Boolean;
      procedure RealoadProject();
  end;

  TDebuggerThread = class(TThread)
    private
      { Private declarations }
    protected
      procedure Execute; override;
  end;

  TfrmMain = class(TForm)
    Panel1: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    stbMain: TStatusBar;
    actListMain: TActionList;
    actNewProject: TAction;
    actNewUnit: TAction;
    actOpenFile: TAction;
    actOpenProject: TAction;
    actExit: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actSaveProjectAs: TAction;
    actSaveAll: TAction;
    actClose: TAction;
    actPrint: TAction;
    actUndo: TAction;
    actRedo: TAction;
    actSelectAll: TAction;
    actCut: TAction;
    actCopy: TAction;
    actPaste: TAction;
    actSearch: TAction;
    actSearchAgain: TAction;
    actSearchReplace: TAction;
    actGoToLine: TAction;
    actRunScript: TAction;
    actStepOver: TAction;
    actStepInto: TAction;
    actAddBreakpoint: TAction;
    actCheckSyntax: TAction;
    actPause: TAction;
    actStop: TAction;
    actRunToCursor: TAction;
    actAddToPrj: TAction;
    actRemoveFromPrj: TAction;
    actEditorSettings: TAction;
    actBlockUnindent: TAction;
    actBlockIndent: TAction;
    actPrjSettings: TAction;
    actActiveSelPrj: TAction;
    imlActions: TImageList;
    odlgOpenUnit: TOpenDialog;
    odlgOpenProject: TOpenDialog;
    sdlgSaveAsUnit: TSaveDialog;
    sdlgSaveAsPrj: TSaveDialog;
    mnuReopen: TPopupMenu;
    synMainSearch: TSynEditSearch;
    synMainSearchRegEx: TSynEditRegexSearch;
    ppmEditor: TPopupMenu;
    Undo2: TMenuItem;
    Redo2: TMenuItem;
    N17: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    N19: TMenuItem;
    IndentSelection2: TMenuItem;
    UnindentSelection2: TMenuItem;
    N16: TMenuItem;
    oggleBookmark1: TMenuItem;
    GotoBookmark12: TMenuItem;
    GotoBookmark13: TMenuItem;
    GotoBookmark14: TMenuItem;
    GotoBookmark15: TMenuItem;
    GotoBookmark16: TMenuItem;
    GotoBookmark17: TMenuItem;
    GotoBookmark18: TMenuItem;
    GotoBookmark81: TMenuItem;
    GotoBookmark91: TMenuItem;
    GotoBookmark11: TMenuItem;
    GotoBookmark1: TMenuItem;
    Bookmark11: TMenuItem;
    Bookmark12: TMenuItem;
    Bookmark13: TMenuItem;
    Bookmark14: TMenuItem;
    Bookmark15: TMenuItem;
    Bookmark16: TMenuItem;
    Bookmark17: TMenuItem;
    Bookmark18: TMenuItem;
    Bookmark19: TMenuItem;
    Bookmark110: TMenuItem;
    N15: TMenuItem;
    EditorSettings2: TMenuItem;
    ppmUnits: TPopupMenu;
    Close2: TMenuItem;
    synEditPrint: TSynEditPrint;
    pdlgPrint: TPrintDialog;
    ctrlBar: TControlBar;
    tlbRun: TToolBar;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton19: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    tlbBaseFile: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton2: TToolButton;
    ToolButton7: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    ToolButton5: TToolButton;
    ToolButton9: TToolButton;
    ToolButton34: TToolButton;
    ToolButton33: TToolButton;
    ToolButton22: TToolButton;
    ToolButton10: TToolButton;
    ToolButton23: TToolButton;
    ppmToolBar: TPopupMenu;
    File3: TMenuItem;
    Edit3: TMenuItem;
    Run4: TMenuItem;
    AddBreakpoint1: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    OpenFileatCursor1: TMenuItem;
    jvDockVSNet: TJvDockVSNetStyle;
    jvDockServer: TJvDockServer;
    imlDock: TImageList;
    jvUnitBar: TJvTabBar;
    jvModernUnitBarPainter: TJvModernTabBarPainter;
    pnlMain: TPanel;
    actAddWatch: TAction;
    N22: TMenuItem;
    Save2: TMenuItem;
    SaveAs2: TMenuItem;
    jvchnNotifier: TJvChangeNotify;
    tlbEdit: TToolBar;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    ToolButton39: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    ToolButton43: TToolButton;
    actMainMenuFile: TAction;
    actMainMenuEdit: TAction;
    actMainMenuView: TAction;
    actMainMenuProject: TAction;
    actMainMenuRun: TAction;
    actMainMenuTools: TAction;
    actMainMenuHelp: TAction;
    actShowProjectTree: TAction;
    actShowBreakpoints: TAction;
    actShowMessages: TAction;
    actShowWatchList: TAction;
    actShowCallStack: TAction;
    actShowLuaStack: TAction;
    actShowLuaOutput: TAction;
    actShowLuaGlobals: TAction;
    actShowLuaLocals: TAction;
    mnuMain: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    CloseUnit1: TMenuItem;
    SaveAll1: TMenuItem;
    SaveProjectAs1: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    N3: TMenuItem;
    Reopen1: TMenuItem;
    OpenLuaProject1: TMenuItem;
    OpenFile1: TMenuItem;
    New1: TMenuItem;
    Unit1: TMenuItem;
    Project1: TMenuItem;
    Edit1: TMenuItem;
    GotoLine1: TMenuItem;
    N4: TMenuItem;
    UnindentSelection1: TMenuItem;
    IndentSelection1: TMenuItem;
    N5: TMenuItem;
    SearchAgain1: TMenuItem;
    Replace1: TMenuItem;
    Search1: TMenuItem;
    N6: TMenuItem;
    SelectAll1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    N7: TMenuItem;
    Redo1: TMenuItem;
    Undo1: TMenuItem;
    View1: TMenuItem;
    oolbars1: TMenuItem;
    Run1: TMenuItem;
    Edit2: TMenuItem;
    File2: TMenuItem;
    DebugWindows1: TMenuItem;
    LuaLocals1: TMenuItem;
    LuaGlobals1: TMenuItem;
    LuaOutput1: TMenuItem;
    LuaStack1: TMenuItem;
    CallStack1: TMenuItem;
    WatchList1: TMenuItem;
    Messages1: TMenuItem;
    Breakpoints1: TMenuItem;
    ProjectTree1: TMenuItem;
    Project2: TMenuItem;
    Options1: TMenuItem;
    N8: TMenuItem;
    ActivateSelectedProject1: TMenuItem;
    N9: TMenuItem;
    RemoveUnitFromProject1: TMenuItem;
    AddUnittoProject1: TMenuItem;
    Run2: TMenuItem;
    oggleBreakpoint1: TMenuItem;
    N10: TMenuItem;
    RunScripttoCursor1: TMenuItem;
    StepInto1: TMenuItem;
    StepOver1: TMenuItem;
    N11: TMenuItem;
    CheckSyntax1: TMenuItem;
    N12: TMenuItem;
    StopScript1: TMenuItem;
    PauseScript1: TMenuItem;
    RunScript1: TMenuItem;
    ools1: TMenuItem;
    EditorSettings1: TMenuItem;
    N13: TMenuItem;
    AsciiTable1: TMenuItem;
    Conversions1: TMenuItem;
    ErrorLookup1: TMenuItem;
    Calculator1: TMenuItem;
    N14: TMenuItem;
    AboutLuaEdit1: TMenuItem;
    ContributorsList1: TMenuItem;
    N18: TMenuItem;
    LuaHelp1: TMenuItem;
    Help1: TMenuItem;
    XPManifest1: TXPManifest;
    xmpMenuPainter: TXPMenu;
    actShowRings: TAction;
    ClipboardRing1: TMenuItem;
    actShowFunctionList: TAction;
    FunctionList1: TMenuItem;
    actFunctionHeader: TAction;
    N23: TMenuItem;
    HeaderBuilder1: TMenuItem;
    Functions1: TMenuItem;
    actGotoLastEdited: TAction;
    GotoLastEdited1: TMenuItem;
    N24: TMenuItem;
    GotoLastEdited2: TMenuItem;
    GotoLine2: TMenuItem;
    actBlockComment: TAction;
    actBlockUncomment: TAction;
    CommentSelection1: TMenuItem;
    UncommentSelection1: TMenuItem;
    CommentSelection2: TMenuItem;
    UncommentSelection2: TMenuItem;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    jvAppDrop: TJvDragDrop;
    procedure FormCreate(Sender: TObject);
    procedure synEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actOpenProjectExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actNewUnitExecute(Sender: TObject);
    procedure actNewProjectExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actSaveProjectAsExecute(Sender: TObject);
    procedure actSaveAllExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actRedoExecute(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actSearchAgainExecute(Sender: TObject);
    procedure actSearchReplaceExecute(Sender: TObject);
    procedure actGoToLineExecute(Sender: TObject);
    procedure AboutLuaEdit1Click(Sender: TObject);
    procedure actRunScriptExecute(Sender: TObject);
    procedure LuaHelp1Click(Sender: TObject);
    procedure actAddBreakpointExecute(Sender: TObject);
    procedure stbMainDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actStepOverExecute(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actRunToCursorExecute(Sender: TObject);
    procedure actAddToPrjExecute(Sender: TObject);
    procedure actRemoveFromPrjExecute(Sender: TObject);
    procedure Project1Click(Sender: TObject);
    procedure actEditorSettingsExecute(Sender: TObject);
    procedure ToggleBookmarkClick(Sender: TObject);
    procedure GotoBookmarkClick(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure actBlockUnindentExecute(Sender: TObject);
    procedure actBlockIndentExecute(Sender: TObject);
    procedure actPrjSettingsExecute(Sender: TObject);
    procedure actActiveSelPrjExecute(Sender: TObject);
    procedure ErrorLookup1Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure ctrlBarDockOver(Sender: TObject; Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure File2Click(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure Run3Click(Sender: TObject);
    procedure ASciiTable1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure ContributorsList1Click(Sender: TObject);
    procedure OpenFileatCursor1Click(Sender: TObject);
    procedure Conversions1Click(Sender: TObject);
    procedure ppmEditorPopup(Sender: TObject);
    procedure jvUnitBarTabSelected(Sender: TObject; Item: TJvTabBarItem);
    procedure jvUnitBarTabClosing(Sender: TObject; Item: TJvTabBarItem; var AllowClose: Boolean);
    procedure actAddWatchExecute(Sender: TObject);
    procedure ppmUnitsPopup(Sender: TObject);
    procedure jvchnNotifierChangeNotify(Sender: TObject; Dir: String; Actions: TJvChangeActions);
    procedure actMainMenuFileExecute(Sender: TObject);
    procedure actMainMenuViewExecute(Sender: TObject);
    procedure actShowProjectTreeExecute(Sender: TObject);
    procedure actMainMenuEditExecute(Sender: TObject);
    procedure actMainMenuProjectExecute(Sender: TObject);
    procedure actMainMenuRunExecute(Sender: TObject);
    procedure actMainMenuToolsExecute(Sender: TObject);
    procedure actMainMenuHelpExecute(Sender: TObject);
    procedure actShowBreakpointsExecute(Sender: TObject);
    procedure actShowMessagesExecute(Sender: TObject);
    procedure actShowWatchListExecute(Sender: TObject);
    procedure actShowCallStackExecute(Sender: TObject);
    procedure actShowLuaStackExecute(Sender: TObject);
    procedure actShowLuaOutputExecute(Sender: TObject);
    procedure actShowLuaGlobalsExecute(Sender: TObject);
    procedure actShowLuaLocalsExecute(Sender: TObject);
    procedure actShowRingsExecute(Sender: TObject);
    procedure actCheckSyntaxExecute(Sender: TObject);
    procedure actShowFunctionListExecute(Sender: TObject);
    procedure actFunctionHeaderExecute(Sender: TObject);
    procedure actGotoLastEditedExecute(Sender: TObject);
    procedure actBlockCommentExecute(Sender: TObject);
    procedure actBlockUncommentExecute(Sender: TObject);
    procedure jvAppDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
    //procedure actFunctionHeaderExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    // DEBUG variables
    PrevFile: string;
    PrevLine: Integer;
    CurrentICI: Integer;
    PauseICI: Integer;
    Running: Boolean;
    ReStart, Pause: Boolean;
    PauseLine: Integer;
    PauseFile: string;
    NotifyModified: Boolean;
    LuaState: Plua_State;

    //Search variables
    sSearchString: String;
    sReplaceString: String;
    SearchedText: TStringList;
    ReplacedText: TStringList;
    srSearchDriection: Integer;
    srSearchScope: Integer;
    srSearchOrigin: Integer;
    srReplaceAll: Boolean;
    srPromptForReplace: Boolean;
    srSearchSensitive: Boolean;
    srSearchRegularExpression: Boolean;
    srSearchWholeWords: Boolean;

    procedure ClosingUnit();
    procedure AddFileInTab(pLuaUnit: TLuaUnit);
    procedure AddToNotifier(sPath: String);
    function AddFileInProject(sFilePath: String; IsNew: Boolean; pPrj: TLuaProject): TLuaUnit;
    procedure CheckButtons;
    procedure BuildReopenMenu;
    function IsReopenInList(sString: String): Boolean;
    procedure MonitorFile(sString: String);
    procedure mnuXReopenClick(Sender: TObject);
    procedure btnXFilesClick(Sender: TObject);
    procedure btnXClipboardClick(Sender: TObject);
    function IsProjectOpened(sProjectPath: String): Boolean;
    procedure SynEditReplaceText(Sender: TObject; const ASearch, AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure PaintDebugGlyphs(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
    procedure synEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure synEditGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure synEditMouseCursor(Sender: TObject; const aLineCharPos: TBufferCoord; var aCursor: TCursor);
    procedure synEditChange(Sender: TObject);
    procedure synEditClick(Sender: TObject);
    procedure synEditDblClick(Sender: TObject);
    procedure synEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure synCompletionExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: String; var x, y: Integer; var CanExecute: Boolean);
    function GetBaseCompletionProposal: TSynCompletionProposal;
    function GetBaseParamsProposal: TSynCompletionProposal;
    procedure UpdateWatch;
    procedure UpdateFctList;
    procedure LoadEditorSettings;
    procedure ApplyValuesToEditor(synTemp: TSynEdit; lstColorSheme: TList);
    function ExecuteInitializer(sInitializer: String; L: PLua_State): Integer;
    procedure RefreshOpenedUnits;
    procedure synParamsExecute(Kind: SynCompletionType; Sender: TObject; var AString: String; var x, y: Integer; var CanExecute: Boolean);
    procedure FillLookUpList;
    function FileIsInTree(sFileName: String): Boolean;
    procedure LuaGlobalsToStrings(L: PLua_State; Lines: TStrings; MaxTable: Integer = -1);
    function GetAssociatedTab(pLuaUnit: TLuaUnit): TJvTabBarItem;
    function FindUnitInTabs(sFileName: String): TLuaUnit;
    procedure PrintLuaStack(L: Plua_State);
    procedure PrintStack;
    procedure PrintLocal(L: Plua_State; Level: Integer = 0);
    procedure PrintGlobal(L: Plua_State; Foce: Boolean = False);
    procedure PrintWatch(L: Plua_State);
    function IsBreak(sFileName: String; Line: Integer): Boolean;
    function IsICI(ICI: Integer): Boolean;
    function IsEdited(pIgnoreUnit: TLuaUnit = nil): Boolean;
    function GetValue(Name: string): string;
    function PopUpUnitToScreen(sFileName: String; iLine: Integer = -1; bCleanPrevUnit: Boolean = False): TLuaUnit;
    procedure ExecuteCurrent(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer);
    procedure CustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
    procedure CallHookFunc(L: Plua_State; AR: Plua_Debug);
  end;

var
  frmMain: TfrmMain;
  LuaProjects: TList;
  LuaSingleUnits: TLuaProject;
  LuaOpenedUnits: TList;
  ActiveProject: TLuaProject;
  DraggedTab: Integer;
  LookupList: TStringList;
  pCurrentSynEdit: TSynEdit;
  CallStack: TList;

  //Settings variables
  EditorOptions: TSynEditorOptions;
  TabWidth: Integer;
  UndoLimit: Integer;
  ShowGutter: Boolean;
  ShowLineNumbers: Boolean;
  LeadingZeros: Boolean;
  GutterWidth: Integer;
  GutterColor: String;
  FontName: String;
  FontSize: Integer;
  EditorColors: TList;
  PrintUseColor: Boolean;
  PrintUseSyntax: Boolean;
  PrintUseWrapLines: Boolean;
  PrintLineNumbers: Boolean;
  PrintLineNumbersInMargin: Boolean;
  AssociateFiles: Boolean;
  SaveProjectsInc: Boolean;
  SaveUnitsInc: Boolean;
  SaveBreakpoints: Boolean;
  ShowExSaveDlg: Boolean;
  LibrariesSearchPaths: TStringList;

  //Debugger variables
  LDebug: Plua_State;
  FirstClickPos: TBufferCoord;
  lstLocals: TStringList;
  lstGlobals: TStringList;
  ThreadDebugHandle: THandle;
  ThreadDebugID: Cardinal;
  hMutex: Cardinal;
  lstStack: TStringList;
  lstLuaStack: TStringList;
  IsCompiledComplete: Boolean;
  LastMessage: String;
  IsRunning: Boolean;
  FirstLineStop: Boolean;
  StepOverPressed: Boolean;
  StepIntoPressed: Boolean;
  RunToCursorPressed: Boolean;
  PausePressed: Boolean;
  PlayPressed: Boolean;
  StopPressed: Boolean;
  CallLevel: Integer;
  WaitInCallLevel: Integer;
  sMainInitializer: String;
  hModule: Cardinal;
  HasChangedWhileCompiled: Boolean;
  IsRemoteDebug: Boolean;
  pSock: TSocket;
  pRSock: TSocket;
  thDebugger: TThread;

// Misc functions
procedure CallRemoteHookFunc(pSock: TSocket);
procedure DoLuaStdout(S: PChar; N: Integer);
procedure RelaunchRunningThread;
function GetLocalIP: String;
function LocalOutput(L: PLua_State): Integer; cdecl;
procedure HookCaller(L: Plua_State; AR: Plua_Debug); cdecl;

// External functions
function GetFileLastTimeModified(const sFileName: PChar): TDateTime; cdecl; external 'LuaEditSys.dll';
function GetFileReadOnlyAttr(const sFileName: PChar): Boolean; cdecl; external 'LuaEditSys.dll';
procedure ToggleFileReadOnlyAttr(const sFileName: PChar); cdecl; external 'LuaEditSys.dll';

function FunctionHeaderBuilder(OwnerAppHandle: HWND; sLine: PChar): PChar; cdecl; external 'HdrBld.dll';

implementation

uses
  LuaSyntax, Search, Replace, ReplaceQuerry, GotoLine, About,
  ProjectTree, Stack, Watch, Grids, AddToPrj, EditorSettings,
  PrjSettings, RemFromPrj, ErrorLookup, LuaStack, PrintSetup, CntString,
  Connecting, Math, Contributors, LuaOutput, Breakpoints, LuaGlobals,
  LuaLocals, LuaEditMessages, ExSaveExit, AsciiTable, ReadOnlyMsgBox,
  Rings, JvOutlookBar, SynEditTextBuffer, FunctionList;

{$R *.dfm}

///////////////////////////////////////////////////////////////////
//TEditorColors class
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
  frmMain.PaintDebugGlyphs(ACanvas, AClip, FirstLine, LastLine);
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

  // Initialize project variables and global variables
  sPrjPath := sPath;
  IsNew := False;
  HasChanged := False;
  LuaProjects.Add(Self);
  ActiveProject := Self;
  frmMain.MonitorFile(sPrjPath);

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
    DeleteFile(sPath);

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
    DeleteFile(sPath);

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

  // Wrtie data for [Files] section  
  for x := 0 to lstUnits.Count - 1 do
  begin
    // Write the file with a relative path
    pFile.WriteString('Files', 'File'+IntToStr(x), ExtractRelativePath(ExtractFilePath(sPrjPath), TLuaUnit(lstUnits.Items[x]).sUnitPath));
  end;

  // Initialize stuff...   
  IsNew := False;
  HasChanged := False;
  frmProjectTree.BuildProjectTree;
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

  if pCurrentSynEdit = synUnit then
    pCurrentSynEdit := nil;

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
    LastMessage := '';
    frmProjectTree.BuildProjectTree;
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
    LastMessage := '';
    frmProjectTree.BuildProjectTree;
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
      DeleteFile(ChangeFileExt(sUnitPath, '.lbf'));

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

///////////////////////////////////////////////////////////////////
// TfrmMain class
///////////////////////////////////////////////////////////////////
procedure TfrmMain.FormCreate(Sender: TObject);
var
  AFont: TFont;
  pReg: TRegistry;
begin  
  //Sets Printing basic options...
  AFont := TFont.Create;
  with SynEditPrint.Header do begin
      {First line, default font, right aligned}
    Add('Page: $PAGENUM$ of $PAGECOUNT$', nil, taRightJustify, 1);
      {Second line, default font, left aligned}
    Add('$TITLE$', nil, taLeftJustify, 1);
    AFont.Assign(DefaultFont);
    AFont.Size := 6;
      {Second line, small font, right aligned - note that lines can have different fonts}
    Add('Print Date: $DATE$. Time: $TIME$', AFont, taRightJustify, 2);
  end;
  with SynEditPrint.Footer do begin
    AFont.Assign(DefaultFont);
    Add('$PAGENUM$/$PAGECOUNT$', nil, taRightJustify, 1);
    AFont.Size := 6;
    Add('Printed with LuaEdit for Lua 5.0', AFont, taLeftJustify, 1);
  end;
  AFont.Free;

  //Reads last windows settings
  pReg := TRegistry.Create;
  if pReg.OpenKey('\Software\LuaEdit', False) then
  begin
    if pReg.ValueExists('WasMaxed') then
    begin
      if not pReg.ReadBool('WasMaxed') then
      begin
        if pReg.ValueExists('Width') then
          frmMain.Width := pReg.ReadInteger('Width');
          
        if pReg.ValueExists('Height') then
          frmMain.Height := pReg.ReadInteger('Height');
      end
      else
      begin
        frmMain.WindowState := wsMaximized;
      end;
    end;
  end;
  pReg.Free;

  hMutex := CreateMutex(nil, False, nil);
  LookupList := TStringList.Create;
  EditorColors := TList.Create;
  CallStack := TList.Create;
  lstLocals := TStringList.Create;
  lstGlobals := TStringList.Create;
  lstStack := TStringList.Create;
  lstLuaStack := TStringList.Create;
  LuaProjects := TList.Create;
  LuaOpenedUnits := TList.Create;
  SearchedText := TStringList.Create;
  ReplacedText := TStringList.Create;
  LibrariesSearchPaths := TStringList.Create;
  LuaSingleUnits := TLuaProject.Create('');
  LuaSingleUnits.sPrjName := '[@@SingleUnits@@]';
  LuaProjects.Add(LuaSingleUnits);
  IsRunning := False;
  IsCompiledComplete := True;
  CurrentICI := 1;

  // Create dockable forms...
  frmProjectTree := TfrmProjectTree.Create(nil);
  frmLuaOutput := TfrmLuaOutput.Create(nil);
  frmLuaStack := TfrmLuaStack.Create(nil);
  frmWatch := TfrmWatch.Create(nil);
  frmStack := TfrmStack.Create(nil);
  frmLuaLocals := TfrmLuaLocals.Create(nil);
  frmLuaGlobals := TfrmLuaGlobals.Create(nil);
  frmLuaEditMessages := TfrmLuaEditMessages.Create(nil);
  frmBreakpoints := TfrmBreakpoints.Create(nil);
  frmRings := TfrmRings.Create(nil);
  frmFunctionList := TfrmFunctionList.Create(nil);

  // Assign dockable forms icons...
  imlDock.GetIcon(0, frmWatch.Icon);
  imlDock.GetIcon(1, frmStack.Icon);
  imlDock.GetIcon(2, frmLuaStack.Icon);
  imlDock.GetIcon(3, frmLuaOutput.Icon);
  imlDock.GetIcon(7, frmLuaGlobals.Icon);
  imlDock.GetIcon(8, frmLuaLocals.Icon);
  imlDock.GetIcon(9, frmLuaEditMessages.Icon);
  imlDock.GetIcon(4, frmProjectTree.Icon);
  imlDock.GetIcon(6, frmBreakpoints.Icon);
  imlDock.GetIcon(10, frmRings.Icon);
  imlDock.GetIcon(11, frmFunctionList.Icon);

  // Paint some non overriden components
  xmpMenuPainter.InitComponent(frmBreakpoints.tlbBreakpoints);
  xmpMenuPainter.InitComponent(frmFunctionList.tblFunctionList);

  // Build the reopen menus and ring
  BuildReopenMenu;
end;

procedure TfrmMain.synEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  synEditClick(Sender);
end;

procedure TfrmMain.actOpenFileExecute(Sender: TObject);
var
  pReg: TRegistry;
  z: integer;
  pNewPrj: TLuaProject;
  pLuaUnit: TLuaUnit;
begin
  pReg := TRegistry.Create;

  if pReg.OpenKey('\Software\LuaEdit', False) then
    odlgOpenUnit.InitialDir := pReg.ReadString('RecentPath');

  if odlgOpenUnit.Execute then
  begin
    for z := 0 to odlgOpenUnit.Files.Count - 1 do
    begin
      if ExtractFileExt(odlgOpenUnit.Files.Strings[z]) = '.lua' then
      begin
        if not FileIsInTree(odlgOpenUnit.Files.Strings[z]) then
        begin
          pLuaUnit := AddFileInProject(odlgOpenUnit.Files.Strings[z], False, LuaSingleUnits);
          pLuaUnit.IsLoaded := True;
          AddFileInTab(pLuaUnit);
          MonitorFile(odlgOpenUnit.Files.Strings[z]);
          
          // Add opened file to recent opens
          pReg.OpenKey('\Software\LuaEdit', True);
          pReg.WriteString('RecentPath', ExtractFilePath(odlgOpenUnit.Files.Strings[z]));
        end
        else
        begin
          Application.MessageBox(PChar('The project "'+odlgOpenUnit.Files.Strings[z]+')" is already opened by LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
          Exit;
        end;
      end
      else if ExtractFileExt(odlgOpenUnit.Files.Strings[z]) = '.lpr' then
      begin
        if not IsProjectOpened(odlgOpenUnit.Files.Strings[z]) then
        begin
          pNewPrj := TLuaProject.Create(odlgOpenUnit.Files.Strings[z]);
          pNewPrj.GetProjectFromDisk(odlgOpenUnit.Files.Strings[z]);
          // Add opened file to recent opens
          pReg.OpenKey('\Software\LuaEdit', True);
          pReg.WriteString('RecentPath', ExtractFilePath(odlgOpenUnit.Files.Strings[z]));
        end
        else
        begin
          Application.MessageBox(PChar('The project "'+odlgOpenUnit.Files.Strings[z]+')" is already opened by LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
          Exit;
        end;
      end;
    end;
  end;

  // Rebuild the project tree and initialize stuff
  frmProjectTree.BuildProjectTree;
  CheckButtons;

  pReg.Free;
end;

procedure TfrmMain.AddFileInTab(pLuaUnit: TLuaUnit);
var
  synEdit: TSynEdit;
  HR: TSynLuaSyn;
  sJvTab: TJvTabBarItem;
begin
  sJvTab := jvUnitBar.AddTab(pLuaUnit.sName);
  sJvTab.Visible := False;
  sJvTab.Data := pLuaUnit;

  synEdit := TSynEdit.Create(Self);
  synEdit.MaxScrollWidth := 10000;
  synEdit.Parent := pnlMain;
  synEdit.Visible := False;
  synEdit.Align := alClient;
  synEdit.WantTabs := True;
  synEdit.ShowHint := True;
  synEdit.PopupMenu := ppmEditor;

  synEdit.OnChange := synEditChange;
  synEdit.OnDblClick := synEditDblClick;
  synEdit.OnMouseMove := synEditMouseMove;
  synEdit.OnMouseCursor := synEditMouseCursor;
  synEdit.OnReplaceText := SynEditReplaceText;
  synEdit.OnKeyUp := synEditKeyUp;
  synEdit.OnClick := synEditClick;
  synEdit.OnSpecialLineColors := synEditSpecialLineColors;
  synEdit.OnGutterClick := synEditGutterClick;

  HR := TSynLuaSyn.Create(nil);
  synEdit.Highlighter := HR;
  if not pLuaUnit.IsNew then
    synEdit.Lines.LoadFromFile(pLuaUnit.sUnitPath);

  pLuaUnit.pDebugPlugin := TDebugSupportPlugin.Create(synEdit);
  pLuaUnit.pDebugInfos.iCurrentLineDebug := -1;
  pLuaUnit.PrevLineNumber := synEdit.Lines.Count;
  pLuaUnit.synUnit := synEdit;
  pLuaUnit.synCompletion := GetBaseCompletionProposal();
  pLuaUnit.synParams := GetBaseParamsProposal();
  pLuaUnit.synParams.TriggerChars := '(';
  pLuaUnit.synParams.Editor := pLuaUnit.synUnit;
  pLuaUnit.synCompletion.Editor := pLuaUnit.synUnit;
  LuaOpenedUnits.Add(pLuaUnit);

  synEditClick(synEdit);
  jvUnitBar.SelectedTab := sJvTab;
  ApplyValuesToEditor(pLuaUnit.synUnit, EditorColors);
  pLuaUnit.synUnit.Parent := pnlMain;
  sJvTab.Visible := True;
  sJvTab.Selected := True;

  pLuaUnit.GetBreakpoints();
  frmBreakpoints.RefreshBreakpointList;
end;

function TfrmMain.AddFileInProject(sFilePath: String; IsNew: Boolean; pPrj: TLuaProject): TLuaUnit;
var
  pLuaUnit: TLuaUnit;
begin
  pLuaUnit := TLuaUnit.Create(sFilePath);
  pLuaUnit.sUnitPath := sFilePath;
  pLuaUnit.sName := ExtractFileName(sFilePath);
  pLuaUnit.pPrjOwner := pPrj;
  pLuaUnit.IsNew := IsNew;
  pLuaUnit.synUnit := nil;
  pPrj.lstUnits.Add(pLuaUnit);
  Result := pLuaUnit;
end;

// Add root to the changes notifier
procedure TfrmMain.AddToNotifier(sPath: String);
var
  pChangeNotifyItem: TJvChangeItem;
  x: Integer;
begin
  // make sure the actual given root is not already in list to
  // avoid overkill operations for no reasons
  for x := 0 to jvchnNotifier.Notifications.Count - 1 do
  begin
    if jvchnNotifier.Notifications[x].Directory = sPath then
      Exit;
  end;

  // Add new changes item to notifier and initialize some parameters
  pChangeNotifyItem := jvchnNotifier.Notifications.Add;
  pChangeNotifyItem.Directory := sPath;
  pChangeNotifyItem.IncludeSubTrees := True;
  pChangeNotifyItem.Actions := [caChangeAttributes, caChangeLastWrite]; 
end;

procedure TfrmMain.jvchnNotifierChangeNotify(Sender: TObject; Dir: String; Actions: TJvChangeActions);
var
  srSearchRec: TSearchRec;
  sFileName: String;
  pLuaUnit: TLuaUnit;
  pLuaPrj: TLuaProject;
  x: Integer;
  bNeedPrjTreeRebuild: Boolean;
  test: Double;
begin
  try
    // Try to find wich file(s) has changed
    if FindFirst(Dir+'\*.*', faAnyFile, srSearchRec) = 0 then
    begin
      bNeedPrjTreeRebuild := False;
         
      repeat
        sFileName := Dir+'\'+srSearchRec.Name;

        if FileExists(sFileName) then
        begin
          // Go through all opened unit
          for x := 0 to LuaOpenedUnits.Count - 1 do
          begin
            pLuaUnit := TLuaUnit(LuaOpenedUnits[x]);

            if sFileName = pLuaUnit.sUnitPath then
            begin
              // Compare dates and read only attr each others
              if ((pLuaUnit.LastTimeModified < GetFileLastTimeModified(PChar(sFileName))) or (pLuaUnit.IsReadOnly <> GetFileReadOnlyAttr(PChar(sFileName)))) then
              begin
                if Application.MessageBox(PChar('The file '+sFileName+' has been modified outside of the LuaEdit environnement. Do you want to reaload the file now?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
                begin
                  pLuaUnit.LastTimeModified := GetFileLastTimeModified(PChar(sFileName));
                  pLuaUnit.IsReadOnly := GetFileReadOnlyAttr(PChar(sFileName));
                  pLuaUnit.HasChanged := True;
                  pLuaUnit.synUnit.Lines.LoadFromFile(sFileName);
                  pLuaUnit.synUnit.Modified := True;
                  synEditChange(pLuaUnit.synUnit);
                  pLuaUnit.synUnit.Refresh;
                end;
              end;
            end;
          end;

          // Go through all projects
          for x := 0 to LuaProjects.Count - 1 do
          begin
            pLuaPrj := TLuaProject(LuaProjects[x]);

            if sFileName = pLuaPrj.sPrjPath then
            begin
              test := GetFileLastTimeModified(PChar(sFileName));
              if ((pLuaPrj.LastTimeModified < GetFileLastTimeModified(PChar(sFileName))) or (pLuaPrj.IsReadOnly <> GetFileReadOnlyAttr(PChar(sFileName)))) then
              begin
                if Application.MessageBox(PChar('The file '+sFileName+' has been modified outside of the LuaEdit environnement. Do you want to reaload the file now?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
                begin
                  bNeedPrjTreeRebuild := True;
                  pLuaPrj.LastTimeModified := GetFileLastTimeModified(PChar(sFileName));
                  pLuaPrj.IsReadOnly := GetFileReadOnlyAttr(PChar(sFileName));
                  pLuaPrj.HasChanged := True;
                  pLuaPrj.RealoadProject;
                end;
              end;
            end;
          end;
        end;
      until FindNext(srSearchRec) <> 0;
    end;
  finally
    // Do it once and only if we need it
    if bNeedPrjTreeRebuild then
      frmProjectTree.BuildProjectTree(False);

    FindClose(srSearchRec);
  end;
end;

procedure TfrmMain.synEditClick(Sender: TObject);
var
  synEditTemp: TSynEdit;
begin
  synEditTemp := TSynEdit(Sender);
  FirstClickPos := synEditTemp.CaretXY;
  stbMain.Panels[0].Text := 'Ln:'+IntToStr(synEditTemp.CaretY)+', Col:'+IntToStr(synEditTemp.CaretX);

  // Set caret mode adviser on status bar
  if synEditTemp.InsertMode then
    stbMain.Panels[1].Text := 'Insert'
  else
    stbMain.Panels[1].Text := 'Overwrite';

  // Set caps lock adviser on status bar
  if GetKeyState(VK_CAPITAL) = 1 then
    stbMain.Panels[2].Text := 'CAPS'
  else
    stbMain.Panels[2].Text := '';
end;

procedure TfrmMain.actOpenProjectExecute(Sender: TObject);
var
  pNewPrj: TLuaProject;
  x: integer;
  pReg: TRegistry;
begin
  pReg := TRegistry.Create;

  if pReg.OpenKey('\Software\LuaEdit', False) then
    odlgOpenProject.InitialDir := pReg.ReadString('RecentPath');

  if odlgOpenProject.Execute then
  begin
    for x := 0 to odlgOpenProject.Files.Count - 1 do
    begin
      if not IsProjectOpened(odlgOpenProject.Files.Strings[x]) then
      begin
        pNewPrj := TLuaProject.Create(odlgOpenProject.Files.Strings[x]);
        pNewPrj.GetProjectFromDisk(odlgOpenProject.Files.Strings[x]);

        // Rebuild the project tree
        frmProjectTree.BuildProjectTree;

        // Initialize and free stuff...
        CheckButtons;

        // Add opened file to recent opens
        pReg.OpenKey('\Software\LuaEdit', True);
        pReg.WriteString('RecentPath', ExtractFilePath(odlgOpenProject.Files.Strings[x]));
      end
      else
        Application.MessageBox(PChar('The project "'+odlgOpenProject.Files.Strings[x]+')" is already opened by LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
    end;
  end;

  pReg.Free;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Application.MainForm.Close;
end;

procedure TfrmMain.actSaveExecute(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
begin
  pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  if Assigned(pLuaUnit) then
  begin
    if SaveUnitsInc then
      pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
    else
      pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
  end;
end;

procedure TfrmMain.actSaveAsExecute(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
begin
  pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  if Assigned(pLuaUnit) then
  begin
    if SaveUnitsInc then
      pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath, False, True)
    else
      pLuaUnit.SaveUnit(pLuaUnit.sUnitPath, False, True);
  end;
end;

procedure TfrmMain.CheckButtons;
begin
  actClose.Enabled := not (LuaOpenedUnits.Count = 0);
  actSave.Enabled := not (LuaOpenedUnits.Count = 0);
  actSaveAs.Enabled := not (LuaOpenedUnits.Count = 0);
  actSaveProjectAs.Enabled := not (LuaOpenedUnits.Count = 0);
  actSaveAll.Enabled := not (LuaOpenedUnits.Count = 0);
  actSearch.Enabled := not (LuaOpenedUnits.Count = 0);
  actSearchAgain.Enabled := not (LuaOpenedUnits.Count = 0);
  actSearchReplace.Enabled := not (LuaOpenedUnits.Count = 0);
  actSelectAll.Enabled := not (LuaOpenedUnits.Count = 0);
  actGoToLine.Enabled := not (LuaOpenedUnits.Count = 0);
  actGotoLastEdited.Enabled := not (LuaOpenedUnits.Count = 0);
  actCut.Enabled := not (LuaOpenedUnits.Count = 0);
  actCopy.Enabled := not (LuaOpenedUnits.Count = 0);
  actPaste.Enabled := not (LuaOpenedUnits.Count = 0);
  actUndo.Enabled := not (LuaOpenedUnits.Count = 0);
  actRedo.Enabled := not (LuaOpenedUnits.Count = 0);
  actRunScript.Enabled := not (LuaOpenedUnits.Count = 0);
  actPause.Enabled := not (LuaOpenedUnits.Count = 0);
  actStop.Enabled := not (LuaOpenedUnits.Count = 0);
  actCheckSyntax.Enabled := not (LuaOpenedUnits.Count = 0);
  actStepInto.Enabled := not (LuaOpenedUnits.Count = 0);
  actStepOver.Enabled := not (LuaOpenedUnits.Count = 0);
  actRunToCursor.Enabled := not (LuaOpenedUnits.Count = 0);
  actAddBreakpoint.Enabled := not (LuaOpenedUnits.Count = 0);
  actPrint.Enabled := not (LuaOpenedUnits.Count = 0);
  actBlockIndent.Enabled := not (LuaOpenedUnits.Count = 0);
  actBlockUnindent.Enabled := not (LuaOpenedUnits.Count = 0);
  actBlockComment.Enabled := not (LuaOpenedUnits.Count = 0);
  actBlockUncomment.Enabled := not (LuaOpenedUnits.Count = 0);
  PrintSetup1.Enabled := not (LuaOpenedUnits.Count = 0);
  //HeaderBuilder1.Enabled := not (LuaOpenedUnits.Count = 0);

  if LuaOpenedUnits.Count > 0 then
  begin
    if Assigned(jvUnitBar.SelectedTab) then
    begin
      if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.UndoList.ItemCount = 0 then
        actUndo.Enabled := False
      else
        actUndo.Enabled := True;

      if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.RedoList.ItemCount = 0 then
        actRedo.Enabled := False
      else
        actRedo.Enabled := True;
    end
    else
    begin
      actUndo.Enabled := False;
      actRedo.Enabled := False;
    end;
  end;

  if Assigned(frmProjectTree.trvProjectTree.Selected) then
  begin
    if ((frmProjectTree.trvProjectTree.Selected.ImageIndex = 0) or (frmProjectTree.trvProjectTree.Selected.SelectedIndex = 0)) then
    begin
      actActiveSelPrj.Enabled := True;
    end
    else
    begin
      actActiveSelPrj.Enabled := False;
    end;
  end
  else
  begin
    actActiveSelPrj.Enabled := False;
  end;

  if Assigned(ActiveProject) then
  begin
    actAddToPrj.Enabled := True;
    actRemoveFromPrj.Enabled := True;
    actPrjSettings.Enabled := True;
    actSaveProjectAs.Enabled := True;
  end
  else
  begin
    actAddToPrj.Enabled := False;
    actRemoveFromPrj.Enabled := False;
    actPrjSettings.Enabled := False;
    actSaveProjectAs.Enabled := False;
  end;

  actNewProject.Enabled := True;
  actNewUnit.Enabled := True;
  actOpenFile.Enabled := True;
  actOpenProject.Enabled := True;
  actClose.Enabled := True;
  New1.Enabled := True;
  Reopen1.Enabled := True;
end;

procedure TfrmMain.actNewUnitExecute(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
  x, NewUnit: integer;
  FoundMatch: Boolean;
begin
  NewUnit := 1;

  for x := 0 to LuaOpenedUnits.Count - 1 do
  begin
    if TLuaUnit(LuaOpenedUnits.Items[x]).IsNew then
      Inc(NewUnit);
  end;

  FoundMatch := True;
  
  while FoundMatch do
  begin
    FoundMatch := False;
    for x := 0 to LuaOpenedUnits.Count - 1 do
    begin
      if 'Unit'+IntToStr(NewUnit)+'.lua' = TLuaUnit(LuaOpenedUnits.Items[x]).sName then
      begin
        Inc(NewUnit);
        FoundMatch := True;
      end;
    end;
  end;  

  pLuaUnit := AddFileInProject('Unit'+IntToStr(NewUnit)+'.lua', True, LuaSingleUnits);
  pLuaUnit.IsLoaded := True;
  AddFileInTab(pLuaUnit);
  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmMain.actNewProjectExecute(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
  pNewLuaPrj: TLuaProject;
  x, NewUnit, NewProject: integer;
  FoundMatch: Boolean;
begin
  NewProject := 1;

  for x := 0 to LuaProjects.Count - 1 do
  begin
    if TLuaProject(LuaProjects.Items[x]).IsNew then
      Inc(NewProject);
  end;

  FoundMatch := True;

  while FoundMatch do
  begin
    FoundMatch := False;
    for x := 0 to LuaProjects.Count - 1 do
    begin
      if 'Project'+IntToStr(NewProject) = TLuaProject(LuaProjects.Items[x]).sPrjName then
      begin
        Inc(NewProject);
        FoundMatch := True;
      end;
    end;
  end;

  pNewLuaPrj := TLuaProject.Create('');
  pNewLuaPrj.sPrjName := 'Project'+IntToStr(NewProject);
  pNewLuaPrj.sPrjPath := 'C:\';
  pNewLuaPrj.IsNew := True;
  LuaProjects.Add(pNewLuaPrj);
  ActiveProject := pNewLuaPrj;

  NewUnit := 1;

  for x := 0 to LuaOpenedUnits.Count - 1 do
  begin
    if TLuaUnit(LuaOpenedUnits.Items[x]).IsNew then
      Inc(NewUnit);
  end;

  pLuaUnit := AddFileInProject('Unit'+IntToStr(NewUnit)+'.lua', True, pNewLuaPrj);
  pLuaUnit.IsLoaded := True;
  AddFileInTab(pLuaUnit);
  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  pReg: TRegistry;
begin
{$ifdef RTASSERT} RTAssert(0, true, ' TfrmMain.FormDestroy', '', 0); {$endif}
  // Write last windows settings
  pReg := TRegistry.Create;
  pReg.OpenKey('\Software\LuaEdit', True);
  pReg.WriteBool('WasMaxed', (Self.WindowState = wsMaximized));
  pReg.WriteInteger('Width', Self.Width);
  pReg.WriteInteger('Height', Self.Height);
  pReg.Free;

  // Free previously created objects
  LuaProjects.Free;
  LuaSingleUnits.Free;
  LuaOpenedUnits.Free;
  LibrariesSearchPaths.Free;
  ReplacedText.Free;
  SearchedText.Free;
  lstStack.Free;
  lstLuaStack.Free;
  lstLocals.Free;
  lstGlobals.Free;
  EditorColors.Free;
  LookupList.Free;
  CallStack.Free;
{$ifdef RTASSERT} RTAssert(0, true, ' TfrmMain.FormDestroy Done', '', 0); {$endif}
end;

procedure TfrmMain.actSaveProjectAsExecute(Sender: TObject);
begin
  if SaveProjectsInc then
    ActiveProject.SaveProjectInc(sdlgSaveAsPrj.FileName, False, True)
  else
    ActiveProject.SaveProject(sdlgSaveAsPrj.FileName, False, True);
    
  RefreshOpenedUnits;
  frmProjectTree.BuildProjectTree;
end;

procedure TfrmMain.actSaveAllExecute(Sender: TObject);
var
  x, y: integer;
  pLuaPrj: TLuaProject;
  pLuaUnit: TLuaUnit;
begin
  for x := 0 to LuaProjects.Count - 1 do
  begin
    pLuaPrj := TLuaProject(LuaProjects.Items[x]);
    
    for y := 0 to pLuaPrj.lstUnits.Count - 1 do
    begin
      pLuaUnit := TLuaUnit(pLuaPrj.lstUnits.Items[y]);

      if SaveUnitsInc then
        pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
      else
        pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
    end;
    
    if pLuaPrj.sPrjName <> '[@@SingleUnits@@]' then
    begin
      if SaveProjectsInc then
        pLuaPrj.SaveProjectInc(pLuaPrj.sPrjPath)
      else
        pLuaPrj.SaveProject(pLuaPrj.sPrjPath);
    end;
  end;

  frmProjectTree.BuildProjectTree;
end;

procedure TfrmMain.actCloseExecute(Sender: TObject);
begin
  ClosingUnit;
  jvUnitBar.SelectedTab.Destroy;

  // Initialize stuff...
  CheckButtons;
  frmProjectTree.BuildProjectTree;
  frmBreakpoints.RefreshBreakpointList;
end;

procedure TfrmMain.ClosingUnit();
var
  Answer: Integer;
begin
  if ((TLuaUnit(jvUnitBar.SelectedTab.Data).HasChanged) or (TLuaUnit(jvUnitBar.SelectedTab.Data).IsNew)) then
  begin
    Answer := Application.MessageBox(PChar('Do you want to save "'+TLuaUnit(jvUnitBar.SelectedTab.Data).sUnitPath+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
    if Answer = IDYES then
      actSaveExecute(nil)
    else if Answer = IDCANCEL then
      Exit
    else
      TLuaUnit(jvUnitBar.SelectedTab.Data).pPrjOwner.lstUnits.Remove(TLuaUnit(jvUnitBar.SelectedTab.Data));
  end;

  // Remove file from global opened file list
  LuaOpenedUnits.Remove(TLuaUnit(jvUnitBar.SelectedTab.Data));
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Visible := False;
end;

procedure TfrmMain.BuildReopenMenu;
var
  pReg: TRegistry;
  lstValues: TStringList;
  x: integer;

  // This method add a submenu to the given reopen menu
  procedure AddMenu(pOnClick: TNotifyEvent; AOwner: TComponent; sCaption: String; bEnabled: Boolean = True);
  var
    pNewMenu: TMenuItem;
  begin
    pNewMenu := TMenuItem.Create(AOwner);
    pNewMenu.Caption := sCaption;
    pNewMenu.Enabled := bEnabled;
    pNewMenu.OnClick := pOnClick;
    if AOwner.ClassType = TMenuItem then
      TMenuItem(AOwner).Add(pNewMenu)
    else if AOwner.ClassType = TPopupMenu then
      TPopupMenu(AOwner).Items.Add(pNewMenu);

  end;

  // This method add a button to the ring engine
  procedure AddOBButton(pOnClick: TNotifyEvent; iPageIndex: Integer; sCaption: String; bEnabled: Boolean = True);
  var
    jvOBBtn: TJvOutlookBarButton;
  begin
    jvOBBtn := frmRings.jvRings.Pages[iPageIndex].Buttons.Add();
    jvOBBtn.Caption := sCaption;
    jvOBBtn.Enabled := bEnabled;
    jvOBBtn.OnClick := pOnClick;
  end;
begin
  Reopen1.Clear;
  mnuReopen.Items.Clear;
  frmRings.jvRings.Pages[JVPAGE_RING_FILES].Buttons.Clear;
  pReg := TRegistry.Create;
  
  if pReg.OpenKey('\Software\LuaEdit\RecentFiles', False) then
  begin
    lstValues := TStringList.Create;
    pReg.GetValueNames(lstValues);

    // Create (Empty) menus if no reopen values in registry
    if lstValues.Count = 0 then
    begin
      //Popup menu adding
      AddMenu(nil, mnuReopen, '(Empty)', False);
      //Main menu adding
      AddMenu(nil, Reopen1, '(Empty)', False);
      // Recent files ring adding
      AddOBButton(nil, JVPAGE_RING_FILES, '(Empty)', False);
    end
    else
    begin
      // Add project first...
      for x := 0 to lstValues.Count - 1 do
      begin
        if ExtractFileExt(lstValues.Strings[x]) = '.lpr' then
        begin
          //Popup menu adding
          AddMenu(mnuXReopenClick, mnuReopen, lstValues.Strings[x]);
          //Main menu adding
          AddMenu(mnuXReopenClick, Reopen1, lstValues.Strings[x]);
          // Recent files ring adding
          AddOBButton(btnXFilesClick, JVPAGE_RING_FILES, lstValues.Strings[x]);
        end;
      end;

      // Add seperators...
      if mnuReopen.Items.Count > 0 then
      begin
        //Popup menu adding
        AddMenu(nil, mnuReopen, '-');
        //Main menu adding
        AddMenu(nil, Reopen1, '-');
      end;

      // Add unit after seperators and projects
      for x := 0 to lstValues.Count - 1 do
      begin
        if ExtractFileExt(lstValues.Strings[x]) = '.lua' then
        begin
          //Popup menu adding
          AddMenu(mnuXReopenClick, mnuReopen, lstValues.Strings[x]);
          //Main menu adding
          AddMenu(mnuXReopenClick, Reopen1, lstValues.Strings[x]);
          // Recent files ring adding
          AddOBButton(btnXFilesClick, JVPAGE_RING_FILES, lstValues.Strings[x]);
        end;
      end;
    end;

    // Free list
    lstValues.Free;
  end
  else     // Create (Empty) menus if no reopen values in registry
  begin
    //Popup menu adding
    AddMenu(nil, mnuReopen, '(Empty)', False);
    //Main menu adding
    AddMenu(nil, Reopen1, '(Empty)', False);
    // Recent files ring adding
    AddOBButton(nil, JVPAGE_RING_FILES, '(Empty)', False);
  end;

  // Repaint some non overriden component on runtime
  xmpMenuPainter.InitComponent(mnuReopen);
  xmpMenuPainter.ActivateMenuItem(Reopen1, True);

  pReg.Free;
end;

function TfrmMain.IsReopenInList(sString: String): Boolean;
var
  pReg: TRegistry;
  sReturn: String;
begin
  pReg := TRegistry.Create;
  Result := False;
  
  if pReg.OpenKey('\Software\LuaEdit\RecentFiles', False) then
  begin
    sReturn := pReg.ReadString('sString');
    if sReturn <> '' then
      Result := True;
  end;

  pReg.Free;
end;

procedure TfrmMain.MonitorFile(sString: String);
var
  pReg: TRegistry;
  lstValues: TStringList;
  x: integer;
  ValMax: integer;
  iMaxHigh: integer;
begin
  pReg := TRegistry.Create;

  if not IsReopenInList(sString) then
  begin
    lstValues := TStringList.Create;
    pReg.OpenKey('\Software\LuaEdit\RecentFiles', True);
    pReg.GetValueNames(lstValues);

    if lstValues.Count >= 20 then
    begin
      ValMax := 0;
      iMaxHigh := 0;
      
      for x := 0 to lstValues.Count - 1 do
      begin
        if ValMax < pReg.ReadInteger(lstValues.Strings[x]) then
        begin
          iMaxHigh := x;
          ValMax := pReg.ReadInteger(lstValues.Strings[x])
        end;

        pReg.WriteInteger(lstValues.Strings[x], pReg.ReadInteger(lstValues.Strings[x]) + 1);
      end;

      pReg.DeleteValue(lstValues.Strings[iMaxHigh]);
    end;

    pReg.WriteInteger(sString, 0);
    lstValues.Free;
    //BuildReopenMenu;
  end;

  pReg.Free;
end;

procedure TfrmMain.actMainMenuFileExecute(Sender: TObject);
begin
  CloseUnit1.Enabled := (jvUnitBar.Tabs.Count > 0);
end;

procedure TfrmMain.actMainMenuEditExecute(Sender: TObject);
begin
  // do nothing
end;

procedure TfrmMain.actMainMenuViewExecute(Sender: TObject);
begin
  File2.Checked := tlbBaseFile.Visible;
  Edit2.Checked := tlbEdit.Visible;
  Run1.Checked := tlbRun.Visible;
  File3.Checked := tlbBaseFile.Visible;
  Edit3.Checked := tlbEdit.Visible;
  Run4.Checked := tlbRun.Visible;
  actShowMessages.Checked := frmLuaEditMessages.Visible;
  actShowProjectTree.Checked := frmProjectTree.Visible;
  actShowWatchList.Checked := frmWatch.Visible;
  actShowCallStack.Checked := frmStack.Visible;
  actShowLuaStack.Checked := frmLuaStack.Visible;
  actShowLuaOutput.Checked := frmLuaOutput.Visible;
  actShowBreakpoints.Checked := frmBreakpoints.Visible;
  actShowLuaGlobals.Checked := frmLuaGlobals.Visible;
  actShowLuaLocals.Checked := frmLuaLocals.Visible;
  actShowRings.Checked := frmRings.Visible;
  actShowFunctionList.Checked := frmFunctionList.Visible;
end;

procedure TfrmMain.actMainMenuProjectExecute(Sender: TObject);
begin
  // do nothing
end;

procedure TfrmMain.actMainMenuRunExecute(Sender: TObject);
begin
  // do nothing
end;

procedure TfrmMain.actMainMenuToolsExecute(Sender: TObject);
begin
  // do nothing
end;

procedure TfrmMain.actMainMenuHelpExecute(Sender: TObject);
begin
  // do nothing
end;

procedure TfrmMain.actShowProjectTreeExecute(Sender: TObject);
begin
  actShowProjectTree.Checked := not actShowProjectTree.Checked;
  frmProjectTree.Visible := actShowProjectTree.Checked;

  if actShowProjectTree.Checked then
    ShowDockForm(frmProjectTree)
  else
    HideDockForm(frmProjectTree);
end;

procedure TfrmMain.actShowBreakpointsExecute(Sender: TObject);
begin
  actShowBreakpoints.Checked := not actShowBreakpoints.Checked;
  frmBreakpoints.Visible := actShowBreakpoints.Checked;

  if actShowBreakpoints.Checked then
    ShowDockForm(frmBreakpoints)
  else
    HideDockForm(frmBreakpoints);
end;

procedure TfrmMain.actShowMessagesExecute(Sender: TObject);
begin
  actShowMessages.Checked := not actShowMessages.Checked;
  frmLuaEditMessages.Visible := actShowMessages.Checked;

  if actShowMessages.Checked then
    ShowDockForm(frmLuaEditMessages)
  else
    HideDockForm(frmLuaEditMessages);
end;

procedure TfrmMain.actShowWatchListExecute(Sender: TObject);
begin
  actShowWatchList.Checked := not actShowWatchList.Checked;
  frmWatch.Visible := actShowWatchList.Checked;

  if actShowWatchList.Checked then
    ShowDockForm(frmWatch)
  else
    HideDockForm(frmWatch);
end;

procedure TfrmMain.actShowCallStackExecute(Sender: TObject);
begin
  actShowCallStack.Checked := not actShowCallStack.Checked;
  frmStack.Visible := actShowCallStack.Checked;

  if actShowCallStack.Checked then
    ShowDockForm(frmStack)
  else
    HideDockForm(frmStack);
end;

procedure TfrmMain.actShowLuaStackExecute(Sender: TObject);
begin
  actShowLuaStack.Checked := not actShowLuaStack.Checked;
  frmLuaStack.Visible := actShowLuaStack.Checked;

  if actShowLuaStack.Checked then
    ShowDockForm(frmLuaStack)
  else
    HideDockForm(frmLuaStack);
end;

procedure TfrmMain.actShowLuaOutputExecute(Sender: TObject);
begin
  actShowLuaOutput.Checked := not actShowLuaOutput.Checked;
  frmLuaOutput.Visible := actShowLuaOutput.Checked;

  if actShowLuaOutput.Checked then
    ShowDockForm(frmLuaOutput)
  else
    HideDockForm(frmLuaOutput);
end;

procedure TfrmMain.actShowLuaGlobalsExecute(Sender: TObject);
begin
  actShowLuaGlobals.Checked := not actShowLuaGlobals.Checked;
  frmLuaGlobals.Visible := actShowLuaGlobals.Checked;

  if actShowLuaGlobals.Checked then
    ShowDockForm(frmLuaGlobals)
  else
    HideDockForm(frmLuaGlobals);
end;

procedure TfrmMain.actShowLuaLocalsExecute(Sender: TObject);
begin
  actShowLuaLocals.Checked := not actShowLuaLocals.Checked;
  frmLuaLocals.Visible := actShowLuaLocals.Checked;

  if actShowLuaLocals.Checked then
    ShowDockForm(frmLuaLocals)
  else
    HideDockForm(frmLuaLocals);
end;

procedure TfrmMain.actShowRingsExecute(Sender: TObject);
begin
  actShowRings.Checked := not actShowRings.Checked;
  frmRings.Visible := actShowRings.Checked;

  if actShowRings.Checked then
    ShowDockForm(frmRings)
  else
    HideDockForm(frmRings);
end;

procedure TfrmMain.actShowFunctionListExecute(Sender: TObject);
begin
  actShowFunctionList.Checked := not actShowFunctionList.Checked;
  frmFunctionList.Visible := actShowFunctionList.Checked;

  if actShowFunctionList.Checked then
    ShowDockForm(frmFunctionList)
  else
    HideDockForm(frmFunctionList);
end;

procedure TfrmMain.mnuXReopenClick(Sender: TObject);
var
  pNewPrj: TLuaProject;
  pLuaUnit: TLuaUnit;
  mnuSender: TMenuItem;
  pReg: TRegistry;
  BuildTreeNeeded: Boolean;
  x: Integer;
begin
  BuildTreeNeeded := False;
  mnuSender := TMenuItem(Sender);
  
  if FileExists(mnuSender.Caption) then
  begin
    if ExtractFileExt(mnuSender.Caption) = '.lua' then
    begin
      if not FileIsInTree(mnuSender.Caption) then
      begin
        pLuaUnit := AddFileInProject(mnuSender.Caption, False, LuaSingleUnits);
        pLuaUnit.IsLoaded := True;
        AddFileInTab(pLuaUnit);
        MonitorFile(mnuSender.Caption);
        BuildTreeNeeded := True;
      end
      else
        Application.MessageBox(PChar('The project "'+mnuSender.Caption+')" is already opened by LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
    end
    else if ExtractFileExt(mnuSender.Caption) = '.lpr' then
    begin
      if not IsProjectOpened(mnuSender.Caption) then
      begin
        pNewPrj := TLuaProject.Create(mnuSender.Caption);
        pNewPrj.GetProjectFromDisk(mnuSender.Caption);
        BuildTreeNeeded := True;
      end
      else
        Application.MessageBox(PChar('The project "'+mnuSender.Caption+')" is already opened by LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
    end;
  end
  else
  begin
    Application.MessageBox(PChar('The file "'+mnuSender.Caption+'" is innexistant and will be removed from the list.'), 'LuaEdit', MB_OK+MB_ICONERROR);

    // Remove entry from registry
    pReg := TRegistry.Create;
    if pReg.OpenKey('\Software\LuaEdit\RecentFiles', False) then
    begin
      if pReg.ValueExists(mnuSender.Caption) then
        pReg.DeleteValue(mnuSender.Caption);
    end;

    // Remove ring button from the list
    for x := 0 to frmRings.jvRings.Pages[JVPAGE_RING_FILES].Buttons.Count - 1 do
    begin
      if frmRings.jvRings.Pages[JVPAGE_RING_FILES].Buttons[x].Caption = mnuSender.Caption then
      begin
        frmRings.jvRings.Pages[JVPAGE_RING_FILES].Buttons.Delete(x);
        Break;
      end;
    end;

    // Remove menu from the other reopen menu
    if mnuSender.Owner.ClassType <> TPopupMenu then
    begin
      for x := 0 to mnuReopen.Items.Count - 1 do
      begin
        if mnuReopen.Items[x].Caption = mnuSender.Caption then
        begin
          mnuReopen.Items.Delete(x);
          Break;
        end;
      end;
    end
    else
    begin
      for x := 0 to Reopen1.Count - 1 do
      begin
        if Reopen1.Items[x].Caption = mnuSender.Caption then
        begin
          Reopen1.Delete(x);
          Break;
        end;
      end;
    end;

    // Remove itself from the list
    mnuSender.Free;
  end;

  // Rebuild tree view and initialize stuff
  if BuildTreeNeeded then
  begin
    frmProjectTree.BuildProjectTree;
    CheckButtons;
  end;
end;

// Trigered when user clicks on a ring button of the "Files" slide bar
procedure TfrmMain.btnXFilesClick(Sender: TObject);
var
  pNewPrj: TLuaProject;
  pLuaUnit: TLuaUnit;
  btnSender: TJvOutlookBarButton;
  pReg: TRegistry;
  BuildTreeNeeded: Boolean;
  x: Integer;
begin
  BuildTreeNeeded := False;
  btnSender := TJvOutlookBarButton(Sender);

  if FileExists(btnSender.Caption) then
  begin
    if ExtractFileExt(btnSender.Caption) = '.lua' then
    begin
      if not FileIsInTree(btnSender.Caption) then
      begin
        pLuaUnit := AddFileInProject(btnSender.Caption, False, LuaSingleUnits);
        pLuaUnit.IsLoaded := True;
        AddFileInTab(pLuaUnit);
        MonitorFile(btnSender.Caption);
        BuildTreeNeeded := True;
      end
      else
        Application.MessageBox(PChar('The project "'+btnSender.Caption+')" is already opened by LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
    end
    else if ExtractFileExt(btnSender.Caption) = '.lpr' then
    begin
      if not IsProjectOpened(btnSender.Caption) then
      begin
        pNewPrj := TLuaProject.Create(btnSender.Caption);
        pNewPrj.GetProjectFromDisk(btnSender.Caption);
        BuildTreeNeeded := True;
      end
      else
        Application.MessageBox(PChar('The project "'+btnSender.Caption+')" is already opened by LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
    end;
  end
  else
  begin
    Application.MessageBox(PChar('The file "'+btnSender.Caption+'" is innexistant and will be removed from the list.'), 'LuaEdit', MB_OK+MB_ICONERROR);

    // Remove entry from registry
    pReg := TRegistry.Create;
    if pReg.OpenKey('\Software\LuaEdit\RecentFiles', False) then
    begin
      if pReg.ValueExists(btnSender.Caption) then
        pReg.DeleteValue(btnSender.Caption);
    end;

    // Remove menu from the two reopen menus
    for x := 0 to mnuReopen.Items.Count - 1 do
    begin
      if mnuReopen.Items[x].Caption = btnSender.Caption then
      begin
        mnuReopen.Items.Delete(x);
        Break;
      end;
    end;

    for x := 0 to Reopen1.Count - 1 do
    begin
      if Reopen1.Items[x].Caption = btnSender.Caption then
      begin
        Reopen1.Delete(x);
        Break;
      end;
    end;

    // Remove itself from the list
    btnSender.Free;
  end;

  // Rebuild tree view and initialize stuff
  if BuildTreeNeeded then
  begin
    frmProjectTree.BuildProjectTree;
    CheckButtons;
  end;
end;

procedure TfrmMain.btnXClipboardClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(TJvOutlookBarButton(Sender).Caption));
end;

function TfrmMain.IsProjectOpened(sProjectPath: String): Boolean;
var
  x: integer;
begin
  Result := False;
  
  for x := 0 to LuaProjects.Count -  1 do
  begin
    if TLuaProject(LuaProjects.Items[x]).sPrjPath = sProjectPath then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TfrmMain.actUndoExecute(Sender: TObject);
begin
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Undo;

  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.UndoList.ItemCount = 0 then
    actUndo.Enabled := False
  else
    actUndo.Enabled := True;

  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.RedoList.ItemCount = 0 then
    actRedo.Enabled := False
  else
    actRedo.Enabled := True;
end;

procedure TfrmMain.actRedoExecute(Sender: TObject);
begin
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Redo;

  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.UndoList.ItemCount = 0 then
    actUndo.Enabled := False
  else
    actUndo.Enabled := True;

  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.RedoList.ItemCount = 0 then
    actRedo.Enabled := False
  else
    actRedo.Enabled := True;
end;

procedure TfrmMain.actCutExecute(Sender: TObject);
var
  jvOBBtn: TJvOutlookBarButton;
  x: Integer;
  pLuaUnit: TLuaUnit;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);
  
      if pLuaUnit.synUnit.SelText <> '' then
      begin
        pLuaUnit.synUnit.CutToClipboard;

        // Make sure we don't add content that was already there
        for x := 0 to frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Count - 1 do
        begin
          if frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons[x].Caption = pLuaUnit.synUnit.SelText then
          begin
            frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons[x].Free;
            Break;
          end;
        end;

        // Remove last item if already 10 are listed
        if frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Count = 10 then
          frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Delete(9);

        jvOBBtn := frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Insert(0);
        jvOBBtn.Caption := Clipboard.AsText;
        jvOBBtn.OnClick := btnXClipboardClick;
      end;
    end;
  end;
end;

procedure TfrmMain.actCopyExecute(Sender: TObject);
var
  jvOBBtn: TJvOutlookBarButton;
  x: Integer;
  pLuaUnit: TLuaUnit;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);
      if pLuaUnit.synUnit.SelText <> '' then
      begin
        pLuaUnit.synUnit.CopyToClipboard;

        // Make sure we don't add content that was already there
        for x := 0 to frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Count - 1 do
        begin
          if frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons[x].Caption = pLuaUnit.synUnit.SelText then
          begin
            frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons[x].Free;
            Break;
          end;
        end;

        // Remove last item if already 10 are listed
        if frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Count = 10 then
          frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Delete(9);

        jvOBBtn := frmRings.jvRings.Pages[JVPAGE_RING_CLIPBOARD].Buttons.Insert(0);
        jvOBBtn.Caption := Clipboard.AsText;
        jvOBBtn.OnClick := btnXClipboardClick;
      end;
    end;
  end;
end;

procedure TfrmMain.actPasteExecute(Sender: TObject);
begin
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.PasteFromClipboard;
end;

procedure TfrmMain.actSelectAllExecute(Sender: TObject);
begin
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelectAll;
end;

procedure TfrmMain.actSearchExecute(Sender: TObject);
var
  Options: TSynSearchOptions;
begin
  frmSearch.chkRegularExpression.Checked := srSearchRegularExpression;
  frmSearch.chkSearchCaseSensitive.Checked := srSearchSensitive;
  frmSearch.chkSearchWholeWords.Checked := srSearchWholeWords;
  frmSearch.optOrigin.ItemIndex := srSearchOrigin;
  frmSearch.optScope.ItemIndex := srSearchScope;
  frmSearch.optDirection.ItemIndex := srSearchDriection;
  frmSearch.cboSearchText.Items.AddStrings(SearchedText);

  if SearchedText.Count > 0 then
    frmSearch.cboSearchText.Text := SearchedText.Strings[SearchedText.Count - 1];
  
  if ((TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail) and (TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockBegin.Line = TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockEnd.Line)) then
    frmSearch.cboSearchText.Text := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText
  else
    frmSearch.cboSearchText.Text := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY);

  frmSearch.ShowModal;
  if frmSearch.SearchText <> '' then
  begin
    Options := [];
    srSearchRegularExpression := frmSearch.IsResgularExpression;
    srSearchSensitive := frmSearch.IsCaseSensitive;
    if srSearchSensitive then
      Options := Options + [ssoMatchCase];

    srSearchWholeWords := frmSearch.IsWholeWordOnly;
    if srSearchWholeWords then
      Options := Options + [ssoWholeWord];

    srSearchOrigin := frmSearch.GetOrigin;
    if srSearchOrigin = SR_ENTIRESCOPE then
      Options := Options + [ssoEntireScope];

    srSearchScope := frmSearch.GetScope;
    if srSearchScope = SR_SELECTED then
      Options := Options + [ssoSelectedOnly];

    srSearchDriection := frmSearch.GetDirection;
    if srSearchDriection = SR_BACKWARD then
      Options := Options + [ssoBackwards];

    sSearchString := frmSearch.SearchText;
    SearchedText.Add(sSearchString);

    if srSearchRegularExpression then
      TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearch
    else
      TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearchRegEx;
    
    if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchReplace(sSearchString, '', Options) = 0 then
    begin
      Application.MessageBox(PChar('Search string "'+sSearchString+'" not found.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
    end;
  end;
end;

procedure TfrmMain.actSearchAgainExecute(Sender: TObject);
var
  Options: TSynSearchOptions;
begin
  Options := [];

  if srSearchSensitive then
    Options := Options + [ssoMatchCase];

  if srSearchWholeWords then
    Options := Options + [ssoWholeWord];

  if srSearchOrigin = SR_ENTIRESCOPE then
    Options := Options + [ssoEntireScope];

  if srSearchScope = SR_SELECTED then
    Options := Options + [ssoSelectedOnly];

  if srSearchDriection = SR_BACKWARD then
    Options := Options + [ssoBackwards];

  if not srSearchRegularExpression then
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearch
  else
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearchRegEx;
    
  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchReplace(sSearchString, '', Options) = 0 then
  begin
    Application.MessageBox(PChar('Search string "'+sSearchString+'" not found.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
  end;
end;

procedure TfrmMain.actSearchReplaceExecute(Sender: TObject);
var
  Options: TSynSearchOptions;
begin
  frmReplace.chkRegularExpression.Checked := srSearchRegularExpression;
  frmReplace.chkSearchCaseSensitive.Checked := srSearchSensitive;
  frmReplace.chkSearchWholeWords.Checked := srSearchWholeWords;
  frmReplace.optOrigin.ItemIndex := srSearchOrigin;
  frmReplace.optScope.ItemIndex := srSearchScope;
  frmReplace.optDirection.ItemIndex := srSearchDriection;
  frmReplace.cboSearchText.Items.AddStrings(SearchedText);
  frmReplace.cboReplaceText.Items.AddStrings(ReplacedText);

  if SearchedText.Count > 0 then
    frmReplace.cboSearchText.Text := SearchedText.Strings[SearchedText.Count - 1];
  
  if ((TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail) and (TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockBegin.Line = TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockEnd.Line)) then
    frmReplace.cboSearchText.Text := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText
  else
    frmReplace.cboSearchText.Text := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY);

  frmReplace.ShowModal;
  if frmReplace.SearchText <> '' then
  begin
    Options := [ssoReplace];
    srSearchRegularExpression := frmReplace.IsResgularExpression;

    srReplaceAll := frmReplace.IsReplaceAll;
    if srReplaceAll then
      Options := Options + [ssoReplaceAll];

    srPromptForReplace := frmReplace.IsPromptForReplace;
    if srPromptForReplace then
      Options := Options + [ssoPrompt];

    srSearchSensitive := frmReplace.IsCaseSensitive;
    if srSearchSensitive then
      Options := Options + [ssoMatchCase];

    srSearchWholeWords := frmReplace.IsWholeWordOnly;
    if srSearchWholeWords then
      Options := Options + [ssoWholeWord];

    srSearchOrigin := frmReplace.GetOrigin;
    if srSearchOrigin = SR_ENTIRESCOPE then
      Options := Options + [ssoEntireScope];

    srSearchScope := frmReplace.GetScope;
    if srSearchScope = SR_SELECTED then
      Options := Options + [ssoSelectedOnly];

    srSearchDriection := frmReplace.GetDirection;
    if srSearchDriection = SR_BACKWARD then
      Options := Options + [ssoBackwards];

    sSearchString := frmReplace.SearchText;
    sReplaceString := frmReplace.ReplaceText;
    ReplacedText.Add(sReplaceString);
    SearchedText.Add(sSearchString);

    if not srSearchRegularExpression then
      TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearch
    else
      TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearchRegEx;
    
    if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchReplace(sSearchString, sReplaceString, Options) = 0 then
    begin
      Application.MessageBox(PChar('Search string "'+sSearchString+'" not found.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
    end;
  end;
end;

procedure TfrmMain.SynEditReplaceText(Sender: TObject; const ASearch, AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  Pos: TPoint;
  EditRect: TRect;
  synEdit: TSynEdit;
begin
  synEdit := TSynEdit(Sender);

  if srPromptForReplace then
  begin
    Pos := synEdit.ClientToScreen(synEdit.RowColumnToPixels(synEdit.BufferToDisplayPos(BufferCoord(Column, Line))));
    EditRect := ClientRect;
    EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
    EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);
    frmReplaceQuerry.Prepare(EditRect, Pos.X, Pos.Y, Pos.Y + synEdit.LineHeight, ASearch);
    case frmReplaceQuerry.ShowModal of
      mrYes: Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo: Action := raSkip;
      else Action := raCancel;
    end;
  end
  else if srReplaceAll then
  begin
    Action := raReplaceAll;
  end;
end;

procedure TfrmMain.actGoToLineExecute(Sender: TObject);
begin
  frmGotoLine.txtLineNumber.Text := '';
  
  if frmGotoLine.ShowModal = mrOK then
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(frmGotoLine.LineNumber);
end;

procedure TfrmMain.actGotoLastEditedExecute(Sender: TObject);
begin
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(TLuaUnit(jvUnitBar.SelectedTab.Data).LastEditedLine);
end;

procedure TfrmMain.AboutLuaEdit1Click(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

// This function manage debug actions in general and handle initialization of debug session
procedure TfrmMain.CustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
var
  L: Plua_State;
  FileName: string;
  x, NArgs: Integer;
  pLuaUnit: TLuaUnit;
  iDoLuaOpen :Boolean;

  procedure OpenLibs(L: PLua_State);
  begin
    luaopen_base(L);
    luaopen_table(L);
    luaopen_io(L);
    luaopen_string(L);
    luaopen_math(L);
    luaopen_debug(L);
    luaopen_loadlib(L);
    lua_settop(L, 0);
  end;

  procedure UninitializeUnits;
  var
    x, y: Integer;
    pLuaUnit: TLuaUnit;
  begin
    // Uninitialize opened units
    for x := 0 to frmMain.jvUnitBar.Tabs.Count - 1 do
    begin
      pLuaUnit := TLuaUnit(frmMain.jvUnitBar.Tabs[x].Data);
      pLuaUnit.pDebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.synUnit.Refresh;

      // Reset all breakpoints hitcount to 0
      for y := 0 to pLuaUnit.pDebugInfos.lstBreakpoint.Count - 1 do
        TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint[y]).iHitCount := 0;
    end;

    if Assigned(frmMain.jvUnitBar.SelectedTab) then
      TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;

    frmBreakpoints.RefreshBreakpointList;
    frmMain.stbMain.Refresh;
  end;

  procedure InitializeUnits;
  var
    x, y: Integer;
    pLuaUnit: TLuaUnit;
  begin
    // Initialize opened units
    for x := 0 to frmMain.jvUnitBar.Tabs.Count - 1 do
    begin
      pLuaUnit := TLuaUnit(frmMain.jvUnitBar.Tabs[x].Data);
      pLuaUnit.synUnit.Modified := False;
      pLuaUnit.pDebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.pDebugInfos.iLineError := -1;
      pLuaUnit.synUnit.Refresh;

      // Reset all breakpoints hitcount to 0
      for y := 0 to pLuaUnit.pDebugInfos.lstBreakpoint.Count - 1 do
        TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint[y]).iHitCount := 0;
    end;

    if Assigned(frmMain.jvUnitBar.SelectedTab) then
      TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;

    frmBreakpoints.RefreshBreakpointList;
    frmMain.stbMain.Refresh;
  end;

  procedure SetPause(pLuaUnit: TLuaUnit);
  begin
    if (not Pause) then
    begin
      pLuaUnit.pDebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.pDebugInfos.iStackMarker := -1;

      if Assigned(pCurrentSynEdit) then
        pCurrentSynEdit.Refresh;
    end;
    
    Self.Pause := Pause;
    Self.PauseICI := PauseICI;
    Self.PauseLine := PauseLine;
    Self.PauseFile := PauseFile;
  end;

  function Initializer(L: PLua_State): Boolean;
  begin
    Result := True;

    if TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pPrjOwner.sInitializer <> '' then
    begin
      if frmMain.ExecuteInitializer(TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pPrjOwner.sInitializer, L) < 0 then
      begin
        Application.MessageBox('An error occured while executing the initializer function.', 'LuaEdit', MB_OK+MB_ICONERROR);
        frmMain.CheckButtons;
        FreeLibrary(hModule);
        Result := False;
      end;
    end;
  end;
begin
  if Assigned(frmMain.jvUnitBar.SelectedTab) then
    pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  if Assigned(pLuaUnit) then
  begin
    if Running then
    begin
      if ((IsEdited) and (NotifyModified)) then
      begin
        case (Application.MessageBox(PChar('The unit "'+pLuaUnit.sUnitPath+'" has changed. Stop debugging?'), 'LuaEdit', MB_ICONINFORMATION+MB_YESNO)) of
        IDYES:
          begin
            Running := False;
            frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  End of Scipt - '+DateTimeToStr(Now));
            frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  Script Terminated by User - '+DateTimeToStr(Now));
            Exit;
          end;
        IDNO:
          begin
            NotifyModified := False;
          end;
        end;
      end;
      SetPause(pLuaUnit);
      ReStart := True;
      Exit;
    end else
    begin
      SetPause(pLuaUnit);
      NotifyModified := False;
    end;

    actCheckSyntaxExecute(nil);
    iDoLuaOpen := (LuaState=Nil);
    if iDoLuaOpen
    then LuaState := lua_open;

    L := LuaState;
    OpenLibs(L);

    if not Initializer(L) then
    begin
      Running := False;
      Exit;
    end;

    Running := True;
    LuaRegister(L, 'print', lua_print);
    OnLuaStdout := DoLuaStdout;
    lua_sethook(L, HookCaller, HOOK_MASK, 0);
    CurrentICI := 1;
    frmMain.CheckButtons;

    if (Assigned(Results)) then
      Results.Clear;

    try
      if Assigned(pCurrentSynEdit) then
      begin
        pCurrentSynEdit.Refresh;
        frmMain.stbMain.Refresh;
      end;

      PrevFile := pLuaUnit.sUnitPath;
      PrevLine := 0;

      try
        frmLuaOutput.memLuaOutput.Clear;
        frmLuaEditMessages.memMessages.Clear;
        CallStack.Clear;
        PrintStack;

        if (pCurrentSynEdit.Text = '') then
          Exit;

        LuaLoadBuffer(L, pCurrentSynEdit.Text, pLuaUnit.sUnitPath);
      
        if (FuncName <> '') then
        begin
          LuaPCall(L, 0, 0, 0);
          lua_getglobal(L, PChar(FuncName));
          if (lua_type(L, -1) <> LUA_TFUNCTION) then
            raise Exception.CreateFmt('Can''t find function "%s"', [FuncName]);

          NArgs := Length(Args);
          for x := 0 to NArgs - 1 do
            LuaPushString(L, Args[x]);
        end else
        begin
          NArgs := 0;
          lua_newtable(L);
          for x := 0 to Length(Args) - 1 do
          begin
            LuaPushString(L, Args[x]);
            lua_rawseti(L, -2, x + 1);
          end;
          lua_setglobal(L, ArgIdent);
        end;

{$ifdef RTASSERT} RTAssert(0, true, ' Begin Script', '', 0); {$endif}
        frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  Begin of Script - '+DateTimeToStr(Now));
        LuaPCall(L, NArgs, LUA_MULTRET, 0);
        frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  End of Script - '+DateTimeToStr(Now));
{$ifdef RTASSERT} RTAssert(0, true, ' End Script', '', 0);   {$endif}
      
        if (Assigned(Results)) then
        begin
          Results.Clear;
          for x := 1 to lua_gettop(L) do
            Results.Add(LuaStackToStr(L, x));
        end;

        PrintLuaStack(L);
        PrintGlobal(L, True);
        PrintWatch(L);
      finally
        UninitializeUnits;
        if iDoLuaOpen
        then begin
                  lua_close(L);
                  LuaState := nil;
             end;
        Running := False;
        Self.Pause := False;
        Self.PauseICI := 0;
        Self.PauseLine := -1;
        Self.PauseFile := '';
        CurrentICI := 1;
        Application.HintHidePause := 2500;
        frmMain.CheckButtons;
        FreeLibrary(hModule);
      end;
    except
      on E: ELuaException do
      begin
        if Assigned(frmMain.jvUnitBar.SelectedTab) then
        begin
          pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

          FileName := pLuaUnit.sUnitPath;

          if (not FileExists(FileName)) then
            FileName := PrevFile;

          if (FileExists(FileName) and (E.Line > 0)) then
          begin
            pLuaUnit.pDebugInfos.iLineError := E.Line;
            frmMain.GetAssociatedTab(pLuaUnit).Selected := True;
            pLuaUnit.synUnit.GotoLineAndCenter(E.Line);
          end;
        end;

        if (E.Msg <> 'STOP') then
        begin
          frmLuaEditMessages.memMessages.Lines.Add('[ERROR]: '+E.Msg+' ('+IntToStr(E.Line)+') - '+DateTimeToStr(Now));
          frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  End of Script - '+DateTimeToStr(Now));
          raise;
        end;

        UninitializeUnits;
      end;
    end;
  end;
end;

procedure TfrmMain.ExecuteCurrent(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer);
begin
  CustomExecute(Pause, PauseICI, PauseFile, PauseLine, '', [], nil);
end;

procedure TfrmMain.actRunScriptExecute(Sender: TObject);
begin
  ExecuteCurrent(False, 0, '', -1);
end;

procedure HookCaller(L: Plua_State; AR: Plua_Debug); cdecl;
begin
  frmMain.CallHookFunc(L, AR);
end;

{The Lau debug library is calling us every time before executing AR.currentline.
That means that the first line will get hook but only if AR.what='main' and
AR.currentline=-1 and AR.event=0. It also means that it will call us on the last
execution with AR.what='main' and AR.event=0}
procedure TfrmMain.CallHookFunc(L: Plua_State; AR: Plua_Debug);
var
  pBreakInfo: TBreakInfo;
  pLuaUnit: TLuaUnit;

  procedure Update;
  var
    NextFile: string;
    NextLine: Integer;
    pLuaUnit: TLuaUnit;
  begin
    if FileExists(StringReplace(AR.source, '@', '',[])) then
      NextFile := ExpandUNCFileName(StringReplace(AR.source, '@', '',[]))
    else
      NextFile := StringReplace(AR.source, '@', '',[]);

    NextLine := AR.currentline;

    if (PrevFile <> NextFile) then
    begin
      pLuaUnit := FindUnitInTabs(PrevFile);

      if Assigned(pLuaUnit) then
        pLuaUnit.pDebugInfos.iCurrentLineDebug := -1;
        
      PrevFile := NextFile;
    end;
    
    pLuaUnit := PopUpUnitToScreen(NextFile, -1, True);
    pLuaUnit.pDebugInfos.iCurrentLineDebug := NextLine;
    pLuaUnit.synUnit.CaretY := NextLine;
    pLuaUnit.synUnit.EnsureCursorPosVisibleEx(True);
    pCurrentSynEdit.Refresh;

    PrintLuaStack(L);
    PrintStack;
    PrintLocal(L);
    PrintGlobal(L, True);
    PrintWatch(L);
  end;

  procedure WaitReStart;
  var
    sUnitName: String;
  begin 
    // Get current call level
    CurrentICI := AR.i_ci;

    // NOTE: this condition has been added because when the unit is new,
    //       ExpandUNCFileName must not be used to avoid bugging
    //       Bug fixed the 02/06/2005 by Jean-Francois Goulet
    if FileExists(StringReplace(AR.source, '@', '',[])) then
      sUnitName := ExpandUNCFileName(StringReplace(AR.source, '@', '',[]))
    else
      sUnitName := StringReplace(AR.source, '@', '',[]);

    // Get line break status
    Pause := Pause or IsBreak(sUnitName, AR.currentline) or IsICI(CurrentICI);
    ReStart := not Pause;

    // Reset a few variables if we are going to break
    if (Pause) then
    begin
      Pause := False;
      PauseICI := 0;
      PauseLine := -1;
      PauseFile := '';
    end;

    frmMain.CheckButtons;
    PrevLine := AR.currentline - 1;

    // Update debug informations only if we are going to break
    if not Restart then
      Update;

    repeat
      // Only slow down processor if we really have to wait
      // if we don't we have major poor performances
      // Bug fixed the 02/06/2005 by Jean-Francois Goulet
      if not ReStart then
      begin
        Application.ProcessMessages;
        Sleep(20);
      end;

      // Quit loop if user pressed stop/run
      if (not Running) then
      begin
        lua_pushstring(L, 'STOP');
        lua_error(L);
      end;
    until ReStart;
  end;
begin
  if Assigned(frmMain.jvUnitBar.SelectedTab) then
    pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  lua_getinfo(L, 'Snlu', AR);

  case (AR.event) of
    LUA_HOOKCALL:
    begin
      // Detecting first line of script...
      if ((AR.event = LUA_HOOKCALL) and (AR.linedefined = 0) and (AR.i_ci = 1) and (AR.what = 'main') and (AR.currentline = -1)) then
      begin
        
        AR.event := LUA_HOOKLINE;
        AR.currentline := 1;
        WaitReStart;
      end
      else
      begin
        // Adding to CallStack...
        pBreakInfo := TBreakInfo.Create;
        pBreakInfo.LineOut := IntToStr(PrevLine + 1);
        
        if AR.what <> 'C' then
        begin
          pBreakInfo.FileName := pLuaUnit.sUnitPath;
          pBreakInfo.Line := PrevLine;
          pBreakInfo.Call := pLuaUnit.synUnit.Lines[PrevLine];
        end
        else
        begin
          pBreakInfo.Line := -1;  // Always -1 value when external definition
          pBreakInfo.FileName := '[' + AR.What + ']';
          pBreakInfo.Call := '<External Call>';
        end;

        // Add To Call Stack List
        CallStack.Insert(0, pBreakInfo);
      end;
    end;
    LUA_HOOKRET:
    begin
      // Removing from CallStack...
      if CallStack.Count > 0 then
      begin
        TBreakInfo(CallStack.Items[0]).Free;
        CallStack.Delete(0);
      end;
    end;
    LUA_HOOKLINE:
    begin
      WaitReStart;
    end;
    LUA_HOOKCOUNT, LUA_HOOKTAILRET:
    begin
      // nothing for now
    end;
  end;
end;

// Open the unit in the IDE if not already opened
function TfrmMain.PopUpUnitToScreen(sFileName: String; iLine: Integer = -1; bCleanPrevUnit: Boolean = False): TLuaUnit;
var
  pLuaUnit: TLuaUnit;
  x: Integer;
begin
  // if the current file is already the one selected then we exit this function
  if TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).sUnitPath = sFileName then
  begin
    Result := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);
    Exit;
  end;

  if bCleanPrevUnit then
  begin
    if Assigned(frmMain.jvUnitBar.SelectedTab) then
    begin
      TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug := -1;
      TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iStackMarker := -1;
      frmStack.lstCallStack.Items.BeginUpdate;

      for x := 0 to frmStack.lstCallStack.Items.Count - 1 do
      begin
        if x = 0 then
          frmStack.lstCallStack.Items[x].ImageIndex := 0
        else
          frmStack.lstCallStack.Items[x].ImageIndex := -1;
      end;

      frmStack.lstCallStack.Items.EndUpdate;
    end;
  end;

  if not frmMain.FileIsInTree(sFileName) then
  begin
    pLuaUnit := TLuaUnit.Create(sFileName);
    pLuaUnit := frmMain.AddFileInProject(sFileName, False, LuaSingleUnits);
    pLuaUnit.IsLoaded := True;
    frmMain.AddFileInTab(pLuaUnit);
    frmProjectTree.BuildProjectTree;
    frmMain.CheckButtons;
    Result := pLuaUnit;
  end
  else
  begin
    pLuaUnit := frmMain.FindUnitInTabs(sFileName);
    frmMain.GetAssociatedTab(pLuaUnit).Selected := True;
    Result := pLuaUnit;
  end;

  if iLine <> -1 then
    pLuaUnit.synUnit.GotoLineAndCenter(iLine);
end;

// print the call stack
procedure TfrmMain.PrintStack;
var
  x: Integer;
  pItem: TListItem;
begin
  // Clear call stack before displaying
  frmStack.lstCallStack.Clear;
  frmStack.lstCallStack.Items.BeginUpdate;

  // Display Stack
  for x := 0 to CallStack.Count - 1 do
  begin
    pItem := frmStack.lstCallStack.Items.Add;
    pItem.Caption := TBreakInfo(CallStack.Items[x]).FileName;
    pItem.SubItems.Strings[0] := TBreakInfo(CallStack.Items[x]).Call;
    pItem.SubItems.Strings[1] := TBreakInfo(CallStack.Items[x]).LineOut;
    pItem.Data := CallStack.Items[x];
  end;

  if frmStack.lstCallStack.Items.Count > 0 then
  begin
    // Managing Stack breaking icons...
    frmStack.lstCallStack.Items[0].ImageIndex := 0;
    if frmStack.lstCallStack.Items.Count > 1 then
      frmStack.lstCallStack.Items[1].ImageIndex := -1;
  end;

  frmStack.lstCallStack.Items.EndUpdate;
end;

// print the lua stack
procedure TfrmMain.PrintLuaStack(L: Plua_State);
begin
  LuaStackToStrings(L, frmLuaStack.lstLuaStack.Items, PRINT_SIZE);
end;

// print local list and fill the list of locals
procedure TfrmMain.PrintLocal(L: Plua_State; Level: Integer = 0);
begin
  LuaLocalToStrings(L, frmLuaLocals.lstLocals.Items, PRINT_SIZE, Level);
  LuaLocalToStrings(L, lstLocals, PRINT_SIZE, Level);
end;

// print global list
procedure TfrmMain.PrintGlobal(L: Plua_State; Foce: Boolean);
begin
  if (not Assigned(L)) then
    Exit;
  if not Foce then
    Exit;

  LuaTableToTreeView(L, LUA_GLOBALSINDEX, frmLuaGlobals.tvwLuaGlobals, PRINT_SIZE);
  LuaGlobalsToStrings(L, lstGlobals, PRINT_SIZE);
end;

// print watches list
procedure TfrmMain.PrintWatch(L: Plua_State);
var
  I: Integer;
begin
  for I := 1 to frmWatch.lvwWatch.RowCount - 1 do
    if frmWatch.lvwWatch.Cells[0, I] <> '' then
      frmWatch.lvwWatch.Cells[1, I] := GetValue(frmWatch.lvwWatch.Cells[0, I]);
end;

// check if current debug line is a break one
function TfrmMain.IsBreak(sFileName: String; Line: Integer): Boolean;
var
  pLuaUnit: TLuaUnit;
  pBreakpoint: TBreakpoint;
  BreakCondition: String;
begin
  Result := False;
  pLuaUnit := FindUnitInTabs(sFileName);

  if Assigned(pLuaUnit) then
  begin
    if pLuaUnit.pDebugInfos.IsBreakPointLine(Line) then
    begin
      pBreakpoint := pLuaUnit.pDebugInfos.GetBreakpointAtLine(Line);

      if pBreakpoint.iStatus = BKPT_ENABLED then
      begin
        BreakCondition := pBreakpoint.sCondition;
        if BreakCondition <> '' then
        begin
          lua_dostring(LuaState, PChar('return ('+BreakCondition+')'));

          if lua_toboolean(LuaState, -1) = 1 then
          begin
            // Breakpoint hit!!!
            Result := True;
          end;

          lua_pop(LuaState, 1);
        end
        else
        begin
          // Breakpoint hit!!!
          Result := True;
        end;
      end;

      if Result then
      begin
        Inc(pBreakpoint.iHitCount);
        frmBreakpoints.RefreshBreakpointList;
      end;
    end
    else
    begin
      if Line = PauseLine then
      begin
        Result := True;
      end;
    end;
  end;
end;

// check if it is the current call level
function TfrmMain.IsICI(ICI: Integer): Boolean;
begin
  Result := (ICI <= PauseICI);
end;

// stdout function for lua_print override
procedure DoLuaStdout(S: PChar; N: Integer);
const
  CR = #$0D;
  LF = #$0A;
  CRLF = CR + LF;
begin
  frmLuaOutput.Put(StringReplace(S, LF, CRLF, [rfReplaceAll]));
end;

// check if the given unit was modified
function TfrmMain.IsEdited(pIgnoreUnit: TLuaUnit): Boolean;
var
  x: Integer;
  pLuaUnit: TLuaUnit;
begin
  Result := False;

  for x := 0 to jvUnitBar.Tabs.Count - 1 do
  begin
    pLuaUnit := TLuaUnit(jvUnitBar.Tabs[x].Data);
    if (pLuaUnit <> pIgnoreUnit) then
      Result := Result or pLuaUnit.HasChanged;
  end;
end;

// add selected data to watch list
procedure TfrmMain.actAddWatchExecute(Sender: TObject);
var
  sTemp: string;
  I: Integer;
begin
  if Assigned(pCurrentSynEdit) then
  begin
    sTemp := pCurrentSynEdit.SelText;

    with (frmWatch.lvwWatch) do
    begin
      I := 0;
      while (Cells[0, I] <> '') do
      begin
        Inc(I);
        if (I = RowCount) then
          RowCount := RowCount + 1;
      end;
      Cells[0, I] := sTemp;
      PrintWatch(LuaState);
    end;
  end;
end;

procedure TfrmMain.LuaHelp1Click(Sender: TObject);
begin
  if FileExists(ExtractFilePath(Application.ExeName)+'Help\refman-5.0.pdf') then
    ShellExecute(Self.Handle, 'open', PChar(ExtractFilePath(Application.ExeName)+'Help\refman-5.0.pdf'), nil, nil, SW_SHOWNORMAL)
  else
    Application.MessageBox(PChar('The file "'+ExtractFilePath(Application.ExeName)+'Help\refman-5.0.pdf" does not exists!'), 'LuaEdit', MB_OK+MB_ICONERROR);
end;

procedure TfrmMain.PaintDebugGlyphs(ACanvas: TCanvas; AClip: TRect; FirstLine, LastLine: integer);
var
  LH, X, Y: integer;
  ImgIndex: integer;
  pLuaUnit: TLuaUnit;
begin
  pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

  FirstLine := pLuaUnit.synUnit.RowToLine(FirstLine);
  LastLine := pLuaUnit.synUnit.RowToLine(LastLine);
  X := 14;
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

procedure TfrmMain.actAddBreakpointExecute(Sender: TObject);
var
  iCurrentLine: Integer;
begin
  iCurrentLine := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.CaretY;

  if not TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.IsBreakPointLine(iCurrentLine) then
    TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.AddBreakpointAtLine(iCurrentLine)
  else
    TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.RemoveBreakpointAtLine(iCurrentLine);

  TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
  frmBreakpoints.RefreshBreakpointList;
end;

procedure TfrmMain.stbMainDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var
  InflatedRect: TRect;
begin
  if not IsCompiledComplete then
  begin
    StatusBar.Canvas.Font.Color := clWhite;
    StatusBar.Canvas.Brush.Color := clNavy;
    StatusBar.Canvas.FillRect(Rect);
    StatusBar.Canvas.TextRect(Rect, Rect.Left, rect.Top, '  '+LastMessage);
  end
  else
  begin
    StatusBar.Canvas.Font.Color := clBlack;
    StatusBar.Canvas.FillRect(Rect);
    StatusBar.Canvas.TextRect(Rect, Rect.Left, Rect.Top, '  '+Panel.Text);
    InflatedRect := Rect;
    InflateRect(InflatedRect, 1, 1);
    StatusBar.Canvas.Brush.Color := clGrayText;
    StatusBar.Canvas.FrameRect(Rect);
  end;
end;

procedure TfrmMain.synEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  pLuaUnit: TLuaUnit;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);
    Special := False;

    if pLuaUnit.pDebugInfos.IsBreakPointLine(Line) then
    begin
      Special := True;
      BG := StringToColor(TEditorColors(EditorColors.Items[9]).Background);
      FG := StringToColor(TEditorColors(EditorColors.Items[9]).Foreground);
    end;

    if TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug = Line then
    begin
      Special := True;
      BG := StringToColor(TEditorColors(EditorColors.Items[3]).Background);
      FG := StringToColor(TEditorColors(EditorColors.Items[3]).Foreground);
    end;

    if TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError = Line then
    begin
      Special := True;
      BG := StringToColor(TEditorColors(EditorColors.Items[2]).Background);
      FG := StringToColor(TEditorColors(EditorColors.Items[2]).Foreground);
    end;

    if TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.iStackMarker = Line then
    begin
      Special := True;
      BG := clNavy;
      FG := clWhite;
    end;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  x, y, Answer: Integer;
  pLuaUnit: TLuaUnit;
  pLuaProject: TLuaProject;
  bProjectAdded: Boolean;
  frmExSaveExit: TfrmExSaveExit;
begin
{$ifdef RTASSERT} RTAssert(0, true, ' TfrmMain.FormCloseQuery', '', 0); {$endif}
  // Here we check if the user is currently debugging a unit
  // If that is the case, we aware the user that he is currently debugging a file
  // and that is going to stop the debugger.
  if LuaOpenedUnits.Count > 0 then
  begin
    if ((IsRunning) or (TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug <> -1)) then
    begin
      if Application.MessageBox('This action will stop the debugger. Continue anyway?', 'LuaEdit', MB_YESNO+MB_ICONINFORMATION) = IDNO then
      begin
        CanClose := False;
        Exit;
      end
      else
      begin
        actStopExecute(nil);

        while  WaitForSingleObject(hMutex, 100) = WAIT_TIMEOUT   do
        begin
          Sleep(20);
          Application.ProcessMessages;
        end;

        ReleaseMutex(hMutex);
        CloseHandle(ThreadDebugHandle);
        TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug := -1;
        TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError := -1;
        TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Refresh;
      end;
    end;
  end;

  // Initialize stuff...
  frmExSaveExit := nil;

  // Determines closing method...
  if ShowExSaveDlg then
  begin
    // Create form
    frmExSaveExit := TfrmExSaveExit.Create(nil);

    // Clearing actual list
    frmExSaveExit.lstFiles.Items.Clear;
    frmExSaveExit.lstFiles.MultiSelect := True;

    // Adding modfied units and projects to the list
    for x := 0 to LuaProjects.Count - 1 do
    begin
      bProjectAdded := False;
      pLuaProject := LuaProjects.Items[x]; 

      for y := 0 to pLuaProject.lstUnits.Count - 1 do
      begin
        pLuaUnit := TLuaUnit(pLuaProject.lstUnits.Items[y]);

        if ((not bProjectAdded) and (pLuaProject.sPrjName <> '[@@SingleUnits@@]') and ((pLuaProject.HasChanged) or (pLuaProject.IsNew))) then
        begin
          frmExSaveExit.lstFiles.AddItem(pLuaProject.sPrjName, pLuaProject);
          bProjectAdded := True;
        end;

        if ((pLuaUnit.HasChanged) or (pLuaUnit.IsNew)) then
        begin
          if pLuaProject.sPrjName = '[@@SingleUnits@@]' then
            frmExSaveExit.lstFiles.AddItem(ExtractFileName(pLuaUnit.sUnitPath), pLuaUnit)
          else
            frmExSaveExit.lstFiles.AddItem('     '+ExtractFileName(pLuaUnit.sUnitPath), pLuaUnit);
        end;
      end;
    end;

    // Only show dialog if anything has to be save
    if frmExSaveExit.lstFiles.Count > 0 then
    begin
      // Pre-seleect all items as default feature
      frmExSaveExit.lstFiles.SelectAll;

      // if action was not canceled
      case frmExSaveExit.ShowModal of
        mrYes:
        begin
          for x := 0 to frmExSaveExit.lstFiles.Count - 1 do
          begin
            // Save only if it was selected by user
            if frmExSaveExit.lstFiles.Selected[x] then
            begin 
              // Determines if it is a project or a unit
              if frmExSaveExit.lstFiles.Items.Objects[x].ClassName = 'TLuaUnit' then
              begin
                // We know its a unit...
                pLuaUnit := TLuaUnit(frmExSaveExit.lstFiles.Items.Objects[x]);

                if SaveUnitsInc then
                  CanClose := pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
                else
                  CanClose := pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
              end
              else
              begin
                // We know its a project...
                pLuaProject := TLuaProject(frmExSaveExit.lstFiles.Items.Objects[x]);

                if SaveProjectsInc then
                  CanClose := pLuaProject.SaveProjectInc(pLuaProject.sPrjPath)
                else
                  CanClose := pLuaProject.SaveProject(pLuaProject.sPrjPath);
              end;

              // if CanClose variable has been assign to false, we should quit
              // the function because that means the user has canceled the action
              // in a SaveAs dialog previously
              if not CanClose then
                Exit;
            end;
          end;
        end;
        mrCancel:
        begin
          // Abort closing action by assigning this variable to false
          CanClose := False;
        end;
      end;
    end;
  end
  else
  begin
    for x := 0 to LuaProjects.Count - 1 do
    begin
      pLuaProject := LuaProjects.Items[x];

      // Look for any unit to save (new or modified)
      for y := 0 to pLuaProject.lstUnits.Count - 1 do
      begin
        pLuaUnit := TLuaUnit(pLuaProject.lstUnits.Items[y]);

        if ((pLuaUnit.HasChanged) or (pLuaUnit.IsNew)) then
        begin
          Answer := Application.MessageBox(PChar('Save changes to unit "'+pLuaUnit.sUnitPath+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
        
          if Answer = IDYES then
          begin
            if SaveUnitsInc then
              pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
            else
              pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
          end
          else if Answer = IDCANCEL then
            CanClose := False;
        end;
      end;

      // check if the project has to be save (new or modified)
      if (((pLuaProject.HasChanged) or (pLuaProject.IsNew)) and (pLuaProject.sPrjName <> '[@@SingleUnits@@]')) then
      begin
        Answer := Application.MessageBox(PChar('Save changes to project "'+pLuaProject.sPrjName+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);

        if Answer = IDYES then
        begin
          if SaveProjectsInc then
            pLuaProject.SaveProjectInc(pLuaProject.sPrjPath)
          else
            pLuaProject.SaveProject(pLuaProject.sPrjPath);
        end
        else if Answer = IDCANCEL then
          CanClose := False;
      end;
    end;
  end;

  if Assigned(frmExSaveExit) then
    frmExSaveExit.Free;

  // If action was not canceled
  if CanClose then
  begin
    jvchnNotifier.Active := False;  // "Turn off" the changes notifier
    SaveDockTreeToFile(ExtractFilePath(Application.ExeName) + 'LuaEdit.dck');  // saves the dockable forms positions
  end;
{$ifdef RTASSERT} RTAssert(0, true, ' TfrmMain.FormCloseQuery Done', '', 0); {$endif}
end;

procedure TfrmMain.actStepOverExecute(Sender: TObject);
begin
  if (Pause) then
    Exit;
  ExecuteCurrent(False, CurrentICI, '', -1);
end;

procedure TfrmMain.actStepIntoExecute(Sender: TObject);
begin
  if (Pause) then
    Exit;
  ExecuteCurrent(True, 0, '', -1);
end;

procedure TfrmMain.synEditGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  iCurrentLine: Integer;
begin
  iCurrentLine := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.RowToLine(Line);

  if not TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.IsBreakPointLine(iCurrentLine) then
    TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.AddBreakpointAtLine(iCurrentLine)
  else
    TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.RemoveBreakpointAtLine(iCurrentLine);

  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Refresh;
end;

procedure TfrmMain.actPauseExecute(Sender: TObject);
begin
  if (ReStart) then
    Pause := True;
end;

procedure TfrmMain.actStopExecute(Sender: TObject);
begin
  Running := False;
  if Running then
  begin
    frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  End of Scipt - '+DateTimeToStr(Now));
    frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  Script Terminated by User - '+DateTimeToStr(Now))
  end;
end;

procedure TfrmMain.actRunToCursorExecute(Sender: TObject);
begin
  if Assigned(jvUnitBar.SelectedTab) then
    ExecuteCurrent(False, 0, '', TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretY);
end;

procedure TfrmMain.synEditMouseCursor(Sender: TObject; const aLineCharPos: TBufferCoord; var aCursor: TCursor);
var
  sWord: String;
begin
  if ((IsRunning = False) and (TLuaUnit(jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug <> -1)) then
  begin
    sWord := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(aLineCharPos);
    if sWord <> '' then
    begin
      if lstLocals.Values[sWord] <> '' then
      begin
        if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Hint <> sWord + ' = ' + lstLocals.Values[sWord] then
        begin
          Application.CancelHint;
        end;

        TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Hint := sWord + ' = ' + lstLocals.Values[sWord];
      end;
    end
    else
    begin
      TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Hint := '';
    end;
  end;
end;

procedure TfrmMain.synEditChange(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
begin
  if Assigned(jvUnitBar.SelectedTab.Data) then
  begin
    pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);

    if pLuaUnit.synUnit.Modified then
    begin
      pLuaUnit.HasChanged := True;
      if Pos('*', jvUnitBar.SelectedTab.Caption) <> Length(jvUnitBar.SelectedTab.Caption) then
        jvUnitBar.SelectedTab.Caption := jvUnitBar.SelectedTab.Caption + '*';
      jvUnitBar.SelectedTab.Modified := True;
      stbMain.Panels[3].Text := 'Modified';
      NotifyModified := True;
    end
    else
    begin
      pLuaUnit.HasChanged := False;
      stbMain.Panels[3].Text := '';
      NotifyModified := False;
      if Pos('*', jvUnitBar.SelectedTab.Caption) = Length(jvUnitBar.SelectedTab.Caption) then
        jvUnitBar.SelectedTab.Caption := Copy(jvUnitBar.SelectedTab.Caption, 1, Length(jvUnitBar.SelectedTab.Caption) - 1);
      jvUnitBar.SelectedTab.Modified := False;
    end; 

    if pLuaUnit.IsReadOnly then
      stbMain.Panels[4].Text := 'Read Only'
    else
      stbMain.Panels[4].Text := '';
      
    pLuaUnit.pDebugInfos.iLineError := -1;
    HasChangedWhileCompiled := True;
    pLuaUnit.LastEditedLine := pLuaUnit.synUnit.CaretY;
    pLuaUnit.PrevLineNumber := pLuaUnit.synUnit.Lines.Count;
    pLuaUnit.synUnit.Refresh;
    CheckButtons;
  end;
end;

procedure TfrmMain.synEditDblClick(Sender: TObject);
const
  OpeningBrackets: set of char = ['(', '[', '{', '<'];
  ClosingBrackets: set of char = [')', ']', '}', '>'];
var
  pLuaUnit: TLuaUnit;
  pCoord: TBufferCoord;
begin
  if Assigned(jvUnitBar.SelectedTab.Data) then
  begin
    // Get current unit and find matching bracket
    pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);

    if pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1][pLuaUnit.synUnit.CaretX] in OpeningBrackets then
    begin
      if ((FirstClickPos.Line = pLuaUnit.synUnit.CaretXY.Line) and (FirstClickPos.Char = pLuaUnit.synUnit.CaretXY.Char)) then
      begin
        // Get matching bracket
        pCoord := pLuaUnit.synUnit.GetMatchingBracket;

        // Select matching bracket if found one
        if pCoord.Char <> 0 then
        begin
          Inc(pCoord.Char);
          pLuaUnit.synUnit.BlockBegin := pLuaUnit.synUnit.CaretXY;
          pLuaUnit.synUnit.BlockEnd := pCoord;
        end;
      end;
    end
    else if pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1][pLuaUnit.synUnit.CaretX - 1] in ClosingBrackets then
    begin
    end;
      // Get matching bracket with previous char
      pCoord := pLuaUnit.synUnit.CaretXY;
      Dec(pCoord.Char);
      pCoord := pLuaUnit.synUnit.GetMatchingBracketEx(pCoord);

      // Select matching bracket if found one
      if pCoord.Char <> 0 then
      begin
        pLuaUnit.synUnit.BlockBegin := pLuaUnit.synUnit.CaretXY;
        pLuaUnit.synUnit.BlockEnd := pCoord;
      end;
  end;
end;

procedure TfrmMain.synEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  pLuaUnit: TLuaUnit;
begin
  // Only if left button is down (in other words... when selecting)
  if ssLeft	in Shift then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      // Get currently opened unit
      pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);

      // Set square selection mode if Alt key is held down
      if ssAlt in Shift then
        pLuaUnit.synUnit.SelectionMode := smColumn
      else
        pLuaUnit.synUnit.SelectionMode := smNormal;
    end;
  end;
end;

procedure TfrmMain.UpdateWatch;
var
  x, y: Integer;
  WasShown: Boolean;
  tmpStr: String;
begin
  with frmWatch do
  begin
    for x := 1 to lvwWatch.RowCount - 1 do
    begin
      WasShown := False;
      if lvwWatch.Rows[x].Strings[0] <> '' then
      begin
        for y := 0 to lstLocals.Count - 1 do
        begin
          if lstLocals.Values[lvwWatch.Rows[x].Strings[0]] <> '' then
          begin
            WasShown := True;
            lvwWatch.Rows[x].Strings[1] := lstLocals.Values[lvwWatch.Rows[x].Strings[0]];
          end;
        end;

        for y := 0 to lstGlobals.Count - 1 do
        begin
          if lstGlobals.Values[lvwWatch.Rows[x].Strings[0]] <> '' then
          begin
            WasShown := True;
            lvwWatch.Rows[x].Strings[1] := lstGlobals.Values[lvwWatch.Rows[x].Strings[0]];
          end
          else
          begin
            tmpStr := lvwWatch.Rows[x].Strings[0];

            while Pos('.', tmpStr) <> 0 do
            begin
              tmpStr := Copy(tmpStr, Pos('.', tmpStr) + 1, Length(tmpStr) - Pos('.', tmpStr));
            end;

            if tmpStr <> '' then
            begin
              if lstGlobals.Values[tmpStr] <> '' then
              begin
                WasShown := True;
                lvwWatch.Rows[x].Strings[1] := lstGlobals.Values[tmpStr];
              end;
            end;
          end;
        end;
      end;

      if ((WasShown = False) and (lvwWatch.Rows[x].Strings[0] <> '')) then
      begin
        lvwWatch.Rows[x].Strings[1] := '[ERROR] Undeclared Identifier';
      end;
    end;
  end;
end;

procedure TfrmMain.LuaGlobalsToStrings(L: PLua_State; Lines: TStrings; MaxTable: Integer = -1);
begin
  lua_pushvalue(L, LUA_GLOBALSINDEX);
  LuaTableToStrings(L, -1, Lines, MaxTable);
  lua_pop(L, 1);
end;

procedure TfrmMain.UpdateFctList;
begin
  //Here should be algorithms for ctags...
end;

procedure TfrmMain.actAddToPrjExecute(Sender: TObject);
var
  x, NewUnit: integer;
  pLuaUnit: TLuaUnit;
  FoundMatch: Boolean;
begin
  if frmAddToPrj.ShowModal = mrOk then
  begin
    if frmAddToPrj.chkExisting.Checked then
    begin
      for x := 0 to frmAddToPrj.lstFiles.Count - 1 do
      begin
        (AddFileInProject(frmAddToPrj.lstFiles.Strings[x], False, ActiveProject)).IsLoaded := True;
        ActiveProject.HasChanged := True;
      end;
    end
    else
    begin
      NewUnit := 1;

      for x := 0 to LuaOpenedUnits.Count - 1 do
      begin
        if TLuaUnit(LuaOpenedUnits.Items[x]).IsNew then
          Inc(NewUnit);
      end;

      FoundMatch := True;
  
      while FoundMatch do
      begin
        FoundMatch := False;
        for x := 0 to LuaOpenedUnits.Count - 1 do
        begin
          if 'Unit'+IntToStr(NewUnit)+'.lua' = TLuaUnit(LuaOpenedUnits.Items[x]).sName then
          begin
            Inc(NewUnit);
            FoundMatch := True;
          end;
        end;
      end;

      pLuaUnit := AddFileInProject('Unit'+IntToStr(NewUnit)+'.lua', True, ActiveProject);
      pLuaUnit.IsLoaded := True;
      AddFileInTab(pLuaUnit);
      ActiveProject.HasChanged := True;
    end;
  end;

  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmMain.actRemoveFromPrjExecute(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
begin
  frmRemoveFile.FillCombo(ActiveProject);
  if frmRemoveFile.ShowModal = mrOk then
  begin
    pLuaUnit := TLuaUnit(frmRemoveFile.cboUnit.Items.Objects[frmRemoveFile.cboUnit.ItemIndex]);

    if ((pLuaUnit.HasChanged) or (pLuaUnit.IsNew)) then
    begin
      if Application.MessageBox(PChar('Save changes to file "'+pLuaUnit.sUnitPath+'"?'), 'LuaEdit', MB_ICONQUESTION+MB_YESNO) = IDYES then
      begin
        if SaveUnitsInc then
          pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
        else
          pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
      end;
    end;

    if LuaOpenedUnits.IndexOf(pLuaUnit) <> -1 then
    begin
      GetAssociatedTab(pLuaUnit).Free;
      LuaOpenedUnits.Remove(pLuaUnit);
    end;

    ActiveProject.lstUnits.Remove(pLuaUnit);
    pLuaUnit.Free;
    ActiveProject.HasChanged := True;
    frmProjectTree.BuildProjectTree;
  end;
end;

procedure TfrmMain.Project1Click(Sender: TObject);
begin
  CheckButtons;
end;

function TfrmMain.GetBaseCompletionProposal: TSynCompletionProposal;
var
  pNewCompletionProposal: TSynCompletionProposal;
begin
  pNewCompletionProposal := TSynCompletionProposal.Create(nil);
  pNewCompletionProposal.Resizeable := True;
  pNewCompletionProposal.TimerInterval := 1200;
  pNewCompletionProposal.NbLinesInWindow := 10;
  pNewCompletionProposal.ShortCut := ShortCut(Word(' '), [ssCtrl]);
  pNewCompletionProposal.TriggerChars := '.';
  pNewCompletionProposal.InsertList.Add('assert');
  pNewCompletionProposal.ItemList.Add('\color{clBlue}function\color{clBlack}   \column{}\style{+B}assert\style{-B}(v [, message])');
  pNewCompletionProposal.Options := pNewCompletionProposal.Options + [scoUsePrettyText, scoUseBuiltInTimer, scoUseInsertList, scoCaseSensitive, scoLimitToMatchedText];
  pNewCompletionProposal.OnExecute := synCompletionExecute;
  Result := pNewCompletionProposal;
end;

function TfrmMain.GetBaseParamsProposal: TSynCompletionProposal;
var
  pNewCompletionProposal: TSynCompletionProposal;
begin
  pNewCompletionProposal := TSynCompletionProposal.Create(nil);
  pNewCompletionProposal.Resizeable := False;
  pNewCompletionProposal.ShortCut := ShortCut(Word(' '), [ssCtrl, ssShift]);
  pNewCompletionProposal.TriggerChars := '(';
  pNewCompletionProposal.Options := [scoUsePrettyText, scoUseBuiltInTimer, scoLimitToMatchedText];
  pNewCompletionProposal.OnExecute := synParamsExecute;
  pNewCompletionProposal.TimerInterval := 1200;
  pNewCompletionProposal.NbLinesInWindow := 10;
  pNewCompletionProposal.DefaultType := ctParams;
  pNewCompletionProposal.ClBackground := clInfoBk;
  Result := pNewCompletionProposal;
end;

procedure TfrmMain.synCompletionExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: String; var x, y: Integer; var CanExecute: Boolean);
var
  pLuaUnit: TLuaUnit;
  pFctInfo: TFctInfo;
  hFileSearch: TSearchRec;
  GotTable: Boolean;
  sTemp, sFormatString, sFunctionName, sNestedTable: String;
  sTable, sParameters, LineType, Lookup, LookupTable: String;
  lstLocalTable, sFileContent: TStringList;
  i, j, k, Index: Integer;
begin
  // Initialize stuff before going
  lstLocalTable := TStringList.Create;
  pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);
  pLuaUnit.synCompletion.ItemList.Clear;
  pLuaUnit.synCompletion.ClearList;
  pLuaUnit.synCompletion.InsertList.Clear;
  j := pLuaUnit.synUnit.CaretX - 1;

  // Getting lookup text and lookup table at cursor
  while ((Copy(pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1], j, 1) <> ' ') and (Copy(pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1], j, 1) <> '') and (j > 0)) do
  begin
    // Retreive lookup text at cursor
    Lookup := Copy(pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1], j, 1) + Lookup;

    // Retreive lookup table at cursor if any
    if ((Copy(pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1], j, 1) = '.') or GotTable) then
    begin
      // Don't retreive first point encountered
      if GotTable then
        LookupTable := Copy(pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1], j, 1) + LookupTable;

      GotTable := True;
    end;

    Dec(j);
  end;

  // Go through all libraries search paths
  for i := 0 to LibrariesSearchPaths.Count - 1 do
  begin
    // Begin file search
    if FindFirst(LibrariesSearchPaths.Strings[i]+'*.lib', faAnyFile, hFileSearch) = 0 then
    begin
      repeat
        // Create and initialize temporary content container
        sFileContent := TStringList.Create;
        sFileContent.LoadFromFile(LibrariesSearchPaths.Strings[i]+hFileSearch.Name);

        // Parse content and add it to the lookup list
        for j := 0 to sFileContent.Count - 1 do
        begin
          // Extract line type
          LineType := UpperCase(Copy(sFileContent.Strings[j], Length(sFileContent.Strings[j]) - 2, 3));
          sTemp := Copy(sFileContent.Strings[j], 1, Length(sFileContent.Strings[j]) - 4);

          // Format line according to type
          if LineType = 'FOO' then
            sFormatString := '\color{clBlue}function\color{clBlack}   \column{}\style{+B}'
          else if LineType = 'VAR' then
            sFormatString := '\color{clMaroon}global var\color{clBlack} \column{}\style{+B}'
          else if LineType = 'LIB' then
            sFormatString := '\color{clGreen}library\color{clBlack}       \column{}\style{+B}';

          // Initialize variable before starting
          sParameters := '';
          sFunctionName := '';
          sTable := '';
          sNestedTable := '';

          // Determine if a table is to retreive
          while ((Pos('.', sTemp) <> 0) and ((Pos('(', sTemp) <> 0) and (Pos('.', sTemp) < Pos('(', sTemp)))) do
          begin
            // Retreive table and function name
            sTable := Copy(sTemp, 1, Pos('.', sTemp) - 1);
            sTemp := StringReplace(sTemp, sTable + '.', '', [rfReplaceAll, rfIgnoreCase]);
            if sNestedTable = '' then
              sNestedTable := sTable
            else
              sNestedTable := sNestedTable + '.' + sTable;

            // Sort list of table/nested table before doing the find call
            lstLocalTable.Sort;

            // Add table in table list if not already in it
            if not lstLocalTable.Find(sNestedTable, Index) then
              lstLocalTable.Add(sNestedTable);
          end;

          // Determine if parameters are to retreive
          if Pos('(', sTemp) <> 0 then
            sParameters := Copy(sTemp, Pos('(', sTemp) + 1, Length(sTemp) - 1 - Pos('(', sFileContent.Strings[j]));

          if Pos('(', sTemp) <> 0 then
            sFunctionName := Copy(sTemp, 1, Pos('(', sTemp) - 1)
          else
            sFunctionName := sTemp;

          if sFunctionName <> '' then
          begin
            if ((LookupTable = Copy(sNestedTable, 1, Length(Lookup))) and (LookupTable <> '')) then
            begin
              if ((Pos('(', sTemp) <> 0) and (LineType = 'FOO')) then
                pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}(' + sParameters + ')')
              else
                pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}');

              pLuaUnit.synCompletion.InsertList.Add(sFunctionName);
            end
            else if (Lookup = Copy(sFunctionName, 1, Length(Lookup))) and (sNestedTable = '') then
            begin
              if ((Pos('(', sTemp) <> 0) and (LineType = 'FOO')) then
                pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}(' + sParameters + ')')
              else
                pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}');

              pLuaUnit.synCompletion.InsertList.Add(sFunctionName);
            end;
          end;
        end;

        // Free temporary content container
        sFileContent.Free;
      until FindNext(hFileSearch) <> 0;

      FindClose(hFileSearch);
    end;
  end;

  // Local definitions
  frmFunctionList.RefreshList(pLuaUnit.sUnitPath);

  for i := 0 to frmFunctionList.lvwFunctions.Items.Count - 1 do
  begin
    pFctInfo := TFctInfo(frmFunctionList.lvwFunctions.Items[i].Data);
    sTemp := pFctInfo.FctDef;
    sFunctionName := '';
    sParameters := '';
    sTable := '';
    sNestedTable := '';

    // look if it is member of a table
    while ((Pos('.', sTemp) <> 0) and ((Pos('(', sTemp) <> 0) and (Pos('.', sTemp) < Pos('(', sTemp)))) do
    begin
      // Retreive table and function name
      sTable := Copy(sTemp, 1, Pos('.', sTemp) - 1);
      sTemp := StringReplace(sTemp, sTable + '.', '', [rfReplaceAll, rfIgnoreCase]);
      if sNestedTable = '' then
        sNestedTable := sTable
      else
        sNestedTable := sNestedTable + '.' + sTable;

      // Sort list of table/nested table before doing the find call
      lstLocalTable.Sort;

      // Add table in table list if not already in it
      if not lstLocalTable.Find(sNestedTable, Index) then
        lstLocalTable.Add(sNestedTable);
    end;

    // Retreive parameters and function name
    sParameters := pFctInfo.Params;
    sFunctionName := Copy(sTemp, 1, Pos('(', sTemp) - 1);

    if sFunctionName <> '' then
    begin
      if ((LookupTable = Copy(sNestedTable, 1, Length(Lookup))) and (LookupTable <> '')) then
      begin
        if ((Pos('(', sTemp) <> 0) and (LineType = 'FOO')) then
          pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}(' + sParameters + ')')
        else
          pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}');

        pLuaUnit.synCompletion.InsertList.Add(sFunctionName);
      end
      else if (Lookup = Copy(sFunctionName, 1, Length(Lookup))) and (sNestedTable = '') then
      begin
        if ((Pos('(', sTemp) <> 0) and (LineType = 'FOO')) then
          pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}(' + sParameters + ')')
        else
          pLuaUnit.synCompletion.ItemList.Add(sFormatString + sFunctionName + '\style{-B}');

        pLuaUnit.synCompletion.InsertList.Add(sFunctionName);
      end;
    end;
  end;

  // add all found libraries
  for i := 0 to lstLocalTable.Count - 1 do
  begin
    if ((LookupTable = Copy(lstLocalTable.Strings[i], 1, Length(LookupTable))) and (LookupTable <> '') and (lstLocalTable.Strings[i] <> LookupTable)  and (Pos('.', Copy(lstLocalTable.Strings[i], Length(Lookup) + 1, Length(lstLocalTable.Strings[i]) - Length(Lookup) + 1)) = 0)) then
    begin
      // Because of sub tables, retreive only last part before last point
      j := Length(lstLocalTable.Strings[i]);
      sTemp := '';
      while ((Copy(lstLocalTable.Strings[i], j, 1) <> '.') and (j > 0)) do
      begin
        sTemp := Copy(lstLocalTable.Strings[i], j, 1) + sTemp;
        Dec(j);
      end;

      pLuaUnit.synCompletion.InsertList.Add(sTemp);
      pLuaUnit.synCompletion.ItemList.Add('\color{clGreen}library\color{clBlack}       \column{}\style{+B}' + sTemp + '\style{-B}');
    end
    else if ((Lookup = Copy(lstLocalTable.Strings[i], 1, Length(Lookup))) and (Pos('.', Copy(lstLocalTable.Strings[i], Length(Lookup) + 1, Length(lstLocalTable.Strings[i]) - Length(Lookup) + 1)) = 0)) then
    begin
      pLuaUnit.synCompletion.InsertList.Add(Copy(lstLocalTable.Strings[i], 1, Length(lstLocalTable.Strings[i])));
      pLuaUnit.synCompletion.ItemList.Add('\color{clGreen}library\color{clBlack}       \column{}\style{+B}' + Copy(lstLocalTable.Strings[i], 1, Length(lstLocalTable.Strings[i])) + '\style{-B}');
    end;
  end;

  // Free stuff before leaving 
  lstLocalTable.Free;

  //change title
  pLuaUnit.synCompletion.Title := 'LuaEdit Completion Proposal';
  pLuaUnit.synCompletion.ResetAssignedList;
end;

procedure TfrmMain.synParamsExecute(Kind: SynCompletionType; Sender: TObject; var AString: String; var x, y: Integer; var CanExecute: Boolean);
var
  locline, lookup, sProposition: String;
  sFunctionName, sParameters: String;
  TmpX, savepos, StartX, ParenCounter: Integer;
  TmpLocation, i, j: Integer;
  sFileContent: TStringList;
  hFileSearch: TSearchRec;
  FoundMatch: Boolean;
  pFctInfo: TFctInfo;
begin
  // Refill the lookup list for lastest changes
  FillLookUpList;

  with TSynCompletionProposal(Sender).Editor do
  begin
    locLine := LineText;

    //go back from the cursor and find the first open paren
    TmpX := CaretX;
    if TmpX > length(locLine) then
      TmpX := length(locLine)
    else dec(TmpX);
    FoundMatch := False;
    TmpLocation := 0;
    while (TmpX > 0) and not(FoundMatch) do
    begin
      if LocLine[TmpX] = ',' then
      begin
        inc(TmpLocation);
        dec(TmpX);
      end else if LocLine[TmpX] = ')' then
      begin
        //We found a close, go till it's opening paren
        ParenCounter := 1;
        dec(TmpX);
        while (TmpX > 0) and (ParenCounter > 0) do
        begin
          if LocLine[TmpX] = ')' then inc(ParenCounter)
          else if LocLine[TmpX] = '(' then dec(ParenCounter);
          dec(TmpX);
        end;
        if TmpX > 0 then dec(TmpX);  //eat the open paren
      end else if locLine[TmpX] = '(' then
      begin
        //we have a valid open paren, lets see what the word before it is
        StartX := TmpX;
        while (TmpX > 0) and not(locLine[TmpX] in TSynValidStringChars) do
          Dec(TmpX);
        if TmpX > 0 then
        begin
          SavePos := TmpX;
          While (TmpX > 0) and (locLine[TmpX] in TSynValidStringChars+['.']) do
            dec(TmpX);
          inc(TmpX);
          lookup := Uppercase(Copy(LocLine, TmpX, SavePos - TmpX + 1));
          FoundMatch := LookupList.IndexOf(Lookup) > -1;
          if not(FoundMatch) then
          begin
            TmpX := StartX;
            dec(TmpX);
          end;
        end;
      end else dec(TmpX)
    end;
  end;

  CanExecute := FoundMatch;

  if CanExecute then
  begin
    TSynCompletionProposal(Sender).Form.CurrentIndex := TmpLocation;
    if Lookup <> TSynCompletionProposal(Sender).PreviousToken then
    begin
      TSynCompletionProposal(Sender).ItemList.Clear;

      // Go through all libraries search paths
      for i := 0 to LibrariesSearchPaths.Count - 1 do
      begin
        // Begin file search
        if FindFirst(LibrariesSearchPaths.Strings[i]+'*.lib', faAnyFile, hFileSearch) = 0 then
        begin
          repeat
            // Create and initialize temporary content container
            sFileContent := TStringList.Create;
            sFileContent.LoadFromFile(LibrariesSearchPaths.Strings[i]+hFileSearch.Name);

            // Parse content and add it to the lookup list
            for j := 0 to sFileContent.Count - 1 do
            begin
              if UpperCase(Copy(sFileContent.Strings[j], Length(sFileContent.Strings[j]) - 2, 3)) = 'FOO' then
              begin
                // Retreive parameters from the list
                sParameters := Copy(sFileContent.Strings[j], Pos('(', sFileContent.Strings[j]) + 1, Length(sFileContent.Strings[j]) - 4 - Pos('(', sFileContent.Strings[j]));
                sFunctionName := Copy(sFileContent.Strings[j], 1, Pos('(', sFileContent.Strings[j]) - 1);

                // if current function call is equal to any of these
                if Lookup = UpperCase(sFunctionName) then
                begin
                  // Format the string to be compatible with the proposition engine
                  if sParameters = '' then
                    sProposition := '* No Parameters Expected *'
                  else
                    sProposition := StringReplace(sParameters, ',', '", ", ', [rfReplaceAll, rfIgnoreCase]);

                  sProposition := '"(' + sProposition + '"';
                  TSynCompletionProposal(Sender).ItemList.Add(sProposition);
                end;
              end;
            end;

            // Free temporary content container
            sFileContent.Free;
          until FindNext(hFileSearch) <> 0;

          FindClose(hFileSearch);
        end;
      end;  

      // looking for local definitions
      for i := 0 to frmFunctionList.lvwFunctions.Items.Count - 1 do
      begin
        pFctInfo := TFctInfo(frmFunctionList.lvwFunctions.Items[i].Data);
        sFunctionName := Copy(pFctInfo.FctDef, 1, Pos('(', pFctInfo.FctDef) - 1);

        // if current function call is equal to any of these
        if Lookup = UpperCase(sFunctionName) then
        begin
          // Format the string to be compatible with the proposition engine
          if pFctInfo.Params = '' then
            sProposition := '* No Parameters Expected *'
          else
            sProposition := StringReplace(pFctInfo.Params, ',', '", ", ', [rfReplaceAll, rfIgnoreCase]);

          sProposition := '"(' + sProposition + ')"';
          TSynCompletionProposal(Sender).ItemList.Add(sProposition);
        end;
      end;
    end;
  end else TSynCompletionProposal(Sender).ItemList.Clear;
end;

// Is called when form create
procedure TfrmMain.FillLookUpList;
var
  pFctInfo: TFctInfo;
  hFileSearch: TSearchRec;
  sFileContent: TStringList;
  x, y: Integer;
begin
  // Initialize stuff before starting
  LookupList.Clear;

  // Go through all libraries search paths
  for x := 0 to LibrariesSearchPaths.Count - 1 do
  begin
    // Begin file search
    if FindFirst(LibrariesSearchPaths.Strings[x]+'*.lib', faAnyFile, hFileSearch) = 0 then
    begin
      repeat
        // Create and initialize temporary content container
        sFileContent := TStringList.Create;
        sFileContent.LoadFromFile(LibrariesSearchPaths.Strings[x]+hFileSearch.Name);

        // Parse content and add it to the lookup list
        for y := 0 to sFileContent.Count - 1 do
        begin
          if UpperCase(Copy(sFileContent.Strings[y], Length(sFileContent.Strings[y]) - 2, 3)) = 'FOO' then
            LookupList.Add(Copy(sFileContent.Strings[y], 1, Pos('(', sFileContent.Strings[y]) - 1));
        end;

        // Free temporary content container
        sFileContent.Free;
      until FindNext(hFileSearch) <> 0;

      FindClose(hFileSearch);
    end;
  end;

  // Add local definitions
  for x := 0 to frmFunctionList.lvwFunctions.Items.Count - 1 do
  begin
    pFctInfo := TFctInfo(frmFunctionList.lvwFunctions.Items[x].Data);
    LookupList.Add(Copy(pFctInfo.FctDef, 1, Pos('(', pFctInfo.FctDef) - 1));
  end;
end;

procedure TfrmMain.actEditorSettingsExecute(Sender: TObject);
begin
  frmEditorSettings.ShowModal;
end;

procedure TfrmMain.LoadEditorSettings;
var
  pIniFile: TIniFile;
begin
  pIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'LuaEdit.ini');
  EditorColors.Clear;

  // Reading print Settings
  PrintUseColor := pIniFile.ReadBool('PrintSetup', 'UseColors', True);
  PrintUseSyntax := pIniFile.ReadBool('PrintSetup', 'UseSyntax', True);
  PrintUseWrapLines := pIniFile.ReadBool('PrintSetup', 'UseWrapLines', True);
  PrintLineNumbers := pIniFile.ReadBool('PrintSetup', 'LineNumbers', False);
  PrintLineNumbersInMargin := pIniFile.ReadBool('PrintSetup', 'LineNumbersInMargin', False);

  //Reading general settings
  EditorOptions := [eoScrollPastEol, eoEnhanceHomeKey, eoTabIndent, eoHideShowScrollbars, eoScrollPastEof, eoAutoIndent];
  EditorOptions := TSynEditorOptions(pIniFile.ReadInteger('General', 'EditorOptions', Integer(EditorOptions)));

  // Remove all options we absolutly don't want to have to make sure we don't have them!
  EditorOptions := EditorOptions - [eoShowSpecialChars, eoSpecialLineDefaultFg, eoNoSelection, eoDisableScrollArrows, eoDropFiles, eoNoCaret];

  UndoLimit := pIniFile.ReadInteger('General', 'UndoLimit', 1000);
  TabWidth := pIniFile.ReadInteger('General', 'TabWidth', 4);
  AssociateFiles := pIniFile.ReadBool('General', 'AssociateFiles', False);
  SaveBreakpoints := pIniFile.ReadBool('General', 'SaveBreakpoints', True);
  SaveUnitsInc := pIniFile.ReadBool('General', 'SaveUnitsInc', False);
  SaveProjectsInc := pIniFile.ReadBool('General', 'SaveProjectsInc', False);
  ShowExSaveDlg := pIniFile.ReadBool('General', 'ShowExSaveDlg', True);

  // Reading Environment settings
  LibrariesSearchPaths.CommaText := pIniFile.ReadString('Environement', 'LibrariesSearchPaths', ExtractFilePath(Application.ExeName)+'Libraries\Completion');
  
  //Reading display settings
  ShowGutter := pIniFile.ReadBool('Display', 'ShowGutter', True);
  ShowLineNumbers := pIniFile.ReadBool('Display', 'ShowLineNumbers', False);
  LeadingZeros := pIniFile.ReadBool('Display', 'LeadingZeros', False);
  GutterWidth := pIniFile.ReadInteger('Display', 'GutterWidth', 30);
  GutterColor := pIniFile.ReadString('Display', 'GutterColor', 'clBtnFace');
  FontName := pIniFile.ReadString('Display', 'FontName', 'Courier');
  FontSize := pIniFile.ReadInteger('Display', 'FontSize', 10);

  pIniFile.Free;
  pIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\LuaEdit.dat');

  //Background
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[0]).Background := pIniFile.ReadString('Background', 'Background', 'clWhite');

  //Comment
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[1]).Background := pIniFile.ReadString('Comment', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[1]).Foreground := pIniFile.ReadString('Comment', 'ForegroundColor', 'clGreen');
  TEditorColors(EditorColors.Items[1]).IsBold := pIniFile.ReadBool('Comment', 'IsBold', False);
  TEditorColors(EditorColors.Items[1]).IsItalic := pIniFile.ReadBool('Comment', 'IsItalic', False);
  TEditorColors(EditorColors.Items[1]).IsUnderline := pIniFile.ReadBool('Comment', 'IsUnderline', False);

  //Error line
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[2]).Background := pIniFile.ReadString('Error Line', 'BackgroundColor', 'clRed');
  TEditorColors(EditorColors.Items[2]).Foreground := pIniFile.ReadString('Error Line', 'ForegroundColor', 'clWhite');

  //Execution line
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[3]).Background := pIniFile.ReadString('Execution Line', 'BackgroundColor', 'clBlue');
  TEditorColors(EditorColors.Items[3]).Foreground := pIniFile.ReadString('Execution Line', 'ForegroundColor', 'clWhite');

  //Identifiers
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[4]).Background := pIniFile.ReadString('Identifier', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[4]).Foreground := pIniFile.ReadString('Identifier', 'ForegroundColor', 'clBlack');
  TEditorColors(EditorColors.Items[4]).IsBold := pIniFile.ReadBool('Identifier', 'IsBold', False);
  TEditorColors(EditorColors.Items[4]).IsItalic := pIniFile.ReadBool('Identifier', 'IsItalic', False);
  TEditorColors(EditorColors.Items[4]).IsUnderline := pIniFile.ReadBool('Identifier', 'IsUnderline', False);

  //Numbers
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[5]).Background := pIniFile.ReadString('Numbers', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[5]).Foreground := pIniFile.ReadString('Numbers', 'ForegroundColor', 'clBlue');
  TEditorColors(EditorColors.Items[5]).IsBold := pIniFile.ReadBool('Numbers', 'IsBold', False);
  TEditorColors(EditorColors.Items[5]).IsItalic := pIniFile.ReadBool('Numbers', 'IsItalic', False);
  TEditorColors(EditorColors.Items[5]).IsUnderline := pIniFile.ReadBool('Numbers', 'IsUnderline', False);

  //Reserved words
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[6]).Background := pIniFile.ReadString('Reserved Words', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[6]).Foreground := pIniFile.ReadString('Reserved Words', 'ForegroundColor', 'clBlue');
  TEditorColors(EditorColors.Items[6]).IsBold := pIniFile.ReadBool('Reserved Words', 'IsBold', False);
  TEditorColors(EditorColors.Items[6]).IsItalic := pIniFile.ReadBool('Reserved Words', 'IsItalic', False);
  TEditorColors(EditorColors.Items[6]).IsUnderline := pIniFile.ReadBool('Reserved Words', 'IsUnderline', False);

  //Selection
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[7]).Background := pIniFile.ReadString('Selection', 'BackgroundColor', 'clHighlight');
  TEditorColors(EditorColors.Items[7]).Foreground := pIniFile.ReadString('Selection', 'ForegroundColor', 'clBlack');

  //Strings
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[8]).Background := pIniFile.ReadString('Strings', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[8]).Foreground := pIniFile.ReadString('Strings', 'ForegroundColor', 'clNavy');
  TEditorColors(EditorColors.Items[8]).IsBold := pIniFile.ReadBool('Strings', 'IsBold', False);
  TEditorColors(EditorColors.Items[8]).IsItalic := pIniFile.ReadBool('Strings', 'IsItalic', False);
  TEditorColors(EditorColors.Items[8]).IsUnderline := pIniFile.ReadBool('Strings', 'IsUnderline', False);

  //Breakpoints
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[9]).Background := pIniFile.ReadString('Valid Breakpoint', 'BackgroundColor', 'clMaroon');
  TEditorColors(EditorColors.Items[9]).Foreground := pIniFile.ReadString('Valid Breakpoint', 'ForegroundColor', 'clWhite');
  
  pIniFile.Free;
end;

procedure TfrmMain.ApplyValuesToEditor(synTemp: TSynEdit; lstColorSheme: TList);
var
  x: Integer;
  TempStyle: TFontStyles;
begin
  synTemp.Options := EditorOptions;
  synTemp.TabWidth := TabWidth;
  synTemp.MaxUndo := UndoLimit;
  synTemp.Gutter.Visible := ShowGutter;
  synTemp.Gutter.LeadingZeros := LeadingZeros;
  synTemp.Gutter.ShowLineNumbers := ShowLineNumbers;
  synTemp.Gutter.Width := GutterWidth;
  synTemp.Gutter.Color := StringToColor(GutterColor);
  synTemp.Font.Name := FontName;
  synTemp.Font.Size := FontSize;
  synTemp.Color := StringToColor(TEditorColors(lstColorSheme.Items[0]).Background);
  synTemp.SelectedColor.Foreground := StringToColor(TEditorColors(lstColorSheme.Items[7]).Foreground);
  synTemp.SelectedColor.Background := StringToColor(TEditorColors(lstColorSheme.Items[7]).Background);

  for x := 0 to synTemp.Highlighter.AttrCount - 1 do
  begin
    TempStyle := [];

    if synTemp.Highlighter.Attribute[x].Name = 'Comment' then
    begin
      synTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[1]).Background);
      synTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[1]).Foreground);

      if TEditorColors(lstColorSheme.Items[1]).IsBold then
        TempStyle := TempStyle + [fsBold];

      if TEditorColors(lstColorSheme.Items[1]).IsItalic then
        TempStyle := TempStyle + [fsItalic];

      if TEditorColors(lstColorSheme.Items[1]).IsUnderline then
        TempStyle := TempStyle + [fsUnderline];

      synTemp.Highlighter.Attribute[x].Style := TempStyle;
    end
    else if synTemp.Highlighter.Attribute[x].Name = 'Identifier' then
    begin
      synTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[4]).Background);
      synTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[4]).Foreground);

      if TEditorColors(lstColorSheme.Items[4]).IsBold then
        TempStyle := TempStyle + [fsBold];

      if TEditorColors(lstColorSheme.Items[4]).IsItalic then
        TempStyle := TempStyle + [fsItalic];

      if TEditorColors(lstColorSheme.Items[4]).IsUnderline then
        TempStyle := TempStyle + [fsUnderline];

      synTemp.Highlighter.Attribute[x].Style := TempStyle;
    end
    else if synTemp.Highlighter.Attribute[x].Name = 'Reserved Word' then
    begin
      synTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[6]).Background);
      synTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[6]).Foreground);

      if TEditorColors(lstColorSheme.Items[6]).IsBold then
        TempStyle := TempStyle + [fsBold];

      if TEditorColors(lstColorSheme.Items[6]).IsItalic then
        TempStyle := TempStyle + [fsItalic];

      if TEditorColors(lstColorSheme.Items[6]).IsUnderline then
        TempStyle := TempStyle + [fsUnderline];

      synTemp.Highlighter.Attribute[x].Style := TempStyle;
    end
    else if ((synTemp.Highlighter.Attribute[x].Name = 'String') or (synTemp.Highlighter.Attribute[x].Name = 'LuaMString')) then
    begin
      synTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[8]).Background);
      synTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[8]).Foreground);

      if TEditorColors(lstColorSheme.Items[8]).IsBold then
        TempStyle := TempStyle + [fsBold];

      if TEditorColors(lstColorSheme.Items[8]).IsItalic then
        TempStyle := TempStyle + [fsItalic];

      if TEditorColors(lstColorSheme.Items[8]).IsUnderline then
        TempStyle := TempStyle + [fsUnderline];

      synTemp.Highlighter.Attribute[x].Style := TempStyle;
    end
    else if synTemp.Highlighter.Attribute[x].Name = 'Numbers' then
    begin
      synTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[5]).Background);
      synTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[5]).Foreground);

      if TEditorColors(lstColorSheme.Items[5]).IsBold then
        TempStyle := TempStyle + [fsBold];

      if TEditorColors(lstColorSheme.Items[5]).IsItalic then
        TempStyle := TempStyle + [fsItalic];

      if TEditorColors(lstColorSheme.Items[5]).IsUnderline then
        TempStyle := TempStyle + [fsUnderline];

      synTemp.Highlighter.Attribute[x].Style := TempStyle;
    end;
  end;
end;

procedure TfrmMain.GotoBookmarkClick(Sender: TObject);
var
  iBookmark: Integer;
begin
  iBookmark := TMenuItem(Sender).Tag;

  if iBookmark = 1 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker1, #0, nil);
  end
  else if iBookmark = 2 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker2, #0, nil);
  end
  else if iBookmark = 3 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker3, #0, nil);
  end
  else if iBookmark = 4 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker4, #0, nil);
  end
  else if iBookmark = 5 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker5, #0, nil);
  end
  else if iBookmark = 6 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker6, #0, nil);
  end
  else if iBookmark = 7 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker7, #0, nil);
  end
  else if iBookmark = 8 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker8, #0, nil);
  end
  else if iBookmark = 9 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker9, #0, nil);
  end
  else if iBookmark = 0 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker0, #0, nil);
  end;
end;

procedure TfrmMain.ToggleBookmarkClick(Sender: TObject);
var
  iBookmark: Integer;
begin
  iBookmark := TMenuItem(Sender).Tag;

  if iBookmark = 1 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker1, #0, nil);
  end
  else if iBookmark = 2 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker2, #0, nil);
  end
  else if iBookmark = 3 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker3, #0, nil);
  end
  else if iBookmark = 4 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker4, #0, nil);
  end
  else if iBookmark = 5 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker5, #0, nil);
  end
  else if iBookmark = 6 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker6, #0, nil);
  end
  else if iBookmark = 7 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker7, #0, nil);
  end
  else if iBookmark = 8 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker8, #0, nil);
  end
  else if iBookmark = 9 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker9, #0, nil);
  end
  else if iBookmark = 0 then
  begin
    TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker0, #0, nil);
  end;
end;

procedure TfrmMain.Calculator1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', 'calc', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.Conversions1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + '\Convert.exe'), nil, nil,  SW_SHOWNORMAL);
end;

procedure TfrmMain.actBlockUnindentExecute(Sender: TObject);
begin
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecBlockUnindent, #0, nil);
end;

procedure TfrmMain.actBlockIndentExecute(Sender: TObject);
begin
  TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecBlockIndent, #0, nil);
end;

procedure TfrmMain.actBlockCommentExecute(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
  x: Integer;
begin
  pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);

  for x := pLuaUnit.synUnit.BlockBegin.Line to pLuaUnit.synUnit.BlockEnd.Line - 1 do
  begin
    if Copy(pLuaUnit.synUnit.Lines.Strings[x], 1, 2) <> '--' then
      pLuaUnit.synUnit.Lines.Strings[x] := '--' + pLuaUnit.synUnit.Lines.Strings[x];
  end;
end;

procedure TfrmMain.actBlockUncommentExecute(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
  x: Integer;
begin
  pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);

  for x := pLuaUnit.synUnit.BlockBegin.Line - 1 to pLuaUnit.synUnit.BlockEnd.Line - 1 do
  begin
    if Copy(pLuaUnit.synUnit.Lines.Strings[x], 1, 2) = '--' then
      pLuaUnit.synUnit.Lines.Strings[x] := Copy(pLuaUnit.synUnit.Lines.Strings[x], 3, Length(pLuaUnit.synUnit.Lines.Strings[x]) - 2);
  end;
end;

procedure TfrmMain.actPrjSettingsExecute(Sender: TObject);
begin
  frmPrjOptions.GetLuaProjectOptions(ActiveProject);
  if frmPrjOptions.ShowModal = mrOk then
  begin
    frmPrjOptions.SetLuaProjectOptions(ActiveProject);
    frmProjectTree.BuildProjectTree;
  end;
end;

procedure TfrmMain.actActiveSelPrjExecute(Sender: TObject);
begin
  if Assigned(frmProjectTree.trvProjectTree.Selected) then
  begin
    if frmProjectTree.trvProjectTree.Selected.ImageIndex = 0 then
    begin
      ActiveProject := TLuaProject(frmProjectTree.trvProjectTree.Selected.Data);
      frmProjectTree.BuildProjectTree;
    end;
  end;
end;

function TfrmMain.ExecuteInitializer(sInitializer: String; L: PLua_State): Integer;
var
  Ptr: TFarProc;
  pFunc: TInitializer;
  iFuncReturn: Integer;
begin
  try
    hModule := LoadLibrary(PChar(sInitializer));
    Ptr := GetProcAddress(hModule, 'LuaDebug_Initializer');
    pFunc := TInitializer(Ptr);
    iFuncReturn := pFunc(L);

    Result := iFuncReturn;
  except
    Result := -1;
    
    if hModule <> NULL then
      FreeLibrary(hModule);

    Application.MessageBox(PChar('An error occured when attempting to call the initializer from "'+sInitializer+'".'), 'LuaEdit', MB_ICONERROR+MB_OK);
  end;
end;

procedure TfrmMain.RefreshOpenedUnits;
var
  x: Integer;
begin
  for x := 0 to LuaOpenedUnits.Count - 1 do
  begin
    if not TLuaUnit(LuaOpenedUnits.Items[x]).HasChanged then
    begin
      jvUnitBar.Tabs[x].Caption := TLuaUnit(LuaOpenedUnits.Items[x]).sName;
      jvUnitBar.Tabs[x].Modified := False;
    end
    else
    begin
      jvUnitBar.Tabs[x].Modified := True;
    end;
  end;
end;

function TfrmMain.FileIsInTree(sFileName: String): Boolean;
var
  x: Integer;
begin
  Result := False;

  for x := 0 to frmProjectTree.trvProjectTree.Items.Count - 1 do
  begin
    if ((frmProjectTree.trvProjectTree.Items[x].ImageIndex <> 0) or (frmProjectTree.trvProjectTree.Items[x].SelectedIndex <> 0)) then
    begin
      if TLuaUnit(frmProjectTree.trvProjectTree.Items[x].Data).pPrjOwner.sPrjName = '[@@SingleUnits@@]' then
      begin
        if TLuaUnit(frmProjectTree.trvProjectTree.Items[x].Data).sUnitPath = sFileName then
        begin
          if LuaOpenedUnits.IndexOf(TLuaUnit(frmProjectTree.trvProjectTree.Items[x].Data)) <> -1 then
            GetAssociatedTab(TLuaUnit(frmProjectTree.trvProjectTree.Items[x].Data)).Selected := True
          else
            AddFileInTab(TLuaUnit(frmProjectTree.trvProjectTree.Items[x].Data));

          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain.ErrorLookup1Click(Sender: TObject);
begin
  frmErrorLookup.Show;
end;

procedure TfrmMain.PrintSetup1Click(Sender: TObject);
begin
  frmPrintSetup.ShowModal;
end;

procedure TfrmMain.actPrintExecute(Sender: TObject);
begin
  synEditPrint.SynEdit := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit;
  synEditPrint.Title := TLuaUnit(jvUnitBar.SelectedTab.Data).sUnitPath;

  if synEditPrint.PageCount > 1 then
  begin
    pdlgPrint.Options := pdlgPrint.Options + [poPageNums];
    pdlgPrint.MinPage := 1;
    pdlgPrint.MaxPage := synEditPrint.PageCount;
  end
  else
  begin
    pdlgPrint.Options := pdlgPrint.Options - [poPageNums];
  end;

  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail then
  begin
    pdlgPrint.Options := pdlgPrint.Options + [poSelection];
  end
  else
  begin
    pdlgPrint.Options := pdlgPrint.Options - [poSelection];
  end;

  if pdlgPrint.Execute then
  begin
    synEditPrint.Colors := PrintUseColor;
    synEditPrint.Highlight := PrintUseSyntax;
    synEditPrint.Wrap := PrintUseWrapLines;
    synEditPrint.LineNumbers := PrintLineNumbers;
    synEditPrint.LineNumbersInMargin := PrintLineNumbersInMargin;
    synEditPrint.Copies := pdlgPrint.Copies;

    if pdlgPrint.PrintRange = prPageNums then
    begin
      synEditPrint.PrintRange(pdlgPrint.FromPage, pdlgPrint.ToPage);
    end
    else if pdlgPrint.PrintRange = prAllPages then
    begin
      if pdlgPrint.PrintRange = prSelection then
      begin
        synEditPrint.SelectedOnly := True
      end;

      synEditPrint.Print;
    end;
  end;
end;

procedure TfrmMain.ctrlBarDockOver(Sender: TObject; Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  ARect: TRect;
begin
  Accept := (Source.Control is TToolBar);
  if Accept then
  begin
    //Modify the DockRect to preview dock area (Coolbar client area)
    ARect.TopLeft := ctrlBar.ClientToScreen(ctrlBar.ClientRect.TopLeft);
    ARect.BottomRight := ctrlBar.ClientToScreen(ctrlBar.ClientRect.BottomRight);
    Source.DockRect := ARect;
  end;
end;

procedure TfrmMain.File2Click(Sender: TObject);
begin
  if tlbBaseFile.Visible then
    tlbBaseFile.Hide
  else
    tlbBaseFile.Show;
end;

procedure TfrmMain.Edit2Click(Sender: TObject);
begin
  if tlbEdit.Visible then
    tlbEdit.Hide
  else
    tlbEdit.Show;
end;

procedure TfrmMain.Run3Click(Sender: TObject);
begin
  if tlbRun.Visible then
    tlbRun.Hide
  else
    tlbRun.Show;
end;

procedure RelaunchRunningThread;
begin
  WaitForSingleObject(hMutex, INFINITE);
  ReleaseMutex(hMutex);
  frmMain.actRunScriptExecute(nil);
end;

procedure TfrmMain.ASciiTable1Click(Sender: TObject);
begin
  frmAsciiTable.ShowModal;
end;

procedure TfrmMain.Help1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(ExtractFilePath(Application.ExeName)+'\Help\LuaEdit.chm'), nil, nil, SW_SHOWNORMAL);
end;

procedure TDebuggerThread.Execute;
begin
  //frmMain.actCompileExecute(nil);

  {if IsCompiledComplete then
  begin
    if WSAStartup($101, WSA) <> 0 then
    begin
      Application.MessageBox('Invalid winsock version!', 'LuaEdit', MB_OK+MB_ICONERROR);
      EndThread(0);
    end;
       
    try
      pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);
      pSock := INVALID_SOCKET;
      pRSock := INVALID_SOCKET;

      //initializing connection
      pSock := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
      if pSock = INVALID_SOCKET then
        raise ELuaEditException.Create('Remote Debug Failed: Cannot open socket!');

      FillChar(pAddrIn, SizeOf(pAddrIn), 0);
      pAddrIn.sin_family := PF_INET;
      pAddrIn.sin_port := htons(pLuaUnit.pPrjOwner.RemotePort);
      pAddrIn.sin_addr.S_addr := htonl(INADDR_ANY);

      //Bind the socket
      if bind(pSock, TSockAddr(pAddrIn), SizeOf(pAddrIn)) <> 0 then
      begin
        sTemp := SysErrorMessage(WSAGetLastError());
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed on binding');
      end;

      //Listen for any client...
      if listen(pSock, 5) <> 0 then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed on listening');

      //Building CntString...
      frmCntString.memoCntString.Lines.Clear;
      frmCntString.memoCntString.Text := 'rdbg.exe "'+GetLocalIP+'" "'+IntToStr(pLuaUnit.pPrjOwner.RemotePort)+'"';

      //Wait after user interaction...
      WaitForSingleObject(hMutex, INFINITE);

      //Accept next incoming connection
      pRSock := accept(pSock, 0, 0);
      if pRSock = INVALID_SOCKET then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed on accepting');

      ReleaseMutex(hMutex);
      IsRunning := True;

      //Set a TimeOut (15sec)...
      TimeOut := 15000;
      setsockopt(pRSock, SOL_SOCKET, SO_RCVTIMEO, PChar(@TimeOut), SizeOf(TimeOut));

      //Start communication...
      //send remote initializer full path...
      if pLuaUnit.pPrjOwner.RemoteInitializer = '' then
        Buffer := '@@N/A@@'   //Cannot send an empty string over tcp...
      else

      Buffer := pLuaUnit.pPrjOwner.RemoteInitializer;
      Len := Length(Buffer);

      Status := send(pRSock, Len, SizeOf(Len), 0);
      if Status <> SizeOf(Len) then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the lenght of the remote initializer full path');

      Status := send(pRSock, Buffer[1], Length(Buffer), 0);
      if Status <> Length(Buffer) then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the remote initializer full path');

      //send remote file name...
      Buffer := pLuaUnit.pPrjOwner.DownloadDir + ExtractFileName(pLuaUnit.sName);
      Len := Length(Buffer);

      Status := send(pRSock, Len, SizeOf(Len), 0);
      if Status <> SizeOf(Len) then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the lenght of the remote file name');

      Status := send(pRSock, Buffer[1], Length(Buffer), 0);
      if Status <> Length(Buffer) then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the remote file name');

      //send the file content...
      ContentByte := Length(pLuaUnit.synUnit.Text);
      Status := send(pRSock, ContentByte, SizeOf(ContentByte), 0);
      if Status <> SizeOf(ContentByte) then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the length of the file content to send');

      ContentByte := 0;
      ContentBuffer := 'a = nil' + #$D + #$A;
      ContentBuffer := ContentBuffer + pLuaUnit.synUnit.Text;

      while ContentByte < Length(ContentBuffer) do
      begin
        if (Length(ContentBuffer) - ContentByte) >= 1024 then
          Len := 1024
        else
          Len := Length(ContentBuffer) - ContentByte;

        Buffer := '';
        Buffer := Copy(ContentBuffer, ContentByte + 1, Len);
        Inc(ContentByte, Len);

        Status := send(pRSock, Len, SizeOf(Len), 0);
        if Status <> SizeOf(Len) then
          raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the lenght of the remote file content');

        Status := send(pRSock, Buffer[1], Length(Buffer), 0);
        if Status <> Length(Buffer) then
          raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the content of the remote file');
      end;

      //Handle user debugging...
      while 1 = 1 do
      begin
        //receiving acknoledge bytes... (is also use to know if the script is in an error state...)
        Status := recv(pRSock, Continue, SizeOf(Continue), 0);
        if Status <> SizeOf(Continue) then
          raise ELuaEditException.Create('Remote Debug Failed: The oepration failed while sending acknoledge bytes');

        if Continue = -1 then
        begin
          //receiving compiled message
          FillChar(RecvBuffer, SizeOf(RecvBuffer), 0);
          Len := 0;

          Status := recv(pRSock, Len, SizeOf(Len), 0);
          if Status <> SizeOf(Len) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the compiled message length');

          Status := recv(pRSock, RecvBuffer, Len, 0);
          if Status <> Len then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the compiled message');

          LastMessage := RecvBuffer;

          if LastMessage <> '@@STOPSCRIPT@@' then
          begin
            sTemp := Copy(LastMessage, Pos(':', LastMessage) + 1, Length(LastMessage) - Pos(':', LastMessage));
            TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError := StrToInt(Copy(sTemp, 1, Pos(':', sTemp) - 1));
            TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError);
            TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.CaretX := Length(TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.LineText) + 1;
            LastMessage := '(Line: '+IntToStr(TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError)+')' + Copy(sTemp, Pos(':', sTemp) + 1, Length(sTemp) - Pos(':', sTemp));
            TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
            frmMain.stbMain.Refresh;
            IsCompiledComplete := False;
            Application.MessageBox(PChar(LastMessage), 'LuaEdit', MB_OK+MB_ICONERROR);
          end;

          Continue := 1;

          Status := send(pRSock, Continue, SizeOf(Continue), 0);
          if Status <> SizeOf(Continue) then
            raise ELuaEditException.Create('Remote Debug Failed: The oepration failed while sending acknoledge bytes');

          IsRunning := False;
          Break;
        end;

        CallRemoteHookFunc(pRSock);
      end;
    finally
      if pSock <> INVALID_SOCKET then
        closesocket(pSock);

      if pRSock <> INVALID_SOCKET then
        closesocket(pRSock);

      if Assigned(frmCntString) then
        frmCntString.Free;

      IsRunning := False;
      WSACleanup;
    end;
  end; }
end;

procedure CallRemoteHookFunc(pSock: TSocket);
var
  sStackString: String;
  x, Status: Integer;
  BtnInfos: Integer;
  Answer, CaretY: Integer;
  Len, ItemCount: Integer;
  AR: lua_Debug;
  DbgBuffer: array[0..5000] of char;
  DbgString: String;
  DbgInt: Integer;
  DbgLen: Integer;
  Buffer: array[0..5000] of char;
begin
  if StopPressed then
  begin
    Answer := 1;
    StopPressed := False;
    TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug := -1;
  end
  else
    Answer := 0;

  //sending Stop button status
  Status := send(pSock, Answer, SizeOf(Answer), 0);
  if Status <> SizeOf(Answer) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the stop button status');

  //sending Pause button status
  if PausePressed then
    Answer := 1
  else
    Answer := 0;
    
  Status := send(pSock, Answer, SizeOf(Answer), 0);
  if Status <> SizeOf(Answer) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the pause button status');

  //sending RunToCursor button status
  if RunToCursorPressed then
    Answer := 1
  else
    Answer := 0;

  Status := send(pSock, Answer, SizeOf(Answer), 0);
  if Status <> SizeOf(Answer) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the RunToCursor button status');

  //receiving the lua_debug structure
  Status := recv(pSock, DbgInt, SizeOf(DbgInt), 0);
  if Status <> SizeOf(DbgInt) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  // - 1 because of the lua debug bug!!!
  AR.currentline := DbgInt - 1;

  Status := recv(pSock, DbgInt, SizeOf(DbgInt), 0);
  if Status <> SizeOf(DbgInt) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  AR.event := DbgInt;

  Status := recv(pSock, DbgInt, SizeOf(DbgInt), 0);
  if Status <> SizeOf(DbgInt) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  AR.i_ci := DbgInt;

  Status := recv(pSock, DbgInt, SizeOf(DbgInt), 0);
  if Status <> SizeOf(DbgInt) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  AR.linedefined := DbgInt;

  Status := recv(pSock, DbgInt, SizeOf(DbgInt), 0);
  if Status <> SizeOf(DbgInt) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  AR.nups := DbgInt;

  FillChar(DbgBuffer, 5000, 0);
  DbgString := '';
  DbgLen := 0;

  Status := recv(pSock, DbgLen, SizeOf(DbgLen), 0);
  if Status <> SizeOf(DbgLen) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  Status := recv(pSock, DbgBuffer, DbgLen, 0);
  if Status <> DbgLen then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  DbgString := DbgBuffer;
  if DbgString = '@@LUA_TNIL@@' then
    AR.name := nil
  else
    AR.name := PChar(DbgString); 

  FillChar(DbgBuffer, 5000, 0);
  DbgString := '';
  DbgLen := 0;

  Status := recv(pSock, DbgLen, SizeOf(DbgLen), 0);
  if Status <> SizeOf(DbgLen) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  Status := recv(pSock, DbgBuffer, DbgLen, 0);
  if Status <> DbgLen then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  DbgString := DbgBuffer;
  if DbgString = '@@LUA_TNIL@@' then
    AR.namewhat := nil
  else
    AR.namewhat := PChar(DbgString);

  FillChar(DbgBuffer, 5000, 0);
  DbgString := '';
  DbgLen := 0;

  Status := recv(pSock, DbgLen, SizeOf(DbgLen), 0);
  if Status <> SizeOf(DbgLen) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  Status := recv(pSock, DbgBuffer, DbgLen, 0);
  if Status <> DbgLen then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  DbgString := DbgBuffer;
  if DbgString = '@@LUA_TNIL@@' then
    AR.short_src := ''
  else
    StrPCopy(AR.short_src, DbgString[1]);

  FillChar(DbgBuffer, 5000, 0);
  DbgString := '';
  DbgLen := 0;

  Status := recv(pSock, DbgLen, SizeOf(DbgLen), 0);
  if Status <> SizeOf(DbgLen) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  Status := recv(pSock, DbgBuffer, DbgLen, 0);
  if Status <> DbgLen then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  DbgString := DbgBuffer;
  if DbgString = '@@LUA_TNIL@@' then
    AR.source := nil
  else
    AR.source := PChar(DbgString);

  FillChar(DbgBuffer, 5000, 0);
  DbgString := '';
  DbgLen := 0;

  Status := recv(pSock, DbgLen, SizeOf(DbgLen), 0);
  if Status <> SizeOf(DbgLen) then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  Status := recv(pSock, DbgBuffer, DbgLen, 0);
  if Status <> DbgLen then
    raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving a field of the PLua_Debug structure');

  DbgString := DbgBuffer;
  if DbgString = '@@LUA_TNIL@@' then
    AR.what := nil
  else
    AR.what := PChar(DbgString);

  //Sending Current line informations...
  if TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.IsBreakPointLine(AR.currentline) then
  begin
    Answer := 1;
    IsRunning := False;
    WaitInCallLevel := -1;
  end
  else if FirstLineStop then
  begin
    FirstLineStop := False;
    Answer := 1;
    IsRunning := False;
    WaitInCallLevel := -1;
  end
  else
    Answer := 0;

  Status := send(pSock, Answer, SizeOf(Answer), 0);
  if Status <> SizeOf(Answer) then
    ELuaEditException.Create('Remote Debug Failed: The operation failed while sending Current line informations');

  //sending Caret Y...
  CaretY := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.CaretY;
  Status := send(pSock, CaretY, SizeOf(CaretY), 0);
  if Status <> SizeOf(CaretY) then
    raise ELuaEditException.Create('Remote Debug Failed: The opertion failed while sending the caret y position');

  if ((RunToCursorPressed = True) and (AR.currentline = TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.CaretY)) then
  begin
    RunToCursorPressed := False;
    IsRunning := False;
    WaitInCallLevel := -1;
  end
  else if ((RunToCursorPressed = True) and (IsRunning = False)) then
  begin
    IsRunning := True;
  end;

  if ((IsRunning = False) and (StopPressed = False)) then
  begin
    frmStack.lstCallStack.Items.Assign(Main.lstStack);
    frmStack.lstCallStack.Refresh;
    lstLuaStack.Clear;

    //receiving item numbers...
    Status := recv(pSock, ItemCount, SizeOf(ItemCount), 0);
    if Status <> SizeOf(ItemCount) then
      raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the number of item for the lua stack');

    //receiving items values
    for x := 0 to ItemCount - 1 do
    begin
      FillChar(Buffer, SizeOf(Buffer), 0);
      Len := 0;

      Status := recv(pSock, Len, SizeOf(Len), 0);
      if Status <> SizeOf(Len) then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the length of an item value for the lua stack');

      Status := recv(pSock, Buffer, Len, 0);
      if Status <> Len then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the value of an item for the lua stack');

      lstLuaStack.Add(Buffer);
    end;

    frmLuaStack.lstLuaStack.Items.Assign(Main.lstLuaStack);
    frmLuaStack.lstLuaStack.Refresh;
  end;

  Case AR.event of
    LUA_HOOKCALL:
    begin
      if AR.name <> nil then
      begin
        //receiving sStackString...
        FillChar(Buffer, SizeOf(Buffer), 0);
        Len := 0;

        Status := recv(pSock, Len, SizeOf(Len), 0);
        if Status <> SizeOf(Len) then
          raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the length of the sStackString value');

        Status := recv(pSock, Buffer, Len, 0);
        if Status <> Len then
          raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the sStackString value');

        sStackString := Buffer;

        lstStack.Add(sStackString);
      end;
      Inc(CallLevel);
    end;
    LUA_HOOKRET:
    begin
      if AR.name <> nil then
      begin
        lstStack.Delete(lstStack.Count - 1);
        StepIntoPressed := False;
      end;
      Dec(CallLevel);
    end;
    LUA_HOOKLINE:
    begin
      if ((WaitInCallLevel <> -1) and (PausePressed = False)) then
      begin
        if CallLevel > WaitInCallLevel then
        begin
          Exit;
        end
        else
        begin
          WaitInCallLevel := -1;
        end;
      end;
      
      if ((IsRunning = False) or (PausePressed = True)) then
      begin
        TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(AR.currentline);
        TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug := AR.currentline;
        TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
        frmMain.UpdateWatch;
        frmStack.lstCallStack.Items.Assign(Main.lstStack);
        lstLuaStack.Clear;
        lstLocals.Clear;
        lstGlobals.Clear;

        //receiving items numbers...
        Status := recv(pSock, ItemCount, SizeOf(ItemCount), 0);
        if Status <> SizeOf(ItemCount) then
          raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the number of item for the lua stack');

        //receiving items values
        for x := 0 to ItemCount - 1 do
        begin
          FillChar(Buffer, SizeOf(Buffer), 0);
          Len := 0;

          Status := recv(pSock, Len, SizeOf(Len), 0);
          if Status <> SizeOf(Len) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the length of an item value for the lua stack');

          Status := recv(pSock, Buffer, Len, 0);
          if Status <> Len then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the value of an item for the lua stack');

          lstLuaStack.Add(Buffer);
        end;

        //receiving locals numbers...
        Status := recv(pSock, ItemCount, SizeOf(ItemCount), 0);
        if Status <> SizeOf(ItemCount) then
          raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the number of locals to get');

        //receiving locals values
        for x := 0 to ItemCount - 1 do
        begin
          FillChar(Buffer, SizeOf(Buffer), 0);
          Len := 0;

          Status := recv(pSock, Len, SizeOf(Len), 0);
          if Status <> SizeOf(Len) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the length of a local value');

          Status := recv(pSock, Buffer, Len, 0);
          if Status <> Len then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the value of a local');

          lstLocals.Add(Buffer);
        end;

        //receiving globals numbers...
        Status := recv(pSock, ItemCount, SizeOf(ItemCount), 0);
        if Status <> SizeOf(ItemCount) then
          raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the number of globals to get');

        //receiving globals values
        for x := 0 to ItemCount - 1 do
        begin
          FillChar(Buffer, SizeOf(Buffer), 0);
          Len := 0;

          Status := recv(pSock, Len, SizeOf(Len), 0);
          if Status <> SizeOf(Len) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the length of a global value');

          Status := recv(pSock, Buffer, Len, 0);
          if Status <> Len then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while receiving the value of a global');

          lstGlobals.Add(Buffer);
        end;

        frmLuaStack.lstLuaStack.Items.Assign(Main.lstLuaStack);
        frmMain.UpdateWatch;

        if PausePressed then
        begin
          IsRunning := False;
          StepOverPressed := False;
          StepIntoPressed := False;
          PlayPressed := False;
          PausePressed := False;
        end;

        //Waiting for user action...
        while ((StepOverPressed = False) and (StepIntoPressed = False) and (PlayPressed = False) and (StopPressed = False)) do
        begin
          Application.ProcessMessages;
          Sleep(20);
        end;

        //Send pressed button informations
        if StepOverPressed then
        begin
          BtnInfos := LUA_DBGSTEPOVER;
          Status := send(pSock, BtnInfos, SizeOf(BtnInfos), 0);
          if Status <> SizeOf(BtnInfos) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the pressed button informations');
        end
        else if StepIntoPressed then
        begin
          BtnInfos := LUA_DBGSTEPINTO;
          Status := send(pSock, BtnInfos, SizeOf(BtnInfos), 0);
          if Status <> SizeOf(BtnInfos) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the pressed button informations');
        end
        else if PlayPressed then
        begin
          BtnInfos := LUA_DBGPLAY;
          Status := send(pSock, BtnInfos, SizeOf(BtnInfos), 0);
          if Status <> SizeOf(BtnInfos) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the pressed button informations');
        end
        else if StopPressed then
        begin
          BtnInfos := LUA_DBGSTOP;
          Status := send(pSock, BtnInfos, SizeOf(BtnInfos), 0);
          if Status <> SizeOf(BtnInfos) then
            raise ELuaEditException.Create('Remote Debug Failed: The operation failed while sending the pressed button informations');
        end;

        if HasChangedWhileCompiled then
        begin
          if Application.MessageBox('Source has been modified. Recompile?', 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
          begin
            Answer := 1;
            StopPressed := True;
          end
          else
          begin
            Answer := 0;
            HasChangedWhileCompiled := False;
          end;
        end
        else
          Answer := 0;

        //sending changing status...
        Status := send(pSock, Answer, SizeOf(Answer), 0);
        if Status <> SizeOf(Answer) then
          ELuaEditException.Create('Remote Debug Failed: The operation failed while sending changing status');

        if StepOverPressed = True then
        begin
          WaitInCallLevel := CallLevel;
          TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iCurrentLineDebug := -1;
        end;

        StepOverPressed := False;
        StepIntoPressed := False;
        PlayPressed := False;
        PausePressed := False;
      end;
    end;
  end;
end;

function GetLocalIP: String;
var
  pHostE: PHostEnt;
  Buffer: array[0..100] of Char;
begin
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  PHostE := GetHostByName(Buffer);
  Result := StrPas(inet_ntoa(PInAddr(PHostE^.h_addr_list^)^));
end;

procedure TfrmMain.ContributorsList1Click(Sender: TObject);
begin
  frmContributors.ShowModal;
end;

procedure TfrmMain.OpenFileatCursor1Click(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
  WordAtCursor: String;
  x: Integer;
begin
  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail then
    WordAtCursor := ExpandUNCFileName(TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText);

  if FileExists(WordAtCursor) then
  begin
    if ExtractFileExt(WordAtCursor) = '.lua' then
    begin
      if not FileIsInTree(WordAtCursor) then
      begin
        // Creates the file
        pLuaUnit := AddFileInProject(WordAtCursor, False, LuaSingleUnits);
        pLuaUnit.IsLoaded := True;
        AddFileInTab(pLuaUnit);
        MonitorFile(pLuaUnit.sUnitPath);
      end
      else
      begin
        // Finding unit in the tree
        for x := 0 to frmProjectTree.trvProjectTree.Items.Count - 1 do
        begin
          pLuaUnit := TLuaUnit(frmProjectTree.trvProjectTree.Items[x].Data);

          // Check if unit is found
          if pLuaUnit.sUnitPath = WordAtCursor then
          begin
            // Add file in tab bar
            if LuaOpenedUnits.IndexOf(pLuaUnit) = -1 then
            begin
              frmMain.AddFileInTab(pLuaUnit);
            end
            else
            begin
              frmMain.GetAssociatedTab(pLuaUnit).Selected := True;

              if pLuaUnit.HasChanged then
                frmMain.stbMain.Panels[3].Text := 'Modified'
              else
                frmMain.stbMain.Panels[3].Text := '';

              frmMain.synEditClick(pLuaUnit.synUnit);
            end;
            
            Break;
          end;
        end;
      end;

      // Reinitialize stuff...
      frmProjectTree.BuildProjectTree();
      CheckButtons();
    end
    else
      ShellExecute(Self.Handle, 'open', PChar(WordAtCursor), nil, nil,  SW_SHOWNORMAL);
  end
  else
    Application.MessageBox(PChar('Cannot open file "'+WordAtCursor+'"'), 'LuaEdit', MB_OK+MB_ICONERROR);
end;

function LocalOutput(L: PLua_State): Integer; cdecl;
begin
  //prints out here!
  lua_print(L);
  Result := 0;
end;

procedure TfrmMain.ppmEditorPopup(Sender: TObject);
var
  sTextToShow, sOriginalName: String;
begin
  if TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail then
  begin
    OpenFileatCursor1.Enabled := True;
    sOriginalName := StringReplace(TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText, '\\', '\', [rfIgnoreCase, rfReplaceAll]);
    sTextToShow := MinimizeName(sOriginalName, stbMain.Canvas, 150);
    OpenFileatCursor1.Caption := 'Open Document "'+sTextToShow+'"';
  end
  else
  begin
    OpenFileatCursor1.Caption := 'Open Document ""';
    OpenFileatCursor1.Enabled := False;
  end;
end;

function TfrmMain.GetAssociatedTab(pLuaUnit: TLuaUnit): TJvTabBarItem;
var
  x: Integer;
begin
  Result := nil;

  for x := 0 to jvUnitBar.Tabs.Count - 1 do
  begin
    if jvUnitBar.Tabs[x].Data = pLuaUnit then
    begin
      Result := jvUnitBar.Tabs[x];
      Break;
    end;
  end;
end;

procedure TfrmMain.jvUnitBarTabSelected(Sender: TObject; Item: TJvTabBarItem);
var
  pLuaUnit: TLuaUnit;
begin
  if Assigned(Item) then
  begin
    if Assigned(Item.Data) then
    begin
      pLuaUnit := TLuaUnit(Item.Data);

      if Assigned(pCurrentSynEdit) then
        pCurrentSynEdit.Visible := False;
        
      pCurrentSynEdit := pLuaUnit.synUnit;
      pLuaUnit.synUnit.Visible := True;

      if pLuaUnit.HasChanged then
        stbMain.Panels[3].Text := 'Modified'
      else
        stbMain.Panels[3].Text := '';

      if pLuaUnit.IsReadOnly then
        stbMain.Panels[4].Text := 'Read Only'
      else
        stbMain.Panels[4].Text := '';

      synEditClick(pLuaUnit.synUnit);
      frmFunctionList.RefreshList(pLuaUnit.sUnitPath);
      CheckButtons;
    end;
  end;
end;

procedure TfrmMain.jvUnitBarTabClosing(Sender: TObject; Item: TJvTabBarItem; var AllowClose: Boolean);
var
  x: Integer;
begin
  if Assigned(Item) then
  begin
    if Assigned(Item.Data) then
    begin
      if jvUnitBar.ClosingTab <> jvUnitBar.SelectedTab then
      begin
        ClosingUnit;

        // Initialize stuff...
        CheckButtons;
        frmProjectTree.BuildProjectTree;
        frmBreakpoints.RefreshBreakpointList;

        if Assigned(jvUnitBar.SelectedTab) then
        begin
          if jvUnitBar.Tabs.Count = 1 then
          begin
            // Free previously created TFctInfo objects...
            for x := 0 to frmFunctionList.lvwFunctions.Items.Count - 1 do
              TFctInfo(frmFunctionList.lvwFunctions.Items[x].Data).Free;

            frmFunctionList.lvwFunctions.Clear;
          end;
        end;
      end;
    end;
  end;
end;

// check the syntax of the currently opened unit
procedure TfrmMain.actCheckSyntaxExecute(Sender: TObject);
var
  L: Plua_State;
  pLuaUnit: TLuaUnit;
  FileName: String;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      try
        pLuaUnit := TLuaUnit(jvUnitBar.SelectedTab.Data);

        if pLuaUnit.synUnit.Text <> '' then
        begin
          frmLuaEditMessages.memMessages.Lines.Clear;
          L := lua_open();
          LuaLoadBuffer(L, pLuaUnit.synUnit.Text, pLuaUnit.sUnitPath);
          frmLuaEditMessages.memMessages.Lines.Add('[HINT]:  Syntax Checked - '+DateTimeToStr(Now));
        end;
      except
        on E: ELuaException do
        begin
          if Assigned(frmMain.jvUnitBar.SelectedTab) then
          begin
            pLuaUnit := TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data);

            FileName := pLuaUnit.sUnitPath;

            if (not FileExists(FileName)) then
              FileName := PrevFile;

            if (FileExists(FileName) and (E.Line > 0)) then
            begin
              pLuaUnit.pDebugInfos.iLineError := E.Line;
              frmMain.GetAssociatedTab(pLuaUnit).Selected := True;
              pLuaUnit.synUnit.GotoLineAndCenter(E.Line);
            end;
          end;

          if (E.Msg <> 'STOP') then
          begin
            frmLuaEditMessages.memMessages.Lines.Add('[ERROR]: '+E.Msg+' ('+IntToStr(E.Line)+') - '+DateTimeToStr(Now));
            raise;
          end;
        end;
      end;
    end;
  end;
end;

// Return the value of a given local variable
function TfrmMain.GetValue(Name: string): string;
begin
  Result := '[ERROR] Undeclared Identifier';
       
  if lstLocals.Values[Name] <> ''  then
    Result := lstLocals.Values[Name]
  else if lstGlobals.Values[Name] <> '' then
    Result := lstGlobals.Values[Name];
end;

// Find a unit among all opened unit (wich are placed in tabs...)
function TfrmMain.FindUnitInTabs(sFileName: String): TLuaUnit;
var
  x: Integer;
begin
  Result := nil;

  for x := 0 to jvUnitBar.Tabs.Count - 1 do
  begin
    if Assigned(jvUnitBar.Tabs[x].Data) then
    begin
      if TLuaUnit(jvUnitBar.Tabs[x].Data).sUnitPath = sFileName then
      begin
        Result := TLuaUnit(jvUnitBar.Tabs[x].Data);
        Exit;
      end;
    end;
  end;
end;

// check the syntax of the current unit
procedure TfrmMain.ppmUnitsPopup(Sender: TObject);
begin
  Save2.Enabled := (jvUnitBar.Tabs.Count <> 0);
  SaveAs2.Enabled := (jvUnitBar.Tabs.Count <> 0);
  Close2.Enabled := (jvUnitBar.Tabs.Count <> 0);
end;

procedure TfrmMain.actFunctionHeaderExecute(Sender: TObject);
var
  sLine: String;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      sLine := TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.Lines[TLuaUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretY - 1];
      FunctionHeaderBuilder(Application.Handle, PChar(sLine));
    end;
  end;
end;

procedure TfrmMain.jvAppDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
var
  x: Integer;
  pLuaUnit: TLuaUnit;
  pNewPrj: TLuaProject;
  FileName: String;
begin
  for x := 0 to Value.Count - 1 do
  begin
    // Get current file name
    FileName := Value.Strings[x];

    // Make the file exists
    if FileExists(FileName) then
    begin
      if ExtractFileExt(FileName) = '.lua' then
      begin
        // Add new single unit to the tree
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
        // Add new project to the tree
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

end.
