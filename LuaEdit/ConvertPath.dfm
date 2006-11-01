object frmConvertPath: TfrmConvertPath
  Left = 443
  Top = 357
  BorderStyle = bsSingle
  Caption = 'Convert Path'
  ClientHeight = 100
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
  DesignSize = (
    416
    100)
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 335
    Top = 70
    Width = 76
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Close'
    ModalResult = 1
    TabOrder = 0
  end
  object btnConvert: TButton
    Left = 255
    Top = 70
    Width = 76
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Convert'
    Default = True
    TabOrder = 1
    OnClick = btnConvertClick
  end
  object txtPathToConvert: TEdit
    Left = 7
    Top = 8
    Width = 383
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object btnBrowsePath: TButton
    Left = 395
    Top = 12
    Width = 16
    Height = 16
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 3
    OnClick = btnBrowsePathClick
  end
  object txtConvertedPath: TEdit
    Left = 8
    Top = 40
    Width = 401
    Height = 21
    Color = cl3DLight
    ReadOnly = True
    TabOrder = 4
  end
  object jvSelectDir: TJvBrowseForFolderDialog
    Title = 'Select Directory'
    Left = 8
    Top = 64
  end
end
