TSynLuaSyn
tk
Sensitive '_', 'a'..'z', 'A'..'Z':: '_', '0'..'9', 'a'..'z', 'A'..'Z'::

TOKENTYPES
Identifier
Key Style=[fsBold]
Comment Style=[fsItalic]|Foreground=clGray
LuaMString Foreground=clNavy
Space
String Foreground=clNavy
|><|

KEYS
and
break
do
else
elseif
end
for
function
if
in
local
nil
not
or
repeat
return
then
until
while
true
false
|><|

CHARS
'A'..'Z', 'a'..'z', '_':: Ident
BeginProc
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
EndProc
|><|

ENCLOSEDBY
Comment,LuaComment,--,@гдг@вг@
Comment,LuaMComment,--[[,]],Multiline
Comment,LuaMString,[[,]],Multiline
String,String1,","
String,String2,','

|><|