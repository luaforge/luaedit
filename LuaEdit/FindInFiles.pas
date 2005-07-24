unit FindInFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit, ExtCtrls, JvExStdCtrls,
  JvRadioButton;

type
  TfrmFindInFiles = class(TForm)
    cboSearchInFilesText: TComboBox;
    Label1: TLabel;
    gbSearchOptions: TGroupBox;
    chkSearchCaseSensitive: TCheckBox;
    chkSearchWholeWords: TCheckBox;
    chkRegularExpression: TCheckBox;
    fraDirectory: TGroupBox;
    jvdirDirectory: TJvDirectoryEdit;
    Label2: TLabel;
    optOutput: TRadioGroup;
    btnOK: TButton;
    btnCancel: TButton;
    chkIncludeSubdir: TCheckBox;
    fraWhere: TGroupBox;
    jvoptFilesInDir: TJvRadioButton;
    jvoptActiveProject: TJvRadioButton;
    jvoptOpenFiles: TJvRadioButton;
    procedure btnOKClick(Sender: TObject);
    procedure optWhereClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SearchText: String;
    SearchDirectory: String;
    function IsCaseSensitive: Boolean;
    function IsWholeWordOnly: Boolean;
    function IsResgularExpression: Boolean;
    function IsSubDir: Boolean;
    function GetSearchMode: Integer;
    procedure SetSearchMode(Index: Integer);
    function GetOutput: Integer;
  end;

var
  frmFindInFiles: TfrmFindInFiles;

implementation

uses Main;

{$R *.dfm}

procedure TfrmFindInFiles.btnOKClick(Sender: TObject);
begin
  if cboSearchInFilesText.Text <> '' then
  begin
    SearchText := cboSearchInFilesText.Text;
    SearchDirectory := jvdirDirectory.Text;
    Self.Close;
  end
  else
  begin
    Application.MessageBox('The search string cannot be blank.', 'LuaEdit', MB_OK+MB_ICONERROR);
  end;
end;

procedure TfrmFindInFiles.btnCancelClick(Sender: TObject);
begin
  SearchText := '';
  SearchDirectory := '';
  Self.Close;
end;

procedure TfrmFindInFiles.optWhereClick(Sender: TObject);
begin
  fraDirectory.Enabled := (GetSearchMode = 2);
  jvdirDirectory.Enabled := (GetSearchMode = 2);
  chkIncludeSubdir.Enabled := (GetSearchMode = 2);
end;

function TfrmFindInFiles.IsCaseSensitive: Boolean;
begin
  Result := chkSearchCaseSensitive.Checked;
end;

function TfrmFindInFiles.IsWholeWordOnly: Boolean;
begin
  Result := chkSearchWholeWords.Checked;
end;

function TfrmFindInFiles.IsResgularExpression: Boolean;
begin
  Result := chkRegularExpression.Checked;
end;

function TfrmFindInFiles.IsSubDir: Boolean;
begin
  Result := chkIncludeSubdir.Checked;
end;

function TfrmFindInFiles.GetSearchMode: Integer;
begin
  // Retreive mode through radio buttons
  if jvoptActiveProject.Checked then
    Result := 0
  else if jvoptOpenFiles.Checked then
    Result := 1
  else
    Result := 2;
end;

procedure TfrmFindInFiles.SetSearchMode(Index: Integer);
begin
  // Set mode through radio buttons

  case Index of
    0:
    begin
      if jvoptActiveProject.Enabled then
        jvoptActiveProject.Checked := True
      else
        SetSearchMode(2);
    end;
    1:
    begin
      if jvoptOpenFiles.Enabled then
        jvoptOpenFiles.Checked := True
      else
        SetSearchMode(2);
    end;
    2:  jvoptFilesInDir.Checked := True;
  end;
end;

function TfrmFindInFiles.GetOutput: Integer;
begin
  Result := optOutput.ItemIndex;
end;

procedure TfrmFindInFiles.FormShow(Sender: TObject);
begin
  optWhereClick(nil);
end;

end.
