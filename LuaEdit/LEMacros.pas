////////////////////////////////////////////////////////////////////////////////
// IMPORTANT: View the complexity here since there is no concrete (visual)
//            quick and reliable way to see what's in and out of the functions,
//            please comment properly using the current function's comment
//            syntax.
////////////////////////////////////////////////////////////////////////////////

unit LEMacros;

interface

uses lua, lualib, lauxlib, Forms, SysUtils, LuaUtils, Misc, SynEdit,
     LuaEditMessages, Classes, Registry, Windows;

procedure LERegisterToLua(L: Plua_State);

implementation

uses Main;




////////////////////////////////////////////////////////////////////////////////
// LuaEdit related functions
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Desc: This function open a file using LuaEdit's open file dialog
// In:   None
// Out:  (1) True if the operation ended successfully. False if canceled,
//           unavailable (disabled) or failed.
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEOpenFile(L: Plua_State): Integer; cdecl;
var
  FilesName: TStringList;
  x: Integer;
begin
  // Initialize variables
  FilesName := TStringList.Create;

  // Retrieve all files' name (if any...)
  for x := 1 to lua_gettop(L) do
    if lua_type(L, x) = LUA_TSTRING then
      FilesName.Add(StrPas(lua_tostring(L, x)));

  // Return the luaedit version as a string
  lua_pushboolean(L, frmLuaEditMain.DoOpenFileExecute(FilesName));

  // Free variables
  FilesName.Free;

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function open a project using LuaEdit's open project dialog
// In:   None
// Out:  (1) True if the operation ended successfully. False if canceled,
//           unavailable (disabled) or failed.
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEOpenProject(L: Plua_State): Integer; cdecl;
begin
  // Return the luaedit version as a string
  lua_pushboolean(L, frmLuaEditMain.DoOpenProjectExecute());

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function save all opened files
// In:   None
// Out:  (1) True if the operation ended successfully. False if canceled,
//           unavailable (disabled) or failed.
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLESaveAll(L: Plua_State): Integer; cdecl;
begin
  // Return the luaedit version as a string
  lua_pushboolean(L, frmLuaEditMain.DoSaveAllExecute());

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function save the current active project as...
// In:   None
// Out:  (1) True if the operation ended successfully. False if canceled,
//           unavailable (disabled) or failed.
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLESavePrjAs(L: Plua_State): Integer; cdecl;
begin
  // Return the luaedit version as a string
  lua_pushboolean(L, frmLuaEditMain.DoSaveProjectAsExecute());

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function save the currently opened unit as...
// In:   None
// Out:  (1) True if the operation ended successfully. False if canceled,
//           unavailable (disabled) or failed.
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLESaveUnitAs(L: Plua_State): Integer; cdecl;
begin
  // Return the luaedit version as a string
  lua_pushboolean(L, frmLuaEditMain.DoSaveAsExecute());

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function save the currently opened unit
// In:   None
// Out:  (1) True if the operation ended successfully. False if canceled,
//           unavailable (disabled) or failed.
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLESaveUnit(L: Plua_State): Integer; cdecl;
begin
  // Return the luaedit version as a string
  lua_pushboolean(L, frmLuaEditMain.DoSaveExecute());

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function return informations about the specified unit
// In:   (1) [OPTIONAL] The index of the unit from which to retrieve informations
// Out:  (1) A lua table formatted this way:
//                t = {}
//                t["Name"]           = "Unit1.lua"
//                t["Path"]           = "C:\\Program Files\\LuaEdit\\Unit1.lua"
//                t["IsReadOnly"]     = False
//                t["IsNew"]          = False
//                t["HasChanged"]     = True
//                t["Text"]           = {}
//                t["Text"]["Count"]  = 3
//                t["Text"][-1]       = "print(123)??print(456)??print(789)"
//                t["Text"][0]        = "print(123)"
//                t["Text"][1]        = "print(456)"
//                t["Text"][2]        = "print(789)"
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEGetUnit(L: Plua_State): Integer; cdecl;
var
  Index, x: Integer;
  pLuaUnit: TLuaEditUnit;
begin
  // Retrieve SAFELY the first parameter
  if lua_type(L, -1) = LUA_TNUMBER then
    Index := Trunc(lua_tonumber(L, -1))
  else if lua_gettop(L) = 0 then
    Index := -1;

  // Retrieve currently selected tab index
  if Index = -1 then
    if Assigned(frmLuaEditMain.jvUnitBar.SelectedTab) then
      Index := frmLuaEditMain.jvUnitBar.SelectedTab.Index;

  if ((Index >= 0) and (Index < frmLuaEditMain.jvUnitBar.Tabs.Count)) then
  begin
    // Verify availability of the data at the specified index
    if Assigned(frmLuaEditMain.jvUnitBar.Tabs[Index]) then
    begin
      if Assigned(frmLuaEditMain.jvUnitBar.Tabs[Index].Data) then
      begin
        // Retrieve unit data
        pLuaUnit := TLuaEditUnit(frmLuaEditMain.jvUnitBar.Tabs[Index].Data);

        // Create table on the lua stack which will be returned to lua
        lua_newtable(L);

        // Push "Name" data
        lua_pushstring(L, 'Name');
        lua_pushstring(L, PChar(pLuaUnit.Name));
        lua_settable(L, -3);

        // Push "Path" data
        lua_pushstring(L, 'Path');
        lua_pushstring(L, PChar(pLuaUnit.Path));
        lua_settable(L, -3);

        // Push "IsLoaded" data
        lua_pushstring(L, 'IsLoaded');
        lua_pushboolean(L, pLuaUnit.IsLoaded);
        lua_settable(L, -3);

        // Push "IsReadOnly" data
        lua_pushstring(L, 'IsReadOnly');
        lua_pushboolean(L, pLuaUnit.IsReadOnly);
        lua_settable(L, -3);

        // Push "IsNew" data
        lua_pushstring(L, 'IsNew');
        lua_pushboolean(L, pLuaUnit.IsNew);
        lua_settable(L, -3);

        // Push "HasChanged" data
        lua_pushstring(L, 'HasChanged');
        lua_pushboolean(L, pLuaUnit.HasChanged);
        lua_settable(L, -3);

        // Push "Text" data
        lua_pushstring(L, 'Text');
        lua_newtable(L);

        // Push "Text"."Count" data
        lua_pushstring(L, 'Count');
        lua_pushnumber(L, pLuaUnit.synUnit.Lines.Count);
        lua_settable(L, -3);

        // Push "Text".-1 data
        lua_pushnumber(L, -1);
        lua_pushstring(L, PChar(pLuaUnit.synUnit.Text));
        lua_settable(L, -3);

        // Push "Text".x data
        for x := 0 to pLuaUnit.synUnit.Lines.Count - 1 do
        begin
          lua_pushnumber(L, x);
          lua_pushstring(L, PChar(pLuaUnit.synUnit.Lines[x]));
          lua_settable(L, -3);
        end;

        // Push the "Text" table
        lua_settable(L, -3);
      end;
    end;
  end;

  // Return nil if no unit associated to the given index was found
  if not Assigned(pLuaUnit) then
    lua_pushnil(L);

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function return informations about the current active project
// In:   None
// Out:  (1) A lua table formatted this way:
//                t = {}
//                t["Name"]             = "Project1"
//                t["Path"]             = "C:\\Program Files\\LuaEdit\\Project1.lpr"
//                t["Initializer"]      = "C:\\Initializer.dll"
//                t["RemoteIP"]         = "192.168.0.1"
//                t["RemoteDirectory"]  = "//RemoteDir//Bin//"
//                t["RuntimeDirectory"] = "C:\\Program Files\\LuaEdit\\"
//                t["TargetLuaUnit"]    = "C:\\Program Files\\LuaEdit\\Unit1.lua"
//                t["CompileDirectory"] = "C:\\Bin\\"
//                t["CompileExtension"] = ".luac"
//                t["AutoIncRevNumber"] = False
//                t["IsReadOnly"]       = False
//                t["IsNew"]            = False
//                t["HasChanged"]       = True
//                t["VersionMajor"]    = 1
//                t["VersionMinor"]    = 0
//                t["VersionRelease"]  = 1
//                t["VersionRevision"] = 0
//                t["RemotePort"]      = 6666
//                t["ConnectTimeOut"]  = 10
//                t["Files"]             = {}
//                t["Files"]["Count"]    = 2
//                t["Files"][0]          = "C:\\Program Files\\LuaEdit\\Unit1.lua"
//                t["Files"][1]          = "C:\\Program Files\\LuaEdit\\Unit2.lua"
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEGetActivePrj(L: Plua_State): Integer; cdecl;
var
  x: Integer;
  pLuaUnit: TLuaEditUnit;
begin
  // Verify availability of the data
  if Assigned(ActiveProject) then
  begin
    // Create table on the lua stack which will be returned to lua
    lua_newtable(L);

    // Push "Name" data
    lua_pushstring(L, 'Name');
    lua_pushstring(L, PChar(ActiveProject.Name));
    lua_settable(L, -3);

    // Push "Path" data
    lua_pushstring(L, 'Path');
    lua_pushstring(L, PChar(ActiveProject.Path));
    lua_settable(L, -3);

    // Push "Initializer" data
    lua_pushstring(L, 'Initializer');
    lua_pushstring(L, PChar(ActiveProject.sInitializer));
    lua_settable(L, -3);

    // Push "RemoteIP" data
    lua_pushstring(L, 'RemoteIP');
    lua_pushstring(L, PChar(ActiveProject.sRemoteIP));
    lua_settable(L, -3);

    // Push "RemoteDirectory" data
    lua_pushstring(L, 'RemoteDirectory');
    lua_pushstring(L, PChar(ActiveProject.sRemoteDirectory));
    lua_settable(L, -3);

    // Push "RuntimeDirectory" data
    lua_pushstring(L, 'RuntimeDirectory');
    lua_pushstring(L, PChar(ActiveProject.sRuntimeDirectory));
    lua_settable(L, -3);

    // Push "TargetLuaUnit" data
    lua_pushstring(L, 'TargetLuaUnit');
    lua_pushstring(L, PChar(ActiveProject.sTargetLuaUnit));
    lua_settable(L, -3);

    // Push "CompileDirectory" data
    lua_pushstring(L, 'CompileDirectory');
    lua_pushstring(L, PChar(ActiveProject.sCompileDirectory));
    lua_settable(L, -3);

    // Push "CompileExtension" data
    lua_pushstring(L, 'CompileExtension');
    lua_pushstring(L, PChar(ActiveProject.sCompileExtension));
    lua_settable(L, -3);

    // Push "AutoIncRevNumber" data
    lua_pushstring(L, 'AutoIncRevNumber');
    lua_pushboolean(L, ActiveProject.AutoIncRevNumber);
    lua_settable(L, -3);

    // Push "IsReadOnly" data
    lua_pushstring(L, 'IsReadOnly');
    lua_pushboolean(L, ActiveProject.IsReadOnly);
    lua_settable(L, -3);

    // Push "IsNew" data
    lua_pushstring(L, 'IsNew');
    lua_pushboolean(L, ActiveProject.IsNew);
    lua_settable(L, -3);

    // Push "HasChanged" data
    lua_pushstring(L, 'HasChanged');
    lua_pushboolean(L, ActiveProject.HasChanged);
    lua_settable(L, -3);
    
    // Push "VersionMajor" data
    lua_pushstring(L, 'VersionMajor');
    lua_pushnumber(L, ActiveProject.iVersionMajor);
    lua_settable(L, -3);

    // Push "VersionMinor" data
    lua_pushstring(L, 'VersionMinor');
    lua_pushnumber(L, ActiveProject.iVersionMinor);
    lua_settable(L, -3);

    // Push "VersionRelease" data
    lua_pushstring(L, 'VersionRelease');
    lua_pushnumber(L, ActiveProject.iVersionRelease);
    lua_settable(L, -3);

    // Push "VersionRevision" data
    lua_pushstring(L, 'VersionRevision');
    lua_pushnumber(L, ActiveProject.iVersionRevision);
    lua_settable(L, -3);

    // Push "RemotePort" data
    lua_pushstring(L, 'RemotePort');
    lua_pushnumber(L, ActiveProject.iRemotePort);
    lua_settable(L, -3);

    // Push "ConnectTimeOut" data
    lua_pushstring(L, 'ConnectTimeOut');
    lua_pushnumber(L, ActiveProject.iConnectTimeOut);
    lua_settable(L, -3);
    
    // Push "Files" data
    lua_pushstring(L, 'Files');
    lua_newtable(L);

    // Push "Files"."Count" data
    lua_pushstring(L, 'Count');
    lua_pushnumber(L, ActiveProject.lstUnits.Count);
    lua_settable(L, -3);

    // Push "Files".x data
    for x := 0 to ActiveProject.lstUnits.Count - 1 do
    begin
      lua_pushnumber(L, x);
      lua_pushstring(L, PChar(TLuaEditUnit(ActiveProject.lstUnits[x]).Path));
      lua_settable(L, -3);
    end;

    // Push the "Files" table
    lua_settable(L, -3);
  end;

  // Return nil if no unit associated to the given index was found
  if not Assigned(pLuaUnit) then
    lua_pushnil(L);

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function print the given message in LuaEdit's message window
// In:   (1) The message to print
//       (2) The type of message to print (EG: 1 = 'hint', 2 = 'warning', 3 = 'error')
// Out:  (1) The complete string as displayed in LuaEdit's message window or nil
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEPrint(L: PLua_State): Integer; cdecl;
var
  Msg, FullMsg: String;
  MsgType: Integer;
begin
  // Retrieve SAFELY the second parameter (of the first if there is only one argument)
  if lua_type(L, -1) = LUA_TNUMBER then
  begin
    MsgType := Trunc(lua_tonumber(L, -1));

    // Retrieve SAFELY the first parameter (or assign default message type if only one argument was supplied)
    if lua_type(L, -2) <> LUA_TSTRING then
    begin
      Msg := lua_tostring(L, -1);
      MsgType := LUAEDIT_HINT_MSG;
    end
    else
      Msg := lua_tostring(L, -2);

    // Show message in LuaEdit's message window
    FullMsg := Msg + ' - ' + DateTimeToStr(Now);
    lua_pushstring(L, PChar(FullMsg));
    frmLuaEditMessages.Put(FullMsg, MsgType);
  end
  else
    lua_pushnil(L);

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function return LuaEdit's version on the stack
// In:   None
// Out:  (1) A string containing LuaEdit's version
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEGetVersion(L: Plua_State): Integer; cdecl;
begin
  // Return the luaedit version as a string
  lua_pushstring(L, GetFileVersion(PChar(Application.ExeName)));

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function return LuaEdit's product name on the stack
// In:   None
// Out:  (1) A string containing LuaEdit's product name
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEGetProductName(L: Plua_State): Integer; cdecl;
begin
  // Return the luaedit product name
  lua_pushstring(L, 'LuaEdit');

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This function exit LuaEdit
// In:   None
// Out:  None
//
// 14/05/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLEExit(L: PLua_State): Integer; cdecl;
begin
  // Safely exit from LuaEdit
  frmLuaEditMain.DoExitExecute;

  // Return in Delphi the number of argument pushed on the stack
  Result := 0;
end;




////////////////////////////////////////////////////////////////////////////////
// Win32 related functions
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Desc: This reads the registry given its key and value(s)
// In:   (1) The root key to open
//       (2) The registry key to open
//       (3) The value #1 to read from the specified key
//       (4) The value #2 to read from the specified key
//       (...) The value #X to read from the specified key
// Out:  (1) The registry value's value
//
// 30/09/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLERegRead(L: PLua_State): Integer; cdecl;
var
  pReg: TRegistry;
  x: Integer;
  RootKeyTemp, Key, ValueName: String;
  RootKey: HKEY;
begin
  Result := 0;

  // Retrieve SAFELY the first parameter
  if lua_type(L, 1) = LUA_TSTRING then
  begin
    RootKeyTemp := UpperCase(lua_tostring(L, 1));

    // Determine the root key
    if RootKeyTemp = 'HKLM' then
      RootKey := HKEY_LOCAL_MACHINE
    else if RootKeyTemp = 'HKCR' then
      RootKey := HKEY_CLASSES_ROOT
    else if RootKeyTemp = 'HKCU' then
      RootKey := HKEY_CURRENT_USER
    else if RootKeyTemp = 'HKU' then
      RootKey := HKEY_USERS
    else if RootKeyTemp = 'HKCC' then
      RootKey := HKEY_CURRENT_CONFIG;

    // Retrieve SAFELY the second parameter
    if lua_type(L, 2) = LUA_TSTRING then
    begin
      Key := lua_tostring(L, 2);
      pReg := TRegistry.Create;
      pReg.RootKey := RootKey;

      if pReg.OpenKey(Key, False) then
      begin
        for x := 3 to lua_gettop(L) do
        begin
          // Increment number of argument pushed on the stack
          Inc(Result);

          if lua_type(L, x) = LUA_TSTRING then
          begin
            ValueName := lua_tostring(L, x);

            if pReg.ValueExists(ValueName) then
            begin
              case pReg.GetDataType(ValueName) of
                rdString, rdExpandString: lua_pushstring(L, PChar(pReg.ReadString(ValueName)));
                rdInteger: lua_pushnumber(L, pReg.ReadFloat(ValueName));
              else
                lua_pushnil(L);
              end;
            end
            else
              lua_pushnil(L);
          end
          else
            lua_pushnil(L);
        end;
      end;

      pReg.Free;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Desc: This write the registry given its key and value
// In:   (1) The root key to open
//       (2) The registry key to open
//       (3) The value name to write
//       (4) The value's value
// Out:  (1) Return true if successful. Otherwise return nil.
//
// 30/09/2006 - Jean-Francois Goulet
////////////////////////////////////////////////////////////////////////////////
function LuaLERegWrite(L: PLua_State): Integer; cdecl;
var
  pReg: TRegistry;
  x: Integer;
  RootKeyTemp, Key, ValueName: String;
  RootKey: HKEY;
begin
  // Retrieve SAFELY the first parameter
  if lua_type(L, 1) = LUA_TSTRING then
  begin
    RootKeyTemp := UpperCase(lua_tostring(L, 1));

    // Determine the root key
    if RootKeyTemp = 'HKLM' then
      RootKey := HKEY_LOCAL_MACHINE
    else if RootKeyTemp = 'HKCR' then
      RootKey := HKEY_CLASSES_ROOT
    else if RootKeyTemp = 'HKCU' then
      RootKey := HKEY_CURRENT_USER
    else if RootKeyTemp = 'HKU' then
      RootKey := HKEY_USERS
    else if RootKeyTemp = 'HKCC' then
      RootKey := HKEY_CURRENT_CONFIG;

    // Retrieve SAFELY the second parameter
    if lua_type(L, 2) = LUA_TSTRING then
    begin
      Key := lua_tostring(L, 2);
      pReg := TRegistry.Create;
      pReg.RootKey := RootKey;
      pReg.OpenKey(Key, True);

      if lua_gettop(L) >= 4 then
      begin
        if lua_type(L, 4) = LUA_TSTRING then
        begin
          ValueName := lua_tostring(L, 4);

          case lua_type(L, 5) of
            LUA_TSTRING: pReg.WriteString(ValueName, lua_tostring(L, 5));
            LUA_TNUMBER: pReg.WriteFloat(ValueName, lua_tonumber(L, 5));
          end;
        end;
      end;

      pReg.Free;
    end;
  end;

  // Return in Delphi the number of argument pushed on the stack
  Result := 1;
end;




////////////////////////////////////////////////////////////////////////////////
// Lua state registration related functions
////////////////////////////////////////////////////////////////////////////////

// This function register in the given lua state all luaedit related function
// to allow to the user some interface customization. Kind of like macros but
// using lua.
procedure LERegisterToLua(L: Plua_State);
const
  LETableName = 'luaedit';
begin
  // Open basic lua libraries
  lua_baselibopen(L);
  lua_packlibopen(L);
  lua_tablibopen(L);
  lua_strlibopen(L);
  lua_iolibopen(L);
  lua_mathlibopen(L);
  lua_dblibopen(L);

  // LuaEdit's core system functions
  LuaRegister(L, LETableName+'.getver', LuaLEGetVersion);
  LuaRegister(L, LETableName+'.getproductname', LuaLEGetProductName);
  LuaRegister(L, LETableName+'.exit', LuaLEExit);

  // LuaEdit's interfaces functions
  LuaRegister(L, LETableName+'.print', LuaLEPrint);

  // LuaEdit's file manipulation functions
  LuaRegister(L, LETableName+'.openfile', LuaLEOpenFile);
  LuaRegister(L, LETableName+'.openprj', LuaLEOpenProject);
  LuaRegister(L, LETableName+'.saveall', LuaLESaveAll);
  LuaRegister(L, LETableName+'.saveprjas', LuaLESavePrjAs);
  LuaRegister(L, LETableName+'.saveunit', LuaLESaveUnit);
  LuaRegister(L, LETableName+'.saveunitas', LuaLESaveUnitAs);
  LuaRegister(L, LETableName+'.getunit', LuaLEGetUnit);
  LuaRegister(L, LETableName+'.getactiveprj', LuaLEGetActivePrj);

  // Win32 system functions
  LuaRegister(L, LETableName+'.regread', LuaLERegRead);
  LuaRegister(L, LETableName+'.regwrite', LuaLERegWrite);

  // Register variables
  lua_getglobal(L, LETableName);

  // Push LuaEdit's version
  lua_pushstring(L, '_VERSION');
  lua_pushstring(L, _LuaEditVersion);
  lua_settable(L, -3);
end;

end.
