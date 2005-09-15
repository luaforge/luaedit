unit CntString;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Main, Winsock;

type
  TfrmCntString = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    Label1: TLabel;
    memoCntString: TMemo;
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCntString: TfrmCntString;

implementation

{$R *.dfm}

procedure TfrmCntString.btnCancelClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  closesocket(pSock);
  closesocket(pRSock);
  WSACleanup;
  //TerminateThread(ThreadDebugHandle, 0);
  Screen.Cursor := crDefault;
end;

procedure TfrmCntString.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
  Self.Activate;
end;

end.
