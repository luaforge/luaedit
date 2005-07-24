unit AddBreakpoint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, lua, lualib, lauxlib, LuaUtils;

type
  TfrmAddBreakpoint = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    cboUnits: TComboBox;
    Label2: TLabel;
    txtCondition: TEdit;
    Label3: TLabel;
    txtLine: TEdit;
    procedure txtLineKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddBreakpoint: TfrmAddBreakpoint;

implementation

uses Main, Breakpoints;

{$R *.dfm}

procedure TfrmAddBreakpoint.txtLineKeyPress(Sender: TObject; var Key: Char);
begin
  if ((not (Ord(Key) in [48..57])) and (not (Ord(Key) = 8))) then
    Key := Char(0);
end;

procedure TfrmAddBreakpoint.Button2Click(Sender: TObject);
var
  ReturnMsg: String;
  L: PLua_State;
  pBreakpoint: TBreakpoint;
begin
  ModalResult := mrNone;

  if cboUnits.ItemIndex = -1 then
  begin
    Application.MessageBox('Please choose a unit where to add the breakpoint.', 'LuaEdit', MB_OK+MB_ICONERROR);
    cboUnits.SetFocus;
    Exit;
  end;

  if txtLine.Text = '' then
  begin
    Application.MessageBox('Please choose a line where to add the breakpoint.', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtLine.SetFocus;
    Exit;
  end;

  if TLuaUnit(cboUnits.Items.Objects[cboUnits.ItemIndex]).pDebugInfos.GetBreakpointAtLine(StrToInt(txtLine.Text)) <> nil then
  begin
    Application.MessageBox(PChar('There is already a breakpoint set at line number '+txtLine.Text+'!'), 'LuaEdit', MB_OK+MB_ICONERROR);
    txtLine.SetFocus;
    Exit;
  end;

  if txtCondition.Text <> '' then
  begin
    L := lua_open;

    // test the given expression
    if luaL_loadbuffer(L, PChar('return ('+txtCondition.Text+')'), Length('return ('+txtCondition.Text+')'), 'Main') <> 0 then
    begin
      ReturnMsg := lua_tostring(L, 1);
      ReturnMsg := Copy(ReturnMsg, Pos(':', ReturnMsg) + 1, Length(ReturnMsg) - Pos(':', ReturnMsg));
      ReturnMsg := Copy(ReturnMsg, Pos(':', ReturnMsg) + 1, Length(ReturnMsg) - Pos(':', ReturnMsg));
      Application.MessageBox(PChar('The expression "'+txtCondition.Text+'" is not a valid expression: '#13#10#13#10#13#10+ReturnMsg), 'LuaEdit', MB_OK+MB_ICONERROR);
      txtCondition.SetFocus;
      Exit;
    end;

    lua_close(L);
  end;

  if txtLine.Text = '' then
  begin
    Application.MessageBox('You must specify a line number where to insert the breakpoint!', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtLine.SetFocus;
    Exit;
  end
  else if (StrToInt(txtLine.Text) > TLuaUnit(cboUnits.Items.Objects[cboUnits.ItemIndex]).synUnit.Lines.Count) or (StrToInt(txtLine.Text) < 1) then
  begin
    Application.MessageBox(PChar('The line number must stands between 1 and '+IntToStr(TLuaUnit(cboUnits.Items.Objects[cboUnits.ItemIndex]).synUnit.Lines.Count)+' for the unit "'+TLuaUnit(cboUnits.Items.Objects[cboUnits.ItemIndex]).sName+'"'), 'LuaEdit', MB_OK+MB_ICONERROR);
    txtLine.SetFocus;
    Exit;
  end;

  if cboUnits.Text = '' then
  begin
    Application.MessageBox('You must select a unit where to insert the breakpoint!', 'LuaEdit', MB_OK+MB_ICONERROR);
    cboUnits.SetFocus;
    Exit;
  end;

  pBreakpoint := TBreakpoint.Create;
  pBreakpoint.sCondition := txtCondition.Text;
  pBreakpoint.iLine := StrToInt(txtLine.Text);
  TLuaUnit(cboUnits.Items.Objects[cboUnits.ItemIndex]).pDebugInfos.lstBreakpoint.Add(pBreakpoint);
  frmBreakpoints.RefreshBreakpointList;

  if Assigned(frmMain.jvUnitBar.SelectedTab.Data) then
    TLuaUnit(frmMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
    
  ModalResult := mrOk;
end;

procedure TfrmAddBreakpoint.FormShow(Sender: TObject);
var
  x: Integer;
begin
  cboUnits.Items.Clear;

  for x := 0 to LuaOpenedUnits.Count - 1 do
  begin
    cboUnits.AddItem(TLuaUnit(LuaOpenedUnits.Items[x]).sName, LuaOpenedUnits.Items[x]);
  end;

  txtCondition.Text := '';
  txtLine.Text := '';
end;

end.
