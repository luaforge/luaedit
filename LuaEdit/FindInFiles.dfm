object frmFindInFiles: TfrmFindInFiles
  Left = 485
  Top = 245
  BorderStyle = bsSingle
  Caption = 'Find Text'
  ClientHeight = 313
  ClientWidth = 336
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
    C6C6C6000000000000000000000000000000000000000000C6C6C60000000000
    0000000000000000000000000000000000000000000084848400000000000000
    0000848484000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000C6C6C6000000000000000000000000C6
    C6C6000000000000000000000000000000000000000000000000000000000000
    C6C6C6000000000000000000000000C6C6C60000000000000000000000008484
    8400000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000C6C6C600FFFF00000000FFFF000000
    0000000000000000000000008484840000000000000000000000000000000000
    0000FFFF00000000FFFFC6C6C600FFFFC6C6C600000000000000FFFF00000000
    0000000000000000000000000000000000C6C6C600FFFFC6C6C600FFFF840000
    00FFFF000000000000C6C6C60000000000000000000000000000000000000000
    0000FFFFC6C6C600FFFF84000000FFFFC6C6C600000000000000FFFF00000000
    0000000000000000000000000000000000C6C6C600FFFF84000000FFFFC6C6C6
    00FFFFC6C6C600FFFFC6C6C60000000000000000000000000000000000000000
    0000FFFFC6C6C600FFFFC6C6C600FFFFC6C6C600FFFFC6C6C600FFFF00000000
    0000000000000000000000000000000000C6C6C600FFFF848484000000000000
    0000000000000000000000008484840000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000F8F8
    0000F8F80000F8700000F8000000F8000000F800000000000000000000000013
    00000013000000130000001F0000001F0000001F00008FFF0000FFFF0000}
  OldCreateOrder = False
  Position = poOwnerFormCenter
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
  object cboSearchInFilesText: TComboBox
    Left = 96
    Top = 8
    Width = 233
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
  object fraDirectory: TGroupBox
    Left = 8
    Top = 136
    Width = 321
    Height = 81
    Caption = 'Directory Options'
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 32
      Width = 45
      Height = 13
      Caption = 'Dir&ectory:'
    end
    object jvdirDirectory: TJvDirectoryEdit
      Left = 64
      Top = 28
      Width = 249
      Height = 21
      DialogKind = dkWin32
      DialogText = 'Select a Directory'
      ButtonWidth = 20
      TabOrder = 0
      Text = 'C:\'
    end
    object chkIncludeSubdir: TCheckBox
      Left = 64
      Top = 56
      Width = 153
      Height = 17
      Caption = 'Include s&ubdirectories'
      TabOrder = 1
    end
  end
  object optOutput: TRadioGroup
    Left = 8
    Top = 224
    Width = 321
    Height = 49
    Caption = 'Output'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Find Output 1'
      'Find Output 2')
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 170
    Top = 283
    Width = 75
    Height = 23
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 249
    Top = 283
    Width = 75
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object fraWhere: TGroupBox
    Left = 168
    Top = 40
    Width = 161
    Height = 89
    Caption = 'Where'
    TabOrder = 6
    object jvoptFilesInDir: TJvRadioButton
      Left = 8
      Top = 64
      Width = 107
      Height = 17
      Alignment = taLeftJustify
      Caption = 'All files in directory'
      TabOrder = 0
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      LinkedControls = <>
    end
    object jvoptActiveProject: TJvRadioButton
      Left = 8
      Top = 16
      Width = 131
      Height = 17
      Alignment = taLeftJustify
      Caption = 'All files in active project'
      Checked = True
      TabOrder = 1
      TabStop = True
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      LinkedControls = <>
    end
    object jvoptOpenFiles: TJvRadioButton
      Left = 8
      Top = 40
      Width = 80
      Height = 17
      Alignment = taLeftJustify
      Caption = 'All open files'
      TabOrder = 2
      HotTrackFont.Charset = DEFAULT_CHARSET
      HotTrackFont.Color = clWindowText
      HotTrackFont.Height = -11
      HotTrackFont.Name = 'MS Sans Serif'
      HotTrackFont.Style = []
      LinkedControls = <>
    end
  end
end
