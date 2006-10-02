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
    procedure Transfer(pSock: TSocket; pLuaProject: TLuaEditProject; hModule: Cardinal);
  end;

var
  frmUploadFiles: TfrmUploadFiles;

implementation

{$R *.dfm}

procedure TfrmUploadFiles.Transfer(pSock: TSocket; pLuaProject: TLuaEditProject; hModule: Cardinal);
var
  x, iFileCount: Integer;
  pLuaUnit: TLuaEditUnit;
  SearchRec: TSearchRec;
  SizeInBytes: Cardinal;
  Ptr: TFarProc;
  pSendFile: TSendFile;
  pSocketSend: TSocketSend;
  CurrentPath, FileName, ErrMsg: String;
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
  if pLuaProject.sInitializer <> '' then
    iFileCount := pLuaProject.lstUnits.Count + 1
  else
    iFileCount := pLuaProject.lstUnits.Count;

  if not pSocketSend(pSock, iFileCount, SizeOf(iFileCount), 0, 'Fail to send quantity of files to transfer.') then
    Exit;

  // Initialize stuff...
  anmFileTransfer.Play(1, anmFileTransfer.FrameCount, 0);
  pgbFileTransfer.Max := iFileCount;

  // Send all files under currently active project
  for x := 0 to iFileCount - 1 do
  begin
    if x < pLuaProject.lstUnits.Count then
    begin
      // Sending units under current project
      pLuaUnit := TLuaEditUnit(pLuaProject.lstUnits[x]);
      FindFirst(pLuaUnit.Path, faAnyFile, SearchRec);
      SizeInBytes := SearchRec.Size;

      jvlblSource.Caption := pLuaUnit.Path;
      jvlblTarget.Caption := pLuaProject.sRemoteDirectory + pLuaUnit.Name;
      jvlblSize.Caption := GetFileSizeStr(SizeInBytes);
      jvlblHost.Caption := pLuaProject.sRemoteIP;

      FindClose(SearchRec);
      pgbFileTransfer.StepIt;
      Application.ProcessMessages;
      CurrentPath := pLuaUnit.Path;
      FileName := pLuaProject.sRemoteDirectory + pLuaUnit.Name;
      ErrMsg := 'Fail to send file: ' + pLuaUnit.Path;
    end
    else if pLuaProject.sInitializer <> '' then
    begin
      // Sending project's initializer
      FindFirst(pLuaProject.sInitializer, faAnyFile, SearchRec);
      SizeInBytes := SearchRec.Size;

      jvlblSource.Caption := pLuaProject.sInitializer;
      jvlblTarget.Caption := pLuaProject.sRemoteDirectory + ExtractFileName(pLuaProject.sInitializer);
      jvlblSize.Caption := GetFileSizeStr(SizeInBytes);
      jvlblHost.Caption := pLuaProject.sRemoteIP;

      FindClose(SearchRec);
      pgbFileTransfer.StepIt;
      Application.ProcessMessages;
      CurrentPath := pLuaProject.sInitializer;
      FileName := pLuaProject.sRemoteDirectory + ExtractFileName(pLuaProject.sInitializer);
      ErrMsg := 'Fail to send file: ' + pLuaProject.sInitializer;
    end;

    // Send current file...
    if not pSendFile(pSock, PChar(CurrentPath), PChar(FileName), PChar(ErrMsg)) then
      Exit;
  end;

  // Uninitialize stuff...
  anmFileTransfer.Stop;
end;

end.
