unit ReadOnlyMsgBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmReadOnlyMsgBox = class(TForm)
    imgIcon: TImage;
    lblMessage: TLabel;
    Label2: TLabel;
    pnlButtons: TPanel;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function MessageBox(sMsg: String; sCaption: String): Integer;
  end;

var
  frmReadOnlyMsgBox: TfrmReadOnlyMsgBox;

implementation

{$R *.dfm}

function TfrmReadOnlyMsgBox.MessageBox(sMsg: String; sCaption: String): Integer;
begin
  // Initialize form first
  imgIcon.Picture.Icon.Handle := LoadIcon(0, IDI_EXCLAMATION);
  Caption := sCaption;
  lblMessage.Caption := sMsg;

  // Show the form
  Result := ShowModal;
end;

procedure TfrmReadOnlyMsgBox.FormShow(Sender: TObject);
begin
  MessageBeep(MB_ICONEXCLAMATION);
end;

procedure TfrmReadOnlyMsgBox.FormResize(Sender: TObject);
begin
  // Center button panel in the middle of the form
  pnlButtons.Left := (Width - pnlButtons.Width) div 2;
  Left := (Screen.Width - Width) div 2;
end;

end.
