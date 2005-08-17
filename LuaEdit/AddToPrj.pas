unit AddToPrj;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Registry;

type
  TfrmAddToPrj = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    btnBrowse: TButton;
    txtExistingFile: TEdit;
    chkExisting: TRadioButton;
    chkNew: TRadioButton;
    odlgOpenUnit: TOpenDialog;
    lblEG1: TLabel;
    lblEG2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure chkExistingClick(Sender: TObject);
    procedure chkNewClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    lstFiles: TStringList;
  end;

var
  frmAddToPrj: TfrmAddToPrj;

implementation

{$R *.dfm}

procedure TfrmAddToPrj.FormShow(Sender: TObject);
begin
  txtExistingFile.Text := '';
  txtExistingFile.Enabled := False;
  btnBrowse.Enabled := False;
  lblEG1.Enabled := False;
  lblEG2.Enabled := False;
  chkNew.Checked := True;
  lstFiles.Clear;
end;

procedure TfrmAddToPrj.chkExistingClick(Sender: TObject);
begin
  txtExistingFile.Enabled := True;
  btnBrowse.Enabled := True;
  lblEG1.Enabled := True;
  lblEG2.Enabled := True;
end;

procedure TfrmAddToPrj.chkNewClick(Sender: TObject);
begin
  txtExistingFile.Enabled := False;
  btnBrowse.Enabled := False;
  lblEG1.Enabled := False;
  lblEG2.Enabled := False;
end;

procedure TfrmAddToPrj.btnBrowseClick(Sender: TObject);
var
  pReg: TRegistry;
begin
  pReg := TRegistry.Create;

  if pReg.OpenKey('\Software\LuaEdit', False) then
    odlgOpenUnit.InitialDir := pReg.ReadString('RecentPath');

  if odlgOpenUnit.Execute then
  begin
    txtExistingFile.Text := odlgOpenUnit.Files.CommaText;
  end;

  pReg.Free;
end;

procedure TfrmAddToPrj.FormCreate(Sender: TObject);
begin
  lstFiles := TStringList.Create;
  lstFiles.QuoteChar := '"';
  lstFiles.Delimiter := ',';
end;

procedure TfrmAddToPrj.FormDestroy(Sender: TObject);
begin
  lstFiles.Free;
end;

procedure TfrmAddToPrj.btnOKClick(Sender: TObject);
var
  x: Integer;
begin
  if chkExisting.Checked then
  begin
    lstFiles.DelimitedText := txtExistingFile.Text;
    ModalResult := mrOk;

    for x := 0 to lstFiles.Count - 1 do
    begin
      if not FileExists(lstFiles.Strings[x]) then
      begin
        Application.MessageBox(PChar('The file "'+lstFiles.Strings[x]+'" is innexistant.'), 'LuaEdit', MB_OK+MB_ICONERROR);
        ModalResult := mrNone;
      end;
    end;
  end;
end;

end.
