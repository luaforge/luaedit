unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ShellAPI;

type
  TfrmAbout = class(TForm)
    btnClose: TButton;
    GroupBox1: TGroupBox;
    lblVersion: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    imgLuaLogo: TImage;
    Label5: TLabel;
    Label6: TLabel;
    lblMemory: TLabel;
    lblOS: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image1: TImage;
    Label10: TLabel;
    Label1: TLabel;
    procedure imgLuaLogoClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetTotalMemsize: String;
  end;

var
  frmAbout: TfrmAbout;

function GetFileVersion(const FileName: PChar): PChar; cdecl; external 'LuaEditSys.dll';
function GetOSInfo: PChar; cdecl; external 'LuaEditSys.dll';

implementation

uses Math;

{$R *.dfm}

procedure TfrmAbout.imgLuaLogoClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', 'http://www.lua.org', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  lblOS.Caption := GetOSInfo;
  lblMemory.Caption := GetTotalMemsize;
  lblVersion.Caption := GetFileVersion(PChar(Application.ExeName));
end;

function TfrmAbout.GetTotalMemsize: String;
var
  pMemStatus: TMemoryStatus;
  TotalMem: Cardinal;
begin
  pMemStatus.dwLength := SizeOf(TMemoryStatus);
  GlobalMemoryStatus(pMemStatus);
  TotalMem := Ceil(pMemStatus.dwTotalPhys / 1024);
  Result := IntToStr(TotalMem)+' KB';
end;

procedure TfrmAbout.Label7Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', 'mailto:gouletje@vif.com?subject=About LuaEdit...', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.Image1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', 'http://luaedit.luaforge.net', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.Label1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', 'mailto:luaedit.support@vif.com?subject=LuaEdit Support...', nil, nil, SW_SHOWNORMAL);
end;

end.
