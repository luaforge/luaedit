object frmLuaConsole: TfrmLuaConsole
  Left = 525
  Top = 385
  Width = 482
  Height = 240
  BorderStyle = bsSizeToolWin
  Caption = 'Lua Console'
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
  object vstLuaOutput: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 474
    Height = 213
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    PopupMenu = ppmLuaOutput
    ScrollBarOptions.AlwaysVisible = True
    TabOrder = 0
    TreeOptions.PaintOptions = [toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect, toRightClickSelect]
    OnDblClick = vstLuaOutputDblClick
    OnGetText = vstLuaOutputGetText
    OnGetNodeDataSize = vstLuaOutputGetNodeDataSize
    Columns = <>
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmLuaEditMain.jvDockVSNet
    Left = 24
    Top = 16
  end
  object ppmLuaOutput: TPopupMenu
    OnPopup = ppmLuaOutputPopup
    Left = 24
    Top = 48
    object SelectAll1: TMenuItem
      Caption = 'Select All'
      OnClick = SelectAll1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
    object FindSource1: TMenuItem
      Caption = 'Find Source...'
      OnClick = FindSource1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Clear1: TMenuItem
      Caption = 'Clear Selected'
      OnClick = Clear1Click
    end
    object ClearAll1: TMenuItem
      Caption = 'Clear All'
      OnClick = ClearAll1Click
    end
  end
end
