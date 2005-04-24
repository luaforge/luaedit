unit Contributors;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI;

type
  TfrmContributors = class(TForm)
    btnClose: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SendEMail(EMailAddress: String);
  end;

var
  frmContributors: TfrmContributors;

implementation

{$R *.dfm}

procedure TfrmContributors.SendEMail(EMailAddress: String);
begin
  ShellExecute(Self.Handle, 'open', PChar('mailto:'+EMailAddress+'?subject=About LuaEdit...'), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmContributors.Label2Click(Sender: TObject);
begin
  SendEMail(TLabel(Sender).Caption);
end;

end.
