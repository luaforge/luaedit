unit Watch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, ComCtrls, Menus, StdCtrls, ExtCtrls,
  JvComponent, JvDockControlForm;

type
  TfrmWatch = class(TForm)
    lvwWatch: TStringGrid;
    ppmWatch: TPopupMenu;
    memoSwap: TMemo;
    JvDockClient1: TJvDockClient;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lvwWatchKeyPress(Sender: TObject; var Key: Char);
    procedure lvwWatchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvwWatchSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWatch: TfrmWatch;

implementation

uses Main;

{$R *.dfm}

procedure TfrmWatch.FormShow(Sender: TObject);
begin
  lvwWatch.Rows[0].Strings[0] := 'Key';
  lvwWatch.Rows[0].Strings[1] := 'Value';
  lvwWatch.EditorMode := True;
end;

procedure TfrmWatch.FormResize(Sender: TObject);
begin
  lvwWatch.ColWidths[1] := lvwWatch.Width - lvwWatch.ColWidths[0] - 22;
end;

procedure TfrmWatch.lvwWatchKeyPress(Sender: TObject; var Key: Char);
begin
  if lvwWatch.Col = 1 then
    Key := #0;
end;

procedure TfrmWatch.lvwWatchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if lvwWatch.Col = 1 then
    Key := 0;
end;

procedure TfrmWatch.lvwWatchSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
begin
  frmMain.PrintWatch(frmMain.LuaState);
end;

end.
