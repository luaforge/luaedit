object frmPrjOptions: TfrmPrjOptions
  Left = 516
  Top = 300
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Project Options'
  ClientHeight = 316
  ClientWidth = 531
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
  object Label17: TLabel
    Left = 160
    Top = 120
    Width = 87
    Height = 13
    Caption = 'Runtime Directory:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 275
    Width = 531
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      531
      41)
    object btnCancel: TButton
      Left = 447
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOk: TButton
      Left = 364
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOkClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 531
    Height = 275
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 129
      Top = 0
      Width = 4
      Height = 275
    end
    object jvPageListSettings: TJvPageList
      Left = 133
      Top = 0
      Width = 398
      Height = 275
      ActivePage = JvStandardPage3
      PropagateEnable = False
      ShowDesignCaption = sdcNone
      Align = alClient
      object JvStandardPage1: TJvStandardPage
        Left = 0
        Top = 0
        Width = 398
        Height = 275
        Caption = '[General] Identification'
        object Label1: TLabel
          Left = 24
          Top = 24
          Width = 67
          Height = 13
          Caption = 'Project Name:'
        end
        object Label7: TLabel
          Left = 24
          Top = 72
          Width = 29
          Height = 13
          Caption = 'Major:'
        end
        object Label9: TLabel
          Left = 115
          Top = 72
          Width = 29
          Height = 13
          Caption = 'Minor:'
        end
        object Label10: TLabel
          Left = 205
          Top = 72
          Width = 42
          Height = 13
          Caption = 'Release:'
        end
        object Label11: TLabel
          Left = 296
          Top = 72
          Width = 44
          Height = 13
          Caption = 'Revision:'
        end
        object JvGroupHeader1: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 398
          Height = 17
          Align = alTop
          Caption = 'Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object JvGroupHeader8: TJvGroupHeader
          Left = 0
          Top = 272
          Width = 398
          Height = 3
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object txtPrjName: TEdit
          Left = 24
          Top = 38
          Width = 353
          Height = 21
          TabOrder = 0
        end
        object spinMajorVersion: TJvSpinEdit
          Left = 24
          Top = 86
          Width = 81
          Height = 21
          ButtonKind = bkStandard
          MaxValue = 9999.000000000000000000
          MinValue = 1.000000000000000000
          Value = 1.000000000000000000
          TabOrder = 1
          HideSelection = False
        end
        object spinMinorVersion: TJvSpinEdit
          Left = 115
          Top = 86
          Width = 81
          Height = 21
          ButtonKind = bkStandard
          MaxValue = 9999.000000000000000000
          TabOrder = 2
          HideSelection = False
        end
        object spinReleaseVersion: TJvSpinEdit
          Left = 205
          Top = 86
          Width = 81
          Height = 21
          ButtonKind = bkStandard
          MaxValue = 9999.000000000000000000
          TabOrder = 3
          HideSelection = False
        end
        object spinRevisionVersion: TJvSpinEdit
          Left = 296
          Top = 86
          Width = 81
          Height = 21
          ButtonKind = bkStandard
          MaxValue = 9999.000000000000000000
          TabOrder = 4
          HideSelection = False
        end
        object chkAutoIncRevNumber: TCheckBox
          Left = 24
          Top = 114
          Width = 201
          Height = 17
          Caption = 'Auto-Increment Revision Number'
          TabOrder = 5
        end
      end
      object JvStandardPage2: TJvStandardPage
        Left = 0
        Top = 0
        Width = 398
        Height = 275
        Caption = '[Debug] Remote Debug'
        object Label3: TLabel
          Left = 24
          Top = 24
          Width = 62
          Height = 13
          Caption = 'Port Number:'
        end
        object Label4: TLabel
          Left = 208
          Top = 24
          Width = 54
          Height = 13
          Caption = 'IP Address:'
        end
        object Label5: TLabel
          Left = 247
          Top = 48
          Width = 3
          Height = 13
          Caption = '.'
        end
        object Label6: TLabel
          Left = 294
          Top = 48
          Width = 3
          Height = 13
          Caption = '.'
        end
        object Label12: TLabel
          Left = 342
          Top = 48
          Width = 3
          Height = 13
          Caption = '.'
        end
        object Label13: TLabel
          Left = 24
          Top = 72
          Width = 82
          Height = 13
          Caption = 'Upload Directory:'
        end
        object JvGroupHeader2: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 398
          Height = 17
          Align = alTop
          Caption = 'Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object JvGroupHeader5: TJvGroupHeader
          Left = 0
          Top = 272
          Width = 398
          Height = 3
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label16: TLabel
          Left = 24
          Top = 120
          Width = 103
          Height = 13
          Caption = 'Connection Time-Out:'
        end
        object jvspinPort: TJvSpinEdit
          Left = 24
          Top = 40
          Width = 161
          Height = 21
          MaxValue = 65535.000000000000000000
          MinValue = 1024.000000000000000000
          Value = 1024.000000000000000000
          TabOrder = 0
        end
        object txtIP1: TEdit
          Left = 208
          Top = 40
          Width = 33
          Height = 21
          MaxLength = 3
          TabOrder = 1
          OnExit = txtIP1Exit
          OnKeyPress = txtIP1KeyPress
        end
        object txtIP2: TEdit
          Left = 256
          Top = 40
          Width = 33
          Height = 21
          MaxLength = 3
          TabOrder = 2
          OnExit = txtIP2Exit
          OnKeyPress = txtIP2KeyPress
        end
        object txtIP3: TEdit
          Left = 304
          Top = 40
          Width = 33
          Height = 21
          MaxLength = 3
          TabOrder = 3
          OnExit = txtIP3Exit
          OnKeyPress = txtIP3KeyPress
        end
        object txtIP4: TEdit
          Left = 352
          Top = 40
          Width = 33
          Height = 21
          MaxLength = 3
          TabOrder = 4
          OnExit = txtIP4Exit
          OnKeyPress = txtIP4KeyPress
        end
        object txtUploadDir: TEdit
          Left = 24
          Top = 88
          Width = 361
          Height = 21
          TabOrder = 5
          OnExit = txtUploadDirExit
        end
        object jvspinConnectTimeOut: TJvSpinEdit
          Left = 24
          Top = 135
          Width = 161
          Height = 21
          MaxValue = 99.000000000000000000
          MinValue = 5.000000000000000000
          Value = 5.000000000000000000
          TabOrder = 6
        end
      end
      object JvStandardPage3: TJvStandardPage
        Left = 0
        Top = 0
        Width = 398
        Height = 275
        Caption = '[Debug] Execution'
        object Label2: TLabel
          Left = 24
          Top = 216
          Width = 67
          Height = 13
          Caption = 'DLL Full Path:'
        end
        object JvGroupHeader3: TJvGroupHeader
          Left = 0
          Top = 192
          Width = 410
          Height = 17
          Align = alCustom
          Caption = 'Initializer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object JvGroupHeader4: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 398
          Height = 17
          Align = alTop
          Caption = 'Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label14: TLabel
          Left = 24
          Top = 66
          Width = 87
          Height = 13
          Caption = 'Runtime Directory:'
        end
        object Label15: TLabel
          Left = 24
          Top = 24
          Width = 56
          Height = 13
          Caption = 'Target Unit:'
        end
        object JvGroupHeader6: TJvGroupHeader
          Left = 0
          Top = 272
          Width = 398
          Height = 3
          Align = alBottom
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 24
          Top = 107
          Width = 85
          Height = 13
          Caption = 'Compile Directory:'
        end
        object Label18: TLabel
          Left = 24
          Top = 149
          Width = 89
          Height = 13
          Caption = 'Compile Extension:'
        end
        object txtDebugInitializer: TEdit
          Left = 24
          Top = 231
          Width = 329
          Height = 21
          TabOrder = 6
        end
        object btnBrowseFile: TButton
          Left = 360
          Top = 233
          Width = 19
          Height = 17
          Caption = '...'
          TabOrder = 7
          OnClick = btnBrowseFileClick
        end
        object txtRuntimeDir: TEdit
          Left = 24
          Top = 81
          Width = 329
          Height = 21
          TabOrder = 1
        end
        object btnBrowseDir: TButton
          Left = 360
          Top = 83
          Width = 19
          Height = 17
          Caption = '...'
          TabOrder = 2
          OnClick = btnBrowseDirClick
        end
        object cboUnits: TComboBox
          Left = 24
          Top = 40
          Width = 356
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
        object txtCompileDir: TEdit
          Left = 24
          Top = 122
          Width = 329
          Height = 21
          TabOrder = 3
          OnExit = txtCompileDirExit
        end
        object btnBrowseDir2: TButton
          Left = 361
          Top = 124
          Width = 19
          Height = 17
          Caption = '...'
          TabOrder = 4
          OnClick = btnBrowseDir2Click
        end
        object txtCompileExt: TEdit
          Left = 24
          Top = 164
          Width = 356
          Height = 21
          TabOrder = 5
          OnExit = txtCompileExtExit
        end
      end
    end
    object jvSettingsTVSettings: TJvSettingsTreeView
      Left = 0
      Top = 0
      Width = 129
      Height = 275
      PageDefault = 0
      PageList = jvPageListSettings
      Align = alLeft
      Images = imlPrjSettings
      Indent = 19
      TabOrder = 1
      Items.Data = {
        0200000020000000000000000000000000000000FFFFFFFF0000000001000000
        0747656E6572616C27000000FFFFFFFFFFFFFFFF01000000FFFFFFFF00000000
        000000000E4964656E74696669636174696F6E1E0000000000000000000000FF
        FFFFFFFFFFFFFF02000000020000000544656275672200000002000000020000
        00FFFFFFFFFFFFFFFF020000000000000009457865637574696F6E25000000FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF01000000000000000C52656D6F74652044
        65627567}
      Items.Links = {050000000000000000000000020000000200000001000000}
    end
  end
  object odlgSelectFile: TOpenDialog
    Filter = 'Application Extension (*.dll)|*.dll'
    InitialDir = 'C:\'
    Left = 12
    Top = 280
  end
  object imlPrjSettings: TImageList
    Left = 45
    Top = 281
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF0084848400000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600848484000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF008484
      8400000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000008484840000000000C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C6000000
      0000848484008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C6008484840000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF008484840000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400C6C6C6008484840000000000000000000000000000000000000000000000
      00008484840084848400C6C6C60084848400C6C6C60084848400C6C6C6008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FF
      FF00C6C6C600848484000000000000000000000000008484840000000000C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6
      C60000FFFF008484840000000000000000000000000000000000000000000000
      000084848400C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400000000000000000000000000848484000000000000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      000084848400848484008484840084848400C6C6C600C6C6C600848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60084848400848484008484
      8400848484008484840000000000000000000000000084848400000000000000
      000000FFFF00C6C6C60000FFFF00000000000000000084848400848484008484
      8400848484008484840000000000000000000000000000000000000000000000
      000000000000000000000000000084848400C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400C6C6
      C60000FFFF00C6C6C60000FFFF00C6C6C6008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      C001E001FFFF00008001C001FEFF0000A001A001FE7F0000A001A001FE3F0000
      A0014001F01F0000A0017FE1F00F0000A0010001F0070000A001A001F00F0000
      BFF9A079F01F00008003B183FE3F0000C07FDF7FFE7F0000E0FFE0FFFEFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object jvSelectDir: TJvSelectDirectory
    ClassicDialog = False
    Title = 'Select Directory'
    Left = 78
    Top = 281
  end
end
