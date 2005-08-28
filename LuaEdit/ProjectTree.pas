unit ProjectTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, CommCtrl, ExtCtrls, ImgList, Menus, JvComponent,
  JvDockControlForm, JvExComCtrls, JvComCtrls, JvDotNetControls, Main,
  VirtualTrees;

type
  PProjectTreeData = ^TProjectTreeData;
  TProjectTreeData = record
    pLuaUnit: TLuaUnit;
    pLuaPrj: TLuaProject;
    ActiveProject: Boolean;
    ToKeep: Boolean;
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
  pLuaUnit: TLuaUnit;
begin
  pNode := vstProjectTree.GetFirstSelected;

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);

    if Assigned(pData.pLuaUnit) then
    begin
      pLuaUnit := pData.pLuaUnit;

      if pLuaUnit.IsLoaded then
      begin
        if LuaOpenedUnits.IndexOf(pLuaUnit) = -1 then
        begin
          // Insert new tab in the page control to view the requested unit
          frmMain.AddFileInTab(pLuaUnit);
        end
        else
        begin
          // Activate the tab associated to the requested unit
          frmMain.jvUnitBar.SelectedTab := frmMain.GetAssociatedTab(pLuaUnit);

          if pLuaUnit.HasChanged then
            frmMain.stbMain.Panels[2].Text := 'Modified'
          else
            frmMain.stbMain.Panels[2].Text := '';

          frmMain.synEditClick(pLuaUnit.synUnit);
        end;
      end;
    end;
  end;

  frmMain.CheckButtons;
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
      if Assigned(pData.pLuaUnit) then
      begin
        if ((pData.pLuaUnit.pPrjOwner.sPrjName = sProjectName) or (sProjectName = '[@@SingleUnits@@]')) then
        begin
          if pData.pLuaUnit.sName = sFileName then
          begin
            Result := pNode;
            Break;
          end;
        end;
      end;
    end
    else
    begin
      if Assigned(pData.pLuaPrj) then
      begin
        if pData.pLuaPrj.sPrjName = sFileName then
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
  pTempPrj: TLuaProject;
  pNode, pNewPrjNode, pNewNode, pSingleUnitLastNode: PVirtualNode;
  pData: PProjectTreeData;
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
  pNewNode := nil;
  pSingleUnitLastNode := nil;

  // If the changes notifier is handled, we stop it while building the tree
  if HandleNotifier then
  begin
    frmMain.jvchnNotifier.Active := False;
    frmMain.jvchnNotifier.Notifications.Clear;
  end;

  vstProjectTree.BeginUpdate;
  UnflagAllExpanded(vstProjectTree);

  for x := 0 to LuaProjects.Count - 1 do
  begin
    pTempPrj := TLuaProject(LuaProjects.Items[x]);
    pNode := GetNodeInTree(pTempPrj.sPrjName, '');

    if not Assigned(pNode) then
    begin
      if pTempPrj.sPrjName <> '[@@SingleUnits@@]' then
      begin
        // Create the node
        pNewPrjNode := vstProjectTree.AddChild(vstProjectTree.RootNode);
        pData := vstProjectTree.GetNodeData(pNewPrjNode);
        pData.pLuaUnit := nil;
        pData.pLuaPrj := pTempPrj;
        pData.ActiveProject := (pTempPrj = ActiveProject);
        pData.ToKeep := True;

        // Adding project root to change notifier...
        if ((not pTempPrj.IsNew) and HandleNotifier) then
          frmMain.AddToNotifier(ExtractFileDir(pTempPrj.sPrjPath));
      end
      else
        pNewPrjNode := pSingleUnitLastNode;
    end
    else
    begin
      // Update the node's data
      pData := vstProjectTree.GetNodeData(pNode);
      pData.pLuaUnit := nil;
      pData.pLuaPrj := pTempPrj;
      pData.ActiveProject := (pTempPrj = ActiveProject);
      pData.ToKeep := True;
    end;

    for y := 0 to pTempPrj.lstUnits.Count - 1 do
    begin
      pNode := GetNodeInTree(TLuaUnit(pTempPrj.lstUnits.Items[y]).sName, pTempPrj.sPrjName);

      if not Assigned(pNode) then
      begin
        // Adding single unit (projectless) to the tree
        if pTempPrj.sPrjName = '[@@SingleUnits@@]' then
          pNewNode := vstProjectTree.InsertNode(pNewPrjNode, amInsertAfter)
        else
          pNewNode := vstProjectTree.AddChild(pNewPrjNode);

        // Update last single unit node
        pSingleUnitLastNode := pNewNode;

        // Create the node
        pData := vstProjectTree.GetNodeData(pNewNode);
        pData.pLuaUnit := TLuaUnit(pTempPrj.lstUnits.Items[y]);
        pData.pLuaPrj := nil;
        pData.ActiveProject := False;
        pData.ToKeep := True;

        // Adding unit root to change notifier...
        if ((not TLuaUnit(pTempPrj.lstUnits.Items[y]).IsNew) and HandleNotifier) then
          frmMain.AddToNotifier(ExtractFileDir(TLuaUnit(pTempPrj.lstUnits.Items[y]).sUnitPath));
      end
      else
      begin
        // Update the node's data
        pData := vstProjectTree.GetNodeData(pNode);
        pData.pLuaUnit := TLuaUnit(pTempPrj.lstUnits.Items[y]);
        pData.pLuaPrj := nil;
        pData.ActiveProject := False;
        pData.ToKeep := True;
      end;
    end;
  end;

  CleanTree(vstProjectTree);
  vstProjectTree.EndUpdate;

  // Set back on the changes notifier if required
  if ((frmMain.jvchnNotifier.Notifications.Count > 0) and HandleNotifier) then
    frmMain.jvchnNotifier.Active := True;
end;

procedure TfrmProjectTree.UnloadFileProject1Click(Sender: TObject);
var
  pLuaPrj: TLuaProject;
  pLuaUnit: TLuaUnit;
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
    if Assigned(pData.pLuaPrj) then
    begin
      pLuaPrj := pData.pLuaPrj;

      // Ssaving any new or modified project's files
      for x := 0 to pLuaPrj.lstUnits.Count - 1 do
      begin
        pLuaUnit := TLuaUnit(pLuaPrj.lstUnits.Items[x]);
        
        if ((pLuaUnit.HasChanged) or (pLuaUnit.IsNew)) then
        begin
          Answer := Application.MessageBox(PChar('Save changes to unit "'+pLuaUnit.sName+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
          if Answer = IDYES then
          begin
            if SaveUnitsInc then
              pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
            else
              pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
          end
          else if Answer = IDCANCEL then
          begin
            UnitsToDelete.Free;
            Exit;
          end;
        end;

        UnitsToDelete.Add(pLuaUnit);
      end;

      // saving any new or modified project
      if ((pLuaPrj.HasChanged) or (pLuaPrj.IsNew)) then
      begin
        Answer := Application.MessageBox(PChar('Save changes to project "'+pLuaPrj.sPrjName+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
        if Answer = IDYES then
        begin
          if SaveProjectsInc then
            pLuaPrj.SaveProjectInc(pLuaPrj.sPrjPath)
          else
            pLuaPrj.SaveProject(pLuaPrj.sPrjPath);
        end
        else if Answer = IDCANCEL then
        begin
          UnitsToDelete.Free;
          Exit;
        end;
      end;
    end
    else if Assigned(pData.pLuaUnit) then
    begin
      pLuaUnit := pData.pLuaUnit;

      if pLuaUnit.pPrjOwner.sPrjName = '[@@SingleUnits@@]' then
      begin
        if ((pLuaUnit.HasChanged) or (pLuaUnit.IsNew)) then
        begin
          Answer := Application.MessageBox(PChar('Save changes to unit "'+pLuaUnit.sName+'"?'), 'LuaEdit', MB_YESNOCANCEL+MB_ICONQUESTION);
          if Answer = IDYES then
          begin
            if SaveUnitsInc then
              pLuaUnit.SaveUnitInc(pLuaUnit.sUnitPath)
            else
              pLuaUnit.SaveUnit(pLuaUnit.sUnitPath);
          end
          else if Answer = IDCANCEL then
          begin
            UnitsToDelete.Free;
            Exit;
          end;
        end;

        UnitsToDelete.Add(pLuaUnit);
      end;
    end;
    
    // Free and close units and project
    for x := UnitsToDelete.Count - 1 downto 0 do
    begin
      pLuaUnit := TLuaUnit(UnitsToDelete.Items[x]);

      if frmMain.GetAssociatedTab(pLuaUnit) <> nil then
      begin
        frmMain.jvUnitBar.Tabs.Delete(frmMain.GetAssociatedTab(pLuaUnit).Index);
        LuaOpenedUnits.Remove(pLuaUnit);
      end;

      pLuaUnit.pPrjOwner.lstUnits.Remove(pLuaUnit);
      pLuaUnit.Free;
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
        frmMain.Caption := 'LuaEdit';

    // Initialize stuff...
    UnitsToDelete.Free;
    BuildProjectTree;
    frmMain.CheckButtons;
  end;
end;

procedure TfrmProjectTree.ppmProjectTreePopup(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  // set all menus status initially to false
  UnloadFileProject1.Enabled := False;
  AddUnittoProject1.Enabled := False;
  RemoveUnitFromProject1.Enabled := False;
  Options1.Enabled := False;
  pNode := vstProjectTree.GetFirstSelected;

  // Only if a menu is selected
  if Assigned(pNode) then
  begin
    // Retreive data from selected node
    pData := vstProjectTree.GetNodeData(pNode);

    // setting menu status
    AddUnitToProject1.Enabled := ((pData.pLuaPrj = ActiveProject) and Assigned(ActiveProject));
    RemoveUnitFromProject1.Enabled := ((pData.pLuaPrj = ActiveProject) and Assigned(ActiveProject));
    Options1.Enabled := ((pData.pLuaPrj = ActiveProject) and Assigned(ActiveProject));
    UnloadFileProject1.Enabled := (((Assigned(pData.pLuaUnit)) and (pNode.Parent = vstProjectTree.RootNode)) or (Assigned(pData.pLuaPrj)));
  end;
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
        
        if Assigned(pData.pLuaPrj) then
          CellText := pData.pLuaPrj.sPrjName
        else
          CellText := pData.pLuaUnit.sName;
      end;
      1:
      begin
        pData := Sender.GetNodeData(Node);
        pData.ToKeep := True;
        
        if Assigned(pData.pLuaPrj) then
          CellText := pData.pLuaPrj.sPrjPath
        else
          CellText := pData.pLuaUnit.sUnitPath;
      end;
    end;
  end;
end;

procedure TfrmProjectTree.vstProjectTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  pData: PProjectTreeData;
begin
  pData := Sender.GetNodeData(Node);

  if Assigned(pData.pLuaPrj) then
  begin
    // Set bold style on the active project node
    if pData.ActiveProject then
    begin
      TargetCanvas.Font.Style := [fsBold];
      frmMain.Caption := 'LuaEdit - ' + TLuaProject(pData.pLuaPrj).sPrjName;
    end;
  end
  else
  begin
    // Set disabled color for non-loaded units
    if not pData.pLuaUnit.IsLoaded then
      TargetCanvas.Pen.Color := clInactiveCaption;
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

    if Assigned(pData.pLuaPrj) then
    begin
      ImageIndex := 0;
    end
    else
    begin
      if pData.pLuaUnit.IsLoaded then
        ImageIndex := 1
      else
        ImageIndex := 2;
    end;
  end;
end;

procedure TfrmProjectTree.vstProjectTreeGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TProjectTreeData);
end;

procedure TfrmProjectTree.vstProjectTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmMain.CheckButtons;
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
