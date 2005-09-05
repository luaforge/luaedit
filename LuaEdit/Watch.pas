unit Watch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, ComCtrls, Menus, StdCtrls, ExtCtrls, SynEdit,
  JvComponent, JvDockControlForm, JvDragDrop, VirtualTrees, ActiveX,
  ImgList, ToolWin;

const
  // Helper message to decouple node change handling from edit handling.
  WM_STARTEDITING = WM_USER + 778;

type
  PWatchNodeData = ^TWatchNodeData;
  TWatchNodeData = record
    Value: String;
    Name: String;
    NestedTableCount: Integer;
    ToKeep: Boolean;
  end;

  // Our own edit link to implement several different node editors.
  TEditLinker = class(TInterfacedObject, IVTEditLink)
  private
    FTree: TVirtualStringTree; // A back reference to the tree calling.
    FNode: PVirtualNode;       // The node being edited.
    FColumn: Integer;          // The column of the node being edited.
  public
    constructor Create;
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
    FEdit: TEdit;
    tbtnDelete: TToolButton;
    DeleteSelectedItem1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    AddWatch1: TMenuItem;
    procedure vstWatchGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstWatchEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstWatchCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstWatchGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure vstWatchAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure vstWatchDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure vstWatchDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure tbtnRefreshWatchClick(Sender: TObject);
    procedure tbtnAddWatchClick(Sender: TObject);
    procedure vstWatchEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure vstWatchChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstWatchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DeleteSelected();
    procedure tbtnDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddWatch1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure DeleteSelectedItem1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMStartEditing(var Message: TMessage); message WM_STARTEDITING;
  public
    { Public declarations }
  end;

var
  frmWatch: TfrmWatch;

implementation

uses Main, Types;

{$R *.dfm}

////////////////////////////////////// TEditLinker implementation //////////////////////////////////////

constructor TEditLinker.Create;
begin
  FTree := nil;
  FNode := nil;
  FColumn := 0;
end;

destructor TEditLinker.Destroy;

begin
  // nothing for now...
  inherited;
end;

function TEditLinker.BeginEdit: Boolean;
begin
  Result := True;
  frmWatch.FEdit.Show;
  frmWatch.FEdit.SetFocus;
end;

function TEditLinker.CancelEdit: Boolean;
begin
  Result := True;
  frmWatch.FEdit.Hide;
end;

function TEditLinker.EndEdit: Boolean;
var
  Data: PWatchNodeData;
  S: String;
begin
  Result := True;

  Data := FTree.GetNodeData(FNode);
  S := frmWatch.FEdit.Text;

  if S <> Data.Name then
  begin
    Data.Name := S;
    FTree.InvalidateNode(FNode);
  end;

  frmWatch.FEdit.Hide;
  frmWatch.tbtnDelete.Enabled := True;
  frmWatch.DeleteSelectedItem1.Enabled := True;
  FTree.SetFocus;
end;

procedure TEditLinker.SetBounds(R: TRect);
var
  Dummy: Integer;
begin
  // Since we don't want to activate grid extensions in the tree (this would influence how the selection is drawn)
  // we have to set the edit's width explicitly to the width of the column.
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  frmWatch.FEdit.BoundsRect := R;
end;

function TEditLinker.GetBounds: TRect;
begin
  Result := frmWatch.FEdit.BoundsRect;
end;

function TEditLinker.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Data: PWatchNodeData;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;
    
  Data := FTree.GetNodeData(Node);
  frmWatch.tbtnDelete.Enabled := False;
  frmWatch.DeleteSelectedItem1.Enabled := False;

  with frmWatch.FEdit do
  begin
    Visible := False;
    Parent := FTree;
    AutoSize := False;
    MaxLength := 1000;
    Ctl3D := False;
    Text := Data.Name;
  end;
end;

procedure TEditLinker.ProcessMessage(var Message: TMessage);
begin
  frmWatch.FEdit.WindowProc(Message);
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
        CellText := pData.Value;
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
begin
  frmMain.DoAddWatchExecute;
end;

procedure TfrmWatch.vstWatchEdited(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  frmMain.PrintWatch(frmMain.LuaState);
end;

procedure TfrmWatch.WMStartEditing(var Message: TMessage);
// This message was posted by ourselves from the node change handler above to decouple that change event and our
// intention to start editing a node. This is necessary to avoid interferences between nodes editors potentially created
// for an old edit action and the new one we start here.
var
  Node: PVirtualNode;
begin
  Node := Pointer(Message.WParam);
  // Note: the test whether a node can really be edited is done in the OnEditing event.
  vstWatch.EditNode(Node, 1);
end;

procedure TfrmWatch.vstWatchChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with Sender do
  begin
    tbtnDelete.Enabled := Assigned(GetFirstSelected());
    DeleteSelectedItem1.Enabled := Assigned(GetFirstSelected());

    // Start immediate editing as soon as another node gets focused.
    if Assigned(Node) and (Node.Parent <> RootNode) then
    begin
      // We want to start editing the currently selected node. However it might well happen that this change event
      // here is caused by the node editor if another node is currently being edited. It causes trouble
      // to start a new edit operation if the last one is still in progress. So we post us a special message and
      // in the message handler we then can start editing the new node. This works because the posted message
      // is first executed *after* this event and the message, which triggered it is finished.
      PostMessage(Self.Handle, WM_STARTEDITING, Integer(Node), 0);
    end;
  end;
end;

procedure TfrmWatch.FEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  CanAdvance: Boolean;
begin
  CanAdvance := True;

  case Key of
    VK_ESCAPE:
      if CanAdvance then
      begin
        vstWatch.CancelEditNode;
        Key := 0;
      end;
    VK_RETURN:
      if CanAdvance then
      begin
        vstWatch.EndEditNode;
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
          PostMessage(vstWatch.Handle, WM_KEYDOWN, Key, 0);
          Key := 0;
        end;
      end;
  end;
end;

procedure TfrmWatch.vstWatchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if not vstWatch.IsEditing then
  begin
    // Seek delete key for node deletion
    if Key = VK_DELETE then
      DeleteSelected;
  end;
end;

procedure TfrmWatch.DeleteSelected();
begin
  if Assigned(vstWatch.GetFirstSelected()) then
    vstWatch.DeleteNode(vstWatch.GetFirstSelected());
end;

procedure TfrmWatch.tbtnDeleteClick(Sender: TObject);
begin
  DeleteSelected;
end;

procedure TfrmWatch.FormCreate(Sender: TObject);
begin
  tbtnDelete.Enabled := False;
  DeleteSelectedItem1.Enabled := False;
end;

procedure TfrmWatch.AddWatch1Click(Sender: TObject);
begin
  tbtnAddWatch.Click;
end;

procedure TfrmWatch.Refresh1Click(Sender: TObject);
begin
  tbtnRefreshWatch.Click;
end;

procedure TfrmWatch.DeleteSelectedItem1Click(Sender: TObject);
begin
  tbtnDelete.Click;
end;

end.
