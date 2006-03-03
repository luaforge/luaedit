unit LuaLocals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvDockControlForm, ComCtrls, StdCtrls,
  JvExStdCtrls, JvListBox;

type
  TfrmLuaLocals = class(TForm)
    JvDockClient1: TJvDockClient;
    lstLocals: TJvListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLuaLocals: TfrmLuaLocals;

implementation

{$R *.dfm}

end.
