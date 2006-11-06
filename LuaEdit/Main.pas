////////////////////////////////////////////////////////////////
// IMPORTANT NOTICE:
//  Do not include ShareMem unit in the project. Faulting to
//  such thing would cause an EInvalidPointer error when
//  LuaEdit will close.
////////////////////////////////////////////////////////////////

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
  JvExControls, FileCtrl, VirtualTrees, Misc, LEMacros
  {$ifdef RTASSERT}  ,RTDebug {$endif}
  {$ifdef madExcept} ,madExcept, madLinkDisAsm {$endif}
  ,JvDragDrop, JvAppEvent, JvExStdCtrls, JvButton, JvCtrls, JvComCtrls,
  JvDockTree, JvAppInst, JvExExtCtrls, JvItemsPanel, JvGradientCaption,
  JvgCaption;
                               
type                  
  TfrmLuaEditMain = class(TForm)
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
    actFind: TAction;
    actFindAgain: TAction;
    actFindReplace: TAction;
    actGoToLine: TAction;
    actRunScript: TAction;
    actStepOver: TAction;
    actStepInto: TAction;
    actToggleBreakpoint: TAction;
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
    jvModernUnitBarPainter: TJvModernTabBarPainter;
    actAddWatch: TAction;
    N22: TMenuItem;
    Save2: TMenuItem;
    SaveAs2: TMenuItem;
    jvchnNotifier: TJvChangeNotify;
    tlbFind: TToolBar;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
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
    jvAppDrop: TJvDragDrop;
    actUpperCase: TAction;
    actLowerCase: TAction;
    UpperCaseSelection1: TMenuItem;
    LowerCaseSelection1: TMenuItem;
    pnlMain: TPanel;
    actShowInternalBrowser: TAction;
    InternalBrowser1: TMenuItem;
    AddWatch1: TMenuItem;
    AddWatch2: TMenuItem;
    jvUnitBar: TJvTabBar;
    actFindInFiles: TAction;
    FindinFiles1: TMenuItem;
    actShowFindWindow1: TAction;
    actShowFindWindow2: TAction;
    FindWindow11: TMenuItem;
    FindWindow21: TMenuItem;
    actEnableDisableBreakpoint: TAction;
    DisableEnableBreakpoint1: TMenuItem;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    tlbEdit: TToolBar;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton44: TToolButton;
    ToolButton45: TToolButton;
    ToolButton46: TToolButton;
    ToolButton47: TToolButton;
    ToolButton48: TToolButton;
    ToolButton49: TToolButton;
    Find1: TMenuItem;
    Find2: TMenuItem;
    actRemoteSession: TAction;
    N25: TMenuItem;
    InitiateRemoteSession1: TMenuItem;
    N26: TMenuItem;
    LuaEditHomePage1: TMenuItem;
    actShowProfiler: TAction;
    Profiler1: TMenuItem;
    ComponentsContributors1: TMenuItem;
    actCompileScipt: TAction;
    Compilescript1: TMenuItem;
    sdlgCompileOut: TSaveDialog;
    ToolButton24: TToolButton;
    CreateGUID1: TMenuItem;
    actMacroManager: TAction;
    RegistryEditor1: TMenuItem;
    mnuMacros: TMenuItem;
    MacroManager1: TMenuItem;
    actNewMacro: TAction;
    Macro1: TMenuItem;
    ToolButton25: TToolButton;
    actNewTextFile: TAction;
    ToolButton38: TToolButton;
    extFile1: TMenuItem;
    actShowGUIInspector: TAction;
    ShowGUIInspector1: TMenuItem;
    actNewGUIForm: TAction;
    GUIForm1: TMenuItem;
    ToolButton39: TToolButton;
    actShowGUIControls: TAction;
    GUIControls1: TMenuItem;
    actBringGUIFormToFront: TAction;
    N27: TMenuItem;
    BringGUIFormtoFront1: TMenuItem;
    PathConverter1: TMenuItem;
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
    procedure actFindExecute(Sender: TObject);
    procedure actFindAgainExecute(Sender: TObject);
    procedure actFindReplaceExecute(Sender: TObject);
    procedure actGoToLineExecute(Sender: TObject);
    procedure AboutLuaEdit1Click(Sender: TObject);
    procedure actRunScriptExecute(Sender: TObject);
    procedure LuaHelp1Click(Sender: TObject);
    procedure actToggleBreakpointExecute(Sender: TObject);
    procedure stbMainDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actStepOverExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
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
    procedure actUpperCaseExecute(Sender: TObject);
    procedure actLowerCaseExecute(Sender: TObject);
    procedure actShowInternalBrowserExecute(Sender: TObject);
    procedure jvUnitBarTabSelecting(Sender: TObject; Item: TJvTabBarItem; var AllowSelect: Boolean);
    procedure jvUnitBarTabClosed(Sender: TObject; Item: TJvTabBarItem);
    procedure actPrjSettingsExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actStepIntoExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actFindInFilesExecute(Sender: TObject);
    procedure actShowFindWindow1Execute(Sender: TObject);
    procedure actShowFindWindow2Execute(Sender: TObject);
    procedure jvUnitBarChange(Sender: TObject);
    procedure actEnableDisableBreakpointExecute(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure ppmToolBarPopup(Sender: TObject);
    procedure actRemoteSessionExecute(Sender: TObject);
    procedure LuaEditHomePage1Click(Sender: TObject);
    procedure actShowProfilerExecute(Sender: TObject);
    procedure ComponentsContributors1Click(Sender: TObject);
    procedure actCompileSciptExecute(Sender: TObject);
    procedure CreateGUID1Click(Sender: TObject);
    procedure RegistryEditor1Click(Sender: TObject);
    procedure actMacroManagerExecute(Sender: TObject);
    procedure actNewMacroExecute(Sender: TObject);
    procedure actNewTextFileExecute(Sender: TObject);
    procedure actShowGUIInspectorExecute(Sender: TObject);
    procedure actNewGUIFormExecute(Sender: TObject);
    procedure actShowGUIControlsExecute(Sender: TObject);
    procedure actBringGUIFormToFrontExecute(Sender: TObject);
    procedure PathConverter1Click(Sender: TObject);
    //procedure actFunctionHeaderExecute(Sender: TObject);
  private
    { Private declarations }
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public declarations }
    // DEBUG (Lua) variables
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
    MacroLuaState: Plua_State;
    
    // Search variables
    sSearchInFilesString: String;
    sSearchInFilesDir: String;
    sSearchString: String;
    sReplaceString: String;
    SearchedText: TStringList;
    SearchedInFilesText: TStringList;
    ReplacedText: TStringList;
    srSearchInFilesWhere: Integer;
    srSearchInFilesOutput: Integer;
    srSearchDriection: Integer;
    srSearchScope: Integer;
    srSearchOrigin: Integer;
    srReplaceAll: Boolean;
    srPromptForReplace: Boolean;
    srSearchSensitive: Boolean;
    srSearchRegularExpression: Boolean;
    srSearchWholeWords: Boolean;
    srSearchInFilesSensitive: Boolean;
    srSearchInFilesRegularExpression: Boolean;
    srSearchInFilesWholeWords: Boolean;
    srSearchInFilesSubDir: Boolean;

    function ClosingUnit(): Boolean;
    procedure AddFileInTab(pFile: TLuaEditBasicTextFile);
    procedure AddToNotifier(sPath: String);
    function AddFileInProject(sFilePath: String; IsNew: Boolean; pPrj: TLuaEditProject): TLuaEditFile;
    function GetNewProjectName(sFileSuffix: String): String;
    function GetNewFileName(sFileSuffix: String): String;
    procedure CheckButtons;
    procedure BuildReopenMenu;
    function IsReopenInList(sString: String): Boolean;
    procedure MonitorFileToRecent(sString: String);
    procedure BuildMacroList();
    procedure mnuXReopenClick(Sender: TObject);
    procedure mnuXMacroClick(Sender: TObject);
    procedure btnXFilesClick(Sender: TObject);
    procedure btnXClipboardClick(Sender: TObject);
    function IsProjectOpened(sProjectPath: String): Boolean;
    procedure SynEditReplaceText(Sender: TObject; const ASearch, AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure synEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure synEditGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure synEditMouseCursor(Sender: TObject; const aLineCharPos: TBufferCoord; var aCursor: TCursor);
    procedure synEditChange(Sender: TObject);
    procedure synEditClick(Sender: TObject);
    procedure synEditDblClick(Sender: TObject);
    procedure synEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure synEditScroll(Sender: TObject; ScrollBar: TScrollBarKind);
    procedure synCompletionExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: String; var x, y: Integer; var CanExecute: Boolean);
    function GetBaseCompletionProposal: TSynCompletionProposal;
    function GetBaseParamsProposal: TSynCompletionProposal;
    procedure LoadEditorSettingsFromIni;
    procedure LoadEditorSettingsFromReg;
    procedure GetColorSet(sColorSet: String);
    procedure ApplyValuesToEditor(synTemp: TSynEdit; lstColorSheme: TList);
    function ExecuteInitializer(sInitializer: String; L: PLua_State): Integer;
    procedure RefreshOpenedUnits;
    procedure synParamsExecute(Kind: SynCompletionType; Sender: TObject; var AString: String; var x, y: Integer; var CanExecute: Boolean);
    procedure FillLookUpList;
    function FileIsInTree(sFileName: String): PVirtualNode;
    function FindUnitInTabs(pLuaEditBasicTextFile: TLuaEditBasicTextFile): TLuaEditBasicTextFile;
    function FindUnitInTabsStr(sUnitName: String): TLuaEditBasicTextFile;
    procedure PrintLuaStack(L: Plua_State);
    procedure PrintStack;
    procedure PrintLocal(L: Plua_State; Level: Integer = 0);
    procedure PrintGlobal(L: Plua_State; Foce: Boolean = False);
    procedure PrintWatch(L: Plua_State);
    function IsBreak(sFileName: String; Line: Integer): Boolean;
    function IsICI(ICI: Integer): Boolean;
    function IsEdited(pIgnoreUnit: TLuaEditUnit = nil): Boolean;
    function GetValue(Name: string): string;
    function PopUpUnitToScreen(sFileName: String; iLine: Integer = -1; bCleanPrevUnit: Boolean = False; HighlightMode: Integer = -1): TLuaEditBasicTextFile;
    procedure ExecuteCurrent(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer);
    procedure CustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
    procedure RemoteCustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
    procedure CallHookFunc(L: Plua_State; AR: Plua_Debug);
    procedure CleanUpTempDir();

    // Action manager functions
    function DoCompileSciptExecute(): Boolean;    
    function DoCheckSyntaxExecute(): Boolean;
    function DoOpenFileExecute(FilesName: TStringList): Boolean;
    function DoOpenProjectExecute(): Boolean;
    function DoExitExecute(): Boolean;
    function DoSaveAsExecute(): Boolean;
    function DoNewTextFileExecute(): Boolean;
    function DoNewMacroExecute(): Boolean;
    function DoNewGUIFormExecute(): Boolean;
    function DoNewUnitExecute(): Boolean;
    function DoNewProjectExecute(): Boolean;
    function DoSaveProjectAsExecute(): Boolean;
    function DoSaveAllExecute(): Boolean;
    function DoMainMenuFileExecute(): Boolean;
    function DoMainMenuEditExecute(): Boolean;
    function DoMainMenuViewExecute(): Boolean;
    function DoMainMenuProjectExecute(): Boolean;
    function DoMainMenuRunExecute(): Boolean;
    function DoMainMenuToolsExecute(): Boolean;
    function DoMainMenuHelpExecute(): Boolean;
    function DoBringGUIFormToFrontExecute(): Boolean;
    function DoShowProjectTreeExecute(): Boolean;
    function DoShowGUIInspector(): Boolean;
    function DoShowBreakpointsExecute(): Boolean;
    function DoShowMessagesExecute(): Boolean;
    function DoShowWatchListExecute(): Boolean;
    function DoShowProfilerExecute(): Boolean;
    function DoShowGUIControlsExecute(): Boolean;
    function DoShowCallStackExecute(): Boolean;
    function DoShowLuaStackExecute(): Boolean;
    function DoShowLuaOutputExecute(): Boolean;
    function DoShowLuaGlobalsExecute(): Boolean;
    function DoShowLuaLocalsExecute(): Boolean;
    function DoShowRingsExecute(): Boolean;
    function DoShowFunctionListExecute(): Boolean;
    function DoShowInternalBrowserExecute(): Boolean;
    function DoShowFindWindow1Execute(): Boolean;
    function DoShowFindWindow2Execute(): Boolean;
    function DoUndoExecute(): Boolean;
    function DoRedoExecute(): Boolean;
    function DoCutExecute(): Boolean;
    function DoCopyExecute(): Boolean;
    function DoPasteExecute(): Boolean;
    function DoSelectAll(): Boolean;
    function DoFindExecute(): Boolean;
    function DoFindAgainExecute(): Boolean;
    function DoFindReplaceExecute(): Boolean;
    function DoFindInFilesExecute(): Boolean;
    function DoGoToLineExecute(): Boolean;
    function DoGotoLastEditedExecute(): Boolean;
    function DoRunScriptExecute(): Boolean;
    function DoAddWatchExecute(): Boolean;
    function DoToggleBreakpointExecute(): Boolean;
    function DoEnableDisableBreakpoint(): Boolean;
    function DoStepOverExecute(): Boolean;
    function DoStepIntoExecute(): Boolean;
    function DoPauseExecute(): Boolean;
    function DoStopExecute(): Boolean;
    function DoRunToCursorExecute(): Boolean;
    function DoAddToPrjExecute(FilePathToAdd: String = ''): Boolean;
    function DoRemoveFromPrjExecute(pFileToRemove: TLuaEditFile = nil): Boolean;
    function DoEditorSettingsExecute(): Boolean;
    function DoMacroManagerExecute(): Boolean;
    function DoBlockUnindentExecute(): Boolean;
    function DoBlockIndentExecute(): Boolean;
    function DoBlockCommentExecute(): Boolean;
    function DoBlockUncommentExecute(): Boolean;
    function DoUpperCaseExecute(): Boolean;
    function DoLowerCaseExecute(): Boolean;
    function DoPrjSettingsExecute(): Boolean;
    function DoActiveSelPrjExecute(): Boolean;
    function DoPrintExecute(): Boolean;
    function DoCloseExecute(): Boolean;
    function DoSaveExecute(): Boolean;
    function DoRemoteSessionExecute(): Boolean;
  end;

const
  _LuaEditVersion = '3.0.3a';

var
  frmLuaEditMain: TfrmLuaEditMain;
  LuaEditDebugFilesTypeSet: TLuaEditDebugFilesTypeSet;
  LuaEditTextFilesTypeSet: TLuaEditTextFilesTypeSet;
  LuaProjects: TList;
  LuaSingleFiles: TLuaEditProject;
  LuaOpenedFiles: TList;
  ActiveProject: TLuaEditProject;
  DraggedTab: Integer;
  LookupList: TStringList;
  CallStack: TList;

  //Settings variables
  EditorOptions: TSynEditorOptions;
  AnimatedTabsSpeed: Integer;
  TabWidth: Integer;
  UndoLimit: Integer;
  ShowGutter: Boolean;
  ShowLineNumbers: Boolean;
  LeadingZeros: Boolean;
  GutterWidth: Integer;
  GutterColor: String;
  FontName: String;
  FontSize: Integer;
  ColorSet: String;
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
  KeepSIFWindowOpened: Boolean;
  ShowStatusBar: Boolean;
  LibrariesSearchPaths: TStringList;
  HomePage: String;
  SearchPage: String;
  TempFolder: String;
  HistoryMaxAge: Integer;
  MaxTablesSize: Integer;
  MaxSubTablesLevel: Integer;
  CheckCyclicReferencing: Boolean;
  AutoLoadLibBasic: Boolean;
  AutoLoadLibPackage: Boolean;
  AutoLoadLibTable: Boolean;
  AutoLoadLibString: Boolean;
  AutoLoadLibMath: Boolean;
  AutoLoadLibOSIO: Boolean;
  AutoLoadLibDebug: Boolean;
  ShowStackTraceOnError: Boolean;

  //Debugger variables
  LDebug: Plua_State;
  FirstClickPos: TBufferCoord;
  lstLocals: TStringList;
  lstGlobals: TStringList;
  lstStack: TStringList;
  lstLuaStack: TStringList;
  IsCompiledComplete: Boolean;
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
  WSA: WSAData;
  pSock: TSocket;
  pRSock: TSocket;

// Misc functions
procedure CallRemoteHookFunc(pSock: TSocket);
procedure DoLuaStdoutEx(F, S: PChar; L, N: Integer);
function LocalOutput(L: PLua_State): Integer; cdecl;
procedure HookCaller(L: Plua_State; AR: Plua_Debug); cdecl;

function ParamStrEx(Index: Integer; CommandLine: PChar; ExeName: PChar): PChar; cdecl; external 'LuaEditSys.dll';
function ParamCountEx(CommandLine: PChar): Integer; cdecl; external 'LuaEditSys.dll';
//function FunctionHeaderBuilder(OwnerAppHandle: HWND; sLine: PChar): PChar; cdecl; external 'HdrBld.dll';

implementation

uses
  LuaSyntax, Search, Replace, ReplaceQuerry, GotoLine, About,
  ProjectTree, Stack, Watch, Grids, AddToPrj, EditorSettings,
  PrjSettings, RemFromPrj, ErrorLookup, LuaStack, PrintSetup,
  Math, Contributors, LuaOutput, Breakpoints, LuaGlobals,
  LuaLocals, LuaEditMessages, ExSaveExit, AsciiTable, ReadOnlyMsgBox,
  Rings, JvOutlookBar, SynEditTextBuffer, FunctionList,
  JvDockSupportControl, InternalBrowser, FindInFiles, SIFReport,
  FindWindow1, FindWindow2, UploadFiles, Profiler, ComponentList, GUID,
  MacroManager, GUIInspector, GUIControls, GUIFormType, ConvertPath;

{$R *.dfm}

///////////////////////////////////////////////////////////////////
// TfrmLuaEditMain class
///////////////////////////////////////////////////////////////////
procedure TfrmLuaEditMain.FormCreate(Sender: TObject);
var
  AFont: TFont;
  pReg: TRegistry;
begin
  // Initialize important data
  LuaEditDebugFilesTypeSet := [otLuaEditUnit, otLuaEditMacro];
  LuaEditTextFilesTypeSet := [otLuaEditUnit, otLuaEditMacro, otTextFile];

  // Sets Printing basic options...
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

  // Reads last dialog's settings
  pReg := TRegistry.Create;
  if pReg.OpenKey('\Software\LuaEdit', False) then
  begin
    if pReg.ValueExists('WasMaxed') then
    begin
      if not pReg.ReadBool('WasMaxed') then
      begin
        if pReg.ValueExists('Width') then
          frmLuaEditMain.Width := pReg.ReadInteger('Width');
          
        if pReg.ValueExists('Height') then
          frmLuaEditMain.Height := pReg.ReadInteger('Height');
      end
      else
      begin
        frmLuaEditMain.WindowState := wsMaximized;
      end;
    end;
  end;
  pReg.Free;

  LookupList := TStringList.Create;
  EditorColors := TList.Create;
  CallStack := TList.Create;
  lstLocals := TStringList.Create;
  lstLocals.CaseSensitive := True;
  lstGlobals := TStringList.Create;
  lstGlobals.CaseSensitive := True;
  lstStack := TStringList.Create;
  lstLuaStack := TStringList.Create;
  LuaProjects := TList.Create;
  LuaOpenedFiles := TList.Create;
  SearchedText := TStringList.Create;
  SearchedInFilesText := TStringList.Create;
  ReplacedText := TStringList.Create;
  LibrariesSearchPaths := TStringList.Create;
  LibrariesSearchPaths.QuoteChar := '"';
  LibrariesSearchPaths.Delimiter := ',';
  LuaSingleFiles := TLuaEditProject.Create(GetLuaEditInstallPath() + '\Templates\Template.lpr');
  LuaSingleFiles.Name := '[@@SingleUnits@@]';
  LuaProjects.Add(LuaSingleFiles);
  Running := False;
  IsCompiledComplete := True;
  CurrentICI := 1;

  // Create dockable forms...
  frmProjectTree := TfrmProjectTree.Create(Self);
  frmLuaOutput := TfrmLuaOutput.Create(Self);
  frmLuaStack := TfrmLuaStack.Create(Self);
  frmWatch := TfrmWatch.Create(Self);
  frmStack := TfrmStack.Create(Self);
  frmLuaLocals := TfrmLuaLocals.Create(Self);
  frmLuaGlobals := TfrmLuaGlobals.Create(Self);
  frmLuaEditMessages := TfrmLuaEditMessages.Create(Self);
  frmBreakpoints := TfrmBreakpoints.Create(Self);
  frmRings := TfrmRings.Create(Self);
  frmFunctionList := TfrmFunctionList.Create(Self);
  frmInternalBrowser := TfrmInternalBrowser.Create(Self);
  frmFindWindow1 := TfrmFindWindow1.Create(Self);
  frmFindWindow2 := TfrmFindWindow2.Create(Self);
  frmProfiler := TfrmProfiler.Create(Self);
  frmGUIInspector := TfrmGUIInspector.Create(Self);
  frmGUIControls := TfrmGUIControls.Create(Self);

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
  imlDock.GetIcon(12, frmInternalBrowser.Icon);
  imlDock.GetIcon(13, frmFindWindow1.Icon);
  imlDock.GetIcon(13, frmFindWindow2.Icon);
  imlDock.GetIcon(14, frmProfiler.Icon);
  imlDock.GetIcon(15, frmGUIInspector.Icon);
  imlDock.GetIcon(16, frmGUIControls.Icon);

  // Paint some non overriden components
  xmpMenuPainter.InitComponent(frmProjectTree.ppmProjectTree);
  xmpMenuPainter.InitComponent(frmBreakpoints.tlbBreakpoints);
  xmpMenuPainter.InitComponent(frmFunctionList.tblFunctionList);
  xmpMenuPainter.InitComponent(frmInternalBrowser.tlbInternalBrowser);
  xmpMenuPainter.InitComponent(frmWatch.tblWatch);
  xmpMenuPainter.InitComponent(frmWatch.ppmWatch);

  // Initiate Macro Lua State
  MacroLuaState := lua_open();
  LERegisterToLua(MacroLuaState);
  LuaRegister(MacroLuaState, 'io.write', lua_io_writeex);
  LuaRegister(MacroLuaState, 'print', lua_printex);
  OnLuaStdoutEx := DoLuaStdoutEx;


  // Build the reopen menus and ring
  BuildReopenMenu();
  // Build macro menus
  BuildMacroList();
end;

procedure TfrmLuaEditMain.FormDestroy(Sender: TObject);
var
  pReg: TRegistry;
begin
{$ifdef RTASSERT} RTAssert(0, true, ' TfrmLuaEditMain.FormDestroy', '', 0); {$endif}
  CleanUpTempDir();

  // Write last windows settings
  pReg := TRegistry.Create;
  pReg.OpenKey('\Software\LuaEdit', True);
  pReg.WriteBool('WasMaxed', (Self.WindowState = wsMaximized));
  pReg.WriteInteger('Width', Self.Width);
  pReg.WriteInteger('Height', Self.Height);
  pReg.Free;

  // Free previously created objects
  LuaProjects.Free;
  LuaSingleFiles.Free;
  LuaOpenedFiles.Free;
  LibrariesSearchPaths.Free;
  ReplacedText.Free;
  SearchedInFilesText.Free;
  SearchedText.Free;
  lstStack.Free;
  lstLuaStack.Free;
  lstLocals.Free;
  lstGlobals.Free;
  EditorColors.Free;
  LookupList.Free;
  CallStack.Free;

  // Free Macro Lua State
  lua_close(MacroLuaState);

  // Free the page controller
  jvUnitBar.Free;

{$ifdef RTASSERT} RTAssert(0, true, ' TfrmLuaEditMain.FormDestroy Done', '', 0); {$endif}
end;

// Special window message handling for single application instance
procedure TfrmLuaEditMain.WndProc(var Msg: TMessage);
var
  x, y: Integer;
  CommandLine, FileName: String;
  pFiles: TStringList;
  copyDataStruct: PCopyDataStruct;
  copyDataType: TCopyDataType;
begin
  if Msg.Msg = WM_COPYDATA then
  begin
    copyDataStruct := TWMCopyData(Msg).CopyDataStruct;
    copyDataType := TCopyDataType(copyDataStruct.dwData);

    if copyDataType = cdtAnsiString then
    begin
      CommandLine := PChar(copyDataStruct.lpData);

      if ParamCountEx(PChar(CommandLine)) > 0 then
      begin
        pFiles := TStringList.Create;

        for x := 1 to ParamCountEx(PChar(CommandLine)) do
        begin
          FileName := ParamStrEx(x, PChar(CommandLine), PChar(Application.ExeName));

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
    end;
  end;

  inherited WndProc(Msg);
end;

procedure TfrmLuaEditMain.synEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  synEditClick(Sender);
end;

function TfrmLuaEditMain.DoOpenFileExecute(FilesName: TStringList): Boolean;
var
  pReg: TRegistry;
  pNewPrj: TLuaEditProject;
  pFile: TLuaEditBasicTextFile;

  procedure OpenFiles(Files: TStringList);
  var
    z: integer;
  begin
    for z := 0 to Files.Count - 1 do
    begin
      if FileExistsAbs(Files.Strings[z]) then
      begin
        if ExtractFileExt(Files.Strings[z]) = '.lpr' then
        begin
          if not IsProjectOpened(Files.Strings[z]) then
          begin
            Result := True;
            pNewPrj := TLuaEditProject.Create(Files.Strings[z]);
            pNewPrj.GetProjectFromDisk(Files.Strings[z]);
            // Add opened file to recent opens
            pReg.OpenKey('\Software\LuaEdit', True);
            pReg.WriteString('RecentPath', ExtractFilePath(Files.Strings[z]));
          end
          else
          begin
            Application.MessageBox(PChar('The file "'+Files.Strings[z]+'" is already opened in LuaEdit.'), 'LuaEdit', MB_OK+MB_ICONERROR);
            Exit;
          end;
        end
        else
        begin
          if not Assigned(FileIsInTree(Files.Strings[z])) then
          begin
            Result := True;
            pFile := TLuaEditBasicTextFile(AddFileInProject(Files.Strings[z], False, LuaSingleFiles));
            pFile.IsLoaded := True;
            AddFileInTab(pFile);
            MonitorFileToRecent(Files.Strings[z]);

            // Add opened file to recent opens
            pReg.OpenKey('\Software\LuaEdit', True);
            pReg.WriteString('RecentPath', ExtractFilePath(Files.Strings[z]));
          end
          else
          begin
            PopUpUnitToScreen(Files.Strings[z]);
            Exit;
          end;
        end;
      end;
    end;
  end;
  
begin
  Result := False;
  pReg := TRegistry.Create;

  if pReg.OpenKey('\Software\LuaEdit', False) then
    odlgOpenUnit.InitialDir := pReg.ReadString('RecentPath');

  if FilesName.Count > 0 then
    OpenFiles(FilesName)
  else
    if odlgOpenUnit.Execute then
      OpenFiles(TStringList(odlgOpenUnit.Files));

  // Rebuild the project tree and initialize stuff
  frmProjectTree.BuildProjectTree;
  BuildReopenMenu;
  CheckButtons();

  pReg.Free;
end;

procedure TfrmLuaEditMain.actOpenFileExecute(Sender: TObject);
var
  pFiles: TStringList;
begin
  pFiles := TStringList.Create;
  DoOpenFileExecute(pFiles);
  pFiles.Free;
end;

procedure TfrmLuaEditMain.AddFileInTab(pFile: TLuaEditBasicTextFile);
var
  pJvTab: TJvTabBarItem;
begin
  Screen.Cursor := crHourGlass;

  // Create the tab and associate the synedit control to its data property
  pJvTab := jvUnitBar.AddTab(pFile.Name);
  pJvTab.Data := pFile;
  pJvTab.Visible := False;

  pFile.AssociatedTab := pJvTab;
  pFile.SynUnit.Visible := True;
  LuaOpenedFiles.Add(pFile);

  // Visually initialize the synedit control and other stuff
  pJvTab.Visible := True;
  synEditClick(pFile.SynUnit);
  jvUnitBar.SelectedTab := pJvTab;
  jvUnitBarChange(jvUnitBar);
  ApplyValuesToEditor(pFile.SynUnit, EditorColors);
  
  if pFile.FileType in LuaEditDebugFilesTypeSet then
  begin
    TLuaEditDebugFile(pFile).GetBreakpoints();
    frmBreakpoints.RefreshBreakpointList();
  end;
  
  Screen.Cursor := crDefault;
end;

function TfrmLuaEditMain.GetNewProjectName(sFileSuffix: String): String;
var
  x, IncFileNumber: Integer;
  FoundMatch: Boolean;
begin
  Result := '';
  IncFileNumber := 1;

  for x := 0 to LuaProjects.Count - 1 do
  begin
    if TLuaEditFile(LuaProjects.Items[x]).IsNew then
      Inc(IncFileNumber);
  end;

  FoundMatch := True;

  while FoundMatch do
  begin
    FoundMatch := False;
    for x := 0 to LuaProjects.Count - 1 do
    begin
      if sFileSuffix+IntToStr(IncFileNumber) = TLuaEditFile(LuaProjects.Items[x]).Name then
      begin
        Inc(IncFileNumber);
        FoundMatch := True;
      end;
    end;
  end;

  Result := sFileSuffix+IntToStr(IncFileNumber);
end;

function TfrmLuaEditMain.GetNewFileName(sFileSuffix: String): String;
var
  x, y, IncFileNumber: Integer;
  FoundMatch: Boolean;
begin
  Result := '';
  IncFileNumber := 1;

  for x := 0 to LuaProjects.Count - 1 do
  begin
    for y := 0 to TLuaEditProject(LuaProjects.Items[x]).lstUnits.Count - 1 do
    begin
      if TLuaEditFile(TLuaEditProject(LuaProjects.Items[x]).lstUnits[y]).IsNew then
        Inc(IncFileNumber);
    end;
  end;

  FoundMatch := True;

  while FoundMatch do
  begin
    FoundMatch := False;
    for x := 0 to LuaProjects.Count - 1 do
    begin
      for y := 0 to TLuaEditProject(LuaProjects.Items[x]).lstUnits.Count - 1 do
      begin
        if sFileSuffix+IntToStr(IncFileNumber) = TLuaEditFile(TLuaEditProject(LuaProjects.Items[x]).lstUnits[y]).Name then
        begin
          Inc(IncFileNumber);
          FoundMatch := True;
        end;
      end;
    end;
  end;

  Result := sFileSuffix+IntToStr(IncFileNumber);
end;

function TfrmLuaEditMain.AddFileInProject(sFilePath: String; IsNew: Boolean; pPrj: TLuaEditProject): TLuaEditFile;
var
  pFile: TLuaEditFile;
begin
  if ExtractFileExt(sFilePath) = '.gui' then
    pFile := TLuaEditGUIForm.Create(sFilePath)
  else if ExtractFileExt(sFilePath) = '.lua' then
    pFile := TLuaEditBasicTextFile(TLuaEditUnit.Create(sFilePath))
  else if ExtractFileExt(sFilePath) = '.lmc' then
    pFile := TLuaEditBasicTextFile(TLuaEditMacro.Create(sFilePath))
  else
    pFile := TLuaEditBasicTextFile.Create(sFilePath);

  pFile.PrjOwner := pPrj;
  pFile.IsNew := IsNew;

  if pPrj.Name = '[@@SingleUnits@@]' then
    pPrj.lstUnits.Insert(pPrj.lstUnits.Count, pFile)
  else
    pPrj.lstUnits.Add(pFile);

  Result := pFile;
end;

// Add root to the changes notifier
procedure TfrmLuaEditMain.AddToNotifier(sPath: String);
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

procedure TfrmLuaEditMain.jvchnNotifierChangeNotify(Sender: TObject; Dir: String; Actions: TJvChangeActions);
var
  srSearchRec: TSearchRec;
  sFileName: String;
  pLuaUnit: TLuaEditUnit;
  pLuaPrj: TLuaEditProject;
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

        if FileExistsAbs(sFileName) then
        begin
          // Go through all opened unit
          for x := 0 to LuaOpenedFiles.Count - 1 do
          begin
            pLuaUnit := TLuaEditUnit(LuaOpenedFiles[x]);

            if sFileName = pLuaUnit.Path then
            begin
              // Compare dates and read only attr each others
              if ((pLuaUnit.LastTimeModified < GetFileLastTimeModified(PChar(sFileName))) or (pLuaUnit.IsReadOnly <> GetFileReadOnlyAttr(PChar(sFileName)))) then
              begin
                if Application.MessageBox(PChar('The file '+sFileName+' has been modified outside of the LuaEdit environnement. Do you want to reaload the file now?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
                begin
                  pLuaUnit.LastTimeModified := GetFileLastTimeModified(PChar(sFileName));
                  pLuaUnit.IsReadOnly := GetFileReadOnlyAttr(PChar(sFileName));
                  pLuaUnit.HasChanged := True;
                  pLuaUnit.SynUnit.Lines.LoadFromFile(sFileName);
                  pLuaUnit.SynUnit.Modified := True;
                  SynEditChange(pLuaUnit.SynUnit);
                  pLuaUnit.SynUnit.Refresh;
                end;
              end;
            end;
          end;

          // Go through all projects
          for x := 0 to LuaProjects.Count - 1 do
          begin
            pLuaPrj := TLuaEditProject(LuaProjects[x]);

            if sFileName = pLuaPrj.Path then
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

procedure TfrmLuaEditMain.synEditClick(Sender: TObject);
var
  synEditTemp: TSynEdit;
  pLuaEditFile: TLuaEditFile;
  pLuaEditDebugFile: TLuaEditDebugFile;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pLuaEditFile := TLuaEditFile(jvUnitBar.SelectedTab.Data);

      if pLuaEditFile.FileType in LuaEditDebugFilesTypeSet then
      begin
        pLuaEditDebugFile := TLuaEditDebugFile(pLuaEditFile);

        if Assigned(pLuaEditDebugFile.LinkedGUIForm) then
          ShowWindow(pLuaEditDebugFile.LinkedGUIForm.GUIDesignerForm.Handle, SW_HIDE);
      end;
    end;
  end;

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

  CheckButtons();
end;

function TfrmLuaEditMain.DoOpenProjectExecute(): Boolean;
var
  pNewPrj: TLuaEditProject;
  x: integer;
  pReg: TRegistry;
begin
  Result := False;
  pReg := TRegistry.Create;

  if pReg.OpenKey('\Software\LuaEdit', False) then
    odlgOpenProject.InitialDir := pReg.ReadString('RecentPath');

  if odlgOpenProject.Execute then
  begin
    for x := 0 to odlgOpenProject.Files.Count - 1 do
    begin
      if not IsProjectOpened(odlgOpenProject.Files.Strings[x]) then
      begin
        Result := True;
        pNewPrj := TLuaEditProject.Create(odlgOpenProject.Files.Strings[x]);
        pNewPrj.GetProjectFromDisk(odlgOpenProject.Files.Strings[x]);

        // Rebuild the project tree
        frmProjectTree.BuildProjectTree;

        // Initialize and free stuff...
        CheckButtons();

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

procedure TfrmLuaEditMain.actOpenProjectExecute(Sender: TObject);
begin
  DoOpenProjectExecute;
end;

function TfrmLuaEditMain.DoExitExecute(): Boolean;
begin
  Result := True;
  Application.MainForm.Close;
end;

procedure TfrmLuaEditMain.actExitExecute(Sender: TObject);
begin
  DoExitExecute;
end;

function TfrmLuaEditMain.DoSaveExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
begin
  Result := False;

  if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
  begin
    pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

    if Assigned(pLuaUnit) then
    begin
      if SaveUnitsInc then
        Result := pLuaUnit.SaveInc(pLuaUnit.Path)
      else
        Result := pLuaUnit.Save(pLuaUnit.Path);
    end;
  end;
end;

procedure TfrmLuaEditMain.actSaveExecute(Sender: TObject);
begin
  DoSaveExecute;
end;

function TfrmLuaEditMain.DoSaveAsExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
begin
  Result := False;

  if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
  begin
    pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

    if Assigned(pLuaUnit) then
    begin
      if SaveUnitsInc then
        Result := pLuaUnit.SaveInc(pLuaUnit.Path, False, True)
      else
        Result := pLuaUnit.Save(pLuaUnit.Path, False, True);
    end;
  end;
end;

procedure TfrmLuaEditMain.actSaveAsExecute(Sender: TObject);
begin
  DoSaveAsExecute;
end;

procedure TfrmLuaEditMain.CheckButtons;
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
  pFile: TLuaEditBasicTextFile;
begin
  actClose.Enabled := not (LuaOpenedFiles.Count = 0);
  actSave.Enabled := not (LuaOpenedFiles.Count = 0);
  actSaveAs.Enabled := not (LuaOpenedFiles.Count = 0);
  actSaveProjectAs.Enabled := ((Assigned(ActiveProject)) and (ActiveProject <> LuaSingleFiles));
  actSaveAll.Enabled := not (LuaOpenedFiles.Count = 0);
  actFind.Enabled := not (LuaOpenedFiles.Count = 0);
  actFindAgain.Enabled := not (LuaOpenedFiles.Count = 0);
  actFindReplace.Enabled := not (LuaOpenedFiles.Count = 0);
  actSelectAll.Enabled := not (LuaOpenedFiles.Count = 0);
  actGoToLine.Enabled := not (LuaOpenedFiles.Count = 0);
  actGotoLastEdited.Enabled := not (LuaOpenedFiles.Count = 0);
  actCut.Enabled := not (LuaOpenedFiles.Count = 0);
  actCopy.Enabled := not (LuaOpenedFiles.Count = 0);
  actPaste.Enabled := not (LuaOpenedFiles.Count = 0);
  actPrint.Enabled := not (LuaOpenedFiles.Count = 0);
  actBlockIndent.Enabled := not (LuaOpenedFiles.Count = 0);
  actBlockUnindent.Enabled := not (LuaOpenedFiles.Count = 0);
  actBlockComment.Enabled := not (LuaOpenedFiles.Count = 0);
  actBlockUncomment.Enabled := not (LuaOpenedFiles.Count = 0);
  actUpperCase.Enabled := not (LuaOpenedFiles.Count = 0);
  actLowerCase.Enabled := not (LuaOpenedFiles.Count = 0);
  //HeaderBuilder1.Enabled := not (LuaOpenedFiles.Count = 0);

  if LuaOpenedFiles.Count = 0 then
  begin
    actUndo.Enabled := False;
    actRedo.Enabled := False;
  end;

  // Initialize some actions' state
  actEnableDisableBreakpoint.Enabled := False;

  if LuaOpenedFiles.Count > 0 then
  begin
    if Assigned(jvUnitBar.SelectedTab) then
    begin
      if Assigned(jvUnitBar.SelectedTab.Data) then
      begin
        pFile := TLuaEditBasicTextFile(jvUnitBar.SelectedTab.Data);

        if pFile.FileType in LuaEditDebugFilesTypeSet then
        begin
          actEnableDisableBreakpoint.Enabled := TLuaEditUnit(pFile).DebugInfos.IsBreakPointLine(pFile.SynUnit.CaretY);
          actRunScript.Enabled := (pFile.SynUnit.Text <> '');
          actRemoteSession.Enabled := (pFile.SynUnit.Text <> '');
          actCompileScipt.Enabled := (pFile.SynUnit.Text <> '');
          actCheckSyntax.Enabled := (pFile.SynUnit.Text <> '');
          actRunToCursor.Enabled := (pFile.SynUnit.Text <> '');
          actToggleBreakpoint.Enabled := True;
          actStepInto.Enabled := True;
          actStepOver.Enabled := True;
        end
        else
        begin
          actEnableDisableBreakpoint.Enabled := False;
          actRunScript.Enabled := False;
          actRemoteSession.Enabled := False;
          actCompileScipt.Enabled := False;
          actCheckSyntax.Enabled := False;
          actRunToCursor.Enabled := False;
          actToggleBreakpoint.Enabled := False;
          actStepInto.Enabled := False;
          actStepOver.Enabled := False;
        end;

        if pFile.synUnit.UndoList.ItemCount = 0 then
          actUndo.Enabled := False
        else
          actUndo.Enabled := True;

        if pFile.synUnit.RedoList.ItemCount = 0 then
          actRedo.Enabled := False
        else
          actRedo.Enabled := True;
      end;
    end
    else
    begin
      actUndo.Enabled := False;
      actRedo.Enabled := False;
    end;
  end
  else
  begin
    actRemoteSession.Enabled := False;
    actRunScript.Enabled := False;
    actCompileScipt.Enabled := False;
    actCheckSyntax.Enabled := False;
    actStepInto.Enabled := False;
    actStepOver.Enabled := False;
    actRunToCursor.Enabled := False;
    actToggleBreakpoint.Enabled := False;
  end;

  // These actions are driven by the Running global variable
  // (they only needs to be enabled when the user is debugging)
  actPause.Enabled := Running;
  actStop.Enabled := Running;

  // Retreive selected node if any
  pNode := frmProjectTree.vstProjectTree.GetFirstSelected;

  if Assigned(pNode) then
  begin
    // Retreive data from the selected node
    pData := frmProjectTree.vstProjectTree.GetNodeData(pNode);

    if pData.pLuaEditFile.FileType = otLuaEditProject then
      actActiveSelPrj.Enabled := True
    else
      actActiveSelPrj.Enabled := False;
  end
  else
    actActiveSelPrj.Enabled := False;

  actNewProject.Enabled := True;
  actNewUnit.Enabled := True;
  actOpenFile.Enabled := True;
  actOpenProject.Enabled := True;
  actClose.Enabled := True;
  New1.Enabled := True;
  Reopen1.Enabled := True;
end;

function TfrmLuaEditMain.DoNewMacroExecute(): Boolean;
var
  pLuaMacro: TLuaEditMacro;
begin
  Result := True;
  pLuaMacro := TLuaEditMacro(AddFileInProject(GetNewFileName('Macro') + '.lmc', True, LuaSingleFiles));
  pLuaMacro.IsLoaded := True;
  AddFileInTab(pLuaMacro);
  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmLuaEditMain.actNewMacroExecute(Sender: TObject);
begin
  DoNewMacroExecute;
end;

function TfrmLuaEditMain.DoNewTextFileExecute(): Boolean;
var
  pLuaTextFile: TLuaEditBasicTextFile;
begin
  Result := True;
  pLuaTextFile := TLuaEditBasicTextFile(AddFileInProject(GetNewFileName('Text') + '.txt', True, LuaSingleFiles));
  pLuaTextFile.IsLoaded := True;
  AddFileInTab(pLuaTextFile);
  frmProjectTree.BuildProjectTree;
  CheckButtons();
end;

procedure TfrmLuaEditMain.actNewTextFileExecute(Sender: TObject);
begin
  DoNewTextFileExecute;
end;

function TfrmLuaEditMain.DoNewGUIFormExecute(): Boolean;
var
  pLuaEditGUIForm: TLuaEditGUIForm;
  sFileName: String;
begin
  Result := True;

  Application.CreateForm(TfrmGUIFormType, frmGUIFormType);
  frmGUIFormType.ShowModal;
  sFileName := GetNewFileName('Form') + '.gui';
  pLuaEditGUIForm := TLuaEditGUIForm(AddFileInProject(sFileName, True, LuaSingleFiles));
  pLuaEditGUIForm.IsLoaded := True;

  // Created associated script according to user's type
  if frmGUIFormType.optLuaUnit.Checked then
    pLuaEditGUIForm.LinkedDebugFile := TLuaEditUnit(AddFileInProject(ChangeFileExt(sFileName, '.lua'), True, LuaSingleFiles))
  else
    pLuaEditGUIForm.LinkedDebugFile := TLuaEditMacro(AddFileInProject(ChangeFileExt(sFileName, '.lmc'), True, LuaSingleFiles));

  // Complete cycling reference
  pLuaEditGUIForm.LinkedDebugFile.LinkedGUIForm := pLuaEditGUIForm;
  pLuaEditGUIForm.LinkedDebugFile.IsNew := True;
  pLuaEditGUIForm.LinkedDebugFile.IsLoaded := True;

  // Routine creation
  AddFileInTab(pLuaEditGUIForm.LinkedDebugFile);
  frmProjectTree.BuildProjectTree;
  CheckButtons;

  // Show the designer form
  frmGUIFormType.Free;
  Application.ProcessMessages;
  pLuaEditGUIForm.GUIDesignerForm.Visible := True;
  ShowWindow(pLuaEditGUIForm.GUIDesignerForm.Handle, SW_SHOWNORMAL);
end;

procedure TfrmLuaEditMain.actNewGUIFormExecute(Sender: TObject);
begin
  DoNewGUIFormExecute();
end;

function TfrmLuaEditMain.DoNewUnitExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
begin
  Result := True;
  pLuaUnit := TLuaEditUnit(AddFileInProject(GetNewFileName('Unit') + '.lua', True, LuaSingleFiles));
  pLuaUnit.IsLoaded := True;
  AddFileInTab(pLuaUnit);
  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmLuaEditMain.actNewUnitExecute(Sender: TObject);
begin
  DoNewUnitExecute;
end;

function TfrmLuaEditMain.DoNewProjectExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
  pNewLuaPrj: TLuaEditProject;
begin
  Result := False;
  pNewLuaPrj := TLuaEditProject.Create('');
  pNewLuaPrj.Name := GetNewProjectName('Project');
  pNewLuaPrj.Path := GetLuaEditInstallPath() + '\Templates\Template.lpr';
  pNewLuaPrj.IsNew := True;
  pNewLuaPrj.IsLoaded := True;
  LuaProjects.Add(pNewLuaPrj);
  ActiveProject := pNewLuaPrj;

  Result := True;
  pLuaUnit := TLuaEditUnit(AddFileInProject(GetNewFileName('Unit') + '.lua', True, pNewLuaPrj));
  pLuaUnit.IsLoaded := True;
  AddFileInTab(pLuaUnit);
  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmLuaEditMain.actNewProjectExecute(Sender: TObject);
begin
  DoNewProjectExecute;
end;

function TfrmLuaEditMain.DoSaveProjectAsExecute(): Boolean;
begin
  Result := False;

  if ActiveProject.Name <> '[@@SingleUnits@@]' then
  begin
    if SaveProjectsInc then
      Result := ActiveProject.SaveInc(sdlgSaveAsPrj.FileName, False, True)
    else
      Result := ActiveProject.Save(sdlgSaveAsPrj.FileName, False, True);

    RefreshOpenedUnits;
    frmProjectTree.BuildProjectTree;
  end;
end;

procedure TfrmLuaEditMain.actSaveProjectAsExecute(Sender: TObject);
begin
  DoSaveProjectAsExecute;
end;

function TfrmLuaEditMain.DoSaveAllExecute(): Boolean;
var
  x, y: integer;
  pLuaPrj: TLuaEditProject;
  pLuaUnit: TLuaEditUnit;
begin
  Result := False;
  
  for x := 0 to LuaProjects.Count - 1 do
  begin
    pLuaPrj := TLuaEditProject(LuaProjects.Items[x]);

    for y := 0 to pLuaPrj.lstUnits.Count - 1 do
    begin
      pLuaUnit := TLuaEditUnit(pLuaPrj.lstUnits.Items[y]);

      if SaveUnitsInc then
        Result := pLuaUnit.SaveInc(pLuaUnit.Path)
      else
        Result := pLuaUnit.Save(pLuaUnit.Path);

      if not Result then
        Exit;
    end;
    
    if pLuaPrj.Name <> '[@@SingleUnits@@]' then
    begin
      if SaveProjectsInc then
        Result := pLuaPrj.SaveInc(pLuaPrj.Path)
      else
        Result := pLuaPrj.Save(pLuaPrj.Path);

      if not Result then
        Exit;
    end;
  end;

  frmProjectTree.BuildProjectTree;
end;

procedure TfrmLuaEditMain.actSaveAllExecute(Sender: TObject);
begin
  DoSaveAllExecute;
end;

function TfrmLuaEditMain.DoCloseExecute(): Boolean;
var
  pTab: TJvTabBarItem;
begin
  Screen.Cursor := crHourGlass;
  pTab := jvUnitBar.SelectedTab.GetPreviousVisible;
  Result := ClosingUnit;

  // Close the tab, free data...
  if Result then
  begin
    TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).AssociatedTab := nil;
    jvUnitBar.SelectedTab.Free;
    if Assigned(pTab) then
      jvUnitBar.SelectedTab := pTab;
  end;

  Screen.Cursor := crDefault;
end;

procedure TfrmLuaEditMain.actCloseExecute(Sender: TObject);
begin
  DoCloseExecute;
end;

function TfrmLuaEditMain.ClosingUnit(): Boolean;
var
  Answer, x: Integer;
begin
  // Initialize result to true
  Result := True;

  // Prompt user for closing unit or not
  if ((TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).HasChanged) or (TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).IsNew)) then
  begin
    Answer := Application.MessageBox(PChar('Do you want to save "'+TLuaEditUnit(jvUnitBar.SelectedTab.Data).Path+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
    if Answer = IDYES then
      Result := DoSaveExecute
    else if Answer = IDCANCEL then
    begin
      Result := False;
      Exit;
    end;
  end;

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

  // Remove file from global opened file list
  LuaOpenedFiles.Remove(jvUnitBar.SelectedTab.Data);
  TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).SynUnit.Visible := False;
  TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).AssociatedTab := nil;

  // Reinitialize stuff...
  CheckButtons;
  frmProjectTree.BuildProjectTree;
  frmBreakpoints.RefreshBreakpointList;
end;

procedure TfrmLuaEditMain.BuildMacroList();
var
  x: Integer;
  pReg: TRegistry;
  lstKeyList: TStringList;
  pNewMenu: TMenuItem;
begin
  pReg := TRegistry.Create();

  while mnuMacros.Count > 1 do
    mnuMacros.Delete(mnuMacros.Count - 1);

  // Open registry key to read all macros' datas
  if pReg.OpenKey('\Software\LuaEdit\Macros', False) then
  begin
    lstKeyList := TStringList.Create();
    pReg.GetKeyNames(lstKeyList);

    // Add separator menu
    pNewMenu := TMenuItem.Create(mnuMacros);
    pNewMenu.Caption := '-';
    mnuMacros.Add(pNewMenu);

    for x := 0 to lstKeyList.Count - 1 do
    begin
      // Open current macro registry key to read macro's values
      if pReg.OpenKey('\Software\LuaEdit\Macros\' + lstKeyList.Strings[x], False) then
      begin
        pNewMenu := TMenuItem.Create(mnuMacros);
        pNewMenu.Caption := pReg.ReadString('Caption');
        pNewMenu.Shortcut := TextToShortcut(pReg.ReadString('Shortcut'));
        pNewMenu.Hint := lstKeyList.Strings[x]; // Use hint property to store name...
        pNewMenu.OnClick := mnuXMacroClick;
        mnuMacros.Add(pNewMenu);
      end;
    end;

    lstKeyList.Free;
  end;

  // Repaint some non overriden component on runtime
  xmpMenuPainter.ActivateMenuItem(mnuMacros, True);
  pReg.Free;
end;

// Build 'reopen' submenu of the main 'file' menu 
procedure TfrmLuaEditMain.BuildReopenMenu;
var
  pReg: TRegistry;
  lstValues: TStringList;
  x: integer;

  // This method add a submenu to the given reopen menu
  procedure AddMenu(pOnClick: TNotifyEvent; AOwner: TComponent; sCaption: String; bEnabled: Boolean = True);
  var
    pNewMenu: TMenuItem;
    bFound: Boolean;
    x: Integer;
  begin
    bFound := False;

    if AOwner.ClassType = TMenuItem then
    begin
      for x := 0 to TMenuItem(AOwner).Count - 1 do
      begin
        if TMenuItem(AOwner).Items[x].Caption = sCaption then
          bFound := True;
      end;
    end
    else if AOwner.ClassType = TPopupMenu then
    begin
      for x := 0 to TPopupMenu(AOwner).Items.Count - 1 do
      begin
        if TPopupMenu(AOwner).Items[x].Caption = sCaption then
          bFound := True;
      end;
    end;

    if not bFound then
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
  end;

  // This method add a button to the ring engine
  procedure AddOBButton(pOnClick: TNotifyEvent; iPageIndex: Integer; sCaption: String; bEnabled: Boolean = True);
  var
    jvOBBtn: TJvOutlookBarButton;
    bFound: Boolean;
    x: Integer;
  begin
    bFound := False;

    for x := 0 to frmRings.jvRings.Pages[iPageIndex].Buttons.Count - 1 do
    begin
      if frmRings.jvRings.Pages[iPageIndex].Buttons[x].Caption = sCaption then
        bFound := True;
    end;

    if not bFound then
    begin
      jvOBBtn := frmRings.jvRings.Pages[iPageIndex].Buttons.Add();
      jvOBBtn.Caption := sCaption;
      jvOBBtn.Enabled := bEnabled;
      jvOBBtn.OnClick := pOnClick;
    end;
  end;
begin
  //Reopen1.Clear;
  //mnuReopen.Items.Clear;
  //frmRings.jvRings.Pages[JVPAGE_RING_FILES].Buttons.Clear;
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

      // Add all other types of files after seperators and projects
      for x := 0 to lstValues.Count - 1 do
      begin
        if ExtractFileExt(lstValues.Strings[x]) <> '.lpr' then
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

function TfrmLuaEditMain.IsReopenInList(sString: String): Boolean;
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

procedure TfrmLuaEditMain.MonitorFileToRecent(sString: String);
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
  end;

  pReg.Free;
end;

function TfrmLuaEditMain.DoMainMenuFileExecute(): Boolean;
begin
  Result := True;
  CloseUnit1.Enabled := (jvUnitBar.Tabs.Count  > 0);
end;

procedure TfrmLuaEditMain.actMainMenuFileExecute(Sender: TObject);
begin
  DoMainMenuFileExecute;
end;

function TfrmLuaEditMain.DoMainMenuEditExecute(): Boolean;
begin
  Result := False;
  // Do nothing for now...
end;

procedure TfrmLuaEditMain.actMainMenuEditExecute(Sender: TObject);
begin
  DoMainMenuEditExecute;
end;

function TfrmLuaEditMain.DoMainMenuViewExecute(): Boolean;
begin
  Result := True;
  File2.Checked := tlbBaseFile.Visible;
  Edit2.Checked := tlbEdit.Visible;
  Run1.Checked := tlbRun.Visible;
  File3.Checked := tlbBaseFile.Visible;
  Edit3.Checked := tlbEdit.Visible;
  Find1.Checked := tlbFind.Visible;
  Find2.Checked := tlbFind.Visible;
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
  actShowInternalBrowser.Checked := frmInternalBrowser.Visible;
  actShowFindWindow1.Checked := frmFindWindow1.Visible;
  actShowFindWindow2.Checked := frmFindWindow2.Visible;
  actShowProfiler.Checked := frmProfiler.Visible;
  actShowGUIInspector.Checked := frmGUIInspector.Visible;
  actShowGUIControls.Checked := frmGUIControls.Visible;
end;

procedure TfrmLuaEditMain.actMainMenuViewExecute(Sender: TObject);
begin
  DoMainMenuViewExecute;
end;

function TfrmLuaEditMain.DoMainMenuProjectExecute(): Boolean;
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  Result := True;
  
  // Retreive first selected node
  pNode := frmProjectTree.vstProjectTree.GetFirstSelected;

  // Only if a menu is selected
  if Assigned(pNode) then
  begin
    // Retreive data from selected node
    pData := frmProjectTree.vstProjectTree.GetNodeData(pNode);

    actActiveSelPrj.Enabled := (pData.pLuaEditFile.FileType = otLuaEditProject);
    actAddToPrj.Enabled := ((pData.pLuaEditFile = ActiveProject) and Assigned(ActiveProject));
    actPrjSettings.Enabled := ((pData.pLuaEditFile = ActiveProject) and Assigned(ActiveProject));
    frmProjectTree.UnloadFileProject1.Enabled := (pNode.Parent = frmProjectTree.vstProjectTree.RootNode); //(((pData.pLuaEditFile.FileType in LuaEditTextFilesTypeSet) and (pNode.Parent = frmProjectTree.vstProjectTree.RootNode)) or (pData.pLuaEditFile.FileType = otLuaEditProject));

    if pData.pLuaEditFile.FileType = otLuaEditProject then
      actRemoveFromPrj.Enabled := ((pData.pLuaEditFile = ActiveProject) and Assigned(ActiveProject) and (TLuaEditProject(pData.pLuaEditFile).lstUnits.Count <> 0))
    else
      actRemoveFromPrj.Enabled := False;
  end
  else
  begin
    // Flag all menus to false since no node is selected
    actActiveSelPrj.Enabled := False;
    actAddToPrj.Enabled := False;
    actPrjSettings.Enabled := False;
    frmProjectTree.UnloadFileProject1.Enabled := False;
    actRemoveFromPrj.Enabled := False;
  end;
end;

procedure TfrmLuaEditMain.actMainMenuProjectExecute(Sender: TObject);
begin
  DoMainMenuProjectExecute;
end;

function TfrmLuaEditMain.DoMainMenuRunExecute(): Boolean;
begin
  Result := True;

  CheckButtons;
end;

procedure TfrmLuaEditMain.actMainMenuRunExecute(Sender: TObject);
begin
  DoMainMenuRunExecute;
end;

function TfrmLuaEditMain.DoMainMenuToolsExecute(): Boolean;
begin
  Result := False;
  // Do nothing for now...
end;

procedure TfrmLuaEditMain.actMainMenuToolsExecute(Sender: TObject);
begin
  DoMainMenuToolsExecute;
end;

function TfrmLuaEditMain.DoMainMenuHelpExecute(): Boolean;
begin
  Result := False;
  // Do nothing for now...
end;

procedure TfrmLuaEditMain.actMainMenuHelpExecute(Sender: TObject);
begin
  DoMainMenuHelpExecute;
end;

function TfrmLuaEditMain.DoBringGUIFormToFrontExecute(): Boolean;
var
  pLuaEditFile: TLuaEditFile;
  pLuaEditDebugFile: TLuaEditDebugFile;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pLuaEditFile := TLuaEditFile(jvUnitBar.SelectedTab.Data);

      if pLuaEditFile.FileType in LuaEditDebugFilesTypeSet then
      begin
        pLuaEditDebugFile := TLuaEditDebugFile(pLuaEditFile);

        if Assigned(pLuaEditDebugFile.LinkedGUIForm) then
          ShowWindow(pLuaEditDebugFile.LinkedGUIForm.GUIDesignerForm.Handle, SW_SHOWNORMAL);
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.actBringGUIFormToFrontExecute(Sender: TObject);
begin
  DoBringGUIFormToFrontExecute();
end;

function TfrmLuaEditMain.DoShowProjectTreeExecute(): Boolean;
begin
  Result := True;
  actShowProjectTree.Checked := not actShowProjectTree.Checked;
  frmProjectTree.Visible := actShowProjectTree.Checked;

  if actShowProjectTree.Checked then
    ShowDockForm(frmProjectTree)
  else
    HideDockForm(frmProjectTree);
end;

procedure TfrmLuaEditMain.actShowProjectTreeExecute(Sender: TObject);
begin
  DoShowProjectTreeExecute();
end;

function TfrmLuaEditMain.DoShowGUIInspector(): Boolean;
begin
  Result := True;
  actShowGUIInspector.Checked := not actShowGUIInspector.Checked;
  frmGUIInspector.Visible := actShowGUIInspector.Checked;

  if actShowGUIInspector.Checked then
    ShowDockForm(frmGUIInspector)
  else
    HideDockForm(frmGUIInspector);
end;

procedure TfrmLuaEditMain.actShowGUIInspectorExecute(Sender: TObject);
begin
  DoShowGUIInspector();
end;

function TfrmLuaEditMain.DoShowBreakpointsExecute(): Boolean;
begin
  Result := True;
  actShowBreakpoints.Checked := not actShowBreakpoints.Checked;
  frmBreakpoints.Visible := actShowBreakpoints.Checked;

  if actShowBreakpoints.Checked then
    ShowDockForm(frmBreakpoints)
  else
    HideDockForm(frmBreakpoints);
end;

procedure TfrmLuaEditMain.actShowBreakpointsExecute(Sender: TObject);
begin
  DoShowBreakpointsExecute;
end;

function TfrmLuaEditMain.DoShowMessagesExecute(): Boolean;
begin
  Result := True;
  actShowMessages.Checked := not actShowMessages.Checked;
  frmLuaEditMessages.Visible := actShowMessages.Checked;

  if actShowMessages.Checked then
    ShowDockForm(frmLuaEditMessages)
  else
    HideDockForm(frmLuaEditMessages);
end;

procedure TfrmLuaEditMain.actShowMessagesExecute(Sender: TObject);
begin
  DoShowMessagesExecute;
end;

function TfrmLuaEditMain.DoShowWatchListExecute(): Boolean;
begin
  Result := True;
  actShowWatchList.Checked := not actShowWatchList.Checked;
  frmWatch.Visible := actShowWatchList.Checked;

  if actShowWatchList.Checked then
    ShowDockForm(frmWatch)
  else
    HideDockForm(frmWatch);
end;

procedure TfrmLuaEditMain.actShowWatchListExecute(Sender: TObject);
begin
  DoShowWatchListExecute;
end;

function TfrmLuaEditMain.DoShowCallStackExecute(): Boolean;
begin
  Result := True;
  actShowCallStack.Checked := not actShowCallStack.Checked;
  frmStack.Visible := actShowCallStack.Checked;

  if actShowCallStack.Checked then
    ShowDockForm(frmStack)
  else
    HideDockForm(frmStack);
end;

procedure TfrmLuaEditMain.actShowCallStackExecute(Sender: TObject);
begin
  DoShowCallStackExecute;
end;

function TfrmLuaEditMain.DoShowProfilerExecute(): Boolean;
begin
  Result := True;
  actShowProfiler.Checked := not actShowProfiler.Checked;
  frmProfiler.Visible := actShowProfiler.Checked;

  if actShowProfiler.Checked then
    ShowDockForm(frmProfiler)
  else
    HideDockForm(frmProfiler);
end;

procedure TfrmLuaEditMain.actShowProfilerExecute(Sender: TObject);
begin
  DoShowProfilerExecute();
end;

function TfrmLuaEditMain.DoShowGUIControlsExecute(): Boolean;
begin
  Result := True;
  actShowGUIControls.Checked := not actShowGUIControls.Checked;
  frmGUIControls.Visible := actShowGUIControls.Checked;

  if actShowGUIControls.Checked then
    ShowDockForm(frmGUIControls)
  else
    HideDockForm(frmGUIControls);
end;

procedure TfrmLuaEditMain.actShowGUIControlsExecute(Sender: TObject);
begin
  DoShowGUIControlsExecute();
end;

function TfrmLuaEditMain.DoShowLuaStackExecute(): Boolean;
begin
  Result := True;
  actShowLuaStack.Checked := not actShowLuaStack.Checked;
  frmLuaStack.Visible := actShowLuaStack.Checked;

  if actShowLuaStack.Checked then
    ShowDockForm(frmLuaStack)
  else
    HideDockForm(frmLuaStack);
end;

procedure TfrmLuaEditMain.actShowLuaStackExecute(Sender: TObject);
begin
  DoShowLuaStackExecute;
end;

function TfrmLuaEditMain.DoShowLuaOutputExecute(): Boolean;
begin
  Result := True;
  actShowLuaOutput.Checked := not actShowLuaOutput.Checked;
  frmLuaOutput.Visible := actShowLuaOutput.Checked;

  if actShowLuaOutput.Checked then
    ShowDockForm(frmLuaOutput)
  else
    HideDockForm(frmLuaOutput);
end;

procedure TfrmLuaEditMain.actShowLuaOutputExecute(Sender: TObject);
begin
  DoShowLuaOutputExecute;
end;

function TfrmLuaEditMain.DoShowLuaGlobalsExecute(): Boolean;
begin
  Result := True;
  actShowLuaGlobals.Checked := not actShowLuaGlobals.Checked;
  frmLuaGlobals.Visible := actShowLuaGlobals.Checked;

  if actShowLuaGlobals.Checked then
    ShowDockForm(frmLuaGlobals)
  else
    HideDockForm(frmLuaGlobals);
end;

procedure TfrmLuaEditMain.actShowLuaGlobalsExecute(Sender: TObject);
begin
  DoShowLuaGlobalsExecute;
end;

function TfrmLuaEditMain.DoShowLuaLocalsExecute(): Boolean;
begin
  Result := True;
  actShowLuaLocals.Checked := not actShowLuaLocals.Checked;
  frmLuaLocals.Visible := actShowLuaLocals.Checked;

  if actShowLuaLocals.Checked then
    ShowDockForm(frmLuaLocals)
  else
    HideDockForm(frmLuaLocals);
end;

procedure TfrmLuaEditMain.actShowLuaLocalsExecute(Sender: TObject);
begin
  DoShowLuaLocalsExecute;
end;

function TfrmLuaEditMain.DoShowRingsExecute(): Boolean;
begin
  Result := True;
  actShowRings.Checked := not actShowRings.Checked;
  frmRings.Visible := actShowRings.Checked;

  if actShowRings.Checked then
    ShowDockForm(frmRings)
  else
    HideDockForm(frmRings);
end;

procedure TfrmLuaEditMain.actShowRingsExecute(Sender: TObject);
begin
  DoShowRingsExecute;
end;

function TfrmLuaEditMain.DoShowFunctionListExecute(): Boolean;
begin
  Result := True;
  actShowFunctionList.Checked := not actShowFunctionList.Checked;
  frmFunctionList.Visible := actShowFunctionList.Checked;

  if actShowFunctionList.Checked then
    ShowDockForm(frmFunctionList)
  else
    HideDockForm(frmFunctionList);
end;

procedure TfrmLuaEditMain.actShowFunctionListExecute(Sender: TObject);
begin
  DoShowFunctionListExecute;
end;

function TfrmLuaEditMain.DoShowInternalBrowserExecute(): Boolean;
begin
  Result := True;
  actShowInternalBrowser.Checked := not actShowInternalBrowser.Checked;
  frmInternalBrowser.Visible := actShowInternalBrowser.Checked;

  if actShowInternalBrowser.Checked then
    ShowDockForm(frmInternalBrowser)
  else
    HideDockForm(frmInternalBrowser);
end;

procedure TfrmLuaEditMain.actShowInternalBrowserExecute(Sender: TObject);
begin
  DoShowInternalBrowserExecute;
end;

function TfrmLuaEditMain.DoShowFindWindow1Execute(): Boolean;
begin
  Result := True;
  actShowFindWindow1.Checked := not actShowFindWindow1.Checked;
  frmFindWindow1.Visible := actShowFindWindow1.Checked;

  if actShowFindWindow1.Checked then
    ShowDockForm(frmFindWindow1)
  else
    HideDockForm(frmFindWindow1);
end;

procedure TfrmLuaEditMain.actShowFindWindow1Execute(Sender: TObject);
begin
  DoShowFindWindow1Execute;
end;

function TfrmLuaEditMain.DoShowFindWindow2Execute(): Boolean;
begin
  Result := True;
  actShowFindWindow2.Checked := not actShowFindWindow2.Checked;
  frmFindWindow2.Visible := actShowFindWindow2.Checked;

  if actShowFindWindow2.Checked then
    ShowDockForm(frmFindWindow2)
  else
    HideDockForm(frmFindWindow2);
end;

procedure TfrmLuaEditMain.actShowFindWindow2Execute(Sender: TObject);
begin
  DoShowFindWindow2Execute;
end;

procedure TfrmLuaEditMain.mnuXMacroClick(Sender: TObject);
var
  pReg: TRegistry;
  pMenu: TMenuItem;
  RunRelease: Boolean;

  procedure ExecMacroRelease(FileName: String);
  var
    ScriptCode: TStringList;
  begin
    ScriptCode := TStringList.Create;

    // Load/Execute macro
    ScriptCode.LoadFromFile(FileName);
    LuaLoadBuffer(MacroLuaState, ScriptCode.Text, FileName);
    LuaPCall(MacroLuaState, 0, 0, 0);

    // Free variables
    ScriptCode.Free;
  end;

  procedure ExecMacroDebug(FileName: String);
  begin
    RunRelease := False;
    PopUpUnitToScreen(FileName);
    DoStepIntoExecute();
  end;
  
begin
  // Initiate a few things
  pReg := TRegistry.Create;
  pMenu := TMenuItem(Sender);
  RunRelease := True;

  // Get macro's datas
  if pReg.OpenKey('\Software\LuaEdit\Macros\'+pMenu.Hint, False) then
  begin
    // Execute in debug mode if at all possible
    if pReg.ReadBool('DebugMode') then
    begin
      if not Running then
        ExecMacroDebug(pReg.ReadString('FileName'))
      else
      begin
        Application.MessageBox('LuaEdit is enable to initiate the macro in debug mode because you are debugging another file. The macro will run in release mode.', 'LuaEdit', MB_OK+MB_ICONWARNING);
        ExecMacroRelease(pReg.ReadString('FileName'));
      end;
    end
    else
      ExecMacroRelease(pReg.ReadString('FileName'));
  end;

  pReg.Free;
end;

procedure TfrmLuaEditMain.mnuXReopenClick(Sender: TObject);
var
  pFiles: TStringList;
  mnuSender: TMenuItem;
  pReg: TRegistry;
  BuildTreeNeeded: Boolean;
  x: Integer;
begin
  pFiles := TStringList.Create;
  BuildTreeNeeded := False;
  mnuSender := TMenuItem(Sender);
  
  if FileExistsAbs(mnuSender.Caption) then
  begin
    pFiles.Add(mnuSender.Caption);
    DoOpenFileExecute(pFiles);
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

  pFiles.Free;
end;

// Trigered when user clicks on a ring button of the "Files" slide bar
procedure TfrmLuaEditMain.btnXFilesClick(Sender: TObject);
var
  pFiles: TStringList;
  btnSender: TJvOutlookBarButton;
  pReg: TRegistry;
  BuildTreeNeeded: Boolean;
  x: Integer;
begin
  pFiles := TStringList.Create;
  BuildTreeNeeded := False;
  btnSender := TJvOutlookBarButton(Sender);

  if FileExistsAbs(btnSender.Caption) then
  begin
    pFiles.Add(btnSender.Caption);
    DoOpenFileExecute(pFiles);
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
    pReg.Free;

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

  pFiles.Free;
end;

procedure TfrmLuaEditMain.btnXClipboardClick(Sender: TObject);
begin
  Clipboard.SetTextBuf(PChar(TJvOutlookBarButton(Sender).Caption));
end;

function TfrmLuaEditMain.IsProjectOpened(sProjectPath: String): Boolean;
var
  x: integer;
begin
  Result := False;
  
  for x := 0 to LuaProjects.Count -  1 do
  begin
    if TLuaEditProject(LuaProjects.Items[x]).Path = sProjectPath then
    begin
      Result := True;
      break;
    end;
  end;
end;

function TfrmLuaEditMain.DoUndoExecute(): Boolean;
begin
  Result := True;
  TLuaEditUnit(jvUnitBar.SelectedTab.Data).SynUnit.Undo;

  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).SynUnit.UndoList.ItemCount = 0 then
    actUndo.Enabled := False
  else
    actUndo.Enabled := True;

  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).SynUnit.RedoList.ItemCount = 0 then
    actRedo.Enabled := False
  else
    actRedo.Enabled := True;
end;

procedure TfrmLuaEditMain.actUndoExecute(Sender: TObject);
begin
  DoUndoExecute;
end;

function TfrmLuaEditMain.DoRedoExecute(): Boolean;
begin
  Result := True;
  TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.Redo;

  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.UndoList.ItemCount = 0 then
    actUndo.Enabled := False
  else
    actUndo.Enabled := True;

  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.RedoList.ItemCount = 0 then
    actRedo.Enabled := False
  else
    actRedo.Enabled := True;
end;

procedure TfrmLuaEditMain.actRedoExecute(Sender: TObject);
begin
  DoRedoExecute;
end;

function TfrmLuaEditMain.DoCutExecute(): Boolean;
var
  jvOBBtn: TJvOutlookBarButton;
  x: Integer;
  pLuaUnit: TLuaEditUnit;
begin
  Result := False;

  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

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
        Result := True;
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.actCutExecute(Sender: TObject);
begin
  DoCutExecute;
end;

function TfrmLuaEditMain.DoCopyExecute(): Boolean;
var
  jvOBBtn: TJvOutlookBarButton;
  x: Integer;
  pLuaUnit: TLuaEditUnit;
begin
  Result := False;
  
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);
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
        Result := True;
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.actCopyExecute(Sender: TObject);
begin
  DoCopyExecute;
end;

function TfrmLuaEditMain.DoPasteExecute(): Boolean;
begin
  Result := Assigned(jvUnitBar.SelectedTab);

  if Result then
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.PasteFromClipboard;
end;

procedure TfrmLuaEditMain.actPasteExecute(Sender: TObject);
begin
  DoPasteExecute;
end;

function TfrmLuaEditMain.DoSelectAll(): Boolean;
begin
  Result := Assigned(jvUnitBar.SelectedTab);

  if Result then
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelectAll;
end;

procedure TfrmLuaEditMain.actSelectAllExecute(Sender: TObject);
begin
  DoSelectAll;
end;

function TfrmLuaEditMain.DoFindExecute(): Boolean;
var
  Options: TSynSearchOptions;
  Index: Integer;
begin
  Result := True;
  frmSearch.chkRegularExpression.Checked := srSearchRegularExpression;
  frmSearch.chkSearchCaseSensitive.Checked := srSearchSensitive;
  frmSearch.chkSearchWholeWords.Checked := srSearchWholeWords;
  frmSearch.optOrigin.ItemIndex := srSearchOrigin;
  frmSearch.optScope.ItemIndex := srSearchScope;
  frmSearch.optDirection.ItemIndex := srSearchDriection;
  frmSearch.cboSearchText.Items.Clear;
  frmSearch.cboSearchText.Items.AddStrings(SearchedText);

  if SearchedText.Count > 0 then
    frmSearch.cboSearchText.Text := SearchedText.Strings[SearchedText.Count - 1];

  if ((TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelLength > 0) and (TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockBegin.Line = TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockEnd.Line)) then
    frmSearch.cboSearchText.Text := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText
  else if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY) <> '' then
    frmSearch.cboSearchText.Text := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY);

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
    SearchedText.Sort;
    if not SearchedText.Find(sSearchString, Index) then
      SearchedText.Add(sSearchString);

    if srSearchRegularExpression then
      TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearchRegEx
    else
      TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearch;

    if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchReplace(sSearchString, '', Options) = 0 then
    begin
      Result := False;
      Application.MessageBox(PChar('Search string "'+sSearchString+'" not found.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
    end;
  end;
end;

procedure TfrmLuaEditMain.actFindExecute(Sender: TObject);
begin
  DoFindExecute;
end;

function TfrmLuaEditMain.DoFindInFilesExecute(): Boolean;
var
  Options: TSynSearchOptions;
  Index: Integer;
  Ext: String;

  // Find all instances of the text in the given synedit control
  procedure FindTextInSynEdit(FileName, TextToFind: String; Output: Integer; SynEdit: TSynEdit; SynOptions: TSynSearchOptions);
  begin
    // Initialize some stuff...
    frmSIFReport.CurrentFile := FileName;
    frmSIFReport.ScannedFiles := frmSIFReport.ScannedFiles + 1;
    frmSIFReport.ScannedLines := frmSIFReport.ScannedLines + SynEdit.Lines.Count;
    SynEdit.CaretX := 0;
    SynEdit.CaretY := 0;

    // Assign search engine (regular expressions or not)
    if srSearchInFilesRegularExpression then
      SynEdit.SearchEngine := synMainSearchRegEx
    else
      SynEdit.SearchEngine := synMainSearch;

    while SynEdit.SearchReplace(TextToFind, '', SynOptions) <> 0 do
    begin
      frmSIFReport.MatchFound := frmSIFReport.MatchFound + 1;

      // Add result in the right window
      if Output = 0 then
        frmFindWindow1.AddResult(FileName, SynEdit.CaretY, SynEdit.Lines[SynEdit.CaretY - 1])
      else
        frmFindWindow2.AddResult(FileName, SynEdit.CaretY, SynEdit.Lines[SynEdit.CaretY - 1])
    end;
  end;

  // Find text through the current active project
  procedure FindFilesInProject(TextToFind: String; LuaProject: TLuaEditProject; Output: Integer; SynOptions: TSynSearchOptions);
  var
    x: Integer;
    pTmpSynEdit: TSynEdit;
  begin
    pTmpSynEdit := TSynEdit.Create(nil);
    pTmpSynEdit.Visible := False;

    for x := 0 to LuaProject.lstUnits.Count - 1 do
    begin
      if Assigned(TLuaEditUnit(LuaProject.lstUnits[x]).SynUnit) then
        pTmpSynEdit.Text := TLuaEditUnit(LuaProject.lstUnits[x]).SynUnit.Text
      else
        pTmpSynEdit.Lines.LoadFromFile(TLuaEditUnit(LuaProject.lstUnits[x]).Path);

      FindTextInSynEdit(TLuaEditUnit(LuaProject.lstUnits[x]).Path, TextToFind, Output, pTmpSynEdit, SynOptions);
    end;

    pTmpSynEdit.Free;
  end;

  // Find text through all opened files
  procedure FindFilesOpened(TextToFind: String; Output: Integer; SynOptions: TSynSearchOptions);
  var
    x: Integer;
    pTmpSynEdit: TSynEdit;
  begin
    pTmpSynEdit := TSynEdit.Create(nil);
    pTmpSynEdit.Visible := False;

    for x := 0 to LuaOpenedFiles.Count - 1 do
    begin
      pTmpSynEdit.Text := TLuaEditUnit(LuaOpenedFiles[x]).SynUnit.Text;
      FindTextInSynEdit(TLuaEditUnit(LuaOpenedFiles[x]).Path, TextToFind, Output, pTmpSynEdit, SynOptions);
    end;

    pTmpSynEdit.Free;
  end;

  // Find text through the specified directory (possibly all sub directory too -- recursive calls)
  procedure FindFilesInDir(Path, TextToFind: String; IsRecursive: Boolean; Output: Integer; SynOptions: TSynSearchOptions);
  var
    pTmpSynEdit: TSynEdit;
    FullPathName: String;
    iSearchResult: Integer;
    hSearchHandle: TSearchRec;
  begin
    if Path[Length(Path) - 1] = '\' then
      iSearchResult := FindFirst(Path+'*.*', faAnyFile, hSearchHandle)
    else
      iSearchResult := FindFirst(Path+'\*.*', faAnyFile, hSearchHandle);

    while iSearchResult = 0 do
    begin
      if Path[Length(Path) - 1] = '\' then
        FullPathName := Path + hSearchHandle.Name
      else
        FullPathName := Path + '\' + hSearchHandle.Name;

      if (IsRecursive and (hSearchHandle.Name <> '.') and (hSearchHandle.Name <> '..') and ((hSearchHandle.Attr and faDirectory) <> 0)) then
      begin
        // Recursive call for the new found directory
        FindFilesInDir(FullPathName, TextToFind, IsRecursive, Output, SynOptions);
      end
      else
      begin
        if (hSearchHandle.Attr and faDirectory) = 0 then
        begin
          Ext := ExtractFileExt(FullPathName);

          // Make sure the file is a *.lua file
          if (Ext = '.lua') or (Ext = '.lmc') or (Ext = '.txt') then
          begin
            pTmpSynEdit := TSynEdit.Create(nil);
            pTmpSynEdit.Visible := False;
            pTmpSynEdit.Lines.LoadFromFile(FullPathName);
            FindTextInSynEdit(FullPathName, TextToFind, Output, pTmpSynEdit, SynOptions);
            pTmpSynEdit.Free;
          end
          else
            frmSIFReport.SkippedFiles := frmSIFReport.SkippedFiles + 1;
        end;
      end;

      iSearchResult := FindNext(hSearchHandle);
    end;

    FindClose(hSearchHandle);
  end;
begin
  // Initialize find in files window
  Result := True;
  frmFindInFiles.chkRegularExpression.Checked := srSearchInFilesRegularExpression;
  frmFindInFiles.chkSearchCaseSensitive.Checked := srSearchInFilesSensitive;
  frmFindInFiles.chkSearchWholeWords.Checked := srSearchInFilesWholeWords;
  frmFindInFiles.optOutput.ItemIndex := srSearchInFilesOutput;
  frmFindInFiles.jvoptActiveProject.Enabled := Assigned(ActiveProject);
  frmFindInFiles.jvoptOpenFiles.Enabled := (LuaOpenedFiles.Count <> 0);
  frmFindInFiles.SetSearchMode(srSearchInFilesWhere);
  frmFindInFiles.cboSearchInFilesText.Items.Clear;
  frmFindInFiles.cboSearchInFilesText.Items.AddStrings(SearchedInFilesText);

  if SearchedInFilesText.Count > 0 then
    frmFindInFiles.cboSearchInFilesText.Text := SearchedInFilesText.Strings[SearchedInFilesText.Count - 1];

  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if ((TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelLength > 0) and (TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockBegin.Line = TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockEnd.Line)) then
      frmFindInFiles.cboSearchInFilesText.Text := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText
    else if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY) <> '' then
      frmFindInFiles.cboSearchInFilesText.Text := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY);
  end;

  // Show the find in files dialog
  frmFindInFiles.ShowModal;

  if frmFindInFiles.SearchText <> '' then
  begin
    // Set base search options
    Options := [];

    // Add user's preferences to search options
    srSearchInFilesSubDir := frmFindInFiles.IsSubDir;
    srSearchInFilesWhere := frmFindInFiles.GetSearchMode;
    srSearchInFilesOutput := frmFindInFiles.GetOutput;
    srSearchInFilesRegularExpression := frmFindInFiles.IsResgularExpression;
    srSearchInFilesSensitive := frmFindInFiles.IsCaseSensitive;
    if srSearchInFilesSensitive then
      Options := Options + [ssoMatchCase];

    srSearchInFilesWholeWords := frmFindInFiles.IsWholeWordOnly;
    if srSearchInFilesWholeWords then
      Options := Options + [ssoWholeWord];

    sSearchInFilesString := frmFindInFiles.SearchText;
    sSearchInFilesDir := frmFindInFiles.SearchDirectory;
    SearchedInFilesText.Sort;
    if not SearchedInFilesText.Find(sSearchInFilesString, Index) then
      SearchedInFilesText.Add(sSearchInFilesString);
      
    if sSearchInFilesString <> '' then
    begin
      // Initialize stuff...
      Screen.Cursor := crHourGlass;
      frmSIFReport.ResetReport;
      frmSIFReport.Show;

      if srSearchInFilesOutput = 0 then
        frmFindWindow1.lvwResult.Clear
      else
        frmFindWindow2.lvwResult.Clear;

      // Find results according to the search mode
      case srSearchInFilesWhere of
        SIF_ACTPROJECT:   FindFilesInProject(sSearchInFilesString, ActiveProject, srSearchInFilesOutput, Options);
        SIF_OPENED:       FindFilesOpened(sSearchInFilesString, srSearchInFilesOutput, Options);
        SIF_DIRECTORY:    FindFilesInDir(sSearchInFilesDir, sSearchInFilesString, srSearchInFilesSubDir, srSearchInFilesOutput, Options);
      end;

      // Close the report window if required
      if not KeepSIFWindowOpened then
        frmSIFReport.Close;

      // Uninitialize stuff...
      Screen.Cursor := crDefault;

      // Display messages if no match found or popup the right find window if there's a match
      if frmSIFReport.MatchFound = 0 then
      begin
        Result := False;

        // Spelling check, lol ([files were ...] or [file was ...])
        if frmSIFReport.ScannedFiles > 1 then
          Application.MessageBox(PChar('Search string "'+sSearchInFilesString+'" not found. ' + IntToStr(frmSIFReport.ScannedFiles) + ' files were scanned.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION)
        else
          Application.MessageBox(PChar('Search string "'+sSearchInFilesString+'" not found. ' + IntToStr(frmSIFReport.ScannedFiles) + ' file was scanned.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
      end
      else
      begin
        // Initialize actions before executing
        DoMainMenuViewExecute;
        
        // Popup the corresponding find window if not already opened
        if srSearchInFilesOutput = 0 then
          ShowDockForm(frmFindWindow1)
        else
          ShowDockForm(frmFindWindow2);
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.actFindInFilesExecute(Sender: TObject);
begin
  DoFindInFilesExecute;
end;

function TfrmLuaEditMain.DoFindAgainExecute(): Boolean;
var
  Options: TSynSearchOptions;
begin
  Result := True;
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
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearch
  else
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearchRegEx;
    
  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchReplace(sSearchString, '', Options) = 0 then
  begin
    Result := False;
    Application.MessageBox(PChar('Search string "'+sSearchString+'" not found.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
  end;
end;

procedure TfrmLuaEditMain.actFindAgainExecute(Sender: TObject);
begin
  DoFindAgainExecute;
end;

function TfrmLuaEditMain.DoFindReplaceExecute(): Boolean;
var
  Options: TSynSearchOptions;
  Index: Integer;
begin
  Result := True;
  frmReplace.chkRegularExpression.Checked := srSearchRegularExpression;
  frmReplace.chkSearchCaseSensitive.Checked := srSearchSensitive;
  frmReplace.chkSearchWholeWords.Checked := srSearchWholeWords;
  frmReplace.optOrigin.ItemIndex := srSearchOrigin;
  frmReplace.optScope.ItemIndex := srSearchScope;
  frmReplace.optDirection.ItemIndex := srSearchDriection;
  frmReplace.cboSearchText.Items.Clear;
  frmReplace.cboSearchText.Items.AddStrings(SearchedText);
  frmReplace.cboReplaceText.Clear;
  frmReplace.cboReplaceText.Items.AddStrings(ReplacedText);

  if SearchedText.Count > 0 then
    frmReplace.cboSearchText.Text := SearchedText.Strings[SearchedText.Count - 1];
  
  if ((TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail) and (TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockBegin.Line = TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.BlockEnd.Line)) then
    frmReplace.cboSearchText.Text := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText
  else if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY) <> '' then
    frmReplace.cboSearchText.Text := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GetWordAtRowCol(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretXY);

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
    ReplacedText.Sort;
    SearchedText.Sort;
    if not ReplacedText.Find(sReplaceString, Index) then
      ReplacedText.Add(sReplaceString);
      
    if not SearchedText.Find(sSearchString, Index) then
      SearchedText.Add(sSearchString);

    if not srSearchRegularExpression then
      TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearch
    else
      TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchEngine := synMainSearchRegEx;

    if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SearchReplace(sSearchString, sReplaceString, Options) = 0 then
    begin
      Result := False;
      Application.MessageBox(PChar('Search string "'+sSearchString+'" not found.'), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
    end;
  end;
end;

procedure TfrmLuaEditMain.actFindReplaceExecute(Sender: TObject);
begin
  DoFindReplaceExecute;
end;

procedure TfrmLuaEditMain.SynEditReplaceText(Sender: TObject; const ASearch, AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
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

function TfrmLuaEditMain.DoGoToLineExecute(): Boolean;
begin
  frmGotoLine.txtLineNumber.Text := '';
  Result := (frmGotoLine.ShowModal = mrOK);

  if Result then
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(frmGotoLine.LineNumber);
end;

procedure TfrmLuaEditMain.actGoToLineExecute(Sender: TObject);
begin
  DoGoToLineExecute;
end;


function TfrmLuaEditMain.DoGotoLastEditedExecute(): Boolean;
begin
  Result := True;
  TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(TLuaEditUnit(jvUnitBar.SelectedTab.Data).LastEditedLine);
end;

procedure TfrmLuaEditMain.actGotoLastEditedExecute(Sender: TObject);
begin
  DoGotoLastEditedExecute;
end;

procedure TfrmLuaEditMain.AboutLuaEdit1Click(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

// This function manage debug actions in general and handle initialization of debug session
procedure TfrmLuaEditMain.CustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
var
  L: Plua_State;
  FileName: string;
  x, NArgs: Integer;
  pLuaEditDebugFile: TLuaEditDebugFile;
  iDoLuaOpen: Boolean;
  pStackMarker: TBreakInfo;
  pMessageParentNode: PVirtualNode;

  procedure OpenLibs(L: PLua_State; LuaEditDebugFile: TLuaEditDebugFile);
  begin
    // Register regular lua libraries according to settings
    if AutoLoadLibBasic then
      lua_baselibopen(L);
    if AutoLoadLibPackage then
      lua_packlibopen(L);
    if AutoLoadLibTable then
      lua_tablibopen(L);
    if AutoLoadLibOSIO then
      lua_iolibopen(L);
    if AutoLoadLibString then
      lua_strlibopen(L);
    if AutoLoadLibMath then
      lua_mathlibopen(L);
    if AutoLoadLibDebug then
      lua_dblibopen(L);

    lua_settop(L, 0);

    // Register LuaEdit environement if required
    if LuaEditDebugFile.FileType = otLuaEditMacro then
      LERegisterToLua(L);
  end;

  procedure UninitializeUnits;
  var
    x, y: Integer;
    pLuaUnit: TLuaEditUnit;
  begin
    // Uninitialize opened units
    for x := 0 to frmLuaEditMain.jvUnitBar.Tabs.Count - 1 do
    begin
      pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.Tabs[x].Data);
      pLuaUnit.DebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.SynUnit.Refresh;

      // Reset all breakpoints hitcount to 0
      for y := 0 to pLuaUnit.DebugInfos.lstBreakpoint.Count - 1 do
        TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint[y]).iHitCount := 0;
    end;

    if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
      TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).SynUnit.Refresh;

    frmBreakpoints.RefreshBreakpointList;
    frmLuaEditMain.stbMain.Refresh;
  end;

  procedure InitializeUnits;
  var
    x, y: Integer;
    pLuaUnit: TLuaEditUnit;
  begin
    // Initialize opened units
    for x := 0 to frmLuaEditMain.jvUnitBar.Tabs.Count - 1 do
    begin
      pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.Tabs[x].Data);
      pLuaUnit.SynUnit.Modified := False;
      pLuaUnit.DebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.DebugInfos.iLineError := -1;
      pLuaUnit.SynUnit.Refresh;

      // Reset all breakpoints hitcount to 0
      for y := 0 to pLuaUnit.DebugInfos.lstBreakpoint.Count - 1 do
        TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint[y]).iHitCount := 0;
    end;

    if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
      TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).SynUnit.Refresh;

    frmBreakpoints.RefreshBreakpointList;
    frmLuaEditMain.stbMain.Refresh;
  end;

  procedure SetPause(LuaEditDebugFile: TLuaEditDebugFile);
  begin
    if not Pause then
    begin
      LuaEditDebugFile.DebugInfos.iCurrentLineDebug := -1;
      LuaEditDebugFile.DebugInfos.iStackMarker := -1;

      {if Assigned(TfrmLuaEditMain.jvUnitBar.SelectedTab.Data) then
        LuaEditDebugFile(TfrmLuaEditMain.jvUnitBar.SelectedTab.Data).SynUnit.Refresh;}
    end;

    Self.Pause := Pause;
    Self.PauseICI := PauseICI;
    Self.PauseLine := PauseLine;
    Self.PauseFile := PauseFile;
  end;

  function Initializer(L: PLua_State): Boolean;
  begin
    Result := True;

    if TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).PrjOwner.sInitializer <> '' then
    begin
      if frmLuaEditMain.ExecuteInitializer(TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).PrjOwner.sInitializer, L) < 0 then
      begin
        Application.MessageBox('An error occured while executing the initializer function.', 'LuaEdit', MB_OK+MB_ICONERROR);
        frmLuaEditMain.CheckButtons;
        FreeLibrary(hModule);
        Result := False;
      end;
    end;
  end;

  procedure AppendToLuaCPATH(L: PLua_State; AppendStr: String);
  var
    CurrentCPATH: String;
  begin
    lua_getglobal(L, 'package');
    lua_pushstring(L, 'cpath');
    lua_gettable(L, -2);
    
    CurrentCPATH := lua_tostring(L, -1);
    CurrentCPATH := CurrentCPATH + ';' + AppendStr;
    lua_pop(L, 1);

    lua_pushstring(L, 'cpath');
    lua_pushstring(L, PChar(CurrentCPATH));
    lua_settable(L, -3);
  end;

  procedure AppendToLuaPATH(L: PLua_State; AppendStr: String);
  var
    CurrentCPATH: String;
  begin
    lua_getglobal(L, 'package');
    lua_pushstring(L, 'path');
    lua_gettable(L, -2);
    
    CurrentCPATH := lua_tostring(L, -1);
    CurrentCPATH := CurrentCPATH + ';' + AppendStr;
    lua_pop(L, 1);

    lua_pushstring(L, 'path');
    lua_pushstring(L, PChar(CurrentCPATH));
    lua_settable(L, -3);
  end;
begin
  if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
  begin
    pLuaEditDebugFile := TLuaEditDebugFile(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

    if ((pLuaEditDebugFile.PrjOwner = ActiveProject) and (ActiveProject.sTargetLuaUnit <> '[Current Unit]')) then
    begin
      pLuaEditDebugFile := TLuaEditDebugFile(ActiveProject.pTargetLuaUnit);
      PopUpUnitToScreen(pLuaEditDebugFile.Path);
    end;
  end
  else if Assigned(ActiveProject) then
  begin
    pLuaEditDebugFile := TLuaEditDebugFile(ActiveProject.pTargetLuaUnit);
    PopUpUnitToScreen(pLuaEditDebugFile.Path);
  end;

  if Assigned(pLuaEditDebugFile) then
  begin
    if Running then
    begin
      if ((IsEdited) and (NotifyModified)) then
      begin
        case (Application.MessageBox(PChar('The unit "'+pLuaEditDebugFile.Path+'" has changed. Stop debugging?'), 'LuaEdit', MB_ICONINFORMATION+MB_YESNO)) of
        IDYES:
          begin
            Running := False;
            frmLuaEditMessages.Put('End of Scipt - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
            frmLuaEditMessages.Put('Script Terminated by User - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
            Exit;
          end;
        IDNO:
          begin
            NotifyModified := False;
          end;
        end;
      end;
      SetPause(pLuaEditDebugFile);
      ReStart := True;
      Exit;
    end else
    begin
      SetPause(pLuaEditDebugFile);
      NotifyModified := False;
    end;

    if not DoCheckSyntaxExecute then
      Exit;

    iDoLuaOpen := (LuaState = nil);

    if iDoLuaOpen then
      LuaState := lua_open();

    L := LuaState;
    OpenLibs(L, pLuaEditDebugFile);

    if not Initializer(L) then
    begin
      Running := False;
      Exit;
    end;

    Running := True;
    LuaRegister(L, 'print', lua_printex);
    LuaRegister(MacroLuaState, 'io.write', lua_io_writeex);
    lua_sethook(L, HookCaller, HOOK_MASK, 0);
    CurrentICI := 1;
    frmLuaEditMain.CheckButtons;
    frmProfiler.InitProfiler;

    // Initialize LUA_CPATH global for require system
    AppendToLuaCPATH(L, PChar(GetLuaEditInstallPath()+'\lua5.1.dll'));

    // Initializing project's settings if required
    if ActiveProject = pLuaEditDebugFile.PrjOwner then
    begin
      // Initializing runtime directory
      if DirectoryExists(ActiveProject.sRuntimeDirectory) then
      begin
        SetCurrentDirectory(PChar(ActiveProject.sRuntimeDirectory));
        AppendToLuaPATH(L, ActiveProject.sRuntimeDirectory);
      end;
    end;

    if (Assigned(Results)) then
      Results.Clear;

    try
      if Assigned(jvUnitBar.SelectedTab.Data) then
      begin
        TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).SynUnit.Refresh;
        frmLuaEditMain.stbMain.Refresh;
      end;

      PrevFile := pLuaEditDebugFile.Path;
      PrevLine := 0;

      try
        frmLuaEditMessages.vstLuaEditMessages.Clear;
        CallStack.Clear;
        PrintStack;

        if TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).SynUnit.Text = '' then
          Exit;

        LuaLoadBuffer(L, TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).SynUnit.Text, pLuaEditDebugFile.Path);

        if (FuncName <> '') then
        begin
          LuaPCall(L, 0, 0, 0);
          lua_getglobal(L, PChar(FuncName));
          if (lua_type(L, -1) <> LUA_TFUNCTION) then
            raise Exception.CreateFmt('Can''t find function "%s"', [FuncName]);

          NArgs := Length(Args);
          for x := 0 to NArgs - 1 do
            LuaPushString(L, Args[x]);
        end
        else
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
        frmLuaEditMessages.Put('Begin of Script - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
        LuaPCall(L, NArgs, LUA_MULTRET, 0);
        frmLuaEditMessages.Put('End of Script - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
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
        // Handle end of script de-initialization
        UninitializeUnits;
        
        if iDoLuaOpen then
        begin
          lua_close(L);
          LuaState := nil;
        end;

        frmLuaStack.lstLuaStack.Clear;
        frmStack.lstCallStack.Clear;
        frmLuaLocals.lstLocals.Clear;
        frmLuaGlobals.vstGlobals.Clear;
        //CallStack.Clear;
        Running := False;
        Self.Pause := False;
        Self.PauseICI := 0;
        Self.PauseLine := -1;
        Self.PauseFile := '';
        CurrentICI := 1;
        Application.HintHidePause := 2500;
        frmLuaEditMain.CheckButtons;
        FreeLibrary(hModule);

        // Compute the profiler's data
        frmProfiler.ComputeProfiler;
      end;
    except
      on E: ELuaException do
      begin
        PopUpUnitToScreen(PrevFile);

        if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
        begin
          pLuaEditDebugFile := TLuaEditDebugFile(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

          FileName := pLuaEditDebugFile.Path;

          if (not FileExistsAbs(FileName)) then
            FileName := PrevFile;

          if (FileExistsAbs(FileName) and (E.Line > 0)) then
          begin
            pLuaEditDebugFile.DebugInfos.iLineError := E.Line;
            frmLuaEditMain.jvUnitBar.SelectedTab := pLuaEditDebugFile.AssociatedTab;
            pLuaEditDebugFile.SynUnit.GotoLineAndCenter(E.Line);
          end;
        end;

        if (E.Msg <> 'STOP') then
        begin
          stbMain.Panels[5].Text := '[ERROR]: '+E.Msg+' ('+IntToStr(E.Line)+') - '+DateTimeToStr(Now);
          pMessageParentNode := frmLuaEditMessages.Put(E.Msg + ' (' + IntToStr(E.Line) + ') - ' + DateTimeToStr(Now), LUAEDIT_ERROR_MSG, Self.PrevFile, E.Line);

          // Add call stack if stack trace setting is set to true...
          if ShowStackTraceOnError then
          begin
            for x := CallStack.Count - 1 downto 0 do
            begin
              pStackMarker := TBreakInfo(CallStack.Items[x]);
              frmLuaEditMessages.PutChild(pMessageParentNode, pStackMarker.Call, LUAEDIT_UNKNOW_MSG, pStackMarker.FileName, pStackMarker.Line);
            end;
          end;

          frmLuaEditMessages.Put('End of Script - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
          raise;
        end;

        UninitializeUnits;
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.ExecuteCurrent(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer);
begin
  CustomExecute(Pause, PauseICI, PauseFile, PauseLine, '', [], nil);
end;

function TfrmLuaEditMain.DoRunScriptExecute(): Boolean;
begin
  Result := True;
  ExecuteCurrent(False, 0, '', -1);
end;

procedure TfrmLuaEditMain.actRunScriptExecute(Sender: TObject);
begin
  DoRunScriptExecute;
end;

procedure HookCaller(L: Plua_State; AR: Plua_Debug); cdecl;
begin
  frmLuaEditMain.CallHookFunc(L, AR);
end;

{The Lua debug library is calling us every time before executing AR.currentline.
That means that the first line will get hook but only if AR.what='main' and
AR.currentline=-1 and AR.event=0. It also means that it will call us on the last
execution with AR.what='main' and AR.event=0}
procedure TfrmLuaEditMain.CallHookFunc(L: Plua_State; AR: Plua_Debug);
var
  pBreakInfo: TBreakInfo;
  pLuaEditDebugFile: TLuaEditDebugFile;
  MemUsage: Double;

  procedure Update;
  var
    NextFile: string;
    NextLine: Integer;
    LuaEditDebugFile: TLuaEditDebugFile;
  begin
    if FileExistsAbs(StringReplace(AR.source, '@', '',[])) then
      NextFile := ExpandUNCFileName(StringReplace(AR.source, '@', '',[]))
    else
      NextFile := StringReplace(AR.source, '@', '',[]);

    NextLine := AR.currentline;

    if (PrevFile <> NextFile) then
    begin
      LuaEditDebugFile := TLuaEditDebugFile(FindUnitInTabsStr(PrevFile));

      if Assigned(LuaEditDebugFile) then
        LuaEditDebugFile.DebugInfos.iCurrentLineDebug := -1;
        
      PrevFile := NextFile;
    end;
    
    LuaEditDebugFile := TLuaEditDebugFile(PopUpUnitToScreen(NextFile, -1, True));
    LuaEditDebugFile.DebugInfos.iCurrentLineDebug := NextLine;
    LuaEditDebugFile.SynUnit.CaretY := NextLine;
    LuaEditDebugFile.SynUnit.EnsureCursorPosVisibleEx(True);
    LuaEditDebugFile.SynUnit.Refresh;

    ////////////////////////////////////////////////////////////////////////////
    // NOTE: The globals are now updated when clicking on the global's window
    ////////////////////////////////////////////////////////////////////////////
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
    if FileExistsAbs(StringReplace(AR.source, '@', '',[])) then
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

    PrevLine := AR.currentline - 1;

    // Update debug informations only if we are going to break
    if not Restart then
      Update;

    repeat
      // Always process messages while in the waiting loop (even if not hanging in
      // loop because it's running) to avoid output freezes
      // Bug fixed the 10/09/2005 by Jean-Francois Goulet
      Application.ProcessMessages;

      // Only slow down processor if we really have to wait
      // if we don't we have major poor performances
      // Bug fixed the 02/06/2005 by Jean-Francois Goulet
      if not ReStart then
        Sleep(20);

      // Quit loop if user pressed stop/run
      if (not Running) then
      begin
        lua_pushstring(L, 'STOP');
        lua_error(L);
      end;
    until ReStart;
  end;
begin
  if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
    pLuaEditDebugFile := TLuaEditDebugFile(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

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

        // Special handling for main call
        if CAllStack.Count = 0 then
        begin
          pBreakInfo.LineOut := IntToStr(AR.currentline);
          PrevLine := AR.currentline - 1;
        end
        else
          pBreakInfo.LineOut := IntToStr(PrevLine + 1);
        
        if AR.what <> 'C' then
        begin
          pBreakInfo.FileName := pLuaEditDebugFile.Path;
          pBreakInfo.Line := PrevLine;
          pBreakInfo.Call := pLuaEditDebugFile.SynUnit.Lines[PrevLine];
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

      // Retrieve current memory usage by lua
      MemUsage := RoundTo((lua_gc(L, LUA_GCCOUNTB, 0) / 1024) + lua_gc(L, LUA_GCCOUNT, 0), -2);

      // Adding profiler infos
      frmProfiler.AddCall(nil, AR.name, PrevLine + 1, AR.what, MemUsage); // Leave as last line to execute for optimal performances
    end;
    LUA_HOOKRET:
    begin
      frmProfiler.AddReturn(nil, AR.name); // Leave as first line to execute for optimal performances
      
      // Removing from CallStack...
      if CallStack.Count > 0 then
      begin
        TBreakInfo(CallStack.Items[0]).Free;
        CallStack.Delete(0);
      end;
    end;
    LUA_HOOKLINE:
    begin
      //if (not Running) then
        WaitReStart;
    end;
    LUA_HOOKCOUNT, LUA_HOOKTAILRET:
    begin
      // nothing for now
    end;
  end;
end;

// Open the unit in the IDE if not already opened
function TfrmLuaEditMain.PopUpUnitToScreen(sFileName: String; iLine: Integer = -1; bCleanPrevUnit: Boolean = False; HighlightMode: Integer = -1): TLuaEditBasicTextFile;
var
  pLuaEditBasicTextFile: TLuaEditBasicTextFile;
  x: Integer;

  procedure SynEditSelectExactLineText(SynEditCtrl: TSynEdit; Line: Integer);
  begin
    SynEditCtrl.SelLength := Length(SynEditCtrl.Lines[Line - 1]);
  end;
begin
  // Initialize some stuff...
  Result := nil;
  
  try
    // if the current file is already the one selected then we exit this function
    if Assigned(jvUnitBar.SelectedTab) then
    begin
      if TLuaEditFile(jvUnitBar.SelectedTab.Data).Path = sFileName then
      begin
        Result := TLuaEditDebugFile(jvUnitBar.SelectedTab.Data);
        Exit;
      end;
    end;

    if bCleanPrevUnit then
    begin
      if Assigned(jvUnitBar.SelectedTab) then
      begin
        if TLuaEditFile(jvUnitBar.SelectedTab).FileType in LuaEditDebugFilesTypeSet then
        begin
          TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).DebugInfos.iCurrentLineDebug := -1;
          TLuaEditDebugFile(jvUnitBar.SelectedTab.Data).DebugInfos.iStackMarker := -1;
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
    end;

    // Open the file in LuaEdit if not already opened and if it does exists on the hdd
    if not Assigned(FileIsInTree(sFileName)) then
    begin
      if FileExistsAbs(sFileName) then
      begin
        pLuaEditBasicTextFile := TLuaEditBasicTextFile.Create(sFileName);
        pLuaEditBasicTextFile := TLuaEditBasicTextFile(frmLuaEditMain.AddFileInProject(sFileName, False, LuaSingleFiles));
        pLuaEditBasicTextFile.IsLoaded := True;
        frmLuaEditMain.AddFileInTab(pLuaEditBasicTextFile);
        frmProjectTree.BuildProjectTree;
        frmLuaEditMain.CheckButtons;
        Result := pLuaEditBasicTextFile;
      end;
    end
    else
    begin
      pLuaEditBasicTextFile := frmLuaEditMain.FindUnitInTabsStr(sFileName);
      frmLuaEditMain.jvUnitBar.SelectedTab := pLuaEditBasicTextFile.AssociatedTab;
      Result := pLuaEditBasicTextFile;
    end;
  finally
    // Jump to specified line if we found the unit
    if ((iLine > 0) and Assigned(Result)) then
    begin
      Result.SynUnit.GotoLineAndCenter(iLine);

      // Highlight the specified line if required
      if Result.FileType in LuaEditDebugFilesTypeSet then
      begin
        if HighlightMode >= 0 then
        begin
          case HighlightMode of
            HIGHLIGHT_SELECT:     SynEditSelectExactLineText(Result.SynUnit, iLine);
            HIGHLIGHT_STACK:      TLuaEditDebugFile(Result).DebugInfos.iStackMarker := iLine;
            HIGHLIGHT_ERROR:      TLuaEditDebugFile(Result).DebugInfos.iLineError := iLine;
            HIGHLIGHT_BREAKLINE:  TLuaEditDebugFile(Result).DebugInfos.iCurrentLineDebug := iLine;
          end;
        end;
      end;

      Result.synUnit.Refresh;
    end;
  end;
end;

// print the call stack
procedure TfrmLuaEditMain.PrintStack;
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
    pItem.SubItems.Add(TBreakInfo(CallStack.Items[x]).Call);
    pItem.SubItems.Add(TBreakInfo(CallStack.Items[x]).LineOut);
    pItem.Data := CallStack.Items[x];
    pItem.ImageIndex := -1;
  end;

  // Managing Stack breaking icons...
  if frmStack.lstCallStack.Items.Count > 0 then
    frmStack.lstCallStack.Items[0].ImageIndex := 0;

  frmStack.lstCallStack.Items.EndUpdate;
end;

// print the lua stack
procedure TfrmLuaEditMain.PrintLuaStack(L: Plua_State);
begin
  LuaStackToStrings(L, frmLuaStack.lstLuaStack.Items, MaxTablesSize, MaxSubTablesLevel, CheckCyclicReferencing);
end;

// print local list and fill the list of locals
procedure TfrmLuaEditMain.PrintLocal(L: Plua_State; Level: Integer = 0);
begin
  LuaLocalToStrings(L, frmLuaLocals.lstLocals.Items, MaxTablesSize, Level, MaxSubTablesLevel, CheckCyclicReferencing);
  LuaLocalToStrings(L, lstLocals, MaxTablesSize, Level, MaxSubTablesLevel, CheckCyclicReferencing);
end;

// print global list
procedure TfrmLuaEditMain.PrintGlobal(L: Plua_State; Foce: Boolean);
begin
  if (not Assigned(L)) then
    Exit;
  if not Foce then
    Exit;

  LuaTableToVirtualTreeView(L, LUA_GLOBALSINDEX, frmLuaGlobals.vstGlobals, MaxTablesSize, MaxSubTablesLevel, CheckCyclicReferencing);
  LuaGlobalToStrings(L, lstGlobals, MaxTablesSize, MaxSubTablesLevel, CheckCyclicReferencing);
end;

// print watches list
procedure TfrmLuaEditMain.PrintWatch(L: Plua_State);
var
  x, iLen: Integer;
  sSub, sValue, sLookup, sSubTable: String;
  lstTable: TStringList;
  IsTable: Boolean;
  pNode, pChildNode, pNodeToDel: PVirtualNode;
  pData, pChildData, pNewData: PWatchNodeData;

  // Go through all nodes of the tree and set their ToKeep flag to false
  procedure UnflagAllExpanded(pTree: TVirtualStringTree);
  var
    pNode: PVirtualNode;
    pData: PWatchNodeData;
  begin
    pNode := pTree.GetFirst;

    while Assigned(pNode) do
    begin
      pData := pTree.GetNodeData(pNode);
      pData.ToKeep := False;
      pNode := pTree.GetNext(pNode);
    end;
  end;

  // Deletes all nodes for wich their ToKeep flag is still on false
  procedure CleanTree(pTree: TVirtualStringTree);
  var
    pNode, pPrevious: PVirtualNode;
    pData: PWatchNodeData;
  begin
    pNode := pTree.GetFirst;

    while Assigned(pNode) do
    begin
      pData := pTree.GetNodeData(pNode);
      
      if not pData.ToKeep then
      begin
        pPrevious := pTree.GetPrevious(pNode);
        pTree.DeleteNode(pNode);
        pNode := pPrevious;
      end;
      
      pNode := pTree.GetNext(pNode);
    end;
  end;

  // Subroutine wich parse a string to retreive fields and tables
  procedure LuaStrTableToStringList(sTable: String; pStrLst: TStrings);
  var
    sTemp, sName, sValue: String;
    Token: Char;
    iPos, iLevel: Integer;
  begin
    if sTable[1] = '{' then
    begin
      pStrLst.Clear;
      sTemp := Copy(sTable, 3, Length(sTable) - 2);
      iLen := Length(sTemp);
      iPos := 1;

      while sTemp[iPos] <> '}' do
      begin
        sName := '';
        sValue := '';
        
        // Retreive name part
        while sTemp[iPos] <> '=' do
        begin
          sName := sName + sTemp[iPos];
          Inc(iPos);
        end;

        // Retreive the value part
        Inc(iPos);
        Token := sTemp[iPos];

        // Take different actions according to the token
        case Token of
          '"':
          begin
            sValue := sTemp[iPos];
            Inc(iPos);

            while sTemp[iPos] <> '"' do
            begin
              sValue := sValue + sTemp[iPos];
              Inc(iPos);
            end;

            sValue := sValue + sTemp[iPos];
            Inc(iPos);
          end;
          '{':
          begin
            iLevel := 1;
            sValue := sTemp[iPos];
            Inc(iPos);

            repeat
              sValue := sValue + sTemp[iPos];

              if sTemp[iPos] = '{' then
                Inc(iLevel);

              if sTemp[iPos] = '}' then
                Dec(iLevel);

              Inc(iPos);
            until iLevel = 0;
          end;
          else
          begin
            repeat
              sValue := sValue + sTemp[iPos];
              Inc(iPos);
            until sTemp[iPos] = ' ';
          end;
        end;

        pStrLst.Values[sName] := sValue;
        Inc(iPos);
      end;
    end;
  end;

  // Normalize a table indexing style a[1]["test"] -> a.[1].test
  function NormalizeName(sName: String): String;
  var
    sTemp, sKey: String;
    Dummy: Integer;
  begin
    Result := '';
    sTemp := sName;

    // Convert [] indexing style to . indexing style
    while Pos('[', sTemp) <> 0 do
    begin
      Result := Result + Copy(sTemp, 1, Pos('[', sTemp) - 1) + '.';
      sTemp := Copy(sTemp, Pos('[', sTemp) + 1, Length(sTemp) - Pos('[', sTemp));
      sKey := Copy(sTemp, 1, Pos(']', sTemp) - 1);

      // Convert integer indexing into [] formating for LuaEdit compatibility if required
      if TryStrToInt(sKey, Dummy) then
        Result := Result + '[' + Dequote(sKey) + ']'
      else
        Result := Result + Dequote(sKey);

      sTemp := Copy(sTemp, Pos(']', sTemp) + 1, Length(sTemp) - Pos(']', sTemp));
    end;

    // Append rests of sTemp if any...
    if sTemp <> '' then
      Result := Result + sTemp;

    // Return passed name if normal...
    if Result = '' then
      Result := sName;
  end;

begin
  // Initialize stuff
  UnflagAllExpanded(frmWatch.vstWatch);
  lstTable := TStringList.Create;
  pNodeToDel := nil;

  // Get first node to start
  pNode := frmWatch.vstWatch.GetFirst;

  // Go through all nodes
  while pNode <> nil do
  begin
    // retreive current text and initializing some values
    pData := frmWatch.vstWatch.GetNodeData(pNode);
    IsTable := False;
    sValue := '';

    // A variable name must be assigned in order to make an association
    if pData.Name <> '' then
    begin
      // Attempt to make the association
      if pNode.Parent = frmWatch.vstWatch.RootNode then
      begin
        if ((Pos('.', pData.Name) <> 0) or (Pos('[', pData.Name) <> 0)) then
        begin
          IsTable := True;
          // Normalize table's indexing style
          sLookup := NormalizeName(pData.Name);
          sSubTable := Copy(sLookup, Pos('.', sLookup) + 1, Length(sLookup) - Pos('.', sLookup));
          sLookup := Copy(sLookup, 1, Pos('.', sLookup) - 1);

          if sSubTable = '' then
            sValue := 'nil';
        end
        else
          sLookup := pData.Name;

        if lstLocals.Values[sLookup] <> '' then
          sValue := lstLocals.Values[sLookup];

        if ((sValue = '') and (lstGlobals.Values[sLookup] <> '')) then
          sValue := lstGlobals.Values[sLookup];

        if sValue = '' then
          sValue := 'nil';
      end
      else
      begin
        if pData.ToKeep = True then
          sValue := pData.Value;
      end;

      if sValue <> '' then
      begin
        // Parse table string if it is a table and initalize any required child
        if sValue[1] = '{' then
        begin
          // If value found and is a name is a table then we recursively search for value
          if IsTable then
          begin
            // Initialize first item to look for
            sSub := Copy(sSubTable, 1, Pos('.', sSubTable) - 1);
            if sSub = '' then
              sSub := sSubTable;
          
            // Search for value/subtables in current value
            while ((sValue <> 'nil') and (sSub <> '')) do
            begin
              if Pos('.', sSubTable) <> 0 then
                sSubTable := Copy(sSubTable, Pos('.', sSubTable) + 1, Length(sSubTable) + Pos('.', sSubTable) - 1)
              else
                sSubTable := '';

              LuaStrTableToStringList(sValue, lstTable);
              sValue := lstTable.Values[sSub];

              if sValue = '' then
                sValue := 'nil';

              sSub := Copy(sSubTable, 1, Pos('.', sSubTable) - 1);
              if sSub = '' then
                sSub := sSubTable;
              // Find subtables in current sValue until result or not...
            end;
          end;

          // If found value is still a table then display values/subtables...
          if sValue[1] = '{' then
          begin
            LuaStrTableToStringList(sValue, lstTable);
            pData.Value := sValue;
            pData.ToKeep := True;

            // Get first child
            pChildNode := frmWatch.vstWatch.GetFirstChild(pNode);

            while pChildNode <> nil do
            begin
              // Get the current data of the current child
              pChildData := frmWatch.vstWatch.GetNodeData(pChildNode);

              if ((lstTable.Values[pChildData.Name] <> '') and (lstTable.Values[pChildData.Name] <> 'nil')) then
              begin
                pChildData.ToKeep := True;
                pChildData.Value := lstTable.Values[pChildData.Name];
                lstTable.Values[pChildData.Name] := '';
                pNodeToDel := nil;
              end
              else
                pNodeToDel := pChildNode;

              // Get next sibling child
              pChildNode := frmWatch.vstWatch.GetNextSibling(pChildNode);

              // Delete the node if required
              if Assigned(pNodeToDel) then
              begin
                frmWatch.vstWatch.DeleteNode(pNodeToDel);
                pNodeToDel := nil;
              end;
            end;

            // Assign child nodes
            for x := 0 to lstTable.Count - 1 do
            begin
              if lstTable.Values[lstTable.Names[x]] <> '' then
              begin
                pNewData := frmWatch.vstWatch.GetNodeData(frmWatch.vstWatch.AddChild(pNode));
                pNewData.ToKeep := True;
                pNewData.Name := lstTable.Names[x];
                pNewData.Value := lstTable.Values[pNewData.Name];
              end;
            end;
          end
          else
          begin
            pData.ToKeep := True;
            pData.Value := sValue;
          end;
        end
        else
        begin
          pData.ToKeep := True;
          pData.Value := sValue;
        end;
      end;
    end
    else
      pNodeToDel := pNode;

    //pNode := frmWatch.vstWatch.GetNextSibling(pNode);
    pNode := frmWatch.vstWatch.GetNext(pNode);

    // Delete the node if required
    if Assigned(pNodeToDel) then
    begin
      frmWatch.vstWatch.DeleteNode(pNodeToDel);
      pNodeToDel := nil;
    end;
  end;

  // Free stuff and call virtual treeview to repaint
  lstTable.Free;
  CleanTree(frmWatch.vstWatch);
  frmWatch.vstWatch.Refresh;
end;

// check if current debug line is a break one
function TfrmLuaEditMain.IsBreak(sFileName: String; Line: Integer): Boolean;
var
  pLuaUnit: TLuaEditDebugFile;
  pBreakpoint: TBreakpoint;
  BreakCondition: String;

  // This function evaluate a breakpoint condition for lua locals
  // NB: This work around is necessary since all chunk reader functions of lua (lua_dostring, lua_load, etc...)
  //     are beeing executed in the global scope. So to solve the problem of conditions
  //     returning false all the time because they refer to local variable testing
  //     such as...
  //
  //                variable intialisation from lua ----> local a = 3
  //                condition from luaedit -------------> return a == 3
  //
  //     ...the trick is to take all local variables of the current scope from the main debug lua state
  //     and setting them into the globals of a temporary lua state and testing with that temporary state afterward.
  function LuaTestLocals(L: PLua_State; sCond: String): Boolean;
  var
    LuaStateTemp: PLua_State;
    Name: PChar;
    Index: Integer;
    Debug: lua_Debug;
    AR: Plua_Debug;
  begin
    Result := False; 
    AR := @Debug;
    Index := 1;
    LuaStateTemp := lua_open();

    // Get activation record (AR) of local scope (so at level 0)
    if (lua_getstack(L, 0, AR) = 0) then
      Exit;

    Name := lua_getlocal(L, AR, Index); // Get first local value and name (if any)
    while (Name <> nil) do
    begin
      LuaPushVariant(LuaStateTemp, LuaToVariant(L, -1)); // Retrive local value from main debug state and pushes it on the stack of temporary lua state
      lua_setglobal(LuaStateTemp, Name); // Set local value with the same name in global scope of temporary lua state
      lua_pop(L, 1); // Pop the value of local 'Name' from the main debug state
      Inc(Index); // Increment index for next local value and name (if any)
      Name := lua_getlocal(L, AR, Index); // Get next local value and name (if any)
    end;

    // Evaluate condition in temporary state now containing globals as locals of main debug state
    if luaL_dostring(LuaStateTemp, PChar('return '+sCond)) = 0 then
      Result := lua_toboolean(LuaStateTemp, -1);
      
    lua_close(LuaStateTemp);
  end;

  // This function evaluate a breakpoint condition for lua globals
  function LuaTestGlobals(L: PLua_State; sCond: String): Boolean;
  begin
    Result := False;

    if luaL_dostring(L, PChar('return '+sCond)) = 0 then
      Result := lua_toboolean(L, -1);
      
    lua_pop(L, 1);
  end;
begin
  Result := False;
  pLuaUnit := TLuaEditDebugFile(FindUnitInTabsStr(sFileName));

  if Assigned(pLuaUnit) then
  begin
    if pLuaUnit.DebugInfos.IsBreakPointLine(Line) then
    begin
      pBreakpoint := pLuaUnit.DebugInfos.GetBreakpointAtLine(Line);

      if pBreakpoint.iStatus = BKPT_ENABLED then
      begin
        BreakCondition := pBreakpoint.sCondition;
        if BreakCondition <> '' then
        begin
          // Testing conditions for locals and globals (see comment above about those functions)
          if LuaTestGlobals(LuaState, BreakCondition) or LuaTestLocals(LuaState, BreakCondition) then
          begin
            // Breakpoint hit!!!
            Result := True;
          end;
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
function TfrmLuaEditMain.IsICI(ICI: Integer): Boolean;
begin
  Result := (ICI <= PauseICI);
end;

// stdout extended function for lua_print and lua_io_write override
procedure DoLuaStdoutEx(F, S: PChar; L, N: Integer);
const
  CR = #$0D;
  LF = #$0A;
  CRLF = CR + LF;
begin
  frmLuaOutput.Put(F, StringReplace(S, LF, CRLF, [rfReplaceAll]), L);
end;

// check if the given unit was modified
function TfrmLuaEditMain.IsEdited(pIgnoreUnit: TLuaEditUnit): Boolean;
var
  x: Integer;
  pLuaUnit: TLuaEditUnit;
begin
  Result := False;

  for x := 0 to jvUnitBar.Tabs.Count - 1 do
  begin
    pLuaUnit := TLuaEditUnit(jvUnitBar.Tabs[x].Data);
    if (pLuaUnit <> pIgnoreUnit) then
      Result := Result or pLuaUnit.HasChanged;
  end;
end;

procedure TfrmLuaEditMain.LuaHelp1Click(Sender: TObject);
begin
  BrowseURL(PChar(GetLuaEditInstallPath() + '\Help\LuaManual\ManualIndex.html'));
end;

function TfrmLuaEditMain.DoAddWatchExecute(): Boolean;
var
  pNode: PVirtualNode;
  pData: PWatchNodeData;
  sVarName: String;
begin
  // Determine default proposed value
  sVarName := 'VarName';

  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText <> '' then
        sVarName := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText;
    end;
  end;

  if InputQuery('Add Watch', 'Enter the name of the variable to watch:', sVarName) then
  begin
    frmWatch.vstWatch.RootNodeCount := frmWatch.vstWatch.RootNodeCount + 1;
    pNode := frmWatch.vstWatch.GetLast;
    pData := frmWatch.vstWatch.GetNodeData(pNode);
    pData.Name := sVarName;
    PrintWatch(frmLuaEditMain.LuaState);
  end;
end;

// add selected data to watch list
procedure TfrmLuaEditMain.actAddWatchExecute(Sender: TObject);
begin
  DoAddWatchExecute;
end;

function TfrmLuaEditMain.DoToggleBreakpointExecute(): Boolean;
var
  iCurrentLine: Integer;
begin
  Result := True;
  iCurrentLine := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.CaretY;

  if not TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.IsBreakPointLine(iCurrentLine) then
    TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.AddBreakpointAtLine(iCurrentLine)
  else
    TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.RemoveBreakpointAtLine(iCurrentLine);

  TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
  frmBreakpoints.RefreshBreakpointList;
end;

procedure TfrmLuaEditMain.actToggleBreakpointExecute(Sender: TObject);
begin
  DoToggleBreakpointExecute;
end;

function TfrmLuaEditMain.DoEnableDisableBreakpoint(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
begin
  Result := False;

  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      Result := True;
      pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);
      pLuaUnit.DebugInfos.EnableDisableBreakpointAtLine(pLuaUnit.synUnit.CaretY);
      pLuaUnit.synUnit.Refresh;
      frmBreakpoints.RefreshBreakpointList;
    end;
  end;
end;

procedure TfrmLuaEditMain.actEnableDisableBreakpointExecute(Sender: TObject);
begin
  DoEnableDisableBreakpoint;
end;

procedure TfrmLuaEditMain.stbMainDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var
  InflatedRect: TRect;
begin
  if ((Panel.Text <> '') and (Panel.Index = 5)) then
  begin
    // Special handling for error messages
    StatusBar.Canvas.Font.Color := clWhite;
    StatusBar.Canvas.Brush.Color := $00A06A53;
    StatusBar.Canvas.FillRect(Rect);
    InflatedRect := Rect;
    DrawText(StatusBar.Canvas.Handle, PChar('  '+Panel.Text), Length('  '+Panel.Text), InflatedRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_END_ELLIPSIS);
    InflateRect(InflatedRect, 1, 1);
    StatusBar.Canvas.Brush.Color := clGrayText;
    StatusBar.Canvas.FrameRect(Rect);
  end
  else
  begin
    // Regualar handling
    StatusBar.Canvas.Font.Color := clBlack;
    StatusBar.Canvas.FillRect(Rect);
    StatusBar.Canvas.TextRect(Rect, Rect.Left, Rect.Top, '  '+Panel.Text);
    InflatedRect := Rect;
    InflateRect(InflatedRect, 1, 1);
    StatusBar.Canvas.Brush.Color := clGrayText;
    StatusBar.Canvas.FrameRect(Rect);
  end;
end;

procedure TfrmLuaEditMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  x, y, Answer: Integer;
  DisplayPath: String;
  pFile: TLuaEditBasicTextFile;
  pLuaUnit: TLuaEditUnit;
  pLuaProject: TLuaEditProject;
  bProjectAdded: Boolean;
  frmExSaveExit: TfrmExSaveExit;
begin
{$ifdef RTASSERT} RTAssert(0, true, ' TfrmLuaEditMain.FormCloseQuery', '', 0); {$endif}
  // Here we check if the user is currently debugging a unit
  // If that is the case, we aware the user that he is currently debugging a file
  // and that is going to stop the debugger.
  if LuaOpenedFiles.Count > 0 then
  begin
    pFile := TLuaEditBasicTextFile(jvUnitBar.SelectedTab.Data);

    if pFile.FileType in LuaEditDebugFilesTypeSet then
    begin
      if (Running or (TLuaEditDebugFile(pFile).DebugInfos.iCurrentLineDebug <> -1)) then
      begin
        if Application.MessageBox('This action will stop the debugger. Continue anyway?', 'LuaEdit', MB_YESNO+MB_ICONINFORMATION) = IDNO then
        begin
          CanClose := False;
          Exit;
        end
        else
        begin
          actStopExecute(nil);
          TLuaEditDebugFile(pFile).DebugInfos.iCurrentLineDebug := -1;
          TLuaEditDebugFile(pFile).DebugInfos.iLineError := -1;
          pFile.SynUnit.Refresh;
        end;
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
        pFile := TLuaEditBasicTextFile(pLuaProject.lstUnits.Items[y]);

        if ((not bProjectAdded) and (pLuaProject.Name <> '[@@SingleUnits@@]') and ((pLuaProject.HasChanged) or (pLuaProject.IsNew))) then
        begin
          frmExSaveExit.lstFiles.AddItem(pLuaProject.Name + ' {' + DisplayPath + ')', pLuaProject);
          bProjectAdded := True;
        end;

        if ((pFile.HasChanged) or (pFile.IsNew)) then
        begin
          if pLuaProject.Name = '[@@SingleUnits@@]' then
            frmExSaveExit.lstFiles.AddItem(ExtractFileExt(pFile.DisplayPath), pFile)
          else
            frmExSaveExit.lstFiles.AddItem('     ' + ExtractFileExt(pFile.DisplayPath), pFile);
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
              if TLuaEditFile(frmExSaveExit.lstFiles.Items.Objects[x]).FileType <> otLuaEditProject then
              begin
                // We know its a text file...
                pFile := TLuaEditBasicTextFile(frmExSaveExit.lstFiles.Items.Objects[x]);

                if SaveUnitsInc then
                begin
                  if pFile.FileType = otLuaEditUnit then
                    CanClose := TLuaEditUnit(pFile).SaveInc(pFile.Path)
                  else if pFile.FileType = otLuaEditMacro then
                    CanClose := TLuaEditMacro(pFile).SaveInc(pFile.Path)
                  else
                    CanClose := pFile.SaveInc(pFile.Path);
                end
                else
                begin
                  if pFile.FileType = otLuaEditUnit then
                    CanClose := TLuaEditUnit(pFile).Save(pFile.Path)
                  else if pFile.FileType = otLuaEditMacro then
                    CanClose := TLuaEditMacro(pFile).Save(pFile.Path)
                  else
                    CanClose := pFile.Save(pFile.Path);
                end;
              end
              else
              begin
                // We know its a project...
                pLuaProject := TLuaEditProject(frmExSaveExit.lstFiles.Items.Objects[x]);

                if SaveProjectsInc then
                  CanClose := pLuaProject.SaveInc(pLuaProject.Path)
                else
                  CanClose := pLuaProject.Save(pLuaProject.Path);
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
        pLuaUnit := TLuaEditUnit(pLuaProject.lstUnits.Items[y]);

        if ((pLuaUnit.HasChanged) or (pLuaUnit.IsNew)) then
        begin
          Answer := Application.MessageBox(PChar('Save changes to unit "'+pLuaUnit.Path+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
        
          if Answer = IDYES then
          begin
            if SaveUnitsInc then
              pLuaUnit.SaveInc(pLuaUnit.Path)
            else
              pLuaUnit.Save(pLuaUnit.Path);
          end
          else if Answer = IDCANCEL then
            CanClose := False;
        end;
      end;

      // check if the project has to be save (new or modified)
      if (((pLuaProject.HasChanged) or (pLuaProject.IsNew)) and (pLuaProject.Name <> '[@@SingleUnits@@]')) then
      begin
        Answer := Application.MessageBox(PChar('Save changes to project "'+pLuaProject.Name+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);

        if Answer = IDYES then
        begin
          if SaveProjectsInc then
            pLuaProject.SaveInc(pLuaProject.Path)
          else
            pLuaProject.Save(pLuaProject.Path);
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
    // Writes editor settings to make sure all settings are saved
    // Note: Some settings may be changed by the user without going thtrough the
    // Editor Settings window
    frmEditorSettings.LoadEditorSettings;
    frmEditorSettings.WriteEditorSettings;

    // Backward compatibility with the ini file (versions < 3.0)
    // Delete useless *.ini and *.dat files
    if FileExistsAbs(GetLuaEditInstallPath()+'\LuaEdit.ini') then
    begin
      DeleteFile(PChar(GetLuaEditInstallPath()+'\LuaEdit.ini'));
      DeleteFile(PChar(GetLuaEditInstallPath()+'\LuaEdit.dat'));
    end;

    jvchnNotifier.Active := False;  // "Turn off" the changes notifier
    SaveDockTreeToFile(ExtractFilePath(Application.ExeName) + 'LuaEdit.dck');  // saves the dockable forms positions
  end;
{$ifdef RTASSERT} RTAssert(0, true, ' TfrmLuaEditMain.FormCloseQuery Done', '', 0); {$endif}
end;

function TfrmLuaEditMain.DoStepOverExecute(): Boolean;
begin
  Result := True;

  if (Pause) then
  begin
    Result := False;
    Exit;
  end;

  ExecuteCurrent(False, CurrentICI, '', -1);
end;

procedure TfrmLuaEditMain.actStepOverExecute(Sender: TObject);
begin
  DoStepOverExecute;
end;

function TfrmLuaEditMain.DoStepIntoExecute(): Boolean;
begin
  Result := True;

  if (Pause) then
  begin
    Result := False;
    Exit;
  end;
  ExecuteCurrent(True, 0, '', -1);
end;

procedure TfrmLuaEditMain.actStepIntoExecute(Sender: TObject);
begin
  DoStepIntoExecute;
end;

procedure TfrmLuaEditMain.synEditGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
var
  iCurrentLine: Integer;
  pLuaUnit: TLuaEditUnit;
begin
  if X <= 14 then
  begin
    pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);
    iCurrentLine := pLuaUnit.synUnit.RowToLine(Line);

    if not pLuaUnit.DebugInfos.IsBreakPointLine(iCurrentLine) then
      pLuaUnit.DebugInfos.AddBreakpointAtLine(iCurrentLine)
    else
      pLuaUnit.DebugInfos.RemoveBreakpointAtLine(iCurrentLine);

    pLuaUnit.synUnit.Refresh;
    frmBreakpoints.RefreshBreakpointList;
  end;
end;

function TfrmLuaEditMain.DoPauseExecute(): Boolean;
begin
  Result := False;

  if ReStart or Running then
  begin
    frmLuaEditMessages.Put('Script Paused by User - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
    Result := True;
    Pause := True;
  end;
end;

procedure TfrmLuaEditMain.actPauseExecute(Sender: TObject);
begin
  DoPauseExecute;
end;

function TfrmLuaEditMain.DoStopExecute(): Boolean;
begin
  Result := True;

  if Running then
  begin
    frmLuaEditMessages.Put('End of Scipt - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
    frmLuaEditMessages.Put('Script Terminated by User - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
    Running := False;
  end;
end;

procedure TfrmLuaEditMain.actStopExecute(Sender: TObject);
begin
  DoStopExecute;
end;

function TfrmLuaEditMain.DoRunToCursorExecute(): Boolean;
begin
  Result := Assigned(jvUnitBar.SelectedTab);

  if Result then
    ExecuteCurrent(False, 0, '', TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretY);
end;

procedure TfrmLuaEditMain.actRunToCursorExecute(Sender: TObject);
begin
  DoRunToCursorExecute;
end;

procedure TfrmLuaEditMain.synEditMouseCursor(Sender: TObject; const aLineCharPos: TBufferCoord; var aCursor: TCursor);
var
  sWord: String;
  pFile: TLuaEditBasicTextFile;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pFile := TLuaEditBasicTextFile(jvUnitBar.SelectedTab.Data);

      // The autodisplay value feature is only available for debuggable files
      if pFile.FileType in LuaEditDebugFilesTypeSet then
      begin
        // Make sure we're currently debugging
        if (Running and (TLuaEditDebugFile(pFile).DebugInfos.iCurrentLineDebug <> -1)) then
        begin
          // Make sure the cursor is in a "ok" location
          if aLineCharPos.Line <= pFile.SynUnit.Lines.Count - 1 then
          begin
            if aLineCharPos.Char <= Length(pFile.SynUnit.Lines[aLineCharPos.Line - 1]) - 1 then
            begin
              // Find the word under the cursor if any
              sWord := pFile.SynUnit.GetWordAtRowCol(aLineCharPos);

              if sWord <> '' then
              begin
                // Find the "local" value associated to that word if any
                if lstLocals.Values[sWord] <> '' then
                begin
                  if pFile.SynUnit.Hint <> sWord + ' = ' + lstLocals.Values[sWord] then
                  begin
                    Application.CancelHint;
                  end;

                  pFile.SynUnit.Hint := sWord + ' = ' + lstLocals.Values[sWord];
                end
                // Otherwise, we find the "global" value associated to that word if any
                else if lstGlobals.Values[sWord] <> '' then
                begin
                  if pFile.SynUnit.Hint <> sWord + ' = ' + lstGlobals.Values[sWord] then
                  begin
                    Application.CancelHint;
                  end;

                  pFile.SynUnit.Hint := sWord + ' = ' + lstGlobals.Values[sWord];
                end
                else
                  pFile.SynUnit.Hint := '';
              end
              else
                pFile.SynUnit.Hint := '';
            end
            else
              pFile.SynUnit.Hint := '';
          end
          else
            pFile.SynUnit.Hint := '';
        end
        else
          pFile.SynUnit.Hint := '';
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.synEditScroll(Sender: TObject; ScrollBar: TScrollBarKind);
var
  pFile: TLuaEditBasicTextFile;
begin
  if Assigned(jvUnitBar.SelectedTab.Data) then
  begin
    pFile := TLuaEditBasicTextFile(jvUnitBar.SelectedTab.Data);

    // Reset line painting variables
    if pFile.FileType in LuaEditDebugFilesTypeSet then
    begin
      TLuaEditDebugFile(pFile).DebugInfos.iLineError := -1;
      TLuaEditDebugFile(pFile).DebugInfos.iStackMarker := -1;
    end;

    stbMain.Panels[5].Text := '';
    pFile.SynUnit.Refresh;
  end;
end;

procedure TfrmLuaEditMain.synEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  pFile: TLuaEditBasicTextFile;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    pFile := TLuaEditBasicTextFile(jvUnitBar.SelectedTab.Data);
    Special := False;

    if pFile.FileType in LuaEditDebugFilesTypeSet then
    begin
      if TLuaEditDebugFile(pFile).DebugInfos.IsBreakPointLine(Line) then
      begin
        Special := True;
        BG := StringToColor(TEditorColors(EditorColors.Items[9]).Background);
        FG := StringToColor(TEditorColors(EditorColors.Items[9]).Foreground);
      end;

      if TLuaEditDebugFile(pFile).DebugInfos.iCurrentLineDebug = Line then
      begin
        Special := True;
        BG := StringToColor(TEditorColors(EditorColors.Items[3]).Background);
        FG := StringToColor(TEditorColors(EditorColors.Items[3]).Foreground);
      end;

      if TLuaEditDebugFile(pFile).DebugInfos.iLineError = Line then
      begin
        Special := True;
        BG := StringToColor(TEditorColors(EditorColors.Items[2]).Background);
        FG := StringToColor(TEditorColors(EditorColors.Items[2]).Foreground);
      end;

      if TLuaEditDebugFile(pFile).DebugInfos.iStackMarker = Line then
      begin
        Special := True;
        BG := clNavy;
        FG := clWhite;
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.synEditChange(Sender: TObject);
var
  pFile: TLuaEditBasicTextFile;
begin
  if Assigned(jvUnitBar.SelectedTab.Data) then
  begin
    pFile := TLuaEditBasicTextFile(jvUnitBar.SelectedTab.Data);

    if pFile.SynUnit.Modified then
      NotifyModified := True;

    if pFile.SynUnit.Modified <> jvUnitBar.SelectedTab.Modified then
    begin
      if pFile.SynUnit.Modified then
      begin
        pFile.HasChanged := True;
        jvUnitBar.SelectedTab.Modified := True;
        jvUnitBar.SelectedTab.Caption := jvUnitBar.SelectedTab.Caption + '*';
        stbMain.Panels[3].Text := 'Modified';
        jvUnitBar.Repaint;
      end
      else
      begin
        pFile.HasChanged := False;
        stbMain.Panels[3].Text := '';
        jvUnitBar.SelectedTab.Modified := False;
        jvUnitBar.SelectedTab.Caption := Copy(jvUnitBar.SelectedTab.Caption, 1, Length(jvUnitBar.SelectedTab.Caption) - 1);
      end;
    end;

    if pFile.IsReadOnly then
      stbMain.Panels[4].Text := 'Read Only'
    else
      stbMain.Panels[4].Text := '';

    // Reset line painting variables and other stuff
    if pFile.FileType in LuaEditDebugFilesTypeSet then
    begin
      TLuaEditDebugFile(pFile).DebugInfos.iLineError := -1;
      TLuaEditDebugFile(pFile).DebugInfos.iStackMarker := -1;
      TLuaEditDebugFile(pFile).PrevLineNumber := pFile.SynUnit.Lines.Count;
      HasChangedWhileCompiled := True;
    end;

    stbMain.Panels[5].Text := '';
    pFile.LastEditedLine := pFile.SynUnit.CaretY;
    pFile.synUnit.Refresh;
    frmProjectTree.vstProjectTree.Refresh;
    CheckButtons();
  end;
end;

procedure TfrmLuaEditMain.synEditDblClick(Sender: TObject);
const
  OpeningBrackets: set of char = ['(', '[', '{', '<', '"'];
  ClosingBrackets: set of char = [')', ']', '}', '>', '"'];
var
  pLuaUnit: TLuaEditUnit;
  pCoord: TBufferCoord;
begin
  if Assigned(jvUnitBar.SelectedTab.Data) then
  begin
    // Get current unit and find matching bracket
    pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

    if pLuaUnit.synUnit.Text <> '' then
    begin
      if pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1] <> '' then
      begin
        // Towards left
        if pLuaUnit.synUnit.CaretX > 1 then
        begin
          if pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1][pLuaUnit.synUnit.CaretX - 1] in OpeningBrackets then
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
        
        // Towards right
        if pLuaUnit.synUnit.CaretX < Length(pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1]) then
        begin
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
          else if pLuaUnit.synUnit.Lines[pLuaUnit.synUnit.CaretY - 1][pLuaUnit.synUnit.CaretX] in ClosingBrackets then
          begin
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
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.synEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  pLuaUnit: TLuaEditUnit;
begin
  // Only if left button is down (in other words... when selecting)
  if ssLeft	in Shift then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      // Get currently opened unit
      pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

      // Set square selection mode if Alt key is held down
      if ssAlt in Shift then
        pLuaUnit.synUnit.SelectionMode := smColumn
      else
        pLuaUnit.synUnit.SelectionMode := smNormal;
    end;
  end;
end;

function TfrmLuaEditMain.DoAddToPrjExecute(FilePathToAdd: String): Boolean;
var
  x, NewUnit: integer;
  pFile: TLuaEditBasicTextFile;
  FoundMatch: Boolean;
  Name, Ext: String;
begin
  if FilePathToAdd = '' then
    Result := (frmAddToPrj.ShowModal = mrOk)
  else
    Result := True;

  if Result then
  begin
    if FilePathToAdd <> '' then
    begin
      TLuaEditBasicTextFile(AddFileInProject(FilePathToAdd, False, ActiveProject)).IsLoaded := True;
      ActiveProject.HasChanged := True;
    end
    else
    begin
      if frmAddToPrj.chkExisting.Checked then
      begin
        for x := 0 to frmAddToPrj.lstFiles.Count - 1 do
        begin
          TLuaEditBasicTextFile(AddFileInProject(frmAddToPrj.lstFiles.Strings[x], False, ActiveProject)).IsLoaded := True;
          ActiveProject.HasChanged := True;
        end;
      end
      else
      begin
        NewUnit := 1;

        if frmAddToPrj.chkNewUnit.Checked = True then
        begin
          Name := 'Unit';
          Ext := '.lua';
        end
        else if frmAddToPrj.chkNewMacro.Checked = True then
        begin
          Name := 'Macro';
          Ext := '.lmc';
        end
        else if frmAddToPrj.chkNewTextFile.Checked = True then
        begin
          Name := 'Text';
          Ext := '.txt';
        end;

        for x := 0 to LuaOpenedFiles.Count - 1 do
        begin
          if TLuaEditUnit(LuaOpenedFiles.Items[x]).IsNew then
            Inc(NewUnit);
        end;

        FoundMatch := True;
  
        while FoundMatch do
        begin
          FoundMatch := False;
          for x := 0 to LuaOpenedFiles.Count - 1 do
          begin
            if 'Unit'+IntToStr(NewUnit)+'.lua' = TLuaEditUnit(LuaOpenedFiles.Items[x]).Name then
            begin
              Inc(NewUnit);
              FoundMatch := True;
            end;
          end;
        end;

        pFile := TLuaEditBasicTextFile(AddFileInProject('Unit'+IntToStr(NewUnit)+'.lua', True, ActiveProject));
        pFile.IsLoaded := True;
        AddFileInTab(pFile);
        ActiveProject.HasChanged := True;
      end;
    end;
  end;

  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmLuaEditMain.actAddToPrjExecute(Sender: TObject);
begin
  DoAddToPrjExecute();
end;

function TfrmLuaEditMain.DoRemoveFromPrjExecute(pFileToRemove: TLuaEditFile): Boolean;
var
  pFile: TLuaEditFile;
begin
  Result := False;
  frmRemoveFile.FillCombo(ActiveProject);

  if Assigned(pFileToRemove) then
  begin
    if frmRemoveFile.ShowModal = mrOk then
      pFile := TLuaEditFile(frmRemoveFile.cboUnit.Items.Objects[frmRemoveFile.cboUnit.ItemIndex]);
  end
  else
    pFile := pFileToRemove;

  if Assigned(pFile) then
  begin
    if ((pFile.HasChanged) or (pFile.IsNew)) then
    begin
      if Application.MessageBox(PChar('Save changes to file "'+pFile.Path+'"?'), 'LuaEdit', MB_ICONQUESTION+MB_YESNO) = IDYES then
      begin
        if SaveUnitsInc then
          TLuaEditBasicTextFile(pFile).SaveInc(pFile.Path)
        else
          TLuaEditBasicTextFile(pFile).Save(pFile.Path);
      end;
    end;

    if LuaOpenedFiles.IndexOf(pFile) <> -1 then
    begin
      if Assigned(TLuaEditBasicTextFile(pFile).AssociatedTab) then
        TLuaEditBasicTextFile(pFile).AssociatedTab.Free;

      LuaOpenedFiles.Remove(pFile);
      Result := True;
    end;

    ActiveProject.lstUnits.Remove(pFile);
    pFile.Free;
    ActiveProject.HasChanged := True;
    frmProjectTree.BuildProjectTree;
  end;
end;

procedure TfrmLuaEditMain.actRemoveFromPrjExecute(Sender: TObject);
begin
  DoRemoveFromPrjExecute;
end;

procedure TfrmLuaEditMain.Project1Click(Sender: TObject);
begin
  CheckButtons;
end;

function TfrmLuaEditMain.GetBaseCompletionProposal: TSynCompletionProposal;
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
  pNewCompletionProposal.ActivateCompletion;
  Result := pNewCompletionProposal;
end;

function TfrmLuaEditMain.GetBaseParamsProposal: TSynCompletionProposal;
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
  pNewCompletionProposal.ActivateCompletion;
  Result := pNewCompletionProposal;
end;

procedure TfrmLuaEditMain.synCompletionExecute(Kind: SynCompletionType; Sender: TObject; var CurrentInput: String; var x, y: Integer; var CanExecute: Boolean);
var
  pLuaUnit: TLuaEditUnit;
  pFctInfo: TFctInfo;
  hFileSearch: TSearchRec;
  GotTable: Boolean;
  sPath, sTemp, sFormatString, sFunctionName, sNestedTable: String;
  sTable, sParameters, LineType, Lookup, LookupTable: String;
  lstLocalTable, sFileContent: TStringList;
  i, j, Index: Integer;
begin
  // Initialize stuff before going
  lstLocalTable := TStringList.Create;
  pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);
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
    // Standarize the path
    sPath := LibrariesSearchPaths.Strings[i];
    
    if Copy(sPath, Length(sPath), 1) <> '\' then
      sPath := sPath + '\';

    // Begin file search
    if FindFirst(sPath+'*.lib', faAnyFile, hFileSearch) = 0 then
    begin
      repeat
        // Create and initialize temporary content container
        sFileContent := TStringList.Create;
        sFileContent.LoadFromFile(sPath+hFileSearch.Name);

        // Parse content and add it to the lookup list
        for j := 0 to sFileContent.Count - 1 do
        begin
          // Extract line type
          LineType := UpperCase(Copy(sFileContent.Strings[j], Length(sFileContent.Strings[j]) - 2, 3));
          sTemp := Copy(sFileContent.Strings[j], 1, Length(sFileContent.Strings[j]) - 4);

          // Format line according to type
          if LineType = 'FOO' then
            sFormatString := '\color{clBlue}function\color{clBlack}   \column{}\style{+B}'
          else if LineType = 'GBL' then
            sFormatString := '\color{clMaroon}global var\color{clBlack} \column{}\style{+B}'
          else if LineType = 'LCL' then
            sFormatString := '\color{clMaroon}local var\color{clBlack}  \column{}\style{+B}'
          else if LineType = 'LIB' then
            sFormatString := '\color{clGreen}library\color{clBlack}       \column{}\style{+B}';

          // Initialize variable before starting
          sParameters := '';
          sFunctionName := '';
          sTable := '';
          sNestedTable := '';

          // Determine if a table is to retreive
          while ((Pos('.', sTemp) <> 0) and ((LineType = 'LCL') or (LineType = 'GBL') or (((Pos('(', sTemp) <> 0) and (Pos('.', sTemp) < Pos('(', sTemp)))))) do
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
            sParameters := Copy(sTemp, Pos('(', sTemp) + 1, Pos(')', sTemp) - Pos('(', sTemp) - 1);

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
  frmFunctionList.RefreshList(pLuaUnit.Path);

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

procedure TfrmLuaEditMain.synParamsExecute(Kind: SynCompletionType; Sender: TObject; var AString: String; var x, y: Integer; var CanExecute: Boolean);
var
  locline, lookup, sProposition: String;
  sPath, sFunctionName, sParameters: String;
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
        // Standarize the path
        sPath := LibrariesSearchPaths.Strings[i];

        if Copy(sPath, Length(sPath), 1) <> '\' then
          sPath := sPath +'\';
        
        // Begin file search
        if FindFirst(sPath +'*.lib', faAnyFile, hFileSearch) = 0 then
        begin
          repeat
            // Create and initialize temporary content container
            sFileContent := TStringList.Create;
            sFileContent.LoadFromFile(sPath+hFileSearch.Name);

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
procedure TfrmLuaEditMain.FillLookUpList;
var
  pFctInfo: TFctInfo;
  sSearchPath: String;
  hFileSearch: TSearchRec;
  sFileContent: TStringList;
  x, y: Integer;
begin
  // Initialize stuff before starting
  LookupList.Clear;

  // Go through all libraries search paths
  for x := 0 to LibrariesSearchPaths.Count - 1 do
  begin
    sSearchPath := LibrariesSearchPaths.Strings[x];
    if sSearchPath[Length(sSearchPath)] <> '\' then
      sSearchPath := sSearchPath + '\';

    // Begin file search
    if FindFirst(sSearchPath+'*.lib', faAnyFile, hFileSearch) = 0 then
    begin
      repeat
        // Create and initialize temporary content container
        sFileContent := TStringList.Create;
        sFileContent.LoadFromFile(sSearchPath+hFileSearch.Name);

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

function TfrmLuaEditMain.DoEditorSettingsExecute(): Boolean;
begin
  Result := (frmEditorSettings.ShowModal = mrOk);
end;

procedure TfrmLuaEditMain.actEditorSettingsExecute(Sender: TObject);
begin
  DoEditorSettingsExecute;
end;

function TfrmLuaEditMain.DoMacroManagerExecute(): Boolean;
begin
  Result := (frmMacroManager.ShowModal = mrOk);
  BuildMacroList();
end;

procedure TfrmLuaEditMain.actMacroManagerExecute(Sender: TObject);
begin
  DoMacroManagerExecute();
end;

// New function wich loads the settings from the registry
procedure TfrmLuaEditMain.LoadEditorSettingsFromReg;
var
  pReg: TAdvanceRegistry;
begin
  pReg := TAdvanceRegistry.Create();

  // Reading print Settings
  pReg.OpenKey('\Software\LuaEdit\PrintSetup', True);
  PrintUseColor := pReg.ReadBool('UseColors', True);
  PrintUseSyntax := pReg.ReadBool('UseSyntax', True);
  PrintUseWrapLines := pReg.ReadBool('UseWrapLines', True);
  PrintLineNumbers := pReg.ReadBool('LineNumbers', False);
  PrintLineNumbersInMargin := pReg.ReadBool('LineNumbersInMargin', False);

  //Reading general settings
  pReg.OpenKey('\Software\LuaEdit\EditorSettings\General', True);
  EditorOptions := [eoScrollPastEol, eoEnhanceHomeKey, eoTabIndent, eoHideShowScrollbars, eoScrollPastEof, eoAutoIndent];
  EditorOptions := TSynEditorOptions(pReg.ReadInteger('EditorOptions', Integer(EditorOptions)));

  // Remove all options we absolutly don't want to have to make sure we don't have them!
  EditorOptions := EditorOptions - [eoShowSpecialChars, eoSpecialLineDefaultFg, eoNoSelection, eoDisableScrollArrows, eoDropFiles, eoNoCaret];

  UndoLimit := pReg.ReadInteger('UndoLimit', 1000);
  TabWidth := pReg.ReadInteger('TabWidth', 4);
  AssociateFiles := pReg.ReadBool('AssociateFiles', False);
  SaveBreakpoints := pReg.ReadBool('SaveBreakpoints', True);
  SaveUnitsInc := pReg.ReadBool('SaveUnitsInc', False);
  SaveProjectsInc := pReg.ReadBool('SaveProjectsInc', False);
  ShowExSaveDlg := pReg.ReadBool('ShowExSaveDlg', True);
  KeepSIFWindowOpened := pReg.ReadBool('KeepSIFWindowOpened', True);
  AnimatedTabsSpeed := pReg.ReadInteger('AnimatedTabsSpeed', 1000);
  jvDockVSNet.ChannelOption.HideHoldTime := AnimatedTabsSpeed;
  ShowStatusBar := pReg.ReadBool('ShowStatusBar', True);
  stbMain.Visible := ShowStatusBar;
  HomePage := pReg.ReadString('HomePage', 'http://www.luaedit.net');
  SearchPage := pReg.ReadString('SearchPage', 'http://www.google.com');
  TempFolder := pReg.ReadString('TempFolder', GetLuaEditInstallPath() + '\Temp');
  HistoryMaxAge := pReg.ReadInteger('HistoryMaxAge', 10);

  // Loading debugger settings
  pReg.OpenKey('\Software\LuaEdit\EditorSettings\Debugger', True);
  MaxTablesSize := pReg.ReadInteger('MaxTablesSize', PRINT_SIZE);
  MaxSubTablesLevel := pReg.ReadInteger('MaxSubTablesLevel', SUB_TABLE_MAX);
  CheckCyclicReferencing := pReg.ReadBool('CheckCyclicReferencing', True);
  AutoLoadLibBasic := pReg.ReadBool('AutoLoadLibBasic', True);
  AutoLoadLibPackage := pReg.ReadBool('AutoLoadLibPackage', True);
  AutoLoadLibTable := pReg.ReadBool('AutoLoadLibTable', True);
  AutoLoadLibString := pReg.ReadBool('AutoLoadLibString', True);
  AutoLoadLibMath := pReg.ReadBool('AutoLoadLibMath', True);
  AutoLoadLibOSIO := pReg.ReadBool('AutoLoadLibOSIO', True);
  AutoLoadLibDebug := pReg.ReadBool('AutoLoadLibDebug', True);
  ShowStackTraceOnError := pReg.ReadBool('ShowStackTraceOnError', True);

  // Reading Environment settings
  pReg.OpenKey('\Software\LuaEdit\EditorSettings\Environment', True);
  LibrariesSearchPaths.DelimitedText := pReg.ReadString('LibrariesSearchPaths', '"' + GetLuaEditInstallPath() + '\Libraries"');

  //Reading display settings
  pReg.OpenKey('\Software\LuaEdit\EditorSettings\Display', True);
  ShowGutter := pReg.ReadBool('ShowGutter', True);
  ShowLineNumbers := pReg.ReadBool('ShowLineNumbers', False);
  LeadingZeros := pReg.ReadBool('LeadingZeros', False);
  GutterWidth := pReg.ReadInteger('GutterWidth', 30);
  GutterColor := pReg.ReadString('GutterColor', 'clBtnFace');
  FontName := pReg.ReadString('FontName', 'Courier');
  FontSize := pReg.ReadInteger('FontSize', 10);
  ColorSet := pReg.ReadString('ColorSet', 'LuaEdit (TM)');

  pReg.Free;
  GetColorSet(ColorSet);

  // Initializing settings
  frmEditorSettings.LoadEditorSettings();
end;

procedure TfrmLuaEditMain.GetColorSet(sColorSet: String);
var
  pColorSet: TIniFile;
  pEditorColor: TEditorColors;
  x: Integer;
begin
  pColorSet := TIniFile.Create(GetLuaEditInstallPath()+'\Data\' + sColorSet + '.dat');
  for x := EditorColors.Count - 1 downto 0 do
  begin
    pEditorColor := TEditorColors(EditorColors.Items[x]);
    EditorColors.Remove(pEditorColor);
    pEditorColor.Free;
  end;

  //Background
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[0]).Background := pColorSet.ReadString('Background', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[0]).Foreground := pColorSet.ReadString('Foreground', 'ForegroundColor', 'clWhite');

  //Comment
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[1]).Background := pColorSet.ReadString('Comment', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[1]).Foreground := pColorSet.ReadString('Comment', 'ForegroundColor', 'clGreen');
  TEditorColors(EditorColors.Items[1]).IsBold := pColorSet.ReadBool('Comment', 'IsBold', False);
  TEditorColors(EditorColors.Items[1]).IsItalic := pColorSet.ReadBool('Comment', 'IsItalic', False);
  TEditorColors(EditorColors.Items[1]).IsUnderline := pColorSet.ReadBool('Comment', 'IsUnderline', False);

  //Error line
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[2]).Background := pColorSet.ReadString('Error Line', 'BackgroundColor', 'clRed');
  TEditorColors(EditorColors.Items[2]).Foreground := pColorSet.ReadString('Error Line', 'ForegroundColor', 'clWhite');

  //Execution line
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[3]).Background := pColorSet.ReadString('Execution Line', 'BackgroundColor', 'clBlue');
  TEditorColors(EditorColors.Items[3]).Foreground := pColorSet.ReadString('Execution Line', 'ForegroundColor', 'clWhite');

  //Identifiers
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[4]).Background := pColorSet.ReadString('Identifier', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[4]).Foreground := pColorSet.ReadString('Identifier', 'ForegroundColor', 'clBlack');
  TEditorColors(EditorColors.Items[4]).IsBold := pColorSet.ReadBool('Identifier', 'IsBold', False);
  TEditorColors(EditorColors.Items[4]).IsItalic := pColorSet.ReadBool('Identifier', 'IsItalic', False);
  TEditorColors(EditorColors.Items[4]).IsUnderline := pColorSet.ReadBool('Identifier', 'IsUnderline', False);

  //Numbers
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[5]).Background := pColorSet.ReadString('Numbers', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[5]).Foreground := pColorSet.ReadString('Numbers', 'ForegroundColor', 'clBlue');
  TEditorColors(EditorColors.Items[5]).IsBold := pColorSet.ReadBool('Numbers', 'IsBold', False);
  TEditorColors(EditorColors.Items[5]).IsItalic := pColorSet.ReadBool('Numbers', 'IsItalic', False);
  TEditorColors(EditorColors.Items[5]).IsUnderline := pColorSet.ReadBool('Numbers', 'IsUnderline', False);

  //Reserved words
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[6]).Background := pColorSet.ReadString('Reserved Words', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[6]).Foreground := pColorSet.ReadString('Reserved Words', 'ForegroundColor', 'clBlue');
  TEditorColors(EditorColors.Items[6]).IsBold := pColorSet.ReadBool('Reserved Words', 'IsBold', False);
  TEditorColors(EditorColors.Items[6]).IsItalic := pColorSet.ReadBool('Reserved Words', 'IsItalic', False);
  TEditorColors(EditorColors.Items[6]).IsUnderline := pColorSet.ReadBool('Reserved Words', 'IsUnderline', False);

  //Selection
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[7]).Background := pColorSet.ReadString('Selection', 'BackgroundColor', 'clHighlight');
  TEditorColors(EditorColors.Items[7]).Foreground := pColorSet.ReadString('Selection', 'ForegroundColor', 'clBlack');

  //Strings
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[8]).Background := pColorSet.ReadString('Strings', 'BackgroundColor', 'clWhite');
  TEditorColors(EditorColors.Items[8]).Foreground := pColorSet.ReadString('Strings', 'ForegroundColor', 'clBlack');
  TEditorColors(EditorColors.Items[8]).IsBold := pColorSet.ReadBool('Strings', 'IsBold', False);
  TEditorColors(EditorColors.Items[8]).IsItalic := pColorSet.ReadBool('Strings', 'IsItalic', False);
  TEditorColors(EditorColors.Items[8]).IsUnderline := pColorSet.ReadBool('Strings', 'IsUnderline', False);

  //Breakpoints
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[9]).Background := pColorSet.ReadString('Valid Breakpoint', 'BackgroundColor', 'clMaroon');
  TEditorColors(EditorColors.Items[9]).Foreground := pColorSet.ReadString('Valid Breakpoint', 'ForegroundColor', 'clWhite');

  pColorSet.Free;
end;

// Old function wich loads the settings from luaedit.ini file
// (still there for backward compatibility)
procedure TfrmLuaEditMain.LoadEditorSettingsFromIni;
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
  KeepSIFWindowOpened := pIniFile.ReadBool('General', 'KeepSIFWindowOpened', True);

  // Reading Environment settings
  LibrariesSearchPaths.DelimitedText := pIniFile.ReadString('Environement', 'LibrariesSearchPaths', ExtractFilePath(Application.ExeName)+'Libraries');

  //Reading display settings
  ShowGutter := pIniFile.ReadBool('Display', 'ShowGutter', True);
  ShowLineNumbers := pIniFile.ReadBool('Display', 'ShowLineNumbers', False);
  LeadingZeros := pIniFile.ReadBool('Display', 'LeadingZeros', False);
  GutterWidth := pIniFile.ReadInteger('Display', 'GutterWidth', 30);
  GutterColor := pIniFile.ReadString('Display', 'GutterColor', 'clBtnFace');
  FontName := pIniFile.ReadString('Display', 'FontName', 'Courier');
  FontSize := pIniFile.ReadInteger('Display', 'FontSize', 10);
  ColorSet := pIniFile.ReadString('Display', 'ColorSet', 'LuaEdit (TM)');

  pIniFile.Free;
  pIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\LuaEdit.dat');

  //Background
  EditorColors.Add(TEditorColors.Create);
  TEditorColors(EditorColors.Items[0]).Background := pIniFile.ReadString('Background', 'BackgroundColor', 'clWhite');

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

procedure TfrmLuaEditMain.ApplyValuesToEditor(SynTemp: TSynEdit; lstColorSheme: TList);
var
  x: Integer;
  TempStyle: TFontStyles;
begin
  SynTemp.Options := EditorOptions;
  SynTemp.TabWidth := TabWidth;
  SynTemp.MaxUndo := UndoLimit;
  SynTemp.Gutter.Visible := ShowGutter;
  SynTemp.Gutter.LeadingZeros := LeadingZeros;
  SynTemp.Gutter.ShowLineNumbers := ShowLineNumbers;
  SynTemp.Gutter.Width := GutterWidth;
  SynTemp.Gutter.Color := StringToColor(GutterColor);
  SynTemp.Font.Name := FontName;
  SynTemp.Font.Size := FontSize;
  SynTemp.Color := StringToColor(TEditorColors(lstColorSheme.Items[0]).Background);
  SynTemp.SelectedColor.Foreground := StringToColor(TEditorColors(lstColorSheme.Items[7]).Foreground);
  SynTemp.SelectedColor.Background := StringToColor(TEditorColors(lstColorSheme.Items[7]).Background);
  frmLuaEditMain.stbMain.Visible := ShowStatusBar;

  if Assigned(SynTemp.Highlighter) then
  begin
    for x := 0 to SynTemp.Highlighter.AttrCount - 1 do
    begin
      TempStyle := [];

      if synTemp.Highlighter.Attribute[x].Name = 'Comment' then
      begin
        SynTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[1]).Background);
        SynTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[1]).Foreground);

        if TEditorColors(lstColorSheme.Items[1]).IsBold then
          TempStyle := TempStyle + [fsBold];

        if TEditorColors(lstColorSheme.Items[1]).IsItalic then
          TempStyle := TempStyle + [fsItalic];

        if TEditorColors(lstColorSheme.Items[1]).IsUnderline then
          TempStyle := TempStyle + [fsUnderline];

        SynTemp.Highlighter.Attribute[x].Style := TempStyle;
      end
      else if synTemp.Highlighter.Attribute[x].Name = 'Identifier' then
      begin
        SynTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[4]).Background);
        SynTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[4]).Foreground);

        if TEditorColors(lstColorSheme.Items[4]).IsBold then
          TempStyle := TempStyle + [fsBold];

        if TEditorColors(lstColorSheme.Items[4]).IsItalic then
          TempStyle := TempStyle + [fsItalic];

        if TEditorColors(lstColorSheme.Items[4]).IsUnderline then
          TempStyle := TempStyle + [fsUnderline];

        SynTemp.Highlighter.Attribute[x].Style := TempStyle;
      end
      else if synTemp.Highlighter.Attribute[x].Name = 'Reserved Word' then
      begin
        SynTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[6]).Background);
        SynTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[6]).Foreground);

        if TEditorColors(lstColorSheme.Items[6]).IsBold then
          TempStyle := TempStyle + [fsBold];

        if TEditorColors(lstColorSheme.Items[6]).IsItalic then
          TempStyle := TempStyle + [fsItalic];

        if TEditorColors(lstColorSheme.Items[6]).IsUnderline then
          TempStyle := TempStyle + [fsUnderline];

        SynTemp.Highlighter.Attribute[x].Style := TempStyle;
      end
      else if ((synTemp.Highlighter.Attribute[x].Name = 'String') or (synTemp.Highlighter.Attribute[x].Name = 'LuaMString')) then
      begin
        SynTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[8]).Background);
        SynTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[8]).Foreground);

        if TEditorColors(lstColorSheme.Items[8]).IsBold then
          TempStyle := TempStyle + [fsBold];

        if TEditorColors(lstColorSheme.Items[8]).IsItalic then
          TempStyle := TempStyle + [fsItalic];

        if TEditorColors(lstColorSheme.Items[8]).IsUnderline then
          TempStyle := TempStyle + [fsUnderline];

        SynTemp.Highlighter.Attribute[x].Style := TempStyle;
      end
      else if synTemp.Highlighter.Attribute[x].Name = 'Numbers' then
      begin
        SynTemp.Highlighter.Attribute[x].Background := StringtoColor(TEditorColors(lstColorSheme.Items[5]).Background);
        SynTemp.Highlighter.Attribute[x].Foreground := StringToColor(TEditorColors(lstColorSheme.Items[5]).Foreground);

        if TEditorColors(lstColorSheme.Items[5]).IsBold then
          TempStyle := TempStyle + [fsBold];

        if TEditorColors(lstColorSheme.Items[5]).IsItalic then
          TempStyle := TempStyle + [fsItalic];

        if TEditorColors(lstColorSheme.Items[5]).IsUnderline then
          TempStyle := TempStyle + [fsUnderline];

        SynTemp.Highlighter.Attribute[x].Style := TempStyle;
      end;
    end;
  end
  else
  begin
    SynTemp.Font.Color := StringToColor(TEditorColors(lstColorSheme.Items[4]).Foreground);
  end;

  synTemp.Refresh;
end;

procedure TfrmLuaEditMain.GotoBookmarkClick(Sender: TObject);
var
  iBookmark: Integer;
begin
  iBookmark := TMenuItem(Sender).Tag;

  if iBookmark = 1 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker1, #0, nil);
  end
  else if iBookmark = 2 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker2, #0, nil);
  end
  else if iBookmark = 3 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker3, #0, nil);
  end
  else if iBookmark = 4 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker4, #0, nil);
  end
  else if iBookmark = 5 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker5, #0, nil);
  end
  else if iBookmark = 6 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker6, #0, nil);
  end
  else if iBookmark = 7 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker7, #0, nil);
  end
  else if iBookmark = 8 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker8, #0, nil);
  end
  else if iBookmark = 9 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker9, #0, nil);
  end
  else if iBookmark = 0 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecGotoMarker0, #0, nil);
  end;
end;

procedure TfrmLuaEditMain.ToggleBookmarkClick(Sender: TObject);
var
  iBookmark: Integer;
begin
  iBookmark := TMenuItem(Sender).Tag;

  if iBookmark = 1 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker1, #0, nil);
  end
  else if iBookmark = 2 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker2, #0, nil);
  end
  else if iBookmark = 3 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker3, #0, nil);
  end
  else if iBookmark = 4 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker4, #0, nil);
  end
  else if iBookmark = 5 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker5, #0, nil);
  end
  else if iBookmark = 6 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker6, #0, nil);
  end
  else if iBookmark = 7 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker7, #0, nil);
  end
  else if iBookmark = 8 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker8, #0, nil);
  end
  else if iBookmark = 9 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker9, #0, nil);
  end
  else if iBookmark = 0 then
  begin
    TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecSetMarker0, #0, nil);
  end;
end;

procedure TfrmLuaEditMain.RegistryEditor1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', 'regedit', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmLuaEditMain.Calculator1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', 'calc', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmLuaEditMain.Conversions1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(ExtractFilePath(Application.ExeName) + '\Convert.exe'), nil, nil,  SW_SHOWNORMAL);
end;

function TfrmLuaEditMain.DoBlockUnindentExecute(): Boolean;
begin
  Result := True;
  TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecBlockUnindent, #0, nil);
end;

procedure TfrmLuaEditMain.actBlockUnindentExecute(Sender: TObject);
begin
  DoBlockUnindentExecute;
end;

function TfrmLuaEditMain.DoBlockIndentExecute(): Boolean;
begin
  Result := True;
  TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.ExecuteCommand(ecBlockIndent, #0, nil);
end;

procedure TfrmLuaEditMain.actBlockIndentExecute(Sender: TObject);
begin
  DoBlockIndentExecute;
end;

function TfrmLuaEditMain.DoBlockCommentExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
  x, SelStart, SelEnd, AddedChars: Integer;
  UndoStart, UndoEnd: TBufferCoord;
begin
  Result := False;
  pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

  // Retrieve selection
  SelStart := pLuaUnit.synUnit.SelStart;
  SelEnd := pLuaUnit.synUnit.SelEnd;
  pLuaUnit.synUnit.BeginUndoBlock;
  AddedChars := 0;

  for x := pLuaUnit.synUnit.BlockBegin.Line - 1 to pLuaUnit.synUnit.BlockEnd.Line - 1 do
  begin
    Result := True;

    // Commenting line
    pLuaUnit.synUnit.Lines.Strings[x] := '--' + pLuaUnit.synUnit.Lines.Strings[x];
    pLuaUnit.synUnit.Modified := True;
    pLuaUnit.synUnit.OnChange(pLuaUnit.synUnit);
    AddedChars := AddedChars + 2;

    // Notify change to synedit's undo list
    UndoStart.Char := 1;
    UndoStart.Line := x+1;
    UndoEnd.Char := 3;
    UndoEnd.Line := x+1;
    pLuaUnit.synUnit.UndoList.AddChange(crInsert, UndoStart, UndoEnd, '', smNormal);
  end;

  // Reset selection
  if Result then
  begin
    pLuaUnit.synUnit.SelStart := SelStart;
    pLuaUnit.synUnit.SelEnd := SelEnd + AddedChars;
  end;

  pLuaUnit.synUnit.EndUndoBlock;
end;

procedure TfrmLuaEditMain.actBlockCommentExecute(Sender: TObject);
begin
  DoBlockCommentExecute;
end;

function TfrmLuaEditMain.DoBlockUncommentExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
  x, SelStart, SelEnd, RemovedChars: Integer;
  UndoStart, UndoEnd: TBufferCoord;
begin
  Result := False;
  pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

  // Retrieve selection
  SelStart := pLuaUnit.synUnit.SelStart;
  SelEnd := pLuaUnit.synUnit.SelEnd;
  pLuaUnit.synUnit.BeginUndoBlock;
  RemovedChars := 0;

  for x := pLuaUnit.synUnit.BlockBegin.Line - 1 to pLuaUnit.synUnit.BlockEnd.Line - 1 do
  begin
    if Copy(pLuaUnit.synUnit.Lines.Strings[x], 1, 2) = '--' then
    begin
      Result := True;

      // Uncommenting line
      pLuaUnit.synUnit.Lines.Strings[x] := Copy(pLuaUnit.synUnit.Lines.Strings[x], 3, Length(pLuaUnit.synUnit.Lines.Strings[x]) - 2);
      pLuaUnit.synUnit.Modified := True;
      pLuaUnit.synUnit.OnChange(pLuaUnit.synUnit);
      RemovedChars := RemovedChars + 2;

      // Notify change to synedit's undo list
      UndoStart.Char := 1;
      UndoStart.Line := x+1;
      UndoEnd.Char := 3;
      UndoEnd.Line := x+1;
      pLuaUnit.synUnit.UndoList.AddChange(crDelete, UndoStart, UndoEnd, '--', smNormal);
    end;
  end;

  // Reset selection
  if Result then
  begin
    pLuaUnit.synUnit.SelStart := SelStart;
    pLuaUnit.synUnit.SelEnd := SelEnd - RemovedChars;
  end;

  pLuaUnit.synUnit.EndUndoBlock;
end;

procedure TfrmLuaEditMain.actBlockUncommentExecute(Sender: TObject);
begin
  DoBlockUncommentExecute;
end;

function TfrmLuaEditMain.DoUpperCaseExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
  SelStart, SelLength: Integer;
begin
  Result := False;

  if Assigned(jvUnitBar.SelectedTab) then
  begin
    pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

    if pLuaUnit.synUnit.SelText <> '' then
    begin
      Result := True;
      SelStart := pLuaUnit.synUnit.SelStart;
      SelLength := pLuaUnit.synUnit.SelLength;
      pLuaUnit.synUnit.SelText := UpperCase(pLuaUnit.synUnit.SelText);
      pLuaUnit.synUnit.SelStart := SelStart;
      pLuaUnit.synUnit.SelLength := SelLength;
    end;
  end;
end;
procedure TfrmLuaEditMain.actUpperCaseExecute(Sender: TObject);
begin
  DoUpperCaseExecute;
end;

function TfrmLuaEditMain.DoLowerCaseExecute(): Boolean;
var
  pLuaUnit: TLuaEditUnit;
  SelStart, SelLength: Integer;
begin
  Result := False;

  if Assigned(jvUnitBar.SelectedTab) then
  begin
    pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

    if pLuaUnit.synUnit.SelText <> '' then
    begin
      Result := True;
      SelStart := pLuaUnit.synUnit.SelStart;
      SelLength := pLuaUnit.synUnit.SelLength;
      pLuaUnit.synUnit.SelText := LowerCase(pLuaUnit.synUnit.SelText);
      pLuaUnit.synUnit.SelStart := SelStart;
      pLuaUnit.synUnit.SelLength := SelLength;
    end;
  end;
end;

procedure TfrmLuaEditMain.actLowerCaseExecute(Sender: TObject);
begin
  DoLowerCaseExecute;
end;

function TfrmLuaEditMain.DoPrjSettingsExecute(): Boolean;
begin
  frmPrjOptions.GetLuaProjectOptions(ActiveProject);
  Result := (frmPrjOptions.ShowModal = mrOk);
  if Result then
  begin
    frmPrjOptions.SetLuaProjectOptions(ActiveProject);
    ActiveProject.HasChanged := True;
    frmProjectTree.BuildProjectTree;
  end;
end;

procedure TfrmLuaEditMain.actPrjSettingsExecute(Sender: TObject);
begin
  DoPrjSettingsExecute;
end;

function TfrmLuaEditMain.DoActiveSelPrjExecute(): Boolean;
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  Result := False;
  
  // Retreive selected node if any
  pNode := frmProjectTree.vstProjectTree.GetFirstSelected;

  if Assigned(pNode) then
  begin
    // Retreive data from the selected node
    pData := frmProjectTree.vstProjectTree.GetNodeData(pNode);

    // Assign selected to the currently active project
    if pData.pLuaEditFile.FileType = otLuaEditProject then
    begin
      Result := True;
      ActiveProject := TLuaEditProject(pData.pLuaEditFile);
      frmProjectTree.BuildProjectTree;
    end;
  end;
end;

procedure TfrmLuaEditMain.actActiveSelPrjExecute(Sender: TObject);
begin
  DoActiveSelPrjExecute;
end;

function TfrmLuaEditMain.ExecuteInitializer(sInitializer: String; L: PLua_State): Integer;
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

procedure TfrmLuaEditMain.RefreshOpenedUnits;
var
  x: Integer;
begin
  for x := 0 to LuaOpenedFiles.Count - 1 do
  begin
    if not TLuaEditUnit(LuaOpenedFiles.Items[x]).HasChanged then
    begin
      jvUnitBar.Tabs[x].Caption := TLuaEditUnit(jvUnitBar.Tabs[x].Data).Name;
      jvUnitBar.Tabs[x].Modified := False;
    end
    else
    begin
      jvUnitBar.Tabs[x].Modified := True;
    end;
  end;
end;

function TfrmLuaEditMain.FileIsInTree(sFileName: String): PVirtualNode;
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  // Initialize stuff before going
  Result := nil;
  pNode := frmProjectTree.vstProjectTree.GetFirst;

  while pNode <> nil do
  begin
    // Retreive data from current node
    pData := frmProjectTree.vstProjectTree.GetNodeData(pNode);
    
    if pData.pLuaEditFile.FileType in LuaEditTextFilesTypeSet then
    begin
      if pData.pLuaEditFile.PrjOwner.Name = '[@@SingleUnits@@]' then
      begin
        if pData.pLuaEditFile.Path = sFileName then
        begin
          if LuaOpenedFiles.IndexOf(pData.pLuaEditFile) <> -1 then
            jvUnitBar.SelectedTab := TLuaEditBasicTextFile(pData.pLuaEditFile).AssociatedTab
          else
            AddFileInTab(TLuaEditBasicTextFile(pData.pLuaEditFile));

          Result := pNode;
          Break;
        end;
      end;
    end;

    pNode := frmProjectTree.vstProjectTree.GetNext(pNode);
  end;
end;

procedure TfrmLuaEditMain.ErrorLookup1Click(Sender: TObject);
begin
  frmErrorLookup.Show;
end;

procedure TfrmLuaEditMain.PrintSetup1Click(Sender: TObject);
begin
  frmPrintSetup.ShowModal;
end;

function TfrmLuaEditMain.DoPrintExecute(): Boolean;
begin
  synEditPrint.SynEdit := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit;
  synEditPrint.Title := TLuaEditUnit(jvUnitBar.SelectedTab.Data).Path;

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

  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail then
  begin
    pdlgPrint.Options := pdlgPrint.Options + [poSelection];
  end
  else
  begin
    pdlgPrint.Options := pdlgPrint.Options - [poSelection];
  end;

  Result := pdlgPrint.Execute;

  if Result then
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

procedure TfrmLuaEditMain.actPrintExecute(Sender: TObject);
begin
  DoPrintExecute;
end;

procedure TfrmLuaEditMain.ctrlBarDockOver(Sender: TObject; Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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

procedure TfrmLuaEditMain.File2Click(Sender: TObject);
begin
  if tlbBaseFile.Visible then
    tlbBaseFile.Hide
  else
    tlbBaseFile.Show;
end;

procedure TfrmLuaEditMain.Edit2Click(Sender: TObject);
begin
  if tlbEdit.Visible then
    tlbEdit.Hide
  else
    tlbEdit.Show;
end;

procedure TfrmLuaEditMain.Find1Click(Sender: TObject);
begin
  if tlbFind.Visible then
    tlbFind.Hide
  else
    tlbFind.Show;
end;

procedure TfrmLuaEditMain.Run3Click(Sender: TObject);
begin
  if tlbRun.Visible then
    tlbRun.Hide
  else
    tlbRun.Show;
end;

procedure TfrmLuaEditMain.ASciiTable1Click(Sender: TObject);
begin
  frmAsciiTable.ShowModal;
end;

procedure TfrmLuaEditMain.CreateGUID1Click(Sender: TObject);
begin
  frmGUID.ShowModal();
end;

procedure TfrmLuaEditMain.PathConverter1Click(Sender: TObject);
begin
  frmConvertPath.ShowModal();
end;

procedure TfrmLuaEditMain.Help1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar(ExtractFilePath(Application.ExeName)+'\Help\LuaEdit.chm'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmLuaEditMain.LuaEditHomePage1Click(Sender: TObject);
begin
  BrowseURL('http://luaedit.luaforge.net');
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
    TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.iCurrentLineDebug := -1;
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
  if TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.IsBreakPointLine(AR.currentline) then
  begin
    Answer := 1;
    frmLuaEditMain.Running := False;
    WaitInCallLevel := -1;
  end
  else if FirstLineStop then
  begin
    FirstLineStop := False;
    Answer := 1;
    frmLuaEditMain.Running := False;
    WaitInCallLevel := -1;
  end
  else
    Answer := 0;

  Status := send(pSock, Answer, SizeOf(Answer), 0);
  if Status <> SizeOf(Answer) then
    ELuaEditException.Create('Remote Debug Failed: The operation failed while sending Current line informations');

  //sending Caret Y...
  CaretY := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.CaretY;
  Status := send(pSock, CaretY, SizeOf(CaretY), 0);
  if Status <> SizeOf(CaretY) then
    raise ELuaEditException.Create('Remote Debug Failed: The opertion failed while sending the caret y position');

  if ((RunToCursorPressed = True) and (AR.currentline = TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.CaretY)) then
  begin
    RunToCursorPressed := False;
    frmLuaEditMain.Running := False;
    WaitInCallLevel := -1;
  end
  else if ((RunToCursorPressed = True) and not frmLuaEditMain.Running) then
  begin
    frmLuaEditMain.Running := True;
  end;

  if (not frmLuaEditMain.Running and (StopPressed = False)) then
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
      
      if (not frmLuaEditMain.Running or (PausePressed = True)) then
      begin
        TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(AR.currentline);
        TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.iCurrentLineDebug := AR.currentline;
        TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
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

        if PausePressed then
        begin
          frmLuaEditMain.Running := False;
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
          TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).DebugInfos.iCurrentLineDebug := -1;
        end;

        StepOverPressed := False;
        StepIntoPressed := False;
        PlayPressed := False;
        PausePressed := False;
      end;
    end;
  end;
end;

procedure TfrmLuaEditMain.ContributorsList1Click(Sender: TObject);
begin
  frmContributors.ShowModal();
end;

procedure TfrmLuaEditMain.ComponentsContributors1Click(Sender: TObject);
begin
  frmComponentList.ShowModal();
end;

procedure TfrmLuaEditMain.OpenFileAtCursor1Click(Sender: TObject);
var
  pFiles: TStringList;
  WordAtCursor: String;
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail then
    WordAtCursor := ExpandUNCFileName(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText);

  if FileExistsAbs(WordAtCursor) then
  begin
    pFiles := TStringList.Create;
    pFiles.Add(WordAtCursor);
    DoOpenFileExecute(pFiles);
    pFiles.Free;

    // Reinitialize stuff...
    frmProjectTree.BuildProjectTree();
    CheckButtons();
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

procedure TfrmLuaEditMain.ppmEditorPopup(Sender: TObject);
var
  sTextToShow, sOriginalName: String;
begin
  sTextToShow := '';
  
  if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelAvail then
  begin
    OpenFileatCursor1.Enabled := True;
    sOriginalName := StringReplace(TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.SelText, '\\', '\', [rfIgnoreCase, rfReplaceAll]);

    if FileExistsAbs(sOriginalName) then
      sTextToShow := MinimizeName(sOriginalName, stbMain.Canvas, 150);
  end;

  if sTextToShow <> '' then
  begin
    OpenFileatCursor1.Caption := 'Open Document "'+sTextToShow+'"';
    OpenFileatCursor1.Enabled := True;
  end
  else
  begin
    OpenFileatCursor1.Caption := 'Open Document ""';
    OpenFileatCursor1.Enabled := False;
  end;
end;

procedure TfrmLuaEditMain.jvUnitBarChange(Sender: TObject);
var
  pFile: TLuaEditBasicTextFile;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pFile := TLuaEditBasicTextFile(jvUnitBar.SelectedTab.Data);

      if pFile.HasChanged then
        stbMain.Panels[3].Text := 'Modified'
      else
        stbMain.Panels[3].Text := '';

      if pFile.IsReadOnly then
        stbMain.Panels[4].Text := 'Read Only'
      else
        stbMain.Panels[4].Text := '';

      synEditClick(pFile.SynUnit);
      frmFunctionList.RefreshList(pFile.Path);
      CheckButtons;
    end;
  end;
end;

function TfrmLuaEditMain.DoCompileSciptExecute(): Boolean;
var
  sFileOut: String;
  sCmd: PChar;
  pLuaUnit: TLuaEditUnit;
  si: TStartupInfo;
  pi: TProcessInformation;
begin
  Result := True;

  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

      if not DoSaveExecute then
        Exit;

      // Prompt user for the output file path
      if pLuaUnit.PrjOwner.sCompileDirectory = '' then
      begin
        sdlgCompileOut.FileName := ChangeFileExt(pLuaUnit.Name, pLuaUnit.PrjOwner.sCompileExtension);
        sdlgCompileOut.InitialDir := ExtractFileDir(pLuaUnit.Path);

        if not sdlgCompileOut.Execute then
          Exit;

        sFileOut := sdlgCompileOut.FileName;
      end
      else
        sFileOut := pLuaUnit.PrjOwner.sCompileDirectory + ChangeFileExt(pLuaUnit.Name, pLuaUnit.PrjOwner.sCompileExtension);

      // Initialize createprocess variables for call
      Screen.Cursor := crHourGlass;
      ShowDockForm(frmLuaEditMessages);
      frmLuaEditMessages.Put('Begin of Script Compilation - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
      FillChar(si, sizeof(si), 0);
      si.cb := sizeof(si);
      sCmd := PChar('"' + GetLuaEditInstallPath() + '\luac.exe" -l -o "' + sFileOut + '" "' + pLuaUnit.Path + '"');

      // Call luac application to compile (hidden process)
      CreateProcess(nil, sCmd, nil, nil, True, CREATE_NO_WINDOW, nil, nil, si, pi);

      // Wait until the process is done
      stbMain.Panels[5].Text := 'Compiling Script... Please Wait';
      stbMain.Refresh;
      frmLuaEditMessages.Put('Compiling Script... Please Wait - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
      Application.ProcessMessages;

      WaitForSingleObject(pi.hProcess, INFINITE);

      stbMain.Panels[5].Text := '';
      stbMain.Refresh;
      frmLuaEditMessages.Put('End of Script Compilation - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
      Screen.Cursor := crDefault;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrmLuaEditMain.actCompileSciptExecute(Sender: TObject);
begin
  DoCompileSciptExecute();
end;

function TfrmLuaEditMain.DoCheckSyntaxExecute(): Boolean;
var
  L: Plua_State;
  pLuaUnit: TLuaEditUnit;
  FileName: String;
begin
  Result := True;
  
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      try
        pLuaUnit := TLuaEditUnit(jvUnitBar.SelectedTab.Data);

        if pLuaUnit.synUnit.Text <> '' then
        begin
          frmLuaEditMessages.vstLuaEditMessages.Clear;
          PrevFile := pLuaUnit.Path;
          L := lua_open();
          LuaLoadBuffer(L, pLuaUnit.synUnit.Text, pLuaUnit.Path);
          frmLuaEditMessages.Put('Syntax Checked - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
          stbMain.Panels[5].Text := '[HINT]:  Syntax Checked - '+DateTimeToStr(Now);
          pLuaUnit.synUnit.Refresh;
        end;
      except
        on E: ELuaException do
        begin
          PopUpUnitToScreen(PrevFile);

          if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
          begin
            pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

            FileName := pLuaUnit.Path;

            if (not FileExistsAbs(FileName)) then
              FileName := PrevFile;

            if E.Line > 0 then
            begin
              pLuaUnit.DebugInfos.iLineError := E.Line;
              jvUnitBar.SelectedTab := pLuaUnit.AssociatedTab;
              pLuaUnit.synUnit.GotoLineAndCenter(E.Line);
            end;
          end;

          if (E.Msg <> 'STOP') then
          begin
            Result := False;
            frmLuaEditMessages.Put(E.Msg + ' (' + IntToStr(E.Line) + ') - ' + DateTimeToStr(Now), LUAEDIT_ERROR_MSG, PrevFile, E.Line);
            raise;
          end;
        end;
      end;
    end;
  end;

  ShowDockForm(frmLuaEditMessages);
end;

// check the syntax of the currently opened unit
procedure TfrmLuaEditMain.actCheckSyntaxExecute(Sender: TObject);
begin
  DoCheckSyntaxExecute;
end;

// Return the value of a given local variable
function TfrmLuaEditMain.GetValue(Name: string): string;
begin
  Result := '[ERROR] Undeclared Identifier';

  if lstLocals.Values[Name] <> ''  then
    Result := lstLocals.Values[Name]
  else if lstGlobals.Values[Name] <> '' then
    Result := lstGlobals.Values[Name];
end;

// Find a unit among all opened unit (wich are placed in tabs...)
function TfrmLuaEditMain.FindUnitInTabs(pLuaEditBasicTextFile: TLuaEditBasicTextFile): TLuaEditBasicTextFile;
var
  x: Integer;
begin
  Result := nil;

  for x := 0 to jvUnitBar.Tabs.Count - 1 do
  begin
    if Assigned(jvUnitBar.Tabs[x].Data) then
    begin
      if TLuaEditBasicTextFile(jvUnitBar.Tabs[x].Data) = pLuaEditBasicTextFile then
      begin
        Result := TLuaEditBasicTextFile(jvUnitBar.Tabs[x].Data); // Return the unit data object
        Exit; // No need to go further cause we found the unit
      end;
    end;
  end;
end;

// Find a unit among all opened unit (wich are placed in tabs...)
function TfrmLuaEditMain.FindUnitInTabsStr(sUnitName: String): TLuaEditBasicTextFile;
var
  x: Integer;
begin
  Result := nil;

  for x := 0 to jvUnitBar.Tabs.Count - 1 do
  begin
    if Assigned(jvUnitBar.Tabs[x].Data) then
    begin
      if TLuaEditBasicTextFile(jvUnitBar.Tabs[x].Data).Path = sUnitName then
      begin
        Result := TLuaEditBasicTextFile(jvUnitBar.Tabs[x].Data); // Return the unit data object
        Exit; // No need to go further cause we found the unit
      end;
    end;
  end;
end;

// check the syntax of the current unit
procedure TfrmLuaEditMain.ppmUnitsPopup(Sender: TObject);
begin
  Save2.Enabled := (jvUnitBar.Tabs.Count <> 0);
  SaveAs2.Enabled := (jvUnitBar.Tabs.Count <> 0);
  Close2.Enabled := (jvUnitBar.Tabs.Count <> 0);
end;

procedure TfrmLuaEditMain.actFunctionHeaderExecute(Sender: TObject);
var
  sLine: String;
begin
  if Assigned(jvUnitBar.SelectedTab) then
  begin
    if Assigned(jvUnitBar.SelectedTab.Data) then
    begin
      sLine := TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.Lines[TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.CaretY - 1];
      //FunctionHeaderBuilder(Application.Handle, PChar(sLine));
    end;
  end;
end;

procedure TfrmLuaEditMain.jvAppDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
var
  x: Integer;
  pFiles: TStringList;
  FileName: String;
begin
  pFiles := TStringList.Create;

  for x := 0 to Value.Count - 1 do
  begin
    // Get current file name
    FileName := Value.Strings[x];

    // Make the file exists
    if FileExistsAbs(FileName) then
    begin
      pFiles.Add(FileName);
      DoOpenFileExecute(pFiles);
    end;
  end;

  // Rebuild the project tree and initialize stuff
  pFiles.Free;
  frmProjectTree.BuildProjectTree;
  CheckButtons;
end;

procedure TfrmLuaEditMain.jvUnitBarTabClosed(Sender: TObject; Item: TJvTabBarItem);
var
  pTab: TJvTabBarItem;
begin
  pTab := jvUnitBar.SelectedTab.GetPreviousVisible;

  if ClosingUnit then
    Item.Free;

  if Assigned(pTab) then
    jvUnitBar.SelectedTab := pTab;
end;

procedure TfrmLuaEditMain.jvUnitBarTabSelecting(Sender: TObject; Item: TJvTabBarItem; var AllowSelect: Boolean);
begin
  if Assigned(Item) then
  begin
    if Assigned(Item.Data) then
    begin
      Self.Caption := 'LuaEdit - ' + TLuaEditUnit(Item.Data).Path;
      frmFunctionList.RefreshList(TLuaEditUnit(Item.Data).Path);
      TLuaEditUnit(Item.Data).synUnit.Visible := True;
      synEditClick(TLuaEditUnit(Item.Data).synUnit);
      
      if Assigned(jvUnitBar.SelectedTab) then
        TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.Visible := False;
    end
    else
      Self.Caption := 'LuaEdit';
  end
  else
    Self.Caption := 'LuaEdit';
end;

procedure TfrmLuaEditMain.ppmToolBarPopup(Sender: TObject);
begin
  DoMainMenuViewExecute;
end;

// Clean up temporary folder (delete all *.tag files under the temporary folder)
procedure TfrmLuaEditMain.CleanUpTempDir();
var
  hSearchRec: TSearchRec;
  iSearchResult: Integer;
begin
  SetCurrentDirectory(PChar(TempFolder));
  iSearchResult := FindFirst(TempFolder + '\*.tag', faAnyFile, hSearchRec);

  while iSearchResult = 0 do
  begin
    if FileExistsAbs(TempFolder + '\' + hSearchRec.Name) then
      DeleteFile(TempFolder + '\' + hSearchRec.Name);

    iSearchResult := FindNext(hSearchRec);
  end;

  FindClose(hSearchRec);
end;

(*procedure TDebuggerThread.Execute;
begin




  //frmLuaEditMain.actCompileExecute(nil);

  {if IsCompiledComplete then
  begin
    if WSAStartup($101, WSA) <> 0 then
    begin
      Application.MessageBox('Invalid winsock version!', 'LuaEdit', MB_OK+MB_ICONERROR);
      EndThread(0);
    end;

    try
      pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);
      pSock := INVALID_SOCKET;
      pRSock := INVALID_SOCKET;

      // initializing connection
      pSock := socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
      if pSock = INVALID_SOCKET then
        raise ELuaEditException.Create('Remote Debug Failed: Cannot open socket!');

      FillChar(pAddrIn, SizeOf(pAddrIn), 0);
      pAddrIn.sin_family := PF_INET;
      pAddrIn.sin_port := htons(pLuaUnit.pPrjOwner.RemotePort);
      pAddrIn.sin_addr.S_addr := htonl(INADDR_ANY);

      // Bind the socket
      if bind(pSock, TSockAddr(pAddrIn), SizeOf(pAddrIn)) <> 0 then
      begin
        sTemp := SysErrorMessage(WSAGetLastError());
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed on binding');
      end;

      // Listen for any client...
      if listen(pSock, 5) <> 0 then
        raise ELuaEditException.Create('Remote Debug Failed: The operation failed on listening');

      // Building CntString...
      frmCntString.memoCntString.Lines.Clear;
      frmCntString.memoCntString.Text := 'rdbg.exe "'+GetLocalIP+'" "'+IntToStr(pLuaUnit.pPrjOwner.RemotePort)+'"';

      // Wait after user interaction...
      WaitForSingleObject(hMutex, INFINITE);

      // Accept next incoming connection
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
            TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError := StrToInt(Copy(sTemp, 1, Pos(':', sTemp) - 1));
            TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.GotoLineAndCenter(TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError);
            TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.CaretX := Length(TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.LineText) + 1;
            LastMessage := '(Line: '+IntToStr(TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).pDebugInfos.iLineError)+')' + Copy(sTemp, Pos(':', sTemp) + 1, Length(sTemp) - Pos(':', sTemp));
            TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
            frmLuaEditMain.stbMain.Refresh;
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
end;*)

// This function manage debug actions in general and handle initialization of debug session
procedure TfrmLuaEditMain.RemoteCustomExecute(Pause: Boolean; PauseICI: Integer; PauseFile: string; PauseLine: Integer; FuncName: string; const Args: array of string; Results: TStrings);
var
  L: Plua_State;
  FileName: string;
  x, NArgs: Integer;
  pLuaUnit: TLuaEditUnit;
  iDoLuaOpen :Boolean;

  procedure OpenLibs(L: PLua_State);
  begin
    luaopen_base(L);
    luaopen_table(L);
    luaopen_io(L);
    luaopen_string(L);
    luaopen_math(L);
    luaopen_debug(L);
    lua_settop(L, 0);
  end;

  procedure UninitializeUnits;
  var
    x, y: Integer;
    pLuaUnit: TLuaEditUnit;
  begin
    // Uninitialize opened units
    for x := 0 to frmLuaEditMain.jvUnitBar.Tabs.Count - 1 do
    begin
      pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.Tabs[x].Data);
      pLuaUnit.DebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.synUnit.Refresh;

      // Reset all breakpoints hitcount to 0
      for y := 0 to pLuaUnit.DebugInfos.lstBreakpoint.Count - 1 do
        TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint[y]).iHitCount := 0;
    end;

    if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
      TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;

    frmBreakpoints.RefreshBreakpointList;
    frmLuaEditMain.stbMain.Refresh;
  end;

  procedure InitializeUnits;
  var
    x, y: Integer;
    pLuaUnit: TLuaEditUnit;
  begin
    // Initialize opened units
    for x := 0 to frmLuaEditMain.jvUnitBar.Tabs.Count - 1 do
    begin
      pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.Tabs[x].Data);
      pLuaUnit.synUnit.Modified := False;
      pLuaUnit.DebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.DebugInfos.iLineError := -1;
      pLuaUnit.synUnit.Refresh;

      // Reset all breakpoints hitcount to 0
      for y := 0 to pLuaUnit.DebugInfos.lstBreakpoint.Count - 1 do
        TBreakpoint(pLuaUnit.DebugInfos.lstBreakpoint[y]).iHitCount := 0;
    end;

    if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
      TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).SynUnit.Refresh;

    frmBreakpoints.RefreshBreakpointList;
    frmLuaEditMain.stbMain.Refresh;
  end;

  procedure SetPause(pLuaUnit: TLuaEditUnit);
  begin
    if (not Pause) then
    begin
      pLuaUnit.DebugInfos.iCurrentLineDebug := -1;
      pLuaUnit.DebugInfos.iStackMarker := -1;

      if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab.Data) then
        TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).SynUnit.Refresh;
    end;
    
    Self.Pause := Pause;
    Self.PauseICI := PauseICI;
    Self.PauseLine := PauseLine;
    Self.PauseFile := PauseFile;
  end;

  function Initializer(L: PLua_State): Boolean;
  begin
    Result := True;

    if TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).PrjOwner.sInitializer <> '' then
    begin
      if frmLuaEditMain.ExecuteInitializer(TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).PrjOwner.sInitializer, L) < 0 then
      begin
        Application.MessageBox('An error occured while executing the initializer function.', 'LuaEdit', MB_OK+MB_ICONERROR);
        frmLuaEditMain.CheckButtons;
        FreeLibrary(hModule);
        Result := False;
      end;
    end;
  end;

  procedure AppendToLuaCPath(L: PLua_State; AppendStr: String);
  var
    CurrentStr, NewStr: String;
  begin
    lua_getglobal(L, 'package');

    if lua_istable(L, -1) then
    begin
      lua_pushstring(L, 'cpath');
      lua_gettable(L, -2);

      CurrentStr := lua_tostring(L, -1);
      NewStr := CurrentStr + ';' + AppendStr;

      lua_pushstring(L, PChar(NewStr));
      lua_pushstring(L, 'cpath');
      lua_settable(L, -3);
    end;
  end;

  procedure AppendToLuaPath(L: PLua_State; AppendStr: String);
  var
    CurrentStr, NewStr: String;
  begin
    lua_getglobal(L, 'package');

    if lua_istable(L, -1) then
    begin
      lua_pushstring(L, 'path');
      lua_gettable(L, -2);

      CurrentStr := lua_tostring(L, -1);
      NewStr := CurrentStr + ';' + AppendStr;

      lua_pushstring(L, PChar(NewStr));
      lua_pushstring(L, 'path');
      lua_settable(L, -3);
    end;
  end;
begin
  // Determine unit to use to start debug
  if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
  begin
    pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

    if ((pLuaUnit.PrjOwner = ActiveProject) and (ActiveProject.sTargetLuaUnit <> '[Current Unit]')) then
    begin
      pLuaUnit := ActiveProject.pTargetLuaUnit;
      PopUpUnitToScreen(pLuaUnit.Path);
    end;
  end
  else if Assigned(ActiveProject) then
  begin
    pLuaUnit := ActiveProject.pTargetLuaUnit;
    PopUpUnitToScreen(pLuaUnit.Path);
  end;

  if Assigned(pLuaUnit) then
  begin
    if Running then
    begin
      if ((IsEdited) and (NotifyModified)) then
      begin
        case (Application.MessageBox(PChar('The unit "'+pLuaUnit.Path+'" has changed. Stop debugging?'), 'LuaEdit', MB_ICONINFORMATION+MB_YESNO)) of
        IDYES:
          begin
            Running := False;
            frmLuaEditMessages.Put('End of Scipt - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
            frmLuaEditMessages.Put('Script Terminated by User - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
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

    if not DoCheckSyntaxExecute then
      Exit;

    iDoLuaOpen := (LuaState = nil);

    if iDoLuaOpen then
      LuaState := lua_open;

    L := LuaState;
    OpenLibs(L);

    if not Initializer(L) then
    begin
      Running := False;
      Exit;
    end;

    Running := True;
    LuaRegister(L, 'print', lua_print);
    OnLuaStdoutEx := DoLuaStdoutEx;
    lua_sethook(L, HookCaller, HOOK_MASK, 0);
    CurrentICI := 1;
    frmLuaEditMain.CheckButtons;

    // Initializing project's settings if required
    if ActiveProject = pLuaUnit.PrjOwner then
    begin
      // Initializing runtime directory
      if DirectoryExists(ActiveProject.sRuntimeDirectory) then
      begin
        SetCurrentDirectory(PChar(ActiveProject.sRuntimeDirectory));
        lua_pushstring(L, PChar(ActiveProject.sRuntimeDirectory));
        lua_setglobal(L, 'LUA_PATH');
      end;
    end;

    if (Assigned(Results)) then
      Results.Clear;

    try
      if Assigned(jvUnitBar.SelectedTab.Data) then
      begin
        TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.Refresh;
        frmLuaEditMain.stbMain.Refresh;
      end;

      PrevFile := pLuaUnit.Path;
      PrevLine := 0;

      try
        frmLuaEditMessages.vstLuaEditMessages.Clear;
        CallStack.Clear;
        PrintStack;

        if TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.Text = '' then
          Exit;

        LuaLoadBuffer(L, TLuaEditUnit(jvUnitBar.SelectedTab.Data).synUnit.Text, pLuaUnit.Path);

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
        frmLuaEditMessages.Put('Begin of Script - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
        LuaPCall(L, NArgs, LUA_MULTRET, 0);
        frmLuaEditMessages.Put('End of Script - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
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
        frmLuaEditMain.CheckButtons;
        FreeLibrary(hModule);
      end;
    except
      on E: ELuaException do
      begin
        PopUpUnitToScreen(PrevFile);
        
        if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
        begin
          pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data);

          FileName := pLuaUnit.Path;

          if (not FileExistsAbs(FileName)) then
            FileName := PrevFile;

          if (FileExistsAbs(FileName) and (E.Line > 0)) then
          begin
            pLuaUnit.DebugInfos.iLineError := E.Line;
            frmLuaEditMain.jvUnitBar.SelectedTab := pLuaUnit.AssociatedTab;
            pLuaUnit.synUnit.GotoLineAndCenter(E.Line);
          end;
        end;

        if (E.Msg <> 'STOP') then
        begin
          stbMain.Panels[5].Text := '[ERROR]: '+E.Msg+' ('+IntToStr(E.Line)+') - '+DateTimeToStr(Now);
          frmLuaEditMessages.Put(E.Msg + ' (' + IntToStr(E.Line) + ') - ' + DateTimeToStr(Now), LUAEDIT_ERROR_MSG, PrevFile, E.Line);
          frmLuaEditMessages.Put('End of Script - '+DateTimeToStr(Now), LUAEDIT_HINT_MSG);
          raise;
        end;

        UninitializeUnits;
      end;
    end;
  end;
end;

function TfrmLuaEditMain.DoRemoteSessionExecute(): Boolean;
var
  pInitiateClient: TInitiateClient;
  pSocketCreate: TSocketCreate;
  pSocketSend: TSocketSend;
  Ptr: TFarProc;
  hModule: Cardinal;
begin
  try
    Result := True;
    
    // Initialize winsock
    if WSAStartup($101, WSA) <> 0 then
      ESocketException.Create('Fail to initialize winsock: ' + SysErrorMessage(WSAGetLastError()));

    // Load remote plugin library
    hModule := LoadLibrary(PChar(GetLuaEditInstallPath() + '\Remote.dll'));

    // Retrieve the 'SocketSend' function from plugin dll
    Ptr := GetProcAddress(hModule, 'SocketSend');
    pSocketSend := TSocketSend(Ptr);
    Ptr := nil;

    // Retrieve the 'SocketCreate' function from plugin dll
    Ptr := GetProcAddress(hModule, 'SocketCreate');
    pSocketCreate := TSocketCreate(Ptr);
    Ptr := nil;

    // Create the socket...
    pSock := pSocketCreate(True, 'Unable to create the socket.');
    if pSock = INVALID_SOCKET then
      Exit;

    // Retrieve the 'InitiateClient' function from plugin dll
    Ptr := GetProcAddress(hModule, 'InitiateClient');
    pInitiateClient := TInitiateClient(Ptr);
    Ptr := nil;

    // Initiate connection
    if Assigned(ActiveProject) then
    begin
      if ((ActiveProject.sRemoteIP <> '0.0.0.0') and (ActiveProject.iRemotePort > 0) and (ActiveProject.sRemoteDirectory <> '')) then
      begin
        if not pInitiateClient(pSock, PChar(ActiveProject.sRemoteIP), ActiveProject.iRemotePort, PChar(ActiveProject.sRemoteDirectory), ActiveProject.iConnectTimeOut) then
          Exit;

        // Uploading files on remote machine (including initializer if required)
        frmUploadFiles := TfrmUploadFiles.Create(nil);
        frmUploadFiles.Show;
        frmUploadFiles.Transfer(pSock, ActiveProject, hModule);

        // Free and nil frmUploadFiles if required
        if Assigned(frmUploadFiles) then
          frmUploadFiles.Free;

        // Send initializer path...
        if ActiveProject.sInitializer <> '' then
          pSocketSend(pSock, PChar(ActiveProject.sRemoteDirectory + ExtractFileName(ActiveProject.sInitializer))^, Length(ActiveProject.sRemoteDirectory + ExtractFileName(ActiveProject.sInitializer)), 0, 'Fail to send the intializer path.')
        else
          pSocketSend(pSock, PChar(RDBG_EMPTY)^, Length(RDBG_EMPTY), 0, 'Fail to send the intializer path.');
      end
      else
        Application.MessageBox('Remote debugging informations in the currently opened project must be valid!', 'LuaEdit', MB_ICONERROR + MB_OK);
    end
    else
      Application.MessageBox('A project containing remote debugging informations must be opened!', 'LuaEdit', MB_ICONERROR + MB_OK);

    // Uninitialize winsock
    //WSACleanup;

  except
    on E: Exception do
    begin
      // Free and nil frmUploadFiles if required
      if Assigned(frmUploadFiles) then
        frmUploadFiles.Free;

      // Free loaded library
      if hModule <> NULL then
        FreeLibrary(hModule);

      // Display error message
      WSACleanup;
      Result := False;
      Application.MessageBox(PChar(E.Message), 'LuaEdit', MB_OK+MB_ICONERROR);
    end;
  end;
end;

procedure TfrmLuaEditMain.actRemoteSessionExecute(Sender: TObject);
begin
  DoRemoteSessionExecute;
end;

end.
