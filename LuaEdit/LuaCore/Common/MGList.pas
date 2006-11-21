//******************************************************************************
//***                     COMMON DELPHI FUNCTIONS                            ***
//***                                                                        ***
//***    (c) Beppe Grimaldi, Massimo Magnano 11-11-2004.                     ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : MGList.pas      REV. 1.6   (13-09-2006)
//
//  Description : Implementation of an Optimazed and Polimorphic List.
//
//******************************************************************************

unit MGList;

interface

Type
  PDataExt = ^TDataExt;
  TDataExt = record
     Data         :Pointer;
     Prev         :PDataExt;
     Next         :PDataExt;
  end;

  //I Tag sono necessari xche' Non posso leggere le variabili che stanno nello Stack
  //quindi devo passare le variabile necessarie alle funzioni locali così
  TLocalCompareFunction = function (Tag :Integer; ptData1, ptData2 :Pointer) :Boolean;
  TLocalWalkFunction = procedure (Tag :Integer; ptData :Pointer);
  TObjCompareFunction = function (Tag :Integer; ptData1, ptData2 :Pointer) :Boolean of object;
  PObjCompareFunction = ^TObjCompareFunction;
  TObjWalkFunction = procedure (Tag :Integer; ptData :Pointer) of object;


  TMGList = class
    protected
        rListInit,
        rListEnd,
        rCurrent     :PDataExt;
        rCount       :Integer;

        function Get(Index: Integer): Pointer;
        function InternalDelete(Item :PDataExt) :PDataExt; overload;
        function InternalFind(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=nil) :PDataExt; virtual;
        function PutInRightPosition(newElem :PDataExt; ATag :Integer; CompareFunction : TLocalCompareFunction=nil) :Integer; overload; virtual;
        function PutInRightPosition(newElem :PDataExt; ATag :Integer; CompareFunction : TObjCompareFunction) :Integer; overload; virtual;
        function allocData :Pointer; virtual;
        procedure deallocData(pData :Pointer); virtual;
        function RefreshOK(pData :Pointer) : Boolean; virtual;
    public
        constructor Create; virtual;
        destructor Destroy; override;

        function Find(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=nil): Integer; overload;
        function Find(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction): Integer; overload;
        function Find(const Args: array of Variant): Pointer; overload; virtual;
        function ExtFind(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=nil): Pointer; overload;
        function ExtFind(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction): Pointer; overload;
        procedure Walk(ATag :Integer; WalkFunction : TLocalWalkFunction); overload;
        procedure Walk(ATag :Integer; WalkFunction : TObjWalkFunction); overload;
        procedure WalkAndRefresh(ATag :Integer; WalkFunction : TLocalWalkFunction); overload;
        procedure WalkAndRefresh(ATag :Integer; WalkFunction : TObjWalkFunction); overload;

        function Add :Pointer; overload;
        function Insert(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=nil) :Integer; overload;
        function Insert(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction) :Integer; overload;
        function Delete(Index :Integer) :Boolean; overload;
        function Delete(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=Nil) :Boolean; overload;
        function Delete(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction) :Boolean; overload;
        procedure Exchange(pData1, pData2 :Pointer); overload; virtual;

        procedure Clear;
        procedure Refresh;

        function FindFirst: Pointer; virtual;
        function FindNext : Pointer; virtual;
        function GetCurrent : Pointer; virtual;
        function GetData(DataPointer :Pointer; DataName :String) :Variant; virtual;
        function DeleteCurrent :Boolean;
        procedure FindClose; virtual;

        property Count :Integer read rCount;
        property Items [Index :Integer] :Pointer read Get;
  end;

  TMGListClass = class of TMGList;


  TMGObjectWithCreate = class(TObject)
  public
     constructor Create(dummy :Boolean); virtual;
  end;

  TObjectWCClass = class of TMGObjectWithCreate;

  TMGObject_List = class(TMGList)
  protected
       function allocData :Pointer; override;
       procedure deallocData(pData :Pointer); override;
       function GetObjectClass :TObjectWCClass; virtual; abstract;
  end;

  TMGList_List = class(TMGList)
  protected
       function allocData :Pointer; override;
       procedure deallocData(pData :Pointer); override;
       function GetObjectClass :TMGListClass; virtual; abstract;
  end;


implementation

Type
    TLocalToObjData_Compare = record
        Tag  :Integer;
        Func :TObjCompareFunction;
    end;
    PLocalToObjData_Compare = ^TLocalToObjData_Compare;

    TLocalToObjData_Walk = record
        Tag  :Integer;
        Func :TObjWalkFunction;
    end;
    PLocalToObjData_Walk = ^TLocalToObjData_Walk;


function _localToObj_Compare(xTag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := PLocalToObjData_Compare(xTag).Func(
                                     PLocalToObjData_Compare(xTag).Tag,
                                     ptData1, ptData2);
end;

procedure _localToObj_Walk(xTag :Integer; ptData :Pointer);
begin
     PLocalToObjData_Walk(xTag).Func(PLocalToObjData_Walk(xTag).Tag, ptData);
end;

function AllocData_Compare(Tag :Integer; Func :TObjCompareFunction) :PLocalToObjData_Compare;
begin
     GetMem(Result, sizeOf(TLocalToObjData_Compare));
     Result^.Tag :=Tag;
     Result^.Func :=Func;
end;

function AllocData_Walk(Tag :Integer; Func :TObjWalkFunction) :PLocalToObjData_Walk;
begin
     GetMem(Result, sizeOf(TLocalToObjData_Walk));
     Result^.Tag :=Tag;
     Result^.Func :=Func;
end;

function CompByData(xTag :Integer; ptData1, ptData2 :Pointer) :Boolean;
begin
     Result := (ptData1 = ptData2);
end;



// =============================================================================

constructor TMGList.Create;
begin
   rCount := 0;
   rListInit := Nil;
   rListEnd := Nil;
   rCurrent := Nil;
end;

destructor TMGList.Destroy;
begin
   Clear;
end;

function TMGList.allocData :Pointer;
begin
     Result :=Nil;
end;

procedure TMGList.deallocData(pData :Pointer);
begin
end;

function TMGList.RefreshOK(pData :Pointer) : Boolean;
begin
     Result :=True;
end;

procedure TMGList.Clear;
var
   pIndex :PDataExt;
begin
   while (rListInit <> Nil) do
     begin
        pIndex := rListInit;
        rListInit := rListInit^.Next;
        deallocData(pIndex^.Data);
        Dispose(pIndex);
     end;
   rListInit := Nil;
   rListEnd := Nil;
   rCount := 0;
end;

procedure TMGList.Refresh;
var
   pIndex :PDataExt;
begin
   pIndex := rListInit;
   while (pIndex <> Nil) do
     begin
        if RefreshOK(pIndex^.Data)
          then pIndex := pIndex^.Next
          else begin
                  if (pIndex^.Next = Nil)  // se è l'ultimo elemento..
                    then rListEnd := pIndex^.Prev;
                  pIndex := InternalDelete(pIndex);
               end;
     end;
end;

function TMGList.FindFirst: Pointer;
begin
     if (rCurrent=Nil)
      then begin
                rCurrent :=rListInit;
                Result :=GetCurrent;
           end
      else Result :=Nil;
end;

function TMGList.FindNext : Pointer;
begin
     if (rCurrent<>Nil)
      then begin
                rCurrent :=rCurrent^.Next;
                Result :=GetCurrent;
           end
      else Result :=Nil;
end;

function TMGList.GetCurrent : Pointer;
begin
     if (rCurrent=Nil)
     then Result :=Nil
     else Result :=rCurrent^.Data;
end;

function TMGList.GetData(DataPointer :Pointer; DataName :String) :Variant;
begin
     Result :=Variant(Integer(DataPointer));
end;

function TMGList.DeleteCurrent :Boolean;
begin
   Result := False;
   if (rCurrent <> Nil) then
     begin
        rCurrent := InternalDelete(rCurrent);
        Result := True;
     end;
end;

procedure TMGList.FindClose;
begin
     rCurrent :=Nil;
end;

function TMGList.Get(Index: Integer): Pointer;
var
   I :Integer;
   pIndex :PDataExt;

begin
   Result := Nil;
   if ((Index >= 0) and (Index < rCount)) then
     begin
        pIndex := rListInit;
        for i:=0 to Index-1 do
          pIndex := pIndex^.Next;
        Result := pIndex^.Data;
     end;
end;

function TMGList.Find(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=nil): Integer;
var
   i :Integer;
   Found :Boolean;
   pIndex :PDataExt;

begin
   if not(Assigned(CompareFunction))
   then CompareFunction :=CompByData;

   Result := -1;
   i := 0;
   Found := False;
   pIndex := rListInit;
   while ((i < rCount) and not Found) do
     if CompareFunction(ATag, pData, pIndex^.Data)
       then begin
               Result := i;
               Found := True;
            end
       else begin
               Inc(i);
               pIndex := pIndex^.Next;
            end;
end;

function TMGList.Find(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction): Integer;
Var
  auxPointer :PLocalToObjData_Compare;

begin
     auxPointer :=AllocData_Compare(ATag, CompareFunction);
     Result := Find(pData, Integer(auxPointer), _LocalToObj_Compare);
     FreeMem(auxPointer);
end;

function TMGList.Find(const Args: array of Variant): Pointer;
begin
     Result :=Nil;
end;

function TMGList.ExtFind(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=nil): Pointer;
var
   Found  :Boolean;
   pIndex :PDataExt;

begin
   if not(Assigned(CompareFunction))
   then CompareFunction :=CompByData;

   Result := Nil;
   Found := False;
   pIndex := rListInit;
   while ((pIndex <> Nil) and not Found) do
     if CompareFunction(ATag, pData, pIndex^.Data)
       then begin
               Result := pIndex^.Data;
               Found := True;
            end
       else pIndex := pIndex^.Next;
end;


function TMGList.ExtFind(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction): Pointer;
Var
  auxPointer :PLocalToObjData_Compare;

begin
     auxPointer :=AllocData_Compare(ATag, CompareFunction);
     Result := ExtFind(pData, Integer(auxPointer), _LocalToObj_Compare);
     FreeMem(auxPointer);
end;

procedure TMGList.Walk(ATag :Integer; WalkFunction : TLocalWalkFunction);
var
   pIndex :PDataExt;

begin
     pIndex := rListInit;
     while (pIndex <> Nil) do
     begin
          WalkFunction(ATag, pIndex^.Data);
          pIndex := pIndex^.Next;
     end;
end;

procedure TMGList.Walk(ATag :Integer; WalkFunction : TObjWalkFunction);
Var
  auxPointer :PLocalToObjData_Walk;

begin
     auxPointer :=AllocData_Walk(ATag, WalkFunction);
     Walk(Integer(auxPointer), _LocalToObj_Walk);
     FreeMem(auxPointer);
end;

procedure TMGList.WalkAndRefresh(ATag :Integer; WalkFunction : TLocalWalkFunction);
var
   pIndex :PDataExt;

begin
     pIndex := rListInit;
     while (pIndex <> Nil) do
     begin
          if RefreshOk(pIndex^.Data)
          then begin
                    WalkFunction(ATag, pIndex^.Data);
                    pIndex := pIndex^.Next;
               end
          else begin
                  if (pIndex^.Next = Nil)  // se è l'ultimo elemento..
                    then rListEnd := pIndex^.Prev;
                  pIndex := InternalDelete(pIndex);
               end;
     end;
end;

procedure TMGList.WalkAndRefresh(ATag :Integer; WalkFunction : TObjWalkFunction);
Var
  auxPointer :PLocalToObjData_Walk;

begin
     auxPointer :=AllocData_Walk(ATag, WalkFunction);
     WalkAndRefresh(Integer(auxPointer), _LocalToObj_Walk);
     FreeMem(auxPointer);
end;


function TMGList.Add :Pointer;
var
   newElem :PDataExt;

begin
   new(newElem);
   fillchar(newElem^, sizeof(TDataExt), 0);
   newElem^.Data := allocData;

   if (rListEnd = Nil)
     then begin
             rListInit := newElem;
             rListEnd := newElem;
          end
     else begin
             rListEnd^.Next := newElem;
             newElem^.Prev := rListEnd;
             rListEnd := newElem;
          end;
   Inc(rCount);
   Result := newElem^.Data;
end;

function TMGList.PutInRightPosition(newElem :PDataExt; ATag :Integer; CompareFunction : TLocalCompareFunction) :Integer;
var
   Found   :Boolean;
   pIndex  :PDataExt;

begin
   if not(Assigned(CompareFunction))
   then CompareFunction :=CompByData;

   Result := 0;
   if (rListInit = Nil)
     then begin
             rListInit := newElem;
             rListEnd := newElem;
          end
     else begin
             Found := False;
             pIndex := rListInit;
             repeat
               if CompareFunction(ATag, newElem^.Data, pIndex^.Data)
                 then begin
                         // uso 'newElem^.Prev' per conservare il puntatore al record precedente..
                         newElem^.Prev := pIndex;
                         pIndex := pIndex^.Next;
                      end
                 else Found := True;
               Inc(Result);
             until ((pIndex = Nil) or Found);

             if (newElem^.Prev = Nil)  // inserisco in prima posizione..
               then rListInit := newElem
               else newElem^.Prev^.Next := newElem;
             newElem^.Next := pIndex;
             if (pIndex <> Nil)
               then pIndex^.Prev := newElem
               else rListEnd := newElem;  // inserisco in ultima posizione..
          end;
end;

function TMGList.PutInRightPosition(newElem :PDataExt; ATag :Integer; CompareFunction : TObjCompareFunction) :Integer;
Var
  auxPointer :PLocalToObjData_Compare;

begin
     auxPointer :=AllocData_Compare(ATag, CompareFunction);
     Result := PutInRightPosition(newElem, Integer(auxPointer), _LocalToObj_Compare);
     FreeMem(auxPointer);
end;

function TMGList.Insert(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=Nil) :Integer;
var
   newElem :PDataExt;
   
begin
   if not(Assigned(CompareFunction))
   then CompareFunction :=CompByData;

   new(newElem);
   fillchar(newElem^, sizeof(TDataExt), 0);
   newElem^.Data :=pData;

   Result := PutInRightPosition(pData, ATag, CompareFunction);
   Inc(rCount);
end;

function TMGList.Insert(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction) :Integer;
Var
  auxPointer :PLocalToObjData_Compare;

begin
     auxPointer :=AllocData_Compare(ATag, CompareFunction);
     Result := Insert(pData, Integer(auxPointer), _LocalToObj_Compare);
     FreeMem(auxPointer);
end;


function TMGList.Delete(Index :Integer) :Boolean;
var
   i      :Integer;
   pIndex :PDataExt;

begin
   Result := False;
   if ((Index >= 0) and (Index < rCount)) then
     begin
        pIndex := rListInit;
        for i:=0 to Index-1 do
          pIndex := pIndex^.Next;

        if (pIndex = Nil)
          then InternalDelete(rListEnd)
          else InternalDelete(pIndex);

        Result := True;
     end;
end;

function TMGList.Delete(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=Nil) :Boolean;
Var
   toDel :PDataExt;

begin
     if not(Assigned(CompareFunction))
     then CompareFunction :=CompByData;

     toDel := InternalFind(pData, ATag, CompareFunction);
     Result := (toDel<>Nil);
     if Result
     then InternalDelete(toDel);
end;

function TMGList.Delete(pData :Pointer; ATag :Integer; CompareFunction : TObjCompareFunction) :Boolean;
Var
  auxPointer :PLocalToObjData_Compare;

begin
     auxPointer :=AllocData_Compare(ATag, CompareFunction);
     Result := Delete(pData, Integer(auxPointer), _LocalToObj_Compare);
     FreeMem(auxPointer);
end;

procedure TMGList.Exchange(pData1, pData2 :Pointer);
var
   pIndex,
   pIndexData1,
   pIndexData2  :PDataExt;
   xData        :Pointer;


begin
   pIndex := rListInit;
   pIndexData1 :=Nil;
   pIndexData2 :=Nil;
   while ((pIndex <> Nil) and ((pIndexData1=Nil) or (pIndexData2=Nil))) do
   begin
        if (pIndex^.Data=pData1)
        then pIndexData1 :=pIndex
        else if (pIndex^.Data=pData2)
             then pIndexData2 :=pIndex;

        pIndex := pIndex^.Next;
   end;

   if ((pIndexData1<>Nil) and (pIndexData2<>Nil)) then
   begin
        xData := pIndexData1^.Data;
        pIndexData1^.Data := pIndexData2^.Data;
        pIndexData2^.Data := xData;
   end;
end;


function TMGList.InternalDelete(Item :PDataExt) :PDataExt;
var
   P :PDataExt;
begin
   Result := Nil;
   P := PDataExt(Item);
   if (P <> Nil) then
     begin
        if (P^.Prev <> Nil)
          then P^.Prev^.Next := P^.Next
          else rListInit := P^.Next;
        if (P^.Next <> Nil)
          then P^.Next^.Prev := P^.Prev
          else rListEnd := P^.Prev;  // sto cancellando l'ultimo elemento..

        Result := P^.Prev;
        deallocData(P^.Data);
        Dispose(P);
        Dec(rCount);
     end;
end;


function TMGList.InternalFind(pData :Pointer; ATag :Integer; CompareFunction : TLocalCompareFunction=nil) :PDataExt;
var
   Found  :Boolean;
   pIndex :PDataExt;

begin
   if not(Assigned(CompareFunction))
   then CompareFunction :=CompByData;

   Result := Nil;
   Found := False;
   pIndex := rListInit;
   while ((pIndex <> Nil) and not Found) do
     if CompareFunction(ATag, pData, pIndex^.Data)
       then begin
               Result := pIndex;
               Found := True;
            end
       else pIndex := pIndex^.Next;
end;

//==============================================================================
//  TMGObject_List = class(TMGList)

constructor TMGObjectWithCreate.Create(dummy :Boolean);
begin
     inherited Create;
end;

function TMGObject_List.allocData :Pointer;
begin
     Result :=GetObjectClass.Create(true); //Why Tobject.Create is not virtual???
end;

procedure TMGObject_List.deallocData(pData :Pointer);
begin
     TObject(pData).Free;
end;

//==============================================================================
//  TMGList_List = class(TMGList)

function TMGList_List.allocData :Pointer;
begin
     Result :=GetObjectClass.Create;
end;

procedure TMGList_List.deallocData(pData :Pointer);
begin
     TMGList(pData).Free;
end;


end.
