//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2005                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_MGList.pas
//
//  Description : Access from Lua scripts to TMGList Classes
//
//******************************************************************************
//
//  Lua Exported functions :
//
//   GetMGList{Name=string}                               return TMGList object.
//      TMGList:FindFirst()                              return Data as Pointer.
//      TMGList:FindNext()                               return Data as Pointer.
//      TMGList:FindClose()                            return Status as boolean.
//      TMGList:GetCount()                                  return Count as Int.
//      TMGList:GetData(integer DataPointer, string DataName)       return Data.
//      TMGList:Find([variant Param1[,...[, ParamN]])    return Data as Pointer.


unit Lua_MGList;

interface

uses Lua, Classes, MGList, Variants;

function  AddMGList(Name :String; List :TMGList) :Boolean;
function  DeleteMGList(Name :String) :Boolean;
function  FindMGList(Name :String) :TMGList;
procedure RegisterFunctions(L: Plua_State);

implementation

uses LuaUtils, SysUtils;

const
     HANDLE_STR ='Lua_MGList_Handle';

type
    TMGListDescr = record
       Name     :String;
       List     :TMGList;
    end;
    PMGListDescr = ^TMGListDescr;

    TLuaMGList = class(TMGList)
    protected
        function allocData :Pointer; override;
        procedure deallocData(pData :Pointer); override;
        function FindByName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
    public
        function Find(Name :String): PMGListDescr;  overload;
        function Add(Name :String; List :TMGList) :PMGListDescr; overload;
        function Delete(Name :String) :Boolean; overload;
    end;

Var
   LuaMGList :TLuaMGList =Nil;


//========================== Lua Functions TMGList ==============================

function GetPMGListDescr(L: Plua_State; Index: Integer): PMGListDescr;
begin
     Result := PMGListDescr(LuaGetTableLightUserData(L, Index, HANDLE_STR));
end;

function LuaFindFirstMGList(L: Plua_State): Integer; cdecl;
Var
   theList     :TMGList;
   NParams     :Integer;
   xFind       :Pointer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theList :=GetPMGListDescr(L, 1)^.List;
                  xFind := theList.FindFirst;
                  if (xFind<>Nil)
                  then begin
                            lua_pushlightuserdata(L, xFind);
                            Result :=1;
                       end;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaFindNextMGList(L: Plua_State): Integer; cdecl;
Var
   theList     :TMGList;
   NParams     :Integer;
   xFind       :Pointer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theList :=GetPMGListDescr(L, 1)^.List;
                  xFind := theList.FindNext;
                  if (xFind<>Nil)
                  then begin
                            lua_pushlightuserdata(L, xFind);
                            Result :=1;
                       end;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaFindCloseMGList(L: Plua_State): Integer; cdecl;
Var
   theList     :TMGList;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theList :=GetPMGListDescr(L, 1)^.List;
                  theList.FindClose;
                  LuaPushBoolean(L, True);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaGetCountMGList(L: Plua_State): Integer; cdecl;
Var
   theList     :TMGList;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theList :=GetPMGListDescr(L, 1)^.List;
                  LuaPushInteger(L, theList.Count);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;


function LuaGetDataMGList(L: Plua_State): Integer; cdecl;
Var
   theListDescr :PMGListDescr;
   NParams      :Integer;
   DataName     :String;
   CurrentData  :Pointer;
   xResult      :Variant;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=3)
     then begin
               try
                  theListDescr :=GetPMGListDescr(L, 1);
                  CurrentData  :=lua_touserdata(L, 2);
                  DataName :=LuaToString(L, 3);
                  if (CurrentData<>Nil)
                  then begin
                            xResult :=theListDescr^.List.GetData(CurrentData, DataName);
                            LuaPushVariant(L, xResult);
                            Result := 1;
                       end;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaFindMGList(L: Plua_State): Integer; cdecl;
Var
   theListDescr :PMGListDescr;
   NParams,
   iParams      :Integer;
   xResult      :Variant;
   xFind        :Pointer;
   theParams    :array of Variant;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams>1)
     then begin
               try
                  theListDescr :=GetPMGListDescr(L, 1);

                  SetLength(theParams, (NParams-1));
                  for iParams :=2 to NParams do
                  begin
                       xResult :=LuaToVariant(L, iParams);
                       theParams[iParams-2] :=xResult;
                  end;

                  xFind  :=theListDescr^.List.Find(theParams);
                  if (xFind<>Nil)
                  then begin
                            lua_pushlightuserdata(L, xFind);
                            Result :=1;
                       end;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;


function LuaGetMGList(L: Plua_State): Integer; cdecl;
Var
   ListName   :String;
   xResult    :PMGListDescr;

begin
     Result := 0;

     try
        ListName :=LuaGetTableString(L, 1, 'Name');
        LuaSetTableNil(L, 1, 'Name');
        xResult :=LuaMGList.Find(ListName);
        if (xResult=Nil)
        then raise Exception.Create('Unable to Locate List '+ListName);

        LuaSetTableLightUserData(L, 1, HANDLE_STR, xResult);
        LuaSetTableFunction(L, 1, 'FindFirst', LuaFindFirstMGList);
        LuaSetTableFunction(L, 1, 'FindNext', LuaFindNextMGList);
        LuaSetTableFunction(L, 1, 'FindClose', LuaFindCloseMGList);
        LuaSetTableFunction(L, 1, 'GetCount', LuaGetCountMGList);
        LuaSetTableFunction(L, 1, 'GetData', LuaGetDataMGList);
        LuaSetTableFunction(L, 1, 'Find', LuaFindMGList);
        Result := 1;
     except
        On E:Exception do begin
                               //LuaError(L, ERR_Script+E.Message);
                          end;
     end;
end;

//==============================================================================
//======================== TLuaMGList Class ====================================

function TLuaMGList.allocData :Pointer;
begin
     GetMem(Result, sizeOf(TMGListDescr));
     FillChar(Result^, sizeOf(TMGListDescr), 0);
end;

procedure TLuaMGList.deallocData(pData :Pointer);
begin
     //Evito eventuali problemi per allocazione delle stringhe in Delphi.
     PMGListDescr(pData)^.Name  :='';

     FreeMem(pData, sizeOf(TMGListDescr));
end;

function TLuaMGList.FindByName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := (String(PChar(ptData1)) = PMGListDescr(ptData2)^.Name);
end;

function TLuaMGList.Find(Name :String): PMGListDescr;

begin
     Result :=Self.ExtFind(PChar(Uppercase(Name)), 0, FindByName);
end;

function TLuaMGList.Add(Name :String; List :TMGList) :PMGListDescr;
Var
   toFind :PMGListDescr;

begin
     toFind :=Find(Name);

     if (toFind=Nil)
     then begin
               toFind :=Self.Add;
               toFind^.Name :=Uppercase(Name);
          end;
     toFind^.List :=List;
     Result :=toFind;
end;

function TLuaMGList.Delete(Name :String) :Boolean;
begin
     Result :=Delete(PChar(Uppercase(Name)), 0, FindByName);
end;

//==============================================================================
//======================== Public Functions ====================================

function  AddMGList(Name :String; List :TMGList) :Boolean;
begin
     Result :=False;
     if (LuaMGList<>Nil)
     then begin
               try
                  Result := (LuaMGList.Add(Name, List) <> Nil);
               except
                  On E:Exception do begin end;
               end;
          end;
end;

function  DeleteMGList(Name :String) :Boolean;
begin
     Result :=False;
     if (LuaMGList<>Nil)
     then begin
               try
                  Result := LuaMGList.Delete(Name);
               except
                  On E:Exception do begin end;
               end;
          end;
end;

function  FindMGList(Name :String) :TMGList;
Var
   toFind :PMGListDescr;

begin
     Result :=Nil;
     if (LuaMGList<>Nil)
     then begin
               try
                  toFind :=LuaMGList.Find(Name);
                  if (toFind<>Nil)
                  then Result :=toFind.List;
               except
                  On E:Exception do begin end;
               end;
          end;
end;

procedure RegisterFunctions(L: Plua_State);
begin
     LuaRegister(L, 'GetMGList', LuaGetMGList);
end;

initialization
   LuaMGList :=TLuaMGList.Create;

finalization
   LuaMGList.Free;
   LuaMGList :=Nil;

end.
