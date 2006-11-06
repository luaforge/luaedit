unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ShellAPI, JvGIF, JvExControls,
  JvComponent, JvXPCore, JvXPButtons;

type
  TfrmAbout = class(TForm)
    btnClose: TButton;
    Image1: TImage;
    Label4: TLabel;
    lblVersion: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblMemory: TLabel;
    lblOS: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    imgLuaLogo: TImage;
    Image2: TImage;
    procedure imgLuaLogoClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetTotalMemsize: String;
  end;

var
  frmAbout: TfrmAbout;

implementation

uses Math, Misc;

{$R *.dfm}

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
  TotalMem := pMemStatus.dwTotalPhys;
  Result := GetFileSizeStr(TotalMem);
end;

procedure TfrmAbout.imgLuaLogoClick(Sender: TObject);
begin
  BrowseURL(PChar('http://www.lua.org'));
end;

procedure TfrmAbout.Label7Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar('mailto:' + Label7.Caption + '?subject=About LuaEdit...'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.Label1Click(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PChar('mailto:' + Label1.Caption + '?subject=LuaEdit Support...'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.Image3Click(Sender: TObject);
begin
  BrowseURL(PChar('http://www.luaedit.net'));
end;

procedure TfrmAbout.Image2Click(Sender: TObject);
begin
  BrowseURL(PChar('http://opensource.org/index.php'));
end;

procedure TfrmAbout.Label4Click(Sender: TObject);
begin
  BrowseURL(PChar('http://www.luaedit.net'));
end;

end.
