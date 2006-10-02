object frmLuaGlobals: TfrmLuaGlobals
  Left = 481
  Top = 239
  Width = 434
  Height = 188
  BorderStyle = bsSizeToolWin
  Caption = 'Lua Globals'
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object vstGlobals: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 426
    Height = 161
    Align = alClient
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning]
    OnGetText = vstGlobalsGetText
    OnGetNodeDataSize = vstGlobalsGetNodeDataSize
    Columns = <
      item
        Position = 0
        Width = 100
        WideText = 'Name'
      end
      item
        Position = 1
        Width = 322
        WideText = 'Value'
      end>
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmLuaEditMain.jvDockVSNet
    Left = 16
    Top = 24
  end
end
