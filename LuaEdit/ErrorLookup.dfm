object frmErrorLookup: TfrmErrorLookup
  Left = 471
  Top = 363
  Width = 318
  Height = 221
  Caption = 'Error Lookup'
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
  object Panel1: TPanel
    Left = 0
    Top = 119
    Width = 310
    Height = 68
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      310
      68)
    object txtErrorLookup: TEdit
      Left = 8
      Top = 10
      Width = 295
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      AutoSelect = False
      TabOrder = 0
      OnKeyPress = txtErrorLookupKeyPress
    end
    object btnLookUp: TButton
      Left = 148
      Top = 37
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Lookup'
      Default = True
      TabOrder = 1
      OnClick = btnLookUpClick
    end
    object btnClose: TButton
      Left = 228
      Top = 37
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Close'
      ModalResult = 1
      TabOrder = 2
      OnClick = btnCloseClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 310
    Height = 119
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 1
    object memoErrorLookup: TMemo
      Left = 8
      Top = 8
      Width = 294
      Height = 103
      Align = alClient
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
