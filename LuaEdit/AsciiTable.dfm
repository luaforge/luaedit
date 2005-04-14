object frmAsciiTable: TfrmAsciiTable
  Left = 416
  Top = 215
  Width = 400
  Height = 475
  Caption = 'Ascii Table'
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
    Top = 400
    Width = 392
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      392
      41)
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 83
      Height = 13
      Caption = 'Enter Ascii Value:'
    end
    object btnClose: TButton
      Left = 312
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Close'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnGetValue: TButton
      Left = 232
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Get Value'
      TabOrder = 1
      OnClick = btnGetValueClick
    end
    object txtAscii: TEdit
      Left = 96
      Top = 12
      Width = 25
      Height = 21
      MaxLength = 1
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object memoAsciiTable: TMemo
      Left = 0
      Top = 0
      Width = 392
      Height = 400
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
end
