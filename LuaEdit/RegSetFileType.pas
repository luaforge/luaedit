unit RegSetFileType;

interface

uses
 SysUtils, Windows;

{
 Example usage:

  RegSetAssociations('.MYX', 'myCompany.MYX', 'myCompany`s X File',
   'application/x-myCompany.MYX', ExtractFilePath(Application.ExeName) + '\Graphics\Icon1.ico');

  RegSetOpenWith('myCompany.MYX', Application.ExeName + ' %1');
}

procedure RegSetAssociation(inExtension, inFileType, inTypeDesc, inContentType, inIconPath: String);
procedure RegSetOpenWith(inFileType, inOpenWith: String);
procedure RegSetFileTypeAutoOpenInIE(inFileType: String; inAutoOpenFromIE: Boolean = true);
procedure RegClearIEOpenKey(inFileExt: String);
procedure RegClearAssociation(inExtension, inFileType: String);

implementation

uses
 Registry;

const
 cExceptMsg = 'RegSetFileType Failure';

procedure RegSetAssociation(inExtension, inFileType, inTypeDesc, inContentType, inIconPath: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    if not Reg.OpenKey('\'+inExtension, true) then
      raise Exception.Create(cExceptMsg);

    Reg.WriteString('', inFileType);
    Reg.WriteString('Content Type', inContentType);

    if not Reg.OpenKey('\'+inFileType, true) then
      raise Exception.Create(cExceptMsg);

    Reg.WriteString('', inTypeDesc);

    if not Reg.OpenKey('DefaultIcon', true) then
      raise Exception.Create(cExceptMsg);

    Reg.WriteString('', inIconPath);
    Reg.CloseKey;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure RegSetOpenWith(inFileType, inOpenWith: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;

  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if not Reg.OpenKey('\'+inFileType, false) then
      raise Exception.Create(cExceptMsg);

    if not Reg.OpenKey('shell', true) then
      raise Exception.Create(cExceptMsg);

    if not Reg.OpenKey('open', true) then
      raise Exception.Create(cExceptMsg);

    if not Reg.OpenKey('command', true) then
      raise Exception.Create(cExceptMsg);

    Reg.WriteString('', inOpenWith);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure RegClearIEOpenKey(inFileExt: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    Reg.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + inFileExt);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure RegClearAssociation(inExtension, inFileType: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    if Reg.OpenKey('\' + inExtension, false) then
    begin
      Reg.DeleteKey('\' + inExtension);
    end;

    if Reg.OpenKey('\' + inFileType, false) then
    begin
      Reg.DeleteKey('\' + inFileType);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

procedure RegSetFileTypeAutoOpenInIE(inFileType: String; inAutoOpenFromIE: Boolean);
var
  Reg: TRegistry;
  pikAutoOpenFlag: Integer;
begin
  pikAutoOpenFlag := $00010000;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    if not Reg.OpenKey('\'+inFileType, true) then
      raise Exception.Create(cExceptMsg);
    if inAutoOpenFromIE then
      Reg.WriteBinaryData('EditFlags', pikAutoOpenFlag, 4);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

end.