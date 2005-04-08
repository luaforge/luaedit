object frmReadOnlyMsgBox: TfrmReadOnlyMsgBox
  Left = 389
  Top = 287
  AutoSize = True
  BorderStyle = bsSingle
  Caption = 'frmReadOnlyMsgBox'
  ClientHeight = 89
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgIcon: TImage
    Left = 29
    Top = 8
    Width = 33
    Height = 33
  end
  object lblMessage: TLabel
    Left = 82
    Top = 18
    Width = 112
    Height = 13
    Caption = 'Set the message here...'
  end
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 29
    Height = 13
    AutoSize = False
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 56
    Width = 295
    Height = 33
    BevelOuter = bvNone
    TabOrder = 0
    object Button3: TButton
      Left = 105
      Top = 5
      Width = 85
      Height = 25
      Caption = 'Save &As...'
      ModalResult = 6
      TabOrder = 1
    end
    object Button2: TButton
      Left = 13
      Top = 5
      Width = 85
      Height = 25
      Caption = '&Overwrite'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button1: TButton
      Left = 197
      Top = 5
      Width = 85
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
