object frmGotoLine: TfrmGotoLine
  Left = 249
  Top = 113
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Go to Line'
  ClientHeight = 89
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 63
    Height = 13
    Caption = 'Line Number:'
  end
  object txtLineNumber: TEdit
    Left = 16
    Top = 24
    Width = 249
    Height = 21
    MaxLength = 10
    TabOrder = 0
    OnKeyPress = txtLineNumberKeyPress
  end
  object btnOK: TButton
    Left = 112
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 192
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
