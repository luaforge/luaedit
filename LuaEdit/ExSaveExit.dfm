object frmExSaveExit: TfrmExSaveExit
  Left = 404
  Top = 227
  Width = 350
  Height = 300
  Caption = 'Save Changes?'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 227
    Width = 342
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      342
      39)
    object Button1: TButton
      Left = 260
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object Button2: TButton
      Left = 180
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&No'
      ModalResult = 7
      TabOrder = 1
    end
    object btnYes: TButton
      Left = 100
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Yes'
      ModalResult = 6
      TabOrder = 2
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 342
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 11
      Top = 16
      Width = 157
      Height = 13
      Caption = 'Save Changes to Selected Files?'
    end
  end
  object lstFiles: TJvDotNetListBox
    Left = 0
    Top = 41
    Width = 342
    Height = 186
    Align = alClient
    ItemHeight = 13
    Background.FillMode = bfmTile
    Background.Visible = False
    MultiSelect = True
    TabOrder = 2
  end
end
