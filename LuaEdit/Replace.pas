unit Replace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmReplace = class(TForm)
    Label1: TLabel;
    cboSearchText: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    cboReplaceText: TComboBox;
    optScope: TRadioGroup;
    optOrigin: TRadioGroup;
    optDirection: TRadioGroup;
    gbSearchOptions: TGroupBox;
    chkSearchCaseSensitive: TCheckBox;
    chkSearchWholeWords: TCheckBox;
    chkRegularExpression: TCheckBox;
    btnReplaceAll: TButton;
    chkPrompt: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SearchText: String;
    ReplaceText: String;
    function IsCaseSensitive: Boolean;
    function IsWholeWordOnly: Boolean;
    function IsResgularExpression: Boolean;
    function IsReplaceAll: Boolean;
    function IsPromptForReplace: Boolean;
    function GetDirection: Integer;
    function GetScope: Integer;
    function GetOrigin: Integer;
  end;

var
  frmReplace: TfrmReplace;
  bReplaceAll: Boolean;

implementation

{$R *.dfm}

function TfrmReplace.IsCaseSensitive: Boolean;
begin
  Result := chkSearchCaseSensitive.Checked;
end;

function TfrmReplace.IsWholeWordOnly: Boolean;
begin
  Result := chkSearchWholeWords.Checked;
end;

function TfrmReplace.IsResgularExpression: Boolean;
begin
  Result := chkRegularExpression.Checked;
end;

function TfrmReplace.IsReplaceAll: Boolean;
begin
  Result := bReplaceAll;
end;

function TfrmReplace.IsPromptForReplace: Boolean;
begin
  Result := chkPrompt.Checked
end;

function TfrmReplace.GetDirection: Integer;
begin
  Result := optDirection.ItemIndex;
end;

function TfrmReplace.GetScope: Integer;
begin
  Result := optScope.ItemIndex;
end;

function TfrmReplace.GetOrigin: Integer;
begin
  Result := optOrigin.ItemIndex;
end;

procedure TfrmReplace.btnOKClick(Sender: TObject);
begin
  if cboSearchText.Text <> '' then
  begin
    SearchText := cboSearchText.Text;
    ReplaceText := cboReplaceText.Text;
    Self.Close;
  end
  else
  begin
    Application.MessageBox('The search string cannot be blank.', 'LuaEdit', MB_OK+MB_ICONERROR);
  end;
end;

procedure TfrmReplace.btnCancelClick(Sender: TObject);
begin
  ReplaceText := '';
  SearchText := '';
  Self.Close;
end;

procedure TfrmReplace.FormCreate(Sender: TObject);
begin
  bReplaceAll := False;
  ReplaceText := '';
  SearchText := '';
end;

procedure TfrmReplace.btnReplaceAllClick(Sender: TObject);
begin
  bReplaceAll := True;
  btnOk.Click;
end;

procedure TfrmReplace.FormShow(Sender: TObject);
begin
  cboSearchText.SetFocus;
end;

end.
