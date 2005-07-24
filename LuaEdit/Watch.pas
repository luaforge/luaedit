unit Watch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, ComCtrls, Menus, StdCtrls, ExtCtrls, SynEdit,
  JvComponent, JvDockControlForm, JvDragDrop, VirtualTrees, ActiveX,
  ImgList, ToolWin;

type
  PWatchNodeData = ^TWatchNodeData;
  TWatchNodeData = record
    Value: String;
    Name: String;
    NestedTableCount: Integer;
  end;

  // Our own edit link to implement several different node editors.
  TEditLinker = class(TInterfacedObject, IVTEditLink)
  private
    FEdit: TWinControl;        // One of the property editor classes.
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    destructor Destroy; override;

    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure SetBounds(R: TRect); stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
  end;

  TfrmWatch = class(TForm)
    ppmWatch: TPopupMenu;
    memoSwap: TMemo;
    JvDockClient1: TJvDockClient;
    vstWatch: TVirtualStringTree;
    tblWatch: TToolBar;
    tbtnAddWatch: TToolButton;
    ToolButton1: TToolButton;
    tbtnRefreshWatch: TToolButton;
    imlWatch: TImageList;
    procedure vstWatchGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstWatchEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstWatchCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstWatchGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure vstWatchAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure vstWatchDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure vstWatchDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure tbtnRefreshWatchClick(Sender: TObject);
    procedure tbtnAddWatchClick(Sender: TObject);
    procedure vstWatchEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
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

////////////////////////////////////// TEditLinker implementation //////////////////////////////////////

destructor TEditLinker.Destroy;

begin
  FreeAndNil(FEdit);
  inherited;
end;

procedure TEditLinker.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanAdvance: Boolean;
begin
  CanAdvance := true;

  case Key of
    VK_ESCAPE:
      if CanAdvance then
      begin
        FTree.CancelEditNode;
        Key := 0;
      end;
    VK_RETURN:
      if CanAdvance then
      begin
        FTree.EndEditNode;
        Key := 0;
      end;

    VK_UP,
    VK_DOWN:
      begin
        // Consider special cases before finishing edit mode.
        CanAdvance := Shift = [];

        if CanAdvance then
        begin
          // Forward the keypress to the tree. It will asynchronously change the focused node.
          PostMessage(FTree.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

function TEditLinker.BeginEdit: Boolean;
begin
  Result := True;
  FEdit.Show;
  FEdit.SetFocus;
end;

function TEditLinker.CancelEdit: Boolean;
begin
  Result := True;
  FEdit.Hide;
end;

function TEditLinker.EndEdit: Boolean;
var
  Data: PWatchNodeData;
  Buffer: array[0..1024] of Char;
  S: String;
begin
  Result := True;

  Data := FTree.GetNodeData(FNode);
  GetWindowText(FEdit.Handle, Buffer, 1024);
  S := Buffer;

  if S <> Data.Name then
  begin
    Data.Name := S;
    FTree.InvalidateNode(FNode);
  end;

  FEdit.Hide;
  FTree.SetFocus;
end;

procedure TEditLinker.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
end;

function TEditLinker.GetBounds: TRect;
begin
  Result := FEdit.BoundsRect;
end;

function TEditLinker.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Data: PWatchNodeData;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;

  // determine what edit type actually is needed
  FreeAndNil(FEdit);
  Data := FTree.GetNodeData(Node);
  FEdit := TEdit.Create(Tree);
  with FEdit as TEdit do
  begin
    Visible := False;
    Parent := Tree;
    AutoSize := False;
    MaxLength := 1000;
    Ctl3D := False;
    Text := Data.Name;
    OnKeyDown := EditKeyDown;
  end;
end;

procedure TEditLinker.ProcessMessage(var Message: TMessage);
begin
  // Do nothing
end;

////////////////////////////////////// TfrmWatch implementation //////////////////////////////////////

procedure TfrmWatch.vstWatchCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  // Create the editor class wich will interact with the user when editing a variable name
  EditLink := TEditLinker.Create;
end;

// This is called whenever the tree needs to get the text for the current cell
procedure TfrmWatch.vstWatchGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  pData: PWatchNodeData;
begin
  if TextType = ttNormal then
  begin
    case Column of
      0:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.Name;
      end;
      1:
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.Value
      end;
    end;
  end;
end;

procedure TfrmWatch.vstWatchEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := ((Column = 0) and (Node.Parent = Sender.RootNode));
end;

procedure TfrmWatch.vstWatchGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TWatchNodeData);
end;

procedure TfrmWatch.vstWatchAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var
  pRect: TRect;
begin
  pRect := ItemRect;
  pRect.Bottom := pRect.Bottom - 1;
  pRect.Right := pRect.Left + 22;
  TargetCanvas.Brush.Color := clWhite;
  TargetCanvas.FillRect(pRect);

  // Draw node button since the noda has some child
  if ((Node.Parent = Sender.RootNode) and (Node.ChildCount <> 0)) then
  begin
    // Draw the frame around the button
    TargetCanvas.Pen.Color := clBtnShadow;
    TargetCanvas.Rectangle(5, 4, 14, 13);
    TargetCanvas.MoveTo(14, 8);
    TargetCanvas.LineTo(20, 8);
    TargetCanvas.Pen.Color := clBlack;

    if not (vsExpanded in Node.States) then
    begin
      // Draw expandable node button (plus sign)
      TargetCanvas.MoveTo(7, 8);
      TargetCanvas.LineTo(12, 8);
      TargetCanvas.MoveTo(9, 6);
      TargetCanvas.LineTo(9, 11);
    end
    else
    begin
      // Draw non-expandable node button (minus sign)
      TargetCanvas.MoveTo(7, 8);
      TargetCanvas.LineTo(12, 8);
    end;
  end;
end;

procedure TfrmWatch.vstWatchDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  pNode: PVirtualNode;
  pData: PWatchNodeData;
begin
  // Only works over the list view lvwWatch
  if ((Sender = vstWatch) and (TSynEdit(Source).SelText <> ''))then
  begin
    pNode := Sender.AddChild(Sender.RootNode);
    pData := Sender.GetNodeData(pNode);
    pData.Name := TSynEdit(Source).SelText;
    frmMain.PrintWatch(frmMain.LuaState);
  end;
end;

procedure TfrmWatch.vstWatchDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := (Source is TSynEdit);
end;

procedure TfrmWatch.tbtnRefreshWatchClick(Sender: TObject);
begin
  frmMain.PrintWatch(frmMain.LuaState);
end;

procedure TfrmWatch.tbtnAddWatchClick(Sender: TObject);
var
  pNode: PVirtualNode;
  pData: PWatchNodeData;
  sVarName: String;
begin
  sVarName := InputBox('Add Watch', 'Enter the name of the variable to watch:', 'VarName');
  if 'VarName' <> sVarName then
  begin
    vstWatch.RootNodeCount := vstWatch.RootNodeCount + 1;
    pNode := vstWatch.GetLast;
    pData := vstWatch.GetNodeData(pNode);
    pData.Name := sVarName;
  end;
end;

procedure TfrmWatch.vstWatchEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  frmMain.PrintWatch(frmMain.LuaState);
end;

end.
