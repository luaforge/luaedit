//******************************************************************************
//***                   COMMON DELPHI FUNCTIONS                              ***
//***                                                                        ***
//***        (c) Massimo Magnano, Beppe Grimaldi 2004-2005                   ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : MGRegistry.pas
//
//  Description : Extensions on TRegistry class
//                    Support for Read\Write Components,
//                    TFont,
//                    MultiLine Text
//
//******************************************************************************

unit MGRegistry;

interface

{$define TYPE_INFO_1}

Uses Windows, Registry, SysUtils, Classes, Graphics, TypInfo;

Type
    TRegFont = packed record
       Name    :ShortString;
       Size    :Byte;
       Style   :Byte;
       Charset :Byte;
       Color   :TColor;
    end;

    TPersistentClasses = class of TPersistent;

    TMGRegistry =class(TRegistry)
    protected
       function ReadWriteClass(Read :Boolean; AClass :TPersistent) :Boolean; virtual;
    public
       function ReadBool(Default :Boolean; const Name: string): Boolean; overload;
       function ReadCurrency(Default :Currency; const Name: string): Currency; overload;
       function ReadDate(Default :TDateTime; const Name: string): TDateTime; overload;
       function ReadDateTime(Default :TDateTime; const Name: string): TDateTime; overload;
       function ReadFloat(Default :Double; const Name: string): Double; overload;
       function ReadInteger(Default :Integer; const Name: string): Integer; overload;
       function ReadString(Default :string; AcceptEmpty :Boolean;  const Name: string): string; overload;
       function ReadTime(Default :TDateTime; const Name: string): TDateTime; overload;
       procedure ReadBinaryDataFromFile(FileName :String; var Buffer :Pointer; var BufSize :Integer);
       procedure ReadBinaryDataFromString(theString :String; var Buffer :Pointer; var BufSize :Integer);
       function ReadFont(const Name: string; var AFont :TFont): Boolean;
       procedure WriteFont(const Name: string; Value :TFont);
       function ReadClass(var AClass :TPersistent; AClasses :TPersistentClasses): Boolean;
       function WriteClass(AClass :TPersistent): Boolean;
       function ReadDFMClass(Name :String; AClass :TPersistent): Boolean;
       function WriteDFMClass(Name :String; AClass :TPersistent): Boolean;
       procedure WriteMultiLineString(Name, Value: String);
       function ReadMultiLineString(const Name: string): string;
    end;

implementation


type
    TReadWritePersist = class (TComponent)
    private
      rData :TPersistent;
    published
      property Data :TPersistent read rData write rData;
    end;

function TMGRegistry.ReadBool(Default :Boolean; const Name: string): Boolean;
begin
     try
        Result :=ReadBool(Name);
     except
        On E:Exception do Result :=Default;
     end;
end;

function TMGRegistry.ReadCurrency(Default :Currency; const Name: string): Currency;
begin
     try
        Result :=ReadCurrency(Name);
     except
        On E:Exception do Result :=Default;
     end;
end;

function TMGRegistry.ReadDate(Default :TDateTime; const Name: string): TDateTime;
begin
     try
        Result :=ReadDate(Name);
     except
        On E:Exception do Result :=Default;
     end;
end;

function TMGRegistry.ReadDateTime(Default :TDateTime; const Name: string): TDateTime;
begin
     try
        Result :=ReadDateTime(Name);
     except
        On E:Exception do Result :=Default;
     end;
end;

function TMGRegistry.ReadFloat(Default :Double; const Name: string): Double;
begin
     try
        Result :=ReadFloat(Name);
     except
        On E:Exception do Result :=Default;
     end;
end;

function TMGRegistry.ReadInteger(Default :Integer; const Name: string): Integer;
begin
     try
        Result :=ReadInteger(Name);
     except
        On E:Exception do Result :=Default;
     end;
end;

function TMGRegistry.ReadString(Default :string; AcceptEmpty :Boolean; const Name: string): string;
begin
     try
        if (ValueExists(Name))
          then begin
                  Result := ReadString(Name);
                  if ((Result = '') and not AcceptEmpty)
                    then Result := Default;
               end
          else Result := Default;
     except
        On E:Exception do Result :=Default;
     end;
end;

function TMGRegistry.ReadTime(Default :TDateTime; const Name: string): TDateTime;
begin
     try
        Result :=ReadTime(Name);
     except
        On E:Exception do Result :=Default;
     end;
end;

procedure TMGRegistry.ReadBinaryDataFromFile(FileName :String; var Buffer :Pointer; var BufSize :Integer);
Var
   theFile :TFileStream;

begin
     BufSize :=0;
     Buffer :=Nil;
     theFile :=Nil;
     try
        theFile :=TFileStream.Create(FileName, fmOpenRead);
        BufSize :=theFile.Size;
        GetMem(Buffer, BufSize);
        theFile.Read(Buffer, BufSize);
        theFile.Free; theFile :=Nil;
     except
        On E:Exception do
        begin
             if Buffer<>Nil then FreeMem(Buffer);
             if theFile<>Nil then theFile.Free;
             Buffer :=Nil;
             BufSize :=0;
        end;
     end;
end;

procedure TMGRegistry.ReadBinaryDataFromString(theString :String; var Buffer :Pointer; var BufSize :Integer);
Var
   indexStr,
   indexPtr :Integer;

begin
     BufSize :=Length(theString) div 2;
     SetLength(theString, BufSize*2); //la stringa deve essere di lunghezza pari
     GetMem(Buffer, BufSize);
     indexStr :=1;
     for indexPtr :=0 to BufSize-1 do
     begin
          PChar(Buffer)[indexPtr] :=Char(StrToInt('$'+Copy(theString, indexStr, 2)));
          inc(indexStr, 2);
     end;
end;

function TMGRegistry.ReadFont(const Name: string; var AFont :TFont) :Boolean;
var
   regFont :TRegFont;
begin
     Result := False;
     try
        if (not assigned(AFont))
          then AFont := TFont.Create;
        if (ValueExists(Name))
          then if (GetDataSize(Name) = sizeOf(TRegFont))
                 then begin
                         ReadBinaryData(Name, regFont, sizeOf(TRegFont));
                         AFont.Name := regFont.Name;
                         AFont.Size := regFont.Size;
                         AFont.Style := TFontStyles(regFont.Style);
                         AFont.Charset := regFont.Charset;
                         AFont.Color := regFont.Color;
                         Result := True;
                      end;
     except
        On E:Exception do begin end;
     end;
end;

procedure TMGRegistry.WriteFont(const Name: string; Value :TFont);
var
   regFont :TRegFont;
begin
     try
        if (Value <> Nil)
          then begin
                  regFont.Name := Value.Name;
                  regFont.Size := Value.Size;
                  regFont.Style := Byte(Value.Style);
                  regFont.Charset := Value.Charset;
                  regFont.Color := Value.Color;
                  WriteBinaryData(Name, regFont, sizeOf(TRegFont));
               end;
     except
        On E:Exception do begin end;
     end;
end;

function TMGRegistry.ReadWriteClass(Read :Boolean; AClass :TPersistent) :Boolean;
Var
   rPropList :TPropList;
   PropName  :String;
   PropValue :Variant;
   IsClass   :Boolean;
   i         :Integer;

begin
     Result := True;
     try
          fillchar(rPropList, sizeof(TPropList), 0);
          TypInfo.GetPropList(AClass.ClassInfo, tkProperties,
                              PPropList(@rPropList));
          i := 0;
          while (rPropList[i] <> Nil) do
          begin
             try
               {$ifdef TYPE_INFO_1}
                 IsClass :=(rPropList[i]^.PropType^.Kind=tkClass);
               {$else}
                 IsClass :=(rPropList[i]^.PropType^^.Kind=tkClass);
               {$endif}
               PropName :=rPropList[i]^.Name;

               if not(IsClass) then
               begin
                    if Read
                    then begin
                              PropValue :=Self.ReadString('', True, PropName);
                              SetPropValue(AClass, PropName, PropValue);
                         end
                    else begin
                              PropValue :=GetPropValue(AClass, PropName, True);
                              Self.WriteString(PropName, PropValue);
                         end;
               end;
             except
                   On E:Exception do Result :=False;
             end;
             Inc(i);
          end;
     except
        On E:Exception do Result :=False;
     end;
end;

function TMGRegistry.ReadClass(var AClass :TPersistent; AClasses :TPersistentClasses): Boolean;
begin
     Result :=False;
     try
        if (not assigned(AClass))
        then begin
                  AClass := TPersistent(AClasses.Create);
             end;

        if (AClass<>Nil)
        then Result :=ReadWriteClass(True, AClass);
     except
       On E:Exception do Result :=False;
     end;
end;

function TMGRegistry.WriteClass(AClass :TPersistent):Boolean;
begin
     Result :=False;
     if (AClass<>Nil)
     then Result :=ReadWriteClass(False, AClass);
end;

function TMGRegistry.ReadDFMClass(Name :String; AClass :TPersistent): Boolean;
Var
   MStream,
   MStreamTXT  :TMemoryStream;
   xList       :TStringList;
   toRead      :TComponent;


begin
  Result :=False;
  try
     if (AClass is TComponent)
     then toRead :=TComponent(AClass)
     else begin
               if (AClass is TPersistent)
               then begin
                         toRead :=TReadWritePersist.Create(Nil);
                         TReadWritePersist(toRead).Data :=AClass;
                    end
               else Exit;
          end;

     MStream    :=TMemoryStream.Create;
     MStreamTXT :=TMemoryStream.Create;
     xList   :=TStringList.Create;
     try
        xList.Text :=Self.ReadMultiLineString(Name);
        xList.SaveToStream(MStreamTXT);
        MStreamTXT.Position :=0;

        ObjectTextToBinary(MStreamTXT, MStream);
        MStream.Position :=0;
        MStream.ReadComponent(toRead);
        Result :=True;
     finally
        MStream.Free;
        MStreamTXT.Free;
        xList.Free;

        if (toRead<>AClass)
        then toRead.Free;
     end;
  except
     On E:Exception do begin end;
  end;
end;

function TMGRegistry.WriteDFMClass(Name :String; AClass :TPersistent): Boolean;
Var
   MStream,
   MStreamTXT  :TMemoryStream;
   xList       :TStringList;
   toWrite     :TComponent;

begin
  Result :=False;
  try
     if (AClass is TComponent)
     then toWrite :=TComponent(AClass)
     else begin
               if (AClass is TPersistent)
               then begin
                         toWrite :=TReadWritePersist.Create(Nil);
                         TReadWritePersist(toWrite).Data :=AClass;
                    end
               else Exit;
          end;

     MStream    :=TMemoryStream.Create;
     MStreamTXT :=TMemoryStream.Create;
     xList   :=TStringList.Create;
     try
        MStream.WriteComponent(toWrite);
        MStream.Position :=0;

        ObjectBinaryToText(MStream, MStreamTXT);
        MStreamTXT.Position :=0;
        xList.LoadFromStream(MStreamTXT);
        Self.WriteMultiLineString(Name, xList.Text);
        Result :=True;
     finally
        MStream.Free;
        MStreamTXT.Free;
        xList.Free;

        if (toWrite<>AClass)
        then toWrite.Free;
     end;
  except
    On E:Exception do begin end;
  end;
end;

procedure TMGRegistry.WriteMultiLineString(Name, Value: String);
Var
   Buffer :PChar;
   ch     :Char;
   i, k   :Integer;

begin
    Buffer :=Nil;
    try
       GetMem(Buffer, Length(Value)+1);
       k :=0;
       for i :=1 to Length(Value) do
       begin
            ch :=Value[i];
            case ch of
            #13 : ch :=#0;
            #10 : Continue;
            end;
            Buffer[k] :=ch;
            inc(k);
        end;

       Buffer[k+1] :=#0;

       RegSetValueEx(CurrentKey, PChar(Name), 0, REG_MULTI_SZ, Buffer, k);
    finally
       if (Buffer<>Nil)
       then Freemem(Buffer);
    end;
end;

function TMGRegistry.ReadMultiLineString(const Name: string): string;
Var
   Buffer  :PChar;
   ch      :Char;
   i       :Integer;
   bufSize :DWord;
   bufType :DWord;

begin
    if (RegQueryValueEx(CurrentKey, PChar(Name), Nil, @bufType, Nil, @bufSize)
       =ERROR_SUCCESS) and (bufType=REG_MULTI_SZ)
    then begin
              Buffer :=Nil;
              try
                 GetMem(Buffer, bufSize);
                 RegQueryValueEx(CurrentKey, PChar(Name), Nil, @bufType, PByte(Buffer), @bufSize);

                 for i :=0 to bufSize-2 do
                 begin
                      ch :=Buffer[i];
                      if ch=#0
                      then Result :=Result+#13#10
                      else Result :=Result+ch;
                 end;
              finally
                 if (Buffer<>Nil)
                 then Freemem(Buffer);
              end;
         end;
end;

end.
