object frmSearch: TfrmSearch
  Left = 249
  Top = 113
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Search Text'
  ClientHeight = 241
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
  object cboSearchText: TComboBox
    Left = 96
    Top = 8
    Width = 225
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object gbSearchOptions: TGroupBox
    Left = 8
    Top = 40
    Width = 154
    Height = 89
    Caption = 'Options'
    TabOrder = 1
    object chkSearchCaseSensitive: TCheckBox
      Left = 8
      Top = 17
      Width = 140
      Height = 17
      Caption = 'C&ase sensitivity'
      TabOrder = 0
    end
    object chkSearchWholeWords: TCheckBox
      Left = 8
      Top = 39
      Width = 140
      Height = 17
      Caption = '&Whole words only'
      TabOrder = 1
    end
    object chkRegularExpression: TCheckBox
      Left = 8
      Top = 62
      Width = 140
      Height = 17
      Caption = '&Regular expression'
      TabOrder = 2
    end
  end
  object optDirection: TRadioGroup
    Left = 170
    Top = 40
    Width = 151
    Height = 89
    Caption = 'Direction'
    ItemIndex = 0
    Items.Strings = (
      '&Forward'
      '&Backward')
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 170
    Top = 211
    Width = 75
    Height = 23
    Caption = 'OK'
    Default = True
    TabOrder = 5
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 249
    Top = 211
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object optScope: TRadioGroup
    Left = 8
    Top = 136
    Width = 153
    Height = 65
    Caption = 'Scope'
    ItemIndex = 0
    Items.Strings = (
      '&Global'
      '&Selected Text')
    TabOrder = 3
  end
  object optOrigin: TRadioGroup
    Left = 168
    Top = 136
    Width = 153
    Height = 65
    Caption = 'Origin'
    ItemIndex = 0
    Items.Strings = (
      '&From Cursor'
      '&Entire Scope')
    TabOrder = 4
  end
end
