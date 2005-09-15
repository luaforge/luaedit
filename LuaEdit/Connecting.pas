unit Connecting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Main, ExtCtrls, WinSock;

type
  TfrmConnecting = class(TForm)
    pgbTimeOut: TProgressBar;
    btnCancel: TButton;
    Label1: TLabel;
    tmrTimeOut: TTimer;
    procedure btnCancelClick(Sender: TObject);
    procedure tmrTimeOutTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConnecting: TfrmConnecting;

implementation

{$R *.dfm}

procedure TfrmConnecting.btnCancelClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  tmrTimeOut.Enabled := False;
  closesocket(pSock);
  closesocket(pRSock);
  WSACleanup;
  //TerminateThread(ThreadDebugHandle, 0);
  Screen.Cursor := crDefault;
end;

procedure TfrmConnecting.tmrTimeOutTimer(Sender: TObject);
begin
  Application.ProcessMessages;
  Self.Activate;
  
  if pgbTimeOut.Position < pgbTimeOut.Max then
  begin
    pgbTimeOut.StepBy(1);
  end
  else
  begin
    tmrTimeOut.Enabled := False;
    Application.MessageBox('The connection timeout has been reached!', 'LuaEdit', MB_OK+MB_ICONERROR);
    btnCancel.Click;
  end;

  {if WaitForSingleObject(hMutex, 30) <> WAIT_TIMEOUT then
  begin
    // A connection has been made so we close this form and start debugging
    ReleaseMutex(hMutex);
    tmrTimeOut.Enabled := False;
    Self.Close;
  end;}
end;

procedure TfrmConnecting.FormShow(Sender: TObject);
begin
  tmrTimeOut.Enabled := True;
  pgbTimeOut.Position := 0;
end;

end.
