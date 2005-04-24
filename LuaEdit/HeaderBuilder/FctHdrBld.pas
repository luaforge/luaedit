unit FctHdrBld;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMenu, ImgList, ComCtrls, ToolWin, Grids,
  ValEdit, XPMan, Registry;

type
  TfrmFctHdrBld = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    txtFunctionName: TEdit;
    Label1: TLabel;
    tlbMain: TToolBar;
    tbtnPreview: TToolButton;
    ToolButton2: TToolButton;
    imlToolbar: TImageList;
    Label3: TLabel;
    memoComment: TMemo;
    lblCallSample: TLabel;
    txtCallSample: TEdit;
    ToolButton1: TToolButton;
    tbtnSettings: TToolButton;
    ToolButton4: TToolButton;
    tbtnCopyright: TToolButton;
    tbtnCallSample: TToolButton;
    tbtnEdit: TToolButton;
    xmpMenuPainter: TXPMenu;
    tbtnAddParam: TToolButton;
    tbtnRemoveParam: TToolButton;
    ToolButton9: TToolButton;
    lvwParams: TListView;
    Label5: TLabel;
    txtReturn: TEdit;
    procedure ToolButton2Click(Sender: TObject);
    procedure tbtnAddParamClick(Sender: TObject);
    procedure tbtnRemoveParamClick(Sender: TObject);
    procedure tbtnEditClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure tbtnCallSampleClick(Sender: TObject);
    procedure tbtnSettingsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ParseLine(sLine: String);
    procedure ClearForm(bPrompt: Boolean = False);
    procedure CheckButtons;
    function GetHeader: String;
  end;

var
  frmFctHdrBld: TfrmFctHdrBld;

implementation

uses
  EditParam, Settings;

{$R *.dfm}

procedure TfrmFctHdrBld.ParseLine(sLine: String);
var
  xPos: Integer;
  sTemp: String;
  EqTokenPos, ParenTokenPos: Integer;
  pItem: TListItem;
begin
  // Clear the form before auto-filling infos
  ClearForm;

  if sLine <> '' then
  begin
    if Pos('function', sLine) > 0 then
    begin
      // look for the '=' token if any
      EqTokenPos := Pos('=', sLine);
      sTemp := '';

      // if we got an '=' token then we look for the very first word on left
      //of '=' token wich is the function name
      if EqTokenPos > 0 then
      begin
        xPos := EqTokenPos - 1;

        // get end of very first word on left
        while sLine[xPos] = ' ' do
          Dec(xPos);

        // start collecting chars
        while sLine[xPos] <> ' ' do
        begin
          sTemp := sLine[xPos] + sTemp;
          Dec(xPos);
        end;
      end
      else   // if we don't have an '=' token then this means the function name
      begin  // is the very word on the right of the 'function' token
        xPos := Pos('function', sLine) + Length('function');

        // get end of very first word on right
        while sLine[xPos] = ' ' do
          Inc(xPos);

        // start collecting chars
        while (not (sLine[xPos] in [' ', '('])) do
        begin
          sTemp := sTemp + sLine[xPos];
          Inc(xPos);
        end;
      end;

      // Once here we should have the function name
      txtFunctionName.Text := sTemp;
      sTemp := '';

      // now it's time to get the parameters list
      ParenTokenPos := Pos('(', sLine);

      // if there is any parameters, we get them
      if ParenTokenPos > 0 then
      begin
        xPos := ParenTokenPos + 1;
        sTemp := '';

        // get parameters until we get closing paren
        while sLine[xPos] <> ')' do
        begin
          while (not (sLine[xPos] in [')', ','])) do
          begin
            sTemp := sTemp + sLine[xPos];
            Inc(xPos);
          end;

          if sLine[xPos] = ',' then
            Inc(xPos);

          pItem := lvwParams.Items.Add;
          pItem.Caption := Trim(sTemp);
          pItem.SubItems.Add('');
          sTemp := '';
        end;
      end;
    end;
  end;
end;

procedure TfrmFctHdrBld.ClearForm(bPrompt: Boolean = False);
var
  bCanClear: Boolean;
begin
  bCanClear := True;
  
  if bPrompt then
    bCanClear := (Windows.MessageBox(Self.Handle, 'Are you sure you want to clear the form?', 'Header Builder', MB_YESNO+MB_ICONQUESTION) = IDYES);

  if bCanClear then
  begin
    txtFunctionName.Text := '';
    txtCallSample.Text := '';
    txtCallSample.Text := '';
    memoComment.Lines.Clear;
    lvwParams.Items.Clear;
  end;
end;

function TfrmFctHdrBld.GetHeader: String;
var
  pReg: TRegistry;
  sTemplate, sToday, sInitialRealese: String;
  sCopyright, sDevelopperName: String;
begin
  pReg := TRegistry.Create;
  sToday := DateTimeToStr(Now);

  if pReg.OpenKey('\Software\LuaEdit\HdrBld', False) then
  begin
    sDevelopperName := pReg.ReadString('DevelopperName');
    sInitialRealese := pReg.ReadString('InitialRelease');
    sCopyright := pReg.ReadString('Copyright');

    if pReg.OpenKey('\Software\LuaEdit\HdrBld\FctHdr', False) then
    begin
      sTemplate := pReg.ReadString('Template');

      if not FileExists(sTemplate) then
      begin
        Windows.MessageBox(Self.Handle, Pchar('The template ' + sTemplate + ' is innexistant! No header was generated.'), 'Header Builder', MB_OK+MB_ICONERROR);
      end
      else
      begin

      end;
    end;
  end;

  pReg.Free;
end;

procedure TfrmFctHdrBld.ToolButton2Click(Sender: TObject);
begin
  ClearForm(True);
end;

procedure TfrmFctHdrBld.tbtnAddParamClick(Sender: TObject);
var
  pItem: TListItem;
begin
  pItem := lvwParams.Items.Add;
  pItem.Caption := '*New Parameter*';
  pItem.SubItems.Add('');
  CheckButtons;
end;

procedure TfrmFctHdrBld.tbtnRemoveParamClick(Sender: TObject);
begin
  if Assigned(lvwParams.Selected) then
  begin
    lvwParams.Items.Delete(lvwParams.Selected.Index);
    CheckButtons;
  end;
end;

procedure TfrmFctHdrBld.tbtnEditClick(Sender: TObject);
begin
  if Assigned(lvwParams.Selected) then
  begin
    frmEditParam := TfrmEditParam.Create(nil);
    frmEditParam.txtName.Text := lvwParams.Selected.Caption;
    frmEditParam.txtComment.Text := lvwParams.Selected.SubItems[0];

    if frmEditParam.ShowModal = mrOk then
    begin
      lvwParams.Selected.Caption := frmEditParam.txtName.Text;
      lvwParams.Selected.SubItems[0] := frmEditParam.txtComment.Text;
    end;

    FreeAndNil(frmEditParam);
  end;
end;

procedure TfrmFctHdrbld.CheckButtons;
begin
  tbtnRemoveParam.Enabled := not (lvwParams.Items.Count = 0);
  tbtnEdit.Enabled := not (lvwParams.Items.Count = 0);
end;

procedure TfrmFctHdrBld.FormShow(Sender: TObject);
begin
  CheckButtons;
end;

procedure TfrmFctHdrBld.btnOKClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if txtFunctionName.Text = '' then
  begin
    Windows.MessageBox(Self.Handle, 'You must enter a function name for the header.', 'Header Builder', MB_OK+MB_ICONERROR);
    txtFunctionName.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

procedure TfrmFctHdrBld.tbtnCallSampleClick(Sender: TObject);
begin
  lblCallSample.Enabled := tbtnCallSample.Down;
  txtCallSample.Enabled := tbtnCallSample.Down; 
end;

procedure TfrmFctHdrBld.tbtnSettingsClick(Sender: TObject);
begin
  frmSettings := TfrmSettings.Create(nil);
  frmSettings.ShowModal;
  FreeAndNil(frmSettings);
end;

end.
