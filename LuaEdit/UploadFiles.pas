unit UploadFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvExControls, JvComponent, JvLabel, StdCtrls, ComCtrls, Winsock,
  Misc;

type
  TfrmUploadFiles = class(TForm)
    anmFileTransfer: TAnimate;
    pgbFileTransfer: TProgressBar;
    Label1: TLabel;
    jvlblSource: TJvLabel;
    Label2: TLabel;
    jvlblTarget: TJvLabel;
    Label3: TLabel;
    jvlblSize: TJvLabel;
    Label4: TLabel;
    jvlblHost: TJvLabel;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Transfer(pSock: TSocket; pLuaProject: TLuaProject; hModule: Cardinal);
  end;

var
  frmUploadFiles: TfrmUploadFiles;

// External function
function GetFileSizeStr(Size: Cardinal): PChar; cdecl; external 'LuaEditSys.dll';

implementation

{$R *.dfm}

procedure TfrmUploadFiles.Transfer(pSock: TSocket; pLuaProject: TLuaProject; hModule: Cardinal);
var
  x, iFileCount: Integer;
  pLuaUnit: TLuaUnit;
  SearchRec: TSearchRec;
  SizeInBytes: Cardinal;
  Ptr: TFarProc;
  pSendFile: TSendFile;
  pSocketSend: TSocketSend;
begin
  // Retrieve the 'SocketSend' function from plugin dll
  Ptr := GetProcAddress(hModule, 'SocketSend');
  pSocketSend := TSocketSend(Ptr);
  Ptr := nil;

  // Retrieve the 'SendFile' function from plugin dll
  Ptr := GetProcAddress(hModule, 'SendFile');
  pSendFile := TSendFile(Ptr);
  Ptr := nil;

  // Send quantity of files to transfer
  iFileCount := pLuaProject.lstUnits.Count;
  if not pSocketSend(pSock, iFileCount, SizeOf(iFileCount), 0, 'Fail to send quantity of files to transfer.') then
    Exit;

    // Initialize stuff...
  anmFileTransfer.Play(1, anmFileTransfer.FrameCount, 0);
  pgbFileTransfer.Max := pLuaProject.lstUnits.Count;

  // Send all files under currently active project
  for x := 0 to pLuaProject.lstUnits.Count - 1 do
  begin
    pLuaUnit := TLuaUnit(pLuaProject.lstUnits[x]);
    FindFirst(pLuaUnit.sUnitPath,faAnyFile, SearchRec);
    SizeInBytes := SearchRec.Size;
                                 
    jvlblSource.Caption := pLuaUnit.sUnitPath;
    jvlblTarget.Caption := pLuaProject.sRemoteDirectory + pLuaUnit.sName;
    jvlblSize.Caption := GetFileSizeStr(SizeInBytes);
    jvlblHost.Caption := pLuaProject.sRemoteIP;

    FindClose(SearchRec);
    pgbFileTransfer.StepIt;
    Application.ProcessMessages;

    // Send current file...
    if not pSendFile(pSock, PChar(pLuaUnit.sUnitPath), PChar(pLuaProject.sRemoteDirectory + pLuaUnit.sName), PChar('Fail to send file: ' + pLuaUnit.sUnitPath)) then
      Exit;
  end;

  // Uninitialize stuff...
  anmFileTransfer.Stop;
end;

end.
