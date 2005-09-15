unit LuaGlobals;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, JvComponent, JvDockControlForm, VirtualTrees, LuaUtils;

type
  TfrmLuaGlobals = class(TForm)
    JvDockClient1: TJvDockClient;
    vstGlobals: TVirtualStringTree;
    procedure vstGlobalsGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure vstGlobalsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLuaGlobals: TfrmLuaGlobals;

implementation

{$R *.dfm}

procedure TfrmLuaGlobals.vstGlobalsGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TBasicTreeData);
end;

procedure TfrmLuaGlobals.vstGlobalsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  pData: PBasicTreeData;
begin
  // Set text to display for all nodes
  if TextType = ttNormal then
  begin
    case Column of
      0:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.sName;
      end;
      1:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.sValue;
      end;
    end;
  end;
end;

end.
