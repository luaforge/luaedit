unit RTDebugWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ComCtrls, ExtCtrls, RTDebug, ImgList, ToolWin;

type
  TRTDebugMainWin = class(TForm)
    lvAssert: TListView;
    ToolBar1: TToolBar;
    tbLock: TToolButton;
    tbClear: TToolButton;
    tbOnTop: TToolButton;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    tbOptions: TToolButton;
    procedure btClearClick(Sender: TObject);
    procedure tbLockClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tbOnTopClick(Sender: TObject);
    procedure tbOptionsClick(Sender: TObject);
  protected
    { Private declarations }
    AcceptMsg :Boolean;

    procedure MGGetListHandle(Var Msg :TMessage); message MG_RTD_GetListHandle;
    procedure WMCopyData(var M : TMessage); message WM_COPYDATA;
  public
    { Public declarations }
  end;

var
  RTDebugMainWin: TRTDebugMainWin;

implementation

uses RTDebugOptions;

{$R *.DFM}

procedure TRTDebugMainWin.btClearClick(Sender: TObject);
begin
     lvAssert.Clear;
end;

procedure TRTDebugMainWin.MGGetListHandle(Var Msg :TMessage);
begin
     Msg.Result :=lvAssert.Handle;
end;

procedure TRTDebugMainWin.WMCopyData(var M : TMessage);
Var
   Parametri :^TRTDebugParameters;
   lvItem    :TListItem;
   Spaces    :ShortString;

begin
     if AcceptMsg then
     begin
          Parametri :=PcopyDataStruct(M.lParam)^.lpData;

          FillChar(Spaces, 255, '*');
          Spaces[0] :=Char(Parametri.Level);
          lvItem :=lvAssert.Items.Add;
          lvItem.Caption :=Parametri.theString;
          lvItem.SubItems.Add(IntToHex(Parametri.processID, 8));
          lvItem.SubItems.Add(IntToHex(Parametri.ThreadID, 8));
      end;
     M.Result :=Integer(AcceptMsg);
end;



procedure TRTDebugMainWin.tbLockClick(Sender: TObject);
begin
     AcceptMsg :=Not(AcceptMsg);
     if AcceptMsg then tbLock.ImageIndex :=0
                  else tbLock.ImageIndex :=1;
end;

procedure TRTDebugMainWin.FormCreate(Sender: TObject);
begin
     AcceptMsg :=True;
end;

procedure TRTDebugMainWin.tbOnTopClick(Sender: TObject);
begin
     if tbOnTop.ImageIndex=3
     then begin
               Self.FormStyle :=fsNormal;
               tbOnTop.ImageIndex :=4;
           end
     else begin
               Self.FormStyle :=fsStayOnTop;
               tbOnTop.ImageIndex :=3;
           end;
end;

procedure TRTDebugMainWin.tbOptionsClick(Sender: TObject);
begin
     FormOptions.ShowModal;
end;

end.
