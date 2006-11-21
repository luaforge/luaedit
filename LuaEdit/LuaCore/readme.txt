===============================================================================
                                Lua for Delphi
                                
===============================================================================
Authors :
   Massimo Magnano      :  max.maxm@tiscali.it
   Jean-François Goulet :  gouletje@vif.com
   Kuma                 :  kuma@webj.net

Supported Delphi Versions :
  >= 6.0 

-------------------------------------------------------------------------------

MaxM :  I Use some common functions\classes implemented in the units under
        the folder "Common", include this folder in your search directory
        or simple move this files to a directory visible to delphi ide.
        
        RTDebug is a program to view assertions (useful in a place where you
         cannot do a debug), you can download here 
         
         http://www.sortinonline.it/download/software/RTDebug/RunTimeDebug.zip
        
        For any questions contact-me.

-------------------------------------------------------------------------------

History
v1.2 MaxM Adds : Units to access some functions from lua scripts 
                  Lua_DB, Lua_Files, Lua_FunctionsLog, Lua_VCL (experimental)
v1.1
     MaxM Adds :
             LuaPCallFunction

v1.0
     MaxM Adds :
             LuaPushVariant
             LuaToVariant
             LuaGetTableInteger, LuaGet\SetTableTMethod
             LuaLoadBufferFromFile
     Solved Bugs : Stack problem in LuaProcessTableName
                   LuaToInteger why Round?, Trunc is better

v0.07	2004/10/03 First Release by kuma@webj.net

===============================================================================
