object frmReplace: TfrmReplace
  Left = 249
  Top = 113
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Replace Text'
  ClientHeight = 297
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 52
    Height = 13
    Caption = '&Search for:'
  end
  object Label2: TLabel
    Left = 8
    Top = 41
    Width = 65
    Height = 13
    Caption = '&Replace with:'
  end
  object cboSearchText: TComboBox
    Left = 96
    Top = 8
    Width = 225
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 90
    Top = 267
    Width = 75
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 249
    Top = 267
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object cboReplaceText: TComboBox
    Left = 96
    Top = 37
    Width = 225
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object optScope: TRadioGroup
    Left = 8
    Top = 192
    Width = 153
    Height = 65
    Caption = 'Scope'
    ItemIndex = 0
    Items.Strings = (
      '&Global'
      '&Selected Text')
    TabOrder = 4
  end
  object optOrigin: TRadioGroup
    Left = 168
    Top = 192
    Width = 153
    Height = 65
    Caption = 'Origin'
    ItemIndex = 0
    Items.Strings = (
      '&From Cursor'
      '&Entire Scope')
    TabOrder = 5
  end
  object optDirection: TRadioGroup
    Left = 170
    Top = 72
    Width = 151
    Height = 113
    Caption = 'Direction'
    ItemIndex = 0
    Items.Strings = (
      '&Forward'
      '&Backward')
    TabOrder = 3
  end
  object gbSearchOptions: TGroupBox
    Left = 8
    Top = 72
    Width = 154
    Height = 113
    Caption = 'Options'
    TabOrder = 2
    object chkSearchCaseSensitive: TCheckBox
      Left = 8
      Top = 17
      Width = 140
      Height = 17
      Caption = 'C&ase Sensitive'
      TabOrder = 0
    end
    object chkSearchWholeWords: TCheckBox
      Left = 8
      Top = 39
      Width = 140
      Height = 17
      Caption = '&Whole Words Only'
      TabOrder = 1
    end
    object chkRegularExpression: TCheckBox
      Left = 8
      Top = 62
      Width = 140
      Height = 17
      Caption = '&Regular Expression'
      TabOrder = 2
    end
    object chkPrompt: TCheckBox
      Left = 8
      Top = 85
      Width = 140
      Height = 17
      Caption = '&Prompt on Repalce'
      TabOrder = 3
    end
  end
  object btnReplaceAll: TButton
    Left = 170
    Top = 266
    Width = 75
    Height = 23
    Caption = 'Replace All'
    ModalResult = 1
    TabOrder = 7
    OnClick = btnReplaceAllClick
  end
end
