unit Splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, JvGIF;

type
  TfrmSplash = class(TForm)
    Shape1: TShape;
    Label3: TLabel;
    lblVersion: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    imlLua: TImage;
    imlLuaEditLogo: TImage;
    imgLogo: TImage;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSplash: TfrmSplash;

function GetFileVersion(const FileName: PChar): PChar; cdecl; external 'LuaEditSys.dll';

implementation

uses Main;

{$R *.dfm}

procedure TfrmSplash.FormShow(Sender: TObject);
begin
  lblVersion.Caption := TCaption(GetFileVersion(PChar(Application.ExeName)));
  frmMain.LoadEditorSettings;
end;

end.
