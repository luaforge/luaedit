unit PrjSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Main, Mask, JvExMask, JvSpin;

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
    procedure FormShow(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure txtIPKeyPress(Sender: TObject; var Key: Char);
    procedure txtPortKeyPress(Sender: TObject; var Key: Char);
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
end;

//Validate a Port number. Expected Format: x (x in [1024..65535])
function TfrmPrjOptions.IsPortNumber(Port: Integer): Boolean;
begin
  Result := True;
  
  if Port < 1024 then
    Result := False;

  if Port > 65535 then
    Result := False;
end;

//Validate an IP address. Expected format: xxx.xxx.xxx.xxx (xxx in [0..255])
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
  else
  begin
    ModalResult := mrOk;
  end;
end;

procedure TfrmPrjOptions.txtIPKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8, '.']) then
    Key := #0;
end;

procedure TfrmPrjOptions.txtPortKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

function TfrmPrjOptions.GetLastChar(sLine: String): String;
begin
  Result := Copy(sLine, Length(sLine), 1);
end;

end.
