//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2005                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_Assert.pas
//
//  Description : Access from Lua scripts to RunTime Debug.
//
//******************************************************************************

unit Lua_Assert;

interface

uses Lua, Classes;

procedure RegisterFunctions(L: Plua_State);


implementation

uses LuaUtils, RTDebug, SysUtils;

function LuaRTAssert(L: Plua_State): Integer; cdecl;
Var
   Condition   :Boolean;
   TrueStr,
   FalseStr    :String;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=3)
     then begin
               try
                  Condition := LuaToBoolean(L, 1);
                  TrueStr   := LuaToString(L, 2);
                  FalseStr  := LuaToString(L, 3);
                  RTAssert(0, Condition, 'Lua : '+TrueStr, 'Lua : '+FalseStr, 0);
               except
                  On E:Exception do Result :=0;
               end;
          end;
end;


procedure RegisterFunctions(L: Plua_State);
begin
     LuaRegister(L, 'RTAssert', LuaRTAssert);
end;


end.
