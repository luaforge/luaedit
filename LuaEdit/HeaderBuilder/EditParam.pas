unit EditParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmEditParam = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    Label1: TLabel;
    Label2: TLabel;
    txtName: TEdit;
    txtComment: TEdit;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditParam: TfrmEditParam;

implementation

{$R *.dfm}

procedure TfrmEditParam.btnOKClick(Sender: TObject);
begin
  ModalResult := mrNone;
  
  if txtName.Text = '' then
  begin
    Windows.MessageBox(Self.Handle, 'You must enter a name for the parameter.', 'Header Builder', MB_OK+MB_ICONERROR);
    txtName.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

end.
