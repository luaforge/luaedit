//******************************************************************************
//***                     LUA SCRIPT FUNCTIONS                               ***
//***                                                                        ***
//***        (c) Massimo Magnano 2006                                        ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : Lua_Classes.pas   (rev. 1.0)
//
//  Description : Access from Lua scripts to Class declared in "Classes.pas"
//
//******************************************************************************
unit Lua_Classes;

interface

uses TypInfo, Variants, Lua_Object;

type
    TLuaComponent = class(TLuaObject)
    protected
       class function GetPublicPropertyAccessClass :TClass; override;
       
    public
                                  //TClass         TComponent TComponent
       function LuaCreate(ObjClass :Integer; AOwner :Integer) :Integer; overload;

       function GetArrayPropType(Name :String; index :Variant) :PTypeInfo; override;
       function GetArrayProp(Name :String; index :Variant) :Variant; override;
       function GetElementType(Name :String) :PTypeInfo; override;
       function GetElement(Name :String) :Variant; override;
    end;


implementation

uses Classes, SysUtils, StdCtrls;

type
    TComponentAccess = class(TComponent)
    published
       property ComponentIndex;
       property ComponentCount;
    end;


function TLuaComponent.LuaCreate(ObjClass :Integer; AOwner :Integer) :Integer;
Var
   xObjClass :TClass;

begin
     xObjClass :=TClass(ObjClass);
     if (xObjClass.InheritsFrom(TComponent))
     then Result :=Integer(TComponentClass(xObjClass).Create(TComponent(AOwner)))
     else Result :=Integer(TComponent(LuaCreate(ObjClass)));
end;

function TLuaComponent.GetArrayPropType(Name :String; index :Variant) :PTypeInfo;
begin
     Name :=Uppercase(Name);
     Result :=nil;

     if (Name='COMPONENTS')
     then begin
               if (TComponent(InstanceObj).Components[index]<>nil)
               then Result :=TypeInfo(TComponent)
               else Result :=nil;
          end;
end;

function TLuaComponent.GetArrayProp(Name :String; index :Variant) :Variant;
begin
     Name :=Uppercase(Name);
     Result :=NULL;

     if (Name='COMPONENTS')
     then begin
               if (TComponent(InstanceObj).Components[index]<>nil)
               then Result :=Integer(TComponent(InstanceObj).Components[index]);
          end;
end;

function TLuaComponent.GetElementType(Name :String) :PTypeInfo;
Var
   upName :String;

begin
     upName :=Uppercase(Name);
     Result :=nil;

     if (upName='COMPONENTS')
     then Result :=@TypeInfoArray
     else
     if (TComponent(InstanceObj).FindComponent(Name)<>nil)
     then Result :=TypeInfo(TComponent);
end;

function TLuaComponent.GetElement(Name :String) :Variant;
Var
   theComponent :TComponent;

begin
     Result :=NULL;

     theComponent :=TComponent(InstanceObj).FindComponent(Name);
     if (theComponent<>nil)
     then Result :=Integer(theComponent);
end;

class function TLuaComponent.GetPublicPropertyAccessClass :TClass;
begin
     Result :=TComponentAccess;
end;


initialization
   Lua_Object.RegisterClass(TComponent, TLuaComponent);

end.
