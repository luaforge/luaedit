unit ErrorLookup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmErrorLookup = class(TForm)
    Panel1: TPanel;
    txtErrorLookup: TEdit;
    btnLookUp: TButton;
    btnClose: TButton;
    Panel2: TPanel;
    memoErrorLookup: TMemo;
    procedure FormShow(Sender: TObject);
    procedure btnLookUpClick(Sender: TObject);
    procedure txtErrorLookupKeyPress(Sender: TObject; var Key: Char);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmErrorLookup: TfrmErrorLookup;

implementation

uses Math;

{$R *.dfm}

procedure TfrmErrorLookup.FormShow(Sender: TObject);
begin
  memoErrorLookup.Lines.Clear;
  txtErrorLookup.Text := '';
end;

procedure TfrmErrorLookup.btnLookUpClick(Sender: TObject);
begin
  try
    memoErrorLookup.Lines.Clear;
    if SysErrorMessage(StrToInt(txtErrorLookup.Text)) <> '' then
      memoErrorLookup.Text := SysErrorMessage(StrToInt(txtErrorLookup.Text))
    else
      Application.MessageBox('The specified message number does not represent a Windows NT message.', 'LuaEdit', MB_OK+MB_ICONERROR);
  except
    Application.MessageBox(PChar('The expression "'+txtErrorLookup.Text+'" is not numeric.'), 'LuaEdit', MB_OK+MB_ICONERROR);
    txtErrorLookup.SetFocus;
  end;
end;

procedure TfrmErrorLookup.txtErrorLookupKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmErrorLookup.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

end.
