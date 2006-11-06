object frmEditorSettings: TfrmEditorSettings
  Left = 457
  Top = 161
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Editor Settings'
  ClientHeight = 408
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 367
    Width = 632
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      632
      41)
    object imgNotify: TImage
      Left = 20
      Top = 15
      Width = 32
      Height = 32
      AutoSize = True
      Picture.Data = {
        055449636F6E0000010001001010000001002000680400001600000028000000
        1000000020000000010020000000000000000000000000000000000000000000
        000000006E442A00966E4E00673C2300461804006B3F2500451A06003C0F0000
        461906004A1E0B2463361BB7502511295328130053281300562A1500552A1500
        552A15006E442A00966E4E00673C2300461804006A3E240043170400380A0000
        3D10004DCE9F6FFFAB784DFF3F160424532915004C200D00562B1600552A1500
        552A15006E442A00966E4E00663B220043160200663920003D1000002D00003F
        966B4BFFFFF7C4FF946341FF2F030043512613004B1F0D00552A1500552A1500
        552A15006E432A00946C4C0062371E003C0C00215A2C14A77E553AE88C674AFF
        CAAA87FFFFDCB3FFAF8764FF54270DFE3F1200C9461A085253281300552A1500
        552A15006D42280090674700592B136AA7886AFFD2B699FFE7CAA8FFFDE4BFFF
        FFE9C7FFFFF8D1FFF5D6B3FFD8B893FFAD8964FF5E2F15FF3E1100A153281300
        552A1500693D2300885E3D74CAB59AFFEDD5B8FFFFEBCCFFF8D6B7FFC0704FFF
        E99563FFDD8D5CFFDFA67BFFFFE7C3FFF4D6B1FFD7B694FF734729FF3C11009A
        5428130060331929CBB8A2FFEED8C1FFFFEFD1FFFFEECFFFFFFFE2FFB48162FF
        790000FF8F2E06FFF7E5C4FFFFEDCBFFFFE7C3FFF5D7B7FFDABD9BFF5B2D14FF
        471B0837AD9177B3E8DBC7FFFFF0D7FFFFECD2FFFFE7CEFFFFFFEDFFCFB295FF
        6F0000FFA45837FFFFFFF0FFFFE7C9FFFFE5C6FFFFEAC9FFFCE3C5FFAD8A6BFF
        3E0F0092CFBFAEFFF8E7D5FFFFF4DFFFFFECD6FFFFECD6FFFFFFF3FFCDAF94FF
        740000FFA55736FFFFFFF1FFFFE8CFFFFFE5CAFFFFEACFFFFFEBD1FFE4CAAFFF
        4B1D07A8CFC2B7FFFDEFE0FFFFF4E3FFFFEFDEFFFFF0DCFFFFFFFFFFD6C1AAFF
        770000FFA65836FFFFFFF8FFFFEDD5FFFFE9D0FFFFECD2FFFFF2D9FFECD7C0FF
        491E09A9D0C7BDFFFDF5E9FFFFF8EBFFFFF2E6FFFFFDEFFFEFE6DAFF8C3D1EFF
        650000FF8C3C23FFFFFFFEFFFFF0DDFFFFEBD6FFFFEED9FFFFFAE5FFF2DEC9FF
        4B1F0A93D9CCBED8F7F4EFFFFFFFF9FFFFF6ECFFFFFFF9FFE6D9C9FFB39382FF
        BAA59AFFC2AEA3FFFFFFF8FFFFF4E3FFFFEEDCFFFFFAEBFFFFFFFCFFE2CAB4FF
        42110036E2C9B254E4E5E5FFFFFFFFFFFFFFFAFFFFFBF3FFFFFFFFFFFFFFFAFF
        F9C8A6FFFFFEEEFFFFFFFFFFFFF5E8FFFFFAEFFFFFFFFFFFFFFFFFFF8A6750AF
        38080000E8CBB000E2DBD3AAEDEDEFFFFFFFFFFFFFFFFFFFFFFFFFFF8E574EFF
        5D0000FF9A4528FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCAB2A0DC33030000
        3E0E0000E7CCB200F0D4B700E6DCD391F2F4F5FFFFFFFFFFFFFFFFFFD7CEC9FF
        624144FFC5B5AFFFFFFFFFFFFFFFFFFFFFFFFEFFDCCCBEA4613014003B0C0000
        41130000E7CDB300F0D5B900E7DFD700D3CAC226DBCFC395F5F2EEEFFFFFFFFF
        FFFFFFFFFFFFFFFFFBF8F3F3BFAB9D9D7B56402EE4D6C90067371C003E100000
        42140000FF1FFFFFFE1FFFFFFC1FFFFFE007FFFFC003FF088001FFFF0000FFFF
        0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000159188003FFFFC007FFFF
        E00FFFFF}
    end
    object lblNotify: TLabel
      Left = 40
      Top = 15
      Width = 225
      Height = 13
      Caption = 'Some changes will require to restart your system'
    end
    object btnCancel: TButton
      Left = 550
      Top = 11
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 468
      Top = 11
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 632
    Height = 367
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 153
      Top = 0
      Width = 4
      Height = 367
    end
    object jvSettingsTVSettings: TJvSettingsTreeView
      Left = 0
      Top = 0
      Width = 153
      Height = 367
      PageDefault = 0
      PageList = jvPageListSettings
      Align = alLeft
      Images = imlEditorSettings
      Indent = 19
      TabOrder = 0
      Items.Data = {
        0400000025000000010000000100000000000000FFFFFFFF0000000003000000
        0C456E7669726F6E656D656E7420000000FFFFFFFFFFFFFFFF01000000FFFFFF
        FF00000000000000000747656E6572616C25000000FFFFFFFFFFFFFFFF010000
        00FFFFFFFF02000000000000000C53656172636820506174687324000000FFFF
        FFFFFFFFFFFF02000000FFFFFFFF03000000000000000B5765622042726F7773
        6572210000000100000001000000FFFFFFFFFFFFFFFF07000000010000000844
        6562756767657220000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0700000000
        0000000747656E6572616C240000000100000001000000FFFFFFFFFFFFFFFF01
        000000020000000B5465787420456469746F7220000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF01000000000000000747656E6572616C1D000000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF050000000000000004466F6E742000000001000000
        01000000FFFFFFFFFFFFFFFF040000000200000007446973706C61791F000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0400000000000000064775747465722C
        000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF06000000000000001353796E74
        617820486967686C69676874696E67}
      Items.Links = {
        0C00000000000000000000000200000003000000070000000700000001000000
        0100000005000000040000000400000006000000}
    end
    object jvPageListSettings: TJvPageList
      Left = 169
      Top = 0
      Width = 463
      Height = 367
      ActivePage = JvStandardPage1
      PropagateEnable = False
      ShowDesignCaption = sdcNone
      Align = alClient
      object JvStandardPage1: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Environement] - General'
        DesignSize = (
          463
          367)
        object JvGroupHeader1: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
          Height = 17
          Align = alTop
          Caption = 'General'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label12: TLabel
          Left = 24
          Top = 204
          Width = 108
          Height = 13
          Caption = 'Animated Tabs Speed:'
        end
        object Label13: TLabel
          Left = 117
          Top = 226
          Width = 6
          Height = 13
          Caption = '+'
        end
        object Label14: TLabel
          Left = 24
          Top = 226
          Width = 3
          Height = 13
          Caption = '-'
        end
        object Label17: TLabel
          Left = 24
          Top = 144
          Width = 85
          Height = 13
          Caption = 'Temporary Folder:'
        end
        object Bevel2: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object chkFileAssociate: TCheckBox
          Left = 24
          Top = 32
          Width = 225
          Height = 17
          Caption = 'Associate LuaEdit with Common Lua Files'
          TabOrder = 0
          OnClick = chkFileAssociateClick
        end
        object chkKeepReportOpened: TCheckBox
          Left = 24
          Top = 56
          Width = 225
          Height = 17
          Caption = 'Keep Find in Files Report Opened'
          TabOrder = 1
        end
        object chkShowExSaveDlg: TCheckBox
          Left = 24
          Top = 80
          Width = 217
          Height = 17
          Caption = 'Show Extended Save Dialog on Exit'
          TabOrder = 2
        end
        object chkSaveProjectsInc: TCheckBox
          Left = 272
          Top = 32
          Width = 161
          Height = 17
          Caption = 'Save Projects Incrementally'
          TabOrder = 3
        end
        object chkSaveUnitsInc: TCheckBox
          Left = 272
          Top = 56
          Width = 161
          Height = 17
          Caption = 'Save Units Incrementally'
          TabOrder = 4
        end
        object chkSaveBreakpoints: TCheckBox
          Left = 272
          Top = 80
          Width = 161
          Height = 17
          Caption = 'Save Breakpoints'
          TabOrder = 5
        end
        object jvslAnimatedTabsSpeed: TJvxSlider
          Left = 29
          Top = 220
          Width = 89
          Height = 25
          ImageHThumb.Data = {
            EE030000424DEE03000000000000360000002800000012000000110000000100
            180000000000B803000000000000000000000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
            404040404040404040404040404040FF00FFFF00FFFF00FFFF00FF4040404040
            40404040404040404040FF00FFFF00FF0000FF00FFFF00FFFFFFFF8080808080
            80808080404040FF00FFFF00FFFF00FFFF00FFFFFFFF80808080808080808040
            4040FF00FFFF00FF0000FF00FFFF00FFFFFFFFC8D0D4C8D0D4808080404040FF
            00FFFF00FFFF00FFFF00FFFFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FF
            0000FF00FFFF00FFFFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FFFF00FF
            FF00FFFFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FF0000FF00FFFF00FF
            FFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FFFF00FFFF00FFFFFFFFC8D0
            D4C8D0D4808080404040FF00FFFF00FF0000FF00FFFF00FFFFFFFFC8D0D4C8D0
            D4808080404040FF00FFFF00FFFF00FFFF00FFFFFFFFC8D0D4C8D0D480808040
            4040FF00FFFF00FF0000FF00FFFF00FFFFFFFFC8D0D4C8D0D4808080404040FF
            00FFFF00FFFF00FFFF00FFFFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FF
            0000FF00FFFF00FFFFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FFFF00FF
            FF00FFFFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FF0000FF00FFFF00FF
            FFFFFFC8D0D4C8D0D4808080404040FF00FFFF00FFFF00FFFF00FFFFFFFFC8D0
            D4C8D0D4808080404040FF00FFFF00FF0000FF00FFFF00FFFFFFFFFFFFFFFFFF
            FFFFFFFF404040FF00FFFF00FFFF00FFFF00FFFFFFFFFFFFFFFFFFFFFFFFFF40
            4040FF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
          Increment = 1
          MinValue = 1
          MaxValue = 2000
          Options = [soShowFocus, soSmooth]
          TabOrder = 6
          Value = 50
          UserImages = {01}
        end
        object chkShowStatusBar: TCheckBox
          Left = 24
          Top = 104
          Width = 105
          Height = 17
          Caption = 'Show Status Bar'
          TabOrder = 7
        end
        object txtTempFolder: TJvDotNetDirectoryEdit
          Left = 24
          Top = 160
          Width = 412
          Height = 21
          AcceptFiles = False
          DialogKind = dkWin32
          AutoCompleteFileOptions = []
          DialogOptions = [sdAllowCreate, sdPerformCreate]
          Anchors = [akLeft, akRight, akBottom]
          TabOrder = 8
        end
      end
      object JvStandardPage2: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Text Editor] - General'
        object Label1: TLabel
          Left = 24
          Top = 206
          Width = 53
          Height = 13
          Caption = 'Undo Limit:'
        end
        object Label2: TLabel
          Left = 160
          Top = 206
          Width = 53
          Height = 13
          Caption = 'Tab Width:'
        end
        object JvGroupHeader2: TJvGroupHeader
          Left = 0
          Top = 185
          Width = 475
          Height = 17
          Align = alCustom
          Caption = 'Tabs & Undos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object JvGroupHeader16: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
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
        object Bevel1: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object txtTabWidth: TEdit
          Left = 160
          Top = 222
          Width = 121
          Height = 21
          MaxLength = 2
          TabOrder = 0
          OnKeyPress = txtTabWidthKeyPress
        end
        object txtUndoLimit: TEdit
          Left = 24
          Top = 222
          Width = 121
          Height = 21
          MaxLength = 5
          TabOrder = 1
          OnKeyPress = txtUndoLimitKeyPress
        end
        object chkAutoIndent: TCheckBox
          Left = 24
          Top = 32
          Width = 97
          Height = 17
          Caption = 'Auto Indent'
          TabOrder = 2
        end
        object chkSmartTab: TCheckBox
          Left = 24
          Top = 104
          Width = 97
          Height = 17
          Caption = 'Use Smart Tabs'
          TabOrder = 3
        end
        object chkTabIndent: TCheckBox
          Left = 24
          Top = 80
          Width = 97
          Height = 17
          Caption = 'Use Tab Indent'
          TabOrder = 4
        end
        object chkGroupUndo: TCheckBox
          Left = 24
          Top = 56
          Width = 97
          Height = 17
          Caption = 'Group Undo'
          TabOrder = 5
        end
        object chkRightMouseMovesCursor: TCheckBox
          Left = 24
          Top = 128
          Width = 145
          Height = 17
          Caption = 'Move Caret on Right Click'
          TabOrder = 6
        end
        object chkEHomeKey: TCheckBox
          Left = 24
          Top = 152
          Width = 145
          Height = 17
          Caption = 'Use Enhance Home Key'
          TabOrder = 7
        end
        object chkTabsToSpaces: TCheckBox
          Left = 256
          Top = 32
          Width = 135
          Height = 17
          Caption = 'Convert Tabs to Spaces'
          TabOrder = 8
        end
        object chkHideScrollBars: TCheckBox
          Left = 256
          Top = 56
          Width = 169
          Height = 17
          Caption = 'Hide Scroll Bars When Useless'
          TabOrder = 9
        end
        object chkTrailBlanks: TCheckBox
          Left = 256
          Top = 152
          Width = 121
          Height = 17
          Caption = 'Keep Trailing Blanks'
          TabOrder = 10
        end
        object chkKeepCaretX: TCheckBox
          Left = 256
          Top = 128
          Width = 129
          Height = 17
          Caption = 'Seek Caret X'
          TabOrder = 11
        end
        object chkScrollPastEOL: TCheckBox
          Left = 256
          Top = 104
          Width = 97
          Height = 17
          Caption = 'Scroll Past EOL'
          TabOrder = 12
        end
        object chkScrollPastEOF: TCheckBox
          Left = 256
          Top = 80
          Width = 97
          Height = 17
          Caption = 'Scroll Past EOF'
          TabOrder = 13
        end
      end
      object JvStandardPage3: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Environment] - Search Paths'
        DesignSize = (
          463
          367)
        object Label10: TLabel
          Left = 25
          Top = 30
          Width = 99
          Height = 13
          Caption = 'Completion Proposal:'
        end
        object JvGroupHeader3: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
          Height = 17
          Align = alTop
          Caption = 'Search Path'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Bevel3: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object txtLibraries: TEdit
          Left = 24
          Top = 44
          Width = 394
          Height = 21
          TabOrder = 0
        end
        object btnBrowseLibraries: TButton
          Left = 423
          Top = 46
          Width = 20
          Height = 17
          Hint = 'Browse for Completion Proposal Search Paths...'
          Anchors = [akTop, akRight]
          Caption = '...'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnBrowseLibrariesClick
        end
      end
      object JvStandardPage4: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Environment] - Web Browser'
        object JvGroupHeader4: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
          Height = 17
          Align = alTop
          Caption = 'Browser Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label15: TLabel
          Left = 24
          Top = 152
          Width = 118
          Height = 13
          Caption = 'Delete History Older than'
        end
        object Label16: TLabel
          Left = 189
          Top = 152
          Width = 25
          Height = 13
          Caption = 'days.'
        end
        object Bevel4: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object txtHomePage: TEdit
          Left = 24
          Top = 52
          Width = 425
          Height = 21
          TabOrder = 0
        end
        object txtSearchPage: TEdit
          Left = 24
          Top = 100
          Width = 425
          Height = 21
          TabOrder = 1
        end
        object chkHomePage: TCheckBox
          Left = 24
          Top = 32
          Width = 137
          Height = 17
          Caption = 'Use Custom Home Page'
          TabOrder = 2
          OnClick = chkHomePageClick
        end
        object chkSearchPage: TCheckBox
          Left = 24
          Top = 80
          Width = 145
          Height = 17
          Caption = 'Use Custom Search Page'
          TabOrder = 3
          OnClick = chkSearchPageClick
        end
        object jvspinHistoryMaxAge: TJvSpinEdit
          Left = 146
          Top = 148
          Width = 41
          Height = 21
          MaxValue = 99.000000000000000000
          MinValue = 1.000000000000000000
          Value = 99.000000000000000000
          TabOrder = 4
        end
      end
      object JvStandardPage5: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Display] - Gutter'
        object Label4: TLabel
          Left = 192
          Top = 120
          Width = 59
          Height = 13
          Caption = 'Gutter Color:'
        end
        object Label3: TLabel
          Left = 24
          Top = 120
          Width = 63
          Height = 13
          Caption = 'Gutter Width:'
        end
        object JvGroupHeader5: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
          Height = 17
          Align = alTop
          Caption = 'Gutter Settings'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Bevel5: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object chkShowGutter: TCheckBox
          Left = 24
          Top = 32
          Width = 89
          Height = 17
          Caption = 'Show Gutter'
          TabOrder = 0
          OnClick = chkShowGutterClick
        end
        object chkShowLineNumbers: TCheckBox
          Left = 24
          Top = 56
          Width = 129
          Height = 17
          Caption = 'Show Line Numbers'
          TabOrder = 1
        end
        object chkLeadingZeros: TCheckBox
          Left = 24
          Top = 80
          Width = 97
          Height = 17
          Caption = 'Leading Zeros'
          TabOrder = 2
        end
        object cboGutterColor: TColorBox
          Left = 192
          Top = 136
          Width = 249
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 16
          ParentFont = False
          TabOrder = 3
        end
        object txtGutterWidth: TEdit
          Left = 24
          Top = 136
          Width = 153
          Height = 21
          MaxLength = 2
          TabOrder = 4
          OnKeyPress = txtGutterWidthKeyPress
        end
      end
      object JvStandardPage6: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Text Editor] - Font'
        object Label5: TLabel
          Left = 24
          Top = 32
          Width = 24
          Height = 13
          Caption = 'Font:'
        end
        object Label6: TLabel
          Left = 336
          Top = 32
          Width = 23
          Height = 13
          Caption = 'Size:'
        end
        object JvGroupHeader6: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
          Height = 17
          Align = alTop
          Caption = 'Font Styles'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Bevel6: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object pnlPreview: TPanel
          Left = 24
          Top = 80
          Width = 417
          Height = 129
          BevelOuter = bvNone
          BorderStyle = bsSingle
          Caption = 'Sample Text'
          TabOrder = 0
        end
        object cboFonts: TComboBox
          Left = 24
          Top = 48
          Width = 297
          Height = 22
          Style = csOwnerDrawVariable
          ItemHeight = 16
          TabOrder = 1
          OnChange = cboFontsChange
          OnDrawItem = cboFontsDrawItem
          OnMeasureItem = cboFontsMeasureItem
        end
        object cboFontSize: TComboBox
          Left = 336
          Top = 48
          Width = 105
          Height = 22
          Style = csOwnerDrawVariable
          ItemHeight = 16
          MaxLength = 2
          TabOrder = 2
          OnChange = cboFontSizeChange
          OnKeyPress = cboFontSizeKeyPress
          OnMeasureItem = cboFontSizeMeasureItem
          Items.Strings = (
            '8'
            '10'
            '11'
            '12'
            '14'
            '18'
            '24')
        end
      end
      object JvStandardPage7: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Display] - Syntax Highlighting'
        object Label7: TLabel
          Left = 24
          Top = 75
          Width = 46
          Height = 13
          Caption = 'Elements:'
        end
        object Label8: TLabel
          Left = 288
          Top = 76
          Width = 57
          Height = 13
          Caption = 'Foreground:'
        end
        object Label9: TLabel
          Left = 288
          Top = 123
          Width = 61
          Height = 13
          Caption = 'Background:'
        end
        object JvGroupHeader7: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
          Height = 17
          Align = alTop
          Caption = 'Syntax Highlighting'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 24
          Top = 32
          Width = 46
          Height = 13
          Caption = 'Color Set:'
        end
        object Bevel7: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object synSample: TSynEdit
          Left = 24
          Top = 168
          Width = 433
          Height = 177
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Lines.Strings = (
            '-- This is a sample'
            'local varString = "This is a string"'
            'local varNumber = 1975.064328'
            ''
            'function Test(Param1, Param2)'
            '    local varTemp = 0'
            ''
            '    while varTemp < 99 do'
            '        varTemp = varTemp + 1'
            '    end'
            'end'
            ''
            '--[[ This is a Breakpoint line'
            'This is a Error line'
            'This is a Execution line]]')
          MaxScrollWidth = 200
          ReadOnly = True
          WordWrapGlyph.Visible = False
        end
        object lstElement: TListBox
          Left = 24
          Top = 91
          Width = 145
          Height = 65
          ItemHeight = 13
          Sorted = True
          TabOrder = 1
          OnClick = lstElementClick
        end
        object chkBold: TCheckBox
          Left = 192
          Top = 89
          Width = 57
          Height = 17
          Caption = 'Bold'
          TabOrder = 2
          OnClick = chkBoldClick
        end
        object chkItalic: TCheckBox
          Left = 192
          Top = 116
          Width = 57
          Height = 17
          Caption = 'Italic'
          TabOrder = 3
          OnClick = chkItalicClick
        end
        object chkUnderline: TCheckBox
          Left = 192
          Top = 143
          Width = 73
          Height = 17
          Caption = 'Underline'
          TabOrder = 4
          OnClick = chkUnderlineClick
        end
        object cboForeground: TColorBox
          Left = 287
          Top = 92
          Width = 170
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 5
          OnChange = cboForegroundChange
        end
        object cboBackground: TColorBox
          Left = 287
          Top = 139
          Width = 170
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 6
          OnChange = cboBackgroundChange
        end
        object cboColorSet: TComboBox
          Left = 24
          Top = 48
          Width = 353
          Height = 21
          AutoComplete = False
          Style = csDropDownList
          ItemHeight = 0
          Sorted = True
          TabOrder = 7
          OnClick = cboColorSetClick
        end
        object bitbtnDelete: TBitBtn
          Left = 384
          Top = 48
          Width = 22
          Height = 20
          Hint = 'Delete Selected Color Set'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
          OnClick = bitbtnDeleteClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FF000080FF00FFFF00FFFF00FFFF00FFFF00FF000080FFFFFFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF000080000080000080FFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF000080FFFFFFFF00FFFF00FFFF00FFFF00FF000080000080000080FFFFFFFF
            00FFFF00FFFF00FFFF00FFFF00FF000080FFFFFFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FF000080000080000080FFFFFFFF00FFFF00FFFF00FF0000800000
            80FFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00008000008000
            0080FFFFFFFF00FF000080000080FFFFFFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF000080000080000080000080000080FFFFFFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00
            0080000080000080FFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF000080000080000080000080000080FFFFFFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00008000008000
            0080FFFFFFFF00FF000080FFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF000080000080000080000080FFFFFFFF00FFFF00FFFF00FF0000800000
            80FFFFFFFF00FFFF00FFFF00FFFF00FF000080000080000080000080FFFFFFFF
            00FFFF00FFFF00FFFF00FFFF00FF000080000080FFFFFFFF00FFFF00FFFF00FF
            000080000080FFFFFFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF000080000080FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        end
        object bitbtnSave: TBitBtn
          Left = 409
          Top = 48
          Width = 22
          Height = 20
          Hint = 'Save Changes to Current Color Set'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          OnClick = bitbtnSaveClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF42424242424242424242424242424242
            4242424242424242424242424242424242424242424242FF00FFFF00FF424242
            429D9D429D9D424242424242424242424242424242424242CECECECECECE4242
            42429D9D424242FF00FFFF00FF424242429D9D429D9D42424242424242424242
            4242424242424242CECECECECECE424242429D9D424242FF00FFFF00FF424242
            429D9D429D9D424242424242424242424242424242424242CECECECECECE4242
            42429D9D424242FF00FFFF00FF424242429D9D429D9D42424242424242424242
            4242424242424242424242424242424242429D9D424242FF00FFFF00FF424242
            429D9D429D9D429D9D429D9D429D9D429D9D429D9D429D9D429D9D429D9D429D
            9D429D9D424242FF00FFFF00FF424242429D9D429D9D42424242424242424242
            4242424242424242424242424242429D9D429D9D424242FF00FFFF00FF424242
            429D9D424242CECECECECECECECECECECECECECECECECECECECECECECECE4242
            42429D9D424242FF00FFFF00FF424242429D9D424242CECECECECECECECECECE
            CECECECECECECECECECECECECECE424242429D9D424242FF00FFFF00FF424242
            429D9D424242CECECECECECECECECECECECECECECECECECECECECECECECE4242
            42429D9D424242FF00FFFF00FF424242429D9D424242CECECECECECECECECECE
            CECECECECECECECECECECECECECE424242429D9D424242FF00FFFF00FF424242
            429D9D424242CECECECECECECECECECECECECECECECECECECECECECECECE4242
            42424242424242FF00FFFF00FF424242429D9D424242CECECECECECECECECECE
            CECECECECECECECECECECECECECE424242CECECE424242FF00FFFF00FF424242
            4242424242424242424242424242424242424242424242424242424242424242
            42424242424242FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        end
        object bitbtnNew: TBitBtn
          Left = 434
          Top = 48
          Width = 22
          Height = 20
          Hint = 'Create New Empty Color Set'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 10
          OnClick = bitbtnNewClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            0000000000000000000000000000000000000000000000000000000000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FF
            000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
            00FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FF
            000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
            00FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FF
            000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
            00FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FF
            000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
            00FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
            000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            000000000000000000000000000000000000000000000000FF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        end
      end
      object JvStandardPage8: TJvStandardPage
        Left = 0
        Top = 0
        Width = 463
        Height = 367
        Caption = '[Debugger] - General'
        object JvGroupHeader15: TJvGroupHeader
          Left = 0
          Top = 0
          Width = 463
          Height = 17
          Align = alTop
          Caption = 'Automatic Loading of Libraries'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label18: TLabel
          Left = 16
          Top = 160
          Width = 161
          Height = 13
          Caption = 'Maximum Printable Size of Tables:'
        end
        object Bevel8: TBevel
          Left = 0
          Top = 365
          Width = 463
          Height = 2
          Align = alBottom
        end
        object JvGroupHeader8: TJvGroupHeader
          Left = 0
          Top = 136
          Width = 463
          Height = 17
          Align = alCustom
          Caption = 'Lua Tables'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label19: TLabel
          Left = 16
          Top = 208
          Width = 133
          Height = 13
          Caption = 'Maximum Sub Tables Level:'
        end
        object JvGroupHeader9: TJvGroupHeader
          Left = 0
          Top = 296
          Width = 463
          Height = 17
          Align = alCustom
          Caption = 'Miscellaneous'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object jvspinMaxTablesSize: TJvSpinEdit
          Left = 16
          Top = 174
          Width = 201
          Height = 21
          MaxValue = 65536.000000000000000000
          MinValue = 256.000000000000000000
          Value = 16384.000000000000000000
          TabOrder = 0
        end
        object chkAutoLoadLibBasic: TCheckBox
          Left = 16
          Top = 24
          Width = 185
          Height = 17
          Caption = 'Basic Library (Recommended)'
          TabOrder = 1
        end
        object chkAutoLoadLibMath: TCheckBox
          Left = 224
          Top = 24
          Width = 177
          Height = 17
          Caption = 'Mathematical Library'
          TabOrder = 2
        end
        object chkAutoLoadLibString: TCheckBox
          Left = 16
          Top = 72
          Width = 185
          Height = 17
          Caption = 'String Library'
          TabOrder = 3
        end
        object chkAutoLoadLibTable: TCheckBox
          Left = 16
          Top = 96
          Width = 201
          Height = 17
          Caption = 'Table Library'
          TabOrder = 4
        end
        object chkAutoLoadLibOSIO: TCheckBox
          Left = 224
          Top = 48
          Width = 201
          Height = 17
          Caption = 'I/O and Operating System Library'
          TabOrder = 5
        end
        object chkAutoLoadLibDebug: TCheckBox
          Left = 224
          Top = 72
          Width = 193
          Height = 17
          Caption = 'Debug Library'
          TabOrder = 6
        end
        object jvspinMaxSubTablesLevel: TJvSpinEdit
          Left = 16
          Top = 222
          Width = 201
          Height = 21
          MaxValue = 999.000000000000000000
          MinValue = 1.000000000000000000
          Value = 999.000000000000000000
          TabOrder = 7
        end
        object chkAutoLoadLibPackage: TCheckBox
          Left = 16
          Top = 48
          Width = 185
          Height = 17
          Caption = 'Package Library (Recommended)'
          TabOrder = 8
        end
        object chkCheckCyclicReferencing: TCheckBox
          Left = 16
          Top = 256
          Width = 233
          Height = 17
          Caption = 'Check Cyclic Referencing (Recommended)'
          TabOrder = 9
        end
        object chkShowStackTraceOnError: TCheckBox
          Left = 16
          Top = 320
          Width = 289
          Height = 17
          Caption = 'Show Stack Trace On Lua Errors'
          TabOrder = 10
        end
      end
    end
    object Panel3: TPanel
      Left = 157
      Top = 0
      Width = 12
      Height = 367
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  object imlEditorSettings: TImageList
    Left = 397
    Top = 377
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
end
