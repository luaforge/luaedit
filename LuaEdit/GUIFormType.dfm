object frmGUIFormType: TfrmGUIFormType
  Left = 543
  Top = 287
  Width = 258
  Height = 150
  BorderIcons = [biSystemMenu]
  Caption = 'Type of Script?'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    250
    123)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 4
    Width = 236
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Please choose the type of script to associate with the GUI Form'
    WordWrap = True
  end
  object Button1: TButton
    Left = 170
    Top = 92
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object optLuaUnit: TRadioButton
    Left = 16
    Top = 43
    Width = 113
    Height = 17
    Caption = 'Lua Unit'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object optLuaMacro: TRadioButton
    Left = 16
    Top = 67
    Width = 113
    Height = 17
    Caption = 'Lua Macro'
    TabOrder = 2
  end
end
