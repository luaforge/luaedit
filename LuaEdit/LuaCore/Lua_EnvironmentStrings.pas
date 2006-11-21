//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2006                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_EnvironmentStrings.pas
//
//  Description : Access from Lua scripts to EnvironmentStrings
//
//******************************************************************************
//  Exported functions :
//
//   GetVarValue(string VarString)                       return Value as String.

unit Lua_EnvironmentStrings;

interface

uses SysUtils, Lua, LuaUtils, EnvironmentStrings;

procedure RegisterFunctions(L: Plua_State;
                            OnGetVariable :TOnGetVariableFunction =Nil;
                            OnGetVariableTag :TObject =Nil);

implementation

const
     HANDLE_ONGETVARIABLE         ='Lua_ES_OnGetVariable';
     HANDLE_ONGETVARIABLETAG      ='Lua_ES_OnGetVariableTag';


function GetOnGetVariable(L: Plua_State): TOnGetVariableFunction;
begin
     Result := TOnGetVariableFunction(LuaGetTableLightUserData(L, LUA_REGISTRYINDEX, HANDLE_ONGETVARIABLE));
end;

function GetOnGetVariableTag(L: Plua_State): TObject;
begin
     Result := TObject(LuaGetTableLightUserData(L, LUA_REGISTRYINDEX, HANDLE_ONGETVARIABLETAG));
end;

//   GetVarValue(string VarString)                       return Value as String.
function LuaGetVarValue(L: Plua_State): Integer; cdecl;
Var
   NParams      :Integer;
   VarName      :String;
   xResult      :String;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  VarName :=LuaToString(L, 1);
                  xResult :=EnvironmentStrings.ProcessPARAMString(VarName, GetOnGetVariable(L), GetOnGetVariableTag(L));
                  if (xResult<>'')
                  then begin
                            LuaPushString(L, xResult);
                            Result := 1;
                       end;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

procedure RegisterFunctions(L: Plua_State;
                            OnGetVariable :TOnGetVariableFunction =Nil;
                            OnGetVariableTag :TObject =Nil);
begin
     LuaSetTableLightUserData(L, LUA_REGISTRYINDEX,
                              HANDLE_ONGETVARIABLE, @OnGetVariable);
     LuaSetTableLightUserData(L, LUA_REGISTRYINDEX,
                              HANDLE_ONGETVARIABLETAG, OnGetVariableTag);
     LuaRegister(L, 'GetVarValue', LuaGetVarValue);
end;

end.
