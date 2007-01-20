unit ProjectTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, CommCtrl, ExtCtrls, ImgList, Menus, JvComponent, ShellAPI,
  JvDockControlForm, JvExComCtrls, JvComCtrls, JvDotNetControls, Misc,
  VirtualTrees;

type
  PProjectTreeData = ^TProjectTreeData;
  TProjectTreeData = record
    ItemType: Integer;
    pLuaEditFile: TLuaEditFile;
    ActiveProject: Boolean;
    ToKeep: Boolean;
    Deleting: Boolean;
    OpenIndex: Integer;
    CloseIndex: Integer;
  end;

  TfrmProjectTree = class(TForm)
    Panel1: TPanel;
    ppmProjectTree: TPopupMenu;
    ActivateSelectedProject1: TMenuItem;
    N1: TMenuItem;
    UnloadFileProject1: TMenuItem;
    JvDockClient1: TJvDockClient;
    N2: TMenuItem;
    AddUnittoProject1: TMenuItem;
    RemoveUnitFromProject1: TMenuItem;
    Options1: TMenuItem;
    mnuFindTarget: TMenuItem;
    vstProjectTree: TVirtualDrawTree;
    SystemImages: TImageList;
    StatesImages: TImageList;
    N3: TMenuItem;
    SaveAs1: TMenuItem;
    procedure UnloadFileProject1Click(Sender: TObject);
    procedure ppmProjectTreePopup(Sender: TObject);
    procedure vstProjectTreeGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure vstProjectTreeDblClick(Sender: TObject);
    procedure vstProjectTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure vstProjectTreeAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    function GetNodeInTree(pFile: TLuaEditFile; pPrj: TLuaEditProject): PVirtualNode;
    procedure mnuFindTargetClick(Sender: TObject);
    procedure vstProjectTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstProjectTreeDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
    procedure FormCreate(Sender: TObject);
    procedure vstProjectTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure N3Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BuildProjectTree(HandleNotifier: Boolean = True);
  end;

var
  frmProjectTree: TfrmProjectTree;

implementation

uses Main;

{$R *.dfm}

// Returns the index of the system icon for the given file object.
function GetIconIndex(Name: String; Flags: Cardinal): Integer;
var
  SFI: TSHFileInfo;
begin
  if SHGetFileInfo(PChar(Name), 0, SFI, SizeOf(TSHFileInfo), Flags) = 0 then
    Result := -1
  else
    Result := SFI.iIcon;
end;

procedure GetOpenAndClosedIcons(Name: String; var Open, Closed: Integer);
begin
  Closed := GetIconIndex(Name, SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  Open := GetIconIndex(Name, SHGFI_SYSICONINDEX or SHGFI_SMALLICON or SHGFI_OPENICON);
end;

// Rescale source but keep aspect ratio
procedure RescaleImage(ScaleX, ScaleY: Integer; Source, Target: TBitmap);
var
  NewWidth, NewHeight: Integer;
begin
  if (Source.Width > ScaleX) or (Source.Height > ScaleY) then
  begin
    if Source.Width > Source.Height then
    begin
      NewWidth := ScaleX;
      NewHeight := Round(ScaleY * Source.Height / Source.Width);
    end
    else
    begin
      NewHeight := ScaleY;
      NewWidth := Round(ScaleX * Source.Width / Source.Height);
    end;

    Target.Width := NewWidth;
    Target.Height := NewHeight;
    SetStretchBltMode(Target.Canvas.Handle, HALFTONE);
    StretchBlt(Target.Canvas.Handle, 0, 0, NewWidth, NewHeight,
    Source.Canvas.Handle, 0, 0, Source.Width, Source.Height, SRCCOPY);
  end
  else
    Target.Assign(Source);
end;

// Little helper to convert a Delphi color to an image list color.
function GetRGBColor(Value: TColor): DWORD;
begin
  Result := ColorToRGB(Value);
  case Result of
    clNone:
      Result := CLR_NONE;
    clDefault:
      Result := CLR_DEFAULT;
  end;
end;


////////////////////////////////////////////////////////////////////////////////
// TfrmProjectTree functions
////////////////////////////////////////////////////////////////////////////////


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
        frmLuaEditMain.PopUpUnitToScreen(pFile.DisplayPath);
      end;
    end
    else if pData.pLuaEditFile.FileType = otLuaEditForm then
      frmLuaEditMain.DoBringGUIFormToFrontExecute();
  end;

  frmLuaEditMain.CheckButtons;
end;

function TfrmProjectTree.GetNodeInTree(pFile: TLuaEditFile; pPrj: TLuaEditProject): PVirtualNode;
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  Result := nil;
  pNode := vstProjectTree.GetFirst;

  while Assigned(pNode) do
  begin
    pData := vstProjectTree.GetNodeData(pNode);

    if Assigned(pPrj) then
    begin
      if ((pData.pLuaEditFile.FileType in LuaEditTextFilesTypeSet) and (not pData.Deleting)) then
      begin
        if pData.pLuaEditFile.PrjOwner = pPrj then
        begin
          if pData.pLuaEditFile = pFile then
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
        if pData.pLuaEditFile = pFile then
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
  procedure UnflagAllExpanded(pTree: TVirtualDrawTree);
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
  procedure CleanTree(pTree: TVirtualDrawTree);
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
    pPrjNode := GetNodeInTree(pTempPrj, nil);

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
      pUnitNode := GetNodeInTree(TLuaEditUnit(pTempPrj.lstUnits.Items[y]), pTempPrj);

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
              pFile.SaveInc(pFile.Path)
            else
              pFile.Save(pFile.Path);
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
            pLuaPrj.SaveInc(pLuaPrj.Path)
          else
            pLuaPrj.Save(pLuaPrj.Path);
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
              pFile.SaveInc(pFile.Path)
            else
              pFile.Save(pFile.Path);
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
    ShellExecute(Self.Handle, 'explore', PChar(ExtractFileDir(pData.pLuaEditFile.Path)), nil, nil, SW_SHOWMAXIMIZED);
  end;
end;

procedure TfrmProjectTree.ppmProjectTreePopup(Sender: TObject);
var
  pData: PProjectTreeData;
  pNode: PVirtualNode;
begin
  frmLuaEditMain.CheckButtons();
  pNode := vstProjectTree.GetFirstSelected();
  mnuFindTarget.Enabled := Assigned(pNode);

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);
    mnuFindTarget.Enabled := ((not pData.pLuaEditFile.IsNew) and (FileExistsAbs(pData.pLuaEditFile.Path)));
  end;

  frmLuaEditMain.DoMainMenuProjectExecute;
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

procedure TfrmProjectTree.vstProjectTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    if Assigned(vstProjectTree.GetFirstSelected()) then
      frmLuaEditMain.DoRemoveFromPrjExecute(TLuaEditFile(vstProjectTree.GetNodeData(vstProjectTree.GetFirstSelected())));
end;

procedure TfrmProjectTree.vstProjectTreeDrawNode(Sender: TBaseVirtualTree; const PaintInfo: TVTPaintInfo);
const
  Style: array[TImageType] of Cardinal = (0, ILD_MASK);
  
var
  pData: PProjectTreeData;
  pRect, pImageRect: TRect;
  sCellText: String;
  iImageIndex, iOverlayIndex: Integer;
  ExtraStyle, ForegroundColor: Cardinal;
  bShowImageEnabled: Boolean;
begin
  with Sender as TVirtualDrawTree do
  begin
    pData := Sender.GetNodeData(PaintInfo.Node);
    PaintInfo.Canvas.Font.Color := clBlack;
    PaintInfo.Canvas.Pen.Color := clBlack;

    // Determine text color
    if pData.pLuaEditFile.FileType = otLuaEditProject then
    begin
      // Set bold style on the active project node
      if pData.ActiveProject then
        PaintInfo.Canvas.Font.Style := [fsBold];
    end;

    if Sender.Selected[PaintInfo.Node] then
    begin
      PaintInfo.Canvas.Font.Color := clHighlightText
    end
    else
    begin
      // Set disabled color for non-loaded units
      if not pData.pLuaEditFile.IsLoaded then
      begin
        PaintInfo.Canvas.Font.Color := clInactiveCaption;
        PaintInfo.Canvas.Pen.Color := clInactiveCaption;
      end;
    end;

    SetBKMode(PaintInfo.Canvas.Handle, TRANSPARENT);
    pRect := PaintInfo.ContentRect;
    InflateRect(pRect, -TextMargin, 0);
    Dec(pRect.Right);
    Dec(pRect.Bottom);

    case PaintInfo.Column of
      0:
      begin
        // Determine is loaded image style
        if Assigned(pData.pLuaEditFile) then
          bShowImageEnabled := pData.pLuaEditFile.IsLoaded
        else
          bShowImageEnabled := False;

        // Get image area
        pImageRect := pRect;

        // Determine image index
        if Sender.Expanded[PaintInfo.Node] then
          iImageIndex := pData.OpenIndex
        else
          iImageIndex := pData.CloseIndex;

        // Determine overlay index
        if pData.pLuaEditFile.IsNew then
          iOverlayIndex := 0
        else if not pData.pLuaEditFile.IsLoaded then
          iOverlayIndex := 1
        else if pData.pLuaEditFile.IsReadOnly then
          iOverlayIndex := 2
        else if pData.pLuaEditFile.HasChanged then
          iOverlayIndex := 3
        else
          iOverlayIndex := 4;

        // Handle cell text
        pRect.Left := pRect.Left + SystemImages.Width + 2;
        sCellText := pData.pLuaEditFile.Name;
        DrawText(PaintInfo.Canvas.Handle, PChar(sCellText), Length(sCellText), pRect, DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
        ExtraStyle := ILD_TRANSPARENT or ILD_OVERLAYMASK;// and IndexToOverlayMask(iOverlayIndex + 1);
        ForegroundColor := ColorToRGB(PaintInfo.Canvas.Font.Color);

        // Draw icon
        ImageList_DrawEx(SystemImages.Handle, iImageIndex, PaintInfo.Canvas.Handle, pImageRect.Left, pImageRect.Top, 0, 0, GetRGBColor(SystemImages.BkColor), ForegroundColor, Style[SystemImages.ImageType] or ExtraStyle);
        // Draw overlay icon
        ImageList_DrawEx(StatesImages.Handle, iOverlayIndex, PaintInfo.Canvas.Handle, pImageRect.Left, pImageRect.Top, 0, 0, GetRGBColor(SystemImages.BkColor), ForegroundColor, Style[SystemImages.ImageType] or ExtraStyle);
      end;
      1:
      begin
        sCellText := pData.pLuaEditFile.DisplayPath;
        DrawText(PaintInfo.Canvas.Handle, PChar(sCellText), Length(sCellText), pRect, DT_TOP or DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_PATH_ELLIPSIS);
      end;
    end;
  end;
end;

procedure TfrmProjectTree.FormCreate(Sender: TObject);
var
  SFI: TSHFileInfo;
  pBitmap: TBitmap;
  pIcon: TIcon;
begin
  // Load system images...
  SystemImages.Handle := SHGetFileInfo('', 0, SFI, SizeOf(SFI), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  SystemImages.ShareImages := True;

  try
    // Load overlay icons...
    pBitmap := TBitmap.Create;
    pIcon := TIcon.Create;

    pIcon.LoadFromFile(GetLuaEditInstallPath() + '\Graphics\FileIsNew.ico');
    StatesImages.AddIcon(pIcon);
    pIcon.LoadFromFile(GetLuaEditInstallPath() + '\Graphics\FileNotLoaded.ico');
    StatesImages.AddIcon(pIcon);
    pIcon.LoadFromFile(GetLuaEditInstallPath() + '\Graphics\FileIsReadOnly.ico');
    StatesImages.AddIcon(pIcon);
    pIcon.LoadFromFile(GetLuaEditInstallPath() + '\Graphics\FileHasChanged.ico');
    StatesImages.AddIcon(pIcon);
    pIcon.LoadFromFile(GetLuaEditInstallPath() + '\Graphics\FileIsOK.ico');
    StatesImages.AddIcon(pIcon);
  finally
    FreeAndNil(pBitmap);
    FreeAndNil(pIcon);
  end;
end;

procedure TfrmProjectTree.vstProjectTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  pData: PProjectTreeData;
  WinDir: String;
begin
  pData := Sender.GetNodeData(Node);

  // If the pLuaEditFile member is not initialize at this point, we assume it's a project folder
  if not Assigned(pData.pLuaEditFile) then
  begin
    SetLength(WinDir, GetWindowsDirectory(nil, 0)); 
    GetWindowsDirectory(PChar(WinDir), Length(WinDir));
    GetOpenAndClosedIcons(WinDir, pData.OpenIndex, pData.CloseIndex);
  end
  else
    GetOpenAndClosedIcons(pData.pLuaEditFile.Path, pData.OpenIndex, pData.CloseIndex);
end;

procedure TfrmProjectTree.N3Click(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  pNode := vstProjectTree.GetFirstSelected();

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);

    if TLuaEditFile(pData).FileType = otLuaEditProject then
      if SaveProjectsInc then
        TLuaEditProject(pData).SaveInc(TLuaEditProject(pData).Path)
      else
        TLuaEditProject(pData).Save(TLuaEditProject(pData).Path)
    else
      frmLuaEditMain.DoSaveExecute(TLuaEditBasicTextFile(pData));
  end;
end;

procedure TfrmProjectTree.SaveAs1Click(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PProjectTreeData;
begin
  pNode := vstProjectTree.GetFirstSelected();

  if Assigned(pNode) then
  begin
    pData := vstProjectTree.GetNodeData(pNode);

    if TLuaEditFile(pData).FileType = otLuaEditProject then
      if SaveProjectsInc then
        TLuaEditProject(pData).SaveInc(TLuaEditProject(pData).Path, False, True)
      else
        TLuaEditProject(pData).Save(TLuaEditProject(pData).Path, False, True)
    else
      frmLuaEditMain.DoSaveAsExecute(TLuaEditBasicTextFile(pData));
  end;
end;

end.
