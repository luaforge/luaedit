unit LuaLocals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvDockControlForm, ComCtrls, StdCtrls;

type
  TfrmLuaLocals = class(TForm)
    JvDockClient1: TJvDockClient;
    lstLocals: TListBox;
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
