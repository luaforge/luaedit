unit AsciiTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmAsciiTable = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnClose: TButton;
    memoAsciiTable: TMemo;
    btnGetValue: TButton;
    txtAscii: TEdit;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnGetValueClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAsciiTable: TfrmAsciiTable;

implementation

{$R *.dfm}

procedure TfrmAsciiTable.FormShow(Sender: TObject);
begin
  txtAscii.Text := '';
  memoAsciiTable.Lines.Clear;
  memoAsciiTable.Lines.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Help\AsciiTable.txt');
end;

procedure TfrmAsciiTable.btnGetValueClick(Sender: TObject);
begin
  if txtAscii.Text <> '' then
    Application.MessageBox(PChar('Ascii code for '''+txtAscii.Text+''': '+IntToStr(Ord(txtAscii.Text[1]))), 'LuaEdit', MB_OK+MB_ICONINFORMATION);
end;

end.
