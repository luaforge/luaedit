unit LuaConsole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, JvComponent, JvDockControlForm,
  VirtualTrees, Menus, Clipbrd, Lua, LuaUtils;

type
  PLuaConsoleLine = ^TPLuaConsoleLine;
  TPLuaConsoleLine = record
    FileName:   String;
    LineText:   String;
    LineNumber: Integer;
  end;

  TfrmLuaConsole = class(TForm)
    JvDockClient1: TJvDockClient;
    vstLuaConsole: TVirtualStringTree;
    ppmLuaOutput: TPopupMenu;
    Clear1: TMenuItem;
    N1: TMenuItem;
    FindSource1: TMenuItem;
    Copy1: TMenuItem;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    ClearAll1: TMenuItem;
    Panel1: TPanel;
    cboConsole: TComboBox;
    procedure vstLuaConsoleGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstLuaConsoleGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ppmLuaOutputPopup(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure FindSource1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure ClearAll1Click(Sender: TObject);
    procedure vstLuaConsoleDblClick(Sender: TObject);
    procedure cboConsoleKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Put(FileName, LineText: String; LineNumber: Integer);
  end;

var
  frmLuaConsole: TfrmLuaConsole;

implementation

uses Main, Misc;

{$R *.dfm}

procedure TfrmLuaConsole.Put(FileName, LineText: String; LineNumber: Integer);
var
  pData: PLuaConsoleLine;
  pNode: PVirtualNode;
begin
  if LineText <> #13#10 then
  begin
    pNode := vstLuaConsole.AddChild(vstLuaConsole.RootNode);
    pData := vstLuaConsole.GetNodeData(pNode);
    pData.FileName := FileName;
    pData.LineText := LUA_PROMPT + LineText;
    pData.LineNumber := LineNumber;
  end;
end;

procedure TfrmLuaConsole.vstLuaConsoleGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  pData: PLuaConsoleLine;
begin
  case Column of
    -1:
    begin
      pData := vstLuaConsole.GetNodeData(Node);
      CellText := pData.LineText;
    end;
  end;
end;

procedure TfrmLuaConsole.vstLuaConsoleGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TPLuaConsoleLine);
end;

procedure TfrmLuaConsole.ppmLuaOutputPopup(Sender: TObject);
begin
  ClearAll1.Enabled := True;
  SelectAll1.Enabled := True;
  FindSource1.Enabled := (vstLuaConsole.SelectedCount = 1);
  Clear1.Enabled := (vstLuaConsole.SelectedCount > 0);
  Copy1.Enabled := (vstLuaConsole.SelectedCount > 0);
end;

procedure TfrmLuaConsole.SelectAll1Click(Sender: TObject);
begin
  vstLuaConsole.SelectAll(False);
end;

procedure TfrmLuaConsole.Copy1Click(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PLuaConsoleLine;
  ClipboardText: String;
begin
  ClipboardText := '';
  pNode := vstLuaConsole.GetFirstSelected();

  while Assigned(pNode) do
  begin
    pData := vstLuaConsole.GetNodeData(pNode);
    ClipboardText := ClipboardText + pData.LineText;
    pNode := vstLuaConsole.GetNextSelected(pNode);

    // Add carriage return if required
    if Assigned(pNode) then
      ClipboardText := ClipboardText + #13#10;
  end;

  Clipboard.SetTextBuf(PChar(ClipboardText));
end;

procedure TfrmLuaConsole.FindSource1Click(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PLuaConsoleLine;
begin
  pNode := vstLuaConsole.GetFirstSelected();
  
  if Assigned(pNode) then
  begin
    pData := vstLuaConsole.GetNodeData(pNode);
    frmLuaEditMain.PopUpUnitToScreen(pData.FileName, pData.LineNumber, False, HIGHLIGHT_SELECT);
  end;
end;

procedure TfrmLuaConsole.Clear1Click(Sender: TObject);
begin
  vstLuaConsole.DeleteSelectedNodes();
end;

procedure TfrmLuaConsole.ClearAll1Click(Sender: TObject);
begin
  vstLuaConsole.Clear;
end;

procedure TfrmLuaConsole.vstLuaConsoleDblClick(Sender: TObject);
begin
  FindSource1Click(Sender);
end;

procedure TfrmLuaConsole.cboConsoleKeyPress(Sender: TObject; var Key: Char);
var
  L: PLua_State;
  x, ArgToPop: Integer;
  CallResult, ArgVal: String;
begin
  L := frmLuaEditMain.LuaState;
  CallResult := '';

  if ((Key = Char(VK_RETURN)) and frmLuaEditMain.Running) then
  begin
    if luaL_loadstring(L, PChar(cboConsole.Text)) = 0 then
    begin
      x := lua_gettop(L) - 1;

      if lua_pcall(L, 0, LUA_MULTRET, 0) <> 0 then
      begin
        // retrieve error message...
        Application.MessageBox(lua_tostring(L, -1), 'LuaEdit', MB_OK + MB_ICONERROR);
        // Pop the error message from the lua stack
        lua_pop(L, 1);
      end;

      if x <> lua_gettop(L) then
      begin
        ArgToPop := lua_gettop(L) - x;
        
        for x := x to lua_gettop(L) - 1 do
        begin
          ArgVal := lua_tostring(L, x);

          if ArgVal = '' then
            ArgVal := 'nil';

          if CallResult = '' then
            CallResult := CallResult + ArgVal
          else
            CallResult := CallResult + '        ' + ArgVal;
        end;

        // Print the returned values
        Put('', CallResult, -1);
        // Pop all returned values from the lua stack
        lua_pop(L, ArgToPop);
      end;
    end
    else
      // retrieve error message...
      Application.MessageBox(lua_tostring(L, -1), 'LuaEdit', MB_OK + MB_ICONERROR);

    // Pop either the error message or the function pushed on the lua stack
    lua_pop(L, 1);

    // Add last entry to combobox' list
    if cboConsole.Items.Count > 0 then
    begin
      if cboConsole.Text <> cboConsole.Items[0] then
        cboConsole.Items.Insert(0, cboConsole.Text);
    end
    else
      cboConsole.Items.Add(cboConsole.Text);

    // Remove the text
    cboConsole.Text := '';

    // Remove 11th item (if any) to ensure there is never more than 10 items in the list
    if cboConsole.Items.Count > 10 then
      cboConsole.Items.Delete(11);
  end;
end;

end.
