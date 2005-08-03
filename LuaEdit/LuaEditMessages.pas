unit LuaEditMessages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvComponent, JvDockControlForm;

type
  TfrmLuaEditMessages = class(TForm)
    memMessages: TMemo;
    JvDockClient1: TJvDockClient;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLuaEditMessages: TfrmLuaEditMessages;

implementation

uses Main;

{$R *.dfm}

end.
