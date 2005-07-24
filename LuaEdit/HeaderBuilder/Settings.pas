unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Registry, ToolWin, ImgList, XPMenu;

type
  TfrmSettings = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    Panel2: TPanel;
    pgcMain: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    odlgTemplate: TOpenDialog;
    txtFctTemplatePath: TEdit;
    btnBrowseFctTpl: TButton;
    TabSheet3: TTabSheet;
    btnEditFctTpl: TButton;
    Label2: TLabel;
    txtFileTemplatePath: TEdit;
    btnBrowseFileTpl: TButton;
    btnEditFileTpl: TButton;
    lvwTags: TListView;
    tlbMain: TToolBar;
    tbtnAddTag: TToolButton;
    tbtnRemoveTag: TToolButton;
    xmpMenuPainter: TXPMenu;
    imlToolbar: TImageList;
    tbtnEdit: TToolButton;
    procedure btnBrowseFctTplClick(Sender: TObject);
    procedure btnBrowseFileTplClick(Sender: TObject);
    procedure txtFileTemplatePathChange(Sender: TObject);
    procedure txtFctTemplatePathChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure tbtnRemoveTagClick(Sender: TObject);
    procedure tbtnAddTagClick(Sender: TObject);
    procedure tbtnEditClick(Sender: TObject);
    procedure lvwTagsDblClick(Sender: TObject);
  private
    { Private declarations }
    function Browse(sInitial: String): String;
    procedure CheckButtons;
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses EditTag;

{$R *.dfm}

function TfrmSettings.Browse(sInitial: String): String;
var
  pReg: TRegistry;
begin
  pReg := TRegistry.Create;
  Result := '';

  if sInitial = '' then
  begin
    if pReg.OpenKey('\Software\LuaEdit\HdrBld', False) then
      sInitial := pReg.ReadString('LastBrowsePath');
  end;

  odlgTemplate.InitialDir := sInitial;
  if odlgTemplate.Execute then
  begin
    Result := odlgTemplate.FileName;
    if pReg.OpenKey('\Software\LuaEdit\HdrBld', True) then
      pReg.WriteString('LastBrowsePath', ExtractFilePath(odlgTemplate.FileName));
  end;

  pReg.Free;
end;

procedure TfrmSettings.btnBrowseFctTplClick(Sender: TObject);
begin
  txtFctTemplatePath.Text := Browse(txtFctTemplatePath.Text);
end;

procedure TfrmSettings.btnBrowseFileTplClick(Sender: TObject);
begin
  txtFileTemplatePath.Text := Browse(txtFileTemplatePath.Text);
end;

procedure TfrmSettings.txtFileTemplatePathChange(Sender: TObject);
begin
  btnEditFileTpl.Enabled := (txtFileTemplatePath.Text <> '');
end;

procedure TfrmSettings.txtFctTemplatePathChange(Sender: TObject);
begin
  btnEditFctTpl.Enabled := (txtFctTemplatePath.Text <> '');
end;

procedure TfrmSettings.FormShow(Sender: TObject);
var
  pReg: TRegistry;
  strTags: TStringList;
  pItem: TListItem;
  x: Integer;
begin
  // Getting saved values from registry
  pReg := TRegistry.Create;
  pgcMain.ActivePageIndex := 0;

  // Loading Tags tab informations
  if pReg.OpenKey('\Software\LuaEdit\HdrBld\Tags', False) then
  begin
    strTags := TStringList.Create;
    pReg.GetValueNames(strTags);
    lvwTags.Clear;
    lvwTags.Items.BeginUpdate;

    for x := 0 to strTags.Count - 1 do
    begin
      pItem := lvwTags.Items.Add;
      pItem.Caption := strTags.Strings[x];
      pItem.SubItems.Add(pReg.ReadString(strTags.Strings[x]));
    end;

    lvwTags.Items.EndUpdate;
    strTags.Free;
  end;

  // Loading Funtions tab informations
  if pReg.OpenKey('\Software\LuaEdit\HdrBld\FunctionsHdr', False) then
  begin
    if pReg.ValueExists('Template') then
      txtFctTemplatePath.Text := pReg.ReadString('Template')
    else
      txtFctTemplatePath.Text := '';
  end;

  // Loading Files tab informations
  if pReg.OpenKey('\Software\LuaEdit\HdrBld\FilesHdr', False) then
  begin
    if pReg.ValueExists('Template') then
      txtFileTemplatePath.Text := pReg.ReadString('Template')
    else
      txtFileTemplatePath.Text := '';
  end;

  CheckButtons;
  pReg.Free;
end;

procedure TfrmSettings.btnOKClick(Sender: TObject);
var
  pReg: TRegistry;
  x: Integer;
begin
  // Saving informations in registry
  pReg := TRegistry.Create;

  // Writing Tags tab informations
  if pReg.OpenKey('\Software\LuaEdit\HdrBld\Tags', True) then
  begin
    for x := 0 to lvwTags.Items.Count - 1 do
      pReg.WriteString(lvwTags.Items[x].Caption, lvwTags.Items[x].SubItems.Strings[0]);
  end;

  // Writing Functions tab informations
  if pReg.OpenKey('\Software\LuaEdit\HdrBld\FunctionsHdr', True) then
  begin
    pReg.WriteString('Template', txtFctTemplatePath.Text);
  end;

  // Writing Files tab informations
  if pReg.OpenKey('\Software\LuaEdit\HdrBld\FilesHdr', True) then
  begin
    pReg.WriteString('Template', txtFileTemplatePath.Text);
  end;

  pReg.Free;
end;

procedure TfrmSettings.CheckButtons;
begin
  tbtnRemoveTag.Enabled := not (lvwTags.Items.Count = 0);
  tbtnEdit.Enabled := not (lvwTags.Items.Count = 0);
end;

procedure TfrmSettings.tbtnRemoveTagClick(Sender: TObject);
var
  x: Integer;
  pReg: TRegistry;
begin
  if Assigned(lvwTags.Selected) then
  begin
    pReg := TRegistry.Create;

    // Remove tag from registry
    if pReg.OpenKey('\Software\LuaEdit\HdrBld\Tags', False) then
      pReg.DeleteValue(lvwTags.Selected.Caption);

    pReg.Free;
    lvwTags.Items.Delete(lvwTags.Selected.Index);

    if lvwTags.Items.Count > 0 then
      lvwTags.Selected := lvwTags.Items[0];
      
    CheckButtons;
  end;
end;

procedure TfrmSettings.tbtnAddTagClick(Sender: TObject);
var
  pItem: TListItem;
begin
  pItem := lvwTags.Items.Add;
  pItem.Caption := '*New Tag*';
  pItem.SubItems.Add('');
  CheckButtons;
end;

procedure TfrmSettings.tbtnEditClick(Sender: TObject);
begin
  if Assigned(lvwTags.Selected) then
  begin
    frmEditTag := TfrmEditTag.Create(nil);
    frmEditTag.txtName.Text := lvwTags.Selected.Caption;
    frmEditTag.txtValue.Text := lvwTags.Selected.SubItems[0];

    if frmEditTag.ShowModal = mrOk then
    begin
      lvwTags.Selected.Caption := frmEditTag.txtName.Text;
      lvwTags.Selected.SubItems[0] := frmEditTag.txtValue.Text;
    end;

    FreeAndNil(frmEditTag);
  end;
end;

procedure TfrmSettings.lvwTagsDblClick(Sender: TObject);
begin
  tbtnEdit.Click;
end;

end.
