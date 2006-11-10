object FormOptions: TFormOptions
  Left = 309
  Top = 232
  Width = 312
  Height = 206
  Caption = 'Run Time Debug Options...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btBrowseFile: TSpeedButton
    Left = 264
    Top = 56
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = btBrowseFileClick
  end
  object edLogFilename: TLabeledEdit
    Left = 32
    Top = 56
    Width = 225
    Height = 21
    EditLabel.Width = 88
    EditLabel.Height = 13
    EditLabel.Caption = 'Save Log On File :'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 80
    Top = 136
    Width = 75
    Height = 25
    Caption = '&Ok'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 136
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object cbLogOnFile: TCheckBox
    Left = 16
    Top = 16
    Width = 97
    Height = 17
    Caption = 'Log On File'
    TabOrder = 3
    OnClick = cbLogOnFileClick
  end
  object dlgSaveLog: TSaveDialog
    Title = 'Select Log File'
    Left = 272
    Top = 24
  end
end
