{The LuaEditSys Dll contains a bunch of system function. Its been created to
"modularize" the LuaEdit code and may be useful for other project.}

unit LuaEditSysUtils;

interface

function GetFileLastTimeModified(const sFileName: PChar): TDateTime;
function GetFileReadOnlyAttr(const sFileName: PChar): Boolean;
procedure ToggleFileReadOnlyAttr(const sFileName: PChar);
function GetFileVersion(const FileName: PChar): PChar;
function GetOSInfo: PChar;
function SetPrivilege(sPrivilegeName: PChar; bEnabled: boolean): boolean;
function WinExit(iFlags: integer): Boolean;

implementation

uses SysUtils, Windows;

function GetFileLastTimeModified(const sFileName: PChar): TDateTime;
var
  fHandle: THandle;
  rCreated, rLastAccessed, rLastWritten: TFileTime;
  tLastWritten: TSystemTime;
  test: String;
begin
  Result := -1;
  fHandle := FileOpen(StrPas(sFileName), fmOpenRead);

  try
    GetFileTime(fHandle, @rCreated, @rLastAccessed, @rLastWritten);
    FileTimeToLocalFileTime(rLastWritten, rLastWritten);
    FileTimeToSystemTime(rLastWritten, tLastWritten);
    Result := SystemTimeToDateTime(tLastWritten);//SystemTimeToDateTime(tAccessed);
  finally
    CloseHandle(fHandle);
  end;
end;

function GetFileReadOnlyAttr(const sFileName: PChar): Boolean;
begin
  Result := faReadOnly and FileGetAttr(StrPas(sFileName)) = faReadOnly;
end;

procedure ToggleFileReadOnlyAttr(const sFileName: PChar);
var
  iAttr: Integer;
begin
  if FileExists(StrPas(sFileName)) then
  begin
    iAttr := FileGetAttr(StrPas(sFileName));
    iAttr := iAttr xor faReadOnly;
    FileSetAttr(StrPas(sFileName), iAttr);
  end;
end;

function GetFileVersion(const FileName: PChar): PChar;
var
   VersionInfoSize,
   VersionInfoValueSize,
   Zero: DWORD;
   VersionInfo,
   VersionInfoValue : Pointer;
   VersionString: String;
begin
   Result := '';

   VersionInfoSize := GetFileVersionInfoSize(FileName, Zero);
   if VersionInfoSize = 0 then
    Exit;
   GetMem(VersionInfo, VersionInfoSize);

   try
      if GetFileVersionInfo(FileName, 0, VersionInfoSize, VersionInfo) and VerQueryValue(VersionInfo, '\' { root block }, VersionInfoValue, VersionInfoValueSize) and (0 <> LongInt(VersionInfoValueSize)) then
      begin
         with TVSFixedFileInfo(VersionInfoValue^) do
         begin
            VersionString := IntToStr(HiWord(dwFileVersionMS));
            VersionString := VersionString + '.' + IntToStr(LoWord(dwFileVersionMS));
            VersionString := VersionString + '.' + IntToStr(HiWord(dwFileVersionLS));
            VersionString := VersionString + '  Build(' + IntToStr(LoWord(dwFileVersionLS)) + ')';
            Result := PChar(VersionString);
         end;
      end;
   finally
      FreeMem(VersionInfo);
   end;
end;

function GetOSInfo: PChar;
var
  sPlatform: String;
  pVersionInfos: _OSVERSIONINFOA;
begin
  pVersionInfos.dwOSVersionInfoSize := SizeOf(_OSVERSIONINFOA);
  GetVersionEx(pVersionInfos);

  case pVersionInfos.dwPlatformId of
    VER_PLATFORM_WIN32_NT:
    begin
      if ((pVersionInfos.dwMajorVersion = 5) and (pVersionInfos.dwMinorVersion = 2)) then
      begin
        sPlatform := 'Microsoft Windows Server 2003';
      end
      else if ((pVersionInfos.dwMajorVersion = 5) and (pVersionInfos.dwMinorVersion = 1)) then
      begin
        sPlatform := 'Microsoft Windows XP';
      end
      else if ((pVersionInfos.dwMajorVersion = 5) and (pVersionInfos.dwMinorVersion = 0)) then
      begin
        sPlatform := 'Microsoft Windows 2000';
      end
      else if pVersionInfos.dwMajorVersion <= 4 then
      begin
        sPlatform := 'Microsoft Windows NT';
      end;
    end;

    VER_PLATFORM_WIN32_WINDOWS:
    begin
      if ((pVersionInfos.dwMajorVersion = 4) and (pVersionInfos.dwMinorVersion = 0)) then
      begin
        sPlatform := 'Microsoft Windows 95';
      end
      else if ((pVersionInfos.dwMajorVersion = 4) and (pVersionInfos.dwMinorVersion = 10)) then
      begin
        if pVersionInfos.szCSDVersion[1] = 'A' then
        begin
          sPlatform := 'Microsoft Windows 98 SE';
        end
        else
        begin
          sPlatform := 'Microsoft Windows 98';
        end;
      end
      else if ((pVersionInfos.dwMajorVersion = 4) and (pVersionInfos.dwMinorVersion = 90)) then
      begin
        sPlatform := 'Microsoft Windows ME';
      end;
    end;
  else
    sPlatform := 'Unknown OS';
  end;

  Result := PChar(sPlatform);
end;

function SetPrivilege(sPrivilegeName: PChar; bEnabled: Boolean): Boolean;
var
  TPPrev, TP: TTokenPrivileges;
  Token: THandle;
  dwRetLen: DWord;
begin
  Result := False;
  OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, Token);
  TP.PrivilegeCount := 1;
  
  if(LookupPrivilegeValue(nil, sPrivilegeName, TP.Privileges[ 0 ].LUID))then
  begin
    if(bEnabled)then
    begin
      TP.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    end
    else
    begin
      TP.Privileges[ 0 ].Attributes := 0;
    end;

    dwRetLen := 0;
    Result := AdjustTokenPrivileges(Token, False, TP, SizeOf(TPPrev), TPPrev, dwRetLen);
  end;

  CloseHandle(Token);
end;

function WinExit(iFlags: integer): Boolean;
begin
  Result := True;

  if(SetPrivilege('SeShutdownPrivilege', True))then
  begin
    if(not ExitWindowsEx(iFlags, 0))then
    begin
      // handle errors...
      Result := False;
    end;
    
    SetPrivilege('SeShutdownPrivilege', False)
  end else
  begin
    // handle errors...
    Result := False;
  end;
end;

end.
 