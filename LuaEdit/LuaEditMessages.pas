unit LuaEditMessages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvComponent, JvDockControlForm;

type
  TfrmLuaEditMessages = class(TForm)
    memMessages: TMemo;
    JvDockClient1: TJvDockClient;
    procedure memMessagesChange(Sender: TObject);
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

procedure TfrmLuaEditMessages.memMessagesChange(Sender: TObject);
begin
  LastMessage := memMessages.Lines.Strings[memMessages.Lines.Count - 1];
  frmMain.stbMain.Refresh;
end;

end.
