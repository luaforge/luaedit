unit Breakpoints;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, lua, lualib, lauxlib,
  LuaUtils, Menus, JvExComCtrls, JvHeaderControl, JvComponent,
  JvDockControlForm, ToolWin, JvListView, JvDotNetControls, TypInfo;

type
  TfrmBreakpoints = class(TForm)
    Panel2: TPanel;
    imlBreakpoints: TImageList;
    popmBreakpoints: TPopupMenu;
    RemoveBreakpoint1: TMenuItem;
    N1: TMenuItem;
    Goto1: TMenuItem;
    Condition1: TMenuItem;
    JvDockClient1: TJvDockClient;
    tlbBreakpoints: TToolBar;
    tbtnAdd: TToolButton;
    tbtnToggle: TToolButton;
    tbtnRemove: TToolButton;
    tbtnDisableAllBreakpoints: TToolButton;
    ToolButton5: TToolButton;
    tbtnAllRemove: TToolButton;
    ToolButton7: TToolButton;
    tbtnGoto: TToolButton;
    tbtnEditCondition: TToolButton;
    lvwBreakpoints: TJvDotNetListView;
    tbtnEnableAllBreakpoints: TToolButton;
    procedure tbtnGotoClick(Sender: TObject);
    procedure tbtnEditConditionClick(Sender: TObject);
    procedure lvwBreakpointsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure RefreshBreakpointList;
    procedure tbtnRemoveClick(Sender: TObject);
    procedure tbtnToggleClick(Sender: TObject);
    procedure lvwBreakpointsDblClick(Sender: TObject);
    procedure tbtnDisableAllBreakpointsClick(Sender: TObject);
    procedure tbtnEnableAllBreakpointsClick(Sender: TObject);
    procedure tbtnAllRemoveClick(Sender: TObject);
    procedure lvwBreakpointsChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure tbtnAddClick(Sender: TObject);
    procedure popmBreakpointsPopup(Sender: TObject);
    procedure Condition1Click(Sender: TObject);
    procedure Goto1Click(Sender: TObject);
    procedure RemoveBreakpoint1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WasItemChecked: Boolean;
  end;

var
  frmBreakpoints: TfrmBreakpoints;

implementation

uses Main, AddBreakpoint;

{$R *.dfm}

procedure TfrmBreakpoints.RefreshBreakpointList;
var
  x, y: Integer;
  SubItem: TListItem;
  pLuaUnit: TLuaUnit;
begin
  // Begin update and claer actual list
  lvwBreakpoints.Items.BeginUpdate();
  lvwBreakpoints.Items.Clear();

  // Add all breakpoints in the listview
  for x := 0 to LuaOpenedUnits.Count - 1 do
  begin
    pLuaUnit := TLuaUnit(LuaOpenedUnits.Items[x]);

    for y := 0 to pLuaUnit.pDebugInfos.lstBreakpoint.Count - 1 do
    begin
      SubItem := lvwBreakpoints.Items.Add;

      if TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[y]).iStatus = BKPT_ENABLED then
      begin
        SubItem.Checked := True;
        WasItemChecked := True;
        Subitem.ImageIndex := 7;
      end
      else
      begin
        SubItem.Checked := False;
        WasItemChecked := False;
        Subitem.ImageIndex := 8;
      end;

      SubItem.Data := pLuaUnit;
      SubItem.Caption := pLuaUnit.sName+', line '+IntToStr(TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[y]).iLine);

      if TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[y]).sCondition <> '' then
        SubItem.SubItems.Add(TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[y]).sCondition)
      else
        SubItem.SubItems.Add('(no condition)');

      SubItem.SubItems.Add(IntToStr(TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[y]).iHitCount));
      SubItem.SubItems.Add(IntToStr(TBreakpoint(pLuaUnit.pDebugInfos.lstBreakpoint.Items[y]).iLine));
    end;
  end;

  // End update
  lvwBreakpoints.Items.EndUpdate();

  // Control buttons enable status
  if lvwBreakpoints.Items.Count = 0 then
  begin
    tbtnEditCondition.Enabled := False;
    tbtnGoto.Enabled := False;
    tbtnRemove.Enabled := False;
    tbtnToggle.Enabled := False;
    tbtnDisableAllBreakpoints.Enabled := False;
    tbtnEnableAllBreakpoints.Enabled := False;
    tbtnAllRemove.Enabled := False;
  end;

  if LuaOpenedUnits.Count = 0 then
    tbtnAdd.Enabled := False
  else
    tbtnAdd.Enabled := True;
end;

procedure TfrmBreakpoints.tbtnGotoClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if Assigned(lvwBreakpoints.Selected) then
  begin
    ModalResult := mrOk;

    if frmMain.GetAssociatedTab(TLuaUnit(lvwBreakpoints.Selected.Data)) = nil then
    begin
      frmMain.AddFileInTab(TLuaUnit(lvwBreakpoints.Selected.Data));
    end
    else
    begin
      frmMain.GetAssociatedTab(TLuaUnit(lvwBreakpoints.Selected.Data)).Selected := True;
    end;

    TLuaUnit(lvwBreakpoints.Selected.Data).synUnit.GotoLineAndCenter(StrToInt(lvwBreakpoints.Selected.SubItems.Strings[2]));
  end;
end;

procedure TfrmBreakpoints.tbtnEditConditionClick(Sender: TObject);
var
  Answer: String;
  ReturnMsg: String;
  L: PLua_State;
begin
  if Assigned(lvwBreakpoints.Selected) then
  begin
    Answer := InputBox('Breakpoint Condition', 'Enter condition for selected breakpoint:', lvwBreakpoints.Selected.SubItems.Strings[0]);
    if Answer <> lvwBreakpoints.Selected.SubItems.Strings[1] then
    begin
      L := lua_open;

      // test the given expression
      if luaL_loadbuffer(L, PChar('return ('+Answer+')'), Length('return ('+Answer+')'), 'Main') <> 0 then
      begin
        ReturnMsg := lua_tostring(L, 1);
        ReturnMsg := Copy(ReturnMsg, Pos(':', ReturnMsg) + 1, Length(ReturnMsg) - Pos(':', ReturnMsg));
        ReturnMsg := Copy(ReturnMsg, Pos(':', ReturnMsg) + 1, Length(ReturnMsg) - Pos(':', ReturnMsg));
        Application.MessageBox(PChar('The expression "'+Answer+'" is not a valid expression: '#13#10#13#10#13#10+ReturnMsg), 'LuaEdit', MB_OK+MB_ICONERROR);
      end
      else
      begin
        lvwBreakpoints.Selected.SubItems.Strings[0] := Answer;
        TLuaUnit(lvwBreakpoints.Selected.Data).pDebugInfos.GetBreakpointAtLine(StrToInt(lvwBreakpoints.Selected.SubItems.Strings[2])).sCondition := Answer;
      end;

      lua_close(L);
    end;
  end;
end;

procedure TfrmBreakpoints.lvwBreakpointsChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if Assigned(Item) then
  begin
    tbtnEditCondition.Enabled := Assigned(lvwBreakpoints.Selected);
    tbtnGoto.Enabled := Assigned(lvwBreakpoints.Selected);
    tbtnRemove.Enabled := Assigned(lvwBreakpoints.Selected);
    tbtnToggle.Enabled := Assigned(lvwBreakpoints.Selected);
    tbtnAllRemove.Enabled := Assigned(lvwBreakpoints.Selected);
    tbtnDisableAllBreakpoints.Enabled := Assigned(lvwBreakpoints.Selected);
    tbtnEnableAllBreakpoints.Enabled := Assigned(lvwBreakpoints.Selected);

    if WasItemChecked <> Item.Checked then
    begin
      if Assigned(Item.Data) then
      begin
        if TLuaUnit(Item.Data).pDebugInfos.GetBreakpointStatus(StrToInt(Item.SubItems.Strings[2])) = BKPT_DISABLED then
        begin
          TLuaUnit(Item.Data).pDebugInfos.GetBreakpointAtLine(StrToInt(Item.SubItems.Strings[2])).iStatus := BKPT_ENABLED;
          Item.ImageIndex := 7;
        end
        else
        begin
          TLuaUnit(Item.Data).pDebugInfos.GetBreakpointAtLine(StrToInt(Item.SubItems.Strings[2])).iStatus := BKPT_DISABLED;
          Item.ImageIndex := 8;
        end;

        if Assigned(pCurrentSynEdit) then
          pCurrentSynEdit.Refresh;
      end;
    end;
  end;
end;

procedure TfrmBreakpoints.tbtnRemoveClick(Sender: TObject);
begin
  if Assigned(lvwBreakpoints.Selected) then
  begin
    TLuaUnit(lvwBreakpoints.Selected.Data).pDebugInfos.RemoveBreakpointAtLine(StrToInt(lvwBreakpoints.Selected.SubItems.Strings[2]));
    lvwBreakpoints.Selected.Delete;
  end;

  if Assigned(pCurrentSynEdit) then
    pCurrentSynEdit.Refresh;
end;

procedure TfrmBreakpoints.tbtnToggleClick(Sender: TObject);
begin
  if Assigned(lvwBreakpoints.Selected) then
  begin
    if TLuaUnit(lvwBreakpoints.Selected.Data).pDebugInfos.GetBreakpointStatus(StrToInt(lvwBreakpoints.Selected.SubItems.Strings[2])) = BKPT_DISABLED then
    begin
      TLuaUnit(lvwBreakpoints.Selected.Data).pDebugInfos.GetBreakpointAtLine(StrToInt(lvwBreakpoints.Selected.SubItems.Strings[2])).iStatus := BKPT_ENABLED;
      lvwBreakpoints.Selected.Checked := True;
      lvwBreakpoints.Selected.ImageIndex := 7;
    end
    else
    begin
      TLuaUnit(lvwBreakpoints.Selected.Data).pDebugInfos.GetBreakpointAtLine(StrToInt(lvwBreakpoints.Selected.SubItems.Strings[2])).iStatus := BKPT_DISABLED;
      lvwBreakpoints.Selected.Checked := False;
      lvwBreakpoints.Selected.ImageIndex := 8;
    end;
  end;

  if Assigned(pCurrentSynEdit) then
    pCurrentSynEdit.Refresh;
end;

procedure TfrmBreakpoints.lvwBreakpointsDblClick(Sender: TObject);
begin
  tbtnGoto.Click;
end;

procedure TfrmBreakpoints.tbtnDisableAllBreakpointsClick(Sender: TObject);
var
  x: Integer;
begin
  for x := 0 to lvwBreakpoints.Items.Count - 1 do
  begin
    lvwBreakpoints.Items[x].Checked := False;
  end;

  if Assigned(pCurrentSynEdit) then
    pCurrentSynEdit.Refresh;
end;

procedure TfrmBreakpoints.tbtnEnableAllBreakpointsClick(Sender: TObject);
var
  x: Integer;
begin
  for x := 0 to lvwBreakpoints.Items.Count - 1 do
  begin
    lvwBreakpoints.Items[x].Checked := True;
  end;

  if Assigned(pCurrentSynEdit) then
    pCurrentSynEdit.Refresh;
end;

procedure TfrmBreakpoints.tbtnAllRemoveClick(Sender: TObject);
begin
  if Application.MessageBox('Are you sure you want to remove all breakpoints?', 'LuaEdit', MB_YESNO+MB_ICONERROR) = IDYES then
  begin
    while Assigned(lvwBreakpoints.Items[0]) do
    begin
      TLuaUnit(lvwBreakpoints.Items[0].Data).pDebugInfos.RemoveBreakpointAtLine(StrToInt(lvwBreakpoints.Items[0].SubItems.Strings[2]));
      lvwBreakpoints.Items[0].Delete;
    end;

    if Assigned(pCurrentSynEdit) then
      pCurrentSynEdit.Refresh;
  end;
end;

procedure TfrmBreakpoints.lvwBreakpointsChanging(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  if Assigned(Item) then
    WasItemChecked := Item.Checked;
end;

procedure TfrmBreakpoints.FormCreate(Sender: TObject);
begin
  RefreshBreakpointList;
end;

procedure TfrmBreakpoints.tbtnAddClick(Sender: TObject);
begin
  if frmAddBreakpoint.ShowModal = mrOk then
    RefreshBreakpointList;
end;

procedure TfrmBreakpoints.popmBreakpointsPopup(Sender: TObject);
begin
  RemoveBreakpoint1.Enabled := (lvwBreakpoints.Items.Count > 0);
  Goto1.Enabled := (lvwBreakpoints.Items.Count > 0);
  Condition1.Enabled := (lvwBreakpoints.Items.Count > 0);
end;

procedure TfrmBreakpoints.Condition1Click(Sender: TObject);
begin
  tbtnEditCondition.Click;
end;

procedure TfrmBreakpoints.Goto1Click(Sender: TObject);
begin
  tbtnGoto.Click;
end;

procedure TfrmBreakpoints.RemoveBreakpoint1Click(Sender: TObject);
begin
  tbtnRemove.Click;
end;

end.
