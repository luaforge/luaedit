unit InternalBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvDockControlForm, ImgList, ComCtrls, ToolWin,
  StdCtrls, SHDocVW, ActnList, ExtCtrls, Registry, DateUtils, JvExControls,
  JvAnimatedImage, JvGIFCtrl, OleCtrls, ActiveX, JvOutlookBar, Misc;

const
  // Mouse click basic events
  WM_XBUTTONDOWN   = $020B;
  WM_XBUTTONUP     = $020C;
  WM_XBUTTONDBLCLK = $020D;

  // Extended mouse buttons
  MOUSE_XBUTTONPREV  = $10000;
  MOUSE_XBUTTONNEXT  = $20000;

type
  TURLDateTime = class(TObject)
  public
    Date: TDateTime;
    constructor Create(dtDate: TDateTime);
  end;

  TfrmInternalBrowser = class(TForm)
    JvDockClient1: TJvDockClient;
    imlBrowser: TImageList;
    ActionList1: TActionList;
    actBackTo: TAction;
    actFowardTo: TAction;
    actHome: TAction;
    actStop: TAction;
    actRefresh: TAction;
    actSearch: TAction;
    actGo: TAction;
    Panel2: TPanel;
    tlbInternalBrowser: TToolBar;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton20: TToolButton;
    ToolButton13: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton1: TToolButton;
    jvgifBrowser: TJvGIFAnimator;
    Panel1: TPanel;
    cboURL: TComboBox;
    btnGo: TButton;
    InternalBrowser: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actBackToExecute(Sender: TObject);
    procedure actFowardToExecute(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actGoExecute(Sender: TObject);
    procedure InternalBrowserCommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
    procedure InternalBrowserBeforeNavigate2(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure cboURLKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure InternalBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
  private
    {Private variables}
    IsFirstTime: Boolean;
    
    { Private declarations }
    FOleInPlaceActiveObject: IOleInPlaceActiveObject;
    procedure MsgHandler(var Msg: TMsg; var Handled: Boolean);
  public
    { Public declarations }
    procedure AddURLToList(URL: String);
    procedure btnXHistoryClick(Sender: TObject);
  end;

var
  frmInternalBrowser: TfrmInternalBrowser;

implementation

uses Rings, Main;

{$R *.dfm}

constructor TURLDateTime.Create(dtDate: TDateTime);
begin
  Date := dtDate;
end;

procedure TfrmInternalBrowser.btnXHistoryClick(Sender: TObject);
begin
  if not Self.Visible then
    frmLuaEditMain.DoShowInternalBrowserExecute;

  cboURL.Text := TJvOutlookBarButton(Sender).Caption;
  actGo.Execute;
end;

procedure TfrmInternalBrowser.FormCreate(Sender: TObject);
var
  pReg: TRegistry;
  lstValues: TStringList;
  pURLDateTime: TURLDateTime;
  pRingButton: TJvOutlookBarButton;
  x: Integer;
begin
  // Fix some web broser bugs with enter key
  Application.OnMessage := MsgHandler;
  
  // Initialize url combobox content
  pReg := TRegistry.Create;
  lstValues := TStringList.Create;

  if pReg.OpenKey('\Software\LuaEdit\InternalBrowser\Recent', False) then
  begin
    pReg.GetValueNames(lstValues);

    for x := 0 to lstValues.Count - 1 do
    begin
      if StrToDateTime(lstValues.Strings[x]) < IncDay(Now, 0 - HistoryMaxAge) then
      begin
        pReg.DeleteValue(lstValues.Strings[x]);
      end
      else
      begin
        pURLDateTime := TURLDateTime.Create(StrToDateTime(lstValues.Strings[x]));
        cboURL.AddItem(pReg.ReadString(lstValues.Strings[x]), pURLDateTime);
        pRingButton := frmRings.jvRings.Pages[JVPAGE_RING_BRWHISTORY].Buttons.Add;
        pRingButton.Caption := pReg.ReadString(lstValues.Strings[x]);
        pRingButton.OnClick := btnXHistoryClick;
      end;
    end;
  end;

  lstValues.Free;
  pReg.Free;
  IsFirstTime := True;
end;

procedure TfrmInternalBrowser.FormDestroy(Sender: TObject);
var
  pReg: TRegistry;
  pURLDateTime: TURLDateTime;
  x: Integer;
begin
  // wipe all current values and write new ones...
  pReg := TRegistry.Create;
  pReg.DeleteKey('\Software\LuaEdit\InternalBrowser\Recent');
  
  if pReg.OpenKey('\Software\LuaEdit\InternalBrowser\Recent', True) then
  begin
    for x := 0 to cboURL.Items.Count - 1 do
    begin
      pURLDateTime := TURLDateTime(cboURL.Items.Objects[x]);
      pReg.WriteString(DateTimeToStr(pURLDateTime.Date), cboURL.Items.Strings[x]);
      pURLDateTime.Free;
    end;
  end;

  FOleInPlaceActiveObject := nil;
  pReg.Free;
end;

// Added to fix [Enter] key pressed inside the browser
procedure TfrmInternalBrowser.MsgHandler(var Msg: TMsg; var Handled: Boolean);
const
  StdKeys = [VK_BACK, VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT];
var
  IOIPAO: IOleInPlaceActiveObject;
  Dispatch: IDispatch;
begin
  if InternalBrowser = nil then
  begin
    Handled := False;
    Exit;
  end;
  Handled := (IsDialogMessage(InternalBrowser.Handle, Msg) = True);
  if (Handled) and (not InternalBrowser.Busy) then
  begin
    if FOleInPlaceActiveObject = nil then
    begin
      Dispatch := InternalBrowser.Application;
      if Dispatch <> nil then
      begin
        Dispatch.QueryInterface(IOleInPlaceActiveObject, IOIPAO);
        if IOIPAO <> nil then FOleInPlaceActiveObject := IOIPAO;
      end;
    end;
    if FOleInPlaceActiveObject <> nil then
    begin
      // Next/Previous mouse buttons handling
      if Msg.message = WM_XBUTTONUP then
      begin
        if Msg.wParam = MOUSE_XBUTTONPREV then
          actBackTo.Execute
        else if Msg.wParam = MOUSE_XBUTTONNEXT then
          actFowardTo.Execute;
      end;

      if ((Msg.message = WM_KEYDOWN) or (Msg.message = WM_KEYUP)) and
        (Msg.wParam in StdKeys) then
        //nothing  -  do not pass on Backspace, Left, Right, Up, Down arrows
      else FOleInPlaceActiveObject.TranslateAccelerator(Msg);
    end;
  end;
end;


procedure TfrmInternalBrowser.AddURLToList(URL: String);
var
  x: Integer;
  pURLDateTime: TURLDateTime;
  pRingButton: TJvOutlookBarButton;
  bFound: Boolean;
begin
  // Initialize to false
  bFound := False;

  // Try to find string in the list
  for x := 0 to cboURL.Items.Count - 1 do
  begin
    // Set found flag to true if got match
    if cboURL.Items.Strings[x] = URL then
    begin
      bFound := True;
      break;
    end;
  end;

  // Add url to current list if not found
  if not bFound then
  begin
    pURLDateTime := TURLDateTime.Create(Now);
    cboURL.AddItem(URL, pURLDateTime);
    pRingButton := frmRings.jvRings.Pages[JVPAGE_RING_BRWHISTORY].Buttons.Add;
    pRingButton.Caption := URL;
    pRingButton.OnClick := btnXHistoryClick;
  end;
end;

procedure TfrmInternalBrowser.actBackToExecute(Sender: TObject);
begin
  InternalBrowser.GoBack;
end;

procedure TfrmInternalBrowser.actFowardToExecute(Sender: TObject);
begin
  InternalBrowser.GoForward;
end;

procedure TfrmInternalBrowser.actHomeExecute(Sender: TObject);
begin
  if HomePage = '' then
    InternalBrowser.GoHome
  else
    InternalBrowser.Navigate(HomePage);
end;

procedure TfrmInternalBrowser.actStopExecute(Sender: TObject);
begin
  InternalBrowser.Stop;
end;

procedure TfrmInternalBrowser.actRefreshExecute(Sender: TObject);
begin
  InternalBrowser.Refresh2;
end;

procedure TfrmInternalBrowser.actSearchExecute(Sender: TObject);
begin
  if SearchPage = '' then
    InternalBrowser.GoSearch
  else
    InternalBrowser.Navigate(SearchPage);
end;

procedure TfrmInternalBrowser.actGoExecute(Sender: TObject);
begin
  if cboURL.Text <> '' then
    InternalBrowser.Navigate(cboURL.Text);
end;

procedure TfrmInternalBrowser.InternalBrowserCommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
begin
  case Command of
    CSC_NAVIGATEBACK: actBackTo.Enabled := Enable;
    CSC_NAVIGATEFORWARD: actFowardTo.Enabled := Enable;
    CSC_UPDATECOMMANDS: actStop.Enabled := Enable;
  end;
end;

procedure TfrmInternalBrowser.InternalBrowserBeforeNavigate2(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  jvgifBrowser.Animate := True;
end;

procedure TfrmInternalBrowser.cboURLKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
    actGo.Execute;
end;

procedure TfrmInternalBrowser.FormShow(Sender: TObject);
begin
  if IsFirstTime then
  begin
    IsFirstTime := False;
    actHome.Execute;
  end;
end;

procedure TfrmInternalBrowser.InternalBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  if InternalBrowser.ReadyState = READYSTATE_COMPLETE then
  begin
    jvgifBrowser.Animate := False;
    cboURL.Text := URL;
    AddURLToList(URL);
  end;
end;

initialization
  OleInitialize(nil);

finalization
  OleUninitialize

end.
