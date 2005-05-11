unit HdrBldMain;

interface

uses
  Windows, Messages, SysUtils, Controls, Forms, Themes, UxTheme;

function FunctionHeaderBuilder(OwnerAppHandle: HWND; sLine: PChar): PChar; stdcall;

implementation

uses
  FctHdrBld;

function FunctionHeaderBuilder(OwnerAppHandle: HWND; sLine: PChar): PChar; stdcall;
begin
  // leave those important lines here...
  // There is a bug with the themes and forms placed in dll
  // The dll don't have the time to free the theme handle and the when it does it,
  // the hoset application (LuaEdit) already did it so... Runtime Error 216
  ThemeServices.ApplyThemeChange;
  InitThemeLibrary;

  // Create the form first
  Application.Handle := OwnerAppHandle;
  frmFctHdrBld := TfrmFctHdrBld.Create(nil);

  if sLine <> '' then
    frmFctHdrBld.ParseLine(StrPas(sLine));

  if frmFctHdrBld.ShowModal = mrOk then
  begin
    Result := PChar(frmFctHdrBld.GetHeader);
  end
  else
    Result := '';

  FreeAndNil(frmFctHdrBld);

  // leave those important lines here...
  // There is a bug with the themes and forms placed in dll
  // The dll don't have the time to free the theme handle and the when it does it,
  // the hoset application (LuaEdit) already did it so... Runtime Error 216
  ThemeServices.ApplyThemeChange;
  FreeThemeLibrary;
end;

end.
