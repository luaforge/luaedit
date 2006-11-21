//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2006                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_Object.pas   (rev. 1.0)
//
//  Description : Access from Lua scripts to TObject Classes
//                 (at this time only Properties and methods)
//
//******************************************************************************
//  Exported functions :
//
//   CreateObject(string className, bool CanFree [, param1, ..paramN])   return a new TObject.
//   GetObject(string Name)                          return an existing TObject.
//
//    TObject.PropertyName                     return Property Value as Variant.
//    TObject.PropertyName = (variant Value)                 set Property Value.
//    TObject:<method name>([param1, .., paramN]) call <method name>, return Result as Variant.
//    TObject:Free()                    free the object, return True on success.

// TO-DO :
//           funzioni lua da esportare :
//                 enumval(Type :???, value :string) enumstr(Type :???, value :Integer???)
//           nei metodi dove c'è var, come lo torno in Lua?
//           Eventi degli oggetti (una classe per ogni evento + lista con il nome della funzione lua)
//           Gestione delle property di Tipo Record  Vedi cos'è PFieldTable
//       +   Metodo x avere le property publiche??? invece di usare SetElement 
//       *   gestione del garbage collector (metafunction _gc)
//       *   Gestione di TComponent.<componentname> come se fosse una property tkClass
//      ++   Migliorare la gestione delle property che sono degli array (se possibile???)
//       *   Migliorare la registrazione delle classi, andare sempre alla ricerca dell' ancestor
//          COMMENTARE IL CODICE MENTRO ME LO RICORDO


unit Lua_Object;
{$J+}
interface

uses TypInfo, SysUtils, ScriptableObject, Lua, LuaUtils, lauxlib, Variants;

type
{$METHODINFO ON}
    TLuaObject = class(TObject)
    protected
       rInstanceObj :TObject;
       Owned        :Boolean;

       class function GetPublicPropertyAccessClass :TClass; virtual; abstract;

    public
       constructor Create(AInstanceObj :TObject; AOwned :Boolean);
       destructor Destroy; override;

       function CallMethod(MethodName :String; const Args : array of variant;
                        NeedResult: Boolean): Variant;


       //WARNING : if you want parameters when creating an Object you must write
       //          a function with the following form that create the object.
       //          You must change every parameter or result of type TClass, TObject
       //          with type integer (ObjComAuto do not support this types?????)
       //
       function LuaCreate(ObjClass :Integer) :Integer; overload;

       function GetDefaultArrayProp :String; virtual; abstract;
       function GetArrayPropType(Name :String; index :Variant) :PTypeInfo; virtual; abstract;
       function GetArrayProp(Name :String; index :Variant) :Variant; virtual; abstract;
       procedure SetArrayProp(Name :String; index :Variant; Value :Variant); virtual; abstract;

       //If the ElementType is tkSet or tkEnumeration (except the boolean) you may return the Value
       // in GetElement as a String
       function GetElementType(Name :String) :PTypeInfo; virtual; abstract;
       function GetElement(Name :String) :Variant; virtual; abstract;
       procedure SetElement(Name :String; Value :Variant); virtual; abstract;

       function GetPublicPropInfo(Name :String) :PPropInfo;
       function GetPublicPropValue(Name :String; AsString :Boolean) :Variant;
       procedure SetPublicPropValue(Name :String; Value :Variant);


       property InstanceObj :TObject read rInstanceObj;
    end;
{$METHODINFO OFF}

    TLuaObjectClass = class of TLuaObject;

const
     TypeInfoArray : TTypeInfo = (Kind : tkArray; Name :'');
     TypeInfoClass : TTypeInfo = (Kind : tkClass; Name :'');

procedure RegisterFunctions(L: Plua_State);
procedure RegisterClass(ObjClass :TClass; LuaClass :TLuaObjectClass=nil);
procedure RegisterObject(Obj :TObject; Name :String; LuaClass :TLuaObjectClass=nil);

function SetToString(TypeInfo: PTypeInfo; Value: Integer; Brackets: Boolean): string;
function StringToSet(EnumInfo: PTypeInfo; const Value: string): Integer;

implementation


uses MGList, Classes, Controls;

const
     OBJHANDLE_STR       ='Lua_TObjectHandle';
     ARRAYPROP_STR       ='Lua_TObjectArrayProp';
     ARRAYPROPNAME_STR   ='Lua_TObjectArrayPropName';
     SETPROP_VALUE       ='Lua_TObjectSetPropvalue';
     SETPROP_INFO       ='Lua_TObjectSetPropINFO';


type
    //Record stored in lua stack to mantain TLuaObject
    TLuaObjectData = packed record
       ID  : String[20];
       Obj :TLuaObject;
    end;
    PLuaObjectData =^TLuaObjectData;

    TLuaArrayPropData = record
       ID  : String[20];
       Obj :TLuaObject;
       PropName :string;
    end;

    TLuaSetPropData = record
       ID       :String[20];
       Info     :PTypeInfo;
       Value    :string;
    end;
    PLuaSetPropData = ^TLuaSetPropData;

    //This List associate an Object Class with a LuaObject Class
    TLuaClassesListData = record
       ObjClass :TClass;
       LuaClass :TLuaObjectClass;
    end;
    PLuaClassesListData =^TLuaClassesListData;

    TLuaClassesList = class(TMGList)
    protected
        InternalData :TLuaClassesListData;

        function allocData :Pointer; override;
        procedure deallocData(pData :Pointer); override;
        function internalFind(ObjClassName :String) :PLuaClassesListData; overload;
        function internalFind(ObjClass :TClass) :PLuaClassesListData; overload;
    public
        function Add(ObjClass :TClass; LuaClass :TLuaObjectClass=nil) :PLuaClassesListData; overload;
        function FindAncestor(ObjClass :TClass) :TLuaObjectClass;
        function Find(ObjClassName :String) :PLuaClassesListData; overload;
        function Find(ObjClass :TClass) :PLuaClassesListData; overload;
    end;

    //This List associate an Existing Object Instance with a Name in the Lua script
    TLuaExistingObjListData = record
       Obj :TObject;
       Name :String;
    end;
    PLuaExistingObjListData =^TLuaExistingObjListData;

    TLuaExistingObjList = class(TMGList)
    protected
        function allocData :Pointer; override;
        procedure deallocData(pData :Pointer); override;
    public
        function Add(Obj :TObject; Name :String) :PLuaExistingObjListData; overload;
        function Find(Name :String) :PLuaExistingObjListData; overload;
    end;


Var
   LuaClassesList :TLuaClassesList =nil;
   LuaExistingObjList :TLuaExistingObjList =nil;


procedure MySetPropValue(Instance: TObject; PropInfo: PPropInfo;
  const Value: Variant);
begin
     //SetPropValue raise an exception when i try to set a class property...
     // even if it's value is a simple Integer (infact GetPropValue return it as Integer)

     if PropInfo^.PropType^.Kind = tkClass
     then SetOrdProp(Instance, PropInfo, Value)
     else SetPropValue(Instance, PropInfo, Value);
end;

constructor TLuaObject.Create(AInstanceObj :TObject; AOwned :Boolean);
begin
     inherited Create;
     rInstanceObj :=AInstanceObj;
     Owned :=AOwned;
end;

destructor TLuaObject.Destroy;
begin
     if Owned then rInstanceObj.Free;
     inherited Destroy;
end;

function TLuaObject.LuaCreate(ObjClass :Integer) :Integer;
begin
     Result :=Integer(TClass(ObjClass).Create);
end;

function TLuaObject.CallMethod(MethodName :String; const Args : array of variant;
                               NeedResult: Boolean): Variant;
Var
   scripter :TScriptableObject;
   pRes     :PVariant;

begin
     Result :=NULL;
     scripter :=nil;
     try
        //Try with My Methods
        scripter :=TScriptableObject.Create(Self, false);
        pRes :=scripter.CallMethod(scripter.NameToDispID(MethodName), Args, NeedResult);
        if (pRes<>nil)
        then Result :=pRes^;
        scripter.Free;
     except
        scripter.Free;
        Result :=NULL;
        try
           //Try with InstanceObj Methods
           scripter :=TScriptableObject.Create(rInstanceObj, false);
           pRes :=scripter.CallMethod(scripter.NameToDispID(MethodName), Args, NeedResult);
           if (pRes<>nil)
           then Result :=pRes^;
           scripter.Free;
        except
           scripter.Free;
           Result :=NULL;
        end;
     end;
end;

function TLuaObject.GetPublicPropInfo(Name :String) :PPropInfo;
Var
   _parent :TLuaObjectClass;

begin
     _parent :=TLuaObjectClass(Self.ClassType);

     repeat
          Result :=GetPropInfo(_parent.GetPublicPropertyAccessClass, Name, tkProperties);
          if (Result=nil)
          then _parent := TLuaObjectClass(_parent.ClassParent);
     //IF the Property is not public in this Class, try in ancestors.
     // This method avoid to redeclare property as published in every TXXXAccess class,
     // for example :
     //    TLuaControl <- TLuaWinControl
     //    TControl    <- TWinControl
     // Without this method, in TLuaWinControl, you might declare every public property
     // of TWinControl including every public property of TControl.
     // With this method, in TLuaWinControl, you can declare only public property of TWinControl
     until (_parent=TLuaObject) or (Result<>nil);
end;

(*
begin
     Result :=GetPropInfo(GetPublicPropertyAccessClass, Name, tkProperties);
end;
*)

function TLuaObject.GetPublicPropValue(Name :String; AsString :Boolean) :Variant;
Var
   PropInfo :PPropInfo;

begin
     PropInfo :=GetPublicPropInfo(Name);
     if (PropInfo<>nil)
     then Result :=GetPropValue(rInstanceObj, PropInfo, AsString);
end;

procedure TLuaObject.SetPublicPropValue(Name :String; Value :Variant);

Var
   PropInfo :PPropInfo;

begin
     PropInfo :=GetPublicPropInfo(Name);
     if (PropInfo<>nil)
     then MySetPropValue(rInstanceObj, PropInfo, Value);
end;


//==============================================================================
//
function TLuaClassesList.allocData :Pointer;
begin
     GetMem(Result, sizeof(TLuaClassesListData));
     fillchar(Result^, sizeof(TLuaClassesListData), 0);
end;

procedure TLuaClassesList.deallocData(pData :Pointer);
begin
     FreeMem(pData, sizeof(TLuaClassesListData));
end;

function TLuaClassesList.Add(ObjClass :TClass; LuaClass :TLuaObjectClass=nil) :PLuaClassesListData;
begin
     Result :=Find(ObjClass.ClassName);
     if (Result=nil)
     then Result :=Self.Add;

     if (Result<>nil)
     then begin
               Result^.ObjClass :=ObjClass;
               (*if (LuaClass=nil)
               then Result^.LuaClass :=TLuaObject
               else*) Result^.LuaClass :=LuaClass;
          end;
end;

function TLuaClassesList.FindAncestor(ObjClass :TClass) :TLuaObjectClass;
Var
   _parent :TClass;
   Data    :PLuaClassesListData;

begin
     _parent :=ObjClass.ClassParent;
     Data :=nil;
     while (_parent<>nil) and (Data=nil) do
     begin
          Data :=internalFind(_parent);
          if (Data<>nil)
          then Result :=Data^.LuaClass
          else _parent := _parent.ClassParent;
     end;
     if (Data=nil)
     then Result :=TLuaObject;
end;

function TLuaClassesList.internalFind(ObjClassName :String) :PLuaClassesListData;

   function CompByClassName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
   begin
     Result := String(PChar(ptData1)) = Uppercase(PLuaClassesListData(ptData2)^.ObjClass.Classname);
   end;

begin
     Result :=Self.ExtFind(PChar(Uppercase(ObjClassName)), 0, @CompByClassName);
end;

function TLuaClassesList.internalFind(ObjClass :TClass) :PLuaClassesListData;

   function CompByClass(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
   begin
     Result := TClass(ptData1) = PLuaClassesListData(ptData2)^.ObjClass;
   end;

begin
     Result :=Self.ExtFind(ObjClass, 0, @CompByClass);
end;

function TLuaClassesList.Find(ObjClass :TClass) :PLuaClassesListData;

begin
     Result :=Self.internalFind(ObjClass);

     if (Result<>nil)
     then begin
               if (Result^.LuaClass=nil) //The Class is registered, but have no LuaClass,
                                         //try to find a registered ancestor class
               then Result^.LuaClass :=FindAncestor(Result^.ObjClass);
          end
     else begin
               //The Class is not registered, try to find a registered ancestor class
               InternalData.ObjClass :=ObjClass;
               InternalData.LuaClass :=FindAncestor(ObjClass);

               if (InternalData.LuaClass<>nil)
               then Result :=@InternalData
               else Result :=nil;
          end;
end;


function TLuaClassesList.Find(ObjClassName :String) :PLuaClassesListData;
begin
     Result :=Self.internalFind(ObjClassName);

     if (Result<>nil)
     then begin
               if (Result^.LuaClass=nil) //The Class is registered, but have no LuaClass,
                                         //try to find a registered ancestor class
               then Result^.LuaClass :=FindAncestor(Result^.ObjClass);
          end
     else begin
               Result :=Self.internalFind(FindClass(ObjClassName));
               if (Result<>nil)
               then begin
                         if (Result^.LuaClass=nil) //The Class is registered in VCL, but have no LuaClass,
                                                   //try to find a registered ancestor class
                         then Result^.LuaClass :=FindAncestor(Result^.ObjClass);
                    end
          end;
end;

//==============================================================================
//
function TLuaExistingObjList.allocData :Pointer;
begin
     GetMem(Result, sizeof(TLuaExistingObjListData));
     fillchar(Result^, sizeof(TLuaExistingObjListData), 0);
end;

procedure TLuaExistingObjList.deallocData(pData :Pointer);
begin
     PLuaExistingObjListData(pData)^.Name :='';
     FreeMem(pData, sizeof(TLuaExistingObjListData));
end;

function TLuaExistingObjList.Add(Obj :TObject; Name :String) :PLuaExistingObjListData;
begin
     Result :=Find(Name);
     if (Result=nil)
     then Result :=Self.Add;

     if (Result<>nil)
     then begin
               Result^.Obj :=Obj;
               Result^.Name :=Uppercase(Name);
          end;
end;

function TLuaExistingObjList.Find(Name :String) :PLuaExistingObjListData;

function CompByClass(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := String(PChar(ptData1)) = PLuaExistingObjListData(ptData2)^.Name;
end;

begin
     Result :=Self.ExtFind(PChar(Uppercase(Name)), 0, @CompByClass);
end;

//==============================================================================

function GetPropertyArrayObject(var Data : TLuaArrayPropData; L: Plua_State; Index: Integer): boolean; forward;
function LuaPush_TLuaObject(L :Plua_State; theParams :array of Variant;
                            Obj :TObject=nil; ObjClassName :String='';
                            CanFree :Boolean=True) :boolean; forward;
function LuaPushPropertyArrayObject(L: Plua_State; Obj :TLuaObject; PropName :string): boolean; forward;
function LuaPushPropertySet(L: Plua_State; TypeInfo :PTypeInfo; PropValue :Variant): boolean; forward;


function PushProperty(L :Plua_State; scripter :TLuaObject;
                      PropName :string; PropValue :Variant; PropType :PTypeInfo) :Integer;
begin
     Result :=0;

     if (PropType^.Kind = tkClass)
     then begin
               //If this property is a class, push a TLuaObject in the stack
               if LuaPush_TLuaObject(L, [], TObject(Integer(PropValue)))
               then Result := 1;
          end
     else
     if (PropType^.Kind =tkArray)
     then begin //If this property is an array, push an ArrayPropObject in the stack
               if LuaPushPropertyArrayObject(L, scripter, PropName)
               then Result := 1;
          end
     else
     if (PropType^.Kind =tkSet)
     then begin //If this property is an array, push an ArrayPropObject in the stack
               if LuaPushPropertySet(L, PropType, PropValue)
               then Result := 1;
          end
     else
     begin //Push the PropValue
          LuaPushVariant(L, PropValue);
          Result := 1;
     end;
end;

//==============================================================================
// Array Properties Support

function Lua_IsPropertyArrayObject(L: Plua_State; Index: Integer): boolean;
begin
     Result :=False;
     try
        Result :=(LuaGetTableString(L, Index, 'ID')=ARRAYPROP_STR);
     except
     end;
end;

function GetPropertyArrayObject(var Data : TLuaArrayPropData; L: Plua_State; Index: Integer): boolean;
begin
     Result :=false;
     try
        Data.Obj :=TLuaObject(LuaGetTableLightUserData(L, Index, ARRAYPROP_STR));
        Data.PropName :=LuaGetTableString(L, Index, ARRAYPROPNAME_STR);
        Result :=true;
     except
     end;
end;

function Lua_ArrayProp_Get(L: Plua_State): Integer; cdecl;
Var
   indice,
   PropValue    :Variant;
   PropType     :PTypeInfo;
   GetPropOK    :Boolean;
   NParams      :Integer;
   Data         :TLuaArrayPropData;

begin
     Result := 0;
     NParams := lua_gettop(L);

     if (NParams=2) then
     try
        GetPropertyArrayObject(Data, L, 1);
        indice :=LuaToVariant(L, 2);

        if (indice<>NULL)
        then begin
                  PropType :=Data.Obj.GetArrayPropType(Data.PropName, indice);

                  GetPropOK := (PropType<>nil);

                  if GetPropOK
                  then PropValue :=Data.Obj.GetArrayProp(Data.PropName, indice)
                  else PropValue :=NULL;

                  Result :=PushProperty(L, Data.Obj, Data.PropName, PropValue, PropType);
             end
        else raise Exception.CreateFmt('Trying to index %s.%s with a NULL index', [Data.Obj.InstanceObj.ClassName, Data.PropName]);

     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;

     end;
end;

function Lua_ArrayProp_Set(L: Plua_State): Integer; cdecl;
begin
end;

function LuaPushPropertyArrayObject(L: Plua_State; Obj :TLuaObject; PropName :string): boolean;
begin
     lua_newtable(L);
     LuaSetTableString(L, -1, 'ID', ARRAYPROP_STR);
     LuaSetTableLightUserData(L, -1, ARRAYPROP_STR, Obj);
     LuaSetTableString(L, -1, ARRAYPROPNAME_STR, PropName);
     LuaSetTablePropertyFuncs(L, -1, Lua_ArrayProp_Get, Lua_ArrayProp_Set);
     Result :=true;
end;

//==============================================================================
//Set Properties Support

function Lua_IsPropertySet(L: Plua_State; Index: Integer): boolean;
begin
     Result :=False;
     try
        Result :=lua_istable(L, Index) and (LuaGetTableString(L, Index, 'ID')=SETPROP_VALUE);
     except
     end;
end;

function GetPropertySet(Data :PLuaSetPropData; L: Plua_State; Index: Integer): String;
begin
     Result :='';
     if Data<>nil then FillChar(Data^, Sizeof(TLuaSetPropData), 0);
     
     try
        if lua_istable(L, Index)
        then begin
                  Result :=LuaGetTableString(L, Index, SETPROP_VALUE);
                  if Data<>nil then
                  begin
                       Data^.ID :=LuaGetTableString(L, Index, 'ID');
                       Data^.Info :=LuaGetTableLightUserData(L, Index, SETPROP_INFO);
                  end;
             end
        else begin
                  if (lua_isString(L, Index)=1)
                  then Result :=LuaToString(L, Index);
             end;

        if Data<>nil
        then Data^.Value :=Result;
     except
     end;
end;

function SetToString(TypeInfo: PTypeInfo; Value: Integer; Brackets: Boolean): string;
var
  S: TIntegerSet;
  I: Integer;
  EnumInfo :PTypeInfo;

begin
  Result := '';
  Integer(S) := Value;
  EnumInfo := GetTypeData(TypeInfo)^.CompType^;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(EnumInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;

  // grab the next enum name
function SetNextWord(var P: PChar): string;
var
   i: Integer;

begin
    i := 0;

    // scan til whitespace
    while not (P[i] in [',', ' ', #0,']']) do
      Inc(i);

    SetString(Result, P, i);

    // skip whitespace
    while P[i] in [',', ' ',']'] do
      Inc(i);

    Inc(P, i);
end;

function StringToSet(EnumInfo: PTypeInfo; const Value: string): Integer;
var
  P: PChar;
  EnumName: string;
  EnumValue: Longint;

begin
  Result := 0;
  if Value = '' then Exit;
  P := PChar(Value);

  // skip leading bracket and whitespace
  while P^ in ['[',' '] do
    Inc(P);

  EnumName := SetNextWord(P);
  while EnumName <> '' do
  begin
    EnumValue := GetEnumValue(EnumInfo, EnumName);
    if EnumValue < 0 then
      raise EPropertyConvertError.CreateFmt('Invalid Property Element %s', [EnumName]);
    Include(TIntegerSet(Result), EnumValue);
    EnumName := SetNextWord(P);
  end;
end;


function Lua_SetProp_Add(L: Plua_State): Integer; cdecl;
Var
   Val1, Val2,
   EnumName,
   xResult      :String;
   NParams      :Integer;
   pVal2        :PChar;

begin
     Result := 0;
     NParams := lua_gettop(L);

     if (NParams=2) then
     try
        Val1 :=GetPropertySet(nil, L, 1);
        if (Val1='')
        then raise Exception.Create('Left Side is Not a Set');

        Val2 :=GetPropertySet(nil, L, 2);
        if (Val2='')
        then raise Exception.Create('Right Side is Not a Set');

        xResult :=Val1;
        pVal2 :=PChar(Val2);
        EnumName := SetNextWord(pVal2);
        while (EnumName<>'') do
        begin
             if (Pos(EnumName, Val1)<1)
             then xResult :=xResult+','+EnumName;
             EnumName := SetNextWord(pVal2);
        end;
        LuaPushPropertySet(L, nil, xResult);
        Result :=1;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;

     end;
end;

function Lua_SetProp_Sub(L: Plua_State): Integer; cdecl;
Var
   Val1, Val2,
   EnumName,
   xResult      :String;
   NParams      :Integer;
   pVal2        :PChar;
   xPos         :Integer;

begin
     Result := 0;
     NParams := lua_gettop(L);

     if (NParams=2) then
     try
        Val1 :=GetPropertySet(nil, L, 1);
        if (Val1='')
        then raise Exception.Create('Left Side is Not a Set');

        Val2 :=GetPropertySet(nil, L, 2);
        if (Val1='')
        then raise Exception.Create('Right Side is Not a Set');

        xResult :=Val1;
        pVal2 :=PChar(Val2);
        EnumName := SetNextWord(pVal2);
        while (EnumName<>'') do
        begin
             xPos := Pos(EnumName, xResult);
             while (xPos>0) do
             begin
                  Delete(xResult, xPos, Length(EnumName)+1);
                  xPos := Pos(EnumName, xResult);
             end;
             EnumName := SetNextWord(pVal2);
        end;
        LuaPushPropertySet(L, nil, xResult);
        Result :=1;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;

     end;
end;

function LuaPushPropertySet(L: Plua_State; TypeInfo :PTypeInfo; PropValue :Variant): boolean;
begin
     lua_newtable(L);
     LuaSetTableString(L, -1, 'ID', SETPROP_INFO);
     LuaSetTableLightUserData(L, -1, SETPROP_INFO, TypeInfo);

     if (TVarData(PropValue).VType = varString) or
        (TVarData(PropValue).VType = varOleStr)
     then LuaSetTableString(L, -1, SETPROP_VALUE, PropValue)
     else LuaSetTableString(L, -1, SETPROP_VALUE, SetToString(TypeInfo, PropValue, false));

     LuaSetMetaFunction(L, -1, '__add', Lua_SetProp_Add);
     LuaSetMetaFunction(L, -1, '__sub', Lua_SetProp_Sub);
     Result :=true;
end;

//==============================================================================

function GetTLuaObject(L: Plua_State; Index: Integer): TLuaObject;
Var
   pObjData :PLuaObjectData;

begin
     //Result := TLuaObject(LuaGetTableLightUserData(L, Index, OBJHANDLE_STR));

     Result :=nil;
     try
        if (lua_isuserdata(L, Index)=1) then
        begin
             pObjData :=lua_touserdata(L, Index);
             if (pObjData^.ID=OBJHANDLE_STR)
             then Result :=pObjData^.Obj;
        end;
     except
     end;
end;


//=== Methods Access methods ===================================================
function Lua_TObject_Methods(L: Plua_State): Integer; cdecl;
var
  NParams,
  iParams,
  invParams    :Integer;
  theParams    :array of Variant;
  xResult      :Variant;
  ParamISOBJ   :Boolean;
  MethodName   :String;
  curComponent :TObject;
  NewObj,
  LuaObj       :TLuaObject;
  PropSetData  :TLuaSetPropData;
  retValue     :Variant;

begin
     Result :=0;
     NParams := lua_gettop(L);
     try
        LuaObj :=GetTLuaObject(L, 1);

        MethodName :=LuaGetCurrentFuncName(L);

        //Fill Params for Method call in inverse sequense (why???)
        SetLength(theParams, (NParams-1));
        invParams :=0;
        for iParams :=NParams downto 2  do
        begin
             //If Param[iParams] is an Object get it's real value
             ParamISOBJ :=false;
             NewObj :=GetTLuaObject(L, iParams);
             ParamISOBJ :=(NewObj<>nil);

             if ParamISOBJ
             then xResult :=Integer(NewObj.InstanceObj)
             else begin
                       if Lua_IsPropertySet(L, iParams)
                       then begin
                                 xResult :=GetPropertySet(@PropSetData, L, iParams);
                                 //try to convert string value to Real Set Value
                                 if (PropSetData.Info<>nil)
                                 then xResult :=StringToSet(PropSetData.Info, xResult);
                            end
                       else xResult :=LuaToVariant(L, iParams);
                  end;
             theParams[invParams] :=xResult;
             inc(invParams);
        end;

        retValue := LuaObj.CallMethod(MethodName, theParams, true);
        if (retValue<>NULL)
        then begin
                  //TO-DO : PushVariant è riduttivo, potrebbe tornare un oggetto etc...
                  //        Fare una procedura simile a PushProperty
                  LuaPushVariant(L, retValue);
                  Result :=1;
             end;

     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;

     end;
end;

function Lua_TObject_GetProp(L: Plua_State): Integer; cdecl; forward;
function Lua_TObject_SetProp(L: Plua_State): Integer; cdecl; forward;
function Lua_TObject_Free(L: Plua_State): Integer; cdecl; forward;

function LuaPush_TLuaObject(L :Plua_State; theParams :array of Variant;
                            Obj :TObject=nil; ObjClassName :String='';
                            CanFree :Boolean=True) :boolean;
var
  NParams,
  iParams      :Integer;
  xResult      :Variant;
  retValue     :Variant;
  ClassData    :PLuaClassesListData;
  LuaObj       :TLuaObject;
  NewObj       :TObject;
  CanCreate    :Boolean;
  LuaClass     :TLuaObjectClass;
  pObjData     :PLuaObjectData;
  scripter :TScriptableObject;

begin
     Result :=false;

     CanCreate := (Obj=nil);

     if CanCreate
     then ClassData :=LuaClassesList.Find(ObjClassName)
     else ClassData :=LuaClassesList.Find(Obj.ClassType);

     if (ClassData=nil)
     then LuaClass :=TLuaObject
     else LuaClass :=ClassData^.LuaClass;

     //lua_newtable(L);
     pObjData :=lua_newuserdata(L, sizeof(TLuaObjectData));

     if CanCreate
     then begin
               if (LuaClass<>nil)
               then begin
                         LuaObj :=LuaClass.Create(nil, false);
                         theParams[High(theParams)] :=Integer(ClassData^.ObjClass);
                         
                         try
                            retValue :=LuaObj.CallMethod('LuaCreate', theParams, true);
                            if (retValue<>NULL)
                            then NewObj :=TObject(Integer(retValue))
                            else NewObj :=ClassData^.ObjClass.Create;
                         except
                            NewObj :=ClassData^.ObjClass.Create;
                         end;
                         LuaObj.Free;
                         LuaObj :=LuaClass.Create(NewObj, CanFree);
                    end
               else begin
                         NewObj :=ClassData^.ObjClass.Create;
                         LuaObj :=LuaClass.Create(NewObj, CanFree);
                    end;
          end
     else begin
               if (LuaClass<>nil)
               then LuaObj :=LuaClass.Create(Obj, false)
               else LuaObj :=TLuaObject.Create(Obj, false);
          end;

     pObjData^.ID :=OBJHANDLE_STR;
     pObjData^.Obj :=LuaObj;
     LuaSetTablePropertyFuncs(L, -1, Lua_TObject_GetProp, Lua_TObject_SetProp);
     LuaSetMetaFunction(L, -1, '__gc', Lua_TObject_Free);

     Result :=true;
end;

//=== Properties Access methods ================================================


//NON FUNZIONA!!!!!!! PERCHE' FA LA LISTA SOLO DELLE PROPERTY PUBLISHED
function FindPredefArrayProp(AComponent :TObject):String;
Var
   Props       :PPropList;
   i, n        :Integer;
   curPropInfo :PPropInfo;

begin
     Result :='';
     n :=GetPropList(AComponent, Props);
     for i:=0 to n-1 do
     begin
          curPropInfo :=PPropInfo(Props^[i]);
          if ((curPropInfo^.Default and $80000000)<>0) and
             (curPropInfo^.PropType^^.Kind = tkArray)
          then begin
                    Result :=curPropInfo^.Name;
               end;
     end;
end;

function Lua_TObject_GetProp(L: Plua_State): Integer; cdecl;
Var
   ty           :Integer;
   PropName     :String;
   PropValue    :Variant;
   PropInfo     :PPropInfo;
   PropType     :PTypeInfo;
   GetPropOK    :Boolean;
   NParams      :Integer;
   ClassData    :PLuaClassesListData;
   LuaObj       :TLuaObject;
   NewObj       :TObject;

  function TryGetProp(AComponent :TObject; PropName :String; PropKind :TTypeKinds):Boolean;
  Var
     AsString :Boolean;

  begin
       Result :=false;
       try
          PropInfo :=GetPropInfo(AComponent, PropName, PropKind);
          if (PropInfo<>nil)
          then begin //This Name is a Property
                    PropType :=PropInfo^.PropType^;

                    //Return as String only if the property is a Set or an Enum, exclude the Boolean
                    if (PropType^.Kind=tkEnumeration)
                    then AsString := not(GetTypeData(PropType)^.BaseType^ = TypeInfo(Boolean))
                    else AsString := (PropType^.Kind=tkSet);

                    PropValue :=GetPropValue(AComponent, PropInfo, AsString);

                    Result :=true;
               end;
       except
       end;
  end;

  function TryGetPublicProp:Boolean;
  Var
     AsString :Boolean;

  begin
       Result :=false;
       try
          PropInfo :=LuaObj.GetPublicPropInfo(PropName);
          if (PropInfo<>nil)
          then begin //This Name is a Property
                    PropType :=PropInfo^.PropType^;

                    //Return as String only if the property is a Set or an Enum, exclude the Boolean
                    if (PropType^.Kind=tkEnumeration)
                    then AsString := not(GetTypeData(PropType)^.BaseType^ = TypeInfo(Boolean))
                    else AsString := (PropType^.Kind=tkSet);

                    if (PropType^.Kind<>tkArray)
                    then PropValue :=GetPropValue(LuaObj.InstanceObj, PropInfo, AsString);

                    Result :=true;
               end;
       except
       end;
  end;

  procedure GetPredefArrayProp(Index: Integer);
  var
    indice :Variant;

  begin
       GetPropOK :=false;
       try
          indice :=LuaToVariant(L, Index);
          PropName :=LuaObj.GetDefaultArrayProp;
          PropType :=LuaObj.GetArrayPropType(PropName, indice);

          GetPropOK := (PropType<>nil);
       except
       end;

       if GetPropOK
       then PropValue :=LuaObj.GetArrayProp(PropName, indice)
       else PropValue :=NULL;
  end;


begin
     Result := 0;
     GetPropOK := false;
     NParams := lua_gettop(L);

     if (NParams>0) then
     try
        LuaObj :=GetTLuaObject(L, 1);

        ty := lua_type(L, 2);
        if (ty = LUA_TNUMBER)
        then GetPredefArrayProp(2)
        else begin
                  PropName :=LuaToString(L, 2);

                  GetPropOK :=TryGetProp(LuaObj, PropName, tkProperties);
                  if not(GetPropOK)
                  then begin  //Is not a Property published in the TLuaObject, try the TObject
                            GetPropOK :=TryGetProp(LuaObj.InstanceObj, PropName, tkProperties);

                            if not(GetPropOK)
                            then begin  //Try with public Properties using scripter.GetPublicXXX
                                      GetPropOK :=TryGetPublicProp;
                                 end;


                            if not(GetPropOK)
                            then begin  //Try with public elements using scripter.GetElementXXX
                                      try
                                         PropType :=LuaObj.GetElementType(PropName);
                                         GetPropOK := (PropType<>nil);
                                      except
                                      end;

                                      if GetPropOK and (PropType^.Kind<>tkArray)
                                      then PropValue :=LuaObj.GetElement(PropName);
                                 end;
                       end;
             end;

        if (GetPropOK)
        then begin //This Name is a Property
                  Result :=PushProperty(L, LuaObj, PropName, PropValue, PropType);
             end
        else begin //This Name may be a Method or an Event ???????????
                   //TO-DO : Testare se è un evento (OnXXXX), in questo caso
                   //        tornare l' eventuale nome della funzione lua

                   // (this code is for method)
                   LuaRawSetTableNil(L, 1, PropName);
                   LuaRawSetTableFunction(L, 1, PropName, Lua_TObject_Methods);

                   lua_pushcfunction(L, Lua_TObject_Methods);
                   Result := 1;
             end;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;

     end;
end;


//      TObject:SetProp(string PropName, variant Value)      set Property Value.
function Lua_TObject_SetProp(L: Plua_State): Integer; cdecl;
Var
   curComponent :TObject;
   ty           :Integer;
   PropName     :String;
   PropInfo     :PPropInfo;
   PropType     :PTypeInfo;
   SetPropOK    :Boolean;
   NewVal       :Variant;
   NParams      :Integer;
   ClassData    :PLuaClassesListData;
   LuaObj       :TLuaObject;
   NewObj       :TLuaObject;
   NewValISPropertySet,
   NewValISOBJ  :Boolean;
   PropertySetData :TLuaSetPropData;

  function TrySetProp(AComponent :TObject; PropName :String; PropKind :TTypeKinds):Boolean;
  begin
       Result :=false;
       try
          PropInfo :=GetPropInfo(AComponent, PropName, PropKind);
          if (PropInfo<>nil)
          then begin //This Name is a Property
                    curComponent :=AComponent;
                    PropType :=PropInfo^.PropType^;
                    Result :=true;
               end;
       except
       end;
  end;

  function TrySetPublicProp:Boolean;
  begin
       Result :=false;
       try
          PropInfo :=LuaObj.GetPublicPropInfo(PropName);
          if (PropInfo<>nil)
          then begin //This Name is a Property
                    curComponent :=LuaObj.InstanceObj;
                    PropType :=PropInfo^.PropType^;
                    Result :=true;
               end;
       except
       end;
  end;

  procedure SetPredefArray(Index: Integer);
  var
    indice :Variant;

  begin
       indice :=LuaToVariant(L, Index);
       PropName :=LuaObj.GetDefaultArrayProp;
       PropType :=LuaObj.GetArrayPropType(PropName, indice);

       if (PropType^.Kind=tkClass)
       then begin
                 if NewValISOBJ
                 then LuaObj.SetArrayProp(PropName, indice, Integer(NewObj.InstanceObj))
                 else raise Exception.Createfmt('Cannot assign %s to %s.%s', [NewVal, curComponent.ClassName, PropName]);
            end
       else LuaObj.SetArrayProp(PropName, indice, NewVal);
  end;


begin
     Result := 0;

     ty :=lua_type(L, 3);
     if (ty <> LUA_TFUNCTION) then
     try
        LuaObj :=GetTLuaObject(L, 1);

        //If the new Value is an Object get it's real value
        NewValISOBJ :=false;
        NewObj :=GetTLuaObject(L, 3);
        NewValISOBJ :=(NewObj<>nil);

        if not(NewValISOBJ)
        then begin
                  NewValISPropertySet :=Lua_IsPropertySet(L, 3);
                  if NewValISPropertySet
                  then NewVal :=GetPropertySet(@PropertySetData, L, 3)
                  else NewVal :=LuaToVariant(L, 3);
             end;

        ty := lua_type(L, 2);
        if (ty = LUA_TNUMBER)
        then SetPredefArray(2)
        else begin
                  PropName :=LuaToString(L, 2);

                  SetPropOK :=TrySetProp(LuaObj, PropName, tkProperties);
                  if not(SetPropOK)
                  then begin  //Is not a Property published in the TLuaObject, try the TObject
                            SetPropOK :=TrySetProp(LuaObj.InstanceObj, PropName, tkProperties);

                            if not(SetPropOK)
                            then begin //Try with public Properties using scripter.GetPublicPropInfo
                                      SetPropOK :=TrySetPublicProp;
                                 end;

                            if not(SetPropOK)
                            then begin  //Try with public elements using scripter.SetElementXXX
                                      try
                                         PropType :=LuaObj.GetElementType(PropName);
                                         SetPropOK := (PropType<>nil);
                                      except
                                      end;

                                      if SetPropOK then
                                      begin
                                           if (PropType^.Kind=tkClass)
                                           then begin
                                                     if NewValISOBJ
                                                     then LuaObj.SetElement(PropName, Integer(NewObj.InstanceObj))
                                                     else raise Exception.Createfmt('Cannot assign %s to %s.%s', [NewVal, LuaObj.InstanceObj.ClassName, PropName]);
                                                end
                                           else begin
                                                     if NewValISPropertySet  //convert string to real Value
                                                     then NewVal :=StringToSet(PropertySetData.Info, NewVal);
                                                     LuaObj.SetElement(PropName, NewVal);
                                                end;
                                           Exit;
                                      end;
                                 end;
                       end;

                  if SetPropOK
                  then begin
                            if (PropType^.Kind=tkClass)
                            then begin
                                      if NewValISOBJ
                                      then MySetPropValue(curComponent, PropInfo, Integer(NewObj.InstanceObj))
                                      else raise Exception.Createfmt('Cannot assign %s to %s.%s', [NewVal, curComponent.ClassName, PropName]);
                                 end
                            else MySetPropValue(curComponent, PropInfo, NewVal);
                       end
                  else begin //This Name may be a Method or an Event ???????????
                   //TO-DO : se è un evento potremmo mantenere una Lista
                   //        che associa un oggetto con il nome di una
                   //        funzione Lua. Settiamo come evento un
                   //        nostro metodo che cerca nella Lista l' oggetto
                   //        e chiama la relativa funzione lua
                       end;
             end;
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                          end;

     end;
end;


//      TObject:Free()                                          free the object.
function Lua_TObject_Free(L: Plua_State): Integer; cdecl;
Var
   theObject    :TLuaObject;
   NParams      :Integer;

begin
     Result := 0;

     NParams := lua_gettop(L);
     if (NParams=1)
     then begin
               try
                  theObject :=GetTLuaObject(L, 1);

                  //LuaEventsList.Del(theObject.InstanceObj);

                  theObject.Free;
                  //LuaSetTableClear(L, 1);

               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;

//==============================================================================
// Main Functions

function Lua_CreateObject(L: Plua_State): Integer; cdecl;
var
  NParams,
  iParams,
  invParams    :Integer;
  theParams    :array of Variant;
  xResult      :Variant;
  retValue     :PVariant;
  ObjClassName :String;
  ClassData    :PLuaClassesListData;
  scripter     :TLuaObject;
  NewObj       :TLuaObject;
  CanFree,
  ParamISOBJ   :Boolean;
  PropSetData  :TLuaSetPropData;

begin
     Result :=0;
     NParams := lua_gettop(L);
     if (NParams>1)
     then begin
               try
                  ObjClassName :=LuaToString(L, 1);
                  CanFree :=LuaToBoolean(L, 2);

                  //Fill Params for Create call in inverse sequense (why???)
                  SetLength(theParams, NParams-1);
                  invParams :=0;
                  for iParams :=NParams downto 3  do
                  begin
                       //If Param[iParams] is an Object get it's real value
                       ParamISOBJ :=false;
                       NewObj :=GetTLuaObject(L, iParams);
                       ParamISOBJ :=(NewObj<>nil);

                       if ParamISOBJ
                       then xResult :=Integer(NewObj.InstanceObj)
                       else begin
                                 if Lua_IsPropertySet(L, iParams)
                                 then begin
                                           xResult :=GetPropertySet(@PropSetData, L, iParams);
                                           //try to convert string value to Real Set Value
                                           if (PropSetData.Info<>nil)
                                           then xResult :=StringToSet(PropSetData.Info, xResult);
                                      end
                                 else xResult :=LuaToVariant(L, iParams);
                            end;
                            
                       theParams[invParams] :=xResult;
                       inc(invParams);
                  end;
                  //LuaPush_TLuaObject sets the last parameter with the Class
                  theParams[invParams] :=1234;

                  if LuaPush_TLuaObject(L, theParams, nil, ObjClassName, CanFree)
                  then Result :=1
                  else raise Exception.Createfmt('Cannot Create class %s', [ObjClassName])
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;


function Lua_GetObject(L: Plua_State): Integer; cdecl;
var
  NParams,
  iParams,
  invParams    :Integer;
  theParams    :array of Variant;
  xResult      :Variant;
  retValue     :PVariant;
  ObjName      :String;
  ObjData      :PLuaExistingObjListData;
  scripter     :TLuaObject;
  NewObj       :TObject;

begin
     Result :=0;
     NParams := lua_gettop(L);
     if (NParams>0)
     then begin
               try
                  ObjName :=LuaToString(L, 1);

                  ObjData := LuaExistingObjList.Find(ObjName);
                  if (ObjData<>nil)
                  then begin
                            if LuaPush_TLuaObject(L, [], ObjData^.Obj)
                            then Result :=1
                            else raise Exception.Createfmt('Cannot Interface with class %s', [ObjData^.Obj.ClassName]);
                       end
                  else raise Exception.Createfmt('Object "%s" not found', [ObjName]);
               except
                  On E:Exception do begin
                                       LuaError(L, ERR_Script+E.Message);
                                    end;
               end;
          end;
end;


procedure RegisterFunctions(L: Plua_State);
begin
     LuaRegister(L, 'CreateObject', Lua_CreateObject);
     LuaRegister(L, 'GetObject', Lua_GetObject);
end;

procedure RegisterClass(ObjClass :TClass; LuaClass :TLuaObjectClass=nil);
begin
     LuaClassesList.Add(ObjClass, LuaClass);
end;

procedure RegisterObject(Obj :TObject; Name :String; LuaClass :TLuaObjectClass=nil);
begin
     LuaExistingObjList.Add(Obj, Name);
     LuaClassesList.Add(Obj.ClassType, LuaClass);
end;

initialization
   LuaClassesList :=TLuaClassesList.Create;
   LuaExistingObjList :=TLuaExistingObjList.Create;

finalization
   LuaClassesList.Free;
   LuaExistingObjList.Free;

end.
