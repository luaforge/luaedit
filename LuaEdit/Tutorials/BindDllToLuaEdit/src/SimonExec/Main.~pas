unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Lua, LuaUtils, LAuxLib, LuaLib, StdCtrls;

var
  L: Plua_State;

type
  TInitializer = function(L: PLua_State): Integer; cdecl;
  PTInitializer = ^TInitializer;

  TfrmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ExecuteInitializer(sInitializer: String; L: PLua_State): Integer;
    procedure CallHookFunc(L: Plua_State; AR: Plua_Debug);
  end;

procedure HookCaller(L: Plua_State; AR: Plua_Debug); cdecl;
procedure SetAppHandle(Handle: HWND); cdecl; external 'Simon.dll';

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

function TfrmMain.ExecuteInitializer(sInitializer: String; L: PLua_State): Integer;
var
  Ptr: TFarProc;
  pFunc: TInitializer;
  iFuncReturn: Integer;
  hModule: Cardinal;
begin
  try
    hModule := LoadLibrary(PChar(sInitializer));
    Ptr := GetProcAddress(hModule, 'LuaDebug_Initializer');
    pFunc := TInitializer(Ptr);
    iFuncReturn := pFunc(L);

    Result := iFuncReturn;
  except
    Result := -1;
    
    if hModule <> NULL then
      FreeLibrary(hModule);

    Application.MessageBox(PChar('An error occured when attempting to call the initializer from "'+sInitializer+'".'), 'LuaEdit', MB_ICONERROR+MB_OK);
  end;
end;

procedure TfrmMain.CallHookFunc(L: Plua_State; AR: Plua_Debug);
begin
  lua_getinfo(L, 'Snlu', AR);
end;

procedure HookCaller(L: Plua_State; AR: Plua_Debug); cdecl;
begin
  frmMain.CallHookFunc(L, AR);
  Application.ProcessMessages;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Initialize the Plua_State structure
  L := lua_open();
  lua_baselibopen(L);
  luaopen_loadlib(L);
  lua_tablibopen(L);
  luaopen_io(L);
  luaopen_string(L);
  luaopen_math(L);
  luaopen_debug(L);
  lua_sethook(L, HookCaller, LUA_MASKCALL or LUA_MASKRET or LUA_MASKLINE, 0);

  // Calling game's main entry function
  ExecuteInitializer(ExtractFilePath(Application.ExeName)+'Simon.dll', L);
  LuaLoadBufferFromFile(L, ExtractFilePath(Application.ExeName)+'Simon.lua', 'Main');
  LuaPCall(L, 0, 0, 0);
  Self.Free;
end;

end.
