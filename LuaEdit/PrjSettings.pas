unit PrjSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Main, Mask, JvExMask, JvSpin,
  JvExStdCtrls, JvEdit, JvValidateEdit, JvPageList, JvExControls, Misc,
  JvComponent, JvExComCtrls, JvPageListTreeView, ImgList, JvGroupHeader,
  JvBaseDlg, JvSelectDirectory, JvDotNetControls;

type
  TfrmPrjOptions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    odlgSelectFile: TOpenDialog;
    jvPageListSettings: TJvPageList;
    JvStandardPage1: TJvStandardPage;
    Label1: TLabel;
    txtPrjName: TEdit;
    Label7: TLabel;
    spinMajorVersion: TJvSpinEdit;
    spinMinorVersion: TJvSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    spinReleaseVersion: TJvSpinEdit;
    Label11: TLabel;
    spinRevisionVersion: TJvSpinEdit;
    chkAutoIncRevNumber: TCheckBox;
    JvStandardPage2: TJvStandardPage;
    Label3: TLabel;
    jvspinPort: TJvSpinEdit;
    txtIP1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    txtIP2: TEdit;
    Label6: TLabel;
    txtIP3: TEdit;
    Label12: TLabel;
    txtIP4: TEdit;
    txtUploadDir: TEdit;
    Label13: TLabel;
    JvStandardPage3: TJvStandardPage;
    Label2: TLabel;
    txtDebugInitializer: TEdit;
    btnBrowseFile: TButton;
    imlPrjSettings: TImageList;
    jvSettingsTVSettings: TJvSettingsTreeView;
    JvGroupHeader1: TJvGroupHeader;
    JvGroupHeader2: TJvGroupHeader;
    JvGroupHeader3: TJvGroupHeader;
    JvGroupHeader4: TJvGroupHeader;
    Label14: TLabel;
    txtRuntimeDir: TEdit;
    btnBrowseDir: TButton;
    Label15: TLabel;
    cboUnits: TComboBox;
    jvSelectDir: TJvSelectDirectory;
    Splitter1: TSplitter;
    JvGroupHeader8: TJvGroupHeader;
    JvGroupHeader5: TJvGroupHeader;
    JvGroupHeader6: TJvGroupHeader;
    jvspinConnectTimeOut: TJvSpinEdit;
    Label16: TLabel;
    Label17: TLabel;
    txtCompileDir: TEdit;
    Label8: TLabel;
    btnBrowseDir2: TButton;
    Label18: TLabel;
    txtCompileExt: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnBrowseFileClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure txtIP1KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP2KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP3KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP4KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP1Exit(Sender: TObject);
    procedure txtIP2Exit(Sender: TObject);
    procedure txtIP3Exit(Sender: TObject);
    procedure txtIP4Exit(Sender: TObject);
    procedure btnBrowseDirClick(Sender: TObject);
    procedure txtUploadDirExit(Sender: TObject);
    procedure btnBrowseDir2Click(Sender: TObject);
    procedure txtCompileExtExit(Sender: TObject);
    procedure txtCompileDirExit(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GetLuaProjectOptions(pLuaPrj: TLuaEditProject);
    procedure SetLuaProjectOptions(pLuaPrj: TLuaEditProject);
    function IsIP(IP: String): Boolean;
    function IsPortNumber(Port: Integer): Boolean;
    function GetLastChar(sLine: String): String;
  end;

var
  frmPrjOptions: TfrmPrjOptions;

implementation

{$R *.dfm}

procedure TfrmPrjOptions.FormShow(Sender: TObject);
begin
  jvPageListSettings.ActivePageIndex := 0;
  jvSettingsTVSettings.Selected := jvSettingsTVSettings.Items[1];
end;

procedure TfrmPrjOptions.GetLuaProjectOptions(pLuaPrj: TLuaEditProject);
var
  sTemp: String;

  function ExtractNextIPPart(sIn: String): String;
  begin
    Result := Copy(sIn, 1, Pos('.', sIn) - 1);
  end;

  function TruncateToNextIPPart(sIn: String): String;
  begin
    Result := Copy(sIn, Pos('.', sIn) + 1, Length(sIn) - Pos('.', sIn));
  end;

  procedure FillTargetList(pPrj: TLuaEditProject);
  var
    x: Integer;
    pLuaUnit: TLuaEditUnit;
  begin
    cboUnits.Clear;
    cboUnits.AddItem('[Current Unit]', nil);
    cboUnits.ItemIndex := 0;

    for x := 0 to pPrj.lstUnits.Count - 1 do
    begin
      pLuaUnit := pPrj.lstUnits[x];
      cboUnits.AddItem(pLuaUnit.Name, pLuaUnit);

      if pLuaUnit.Name = pPrj.sTargetLuaUnit then
        cboUnits.ItemIndex := x + 1;
    end;
  end;
begin
  // Get General Options
  txtPrjName.Text := pLuaPrj.Name;
  spinMajorVersion.Value := pLuaPrj.iVersionMajor;
  spinMinorVersion.Value := pLuaPrj.iVersionMinor;
  spinReleaseVersion.Value := pLuaPrj.iVersionRelease;
  spinRevisionVersion.Value := pLuaPrj.iVersionRevision;
  chkAutoIncRevNumber.Checked := pLuaPrj.AutoIncRevNumber;

  // Get Debug Options
  txtDebugInitializer.Text := pLuaPrj.sInitializer;
  jvspinConnectTimeOut.Value := pLuaPrj.iConnectTimeOut;
  jvspinPort.Value := pLuaPrj.iRemotePort;

  // Extract all parts of the ip address
  sTemp := pLuaPrj.sRemoteIP;
  txtIP1.Text := ExtractNextIPPart(sTemp);
  sTemp := TruncateToNextIPPart(sTemp);
  txtIP2.Text := ExtractNextIPPart(sTemp);
  sTemp := TruncateToNextIPPart(sTemp);
  txtIP3.Text := ExtractNextIPPart(sTemp);
  sTemp := TruncateToNextIPPart(sTemp);
  txtIP4.Text := sTemp;

  txtUploadDir.Text := pLuaPrj.sRemoteDirectory;
  FillTargetList(pLuaPrj);
  txtRuntimeDir.Text := pLuaPrj.sRuntimeDirectory;
  txtCompileDir.Text := pLuaPrj.sCompileDirectory;
  txtCompileExt.Text := pLuaPrj.sCompileExtension;
end;

procedure TfrmPrjOptions.SetLuaProjectOptions(pLuaPrj: TLuaEditProject);
begin
  //Set general options
  pLuaPrj.Name := txtPrjName.Text;
  pLuaPrj.iVersionMajor := Round(spinMajorVersion.Value);
  pLuaPrj.iVersionMinor := Round(spinMinorVersion.Value);
  pLuaPrj.iVersionRelease := Round(spinReleaseVersion.Value);
  pLuaPrj.iVersionRevision := Round(spinRevisionVersion.Value);
  pLuaPrj.AutoIncRevNumber := chkAutoIncRevNumber.Checked;

  // Set debug options
  pLuaPrj.sInitializer := txtDebugInitializer.Text;
  pLuaPrj.iRemotePort := Trunc(jvspinPort.Value);
  pLuaPrj.iConnectTimeOut := Trunc(jvspinConnectTimeOut.Value);
  pLuaPrj.sRemoteIP := txtIP1.Text + '.' + txtIP2.Text + '.' + txtIP3.Text + '.' + txtIP4.Text;
  pLuaPrj.sRemoteDirectory := txtUploadDir.Text;
  pLuaPrj.sRuntimeDirectory := txtRuntimeDir.Text;
  pLuaPrj.sTargetLuaUnit := cboUnits.Text;
  pLuaPrj.sCompileDirectory := txtCompileDir.Text;
  pLuaPrj.sCompileExtension := txtCompileExt.Text;

  if cboUnits.Items.Objects[cboUnits.ItemIndex] <> nil then
    pLuaPrj.pTargetLuaUnit := TLuaEditUnit(cboUnits.Items.Objects[cboUnits.ItemIndex])
  else
    pLuaPrj.pTargetLuaUnit := nil;
end;

// Validate a Port number. Expected Format: x (x in [1024..65535])
function TfrmPrjOptions.IsPortNumber(Port: Integer): Boolean;
begin
  Result := True;

  if ((Port < 1024) or (Port > 65535)) then
    Result := False;
end;

// Validate an IP address. Expected format: xxx.xxx.xxx.xxx (xxx in [0..255])
function TfrmPrjOptions.IsIP(IP: String): Boolean;
var
  Sl: TStringList;
  Value, Code, i: Integer;
begin
  Result := True;
  Sl := TStringList.Create;

  try
    Sl.Delimiter := '.';
    Sl.QuoteChar := '"';
    Sl.DelimitedText := IP;

    if Sl.Count <> 4 then
    begin
      Result := False;
      Exit;
    end;

    for i := 0 to Sl.Count - 1 do
    begin
      Val(Sl[i], Value, Code);
      if Code <> 0 then
      begin
        Result := False;
        Break;
      end;

      if (Value < 0) or (Value > 255) then
      begin
        Result := False;
        Break;
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TfrmPrjOptions.btnBrowseFileClick(Sender: TObject);
begin
  odlgSelectFile.InitialDir := ExtractFileDir(txtDebugInitializer.Text);
  odlgSelectFile.Title := 'Select Initializer...';
  odlgSelectFile.Filter := 'Application Extension (*.dll)|*.dll';

  if odlgSelectFile.Execute then
    txtDebugInitializer.Text := odlgSelectFile.FileName;
end;

procedure TfrmPrjOptions.btnBrowseDirClick(Sender: TObject);
begin
  jvSelectDir.InitialDir := txtRuntimeDir.Text;
  jvSelectDir.Title := 'Select Runtime Directory...';

  if jvSelectDir.Execute then
  begin
    txtRuntimeDir.Text := jvSelectDir.Directory;
    txtRuntimeDir.SetFocus;
  end;
end;

procedure TfrmPrjOptions.btnBrowseDir2Click(Sender: TObject);
begin
  jvSelectDir.InitialDir := txtCompileDir.Text;
  jvSelectDir.Title := 'Select Compilation Output Directory...';

  if jvSelectDir.Execute then
  begin
    txtCompileDir.Text := jvSelectDir.Directory;
    txtCompileDir.SetFocus;
  end;
end;

procedure TfrmPrjOptions.btnOkClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if txtPrjName.Text = '' then
  begin
    Application.MessageBox('The project name can''t be empty.', 'LuaEdit', MB_OK+MB_ICONERROR);
    jvPageListSettings.ActivePageIndex := 0;
    txtPrjName.SetFocus;
  end
  else if txtCompileExt.Text = '' then
  begin
    Application.MessageBox('The compilation extension can''t be empty.', 'LuaEdit', MB_OK+MB_ICONERROR);
    jvPageListSettings.ActivePageIndex := 2;
    txtCompileExt.SetFocus;
  end
  else if not IsPortNumber(Trunc(jvspinPort.Value)) then
  begin
    Application.MessageBox('The remote port number is invalid. Value must be between 1024 and 65535.', 'LuaEdit', MB_OK+MB_ICONERROR);
    jvPageListSettings.ActivePageIndex := 1;
    jvspinPort.SetFocus;
  end
  else if not IsIP(txtIP1.Text + '.' + txtIP2.Text + '.' + txtIP3.Text + '.' + txtIP4.Text) then
  begin
    Application.MessageBox('The remote IP address is invalid.', 'LuaEdit', MB_OK+MB_ICONERROR);
    jvPageListSettings.ActivePageIndex := 1;
    txtIP1.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

function TfrmPrjOptions.GetLastChar(sLine: String): String;
begin
  Result := '';

  if sLine <> '' then
    Result := sLine[Length(sLine)];
end;

procedure TfrmPrjOptions.txtIP1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9', '.', #8] then
  begin
    if txtIP1.SelLength <> 3 then
    begin
      if Key = '.' then
      begin
        txtIP2.SetFocus;
        Key := #0;
      end
      else if Length(txtIP1.Text) = 3 then
      begin
        txtIP2.Text := Key;
        txtIP2.SetFocus;
        txtIP2.SelStart := 1;
      end;
    end
    else if Key = '.' then
    begin
      txtIP2.SetFocus;
      Key := #0;
    end;
  end
  else
    Key := #0;
end;

procedure TfrmPrjOptions.txtIP2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9', '.', #8] then
  begin
    if txtIP2.SelLength <> 3 then
    begin
      if Key = '.' then
      begin
        txtIP3.SetFocus;
        Key := #0;
      end
      else
      begin
        if ((Key = #8) and (Length(txtIP2.Text) = 0)) then
        begin
          txtIP1.SetFocus;
        end
        else if Length(txtIP2.Text) = 3 then
        begin
          txtIP3.Text := Key;
          txtIP3.SetFocus;
          txtIP3.SelStart := 1;
        end;
      end;
    end
    else if Key = '.' then
    begin
      txtIP3.SetFocus;
      Key := #0;
    end;
  end
  else
    Key := #0;
end;

procedure TfrmPrjOptions.txtIP3KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9', '.', #8] then
  begin      
    if txtIP1.SelLength <> 3 then
    begin
      if Key = '.' then
      begin
        txtIP4.SetFocus;
        Key := #0;
      end
      else
      begin
        if ((Key = #8) and (Length(txtIP3.Text) = 0)) then
        begin
          txtIP2.SetFocus;
        end
        else if Length(txtIP3.Text) = 3 then
        begin
          txtIP4.Text := Key;
          txtIP4.SetFocus;
          txtIP4.SelStart := 1;
        end;
      end;
    end
    else if Key = '.' then
    begin
      txtIP4.SetFocus;
      Key := #0;
    end;
  end
  else
    Key := #0;
end;

procedure TfrmPrjOptions.txtIP4KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9', #8] then
  begin
    if ((Key = #8) and (Length(txtIP4.Text) = 0)) then
      txtIP3.SetFocus;
  end
  else
    Key := #0;
end;

procedure TfrmPrjOptions.txtIP1Exit(Sender: TObject);
begin
  if txtIP1.Text = '' then
    txtIP1.Text := '0';
end;

procedure TfrmPrjOptions.txtIP2Exit(Sender: TObject);
begin
  if txtIP2.Text = '' then
    txtIP2.Text := '0';
end;

procedure TfrmPrjOptions.txtIP3Exit(Sender: TObject);
begin
  if txtIP3.Text = '' then
    txtIP3.Text := '0';
end;

procedure TfrmPrjOptions.txtIP4Exit(Sender: TObject);
begin
  if txtIP4.Text = '' then
    txtIP4.Text := '0';
end;

procedure TfrmPrjOptions.txtUploadDirExit(Sender: TObject);
begin
  if ((txtUploadDir.Text <> '') and (txtUploadDir.Text[Length(txtUploadDir.Text)] <> '\')) then
    txtUploadDir.Text := txtUploadDir.Text + '\';
end;

procedure TfrmPrjOptions.txtCompileExtExit(Sender: TObject);
begin
  if txtCompileExt.Text <> '' then
  begin
    if txtCompileExt.Text[1] <> '.' then
      txtCompileExt.Text := '.' + txtCompileExt.Text;
  end;
end;

procedure TfrmPrjOptions.txtCompileDirExit(Sender: TObject);
begin
  if txtCompileDir.Text <> '' then
  begin
    if GetLastChar(txtCompileDir.Text) <> '\' then
      txtCompileDir.Text := txtCompileDir.Text + '\';
  end;
end;

end.
