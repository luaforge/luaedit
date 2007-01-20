unit LuaLocals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvDockControlForm, ComCtrls, StdCtrls,
  JvExStdCtrls, JvListBox, LuaUtils;

type
  TfrmLuaLocals = class(TForm)
    JvDockClient1: TJvDockClient;
    lstLocals: TJvListBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FillLocalsList(Locals: TList);
  end;

var
  frmLuaLocals: TfrmLuaLocals;

implementation

{$R *.dfm}

procedure TfrmLuaLocals.FillLocalsList(Locals: TList);
var
  x: Integer;
begin
  lstLocals.Clear;
  lstLocals.Items.BeginUpdate;

  for x := 0 to Locals.Count - 1 do
    lstLocals.AddItem(TLuaVariable(Locals[x]).Name + '=' + TLuaVariable(Locals[x]).Value, nil);

  lstLocals.Items.EndUpdate;
end;

end.
