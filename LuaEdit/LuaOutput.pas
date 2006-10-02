unit LuaOutput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, JvComponent, JvDockControlForm,
  VirtualTrees, Menus, Clipbrd;

type
  PLuaOutputLine = ^TPLuaOutputLine;
  TPLuaOutputLine = record
    FileName:   String;
    LineText:   String;
    LineNumber: Integer;
  end;

  TfrmLuaOutput = class(TForm)
    JvDockClient1: TJvDockClient;
    vstLuaOutput: TVirtualStringTree;
    ppmLuaOutput: TPopupMenu;
    Clear1: TMenuItem;
    N1: TMenuItem;
    FindSource1: TMenuItem;
    Copy1: TMenuItem;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    ClearAll1: TMenuItem;
    procedure vstLuaOutputGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstLuaOutputGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ppmLuaOutputPopup(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure FindSource1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure ClearAll1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Put(FileName, LineText: String; LineNumber: Integer);
  end;

var
  frmLuaOutput: TfrmLuaOutput;

implementation

uses Main, Misc;

{$R *.dfm}

procedure TfrmLuaOutput.Put(FileName, LineText: String; LineNumber: Integer);
var
  pData: PLuaOutputLine;
  pNode: PVirtualNode;
begin
  if LineText <> #13#10 then
  begin
    pNode := vstLuaOutput.AddChild(vstLuaOutput.RootNode);
    pData := vstLuaOutput.GetNodeData(pNode);
    pData.FileName := FileName;
    pData.LineText := '> ' + LineText;
    pData.LineNumber := LineNumber;
  end;
end;

procedure TfrmLuaOutput.vstLuaOutputGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  pData: PLuaOutputLine;
begin
  case Column of
    -1:
    begin
      pData := vstLuaOutput.GetNodeData(Node);
      CellText := pData.LineText;
    end;
  end;
end;

procedure TfrmLuaOutput.vstLuaOutputGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TPLuaOutputLine);
end;

procedure TfrmLuaOutput.ppmLuaOutputPopup(Sender: TObject);
begin
  ClearAll1.Enabled := True;
  SelectAll1.Enabled := True;
  FindSource1.Enabled := (vstLuaOutput.SelectedCount = 1);
  Clear1.Enabled := (vstLuaOutput.SelectedCount > 0);
  Copy1.Enabled := (vstLuaOutput.SelectedCount > 0);
end;

procedure TfrmLuaOutput.SelectAll1Click(Sender: TObject);
begin
  vstLuaOutput.SelectAll(False);
end;

procedure TfrmLuaOutput.Copy1Click(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PLuaOutputLine;
  ClipboardText: String;
begin
  ClipboardText := '';
  pNode := vstLuaOutput.GetFirstSelected();

  while Assigned(pNode) do
  begin
    pData := vstLuaOutput.GetNodeData(pNode);
    ClipboardText := ClipboardText + pData.LineText;
    pNode := vstLuaOutput.GetNextSelected(pNode);

    // Add carriage return if required
    if Assigned(pNode) then
      ClipboardText := ClipboardText + #13#10;
  end;

  Clipboard.SetTextBuf(PChar(ClipboardText));
end;

procedure TfrmLuaOutput.FindSource1Click(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PLuaOutputLine;
begin
  pNode := vstLuaOutput.GetFirstSelected();
  
  if Assigned(pNode) then
  begin
    pData := vstLuaOutput.GetNodeData(pNode);
    frmLuaEditMain.PopUpUnitToScreen(pData.FileName, pData.LineNumber, False, HIGHLIGHT_SELECT);
  end;
end;

procedure TfrmLuaOutput.Clear1Click(Sender: TObject);
begin
  vstLuaOutput.DeleteSelectedNodes();
end;

procedure TfrmLuaOutput.ClearAll1Click(Sender: TObject);
begin
  vstLuaOutput.Clear;
end;

end.
