object frmWatch: TfrmWatch
  Left = 444
  Top = 272
  Width = 300
  Height = 200
  BorderStyle = bsSizeToolWin
  Caption = 'Watch List'
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
  object memoSwap: TMemo
    Left = 40
    Top = 24
    Width = 145
    Height = 49
    Lines.Strings = (
      'memoSwap')
    TabOrder = 0
    Visible = False
  end
  object vstWatch: TVirtualStringTree
    Left = 0
    Top = 24
    Width = 292
    Height = 149
    Align = alClient
    EditDelay = 20
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    Header.Style = hsFlatButtons
    LineStyle = lsSolid
    PopupMenu = ppmWatch
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toEditable, toFullRepaintOnResize, toInitOnSave, toReportMode, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toRightClickSelect]
    OnAfterItemPaint = vstWatchAfterItemPaint
    OnChange = vstWatchChange
    OnCreateEditor = vstWatchCreateEditor
    OnDragOver = vstWatchDragOver
    OnDragDrop = vstWatchDragDrop
    OnEdited = vstWatchEdited
    OnEditing = vstWatchEditing
    OnGetText = vstWatchGetText
    OnGetNodeDataSize = vstWatchGetNodeDataSize
    OnKeyDown = vstWatchKeyDown
    Columns = <
      item
        Position = 0
        Width = 125
        WideText = 'Variable'
      end
      item
        Position = 1
        Width = 163
        WideText = 'Value'
      end>
    WideDefaultText = ''
  end
  object tblWatch: TToolBar
    Left = 0
    Top = 0
    Width = 292
    Height = 24
    AutoSize = True
    Flat = True
    Images = frmMain.imlActions
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object tbtnAddWatch: TToolButton
      Left = 0
      Top = 0
      Hint = 'Add Watch...'
      ImageIndex = 53
      OnClick = tbtnAddWatchClick
    end
    object tbtnDelete: TToolButton
      Left = 23
      Top = 0
      Hint = 'Delete Selected Watch Item'
      Caption = 'tbtnDelete'
      ImageIndex = 62
      OnClick = tbtnDeleteClick
    end
    object ToolButton1: TToolButton
      Left = 46
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object tbtnRefreshWatch: TToolButton
      Left = 54
      Top = 0
      Hint = 'Refresh Watch List'
      ImageIndex = 63
      OnClick = tbtnRefreshWatchClick
    end
  end
  object FEdit: TEdit
    Left = 56
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 3
    Visible = False
    OnKeyDown = FEditKeyDown
  end
  object ppmWatch: TPopupMenu
    Images = frmMain.imlActions
    Left = 48
    Top = 48
    object AddWatch1: TMenuItem
      Action = frmMain.actAddWatch
    end
    object DeleteSelectedItem1: TMenuItem
      Caption = 'Delete Selected Item'
      ImageIndex = 62
      OnClick = DeleteSelectedItem1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      ImageIndex = 63
      OnClick = Refresh1Click
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmMain.jvDockVSNet
    Left = 80
    Top = 48
  end
end
