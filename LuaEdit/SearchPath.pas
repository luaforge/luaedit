unit SearchPath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvComponent, JvBaseDlg, JvBrowseFolder,
  JvExStdCtrls, JvListBox, JvDotNetControls, Mask, JvExMask, JvToolEdit;

type
  TfrmSearchPath = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnDeleteInvalid: TButton;
    btnReplace: TButton;
    txtSearchPath: TJvDotNetDirectoryEdit;
    lstSearchPath: TJvDotNetListBox;
    lblMessage: TLabel;
    btnCancel: TButton;
    btnOk: TButton;
    procedure FormShow(Sender: TObject);
    procedure lstSearchPathDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure txtSearchPathButtonClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure lstSearchPathClick(Sender: TObject);
    procedure btnDeleteInvalidClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitSearchPathForm(SearchPathString, SearchPathFormTitle, SearchPathMessage: String);
    function GetSearchPathString(): String;
  end;

var
  frmSearchPath: TfrmSearchPath;

implementation

{$R *.dfm}

procedure TfrmSearchPath.InitSearchPathForm(SearchPathString, SearchPathFormTitle, SearchPathMessage: String);
begin
  // Initialize a few things before filling
  lstSearchPath.Clear;
  lstSearchPath.Items.CommaText := SearchPathString;
  Self.Caption := SearchPathFormTitle;
  lblMessage.Caption := SearchPathMessage;
end;

function TfrmSearchPath.GetSearchPathString(): String;
begin
  Result := lstSearchPath.Items.CommaText;
end;

procedure TfrmSearchPath.FormShow(Sender: TObject);
begin
  if lstSearchPath.Count > 0 then
  begin
    lstSearchPath.Selected[0] := True;
    txtSearchPath.Text := lstSearchPath.Items[0];
  end;
end;

procedure TfrmSearchPath.lstSearchPathDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  // if current item is selected, simply use white
  if odSelected in State then
  begin
    lstSearchPath.Canvas.Font.Color := clWhite;
  end
  else
  begin
    // Determine color of font to use according existance of the directory
    if DirectoryExists(lstSearchPath.Items[Index]) then
      lstSearchPath.Canvas.Font.Color := clBlack
    else
      lstSearchPath.Canvas.Font.Color := lstSearchPath.DisabledTextColor;
  end;

  // Draw the text
  lstSearchPath.Canvas.TextRect(Rect, Rect.Left, Rect.Top, '  '+lstSearchPath.Items[Index]);
end;

procedure TfrmSearchPath.txtSearchPathButtonClick(Sender: TObject);
begin
  if DirectoryExists(txtSearchPath.Text) then
    txtSearchPath.InitialDir := txtSearchPath.Text
  else
    txtSearchPath.InitialDir := ExtractFilePath(Application.ExeName);
end;

procedure TfrmSearchPath.btnAddClick(Sender: TObject);
var
  ItemInList: Boolean;
  FormatedPath: String;
  x: Integer;
begin
  if txtSearchPath.Text <> '' then
  begin
    // Initialize stuff
    ItemInList := False;

    // Format search path to add (add '\' character if none)
    if Copy(txtSearchPath.Text, Length(txtSearchPath.Text), 1) <> '\' then
      FormatedPath := txtSearchPath.Text + '\'
    else
      FormatedPath := txtSearchPath.Text;

    // Search for new path in list
    for x := 0 to lstSearchPath.Count - 1 do
    begin
      if lstSearchPath.Items[x] = FormatedPath then
        ItemInList := True;
    end;

    // Add path to list only if not already in the list
    if not ItemInList then
      lstSearchPath.Items.Add(FormatedPath);

    btnReplace.Enabled := (lstSearchPath.ItemIndex <> -1);
    btnDelete.Enabled := (lstSearchPath.ItemIndex <> -1);
    btnDeleteInvalid.Enabled := (lstSearchPath.Count > 0);
  end;
end;

procedure TfrmSearchPath.btnReplaceClick(Sender: TObject);
begin
  // Replace selected item by new path if any item is selected
  if lstSearchPath.ItemIndex <> -1 then
    lstSearchPath.Items[lstSearchPath.ItemIndex] := txtSearchPath.Text;
end;

procedure TfrmSearchPath.lstSearchPathClick(Sender: TObject);
begin
  btnReplace.Enabled := (lstSearchPath.ItemIndex <> -1);
  btnDelete.Enabled := (lstSearchPath.ItemIndex <> -1);

  if lstSearchPath.ItemIndex <> -1 then
    txtSearchPath.Text := lstSearchPath.Items[lstSearchPath.ItemIndex]
  else
    txtSearchPath.Text := '';
end;

procedure TfrmSearchPath.btnDeleteClick(Sender: TObject);
var
  DeletedIndex: Integer;
begin
  DeletedIndex := lstSearchPath.ItemIndex;
  
  // Delete currently selected item if any
  if lstSearchPath.ItemIndex <> -1 then
    lstSearchPath.Items.Delete(lstSearchPath.ItemIndex);

  // Select next or previous in the list if any
  if ((lstSearchPath.Count > 0) and (DeletedIndex <> -1)) then
  begin
    if lstSearchPath.Count >= DeletedIndex + 1 then
      lstSearchPath.Selected[DeletedIndex] := True
    else
      lstSearchPath.Selected[DeletedIndex - 1] := True;
  end;

  btnReplace.Enabled := (lstSearchPath.ItemIndex <> -1);
  btnDelete.Enabled := (lstSearchPath.ItemIndex <> -1);
  btnDeleteInvalid.Enabled := (lstSearchPath.Count > 0);
end;

procedure TfrmSearchPath.btnDeleteInvalidClick(Sender: TObject);
var
  x: Integer;
begin
  for x := lstSearchPath.Items.Count - 1 downto 0 do
  begin
    if not DirectoryExists(lstSearchPath.Items[x]) then
      lstSearchPath.Items.Delete(x);
  end;
end;

procedure TfrmSearchPath.btnOkClick(Sender: TObject);
begin
  btnAdd.Click;
  ModalResult := mrOk;
end;

end.
