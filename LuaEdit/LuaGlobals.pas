unit LuaGlobals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvComponent, JvDockControlForm;

type
  TfrmLuaGlobals = class(TForm)
    JvDockClient1: TJvDockClient;
    tvwLuaGlobals: TTreeView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLuaGlobals: TfrmLuaGlobals;

implementation

{$R *.dfm}

end.
