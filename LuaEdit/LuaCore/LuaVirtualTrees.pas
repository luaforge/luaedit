//******************************************************************************
//***                     LUA SCRIPT DELPHI UTILITIES                        ***
//***                                                                        ***
//***        (c) 2006 Jean-François Goulet                                   ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : LuaVirtualTrees.pas
//
//  Description : ? 
//
//******************************************************************************
//** See Copyright Notice in lua.h

//Revision 0.1
//     JF Adds :
//             LuaTableToVirtualTreeView
//

Unit LuaVirtualTrees;

interface

Uses SysUtils, Classes, lua, LuaUtils, VirtualTrees;


type
  PBasicTreeData = ^TBasicTreeData;
  TBasicTreeData = record
    sName: String;
    sValue: String;
  end;

procedure LuaTableToVirtualTreeView(L: Plua_State; Index: Integer; VTV: TVirtualStringTree; MaxTable: Integer; SubTableMax: Integer);

var
  SubTableCount: Integer;
  SubTableCount2: Integer;
  
implementation  

procedure LuaTableToVirtualTreeView(L: Plua_State; Index: Integer; VTV: TVirtualStringTree; MaxTable: Integer; SubTableMax: Integer);
var
  pGLobalsIndexPtr: Pointer;
  
  // Go through all child of current table and create nodes
  procedure ParseTreeNode(TreeNode: PVirtualNode; Index: Integer);
  var
    Key: string;
    pData: PBasicTreeData;
    pNode: PVirtualNode;
  begin
    // Retreive absolute index 
    Index := LuaAbsIndex(L, Index);


    lua_pushnil(L);
    while (lua_next(L, Index) <> 0) do
    begin
      Key := Dequote(LuaStackToStr(L, -2, MaxTable, SubTableMax));
      if lua_type(L, -1) <> LUA_TTABLE then
      begin
        pData := VTV.GetNodeData(VTV.AddChild(TreeNode));
        pData.sName := Key;
        pData.sValue := LuaStackToStr(L, -1, MaxTable, SubTableMax);
      end
      else
      begin
        if ((Key = '_G') or (lua_topointer(L, -1) = pGLobalsIndexPtr)) then
        begin
          pData := VTV.GetNodeData(VTV.AddChild(TreeNode));
          pData.sName := Key;
          pData.sValue := '[LUA_GLOBALSINDEX]';
        end
        else
        begin
          pNode := VTV.AddChild(TreeNode);
          pData := VTV.GetNodeData(pNode);
          pData.sName := Key;
          pData.sValue := LuaStackToStr(L, -1, MaxTable, SubTableMax);

          if SubTableCount < SubTableMax then
          begin
            SubTableCount := SubTableCount + 1;
            ParseTreeNode(pNode, -1);
            SubTableCount := SubTableCount - 1;
          end;
        end;
      end;
        lua_pop(L, 1);
    end;
  end;
begin
  Assert(lua_type(L, Index) = LUA_TTABLE);
  lua_checkstack(L, SubTableMax * 3); // Ensure there is enough space on stack to work with according to user's setting
  pGLobalsIndexPtr := lua_topointer(L, LUA_GLOBALSINDEX); // Retrieve globals index pointer for later conditions
  VTV.BeginUpdate;
  VTV.Clear;
  try
    ParseTreeNode(nil, Index);
  finally
    VTV.EndUpdate;
  end;
end;

end.