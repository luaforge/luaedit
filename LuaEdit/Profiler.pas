unit Profiler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, Dialogs, JvComponent, JvDockControlForm, VirtualTrees, Gauges,
  PrecisionTimer, JvExControls, JvgProgress, JvSpecialProgress;

type
  PProfilerCall = ^TProfilerCall;
  TProfilerCall = record
    EnterTime: Int64; // Time when function enter
    EnterTimeStr: String;
    ExitTime: Int64; // Time when function exit
    ExitTimeStr: String;
    FctName: String; // Function's name
    Source: String;
    FctPointer: Pointer; // Functions's pointer
    Line: Integer; // Function call line declaration
    Parent: PVirtualNode; // Parent's pointer (pointer to caller's informations structure)
    DurationRGauge: TGauge; // Relative duration gauge
    DurationOGauge: TGauge; // Overall duration gauge
  end;

  TfrmProfiler = class(TForm)
    JvDockClient1: TJvDockClient;
    vstLuaProfiler: TVirtualStringTree;
    procedure vstLuaProfilerGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vstLuaProfilerGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure vstLuaProfilerAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure vstLuaProfilerCollapsing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    pCurrentCall: PVirtualNode;
    pTimer: TPrecisionTimer;
  public
    { Public declarations }
    procedure InitProfiler;
    procedure ComputeProfiler;
    function AddCall(FctPointer: Pointer; FctName: String; Line: Integer; Source: String): PProfilerCall;
    procedure AddReturn(FctPointer: Pointer; FctName: String);
  end;

var
  frmProfiler: TfrmProfiler;

implementation

uses Types;

{$R *.dfm}

procedure TfrmProfiler.InitProfiler;
var
  VTVColumn: TVirtualTreeColumn;
  pNode: PVirtualNode;
  pNodeData: PProfilerCall;
begin
  pCurrentCall := vstLuaProfiler.RootNode;
  vstLuaProfiler.BeginUpdate;
  pTimer.Init;
  pNode := vstLuaProfiler.GetLast();

  // Manually clear the tree to free gauges in node data
  while Assigned(pNode) do
  begin
    pNodeData := vstLuaProfiler.GetNodeData(pNode);
    FreeAndNil(pNodeData.DurationRGauge);
    FreeAndNil(pNodeData.DurationOGauge);
    vstLuaProfiler.DeleteNode(pNode);
    pNode := vstLuaProfiler.GetLast();
  end;
end;

procedure TfrmProfiler.ComputeProfiler;
var
  pNode, pMainNode: PVirtualNode;
  pNodeData: PProfilerCall;
  lpResidualDuration: Int64;
begin
  // Computing residual process duration
  // This englobe all lines in the script that were not function calls...
  pNode := vstLuaProfiler.GetFirstChild(vstLuaProfiler.RootNode);
  pMainNode := vstLuaProfiler.GetFirstChild(vstLuaProfiler.RootNode);
  pNodeData := vstLuaProfiler.GetNodeData(pNode);
  lpResidualDuration := pNodeData.ExitTime - pNodeData.EnterTime;
  pNode := vstLuaProfiler.GetNext(pNode);

  while pNode <> nil do
  begin
    pNodeData := vstLuaProfiler.GetNodeData(pNode);
    lpResidualDuration := lpResidualDuration - (pNodeData.ExitTime - pNodeData.EnterTime);
    pNode := vstLuaProfiler.GetNextSibling(pNode);
  end;

  // Adding residual process duration node
  pNode := vstLuaProfiler.AddChild(pMainNode);
  pNodeData := vstLuaProfiler.GetNodeData(pNode);
  pNodeData.Parent := pMainNode;
  pNodeData.EnterTime := 0;
  pNodeData.EnterTimeStr := '';
  pNodeData.ExitTime := lpResidualDuration;
  pNodeData.ExitTimeStr := '';
  pNodeData.Line := -1;
  pNodeData.Source := 'Lua';
  pNodeData.FctPointer := nil;
  pNodeData.FctName := '[RESIDUAL PROCESSES]';

  pNodeData.DurationRGauge := TGauge.Create(Self);
  pNodeData.DurationRGauge.Parent := vstLuaProfiler;
  pNodeData.DurationRGauge.MinValue := 0;
  pNodeData.DurationRGauge.MaxValue := 100;
  pNodeData.DurationRGauge.Progress := 0;
  pNodeData.DurationRGauge.Visible := False;

  pNodeData.DurationOGauge := TGauge.Create(Self);
  pNodeData.DurationOGauge.Parent := vstLuaProfiler;
  pNodeData.DurationOGauge.MinValue := 0;
  pNodeData.DurationOGauge.MaxValue := 100;
  pNodeData.DurationOGauge.Progress := 0;
  pNodeData.DurationOGauge.Visible := False;

  // Display the profiler
  vstLuaProfiler.EndUpdate;
end;

function TfrmProfiler.AddCall(FctPointer: Pointer; FctName: String; Line: Integer; Source: String): PProfilerCall;
var
  StartedTime: Int64;
  pCallData: PProfilerCall;
  pCallNode: PVirtualNode;
begin
  pTimer.GetCurrentTime(StartedTime);
  pCallNode := vstLuaProfiler.AddChild(pCurrentCall);
  pCallData := vstLuaProfiler.GetNodeData(pCallNode);

  pCallData.DurationRGauge := TGauge.Create(Self);
  pCallData.DurationRGauge.Parent := vstLuaProfiler;
  pCallData.DurationRGauge.MinValue := 0;
  pCallData.DurationRGauge.MaxValue := 100;
  pCallData.DurationRGauge.Progress := 0;
  pCallData.DurationRGauge.Visible := False;

  pCallData.DurationOGauge := TGauge.Create(Self);
  pCallData.DurationOGauge.Parent := vstLuaProfiler;
  pCallData.DurationOGauge.MinValue := 0;
  pCallData.DurationOGauge.MaxValue := 100;
  pCallData.DurationOGauge.Progress := 0;
  pCallData.DurationOGauge.Visible := False;

  pCallData.EnterTimeStr := FormatDateTime('hh:nn:ss:zzz', Time);
  pCallData.Parent := pCurrentCall;
  pCallData.FctName := FctName;
  pCallData.FctPointer := FctPointer;
  pCallData.Line := Line;
  pCallData.Source := Source;
  pCallData.EnterTime := StartedTime;
  pCurrentCall := pCallNode;
  Result := pCallData;
end;

procedure TfrmProfiler.AddReturn(FctPointer: Pointer; FctName: String);
var
  EndedTime: Int64;
  pCallData: PProfilerCall;
  test1, test2: Int64;
begin
  pTimer.GetCurrentTime(EndedTime);
  pCallData := vstLuaProfiler.GetNodeData(pCurrentCall);
  pCallData.ExitTimeStr := FormatDateTime('hh:nn:ss:zzz', Time);
  pCurrentCall := pCallData.Parent;
  pCallData.ExitTime := EndedTime;
end;

procedure TfrmProfiler.vstLuaProfilerGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var
  pData: PProfilerCall;
begin
  // Set text to display for all nodes
  if TextType = ttNormal then
  begin
    case Column of
      0: // Function Name
      begin
        pData := Sender.GetNodeData(Node);
        if pData.Parent = Sender.RootNode then
          CellText := '[MAIN]'
        else if pData.FctName = '' then
          CellText := '[UNKNOWN]'
        else
        CellText := pData.FctName;
      end;
      1: // Line
      begin
        pData := Sender.GetNodeData(Node);
        if pData.Line = -1 then
          CellText := 'N/A'
        else
          CellText := IntToStr(pData.Line);
      end;
      2: // Source
      begin
        pData := Sender.GetNodeData(Node);
        CellText := pData.Source;
      end;
      5: // Duration (s)
      begin
        pData := Sender.GetNodeData(Node);
        CellText := FormatFloat('0.000000', (pData.ExitTime - pData.EnterTime) / pTimer.GetFrequency());
      end;
      6: // Enter Time
      begin
        pData := Sender.GetNodeData(Node);

        if pData.EnterTimeStr = '' then
          CellText := 'N/A'
        else
          CellText := pData.EnterTimeStr;
      end;
      7: // Exit Time
      begin
        pData := Sender.GetNodeData(Node);

        if pData.ExitTimeStr = '' then
          CellText := 'N/A'
        else
          CellText := pData.ExitTimeStr;
      end;
    else
      CellText := '';
    end;
  end;
end;

procedure TfrmProfiler.vstLuaProfilerGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TProfilerCall);
end;

procedure TfrmProfiler.vstLuaProfilerAfterCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellRect: TRect);
var
  pFirstNode: PVirtualNode;
  pFirstNodeData: PProfilerCall;
  pData, pParentData: PProfilerCall;
  pPt: TPoint;
  pRect: TRect;
begin
  case Column of
    3: // Relative Usage
    begin
      pRect := Sender.GetDisplayRect(Node, Column, False);
      pData := Sender.GetNodeData(Node);
      pParentData := Sender.GetNodeData(pData.Parent);

      if pData.Parent = Sender.RootNode then
        pData.DurationRGauge.Progress := 100
      else
        pData.DurationRGauge.Progress := Round(((pData.ExitTime - pData.EnterTime) / pTimer.GetFrequency()) / ((pParentData.ExitTime - pParentData.EnterTime) / pTimer.GetFrequency()) * 100);

      InflateRect(pRect, -1, -1);
      pData.DurationRGauge.BoundsRect := pRect;
      pData.DurationRGauge.Visible := True;
    end;
    4: // Overall Usage
    begin
      pRect := Sender.GetDisplayRect(Node, Column, False);
      pFirstNode := Sender.GetFirstChild(vstLuaProfiler.RootNode);
      pFirstNodeData := Sender.GetNodeData(pFirstNode);
      pData := Sender.GetNodeData(Node);

      if pData.Parent = Sender.RootNode then
        pData.DurationOGauge.Progress := 100
      else
        pData.DurationOGauge.Progress := Round(((pData.ExitTime - pData.EnterTime) / pTimer.GetFrequency()) / ((pFirstNodeData.ExitTime - pFirstNodeData.EnterTime) / pTimer.GetFrequency()) * 100);

      InflateRect(pRect, -1, -1);
      pData.DurationOGauge.BoundsRect := pRect;
      pData.DurationOGauge.Visible := True;
    end;
  end;
end;

procedure TfrmProfiler.vstLuaProfilerCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
var
  pChildNode: PVirtualNode;
  pChildData: PProfilerCall;
begin
  // Manually hidding gauges that shouldn't be visible anymore
  pChildNode := Sender.GetFirstChild(Node);
  while ((pChildNode <> nil) and (Node.Parent <> pChildNode.Parent)) do
  begin
    pChildData := Sender.GetNodeData(pChildNode);
    pChildData.DurationRGauge.Visible := False;
    pChildData.DurationOGauge.Visible := False;
    pChildNode := Sender.GetNext(pChildNode);
  end;
end;

procedure TfrmProfiler.FormCreate(Sender: TObject);
begin
  pTimer := TPrecisionTimer.Create;
end;

procedure TfrmProfiler.FormDestroy(Sender: TObject);
begin
  pTimer.Free;
end;

end.
