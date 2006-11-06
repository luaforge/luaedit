unit MacroManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, JvExMask, JvToolEdit, JvDotNetControls,
  Registry, VirtualTrees;

type
  PMacroData = ^TMacroData;
  TMacroData = record
    Name: String;
    FileName: String;
    Caption: String;
    Shortcut: String;
    DebugMode: Boolean;
    IsNew: Boolean;
  end;

  TfrmMacroManager = class(TForm)
    GroupBox1: TGroupBox;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cboShortcut: TComboBox;
    sbtnAdd: TSpeedButton;
    sbtnDelete: TSpeedButton;
    sbtnSave: TSpeedButton;
    chkDebug: TCheckBox;
    txtCaption: TEdit;
    txtFileName: TEdit;
    btnBrowseFile: TButton;
    odlgSelectFile: TOpenDialog;
    vstMacros: TVirtualStringTree;
    Label4: TLabel;
    txtName: TEdit;
    procedure btnBrowseFileClick(Sender: TObject);
    procedure vstMacrosGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstMacrosGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure FormShow(Sender: TObject);
    procedure sbtnDeleteClick(Sender: TObject);
    procedure sbtnSaveClick(Sender: TObject);
    procedure sbtnAddClick(Sender: TObject);
    procedure vstMacrosFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure vstMacrosFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure txtNameChange(Sender: TObject);
    procedure txtFileNameChange(Sender: TObject);
    procedure txtCaptionChange(Sender: TObject);
    procedure cboShortcutClick(Sender: TObject);
    procedure chkDebugClick(Sender: TObject);
  private
    { Private declarations }
    NeedSave: Boolean;
  public
    { Public declarations }
    procedure FillMacroList();
    function SaveMacro(OldName: String): Boolean;
  end;

var
  frmMacroManager: TfrmMacroManager;

implementation

uses Main, Misc;

{$R *.dfm}

procedure TfrmMacroManager.FormShow(Sender: TObject);
var
  pNode: PVirtualNode;
begin
  // Initialize dialog
  FillMacroList();
  txtCaption.Text := '';
  txtName.Text := '';
  txtFileName.Text := '';
  cboShortcut.ItemIndex := 0;
  chkDebug.Checked := False;

  // Attempt to select first node in the tree (if any)
  pNode := vstMacros.GetFirstChild(vstMacros.RootNode);
  if Assigned(pNode) then
  begin
    vstMacros.Selected[pNode] := True;
    vstMacrosFocusChanged(vstMacros, pNode, 0);
  end;
end;

procedure TfrmMacroManager.btnBrowseFileClick(Sender: TObject);
begin
  odlgSelectFile.InitialDir := GetLuaEditInstallPath();

  if odlgSelectFile.Execute then
    txtFileName.Text := odlgSelectFile.FileName;
end;

procedure TfrmMacroManager.FillMacroList();
var
  x: Integer;
  pReg: TRegistry;
  lstKeyList: TStringList;
  pNode: PVirtualNode;
  pNodeData: PMacroData;
begin
  vstMacros.Clear;
  vstMacros.BeginUpdate;
  pReg := TRegistry.Create();

  // Open registry key to read all macros' datas
  if pReg.OpenKey('\Software\LuaEdit\Macros', False) then
  begin
    lstKeyList := TStringList.Create();
    pReg.GetKeyNames(lstKeyList);

    for x := 0 to lstKeyList.Count - 1 do
    begin
      // Open current macro registry key to read macro's values
      if pReg.OpenKey('\Software\LuaEdit\Macros\' + lstKeyList.Strings[x], False) then
      begin
        // Add node in virtual tree
        pNode := vstMacros.AddChild(vstMacros.RootNode);
        pNodeData := vstMacros.GetNodeData(pNode);
        
        // Fill data record with registry values
        pNodeData.Name := lstKeyList.Strings[x];
        pNodeData.FileName := pReg.ReadString('FileName');
        pNodeData.Caption := pReg.ReadString('Caption');
        pNodeData.Shortcut := pReg.ReadString('Shortcut');
        pNodeData.DebugMode := pReg.ReadBool('DebugMode');
        pNodeData.IsNew := False;
      end;
    end;

    lstKeyList.Free;
  end;

  vstMacros.EndUpdate;
  pReg.Free;

  // Attempt to select first node in the tree (if any)
  pNode := vstMacros.GetFirstChild(vstMacros.RootNode);
  if Assigned(pNode) then
  begin
    vstMacros.Selected[pNode] := True;
    vstMacrosFocusChanged(vstMacros, pNode, 0);
  end;
end;

function TfrmMacroManager.SaveMacro(OldName: String): Boolean;
var
  pReg: TRegistry;
begin
  Result := False;
  pReg := TRegistry.Create();

  if txtName.Text = '' then
  begin
    Application.MessageBox('The marco''s name cannot be empty!', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtName.SetFocus;
  end
  else if pReg.KeyExists('\Software\LuaEdit\Macros\'+txtName.Text) and (OldName <> txtName.Text) and (OldName <> '') then
  begin
    Application.MessageBox(PChar('A macro with name "'+txtName.Text+'" already exists!'), 'LuaEdit', MB_OK+MB_ICONERROR);
    txtName.SetFocus;
  end
  else if not FileExistsAbs(txtFileName.Text) then
  begin
    Application.MessageBox(PChar('The file "'+txtFileName.Text+'" does not exists!'), 'LuaEdit', MB_OK+MB_ICONERROR);
    txtFileName.SetFocus;
  end
  else if txtCaption.Text = '' then
  begin
    Application.MessageBox('The macro''s caption cannot be empty!', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtCaption.SetFocus;
  end
  else
  begin
    // Open/create the registry key to write datas
    if pReg.OpenKey('\Software\LuaEdit\Macros\'+txtName.Text, True) then
    begin
      // Write macro's datas
      pReg.WriteString('FileName', txtFileName.Text);
      pReg.WriteString('Caption', txtCaption.Text);
      pReg.WriteString('Shortcut', cboShortcut.Text);
      pReg.WriteBool('DebugMode', chkDebug.Checked);
    end;

    // Delete previous registry key (the one with the old name... the name might have changed)
    if (OldName <> '') and (txtName.Text <> OldName) then
    begin
      if pReg.KeyExists('\Software\LuaEdit\Macros\'+OldName) then
      pReg.DeleteKey('\Software\LuaEdit\Macros\'+OldName);
    end;

    Result := True;
    NeedSave := False;
  end;

  pReg.Free;
end;

procedure TfrmMacroManager.vstMacrosGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  pData: PMacroData;
begin
  // Set text to display for all nodes
  if TextType = ttNormal then
  begin
    case Column of
      0:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.Name;
      end;
      1:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.FileName;
      end;
      2:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.Caption;
      end;
      3:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.Shortcut;
      end;
      4:
      begin
        pData := Sender.GetNodeData(Node);

        if pData.DebugMode then
          CellText := 'Debug'
        else
          CellText := 'Release';
      end;
    end;
  end;
end;

procedure TfrmMacroManager.vstMacrosGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TMacroData);
end;

procedure TfrmMacroManager.vstMacrosFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
var
  pNodeData: PMacroData;
  IsNew: Boolean;
begin
  IsNew := False;

  if OldNode <> NewNode then
  begin
    if Assigned(OldNode) then
    begin
      pNodeData := vstMacros.GetNodeData(OldNode);
      IsNew := pNodeData.IsNew;
    end;

    // Make sure saving is necessary
    if NeedSave or IsNew then
    begin
      // Prompt user to save changes
      if Application.MessageBox(PChar('Save changes to the "'+txtName.Text+'" macro?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
      begin
        // Save macro
        if Assigned(OldNode) and not IsNew then
          Allowed := SaveMacro(pNodeData.Name)
        else
          Allowed := SaveMacro('');

        // Rebuild the list of macros...
        FillMacroList();
      end;
    end;
  end
  else if OldNode = NewNode then
    Allowed := False;
end;

procedure TfrmMacroManager.vstMacrosFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  pNode: PVirtualNode;
  pNodeData: PMacroData;
begin
  pNode := vstMacros.GetFirstSelected();

  if Assigned(pNode) then
  begin
    pNodeData := vstMacros.GetNodeData(pNode);

    txtName.Text := pNodeData.Name;
    txtFileName.Text := pNodeData.FileName;
    txtCaption.Text := pNodeData.Caption;
    cboShortcut.ItemIndex := cboShortcut.Items.IndexOf(pNodeData.Shortcut);
    chkDebug.Checked := pNodeData.DebugMode;
    NeedSave := False;
  end;
end;

procedure TfrmMacroManager.sbtnDeleteClick(Sender: TObject);
var
  pNode: PVirtualNode;
  pNodeData: PMacroData;
  pReg: TRegistry;
begin
  pNode := vstMacros.GetFirstSelected();

  if Assigned(pNode) then
  begin
    pNodeData := vstMacros.GetNodeData(pNode);

    // Make sure the user really wants to do this
    if Application.MessageBox(PChar('Are you sure you want to delete the "'+pNodeData.Name+'" macro?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
    begin
      pReg := TRegistry.Create();

      // Delete the related registry key (so in other words, delete the macro)
      if pReg.OpenKey('\Software\LuaEdit\Macros\'+pNodeData.Name, False) then
        pReg.DeleteKey('\Software\LuaEdit\Macros\'+pNodeData.Name);

      // Rebuild the list of macros... 
      FillMacroList();
    end;
  end;
end;

procedure TfrmMacroManager.sbtnSaveClick(Sender: TObject);
var
  pNode: PVirtualNode;
  pNodeData: PMacroData;
  pReg: TRegistry;
begin
  pNode := vstMacros.GetFirstSelected();

  if Assigned(pNode) then
  begin
    pNodeData := vstMacros.GetNodeData(pNode);

    // Make sure the user really wants to do this
    if Application.MessageBox(PChar('Save changes to the "'+txtName.Text+'" macro?'), 'LuaEdit', MB_YESNO+MB_ICONQUESTION) = IDYES then
    begin
      SaveMacro(pNodeData.Name);

      // Rebuild the list of macros...
      FillMacroList();
    end;
  end;
end;

procedure TfrmMacroManager.sbtnAddClick(Sender: TObject);
var
  pNode: PVirtualNode;
  pNodeData: PMacroData;
begin
  // Create node and retrieve data pointer
  pNode := vstMacros.AddChild(vstMacros.RootNode);
  pNodeData := vstMacros.GetNodeData(pNode);

  pNodeData.Name := 'New Macro';
  pNodeData.FileName := '';
  pNodeData.Caption := 'New Macro';
  pNodeData.Shortcut := '[None]';
  pNodeData.DebugMode := False;
  pNodeData.IsNew := True;

  // Select newly created node
  vstMacros.Selected[pNode] := True;
  vstMacrosFocusChanged(vstMacros, pNode, 0);
  NeedSave := True;
end;

procedure TfrmMacroManager.txtNameChange(Sender: TObject);
begin
  NeedSave := True;
end;

procedure TfrmMacroManager.txtFileNameChange(Sender: TObject);
begin
  NeedSave := True;
end;

procedure TfrmMacroManager.txtCaptionChange(Sender: TObject);
begin
  NeedSave := True;
end;

procedure TfrmMacroManager.cboShortcutClick(Sender: TObject);
begin
  NeedSave := True;
end;

procedure TfrmMacroManager.chkDebugClick(Sender: TObject);
begin
  NeedSave := True;
end;

end.
