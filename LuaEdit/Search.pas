unit Search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

const
  SR_FOWARD      = 0;
  SR_BACKWARD    = 1;
  SR_FROMCURSOR  = 0;
  SR_ENTIRESCOPE = 1;
  SR_GLOBAL      = 0;
  SR_SELECTED    = 1;

type
  TfrmSearch = class(TForm)
    Label1: TLabel;
    cboSearchText: TComboBox;
    gbSearchOptions: TGroupBox;
    chkSearchCaseSensitive: TCheckBox;
    chkSearchWholeWords: TCheckBox;
    chkRegularExpression: TCheckBox;
    optDirection: TRadioGroup;
    btnOK: TButton;
    btnCancel: TButton;
    optScope: TRadioGroup;
    optOrigin: TRadioGroup;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SearchText: String;
    function IsCaseSensitive: Boolean;
    function IsWholeWordOnly: Boolean;
    function IsResgularExpression: Boolean;
    function GetDirection: Integer;
    function GetScope: Integer;
    function GetOrigin: Integer;
  end;

var
  frmSearch: TfrmSearch;

implementation

{$R *.dfm}

procedure TfrmSearch.btnOKClick(Sender: TObject);
begin
  if cboSearchText.Text <> '' then
  begin
    SearchText := cboSearchText.Text;
    Self.Close;
  end
  else
  begin
    Application.MessageBox('The search string cannot be blank.', 'LuaEdit', MB_OK+MB_ICONERROR);
  end;
end;

procedure TfrmSearch.btnCancelClick(Sender: TObject);
begin
  SearchText := '';
  Self.Close;
end;

function TfrmSearch.IsCaseSensitive: Boolean;
begin
  Result := chkSearchCaseSensitive.Checked;
end;

function TfrmSearch.IsWholeWordOnly: Boolean;
begin
  Result := chkSearchWholeWords.Checked;
end;

function TfrmSearch.IsResgularExpression: Boolean;
begin
  Result := chkRegularExpression.Checked;
end;

function TfrmSearch.GetDirection: Integer;
begin
  Result := optDirection.ItemIndex;
end;

function TfrmSearch.GetScope: Integer;
begin
  Result := optScope.ItemIndex;
end;

function TfrmSearch.GetOrigin: Integer;
begin
  Result := optOrigin.ItemIndex;
end;

procedure TfrmSearch.FormCreate(Sender: TObject);
begin
  SearchText := '';
end;

procedure TfrmSearch.FormShow(Sender: TObject);
begin
  cboSearchText.SetFocus;
end;

end.
