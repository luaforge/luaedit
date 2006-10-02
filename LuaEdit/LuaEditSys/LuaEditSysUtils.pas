{The LuaEditSys Dll contains a bunch of system function. Its been created to
"modularize" the LuaEdit code and may be useful for other project.}

unit LuaEditSysUtils;

interface

uses Classes, SysUtils, Windows, Registry, ShellAPI, PSAPI;

function GetFileSizeStr(Size: Cardinal): PChar; cdecl;
function GetFileLastTimeModified(const sFileName: PChar): TDateTime; cdecl;
function GetFileReadOnlyAttr(const sFileName: PChar): Boolean; cdecl;
procedure ToggleFileReadOnlyAttr(const sFileName: PChar); cdecl;
function GetFileVersion(const FileName: PChar): PChar; cdecl;
function GetOSInfo: PChar; cdecl;
function SetPrivilege(sPrivilegeName: PChar; bEnabled: boolean): boolean; cdecl;
function WinExit(iFlags: integer): Boolean; cdecl;
function BrowseURL(URL: PChar): Boolean; cdecl;
function GetRunningProcesses(): PChar; cdecl;
function ParamStrEx(Index: Integer; CommandLine: PChar; ExeName: PChar): PChar; cdecl;
function ParamCountEx(CommandLine: PChar): Integer; cdecl;

implementation

// Return the specified size as the way we see it formated in windows' explorer
function GetFileSizeStr(Size: Cardinal): PChar; 
begin 
  if Size < 1024 then
    Result := PChar(IntToStr(Size) + ' Bytes')
  else 
    if Size < (1024 * 1024) then
      Result := PChar(IntToStr(Size div (1024)) + 'KB')
    else if Size < (1024 * 1024 * 1024) then
      Result := PChar(IntToStr(Size div (1024 * 1024)) + 'MB')
    else
      Result := PChar(IntToStr(Size div (1024 * 1024 * 1024)) + 'GB')
end;

// Retrieve the date/time of the last modification applied to the specified file
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
    Result := SystemTimeToDateTime(tLastWritten);
  finally
    CloseHandle(fHandle);
  end;
end;

// Return whether or not a file is currently in read only mode
function GetFileReadOnlyAttr(const sFileName: PChar): Boolean;
begin
  Result := faReadOnly and FileGetAttr(StrPas(sFileName)) = faReadOnly;
end;

// Toggle a file's read only mode
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

// Return the version string (Major.Minor.Release.Build) of a file
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

// Return a descriptive string of the current OS
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

// This function set specified privileges to the current application
// NOTE: The OS must agree the operation
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

// This function force the PC to reboot
// WARNING: This  does not display a reboot message. The caller function must
//          handle this in order to advise the user that a reboot is going to happen
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

// This function open the specified URL, in a new window, using the default
// internet browser
function BrowseURL(URL: PChar): Boolean;
var
  Browser: String;
  pReg: TRegistry;
begin
  Result := True;
  pReg := TRegistry.Create;
  Browser := '';

  pReg.RootKey := HKEY_CLASSES_ROOT;
  pReg.Access := KEY_QUERY_VALUE;

  // Open the registry key if available
  if pReg.OpenKey('\htmlfile\shell\open\command', False) then
    Browser := pReg.ReadString('');

  // Close the registry key
  pReg.CloseKey;

  // If a browser name was found in registry, we force to open it in a new window
  // by passing the url as command line parameter during the call
  if Browser <> '' then
  begin
    Browser := Copy(Browser, Pos('"', Browser) + 1, Length(Browser));
    Browser := Copy(Browser, 1, Pos('"', Browser) - 1);
    ShellExecute(0, 'open', PChar(Browser), URL, nil, SW_SHOW);
  end
  else
    Result := False;
end;

// Get the list of process identifiers.
function GetRunningProcesses(): PChar;
var
  aList: TStringList;
  lpidProcesses: array[0..1024] of DWord;
  cbNeeded, cProcesses, lphModule: DWord;
  hProcess: Cardinal;
  ProcessName: array[0..1024] of Char;
  i: Integer;
begin
  Result := '';

  if not EnumProcesses(@lpidProcesses, sizeof(lpidProcesses), cbNeeded) then
    Exit;

  // Calculate how many process identifiers were returned.
  cProcesses := cbNeeded div sizeof(Cardinal);
  aList := TStringList.Create;

  // Retrieve the name and id of each process
  for i := 0 to cProcesses - 1 do
  begin
    hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, lpidProcesses[i]);

    if hProcess <> 0 then
    begin
      cbNeeded := 0;
      
      if EnumProcessModules(hProcess, @lphModule, sizeof(lphModule), cbNeeded) then
      begin
        GetModuleBaseName(hProcess, lphModule, ProcessName, sizeof(ProcessName));
        aList.Add(ProcessName);
      end;
    end;
  end;

  Result := aList.GetText;
  aList.Free;
end;

// This function returns the parameter part of the command line
// NOTE: DO NOT EXPORT!!!!
function GetParamStrEx(P: PChar; var Param: string): PChar;
var
  i, Len: Integer;
  Start, S, Q: PChar;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do
      P := CharNext(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  Start := P;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      P := CharNext(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Q := CharNext(P);
        Inc(Len, Q - P);
        P := Q;
      end;
      if P[0] <> #0 then
        P := CharNext(P);
    end
    else
    begin
      Q := CharNext(P);
      Inc(Len, Q - P);
      P := Q;
    end;
  end;

  SetLength(Param, Len);

  P := Start;
  S := Pointer(Param);
  i := 0;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      P := CharNext(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Q := CharNext(P);
        while P < Q do
        begin
          S[i] := P^;
          Inc(P);
          Inc(i);
        end;
      end;
      if P[0] <> #0 then P := CharNext(P);
    end
    else
    begin
      Q := CharNext(P);
      while P < Q do
      begin
        S[i] := P^;
        Inc(P);
        Inc(i);
      end;
    end;
  end;

  Result := P;
end;

// Get the x parameter out of the specified command line
function ParamStrEx(Index: Integer; CommandLine: PChar; ExeName: PChar): PChar;
var
  P: PChar;
  Buffer: array[0..260] of Char;
  StrResult: String;
begin
  StrResult := '';
  
  if Index = 0 then
   StrResult := ExeName
  else
  begin
    P := CommandLine;

    while True do
    begin
      P := GetParamStrEx(P, StrResult);
      
      if (Index = 0) or (StrResult = '') then
        Break;

      Dec(Index);
    end;
  end;
  
  Result := PChar(StrResult);
end;

// Returns the number of parameter found in the specified command line
function ParamCountEx(CommandLine: PChar): Integer;
var
  P: PChar;
  S: String;
begin
  Result := 0;
  P := GetParamStrEx(CommandLine, S);
  
  while True do
  begin
    P := GetParamStrEx(P, S);
    
    if S = '' then
      Break;

    Inc(Result);
  end;
end;


end.
