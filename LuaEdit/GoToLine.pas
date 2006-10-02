unit GoToLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmGotoLine = class(TForm)
    Label1: TLabel;
    txtLineNumber: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure txtLineNumberKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LineNumber: Integer;
  end;

var
  frmGotoLine: TfrmGotoLine;

implementation

{$R *.dfm}

procedure TfrmGotoLine.btnOKClick(Sender: TObject);
begin
  if txtLineNumber.Text <> '' then
  begin
    LineNumber := StrToInt(txtLineNumber.Text);
  end
  else
  begin
    ModalResult := mrNone;
    Application.MessageBox('Please enter a line number.', 'LuaEdit', MB_OK+MB_ICONERROR);
  end;
end;

procedure TfrmGotoLine.txtLineNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if ((not (Ord(Key) in [48..57])) and (not (Ord(Key) = 8))) then
    Key := Char(0);
end;

procedure TfrmGotoLine.FormCreate(Sender: TObject);
begin
  txtLineNumber.Text := '';
end;

procedure TfrmGotoLine.FormShow(Sender: TObject);
begin
  txtLineNumber.SetFocus;
end;

end.
