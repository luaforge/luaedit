object frmWatch: TfrmWatch
  Left = 444
  Top = 272
  Width = 335
  Height = 150
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lvwWatch: TStringGrid
    Left = 0
    Top = 0
    Width = 327
    Height = 116
    Align = alClient
    ColCount = 2
    Ctl3D = False
    DefaultColWidth = 150
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 99
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    ParentCtl3D = False
    ParentFont = False
    PopupMenu = ppmWatch
    TabOrder = 0
    OnKeyDown = lvwWatchKeyDown
    OnKeyPress = lvwWatchKeyPress
    OnSetEditText = lvwWatchSetEditText
  end
  object memoSwap: TMemo
    Left = 40
    Top = 24
    Width = 145
    Height = 49
    Lines.Strings = (
      'memoSwap')
    TabOrder = 1
    Visible = False
  end
  object ppmWatch: TPopupMenu
    Images = frmMain.imlActions
    Left = 8
    Top = 24
  end
  object JvDockClient1: TJvDockClient
    LRDockWidth = 100
    TBDockHeight = 100
    DirectDrag = False
    ShowHint = True
    EnableCloseButton = True
    DockStyle = frmMain.jvDockVSNet
    Left = 8
    Top = 56
  end
end
