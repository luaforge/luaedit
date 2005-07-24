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
    procedure lvwParamsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ParseLine(sLine: String);
    procedure ClearForm(bPrompt: Boolean = False);
    procedure CheckButtons;
    function GetHeader: String;
    function FormatParameters(): String;
    function FormatValue(sValue: String): String;
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

function TfrmFctHdrBld.FormatParameters(): String;
begin
  //todo
  Result := '';
end;

function TfrmFctHdrBld.FormatValue(sValue: String): String;
begin
  //todo
  Result := sValue;
end;

function TfrmFctHdrBld.GetHeader: String;
var
  pReg: TRegistry;
  IsShortened: Boolean;
  x, TagO, TagC: Integer;
  sTemplatePath, sToday, sInitialRealese: String;
  sCopyright, sDevelopperName, sToReplace, sReplaceValue, sTemp, sTag: String;
  strTemplate, strTags: TStringList;
begin
  Result := '';
  pReg := TRegistry.Create;
  sToday := DateTimeToStr(Now);

  // Get template path and start parsing the template
  if pReg.OpenKey('\Software\LuaEdit\HdrBld\FunctionsHdr', False) then
  begin
    sTemplatePath := pReg.ReadString('Template');

    if not FileExists(sTemplatePath) then
    begin
      Windows.MessageBox(Self.Handle, Pchar('The template ' + sTemplatePath + ' is innexistant! No header was generated.'), 'Header Builder', MB_OK+MB_ICONERROR);
    end
    else
    begin
      // Get tags from registry and parse the template to replace tags by their assigned value
      if pReg.OpenKey('\Software\LuaEdit\HdrBld\Tags', False) then
      begin
        // Get template from specified location on the disk
        strTemplate := TStringList.Create;
        strTemplate.LoadFromFile(sTemplatePath);
        sTemp := strTemplate.Text;

        // Retreive tags from registry and add local tags
        strTags := TStringList.Create;
        strTags.Text := 'This is a gottam text!';
        pReg.GetValueNames(strTags);
        strTags.Values['Function'] := FormatValue(txtFunctionName.Text);
        strTags.Values['Comment'] := FormatValue(memoComment.Text);
        strTags.Values['Parameters'] := FormatParameters;
        strTags.Values['Return'] := FormatValue(txtReturn.Text);
        strTags.Values['Sample'] := FormatValue(txtCallSample.Text);

        // parsing template
        repeat
          // reinitialize values
          IsShortened := False;
          TagO := Pos('<', sTemp);
          
          // look for possible tag opening
          if TagO <> 0 then
          begin
            TagC := Pos('>', sTemp);
            
            // Get possible tag name
            if TagC <> 0 then
            begin
              // Extract current tag
              sTag := Copy(sTemp, TagO, TagC - TagO + 1);

              // check if the tag we found is shortened
              if Copy(sTag, Length(sTag) - 1, 1) = '/' then
              begin
                IsShortened := True;
                sTag := Copy(sTag, 1, Length(sTag) - 1);
              end;

              // Extract tag name from tag element
              sTag := Copy(sTag, 2, Length(sTag) - 2);

              // Simple string replace call if it is a shortened one
              if IsShortened then
              begin
                sTemp := StringReplace(sTemp, '<' + sTag + '/>', strTags.Values[sTag], [rfReplaceAll, rfIgnoreCase]);
              end
              else
              begin
                // when not shortened, find closing tag and extract the whole
                // string out of it. Once done, find the %value% tag
                sToReplace := Copy(sTemp, TagO, Length(sTemp) - Pos('</' + sTag + '>', sTemp) + Length('</' + sTag + '>'));
                sReplaceValue := StringReplace(sToReplace, '%value%', strTags.Values[sTag], [rfReplaceAll, rfIgnoreCase]);
                sTemp := StringReplace(sTemp, sToReplace, sReplaceValue, [rfReplaceAll, rfIgnoreCase]);
              end;
            end;
          end;
        until TagO <> 0;

        Result := strTemplate.Text;
        strTags.Free;
        strTemplate.Free;
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
var
  x: Integer;
begin
  if Assigned(lvwParams.Selected) then
  begin
    lvwParams.Items.Delete(lvwParams.Selected.Index);

    if lvwParams.Items.Count > 0 then
      lvwParams.Selected := lvwParams.Items[0];
      
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

procedure TfrmFctHdrBld.lvwParamsDblClick(Sender: TObject);
begin
  tbtnEdit.Click;
end;

end.
