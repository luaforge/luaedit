unit GUID;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActiveX;

type
  TfrmGUID = class(TForm)
    txtGUID: TEdit;
    btnClose: TButton;
    btnGenerate: TButton;
    procedure btnGenerateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGUID: TfrmGUID;

implementation

{$R *.dfm}

procedure TfrmGUID.btnGenerateClick(Sender: TObject);
var
  pGUID: TGUID;
begin
  CoCreateGUID(pGUID);
  txtGUID.Text := GUIDToString(pGUID);
  txtGUID.SetFocus;
end;

procedure TfrmGUID.FormShow(Sender: TObject);
begin
  btnGenerate.Click;
  txtGUID.SetFocus;
end;

end.
