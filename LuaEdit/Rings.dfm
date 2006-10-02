object frmRings: TfrmRings
  Left = 492
  Top = 294
  Width = 343
  Height = 271
  BorderStyle = bsSizeToolWin
  Caption = 'Rings'
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
  object jvRings: TJvOutlookBar
    Left = 0
    Top = 0
    Width = 335
    Height = 244
    Align = alClient
    Pages = <
      item
        Alignment = taLeftJustify
        Buttons = <>
        ButtonSize = olbsSmall
        Caption = 'Files'
        DownFont.Charset = DEFAULT_CHARSET
        DownFont.Color = clWindowText
        DownFont.Height = -11
        DownFont.Name = 'MS Sans Serif'
        DownFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentButtonSize = False
        ParentColor = True
        TopButtonIndex = 0
      end
      item
        Alignment = taLeftJustify
        Buttons = <>
        ButtonSize = olbsLarge
        Caption = 'Clipboard'
        DownFont.Charset = DEFAULT_CHARSET
        DownFont.Color = clWindowText
        DownFont.Height = -11
        DownFont.Name = 'MS Sans Serif'
        DownFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = True
        TopButtonIndex = 0
      end
      item
        Alignment = taLeftJustify
        Buttons = <>
        ButtonSize = olbsLarge
        Caption = 'Internal Browser History'
        DownFont.Charset = DEFAULT_CHARSET
        DownFont.Color = clWindowText
        DownFont.Height = -11
        DownFont.Name = 'MS Sans Serif'
        DownFont.Style = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = True
        TopButtonIndex = 0
      end>
    ThemedBackground = False
    OnCustomDraw = jvRingsCustomDraw
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmLuaEditMain.jvDockVSNet
    Left = 16
    Top = 112
  end
end
