object frmGUIInspector: TfrmGUIInspector
  Left = 660
  Top = 195
  Width = 230
  Height = 342
  BorderStyle = bsSizeToolWin
  Caption = 'GUI Inspector'
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
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 222
    Height = 290
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object TabControl1: TTabControl
      Left = 0
      Top = 0
      Width = 222
      Height = 290
      Align = alClient
      TabOrder = 0
      Tabs.Strings = (
        'Properties'
        'Events')
      TabIndex = 0
      object ELGUIPropertyInspector: TELPropertyInspector
        Left = 4
        Top = 24
        Width = 214
        Height = 262
        Splitter = 84
        Align = alClient
        TabOrder = 0
        OnFilterProp = ELGUIPropertyInspectorFilterProp
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 222
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      222
      25)
    object cboGUIElements: TComboBox
      Left = 2
      Top = 1
      Width = 218
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmLuaEditMain.jvDockVSNet
    Left = 8
    Top = 24
  end
end
