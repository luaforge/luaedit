object frmPrintSetup: TfrmPrintSetup
  Left = 492
  Top = 325
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Print Setup'
  ClientHeight = 129
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 88
    Width = 329
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    DesignSize = (
      329
      41)
    object btnCancel: TButton
      Left = 249
      Top = 11
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 2
    end
    object btnOk: TButton
      Left = 169
      Top = 11
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOkClick
    end
    object Button1: TButton
      Left = 7
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Advanced...'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object chkUseColors: TCheckBox
    Left = 16
    Top = 16
    Width = 97
    Height = 17
    Caption = 'Use Colors'
    TabOrder = 0
  end
  object chkUseHighLight: TCheckBox
    Left = 16
    Top = 40
    Width = 121
    Height = 17
    Caption = 'Use Syntax Highlight'
    TabOrder = 1
  end
  object chkShowLineNumbers: TCheckBox
    Left = 160
    Top = 16
    Width = 129
    Height = 17
    Caption = 'Show Line Numbers'
    TabOrder = 3
  end
  object chkWrapLines: TCheckBox
    Left = 16
    Top = 64
    Width = 97
    Height = 17
    Caption = 'Wrap Lines'
    TabOrder = 2
  end
  object chkLineNumbersInMargin: TCheckBox
    Left = 160
    Top = 40
    Width = 161
    Height = 17
    Caption = 'Print Line Numbers in Margin'
    TabOrder = 4
  end
  object psdlgPrinterSetup: TPrinterSetupDialog
    Left = 160
    Top = 65
  end
end
