//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2005                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_FunctionsLog.pas
//
//  Description : Do Log of Functions called inside a script.
//
//******************************************************************************
unit Lua_FunctionsLog;

interface

type
    Tfunction_LuaLog = procedure (FuncLog :PChar); stdcall;

Var
   OnLuaLog :Tfunction_LuaLog =Nil;

procedure DoFunctionLog(FuncName :String;
                        Param1 :String=''; Param2 :String='';
                        Param3 :String=''; Param4 :String='');

implementation

procedure DoFunctionLog(FuncName :String;
                        Param1 :String=''; Param2 :String='';
                        Param3 :String=''; Param4 :String='');
Var
   xLog :String;

begin
     if Assigned(OnLuaLog)
     then begin
               xLog := FuncName+'(';
               if (Param1<>'')
               then xLog :=xLog+Param1;
               if (Param2<>'')
               then xLog :=xLog+', '+Param2;
               if (Param3<>'')
               then xLog :=xLog+', '+Param3;
               if (Param4<>'')
               then xLog :=xLog+', '+Param4;
               xLog :=xLog+')';

               OnLuaLog(PChar(xLog));
          end;
end;

end.
