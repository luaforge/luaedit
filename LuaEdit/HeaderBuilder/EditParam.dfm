object frmEditParam: TfrmEditParam
  Left = 391
  Top = 315
  BorderStyle = bsToolWindow
  Caption = 'Edit Parameter'
  ClientHeight = 128
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    272
    128)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object Label2: TLabel
    Left = 16
    Top = 52
    Width = 47
    Height = 13
    Caption = 'Comment:'
  end
  object btnCancel: TButton
    Left = 190
    Top = 96
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 110
    Top = 96
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object txtName: TEdit
    Left = 16
    Top = 22
    Width = 241
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object txtComment: TEdit
    Left = 16
    Top = 66
    Width = 241
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
end
