unit ProjectTree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, CommCtrl, ExtCtrls, ImgList, Menus, JvComponent,
  JvDockControlForm, JvExComCtrls, JvComCtrls, JvDotNetControls;

type
  TfrmProjectTree = class(TForm)
    Panel1: TPanel;
    imlProjectTree: TImageList;
    ppmProjectTree: TPopupMenu;
    ActivateSelectedProject1: TMenuItem;
    N1: TMenuItem;
    UnloadFileProject1: TMenuItem;
    JvDockClient1: TJvDockClient;
    trvProjectTree: TJvDotNetTreeView;
    procedure trvProjectTreeDblClick(Sender: TObject);
    procedure trvProjectTreeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure trvProjectTreeAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure UnloadFileProject1Click(Sender: TObject);
    procedure ppmProjectTreePopup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BuildProjectTree;
  end;

var
  frmProjectTree: TfrmProjectTree;

implementation

uses Main;

{$R *.dfm}

procedure TfrmProjectTree.trvProjectTreeDblClick(Sender: TObject);
var
  pLuaUnit: TLuaUnit;
begin
  if (Assigned(frmProjectTree.trvProjectTree.Selected) and ((frmProjectTree.trvProjectTree.Selected.ImageIndex = 1) and (frmProjectTree.trvProjectTree.Selected.SelectedIndex = 1))) then
  begin
    pLuaUnit := TLuaUnit(frmProjectTree.trvProjectTree.Selected.Data);
    
    if pLuaUnit.IsLoaded then
    begin
      if LuaOpenedUnits.IndexOf(pLuaUnit) = -1 then
      begin
        frmMain.AddFileInTab(pLuaUnit);
      end
      else
      begin
        frmMain.GetAssociatedTab(pLuaUnit).Selected := True;
        
        if pLuaUnit.HasChanged then
          frmMain.stbMain.Panels[2].Text := 'Modified'
        else
          frmMain.stbMain.Panels[2].Text := '';

        frmMain.synEditClick(pLuaUnit.synUnit);
      end;
    end;
  end;

  frmMain.CheckButtons;
end;

procedure TfrmProjectTree.BuildProjectTree;
var
  pTempPrj: TLuaProject;
  pNewPrjNode, pNewNode: TTreeNode;
  x, y: integer;
begin
  pNewPrjNode := nil;
  pNewNode := nil;
  frmMain.jvchnNotifier.Active := False;
  frmMain.jvchnNotifier.Notifications.Clear;
  frmProjectTree.trvProjectTree.Items.BeginUpdate;
  frmProjectTree.trvProjectTree.Items.Clear;

  for x := 0 to LuaProjects.Count - 1 do
  begin
    pTempPrj := TLuaProject(LuaProjects.Items[x]);

    if pTempPrj.sPrjName <> '[@@SingleUnits@@]' then
    begin
      // Adding single unit (projectless) to the tree
      pNewPrjNode := frmProjectTree.trvProjectTree.Items.Add(nil, pTempPrj.sPrjName + ' (' + pTempPrj.sPrjPath + ')');
      pNewPrjNode.Data := pTempPrj;
      pNewPrjNode.ImageIndex := 0;
      pNewPrjNode.SelectedIndex := 0;

      // Adding project root to change notifier...
      if not pTempPrj.IsNew then
        frmMain.AddToNotifier(ExtractFileDir(pTempPrj.sPrjPath));
    end;

    for y := 0 to pTempPrj.lstUnits.Count - 1 do
    begin
      pNewNode := frmProjectTree.trvProjectTree.Items.AddChild(pNewPrjNode, ExtractFileName(TLuaUnit(pTempPrj.lstUnits.Items[y]).sName) + '   (' + TLuaUnit(pTempPrj.lstUnits.Items[y]).sUnitPath + ')');
      if TLuaUnit(pTempPrj.lstUnits.Items[y]).IsLoaded then
      begin
        pNewNode.ImageIndex := 1;
        pNewNode.SelectedIndex := 1;
      end
      else
      begin
        pNewNode.ImageIndex := 2;
        pNewNode.SelectedIndex := 2;
      end;

      pNewNode.Data := TLuaUnit(pTempPrj.lstUnits.Items[y]);

      // Adding unit root to change notifier...
      if not TLuaUnit(pTempPrj.lstUnits.Items[y]).IsNew then
        frmMain.AddToNotifier(ExtractFileDir(TLuaUnit(pTempPrj.lstUnits.Items[y]).sUnitPath));
    end;

    if Assigned(pNewPrjNode) then
      pNewPrjNode.Expand(True);
  end;

  frmProjectTree.trvProjectTree.Items.EndUpdate;
  if frmMain.jvchnNotifier.Notifications.Count > 0 then
    frmMain.jvchnNotifier.Active := True;
end;

procedure TfrmProjectTree.trvProjectTreeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  frmMain.CheckButtons;
end;

procedure TfrmProjectTree.trvProjectTreeAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
  if Stage = cdPrepaint then
  begin
    Sender.Canvas.Font.Style := [];

    if ((Node.ImageIndex = 2) or (Node.SelectedIndex = 2)) then
    begin
      if not TLuaUnit(Node.Data).IsLoaded then
      begin
        Sender.Canvas.Font.Color := clGray;
      end;
    end
    else if ((Node.ImageIndex = 0) or (Node.SelectedIndex = 0)) then
    begin
      if TLuaProject(Node.Data) = ActiveProject then
      begin
        Sender.Canvas.Font.Style := [fsBold];
        frmMain.Caption := 'LuaEdit - ' + TLuaProject(Node.Data).sPrjName;
      end;
    end;
  end;
end;

procedure TfrmProjectTree.UnloadFileProject1Click(Sender: TObject);
var
  pLuaPrj: TLuaProject;
  pLuaUnit: TLuaUnit;
  Answer, x: Integer;
  UnitsToDelete: TList;
begin
  if Assigned(trvProjectTree.Selected) then
  begin
    UnitsToDelete := TList.Create;
    
    // Case where the selected file was a project
    if ((trvProjectTree.Selected.ImageIndex = 0) or (trvProjectTree.Selected.SelectedIndex = 0)) then
    begin
      pLuaPrj := TLuaProject(trvProjectTree.Selected.Data);

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
    else if ((trvProjectTree.Selected.ImageIndex = 1) or (trvProjectTree.Selected.SelectedIndex = 1)) then
    begin
      pLuaUnit := TLuaUnit(trvProjectTree.Selected.Data);

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
begin
  if Assigned(trvProjectTree.Selected) then
  begin
    if ((trvProjectTree.Selected.ImageIndex = 0) or (trvProjectTree.Selected.SelectedIndex = 0)) then
    begin
      UnloadFileProject1.Enabled := True;
    end
    else if ((trvProjectTree.Selected.ImageIndex = 1) or (trvProjectTree.Selected.SelectedIndex = 1)) then
    begin
      if not Assigned(trvProjectTree.Selected.Parent) then
      begin
        UnloadFileProject1.Enabled := True;
      end
      else
      begin
        UnloadFileProject1.Enabled := False;
      end;
    end
    else
    begin
      UnloadFileProject1.Enabled := False;
    end;
  end
  else
  begin
    UnloadFileProject1.Enabled := False;
  end;
end;

end.
