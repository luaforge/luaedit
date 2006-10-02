unit ProjectTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, CommCtrl, ExtCtrls, ImgList, Menus, JvComponent, ShellAPI,
  JvDockControlForm, JvExComCtrls, JvComCtrls, JvDotNetControls, Main, Misc,
  VirtualTrees;

type
  PProjectTreeData = ^TProjectTreeData;
  TProjectTreeData = record
    pLuaEditFile: TLuaEditFile;
    ActiveProject: Boolean;
    ToKeep: Boolean;
    Deleting: Boolean;
  end;

  TfrmProjectTree = class(TForm)
    Panel1: TPanel;
    imlProjectTree: TImageList;
    ppmProjectTree: TPopupMenu;
    ActivateSelectedProject1: TMenuItem;
    N1: TMenuItem;
    UnloadFileProject1: TMenuItem;
    JvDockClient1: TJvDockClient;
    N2: TMenuItem;
    AddUnittoProject1: TMenuItem;
    RemoveUnitFromProject1: TMenuItem;
    Options1: TMenuItem;
    vstProjectTree: TVirtualStringTree;
    mnuFindTarget: TMenuItem;
    procedure UnloadFileProject1Click(Sender: TObject);
    procedure ppmProjectTreePopup(Sender: TObject);
    procedure vstProjectTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstProjectTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstProjectTreeGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure vstProjectTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstProjectTreeDblClick(Sender: TObject);
    procedure vstProjectTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure vstProjectTreeAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    function GetNodeInTree(sFileName, sProjectName: String): PVirtualNode;
    procedure mnuFindTargetClick(Sender: TObject);
    procedure vstProjectTreeGetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BuildProjectTree(HandleNotifier: Boolean = True);
  end;

var
  frmProjectTree: TfrmProjectTree;

implementation

{$R *.dfm}

procedure TfrmProjectTree.vstProjectTreeDblClick(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
  pFile: TLuaEditBasicTextFile;
begin
  pNode := vstProjectTree.GetFirstSelected;

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);

    if pData.pLuaEditFile.FileType in LuaEditTextFilesTypeSet then
    begin
      pFile := TLuaEditBasicTextFile(pData.pLuaEditFile);

      if pFile.IsLoaded then
      begin
        frmLuaEditMain.PopUpUnitToScreen(pFile.Path);
      end;
    end
    else if pData.pLuaEditFile.FileType = otLuaEditForm then
      frmLuaEditMain.DoBringGUIFormToFrontExecute();
  end;

  frmLuaEditMain.CheckButtons;
end;

function TfrmProjectTree.GetNodeInTree(sFileName, sProjectName: String): PVirtualNode;
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  Result := nil;
  pNode := vstProjectTree.GetFirst;

  while Assigned(pNode) do
  begin
    pData := vstProjectTree.GetNodeData(pNode);

    if sProjectName <> '' then
    begin
      if ((pData.pLuaEditFile.FileType in LuaEditTextFilesTypeSet) and (not pData.Deleting)) then
      begin
        if ((pData.pLuaEditFile.PrjOwner.Name = sProjectName) or (sProjectName = '[@@SingleUnits@@]')) then
        begin
          if pData.pLuaEditFile.Name = sFileName then
          begin
            Result := pNode;
            Break;
          end;
        end;
      end;
    end
    else
    begin
      if pData.pLuaEditFile.FileType = otLuaEditProject then
      begin
        if pData.pLuaEditFile.Name = sFileName then
        begin
          Result := pNode;
          Break;
        end;
      end;
    end;

    pNode := vstProjectTree.GetNext(pNode);
  end;
end;

procedure TfrmProjectTree.BuildProjectTree(HandleNotifier: Boolean);
var
  pTempPrj: TLuaEditProject;
  pPrjNode, pUnitNode, pSingleUnitLastNode: PVirtualNode;
  pData, pDataGUIForm: PProjectTreeData;
  x, y: Integer;

  // Go through all nodes of the tree and set their ToKeep flag to false
  procedure UnflagAllExpanded(pTree: TVirtualStringTree);
  var
    pNode: PVirtualNode;
    pData: PProjectTreeData;
  begin
    pNode := pTree.GetFirst;

    while Assigned(pNode) do
    begin
      pData := pTree.GetNodeData(pNode);
      pData.ToKeep := False;
      pNode := pTree.GetNext(pNode);
    end;
  end;

  // Deletes all nodes for wich their ToKeep flag is still on false
  procedure CleanTree(pTree: TVirtualStringTree);
  var
    pNode, pPrevious: PVirtualNode;
    pData: PProjectTreeData;
  begin
    pNode := pTree.GetFirst;

    while Assigned(pNode) do
    begin
      pData := pTree.GetNodeData(pNode);
      
      if not pData.ToKeep then
      begin
        pPrevious := pTree.GetPrevious(pNode);
        pTree.DeleteNode(pNode);
        pNode := pPrevious;
      end;
      
      pNode := pTree.GetNext(pNode);
    end;
  end;

begin
  // Initialize stuff
  pPrjNode := nil;
  pUnitNode := nil;
  pSingleUnitLastNode := nil;

  // If the changes notifier is handled, we stop it while building the tree
  if HandleNotifier then
  begin
    frmLuaEditMain.jvchnNotifier.Active := False;
    frmLuaEditMain.jvchnNotifier.Notifications.Clear;
  end;

  vstProjectTree.BeginUpdate;
  UnflagAllExpanded(vstProjectTree);

  for x := 0 to LuaProjects.Count - 1 do
  begin
    pTempPrj := TLuaEditProject(LuaProjects.Items[x]);
    pPrjNode := GetNodeInTree(pTempPrj.Name, '');

    if not Assigned(pPrjNode) then
    begin
      if pTempPrj.Name <> '[@@SingleUnits@@]' then
      begin
        // Create the node
        pPrjNode := vstProjectTree.AddChild(vstProjectTree.RootNode);
        pData := vstProjectTree.GetNodeData(pPrjNode);
        pData.pLuaEditFile := pTempPrj;
        pData.ActiveProject := (pTempPrj = ActiveProject);
        pData.ToKeep := True;
        pData.Deleting := False;

        // Adding project root to change notifier...
        if ((not pTempPrj.IsNew) and HandleNotifier) then
          frmLuaEditMain.AddToNotifier(ExtractFileDir(pTempPrj.Path));
      end
      else
          pPrjNode := pSingleUnitLastNode;
    end
    else
    begin
      // Update the node's data
      pData := vstProjectTree.GetNodeData(pPrjNode);
      pData.pLuaEditFile := pTempPrj;
      pData.ActiveProject := (pTempPrj = ActiveProject);
      pData.ToKeep := True;
      pData.Deleting := False;

      // Adding project root to change notifier...
      if ((not pTempPrj.IsNew) and HandleNotifier) then
        frmLuaEditMain.AddToNotifier(ExtractFileDir(pTempPrj.Path));
    end;

    for y := 0 to pTempPrj.lstUnits.Count - 1 do
    begin
      pUnitNode := GetNodeInTree(TLuaEditUnit(pTempPrj.lstUnits.Items[y]).Name, pTempPrj.Name);

      if not Assigned(pUnitNode) then
      begin
        // Adding single unit (projectless) to the tree
        if pTempPrj.Name = '[@@SingleUnits@@]' then
        begin
          if not Assigned(pPrjNode) then
            pUnitNode := vstProjectTree.InsertNode(vstProjectTree.RootNode, amInsertBefore)
          else
            pUnitNode := vstProjectTree.InsertNode(pPrjNode, amInsertAfter);
          // Update last single unit node
          pSingleUnitLastNode := pUnitNode;
        end
        else
          pUnitNode := vstProjectTree.AddChild(pPrjNode);

        // Create the node
        pData := vstProjectTree.GetNodeData(pUnitNode);
        pData.pLuaEditFile := pTempPrj.lstUnits.Items[y];
        pData.ActiveProject := False;
        pData.ToKeep := True;
        pData.Deleting := False;

        // Adding unit root to change notifier...
        if ((not TLuaEditUnit(pTempPrj.lstUnits.Items[y]).IsNew) and HandleNotifier) then
          frmLuaEditMain.AddToNotifier(ExtractFileDir(TLuaEditUnit(pTempPrj.lstUnits.Items[y]).Path));

        // Special handling for gui forms
        if pData.pLuaEditFile.FileType = otLuaEditForm then
        begin
          pDataGUIForm := pData;
          pUnitNode := vstProjectTree.AddChild(pUnitNode);
          pData := vstProjectTree.GetNodeData(pUnitNode);
          pData.pLuaEditFile := TLuaEditGUIForm(pDataGUIForm.pLuaEditFile).LinkedDebugFile;
          pData.ActiveProject := False;
          pData.ToKeep := True;
          pData.Deleting := False;
        end;
      end
      else
      begin
        // Update the node's data
        pData := vstProjectTree.GetNodeData(pUnitNode);
        pData.pLuaEditFile := pTempPrj.lstUnits.Items[y];
        pData.ActiveProject := False;
        pData.ToKeep := True;
        pData.Deleting := False;

        // Adding unit root to change notifier...
        if ((not TLuaEditUnit(pTempPrj.lstUnits.Items[y]).IsNew) and HandleNotifier) then
          frmLuaEditMain.AddToNotifier(ExtractFileDir(TLuaEditUnit(pTempPrj.lstUnits.Items[y]).Path));
      end;
    end;
  end;

  CleanTree(vstProjectTree);
  vstProjectTree.EndUpdate;

  // Set back on the changes notifier if required
  if ((frmLuaEditMain.jvchnNotifier.Notifications.Count > 0) and HandleNotifier) then
    frmLuaEditMain.jvchnNotifier.Active := True;
end;

procedure TfrmProjectTree.UnloadFileProject1Click(Sender: TObject);
var
  pLuaPrj: TLuaEditProject;
  pFile: TLuaEditBasicTextFile;
  Answer, x: Integer;
  UnitsToDelete: TList;
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  pNode := vstProjectTree.GetFirstSelected;

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);
    UnitsToDelete := TList.Create;

    // Case where the selected file was a project
    if pData.pLuaEditFile.FileType = otLuaEditProject then
    begin
      pLuaPrj := TLuaEditProject(pData.pLuaEditFile);

      // Ssaving any new or modified project's files
      for x := 0 to pLuaPrj.lstUnits.Count - 1 do
      begin
        pFile := TLuaEditBasicTextFile(pLuaPrj.lstUnits.Items[x]);
        
        if ((pFile.HasChanged) or (pFile.IsNew)) then
        begin
          Answer := Application.MessageBox(PChar('Save changes to unit "'+pFile.Name+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
          if Answer = IDYES then
          begin
            if SaveUnitsInc then
              pFile.SaveUnitInc(pFile.Path)
            else
              pFile.SaveUnit(pFile.Path);
          end
          else if Answer = IDCANCEL then
          begin
            UnitsToDelete.Free;
            Exit;
          end;
        end;

        UnitsToDelete.Add(pFile);
      end;

      // saving any new or modified project
      if ((pLuaPrj.HasChanged) or (pLuaPrj.IsNew)) then
      begin
        Answer := Application.MessageBox(PChar('Save changes to project "'+pLuaPrj.Name+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
        if Answer = IDYES then
        begin
          if SaveProjectsInc then
            pLuaPrj.SaveProjectInc(pLuaPrj.Path)
          else
            pLuaPrj.SaveProject(pLuaPrj.Path);
        end
        else if Answer = IDCANCEL then
        begin
          UnitsToDelete.Free;
          Exit;
        end;
      end;
    end
    else if pData.pLuaEditFile.FileType in LuaEditTextFilesTypeSet then
    begin
      pFile := TLuaEditBasicTextFile(pData.pLuaEditFile);

      if pFile.PrjOwner.Name = '[@@SingleUnits@@]' then
      begin
        if ((pFile.HasChanged) or (pFile.IsNew)) then
        begin
          Answer := Application.MessageBox(PChar('Save changes to unit "'+pFile.Name+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
          if Answer = IDYES then
          begin
            if SaveUnitsInc then
              pFile.SaveUnitInc(pFile.Path)
            else
              pFile.SaveUnit(pFile.Path);
          end
          else if Answer = IDCANCEL then
          begin
            UnitsToDelete.Free;
            Exit;
          end;
        end;

        UnitsToDelete.Add(pFile);
      end;
    end;
    
    // Free and close units and project
    for x := UnitsToDelete.Count - 1 downto 0 do
    begin
      pFile := TLuaEditBasicTextFile(UnitsToDelete.Items[x]);

      if Assigned(pFile.AssociatedTab) then
      begin
        frmLuaEditMain.jvUnitBar.Tabs.Delete(pFile.AssociatedTab.Index);
        pFile.AssociatedTab := nil;
        LuaOpenedFiles.Remove(pFile);
      end;

      pData.Deleting := True;
      pFile.PrjOwner.lstUnits.Remove(pFile);
      pFile.Free;
    end;

    if Assigned(pLuaPrj) then
      LuaProjects.Remove(pLuaPrj);

    if pLuaPrj = ActiveProject then
    begin
      // Try to find another project to automatically set to the active one
      if LuaProjects.Count > 1 then
          ActiveProject := LuaProjects.Items[LuaProjects.Count - 1]
      else
        ActiveProject := nil;
    end;

    // Reset LuaEdit main form caption to its initial value
    if not Assigned(ActiveProject) then
        frmLuaEditMain.Caption := 'LuaEdit';

    // Initialize stuff...
    UnitsToDelete.Free;
    BuildProjectTree;
    frmLuaEditMain.CheckButtons;
  end;
end;

procedure TfrmProjectTree.mnuFindTargetClick(Sender: TObject);
var
  pData: PProjectTreeData;
  pNode: PVirtualNode;
begin
  pNode := vstProjectTree.GetFirstSelected;

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);
    ShellExecute(Self.Handle, 'explore', PChar(ExtractFileDir(pData.pLuaEditFile.Path)), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TfrmProjectTree.ppmProjectTreePopup(Sender: TObject);
var
  pData: PProjectTreeData;
  pNode: PVirtualNode;
begin
  pNode := vstProjectTree.GetFirstSelected;
  mnuFindTarget.Enabled := Assigned(pNode);

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);
    mnuFindTarget.Enabled := ((not pData.pLuaEditFile.IsNew) and (FileExists(pData.pLuaEditFile.Path)));
  end;

  frmLuaEditMain.DoMainMenuProjectExecute;
end;

procedure TfrmProjectTree.vstProjectTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  pData: PProjectTreeData;
begin
  // Set text to display for all nodes
  if TextType = ttNormal then
  begin
    case Column of
      0:
      begin
        pData := Sender.GetNodeData(Node);
        pData.ToKeep := True;
        CellText := pData.pLuaEditFile.Name;
      end;
      1: CellText := '';
      2:
      begin
        pData := Sender.GetNodeData(Node);
        pData.ToKeep := True;
        CellText := pData.pLuaEditFile.Path;
      end;
    end;
  end;
end;

procedure TfrmProjectTree.vstProjectTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  pData: PProjectTreeData;
begin
  pData := Sender.GetNodeData(Node);

  if pData.pLuaEditFile.FileType = otLuaEditProject then
  begin
    // Set bold style on the active project node
    if pData.ActiveProject then
    begin
      TargetCanvas.Font.Style := [fsBold];
      frmLuaEditMain.Caption := 'LuaEdit - ' + pData.pLuaEditFile.Path;
    end;
  end
  else
  begin
    // Set disabled color for non-loaded units
    if not pData.pLuaEditFile.IsLoaded then
    begin
      TargetCanvas.Font.Color := clInactiveCaption;
      TargetCanvas.Pen.Color := clInactiveCaption;
    end;
  end;
end;

procedure TfrmProjectTree.vstProjectTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  pData: PProjectTreeData;
begin
  // Set image index for all nodes
  if Column = 0 then
  begin
    pData := Sender.GetNodeData(Node);

    if pData.pLuaEditFile.FileType = otLuaEditProject then
      ImageIndex := 0
    else if pData.pLuaEditFile.FileType = otLuaEditUnit then
    begin
      if pData.pLuaEditFile.IsLoaded then
        ImageIndex := 1
      else
        ImageIndex := 2;
    end
    else if pData.pLuaEditFile.FileType = otLuaEditMacro then
    begin
      if pData.pLuaEditFile.IsLoaded then
        ImageIndex := 3
      else
        ImageIndex := 4;
    end
    else if pData.pLuaEditFile.FileType = otTextFile then
    begin
      if pData.pLuaEditFile.IsLoaded then
        ImageIndex := 5
      else
        ImageIndex := 6;
    end
    else if pData.pLuaEditFile.FileType = otLuaEditForm then
    begin
      if pData.pLuaEditFile.IsLoaded then
        ImageIndex := 7
      else
        ImageIndex := 8;
    end;
  end
  else if Column = 1 then
  begin
    pData := Sender.GetNodeData(Node);

    if pData.pLuaEditFile.IsNew then
      ImageIndex := 9
    else if not pData.pLuaEditFile.IsLoaded then
      ImageIndex := 10
    else if pData.pLuaEditFile.IsReadOnly then
      ImageIndex := 11
    else if pData.pLuaEditFile.HasChanged then
      ImageIndex := 12
    else
      ImageIndex := 13;
  end;
end;

procedure TfrmProjectTree.vstProjectTreeGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
  pData: PProjectTreeData;
begin
  case Column of
    1:
    begin
      pData := Sender.GetNodeData(Node);

      if pData.pLuaEditFile.IsNew then
        HintText := 'File is New'
      else if not pData.pLuaEditFile.IsLoaded then
        HintText := 'File could not be loaded'
      else if pData.pLuaEditFile.IsReadOnly then
        HintText := 'File is Read-Only'
      else if pData.pLuaEditFile.HasChanged then
        HintText := 'File is Modified'
      else
        HintText := 'File is All Right and Saved';
    end;
  end;
end;

procedure TfrmProjectTree.vstProjectTreeGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TProjectTreeData);
end;

procedure TfrmProjectTree.vstProjectTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmLuaEditMain.CheckButtons;
end;

procedure TfrmProjectTree.vstProjectTreeAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var
  pRect: TRect;
begin
  pRect := ItemRect;
  InflateRect(pRect, 0, 1);
  pRect.Right := pRect.Left + 22;
  TargetCanvas.Brush.Color := clWhite;
  TargetCanvas.FillRect(pRect);

  // Draw node button since the noda has some child
  if ((Node.Parent = Sender.RootNode) and (Node.ChildCount <> 0)) then
  begin
    // Draw the frame around the button
    TargetCanvas.Pen.Color := clBtnShadow;
    TargetCanvas.Rectangle(5, 4, 14, 13);
    TargetCanvas.MoveTo(14, 8);
    TargetCanvas.LineTo(20, 8);
    TargetCanvas.Pen.Color := clBlack;

    if not (vsExpanded in Node.States) then
    begin
      // Draw expandable node button (plus sign)
      TargetCanvas.MoveTo(7, 8);
      TargetCanvas.LineTo(12, 8);
      TargetCanvas.MoveTo(9, 6);
      TargetCanvas.LineTo(9, 11);
    end
    else
    begin
      // Draw non-expandable node button (minus sign)
      TargetCanvas.MoveTo(7, 8);
      TargetCanvas.LineTo(12, 8);
    end;
  end;
end;

end.
