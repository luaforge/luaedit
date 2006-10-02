unit Stack;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Main, JvComponent, Misc, ImgList,
  JvDockControlForm, JvExStdCtrls, JvListComb, JvExComCtrls,
  JvListView, JvDotNetControls, lua, lualib, lauxlib, LuaUtils;

type
  TfrmStack = class(TForm)
    JvDockClient1: TJvDockClient;
    imlCallStack: TImageList;
    lstCallStack: TJvDotNetListView;
    procedure lstCallStackDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStack: TfrmStack;

implementation

{$R *.dfm}

procedure TfrmStack.lstCallStackDblClick(Sender: TObject);
var
  x: Integer;
  pBreakInfo: TBreakInfo;
begin
  if Assigned(lstCallStack.Selected) then
  begin
    pBreakInfo := TBreakInfo(lstCallStack.Selected.Data);
    
    if pBreakInfo.Line <> -1 then
    begin
      frmStack.lstCallStack.Items.BeginUpdate;

      for x := 0 to frmStack.lstCallStack.Items.Count - 1 do
      begin
        if x = 0 then
          frmStack.lstCallStack.Items[x].ImageIndex := 0
        else
          frmStack.lstCallStack.Items[x].ImageIndex := -1;
      end;

      // update locals...
      frmLuaEditMain.PrintLocal(frmLuaEditMain.LuaState, lstCallStack.Selected.Index);
      frmLuaEditMain.PrintWatch(frmLuaEditMain.LuaState);

      frmStack.lstCallStack.Items.EndUpdate;
      lstCallStack.Selected.ImageIndex := 1;
      TLuaEditDebugFile(frmLuaEditMain.PopUpUnitToScreen(pBreakInfo.FileName, pBreakInfo.Line)).DebugInfos.iStackMarker := pBreakInfo.Line+1;
      TLuaEditUnit(frmLuaEditMain.jvUnitBar.SelectedTab.Data).synUnit.Refresh;
    end;
  end;
end;

end.
