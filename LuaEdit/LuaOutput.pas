unit LuaOutput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, JvComponent, JvDockControlForm;

type
  TfrmLuaOutput = class(TForm)
    JvDockClient1: TJvDockClient;
    memLuaOutput: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Put(const S: string);
  end;

var
  frmLuaOutput: TfrmLuaOutput;

implementation

uses Main;

{$R *.dfm}

procedure TfrmLuaOutput.Put(const S: string);
begin
  memLuaOutput.SelStart := Length(memLuaOutput.Text);
  memLuaOutput.SelLength := 0;
  memLuaOutput.SelText := S;
end;

end.
