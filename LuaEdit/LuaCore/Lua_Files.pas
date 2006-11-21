//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2005                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_Files.pas
//
//  Description : Access from Lua scripts to some file functions.
//
//******************************************************************************
//  Exported functions :
//
//   CreateSearchRec {Path=string, Attr=integer}       return TSearchRec object.
//      TSearchRec:FindFirst()                          return ErrorCode as Int.
//      TSearchRec:FindNext()                           return ErrorCode as Int.
//      TSearchRec:GetName()                          return FileName as string.
//      TSearchRec:GetTime()                         return FileTime as integer.
//      TSearchRec:GetSize()                         return FileSize as integer.
//      TSearchRec:GetAttr()                         return FileAttr as integer.
//      TSearchRec:IsDir()                              return IsDir as boolean.
//      TSearchRec:FindClose()                                  free the object.
//
//   CopyPath(string SourcePath, DestPath, wild [, integer ExistingFlags, boolean Recursive])
//   CopyFile(string SourceFile, DestPath [, integer ExistingFlags, string DestFileName])
//   DeleteDir(string BaseDir, SelName, boolean Recursive, RemoveDirs)
//   RegServer(string SourceFile)
//   UnRegServer(string SourceFile)
//                                                     return Status as boolean.


unit Lua_Files;

interface

uses Lua, Classes, Lua_FunctionsLog;

const
    faOnlyFile  =$27;    //39 Decimal
    faAnyDir    =$1F;    //31 Decimal


procedure RegisterFunctions(L: Plua_State);


implementation

uses Windows, ShellApi, LuaUtils, SysUtils, CopyRoutines;

const
     HANDLE_SearchRecSTR ='Lua_Files_SearchRecHandle';

type
    TLuaSearchRec = record
                       Path :String;
                       Attr :Integer;
                       Rec  :TSearchRec;
                    end;
    PLuaSearchRec =^TLuaSearchRec;

//=============== Lua Functions Files Enumeration ==============================

function GetPLuaSearchRec(L: Plua_State; Index: Integer): PLuaSearchRec;
begin
     Result := PLuaSearchRec(LuaGetTableLightUserData(L, Index, HANDLE_SearchRecSTR));
     if (Result=Nil)
     then raise Exception.Create('Unable to Get TSearchRec');
end;

function LuaFindFirstTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  LuaPushInteger(L, FindFirst(theRec^.Path, theRec^.Attr, theRec^.Rec));
                  Result :=1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaFindNextTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  LuaPushInteger(L, FindNext(theRec^.Rec));
                  Result :=1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaGetNameTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  LuaPushString(L, theRec^.Rec.Name);
                  Result :=1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaGetTimeTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  LuaPushInteger(L, theRec^.Rec.Time);
                  Result :=1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaGetSizeTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  LuaPushInteger(L, theRec^.Rec.Size);
                  Result :=1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaGetAttrTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  LuaPushInteger(L, theRec^.Rec.Attr);
                  Result :=1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaIsDirTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  LuaPushBoolean(L, ((theRec^.Rec.Attr and $10)<>0) and
                                    ((theRec^.Rec.Name<>'.') and (theRec^.Rec.Name<>'..'))
                                    );
                  Result :=1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

function LuaFindCloseTSearchRec(L: Plua_State): Integer; cdecl;
Var
   theRec      :PLuaSearchRec;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theRec :=GetPLuaSearchRec(L, 1);
                  FindClose(theRec^.Rec);
                  FreeMem(theRec);
                  LuaSetTableClear(L, 1);
                  LuaPushBoolean(L, True);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;


function LuaCreateSearchRec(L: Plua_State): Integer; cdecl;
Var
   Path          :String;
   Attr          :Integer;
   xResult       :PLuaSearchRec;

begin
     Result := 0;

     try
        Path :=LuaGetTableString(L, 1, 'Path');
        Attr :=LuaGetTableInteger(L, 1, 'Attr');
        LuaSetTableNil(L, 1, 'Path');
        LuaSetTableNil(L, 1, 'Attr');
        GetMem(xResult, sizeOf(TLuaSearchRec));
        if (xResult=Nil)
        then raise Exception.Create('Unable to Create TSearchRec');
        FillChar(xResult^, sizeOf(TLuaSearchRec), 0);
        xResult^.Attr :=Attr;
        xResult^.Path :=Path;
        FillChar(xResult^.Rec, sizeOf(TSearchRec), 0);

        LuaSetTableLightUserData(L, 1, HANDLE_SearchRecSTR, xResult);
        LuaSetTableFunction(L, 1, 'FindFirst', LuaFindFirstTSearchRec);
        LuaSetTableFunction(L, 1, 'FindNext', LuaFindNextTSearchRec);
        LuaSetTableFunction(L, 1, 'GetName', LuaGetNameTSearchRec);
        LuaSetTableFunction(L, 1, 'GetTime', LuaGetTimeTSearchRec);
        LuaSetTableFunction(L, 1, 'GetSize', LuaGetSizeTSearchRec);
        LuaSetTableFunction(L, 1, 'GetAttr', LuaGetAttrTSearchRec);
        LuaSetTableFunction(L, 1, 'IsDir', LuaIsDirTSearchRec);

        LuaSetTableFunction(L, 1, 'FindClose', LuaFindCloseTSearchRec);
        LuaSetTableFunction(L, 1, 'Free', LuaFindCloseTSearchRec);
        Result := 1;
     except
        On E:Exception do begin
                               //LuaError(L, ERR_Script+E.Message);
                          end;

     end;
end;

//=============== Lua Functions Files Copy\Delete ==============================

//   CopyPath(string SourcePath, DestPath, wild [, integer ExistingFlags, boolean Recursive])
function LuaCopyPath(L: Plua_State): Integer; cdecl;
Var
   SourcePath,
   DestPath,
   wild           :String;
   Recursive      :Boolean;
   ExistingFlags,
   NParams        :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams>=3)
     then begin
               try
                  Recursive :=True;
                  ExistingFlags :=EXISTING_IF_ASK;

                  SourcePath :=LuaToString(L, 1);
                  DestPath :=LuaToString(L, 2);
                  wild :=LuaToString(L, 3);
                  if (NParams>=4) and
                     (lua_isnumber(L, 4)<>0)
                  then ExistingFlags :=LuaToInteger(L, 4);

                  if (NParams>=5) and
                     (lua_isboolean(L, 5))
                  then Recursive :=LuaToBoolean(L, 5);

                  CopyPath(SourcePath, DestPath, wild, ExistingFlags, Recursive);

                  DoFunctionLog('CopyPath', '"'+SourcePath+'"', '"'+DestPath+'"',
                                '"'+wild+'"');

                  LuaPushBoolean(L, True);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//   CopyFile(string SourceFile, DestPath, integer ExistingFlags, string DestFileName)
function LuaCopyFile(L: Plua_State): Integer; cdecl;
Var
   SourceFile,
   DestPath,
   DestFileName   :String;
   ExistingFlags,
   NParams        :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams>=2)
     then begin
               try
                  DestFileName :='';
                  ExistingFlags :=EXISTING_IF_ASK;

                  SourceFile :=LuaToString(L, 1);
                  DestPath :=LuaToString(L, 2);
                  if (NParams>=3) and
                     (lua_isnumber(L, 3)<>0)
                  then ExistingFlags :=LuaToInteger(L, 3);
                  if (NParams>=4) and
                     (lua_isstring(L, 4)<>0)
                  then DestFileName :=LuaToString(L, 4);

                  CopyFile(SourceFile, DestPath, ExistingFlags, DestFileName);

                  DoFunctionLog('CopyFile', '"'+SourceFile+'"', '"'+DestPath+'"',
                                IntToStr(ExistingFlags), '"'+DestFileName+'"');

                  LuaPushBoolean(L, True);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                  end;
               end;
          end;
end;

//   DeleteDir(string BaseDir, SelName, boolean Recursive, RemoveDirs)
function LuaDeleteDir(L: Plua_State): Integer; cdecl;
Var
   BaseDir,
   SelName     :String;
   Recursive,
   RemoveDirs  :Boolean;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=4)
     then begin
               try
                  BaseDir    :=LuaToString(L, 1);
                  SelName    :=LuaToString(L, 2);
                  Recursive  :=LuaToBoolean(L, 3);
                  RemoveDirs :=LuaToBoolean(L, 4);

                  DeleteDir(BaseDir, SelName, Recursive, RemoveDirs);

                  DoFunctionLog('DeleteDir', '"'+BaseDir+'"', '"'+SelName+'"',
                                BoolToStr(Recursive, True), BoolToStr(RemoveDirs, True));

                  LuaPushBoolean(L, True);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                  end;
               end;
          end;
end;

//   RegServer(string SourceFile)
function LuaRegServer(L: Plua_State): Integer; cdecl;
Var
   SourceFile  :String;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  SourceFile :=LuaToString(L, 1);

                  ShellExecute(GetDesktopWindow, 'open', PChar('REGSVR32'),
                               PChar('/s '+'"'+SourceFile+'"'),
                               Nil, SW_SHOWNORMAL);

                  DoFunctionLog('RegServer', '"'+SourceFile+'"');

                  LuaPushBoolean(L, True);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                  end;
               end;
          end;
end;

//   UnRegServer(string SourceFile)
function LuaUnRegServer(L: Plua_State): Integer; cdecl;
Var
   SourceFile  :String;
   NParams     :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  SourceFile :=LuaToString(L, 1);

                  ShellExecute(GetDesktopWindow, 'open', PChar('REGSVR32'),
                               PChar('/u /s '+'"'+SourceFile+'"'),
                               Nil, SW_SHOWNORMAL);

                  DoFunctionLog('UnRegServer', '"'+SourceFile+'"');

                  LuaPushBoolean(L, True);
                  Result := 1;
               except
                  On E:Exception do begin
                                       //LuaError(L, ERR_Script+E.Message);
                                  end;
               end;
          end;
end;


procedure RegisterFunctions(L: Plua_State);
begin
     LuaRegister(L, 'CreateSearchRec', LuaCreateSearchRec);
     LuaRegister(L, 'CopyPath', LuaCopyPath);
     LuaRegister(L, 'CopyFile', LuaCopyFile);
     LuaRegister(L, 'DeleteDir', LuaDeleteDir);
     LuaRegister(L, 'RegServer', LuaRegServer);
     LuaRegister(L, 'UnRegServer', LuaUnRegServer);
end;


end.
