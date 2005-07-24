object frmSearch: TfrmSearch
  Left = 450
  Top = 224
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Find Text'
  ClientHeight = 241
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001001800680300001600000028000000100000002000
    0000010018000000000040030000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000FFFFFF000000000000000000000000
    000000000000000000000000000000FFFFFF0000000000000000000000000000
    00FFFFFF000000000000000000000000000000000000000000000000000000FF
    FFFF000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000FFFFFF000000000000000000000000000000000000FFFFFF00000000
    0000000000000000000000000000000000000000FFFFFF000000000000000000
    C6C6C6000000000000FFFFFF0000000000000000000000000000000000000000
    00000000FFFFFF000000000000000000C6C6C6000000000000FFFFFF00000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000FFFFFF000000000000000000000000000000FFFFFF00000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000FFFFFF000000
    000000000000000000000000FFFFFF0000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF000007C1000007C1000007C100000101000000010000000100000001
    000080030000C1070000C1070000E38F0000E38F0000E38F0000FFFF0000}
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 12
    Width = 49
    Height = 13
    Caption = '&Find what:'
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
