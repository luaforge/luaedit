object frmProjectTree: TfrmProjectTree
  Left = 675
  Top = 184
  Width = 262
  Height = 400
  BorderStyle = bsSizeToolWin
  Caption = 'Project Tree'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 254
    Height = 373
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object vstProjectTree: TVirtualDrawTree
      Left = 0
      Top = 0
      Width = 254
      Height = 373
      Align = alClient
      Header.AutoSizeIndex = 1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
      Header.Style = hsFlatButtons
      PopupMenu = ppmProjectTree
      TabOrder = 0
      TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      OnAfterItemPaint = vstProjectTreeAfterItemPaint
      OnDblClick = vstProjectTreeDblClick
      OnDrawNode = vstProjectTreeDrawNode
      OnGetNodeDataSize = vstProjectTreeGetNodeDataSize
      OnInitNode = vstProjectTreeInitNode
      OnKeyDown = vstProjectTreeKeyDown
      OnMouseDown = vstProjectTreeMouseDown
      Columns = <
        item
          Position = 0
          Width = 100
          WideText = 'Files'
        end
        item
          Position = 1
          Width = 150
          WideText = 'Path'
        end>
    end
  end
  object ppmProjectTree: TPopupMenu
    Images = frmLuaEditMain.imlActions
    OnPopup = ppmProjectTreePopup
    Left = 8
    Top = 72
    object N3: TMenuItem
      Caption = 'Save'
      ImageIndex = 5
      OnClick = N3Click
    end
    object SaveAs1: TMenuItem
      Caption = 'Save As...'
      ImageIndex = 7
      OnClick = SaveAs1Click
    end
    object mnuFindTarget: TMenuItem
      Caption = 'Find Target...'
      OnClick = mnuFindTargetClick
    end
    object UnloadFileProject1: TMenuItem
      Caption = 'Unload File/Project'
      OnClick = UnloadFileProject1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object ActivateSelectedProject1: TMenuItem
      Action = frmLuaEditMain.actActiveSelPrj
    end
    object AddUnittoProject1: TMenuItem
      Action = frmLuaEditMain.actAddToPrj
    end
    object RemoveUnitFromProject1: TMenuItem
      Action = frmLuaEditMain.actRemoveFromPrj
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Options1: TMenuItem
      Action = frmLuaEditMain.actPrjSettings
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmLuaEditMain.jvDockVSNet
    Left = 8
    Top = 40
  end
  object SystemImages: TImageList
    Left = 40
    Top = 40
  end
  object StatesImages: TImageList
    Left = 40
    Top = 72
  end
end
