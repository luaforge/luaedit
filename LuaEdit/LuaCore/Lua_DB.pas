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
//      TDataset:FindField(string FieldName)             return Field as TField.


unit Lua_DB;

interface

uses Lua;

procedure RegisterFunctions(L: Plua_State);


implementation

uses Classes, SysUtils, LuaUtils, Lua_Object, Lua_Classes,
     DB, DBTables, BDE, TypInfo, Variants;

type
//  TComponent <- TDataset <- TBDEDataSet <- TDBDataSet <- TTable
//                                                      <- TQuery
//  -------------------------------------------------------------
//  TLuaComponent <- TLuaDataset <- TLuaBDEDataSet <- TLuaDBDataSet <- TLuaTable
//                                                                  <- TLuaQuery
//==============================================================================
    TLuaDataset = class (TLuaComponent)
    protected
       class function GetPublicPropertyAccessClass :TClass; override;

    public
       function GetArrayPropType(Name :String; index :Variant) :PTypeInfo; override;
       function GetArrayProp(Name :String; index :Variant) :Variant; override;

    function ActiveBuffer: String;
    procedure Append;
    procedure AppendRecord(const Values: array of const);
    function BookmarkValid(Bookmark: TBookmark): Boolean;
    procedure Cancel;
    procedure CheckBrowseMode;
    procedure ClearFields;
    procedure Close;
    function  ControlsDisabled: Boolean;
    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
    procedure CursorPosChanged;
    procedure Delete;
    procedure DisableControls;
    procedure Edit;
    procedure EnableControls;
    function FieldByName(const FieldName: string): TField;
    function FindField(const FieldName: string): TField;
    function FindFirst: Boolean;
    function FindLast: Boolean;
    function FindNext: Boolean;
    function FindPrior: Boolean;
    procedure First;
    procedure FreeBookmark(Bookmark: TBookmark);
    function GetBookmark: TBookmark;
    function GetCurrentRecord(Buffer: String): Boolean;
    procedure GetDetailDataSets(List: TList);
    procedure GetDetailLinkFields(MasterFields, DetailFields: TList);
    function GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer;
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload;
    function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload;
    function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; overload;
    procedure GetFieldList(List: TList; const FieldNames: string);
    procedure GetFieldNames(List: TStrings);
    procedure GotoBookmark(Bookmark: TBookmark);
    procedure Insert;
    procedure InsertRecord(const Values: array of const);
    function IsEmpty: Boolean;
    function IsLinkedTo(DataSource: TDataSource): Boolean;
    function IsSequenced: Boolean;
    procedure Last;
    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean;
    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant;
    function MoveBy(Distance: Integer): Integer;
    procedure Next;
    procedure Open;
    procedure Post;
    procedure Prior;
    procedure Refresh;
    procedure Resync(Mode: TResyncMode);
    procedure SetFields(const Values: array of const);
    function Translate(Src, Dest: String; ToOem: Boolean): Integer;
    procedure UpdateCursorPos;
    procedure UpdateRecord;
    function UpdateStatus: TUpdateStatus;
    end;

    TDatasetAccess = class(TDataset)
    published
       property AggFields;
       property Bof;
       property Bookmark;
       property CanModify;
       property DataSetField;
       property DataSource;
       property DefaultFields;
       property Designer;
       property Eof;
       property BlockReadSize;
       property FieldCount;
       property FieldDefs;
       property FieldDefList;
       property Fields;
       property FieldList;
       //property FieldValues[const FieldName: string]: Variant
       property Found;
       property IsUniDirectional;
       property Modified;
       property ObjectView;
       property RecordCount;
       property RecNo;
       property RecordSize;
       property SparseArrays;
       property State;
       property Filter;
       property Filtered;
       property FilterOptions;
       property Active;
       property AutoCalcFields;
    end;

//==============================================================================
    TLuaBDEDataSet = class (TLuaDataset)
    protected
       class function GetPublicPropertyAccessClass :TClass; override;

    public
(*       function GetArrayPropType(Name :String; index :Variant) :PTypeInfo; override;
       function GetArrayProp(Name :String; index :Variant) :Variant; override;
       function GetElementType(Name :String) :PTypeInfo; override;
       function GetElement(Name :String) :Variant; override;
*)
    procedure ApplyUpdates;
    procedure CancelUpdates;
    procedure CommitUpdates;
    function ConstraintCallBack(Req: DsInfoReq; var ADataSources: DataSources): DBIResult;
    function ConstraintsDisabled: Boolean;
    procedure DisableConstraints;
    procedure EnableConstraints;
    procedure FetchAll;
    procedure FlushBuffers;
    procedure GetIndexInfo;
    procedure RevertRecord;
    end;

    TBDEDataSetAccess = class(TBDEDataSet)
    published
       property CacheBlobs;
       property ExpIndex;
       //property Handle;  Pointer
       property KeySize;
       //property Locale;  Pointer
       property UpdateObject;
       property UpdatesPending;
       property UpdateRecordTypes;
    end;

//==============================================================================
    TLuaDBDataSet = class (TLuaBDEDataSet)
    protected
       class function GetPublicPropertyAccessClass :TClass; override;

    public
(*       function GetArrayPropType(Name :String; index :Variant) :PTypeInfo; override;
       function GetArrayProp(Name :String; index :Variant) :Variant; override;
       function GetElementType(Name :String) :PTypeInfo; override;
       function GetElement(Name :String) :Variant; override;
*)
    function CheckOpen(Status: DBIResult): Boolean;
    procedure CloseDatabase(Database: TDatabase);
    function OpenDatabase: TDatabase;
    end;

    TDBDataSetAccess = class(TDBDataSet)
    published
       property Database;
       //property DBHandle; Pointer
       //property DBLocale; Pointer
       property DBSession;
       //property Handle; Pointer
    end;

//==============================================================================
    TLuaTable = class (TLuaDBDataSet)
    protected
       class function GetPublicPropertyAccessClass :TClass; override;

    public
       function GetArrayPropType(Name :String; index :Variant) :PTypeInfo; override;
       function GetArrayProp(Name :String; index :Variant) :Variant; override;

    function BatchMove(ASource: TBDEDataSet; AMode: TBatchMode): Longint;
    procedure AddIndex(const Name, Fields: string; Options: TIndexOptions;
      const DescFields: string = '');
    procedure ApplyRange;
    procedure CancelRange;
    procedure CloseIndexFile(const IndexFileName: string);
    procedure CreateTable;
    procedure DeleteIndex(const Name: string);
    procedure DeleteTable;
    procedure EditKey;
    procedure EditRangeEnd;
    procedure EditRangeStart;
    procedure EmptyTable;
    function FindKey(const KeyValues: array of const): Boolean;
    procedure FindNearest(const KeyValues: array of const);
    procedure GetIndexNames(List: TStrings);
    procedure GotoCurrent(Table: TTable);
    function GotoKey: Boolean;
    procedure GotoNearest;
    procedure LockTable(LockType: TLockType);
    procedure OpenIndexFile(const IndexName: string);
    procedure RenameTable(const NewTableName: string);
    procedure SetKey;
    procedure SetRange(const StartValues, EndValues: array of const);
    procedure SetRangeEnd;
    procedure SetRangeStart;
    procedure UnlockTable(LockType: TLockType);
    end;

    TTableAccess = class(TTable)
    published
       property Exists;
       property IndexFieldCount;
       //property IndexFields[Index: Integer]: TField;
       property KeyExclusive;
       property KeyFieldCount;
       property TableLevel;
    end;

//==============================================================================
    TLuaQuery = class (TLuaDBDataSet)
    protected
       class function GetPublicPropertyAccessClass :TClass; override;

    public
(*       function GetArrayPropType(Name :String; index :Variant) :PTypeInfo; override;
       function GetArrayProp(Name :String; index :Variant) :Variant; override;
       function GetElementType(Name :String) :PTypeInfo; override;
       function GetElement(Name :String) :Variant; override;
*)
    procedure ExecSQL;
    function ParamByName(const Value: string): TParam;
    procedure Prepare;
    procedure UnPrepare;
    end;

    TQueryAccess = class(TQuery)
    published
       property Prepared;
       property ParamCount;
       property Local;
       //property StmtHandle; Pointer
       property Text;
       property RowsAffected;
       //property SQLBinary; Pointer
    end;

//==============================================================================
    TLuaField = class (TLuaComponent)
    protected
       class function GetPublicPropertyAccessClass :TClass; override;

    public
    procedure AssignValue(const Value: TVarRec);
    procedure Clear;
    procedure FocusControl;
    function GetData(Buffer: Pointer; NativeFormat: Boolean = True): Boolean;
    class function IsBlob: Boolean;
    function IsValidChar(InputChar: Char): Boolean;
    procedure RefreshLookupList;
    procedure SetData(Buffer: Pointer; NativeFormat: Boolean = True);
    procedure SetFieldType(Value: TFieldType);
    procedure Validate(Buffer: Pointer);
    end;

    TFieldAccess = class(TField)
    published
       property AsBCD;
       property AsBoolean;
       property AsCurrency;
       property AsDateTime;
       property AsSQLTimeStamp;
       property AsFloat;
       property AsInteger;
       property AsString;
       property AsVariant;
       property AttributeSet;
       property Calculated;
       property CanModify;
       property CurValue;
       property DataSet;
       property DataSize;
       property DataType;
       property DisplayName;
       property DisplayText;
       property EditMask;
       property EditMaskPtr;
       property FieldNo;
       property FullName;
       property IsIndexField;
       property IsNull;
       property Lookup;
       property LookupList;
       property NewValue;
       property Offset;
       property OldValue;
       property ParentField;
       property Size;
       property Text;
       //property ValidChars;  Size of published set 'ValidChars' is >4 bytes
       property Value;
    end;

procedure RegisterFunctions(L: Plua_State);
begin
     Lua_Object.RegisterFunctions(L);
end;

{ TLuaDataset }

function TLuaDataset.GetArrayPropType(Name: String; index: Variant): PTypeInfo;
begin
     Name :=Uppercase(Name);
     Result :=nil;

     if (Name='FIELDVALUES')
     then begin
               if (TDataset(InstanceObj).FieldValues[index]<>NULL)
               then Result :=TypeInfo(Variant);
          end
     else
     Result :=inherited GetArrayPropType(Name, index);
end;

function TLuaDataset.GetArrayProp(Name: String; index: Variant): Variant;
begin
     if (Name='FIELDVALUES')
     then begin
               Result :=TDataset(InstanceObj).FieldValues[index]
          end
     else
     Result := inherited GetArrayProp(name, index)
end;

class function TLuaDataset.GetPublicPropertyAccessClass: TClass;
begin
     Result :=TDatasetAccess;
end;

function TLuaDataset.FindLast: Boolean;
begin
     Result :=TDataset(InstanceObj).FindLast;
end;

function TLuaDataset.FieldByName(const FieldName: string): TField;
begin
     Result :=TDataset(InstanceObj).FieldByName(FieldName);
end;

function TLuaDataset.FindPrior: Boolean;
begin
     Result :=TDataset(InstanceObj).FindPrior;
end;

function TLuaDataset.FindField(const FieldName: string): TField;
begin
     Result :=TDataset(InstanceObj).FindField(FieldName);
end;

function TLuaDataset.FindFirst: Boolean;
begin
     Result :=TDataset(InstanceObj).FindFirst;
end;

procedure TLuaDataset.First;
begin
     TDataset(InstanceObj).First;
end;

function TLuaDataset.FindNext: Boolean;
begin
     Result :=TDataset(InstanceObj).FindNext;
end;

function TLuaDataset.IsLinkedTo(DataSource: TDataSource): Boolean;
begin
     Result :=TDataset(InstanceObj).IsLinkedTo(DataSource);
end;

procedure TLuaDataset.ClearFields;
begin
    TDataset(InstanceObj).ClearFields;
end;

procedure TLuaDataset.CursorPosChanged;
begin
     TDataset(InstanceObj).CursorPosChanged;
end;

function TLuaDataset.Lookup(const KeyFields: string; const KeyValues: Variant;
  const ResultFields: string): Variant;
begin
     Result :=TDataset(InstanceObj).Lookup(KeyFields, KeyValues, ResultFields);
end;

procedure TLuaDataset.Last;
begin
     TDataset(InstanceObj).Last;
end;

function TLuaDataset.Locate(const KeyFields: string; const KeyValues: Variant;
  Options: TLocateOptions): Boolean;
begin
     Result :=TDataset(InstanceObj).Locate(KeyFields, KeyValues, Options);
end;

procedure TLuaDataset.SetFields(const Values: array of const);
begin
     TDataset(InstanceObj).SetFields(Values);
end;

procedure TLuaDataset.CheckBrowseMode;
begin
     TDataset(InstanceObj).CheckBrowseMode;
end;

function TLuaDataset.UpdateStatus: TUpdateStatus;
begin
     Result :=TDataset(InstanceObj).UpdateStatus;
end;

function TLuaDataset.MoveBy(Distance: Integer): Integer;
begin
     Result :=TDataset(InstanceObj).MoveBy(Distance);
end;

function TLuaDataset.IsSequenced: Boolean;
begin
     Result :=TDataset(InstanceObj).IsSequenced;
end;

procedure TLuaDataset.Prior;
begin
     TDataset(InstanceObj).Prior;
end;

procedure TLuaDataset.UpdateRecord;
begin
     TDataset(InstanceObj).UpdateRecord;
end;

procedure TLuaDataset.Refresh;
begin
     TDataset(InstanceObj).Refresh;
end;

procedure TLuaDataset.Open;
begin
     TDataset(InstanceObj).Open;
end;

procedure TLuaDataset.DisableControls;
begin
     TDataset(InstanceObj).DisableControls;
end;

procedure TLuaDataset.AppendRecord(const Values: array of const);
begin
     TDataset(InstanceObj).AppendRecord(Values);
end;

procedure TLuaDataset.Cancel;
begin
     TDataset(InstanceObj).Cancel;
end;

procedure TLuaDataset.Post;
begin
     TDataset(InstanceObj).Post;
end;

procedure TLuaDataset.InsertRecord(const Values: array of const);
begin
     TDataset(InstanceObj).InsertRecord(Values);
end;

function TLuaDataset.IsEmpty: Boolean;
begin
     Result :=TDataset(InstanceObj).IsEmpty;
end;

procedure TLuaDataset.Close;
begin
     TDataset(InstanceObj).Close;
end;

procedure TLuaDataset.EnableControls;
begin
     TDataset(InstanceObj).EnableControls;
end;

procedure TLuaDataset.Delete;
begin
     TDataset(InstanceObj).Delete;
end;

procedure TLuaDataset.Resync(Mode: TResyncMode);
begin
     TDataset(InstanceObj).Resync(Mode);
end;

procedure TLuaDataset.Edit;
begin
     TDataset(InstanceObj).Edit;
end;

procedure TLuaDataset.Append;
begin
     TDataset(InstanceObj).Append;
end;

function TLuaDataset.ControlsDisabled: Boolean;
begin
     Result :=TDataset(InstanceObj).ControlsDisabled;
end;

procedure TLuaDataset.UpdateCursorPos;
begin
     TDataset(InstanceObj).UpdateCursorPos;
end;

procedure TLuaDataset.Next;
begin
     TDataset(InstanceObj).Next;
end;

procedure TLuaDataset.Insert;
begin
     TDataset(InstanceObj).Insert;
end;

procedure TLuaDataset.GetFieldList(List: TList; const FieldNames: string);
begin
     TDataset(InstanceObj).GetFieldList(List, FieldNames);
end;

function TLuaDataset.GetFieldData(Field: TField; Buffer: Pointer;
  NativeFormat: Boolean): Boolean;
begin
     Result :=TDataset(InstanceObj).GetFieldData(Field, Buffer, NativeFormat);
end;

function TLuaDataset.GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean;
begin
     Result :=TDataset(InstanceObj).GetFieldData(FieldNo, Buffer);
end;

function TLuaDataset.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
     Result :=TDataset(InstanceObj).GetFieldData(Field, Buffer);
end;

function TLuaDataset.CreateBlobStream(Field: TField;
  Mode: TBlobStreamMode): TStream;
begin
     Result :=TDataset(InstanceObj).CreateBlobStream(Field, Mode);
end;

procedure TLuaDataset.GotoBookmark(Bookmark: TBookmark);
begin
     TDataset(InstanceObj).GotoBookmark(Bookmark);
end;

function TLuaDataset.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
begin
     Result :=TDataset(InstanceObj).CompareBookmarks(Bookmark1, Bookmark2);
end;

function TLuaDataset.GetBookmark: TBookmark;
begin
     Result :=TDataset(InstanceObj).GetBookmark;
end;

function TLuaDataset.GetCurrentRecord(Buffer: String): Boolean;
begin
     Result :=TDataset(InstanceObj).GetCurrentRecord(PChar(Buffer));
end;

procedure TLuaDataset.GetDetailLinkFields(MasterFields, DetailFields: TList);
begin
     TDataset(InstanceObj).GetDetailLinkFields(MasterFields, DetailFields);
end;

function TLuaDataset.BookmarkValid(Bookmark: TBookmark): Boolean;
begin
     Result :=TDataset(InstanceObj).BookmarkValid(Bookmark);
end;

function TLuaDataset.Translate(Src, Dest: String; ToOem: Boolean): Integer;
begin
     Result :=TDataset(InstanceObj).Translate(PChar(Src), PChar(Dest), ToOem);
end;

procedure TLuaDataset.FreeBookmark(Bookmark: TBookmark);
begin
     TDataset(InstanceObj).FreeBookmark(Bookmark);
end;

function TLuaDataset.GetBlobFieldData(FieldNo: Integer;
  var Buffer: TBlobByteData): Integer;
begin
     Result :=TDataset(InstanceObj).GetBlobFieldData(FieldNo, Buffer);
end;

procedure TLuaDataset.GetDetailDataSets(List: TList);
begin
     TDataset(InstanceObj).GetDetailDataSets(List);
end;

function TLuaDataset.ActiveBuffer: String;
begin
     Result :=TDataset(InstanceObj).ActiveBuffer;
end;

procedure TLuaDataset.GetFieldNames(List: TStrings);
begin
     TDataset(InstanceObj).GetFieldNames(List);
end;

{ TLuaBDEDataSet }

class function TLuaBDEDataSet.GetPublicPropertyAccessClass: TClass;
begin
     Result :=TBDEDataSetAccess;
end;

procedure TLuaBDEDataSet.CancelUpdates;
begin
     TBDEDataset(InstanceObj).CancelUpdates;
end;

procedure TLuaBDEDataSet.ApplyUpdates;
begin
     TBDEDataset(InstanceObj).ApplyUpdates;
end;

procedure TLuaBDEDataSet.CommitUpdates;
begin
     TBDEDataset(InstanceObj).CommitUpdates;
end;

procedure TLuaBDEDataSet.DisableConstraints;
begin
     TBDEDataset(InstanceObj).DisableConstraints;
end;

procedure TLuaBDEDataSet.FetchAll;
begin
     TBDEDataset(InstanceObj).FetchAll;
end;

procedure TLuaBDEDataSet.EnableConstraints;
begin
     TBDEDataset(InstanceObj).EnableConstraints;
end;

function TLuaBDEDataSet.ConstraintsDisabled: Boolean;
begin
     Result :=TBDEDataset(InstanceObj).ConstraintsDisabled;
end;

procedure TLuaBDEDataSet.GetIndexInfo;
begin
     TBDEDataset(InstanceObj).GetIndexInfo;
end;

function TLuaBDEDataSet.ConstraintCallBack(Req: DsInfoReq;
  var ADataSources: DataSources): DBIResult;
begin
     Result :=TBDEDataset(InstanceObj).ConstraintCallBack(Req, ADataSources);
end;

procedure TLuaBDEDataSet.FlushBuffers;
begin
     TBDEDataset(InstanceObj).FlushBuffers;
end;

procedure TLuaBDEDataSet.RevertRecord;
begin
     TBDEDataset(InstanceObj).RevertRecord;
end;

{ TLuaDBDataSet }

class function TLuaDBDataSet.GetPublicPropertyAccessClass: TClass;
begin
     Result :=TDBDataSetAccess;
end;

procedure TLuaDBDataSet.CloseDatabase(Database: TDatabase);
begin
     TDBDataSet(InstanceObj).CloseDatabase(Database);
end;

function TLuaDBDataSet.CheckOpen(Status: DBIResult): Boolean;
begin
     Result :=TDBDataSet(InstanceObj).CheckOpen(Status);
end;

function TLuaDBDataSet.OpenDatabase: TDatabase;
begin
     Result :=TDBDataSet(InstanceObj).OpenDatabase;
end;

{ TLuaTable }

function TLuaTable.GetArrayPropType(Name: String; index: Variant): PTypeInfo;
begin
     Name :=Uppercase(Name);
     Result :=nil;

     if (Name='INDEXFIELDS')
     then begin
               if (TTable(InstanceObj).IndexFields[index]<>nil)
               then Result :=TypeInfo(TField);
          end
     else
     Result :=inherited GetArrayPropType(Name, index);
end;

function TLuaTable.GetArrayProp(Name: String; index: Variant): Variant;
begin
     if (Name='INDEXFIELDS')
     then begin
               if (TTable(InstanceObj).IndexFields[index]<>nil)
               then Result :=Integer(TTable(InstanceObj).IndexFields[index])
               else Result :=NULL;
          end
     else
     Result := inherited GetArrayProp(name, index)
end;

class function TLuaTable.GetPublicPropertyAccessClass: TClass;
begin
     Result :=TTableAccess;
end;

procedure TLuaTable.SetRange(const StartValues, EndValues: array of const);
begin
     TTable(InstanceObj).SetRange(StartValues, EndValues);
end;

procedure TLuaTable.GetIndexNames(List: TStrings);
begin
     TTable(InstanceObj).GetIndexNames(List);
end;

procedure TLuaTable.SetKey;
begin
     TTable(InstanceObj).SetKey;
end;

procedure TLuaTable.CreateTable;
begin
     TTable(InstanceObj).CreateTable;
end;

procedure TLuaTable.GotoNearest;
begin
     TTable(InstanceObj).GotoNearest;
end;

procedure TLuaTable.RenameTable(const NewTableName: string);
begin
     TTable(InstanceObj).RenameTable(NewTableName);
end;

procedure TLuaTable.CloseIndexFile(const IndexFileName: string);
begin
     TTable(InstanceObj).CloseIndexFile(IndexFileName);
end;

procedure TLuaTable.DeleteIndex(const Name: string);
begin
     TTable(InstanceObj).DeleteIndex(Name);
end;

function TLuaTable.BatchMove(ASource: TBDEDataSet; AMode: TBatchMode): Longint;
begin
     Result :=TTable(InstanceObj).BatchMove(ASource, AMode);
end;

procedure TLuaTable.EditRangeStart;
begin
     TTable(InstanceObj).EditRangeStart;
end;

procedure TLuaTable.CancelRange;
begin
     TTable(InstanceObj).CancelRange;
end;

function TLuaTable.GotoKey: Boolean;
begin
     Result :=TTable(InstanceObj).GotoKey;
end;

procedure TLuaTable.ApplyRange;
begin
     TTable(InstanceObj).ApplyRange;
end;

procedure TLuaTable.LockTable(LockType: TLockType);
begin
     TTable(InstanceObj).LockTable(LockType);
end;

procedure TLuaTable.FindNearest(const KeyValues: array of const);
begin
     TTable(InstanceObj).FindNearest(KeyValues);
end;

procedure TLuaTable.UnlockTable(LockType: TLockType);
begin
     TTable(InstanceObj).UnlockTable(LockType);
end;

procedure TLuaTable.GotoCurrent(Table: TTable);
begin
     TTable(InstanceObj).GotoCurrent(Table);
end;

procedure TLuaTable.SetRangeStart;
begin
     TTable(InstanceObj).SetRangeStart;
end;

procedure TLuaTable.AddIndex(const Name, Fields: string; Options: TIndexOptions;
  const DescFields: string);
begin
     TTable(InstanceObj).AddIndex(Name, Fields, Options, DescFields);
end;

procedure TLuaTable.EditRangeEnd;
begin
     TTable(InstanceObj).EditRangeEnd;
end;

procedure TLuaTable.EditKey;
begin
     TTable(InstanceObj).EditKey;
end;

procedure TLuaTable.DeleteTable;
begin
     TTable(InstanceObj).DeleteTable;
end;

function TLuaTable.FindKey(const KeyValues: array of const): Boolean;
begin
     Result :=TTable(InstanceObj).FindKey(KeyValues);
end;

procedure TLuaTable.EmptyTable;
begin
     TTable(InstanceObj).EmptyTable;
end;

procedure TLuaTable.SetRangeEnd;
begin
     TTable(InstanceObj).SetRangeEnd;
end;

procedure TLuaTable.OpenIndexFile(const IndexName: string);
begin
     TTable(InstanceObj).OpenIndexFile(IndexName);
end;

{ TLuaQuery }

class function TLuaQuery.GetPublicPropertyAccessClass: TClass;
begin
     Result :=TQueryAccess;
end;

procedure TLuaQuery.ExecSQL;
begin
     TQuery(InstanceObj).ExecSQL;
end;

function TLuaQuery.ParamByName(const Value: string): TParam;
begin
     Result :=TQuery(InstanceObj).ParamByName(Value);
end;

procedure TLuaQuery.Prepare;
begin
     TQuery(InstanceObj).Prepare;
end;

procedure TLuaQuery.UnPrepare;
begin
     TQuery(InstanceObj).UnPrepare;
end;

{ TLuaField }

class function TLuaField.GetPublicPropertyAccessClass: TClass;
begin
     Result :=TFieldAccess;
end;

procedure TLuaField.AssignValue(const Value: TVarRec);
begin
     TField(InstanceObj).AssignValue(Value);
end;

function TLuaField.GetData(Buffer: Pointer; NativeFormat: Boolean): Boolean;
begin
     Result :=TField(InstanceObj).GetData(Buffer, NativeFormat);
end;

procedure TLuaField.FocusControl;
begin
     TField(InstanceObj).FocusControl;
end;

procedure TLuaField.Clear;
begin
     TField(InstanceObj).Clear;
end;

procedure TLuaField.SetData(Buffer: Pointer; NativeFormat: Boolean);
begin
     TField(InstanceObj).SetData(Buffer, NativeFormat);
end;

procedure TLuaField.SetFieldType(Value: TFieldType);
begin
     TField(InstanceObj).SetFieldType(Value);
end;

procedure TLuaField.Validate(Buffer: Pointer);
begin
     TField(InstanceObj).Validate(Buffer);
end;

procedure TLuaField.RefreshLookupList;
begin
     TField(InstanceObj).RefreshLookupList;
end;

class function TLuaField.IsBlob: Boolean;
begin
     Result := False;
end;

function TLuaField.IsValidChar(InputChar: Char): Boolean;
begin
     Result :=TField(InstanceObj).IsValidChar(InputChar);
end;

initialization
   Lua_Object.RegisterClass(TDataset, TLuaDataset);
   Lua_Object.RegisterClass(TBDEDataSet, TLuaBDEDataSet);
   Lua_Object.RegisterClass(TDBDataSet, TLuaDBDataSet);
   Lua_Object.RegisterClass(TTable, TLuaTable);
   Lua_Object.RegisterClass(TQuery, TLuaQuery);
   Lua_Object.RegisterClass(TField, TLuaField);

end.
