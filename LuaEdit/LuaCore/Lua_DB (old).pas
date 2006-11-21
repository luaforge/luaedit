//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2006                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_DB.pas      (rev. 2.0)
//
//  Description : Access from Lua scripts to TDataset VCL Components
//                 (at this time TQuery, TTable)
//
//******************************************************************************
//  Exported functions :
//
//   Methods common to all TDataset classes
//      [descendent of TObject class (see Lua_object.pas)]
//      TDataset:Active(boolean newValue)              return Status as boolean.
//      TDataset:First()                               return Status as boolean.
//      TDataset:Next()                                return Status as boolean.
//      TDataset:GetCount()                           return RecordCount as Int.
//      TDataset:GetField(string FieldName)         return FieldValue as String.
//      TDataset:GetFieldSize(string FieldName)         return FieldSize as Int.
//      TDataset:Modified()                          return Modified as boolean.
//      TDataset:SetField(string FieldName,
//                [int | boolean | string] newValue)   return Status as boolean.
//      TDataset:Edit()                                return Status as boolean.
//      TDataset:Post()                                return Status as boolean.

//   CreateDBTable {Database=string, Table=string}         return TTable object.
//      [descendent of TDataset class]
//      TTable:Query(string query)                     return Status as boolean.
//
//   GetDBTable {Name=string}                     return Existing TTable object.
//      (same as TTable except that you cannot free it)
//
//   CreateDBQuery {Database=string}                       return TQuery object.
//      [descendent of TDataset class]
//
//   GetDBQuery {Name=string}                     return Existing TQuery object.
//      (same as TQuery except that you cannot free it)

unit Lua_DB;

interface

uses Classes, DB, DBTables, Lua, Lua_Object;

type
    TGetDataSetFunc = function (DataSetName :String) :TDataSet of object;


procedure RegisterFunctions(L: Plua_State;
                            AOwner :TComponent=Nil;
                            AOnGetDataSetFunc :TGetDataSetFunc=Nil);

procedure RegisterMethods_TDataset(L: Plua_State;
                           AComponent :TDataset; CanFree :Boolean;
                           PropsAccessRights :TLuaPROPSAccess);

procedure RegisterMethods_TQuery(L: Plua_State;
                           AComponent :TDataset; CanFree :Boolean;
                           PropsAccessRights :TLuaPROPSAccess);

procedure RegisterMethods_TTable(L: Plua_State;
                           AComponent :TDataset; CanFree :Boolean;
                           PropsAccessRights :TLuaPROPSAccess);

implementation

uses LuaUtils, SysUtils;

const
     HANDLE_OWNER       ='Lua_DB_OWNER';
     HANDLE_GETDATAFUNC ='Lua_DB_GETDATAFUNC';


//========================== Lua Functions TTable ==============================

function GetTDataset(L: Plua_State; Index: Integer): TDataSet;
begin
     Result := TDataSet(LuaGetTableLightUserData(L, Index, OBJHANDLE_STR));
end;

function GetOwner(L: Plua_State): TComponent;
begin
     Result := TComponent(LuaGetTableLightUserData(L, LUA_REGISTRYINDEX, HANDLE_OWNER));
end;

function GetOnGetDataSetFunc(L: Plua_State): TGetDataSetFunc;
begin
     Result := TGetDataSetFunc(LuaGetTableTMethod(L, LUA_REGISTRYINDEX, HANDLE_GETDATAFUNC));
end;

//=== TDataset Methods =========================================================
//      TDataset:Active(boolean newValue)              return Status as boolean.
function Lua_TDataset_Active(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;
   oldState     :Boolean;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=2)
     then begin
               theTable :=Nil;
               oldState :=False;
               try
                  theTable :=GetTDataset(L, 1);
                  oldState :=theTable.Active;
                  theTable.Active :=LuaToBoolean(L, 2);

                  LuaPushBoolean(L, True);
                  Result :=1;
               except
                  On E:Exception do begin
                                       theTable.Active :=oldState;
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:First()                               return Status as boolean.
function Lua_TDataset_First(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theTable :=GetTDataset(L, 1);
                  theTable.First;

                  LuaPushBoolean(L, True);
                  Result :=1;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:Next()                                return Status as boolean.
function Lua_TDataset_Next(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theTable :=GetTDataset(L, 1);
                  theTable.Next;

                  LuaPushBoolean(L, True);
                  Result :=1;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:GetCount()                           return RecordCount as Int.
function Lua_TDataset_GetCount(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theTable :=GetTDataset(L, 1);

                  LuaPushInteger(L, theTable.RecordCount);
                  Result := 1;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:GetField(string FieldName)         return FieldValue as String.
function Lua_TDataset_GetField(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;
   FieldName    :String;
   theField     :TField;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=2)
     then begin
               try
                  theTable :=GetTDataset(L, 1);
                  Fieldname :=LuaToString(L, 2);
                  theField  :=theTable.FindField(Fieldname);
                  if (theField<>Nil)
                  then begin
                            if not(theField.IsNull)
                            then begin
                                      LuaPushString(L, theField.AsString);
                                      Result := 1;
                                 end;
                       end;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:GetFieldSize(string FieldName)         return FieldSize as Int.
function Lua_TDataset_GetFieldSize(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;
   FieldName    :String;
   theField     :TField;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=2)
     then begin
               try
                  theTable :=GetTDataset(L, 1);
                  Fieldname :=LuaToString(L, 2);
                  theField  :=theTable.FindField(Fieldname);
                  if (theField<>Nil)
                  then begin
                            LuaPushInteger(L, theField.Size);
                            Result := 1;
                       end;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:Modified()                          return Modified as boolean.
function Lua_TDataset_Modified(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theTable :=GetTDataset(L, 1);

                  LuaPushBoolean(L, theTable.Modified);
                  Result :=1;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:SetField(string FieldName,
//                [int | boolean | string] newValue)   return Status as boolean.
function Lua_TDataset_SetField(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;
   FieldName    :String;
   theField     :TField;
   valueNEW     :Variant;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=3)
     then begin
               try
                  theTable :=GetTDataset(L, 1);
                  Fieldname :=LuaToString(L, 2);
                  theField  :=theTable.FindField(Fieldname);
                  if (theField<>Nil)
                  then begin
                            
                            if (lua_isnumber(L, 3)<>0)
                            then valueNEW := LuaToInteger(L, 3)
                            else
                            if lua_isboolean(L, 3)
                            then valueNEW := LuaToBoolean(L, 3)
                            else valueNEW := LuaToString(L, 3);

                            if (valueNEW<>theField.Value)
                            then begin
                                      theTable.Edit;
                                      theField.Value :=valueNEW;
                                 end;

                            LuaPushBoolean(L, True);
                            Result := 1;
                       end;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:Post()                                return Status as boolean.
function Lua_TDataset_Post(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theTable :=GetTDataset(L, 1);
                  
                  if (theTable.State in [dsEdit, dsInsert])
                  then theTable.Post;

                  LuaPushBoolean(L, True);
                  Result :=1;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//      TDataset:Edit()                                return Status as boolean.
function Lua_TDataset_Edit(L: Plua_State): Integer; cdecl;
Var
   theTable     :TDataset;
   NParams      :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theTable :=GetTDataset(L, 1);
                  theTable.Edit;

                  LuaPushBoolean(L, True);
                  Result :=1;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//=== TTable Methods ===========================================================
//      TTable:Query(string query)                     return Status as boolean.
function Lua_TTable_Query(L: Plua_State): Integer; cdecl;
Var
   theTable     :TTable;
   NParams      :Integer;
   xQuery       :TQuery;
   myOwner      :TComponent;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=2)
     then begin
               try
                  theTable :=TTable(GetTDataset(L, 1));
                  myOwner :=GetOwner(L);
                  xQuery :=TQuery.Create(myOwner);
                  try
                     xQuery.Active :=False;
                     xQuery.DatabaseName :=theTable.DatabaseName;
                     xQuery.SQL.Add(LuaToString(L, 2));
                     xQuery.ExecSQL;
                     
                     LuaPushBoolean(L, True);
                     Result :=1;
                  finally
                     xQuery.Free;
                  end;
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//=== RegisterMethods_XXX ======================================================

procedure RegisterMethods_TDataset(L: Plua_State;
                                  AComponent :TDataset; CanFree :Boolean;
                                  PropsAccessRights :TLuaPROPSAccess);
begin
     if CanFree
     then Lua_Object.RegisterMethods_TObject(L, AComponent, [LOMK_Free]);
     Lua_Object.RegisterProperties_TObject(L, AComponent, PropsAccessRights);

     LuaSetTableFunction(L, 1, 'Active', Lua_TDataset_Active);
     LuaSetTableFunction(L, 1, 'First', Lua_TDataset_First);
     LuaSetTableFunction(L, 1, 'Next', Lua_TDataset_Next);
     LuaSetTableFunction(L, 1, 'GetCount', Lua_TDataset_GetCount);
     LuaSetTableFunction(L, 1, 'GetField', Lua_TDataset_GetField);
     LuaSetTableFunction(L, 1, 'GetFieldSize', Lua_TDataset_GetFieldSize);
     LuaSetTableFunction(L, 1, 'SetField', Lua_TDataset_SetField);
     LuaSetTableFunction(L, 1, 'Edit', Lua_TDataset_Edit);
     LuaSetTableFunction(L, 1, 'Post', Lua_TDataset_Post);
     LuaSetTableFunction(L, 1, 'Modified', Lua_TDataset_Modified);
end;

procedure RegisterMethods_TQuery(L: Plua_State;
                           AComponent :TDataset; CanFree :Boolean;
                           PropsAccessRights :TLuaPROPSAccess);
begin
     RegisterMethods_TDataset(L, AComponent, CanFree, PropsAccessRights);
end;

procedure RegisterMethods_TTable(L: Plua_State;
                           AComponent :TDataset; CanFree :Boolean;
                           PropsAccessRights :TLuaPROPSAccess);
begin
     RegisterMethods_TDataset(L, AComponent, CanFree, PropsAccessRights);
     LuaSetTableFunction(L, 1, 'Query', Lua_TTable_Query);
end;

//   CreateDBTable {Database=string, Table=string}         return TTable object.
function Lua_CreateDBTable(L: Plua_State): Integer; cdecl;
Var
   DBPath,
   DBTableName   :String;
   xResult       :TTable;
   myOwner       :TComponent;

begin
     Result := 0;
     try
        myOwner :=GetOwner(L);
        DBPath      :=LuaGetTableString(L, 1, 'Database');
        DBTableName :=LuaGetTableString(L, 1, 'Table');
        LuaSetTableNil(L, 1, 'Database');
        LuaSetTableNil(L, 1, 'Table');
        xResult := TTable.Create(myOwner);
        if (xResult=Nil)
        then raise Exception.Create('Unable to Create Tables');

        xResult.Active :=False;
        xResult.DatabaseName :=DBPath;
        xResult.TableName :=DBTableName;

        RegisterMethods_TTable(L, xResult, true, LUAPROPS_ACCESS_READWRITE);

        Result := 1;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;
     end;
end;

//   GetDBTable {Name=string}                     return Existing TTable object.
function Lua_GetDBTable(L: Plua_State): Integer; cdecl;
Var
   DBName   :String;
   xResult  :TDataSet;
   myOnGetDataSetFunc :TGetDataSetFunc;

begin
     Result := 0;

     try
        myOnGetDataSetFunc :=GetOnGetDataSetFunc(L);
        DBName      :=LuaGetTableString(L, 1, 'Name');
        LuaSetTableNil(L, 1, 'Name');
        if Assigned(myOnGetDataSetFunc)
        then begin
                  xResult :=myOnGetDataSetFunc(DBName);
                  if not(xResult is TTable)
                  then xResult :=Nil;
             end
        else xResult :=Nil;

        if (xResult=Nil)
        then raise Exception.Create('Unable to Get Table '+DBName);

        RegisterMethods_TTable(L, xResult, false, LUAPROPS_ACCESS_READWRITE);

        Result := 1;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;
     end;
end;

//   CreateDBQuery {Database=string}                       return TQuery object.
function Lua_CreateDBQuery(L: Plua_State): Integer; cdecl;
Var
   DBPath        :String;
   xResult       :TQuery;
   myOwner       :TComponent;

begin
     Result := 0;
     try
        myOwner :=GetOwner(L);
        DBPath      :=LuaGetTableString(L, 1, 'Database');
        LuaSetTableNil(L, 1, 'Database');
        xResult := TQuery.Create(myOwner);
        if (xResult=Nil)
        then raise Exception.Create('Unable to Create Queries');

        xResult.Active :=False;
        xResult.DatabaseName :=DBPath;

        RegisterMethods_TQuery(L, xResult, true, LUAPROPS_ACCESS_READWRITE);

        Result := 1;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;
     end;
end;

//   GetDBQuery {Name=string}                     return Existing TQuery object.
function Lua_GetDBQuery(L: Plua_State): Integer; cdecl;
Var
   DBName        :String;
   xResult       :TDataSet;
   myOnGetDataSetFunc :TGetDataSetFunc;

begin
     Result := 0;

     try
        myOnGetDataSetFunc :=GetOnGetDataSetFunc(L);
        DBName      :=LuaGetTableString(L, 1, 'Name');
        LuaSetTableNil(L, 1, 'Name');
        if Assigned(myOnGetDataSetFunc)
        then begin
                  xResult :=myOnGetDataSetFunc(DBName);
                  if not(xResult is TQuery)
                  then xResult :=Nil;
             end
        else xResult :=Nil;

        if (xResult=Nil)
        then raise Exception.Create('Unable to Get Query '+DBName);

        RegisterMethods_TQuery(L, xResult, false, LUAPROPS_ACCESS_READWRITE);

        Result := 1;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;
     end;
end;

procedure RegisterFunctions(L: Plua_State;
                            AOwner :TComponent=Nil;
                            AOnGetDataSetFunc :TGetDataSetFunc=Nil);
begin
     //myOwner :=AOwner;
     //myOnGetDataSetFunc :=AOnGetDataSetFunc;
     LuaSetTableLightUserData(L, LUA_REGISTRYINDEX,
                              HANDLE_OWNER, AOwner);
     LuaSetTableTMethod(L, LUA_REGISTRYINDEX,
                        HANDLE_GETDATAFUNC, TMethod(AOnGetDataSetFunc));

     LuaRegister(L, 'CreateDBTable', Lua_CreateDBTable);
     LuaRegister(L, 'CreateDBQuery', Lua_CreateDBQuery);
     if Assigned(AOnGetDataSetFunc)
     then begin
               LuaRegister(L, 'GetDBTable', Lua_GetDBTable);
               LuaRegister(L, 'GetDBQuery', Lua_GetDBQuery);
          end;
end;


end.
