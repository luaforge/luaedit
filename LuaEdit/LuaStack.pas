unit LuaStack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Main, ExtCtrls, JvComponent, JvDockControlForm;

type
  TfrmLuaStack = class(TForm)
    lstLuaStack: TListBox;
    JvDockClient1: TJvDockClient;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLuaStack: TfrmLuaStack;

implementation

{$R *.dfm}

procedure TfrmLuaStack.FormActivate(Sender: TObject);
begin
  SendMessage(lstLuaStack.Handle, LB_SetHorizontalExtent, 1000, longint(0));
end;

end.
