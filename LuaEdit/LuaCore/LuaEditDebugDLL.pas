unit LuaEditDebugDLL;

interface

uses lua;

function LuaEditDebugOpen :Plua_State;
function LuaEditDebugStartFile(LuaState :Plua_State; Filename :PChar):Integer;
function LuaEditDebugStart(LuaState :Plua_State; Code :PChar):Integer;
procedure LuaEditDebugClose(LuaState :Plua_State);


implementation

function LuaEditDebugOpen; external 'LuaEditDebug.dll';
function LuaEditDebugStartFile; external 'LuaEditDebug.dll';
function LuaEditDebugStart; external 'LuaEditDebug.dll';
procedure LuaEditDebugClose; external 'LuaEditDebug.dll';


end.
