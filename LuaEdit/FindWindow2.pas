unit FindWindow2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, VirtualTrees, JvComponent, JvDockControlForm,
  JvExComCtrls, JvListView, JvDotNetControls;

type
  TfrmFindWindow2 = class(TForm)
    JvDockClient1: TJvDockClient;
    lvwResult: TJvDotNetListView;
    procedure lvwResultCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lvwResultDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddResult(FileName: String; Line: Integer; Snipset: String);
  end;

var
  frmFindWindow2: TfrmFindWindow2;

implementation

uses Main;

{$R *.dfm}

procedure TfrmFindWindow2.AddResult(FileName: String; Line: Integer; Snipset: String);
var
  pListitem: TListItem;
begin
  pListitem := lvwResult.Items.Add;
  pListitem.Caption := FileName;
  pListitem.SubItems.Add(IntToStr(Line));
  pListitem.SubItems.Add(Snipset);
end;

procedure TfrmFindWindow2.lvwResultCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  cx, cy: Integer;
begin
  {DefaultDraw := True;

  // Handle the snipset column
  if SubItem = 1 then
  begin
    DefaultDraw := False;
  end;}
end;

procedure TfrmFindWindow2.lvwResultDblClick(Sender: TObject);
begin
  // Bring the file in the editor and go directly to the line where it's defined
  if Assigned(lvwResult.Selected) then
    frmMain.PopUpUnitToScreen(lvwResult.Selected.Caption, StrToInt(lvwResult.Selected.SubItems[0]), False, HIGHLIGHT_STACK);
end;

end.
