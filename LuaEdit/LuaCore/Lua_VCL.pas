// ATTENZIONE
// Obsoleta, lasciata per compatibilità finchè non si conclude Lua_Object etc...



//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2005                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//***                                                                        ***
//***  Unit : Lua_VCL.pas                                                    ***
//***                                                                        ***
//***     Functions to Get\Set Properties of a Component from Lua Scripts.   ***
//***     Register component that can be public using AddPublicComponent,    ***
//***     you can add as public "Application" but i think is not a good idea.***
//***                                                                        ***
//******************************************************************************
//  Exported functions :
//
//   GetVCLObject {Name=string}                           return TObject object.
//      TObject:GetProp(string PropName)       return Property Value as Variant.
//      TObject:SetProp(string PropName, variant Value)      set Property Value.
//
//   CreateVCLObject {ClassName=string}             Create a new TObject object. not yet implemented
//      TObject:Free()              Free a TObject created with CreateComponent. not yet implemented
//
//   GetProp(string FullPropName)              return Property Value as Variant.
//   SetProp(string FullPropName, variant Value)             set Property Value.


unit Lua_VCL;

interface

uses Lua, LuaUtils, Classes;

const
     LUAVCL_ACCESS_DENY  = 0;
     LUAVCL_ACCESS_READ  = 1;
     LUAVCL_ACCESS_WRITE = 2;
     LUAVCL_ACCESS_READWRITE = LUAVCL_ACCESS_READ or LUAVCL_ACCESS_WRITE;

type
    TLuaVCLAccess = Integer; //LUAVCL_ACCESS_XXXX Constants

procedure RegisterFunctions(L: Plua_State);
procedure AddPublicComponent(AComponent :TObject;
                             ALuaName :String;
                             AccessRights :TLuaVclAccess=LUAVCL_ACCESS_READ);
procedure DelPublicComponent(AComponent :TObject); overload;
procedure DelPublicComponent(ALuaName :String); overload;

procedure AddPublicProperty(AComponent :TObject; APropName :String;
                            ALuaName :String; AccessRights :TLuaVclAccess);
procedure DelPublicProperty(AComponent :TObject; APropName :String); overload;
procedure DelPublicProperty(ALuaName :String); overload;
function  GetPublicPropertyAccess(AComponent :TObject; APropName :String) :TLuaVCLAccess;
procedure SetPublicPropertyAccess(AComponent :TObject; APropName :String;
                                  AccessRights :TLuaVclAccess);


implementation

uses MGList, SysUtils, TypInfo;

const
     HandleVCLObjectStr = 'HandleVCLObject';
     ERR_Script         = 'Script Error : ';
     ERR_ACCESS_DENIED  = 'Access Denied Property %s.%s';
     ERR_UNKNOWN_OBJECT = 'Unknown VCLObject %s';
     ERR_UNKNOWN_PROP   = 'Unknown Property';


Type
    //Classe che mantiene la lista delle associazioni Lua->TObject
    TObjectNameData = record
        LuaName            :String;
        AccessRights       :TLuaVclAccess;
        Component          :TObject;
    end;
    PComponentNameData =^TObjectNameData;

    TObjectNameList = class(TMGList)
    protected
       function allocData :Pointer; override;
       procedure deallocData(pData :Pointer); override;

       function CompByComponent(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
       function CompByLuaName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
    public
       function Add(AComponent :TObject;
                    ALuaName :String; AccessRights :TLuaVclAccess) :PComponentNameData; overload;
       function Find(AComponent :TObject): Integer; overload;
       function ExtFind(AComponent :TObject): PComponentNameData; overload;
       procedure GetAccessRights(AComponent :TObject;
                                 var AccessRights: TLuaVclAccess);
       function Find(ALuaName :String): TObject; overload;
       function ExtFind(ALuaName :String): PComponentNameData; overload;
       function Delete(ALuaName :String) :Boolean; overload;
       function Delete(AComponent :TObject) :Boolean; overload;
    end;

    //Classe che mantiene la lista delle associazioni Lua-> (Component Property)
    TPropertyNameData = record
        LuaName            :String;
        AccessRights       :TLuaVclAccess;
        Component          :TObject;
        PropName           :String;
    end;
    PPropertyNameData =^TPropertyNameData;

    TPropertyNameList = class(TMGList)
    protected
       function allocData :Pointer; override;
       procedure deallocData(pData :Pointer); override;

       function CompByCompPropName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
       function CompByLuaName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
    public
       function Add(AComponent :TObject; APropName :String;
                    ALuaName :String; AccessRights :TLuaVclAccess) :PPropertyNameData; overload;
       function ExtFind(AComponent :TObject; APropName :String): PPropertyNameData; overload;
       function ExtFind(ALuaName :String): PPropertyNameData; overload;
       function Delete(ALuaName :String) :Boolean; overload;
       function Delete(AComponent :TObject; APropName :String) :Boolean; overload;
    end;


Var
   ComponentNameList : TObjectNameList =Nil;
   PropertyNameList  : TPropertyNameList  =Nil;

procedure ProcessDot(var xFullName, ChildName :String);
Var
   xPos :Integer;

begin
     xPos :=Pos('.', xFullName);
     if (xPos>0)
     then begin
               ChildName :=Copy(xFullName, 1, xPos-1);
               Delete(xFullname, 1, xPos);
          end
     else begin
               ChildName :=xFullName;
               xFullName :='';
          end;
end;

//==============================================================================
//  TObjectNameList Class
//==============================================================================

function TObjectNameList.allocData :Pointer;
begin
     GetMem(Result, SizeOf(TObjectNameData));
     FillChar(PComponentNameData(Result)^, SizeOf(TObjectNameData), 0);
     PComponentNameData(Result)^.LuaName :='';
end;

procedure TObjectNameList.deallocData(pData :Pointer);
begin
     PComponentNameData(pData)^.LuaName :='';
     FreeMem(pData, SizeOf(TObjectNameData));
end;

function TObjectNameList.CompByComponent(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := (TObject(ptData1)=PComponentNameData(ptData2)^.Component);
end;

function TObjectNameList.CompByLuaName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := (PChar(ptData1)=PComponentNameData(ptData2)^.LuaName);
end;

function TObjectNameList.Add(AComponent :TObject;
             ALuaName :String; AccessRights :TLuaVclAccess) :PComponentNameData;
begin
     if (ALuaName<>'')
     then Result :=ExtFind(ALuaName)
     else Result :=ExtFind(AComponent);
     if (Result=Nil)
     then Result :=Add;

     if (Result<>Nil)
     then begin
               Result^.Component :=AComponent;
               if (ALuaName<>'')
               then Result^.LuaName :=Uppercase(ALuaName);
               Result^.AccessRights :=AccessRights;
          end;
end;

function TObjectNameList.Find(AComponent :TObject): Integer;
begin
     Result :=Find(Pointer(AComponent), 0, CompByComponent);
end;

function TObjectNameList.ExtFind(AComponent :TObject): PComponentNameData;
begin
     if (AComponent<>Nil)
     then Result :=ExtFind(Pointer(AComponent), 0, CompByComponent)
     else Result :=Nil;
end;

function TObjectNameList.Find(ALuaName :String): TObject;
Var
   theComp :PComponentNameData;

begin
     Result := Nil;
     theComp := ExtFind(ALuaName);
     if (theComp<>Nil)
     then Result := theComp^.Component;
end;

function TObjectNameList.ExtFind(ALuaName :String): PComponentNameData;
begin
     Result :=ExtFind(PChar(Uppercase(ALuaName)), 0, CompByLuaName);
end;

function TObjectNameList.Delete(AComponent :TObject) :Boolean;
begin
     Result :=Delete(Pointer(AComponent), 0, CompByComponent);
end;

function TObjectNameList.Delete(ALuaName :String) :Boolean;
begin
     Result :=Delete(PChar(Uppercase(ALuaName)), 0, CompByLuaName);
end;

procedure TObjectNameList.GetAccessRights(AComponent :TObject;
                                          var AccessRights: TLuaVclAccess);
Var
   xCompAccess :PComponentNameData;

begin
     xCompAccess :=Self.ExtFind(AComponent);
     if (xCompAccess<>Nil)
     then AccessRights :=xCompAccess^.AccessRights;
end;

//==============================================================================
//  Components Registration\Deregistration
//==============================================================================

procedure AddPublicComponent(AComponent :TObject;
                             ALuaName :String;
                             AccessRights :TLuaVclAccess=LUAVCL_ACCESS_READ);
begin
     if (ComponentNameList=Nil)
     then ComponentNameList := TObjectNameList.Create;

     ComponentNameList.Add(AComponent, ALuaName, AccessRights);
end;

procedure DelPublicComponent(AComponent :TObject);
begin
     if (ComponentNameList<>Nil)
     then begin
               ComponentNameList.Delete(AComponent);
               if (ComponentNameList.Count=0)
               then begin
                         ComponentNameList.Free;
                         ComponentNameList :=Nil;
                    end;
          end;
end;

procedure DelPublicComponent(ALuaName :String); overload;
begin
     if (ComponentNameList<>Nil)
     then begin
               ComponentNameList.Delete(ALuaName);
               if (ComponentNameList.Count=0)
               then begin
                         ComponentNameList.Free;
                         ComponentNameList :=Nil;
                    end;
          end;
end;

//==============================================================================
//     TPropertyNameList Class
//==============================================================================

function TPropertyNameList.allocData :Pointer;
begin
     GetMem(Result, SizeOf(TPropertyNameData));
     FillChar(PPropertyNameData(Result)^, SizeOf(TPropertyNameData), 0);
     PPropertyNameData(Result)^.PropName :='';
     PPropertyNameData(Result)^.LuaName :='';
end;

procedure TPropertyNameList.deallocData(pData :Pointer);
begin
     PPropertyNameData(pData)^.PropName :='';
     PPropertyNameData(pData)^.LuaName :='';
     FreeMem(pData, SizeOf(TPropertyNameData));
end;

function TPropertyNameList.CompByCompPropName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := (PPropertyNameData(ptData1)^.Component=PPropertyNameData(ptData2)^.Component) and
               (PPropertyNameData(ptData1)^.PropName=PPropertyNameData(ptData2)^.PropName);
end;

function TPropertyNameList.CompByLuaName(Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := (PChar(ptData1)=PPropertyNameData(ptData2)^.LuaName);
end;

function TPropertyNameList.Add(AComponent :TObject; APropName :String;
                    ALuaName :String; AccessRights :TLuaVclAccess) :PPropertyNameData;
begin
     Result :=ExtFind(AComponent, APropName);
     if (Result=Nil)
     then Result :=Add;

     if (Result<>Nil)
     then begin
               Result^.Component :=AComponent;
               Result^.PropName :=Uppercase(APropName);
               Result^.LuaName :=Uppercase(ALuaName);
               Result^.AccessRights :=AccessRights;
          end;
end;

function TPropertyNameList.ExtFind(AComponent :TObject; APropName :String): PPropertyNameData;
Var
   aux :PPropertyNameData;

begin
     if (AComponent<>Nil)
     then begin
               aux :=allocData;
               aux^.Component :=AComponent;
               aux^.PropName :=Uppercase(APropName);

               Result :=ExtFind(aux, 0, CompByCompPropName);

               deallocData(aux);
          end
     else Result :=Nil;
end;

function TPropertyNameList.ExtFind(ALuaName :String): PPropertyNameData;
begin
     Result :=ExtFind(PChar(Uppercase(ALuaName)), 0, CompByLuaName);
end;

function TPropertyNameList.Delete(ALuaName :String) :Boolean;
begin
     Result :=Delete(PChar(Uppercase(ALuaName)), 0, CompByLuaName);
end;

function TPropertyNameList.Delete(AComponent :TObject; APropName :String) :Boolean;
Var
   aux :PPropertyNameData;

begin
     aux :=allocData;
     aux^.Component :=AComponent;
     aux^.PropName :=Uppercase(APropName);

     Result :=Delete(aux, 0, CompByCompPropName);

     deallocData(aux);
end;

//==============================================================================
//  Properties Registration\Deregistration, AccessRights
//==============================================================================

procedure AddPublicProperty(AComponent :TObject; APropName :String;
                            ALuaName :String; AccessRights :TLuaVclAccess);
begin
     if (PropertyNameList=Nil)
     then PropertyNameList := TPropertyNameList.Create;
     PropertyNameList.Add(AComponent, APropName, ALuaName, AccessRights);
end;

procedure DelPublicProperty(AComponent :TObject; APropName :String); overload;
begin
     if (PropertyNameList<>Nil)
     then begin
               PropertyNameList.Delete(AComponent, APropName);
               if (PropertyNameList.Count=0)
               then begin
                         PropertyNameList.Free;
                         PropertyNameList :=Nil;
                    end;
          end;
end;

procedure DelPublicProperty(ALuaName :String); overload;
begin
     if (PropertyNameList<>Nil)
     then begin
               PropertyNameList.Delete(ALuaName);
               if (PropertyNameList.Count=0)
               then begin
                         PropertyNameList.Free;
                         PropertyNameList :=Nil;
                    end;
          end;
end;

function  GetPublicPropertyAccess(AComponent :TObject; APropName :String) :TLuaVCLAccess;
Var
   xProp :PPropertyNameData;
   xComp :PComponentNameData;

begin
     Result :=LUAVCL_ACCESS_DENY;
     xProp :=Nil;
     if (AComponent=Nil)
     then Exit;

     //Find Property AccessRights for this property
     if (APropName<>'') and (PropertyNameList<>Nil)
     then begin
               xProp :=PropertyNameList.ExtFind(AComponent, APropName);
               if (xProp<>Nil)
               then Result :=xProp^.AccessRights;
          end;
     if (xProp=Nil) and (ComponentNameList<>Nil)
     then begin
               //If not Find Property AccessRights for this property, Try with it's component
               xComp :=ComponentNameList.ExtFind(AComponent);
               if (xComp<>Nil)
               then Result :=xComp^.AccessRights;
          end;
end;

procedure SetPublicPropertyAccess(AComponent :TObject; APropName :String;
                                  AccessRights :TLuaVclAccess);
begin
     AddPublicProperty(AComponent, APropName, APropName, AccessRights);
end;


//==============================================================================
//  Lua Interface  : Components Property
//==============================================================================

function GetComponentByFullPath(FullCompName: String;
                                var AccessRights :TLuaVCLAccess):TObject;
Var
   xNewParent  :TObject;
   xParent     :TObject;
   xFullName,
   ChildName   :String;
   xCompAccess :PComponentNameData;

begin
     xFullName :=FullCompName;
     AccessRights :=LUAVCL_ACCESS_DENY;

     ProcessDot(xFullName, ChildName);
     xCompAccess :=ComponentNameList.ExtFind(ChildName);
     if (xCompAccess<>Nil)
     then begin
               xParent :=xCompAccess^.Component;
               AccessRights :=xCompAccess^.AccessRights;
           end
     else xParent :=Nil;

     while (xParent<>Nil) and (xFullName<>'') do
     begin
       try
          xNewParent :=Nil;
          ProcessDot(xFullName, ChildName);

          //Try find in Components
          if (xParent is TComponent)
          then xNewParent :=TComponent(xParent).FindComponent(ChildName);
          if (xNewParent=Nil)
          then begin  //Try find in Class Properties
                    if (PropType(xParent, ChildName)=tkClass)
                    then xNewParent :=TObject(GetOrdProp(xParent, ChildName));
               end;

          xCompAccess :=ComponentNameList.ExtFind(xNewParent);
          if (xCompAccess<>Nil)
          then AccessRights :=xCompAccess^.AccessRights;

          xParent :=xNewParent;
        except
           xParent :=Nil;
        end;
     end;
     Result :=xParent;
end;

function GetPropertyByFullPath(FullPropName: String;
                       var ResultComponent :TObject;
                       var AccessRights    :TLuaVCLAccess):String;
Var
   xNewParent  :TObject;
   xPropType   :TTypeKind;
   xFullName,
   ChildName   :String;
   xCompAccess :PComponentNameData;
   xPropAccess :PPropertyNameData;

begin
     Result :='';
     xFullName :=FullPropName;
     xPropType :=tkUnknown;

     if (ResultComponent=Nil)
     then begin
               //No Parent Object specified, Find from Name
               ProcessDot(xFullName, ChildName);
               xCompAccess :=ComponentNameList.ExtFind(ChildName);
               if (xCompAccess<>Nil)
               then begin
                         ResultComponent :=xCompAccess^.Component; //Convert possible Alias
                         if (ResultComponent<>Nil)
                         then xPropType :=tkClass;
                         AccessRights :=xCompAccess^.AccessRights;
                    end;
          end
     else xPropType :=tkClass; //If Parent specified AccessRights is controlled by GetVCLObject

     while (ResultComponent<>Nil) and (xPropType=tkClass) do
     begin
        try
          xNewParent :=Nil;
          ProcessDot(xFullName, ChildName);

          //Try find in Components
          if (ResultComponent is TComponent)
          then begin
                    xNewParent :=TComponent(ResultComponent).FindComponent(ChildName);
                    if (xNewParent<>Nil)
                    then xPropType :=tkClass;
               end;
          if (xNewParent=Nil)
          then begin  //Try find in Class Properties
                    xPropType :=PropType(ResultComponent, ChildName);
                    if (xPropType=tkClass)
                    then xNewParent :=TObject(GetOrdProp(ResultComponent, ChildName));
               end;

          if (xPropType=tkClass)
          then begin
                    //Search if exists AccessRights for this Class
                    xCompAccess :=ComponentNameList.ExtFind(xNewParent);
                    if (xCompAccess<>Nil)
                    then AccessRights :=xCompAccess^.AccessRights;

                    ResultComponent :=xNewParent;
               end;
        except
           ResultComponent :=Nil;
        end;
     end;
     if (ResultComponent<>Nil) and (xPropType<>tkClass) and (Pos('.', ChildName)=0)
     then begin
               Result :=ChildName;

               //Get Property AccessRights if Any
               xPropAccess :=PropertyNameList.ExtFind(ResultComponent, ChildName);
               if (xPropAccess<>Nil)
               then AccessRights :=xPropAccess^.AccessRights;
          end
     else begin
               Result :='';
               ResultComponent :=Nil;
          end;
end;


function LuaToTObject(L: Plua_State; Index: Integer): TObject;
begin
     try
        Result :=TObject(LuaGetTableLightUserData(L, Index, HandleVCLObjectStr));
     except
        Result :=Nil;
     end;
end;

function LuaToPropertyName(L: Plua_State;
                       var Index: Integer;
                       var ResultComponent :TObject;
                       var AccessRights    :TLuaVCLAccess):String;
begin
     Result :='';
     ResultComponent :=Nil;
     AccessRights :=LUAVCL_ACCESS_DENY;
     Index :=1;

     if lua_istable(L, Index)
     then begin
               //The First parameter is a TObject Table,
               //  Property specified in the 2nd parameter start from this Class
               ResultComponent := LuaToTObject(L, Index);
               ComponentNameList.GetAccessRights(ResultComponent, AccessRights);
               Inc(Index);     //Property is the 2nd parameter
               if (ResultComponent=Nil) or
                  (AccessRights=LUAVCL_ACCESS_DENY)
               then Exit;      //Invalid Object or no Access
          end;

     if (lua_isString(L, Index)<>0)
     then begin
               Result := GetPropertyByFullPath(LuaToString(L, Index),
                                               ResultComponent,
                                               AccessRights);
               Inc(Index);
          end;
end;

//      TObject:GetProp(string PropName)       return Property Value as Variant.
//   GetProp(string FullPropName)              return Property Value as Variant.
function LuaGetProp(L: Plua_State): Integer; cdecl;
Var
   curComponent :TObject;
   PropName     :String;
   PropValue    :Variant;
   PropRights   :TLuaVCLAccess;
   Index        :Integer;

begin
     Result := 1;

     try
        PropName  := LuaToPropertyName(L, Index, curComponent, PropRights);
        if (PropName='') or (curComponent=Nil)
        then raise Exception.Create(ERR_UNKNOWN_PROP);

        if ((PropRights and LUAVCL_ACCESS_READ)<>0)
        then begin
                  PropValue :=GetPropValue(curComponent, PropName);
                  LuaPushVariant(L, PropValue);
             end
        else raise Exception.CreateFmt(ERR_ACCESS_DENIED, [curComponent.ClassName, PropName]);
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                               Result :=0;
                          end;

     end;
end;

//      TObject:SetProp(string PropName, variant Value)      set Property Value.
//   SetProp(string FullPropName, variant Value)             set Property Value.
function LuaSetProp(L: Plua_State): Integer; cdecl;
Var
   curComponent :TObject;
   PropName     :String;
   PropValue    :Variant;
   PropRights   :TLuaVCLAccess;
   Index        :Integer;

begin
     Result := 0;

     try
        PropName  := LuaToPropertyName(L, Index, curComponent, PropRights);
        if (PropName='') or (curComponent=Nil)
        then raise Exception.Create(ERR_UNKNOWN_PROP);

        if ((PropRights and LUAVCL_ACCESS_WRITE)<>0)
        then begin
                  PropValue :=LuaToVariant(L, Index);
                  SetPropValue(curComponent, PropName, PropValue);
             end
        else raise Exception.CreateFmt(ERR_ACCESS_DENIED, [curComponent.ClassName, PropName]);
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                               Result :=0;
                          end;
     end;
end;

function LuaGetVCLObject(L: Plua_State): Integer; cdecl;
Var
   ComponentName :String;
   xResult       :TObject;
   AccessRights  :TLuaVCLAccess;

begin
     Result := 1;

     try
        ComponentName :=LuaGetTableString(L, 1, 'Name');
        LuaSetTableNil(L, 1, 'Name');
        xResult := GetComponentByFullPath(ComponentName, AccessRights);
        if (xResult=Nil) or (AccessRights=0)
        then raise Exception.CreateFmt(ERR_UNKNOWN_OBJECT, [ComponentName]);

        LuaSetTableLightUserData(L, 1, HandleVCLObjectStr, xResult);
        LuaSetTableFunction(L, 1, 'GetProp', LuaGetProp);
        LuaSetTableFunction(L, 1, 'SetProp', LuaSetProp);
     except
        On E:Exception do begin
                               LuaError(L, ERR_Script+E.Message);
                               Result :=0;
                          end;

     end;
end;

procedure RegisterFunctions(L: plua_State);
begin
     LuaRegister(L, 'GetVCLObject', LuaGetVCLObject);
     LuaRegister(L, 'GetProp', LuaGetProp);
     LuaRegister(L, 'SetProp', LuaSetProp);
end;

end.
