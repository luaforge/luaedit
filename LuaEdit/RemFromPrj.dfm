object frmRemoveFile: TfrmRemoveFile
  Left = 390
  Top = 359
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Remove Unit'
  ClientHeight = 120
  ClientWidth = 361
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
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 77
    Height = 13
    Caption = 'Unit to Remove:'
  end
  object btnCancel: TButton
    Left = 278
    Top = 88
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 198
    Top = 88
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cboUnit: TComboBox
    Left = 24
    Top = 40
    Width = 313
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
end
