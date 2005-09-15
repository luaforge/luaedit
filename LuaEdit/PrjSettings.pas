unit PrjSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Main, Mask, JvExMask, JvSpin,
  JvExStdCtrls, JvEdit, JvValidateEdit;

type
  TfrmPrjOptions = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    pgcPrjSettings: TPageControl;
    stabGeneral: TTabSheet;
    stabDebug: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    txtPrjName: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    txtDebugInitializer: TEdit;
    btnBrowse: TButton;
    odlgInitializer: TOpenDialog;
    Label7: TLabel;
    spinMajorVersion: TJvSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    spinMinorVersion: TJvSpinEdit;
    spinReleaseVersion: TJvSpinEdit;
    spinRevisionVersion: TJvSpinEdit;
    chkAutoIncRevNumber: TCheckBox;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    jvspinPort: TJvSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    txtUploadDir: TEdit;
    txtIP1: TEdit;
    txtIP2: TEdit;
    txtIP3: TEdit;
    txtIP4: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure txtIP1KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP2KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP3KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP4KeyPress(Sender: TObject; var Key: Char);
    procedure txtIP1Exit(Sender: TObject);
    procedure txtIP2Exit(Sender: TObject);
    procedure txtIP3Exit(Sender: TObject);
    procedure txtIP4Exit(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GetLuaProjectOptions(pLuaPrj: TLuaProject);
    procedure SetLuaProjectOptions(pLuaPrj: TLuaProject);
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
  pgcPrjSettings.ActivePageIndex := 0;
end;

procedure TfrmPrjOptions.GetLuaProjectOptions(pLuaPrj: TLuaProject);
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
begin
  // Get General Options
  txtPrjName.Text := pLuaPrj.sPrjName;
  spinMajorVersion.Value := pLuaPrj.iVersionMajor;
  spinMinorVersion.Value := pLuaPrj.iVersionMinor;
  spinReleaseVersion.Value := pLuaPrj.iVersionRelease;
  spinRevisionVersion.Value := pLuaPrj.iVersionRevision;
  chkAutoIncRevNumber.Checked := pLuaPrj.AutoIncRevNumber;

  // Get Debug Options
  txtDebugInitializer.Text := pLuaPrj.sInitializer;
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
end;

procedure TfrmPrjOptions.SetLuaProjectOptions(pLuaPrj: TLuaProject);
begin
  //Set general options
  pLuaPrj.sPrjName := txtPrjName.Text;
  pLuaPrj.iVersionMajor := Round(spinMajorVersion.Value);
  pLuaPrj.iVersionMinor := Round(spinMinorVersion.Value);
  pLuaPrj.iVersionRelease := Round(spinReleaseVersion.Value);
  pLuaPrj.iVersionRevision := Round(spinRevisionVersion.Value);
  pLuaPrj.AutoIncRevNumber := chkAutoIncRevNumber.Checked;

  // Set debug options
  pLuaPrj.sInitializer := txtDebugInitializer.Text;
  pLuaPrj.iRemotePort := Trunc(jvspinPort.Value);
  pLuaPrj.sRemoteIP := txtIP1.Text + '.' + txtIP2.Text + '.' + txtIP3.Text + '.' + txtIP4.Text;
  pLuaPrj.sRemoteDirectory := txtUploadDir.Text;
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

procedure TfrmPrjOptions.btnBrowseClick(Sender: TObject);
begin
  if odlgInitializer.Execute then
  begin
    txtDebugInitializer.Text := odlgInitializer.FileName;
  end;
end;

procedure TfrmPrjOptions.btnOkClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if txtPrjName.Text = '' then
  begin
    Application.MessageBox('The project name can''t be empty.', 'LuaEdit', MB_OK+MB_ICONERROR);
    pgcPrjSettings.ActivePageIndex := 0;
    txtPrjName.SetFocus;
  end
  else if not IsPortNumber(Trunc(jvspinPort.Value)) then
  begin
    Application.MessageBox('The remote port number is invalid. Value must be between 1024 and 65535.', 'LuaEdit', MB_OK+MB_ICONERROR);
    pgcPrjSettings.ActivePageIndex := 1;
    jvspinPort.SetFocus;
  end
  else if not IsIP(txtIP1.Text + '.' + txtIP2.Text + '.' + txtIP3.Text + '.' + txtIP4.Text) then
  begin
    Application.MessageBox('The remote IP address is invalid.', 'LuaEdit', MB_OK+MB_ICONERROR);
    pgcPrjSettings.ActivePageIndex := 1;
    txtIP1.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

function TfrmPrjOptions.GetLastChar(sLine: String): String;
begin
  Result := Copy(sLine, Length(sLine), 1);
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

end.
