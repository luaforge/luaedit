(*
** $Id: LuaConf.pas,v 1.1 2006-11-21 00:36:22 jfgoulet Exp $
** Configuration file for Lua
** See Copyright Notice in lua.h
**
**   Translation form C and Delphi adaptation of Code : 
**     Massimo Magnano, Jean-Francois Goulet 2006
*)

unit luaconf;

interface

type
    ptrdiff_t = Integer;
(*
@@ LUA_INTEGER is the integral type used by lua_pushinteger/lua_tointeger.
** CHANGE that if ptrdiff_t is not adequate on your machine. (On most
** machines, ptrdiff_t gives a good choice between int or long.)
*)
    LUA_INTEGER = ptrdiff_t;

const
(*
@@ LUA_IDSIZE gives the maximum size for the description of the source
@* of a function in debug information.
** CHANGE it if you want a different size.
*)
    LUA_IDSIZE = 60;

(*
@@ LUA_COMPAT_OPENLIB controls compatibility with old 'luaL_openlib'
@* behavior.
** CHANGE it to undefined as soon as you replace to 'luaL_registry'
** your uses of 'luaL_openlib'
*)
    {$define LUA_COMPAT_OPENLIB}

(*
@@ LUAL_BUFFERSIZE is the buffer size used by the lauxlib buffer system.
*)
   BUFSIZ = 1024;
   LUAL_BUFFERSIZE = BUFSIZ;

(* }================================================================== *)

(*
@@ LUA_PROMPT is the default prompt used by stand-alone Lua.
@@ LUA_PROMPT2 is the default continuation prompt used by stand-alone Lua.
** CHANGE them if you want different prompts. (You can also change the
** prompts dynamically, assigning to globals _PROMPT/_PROMPT2.)
*)
const
  LUA_PROMPT  = '> ';
  LUA_PROMPT2 = '>> ';

type
(*
** {==================================================================
@@ LUA_NUMBER is the type of numbers in Lua.
** CHANGE the following definitions only if you want to build Lua
** with a number type different from double. You may also need to
** change lua_number2int & lua_number2integer.
** ===================================================================
*)
   {$define LUA_NUMBER_DOUBLE}
    LUA_NUMBER = Double;

const
(*
@@ LUA_NUMBER_SCAN is the format for reading numbers.
@@ LUA_NUMBER_FMT is the format for writing numbers.
@@ lua_number2str converts a number to a string.
@@ LUAI_MAXNUMBER2STR is maximum size of previous conversion.
@@ lua_str2number converts a string to a number.
*)
  LUA_NUMBER_SCAN = '%lf';
  LUA_NUMBER_FMT = '%.14g';

(*
@@ lua_readline defines how to show a prompt and then read a line from
@* the standard input.
@@ lua_saveline defines how to "save" a read line in a "history".
@@ lua_freeline defines how to free a line read by lua_readline.
** CHANGE them if you want to improve this functionality (e.g., by using
** GNU readline and history facilities).

function  lua_readline(L : Plua_State; var b : PChar; p : PChar): Boolean;
procedure lua_saveline(L : Plua_State; idx : Integer);
procedure lua_freeline(L : Plua_State; b : PChar);
*)
const
  lua_stdin_is_tty = TRUE;


implementation

(*
function  lua_readline(L : Plua_State; var b : PChar; p : PChar): Boolean;
var
  s : String;
begin
  Write(p);                        // show prompt
  ReadLn(s);                       // get line
  b := PChar(s);                   //   and return it
  result := (b[0] <> #4);          // test for ctrl-D
end;

procedure lua_saveline(L : Plua_State; idx : Integer);
begin
end;

procedure lua_freeline(L : Plua_State; b : PChar);
begin
end;
*)

end.
