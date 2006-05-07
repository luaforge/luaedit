object frmGUID: TfrmGUID
  Left = 407
  Top = 298
  BorderStyle = bsSingle
  Caption = 'Create GUID'
  ClientHeight = 72
  ClientWidth = 416
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object txtGUID: TEdit
    Left = 8
    Top = 8
    Width = 401
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 336
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 1
  end
  object btnGenerate: TButton
    Left = 256
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Generate'
    Default = True
    TabOrder = 2
    OnClick = btnGenerateClick
  end
end
