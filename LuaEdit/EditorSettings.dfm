object frmEditorSettings: TfrmEditorSettings
  Left = 492
  Top = 161
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Editor Settings'
  ClientHeight = 416
  ClientWidth = 492
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
    Top = 375
    Width = 492
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      492
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
      Left = 410
      Top = 11
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 328
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
    Width = 492
    Height = 375
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pgcDebuggerSettings: TPageControl
      Left = 0
      Top = 0
      Width = 492
      Height = 375
      ActivePage = stabGeneral
      Align = alClient
      TabOrder = 0
      object stabGeneral: TTabSheet
        Caption = 'General'
        object Label1: TLabel
          Left = 16
          Top = 291
          Width = 53
          Height = 13
          Caption = 'Undo Limit:'
        end
        object Label2: TLabel
          Left = 152
          Top = 291
          Width = 53
          Height = 13
          Caption = 'Tab Width:'
        end
        object Group1: TGroupBox
          Left = 16
          Top = 135
          Width = 457
          Height = 145
          Caption = 'Editor Options'
          TabOrder = 2
          object chkAutoIndent: TCheckBox
            Left = 16
            Top = 32
            Width = 97
            Height = 17
            Caption = 'Auto Indent'
            TabOrder = 0
          end
          object chkGroupUndo: TCheckBox
            Left = 16
            Top = 56
            Width = 97
            Height = 17
            Caption = 'Group Undo'
            TabOrder = 1
          end
          object chkScrollPastEOF: TCheckBox
            Left = 312
            Top = 32
            Width = 97
            Height = 17
            Caption = 'Scroll Past EOF'
            TabOrder = 8
          end
          object chkSmartTab: TCheckBox
            Left = 16
            Top = 104
            Width = 97
            Height = 17
            Caption = 'Use Smart Tabs'
            TabOrder = 3
          end
          object chkTrailBlanks: TCheckBox
            Left = 312
            Top = 104
            Width = 121
            Height = 17
            Caption = 'Keep Trailing Blanks'
            TabOrder = 11
          end
          object chkTabIndent: TCheckBox
            Left = 16
            Top = 80
            Width = 97
            Height = 17
            Caption = 'Use Tab Indent'
            TabOrder = 2
          end
          object chkHideScrollBars: TCheckBox
            Left = 128
            Top = 104
            Width = 169
            Height = 17
            Caption = 'Hide Scroll Bars When Useless'
            TabOrder = 7
          end
          object chkEHomeKey: TCheckBox
            Left = 128
            Top = 56
            Width = 145
            Height = 17
            Caption = 'Use Enhance Home Key'
            TabOrder = 5
          end
          object chkTabsToSpaces: TCheckBox
            Left = 128
            Top = 80
            Width = 135
            Height = 17
            Caption = 'Convert Tabs to Spaces'
            TabOrder = 6
          end
          object chkScrollPastEOL: TCheckBox
            Left = 312
            Top = 56
            Width = 97
            Height = 17
            Caption = 'Scroll Past EOL'
            TabOrder = 9
          end
          object chkKeepCaretX: TCheckBox
            Left = 312
            Top = 80
            Width = 129
            Height = 17
            Caption = 'Seek Caret X'
            TabOrder = 10
          end
          object chkRightMouseMovesCursor: TCheckBox
            Left = 128
            Top = 32
            Width = 145
            Height = 17
            Caption = 'Move Caret on Right Click'
            TabOrder = 4
          end
        end
        object txtUndoLimit: TEdit
          Left = 16
          Top = 307
          Width = 121
          Height = 21
          MaxLength = 5
          TabOrder = 0
          OnKeyPress = txtUndoLimitKeyPress
        end
        object txtTabWidth: TEdit
          Left = 152
          Top = 307
          Width = 121
          Height = 21
          MaxLength = 2
          TabOrder = 1
          OnKeyPress = txtTabWidthKeyPress
        end
        object GroupBox1: TGroupBox
          Left = 16
          Top = 16
          Width = 457
          Height = 105
          Caption = 'General'
          TabOrder = 3
          object chkFileAssociate: TCheckBox
            Left = 16
            Top = 24
            Width = 225
            Height = 17
            Caption = 'Associate LuaEdit with Common Lua Files'
            TabOrder = 0
            OnClick = chkFileAssociateClick
          end
          object chkSaveProjectsInc: TCheckBox
            Left = 272
            Top = 24
            Width = 161
            Height = 17
            Caption = 'Save Projects Incrementally'
            TabOrder = 3
          end
          object chkSaveUnitsInc: TCheckBox
            Left = 272
            Top = 48
            Width = 161
            Height = 17
            Caption = 'Save Units Incrementally'
            TabOrder = 4
          end
          object chkSaveBreakpoints: TCheckBox
            Left = 272
            Top = 72
            Width = 161
            Height = 17
            Caption = 'Save Breakpoints'
            TabOrder = 5
          end
          object chkShowExSaveDlg: TCheckBox
            Left = 16
            Top = 72
            Width = 217
            Height = 17
            Caption = 'Show Extended Save Dialog on Exit'
            TabOrder = 2
          end
          object chkKeepReportOpened: TCheckBox
            Left = 16
            Top = 48
            Width = 225
            Height = 17
            Caption = 'Keep Find in Files Report Opened'
            TabOrder = 1
          end
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Environment'
        ImageIndex = 3
        object GroupBox4: TGroupBox
          Left = 16
          Top = 16
          Width = 457
          Height = 89
          Caption = 'Search Path'
          TabOrder = 0
          DesignSize = (
            457
            89)
          object Label10: TLabel
            Left = 17
            Top = 30
            Width = 42
            Height = 13
            Caption = 'Libraries:'
          end
          object txtLibraries: TEdit
            Left = 17
            Top = 44
            Width = 401
            Height = 21
            TabOrder = 0
          end
          object btnBrowseLibraries: TButton
            Left = 424
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
      end
      object stabDisplay: TTabSheet
        Caption = 'Display'
        ImageIndex = 1
        object GroupBox2: TGroupBox
          Left = 16
          Top = 16
          Width = 457
          Height = 105
          Caption = 'Gutter'
          TabOrder = 0
          object Label3: TLabel
            Left = 24
            Top = 48
            Width = 63
            Height = 13
            Caption = 'Gutter Width:'
          end
          object Label4: TLabel
            Left = 192
            Top = 48
            Width = 59
            Height = 13
            Caption = 'Gutter Color:'
          end
          object chkShowGutter: TCheckBox
            Left = 24
            Top = 24
            Width = 89
            Height = 17
            Caption = 'Show Gutter'
            TabOrder = 0
            OnClick = chkShowGutterClick
          end
          object chkShowLineNumbers: TCheckBox
            Left = 192
            Top = 24
            Width = 129
            Height = 17
            Caption = 'Show Line Numbers'
            TabOrder = 1
          end
          object txtGutterWidth: TEdit
            Left = 24
            Top = 64
            Width = 153
            Height = 21
            MaxLength = 2
            TabOrder = 3
            OnKeyPress = txtGutterWidthKeyPress
          end
          object cboGutterColor: TColorBox
            Left = 192
            Top = 64
            Width = 241
            Height = 22
            Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ItemHeight = 16
            ParentFont = False
            TabOrder = 4
          end
          object chkLeadingZeros: TCheckBox
            Left = 336
            Top = 24
            Width = 97
            Height = 17
            Caption = 'Leading Zeros'
            TabOrder = 2
          end
        end
        object GroupBox3: TGroupBox
          Left = 16
          Top = 128
          Width = 457
          Height = 201
          Caption = 'Editor Font'
          TabOrder = 1
          object Label5: TLabel
            Left = 24
            Top = 32
            Width = 24
            Height = 13
            Caption = 'Font:'
          end
          object Label6: TLabel
            Left = 304
            Top = 32
            Width = 23
            Height = 13
            Caption = 'Size:'
          end
          object cboFonts: TComboBox
            Left = 24
            Top = 48
            Width = 265
            Height = 22
            Style = csOwnerDrawVariable
            ItemHeight = 16
            TabOrder = 0
            OnChange = cboFontsChange
            OnDrawItem = cboFontsDrawItem
            OnMeasureItem = cboFontsMeasureItem
          end
          object cboFontSize: TComboBox
            Left = 304
            Top = 48
            Width = 129
            Height = 22
            Style = csOwnerDrawVariable
            ItemHeight = 16
            MaxLength = 2
            TabOrder = 1
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
          object pnlPreview: TPanel
            Left = 24
            Top = 80
            Width = 409
            Height = 105
            BevelOuter = bvNone
            BorderStyle = bsSingle
            Caption = 'Sample Text'
            TabOrder = 2
          end
        end
      end
      object stabColors: TTabSheet
        Caption = 'Colors'
        ImageIndex = 2
        object Label7: TLabel
          Left = 16
          Top = 16
          Width = 46
          Height = 13
          Caption = 'Elements:'
        end
        object Label8: TLabel
          Left = 288
          Top = 17
          Width = 57
          Height = 13
          Caption = 'Foreground:'
        end
        object Label9: TLabel
          Left = 288
          Top = 64
          Width = 61
          Height = 13
          Caption = 'Background:'
        end
        object synSample: TSynEdit
          Left = 16
          Top = 112
          Width = 449
          Height = 217
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          TabOrder = 6
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
          Left = 16
          Top = 32
          Width = 145
          Height = 65
          ItemHeight = 13
          Sorted = True
          TabOrder = 0
          OnClick = lstElementClick
        end
        object cboForeground: TColorBox
          Left = 288
          Top = 33
          Width = 177
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 4
          OnChange = cboForegroundChange
        end
        object cboBackground: TColorBox
          Left = 288
          Top = 80
          Width = 177
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 5
          OnChange = cboBackgroundChange
        end
        object chkBold: TCheckBox
          Left = 192
          Top = 30
          Width = 57
          Height = 17
          Caption = 'Bold'
          TabOrder = 1
          OnClick = chkBoldClick
        end
        object chkItalic: TCheckBox
          Left = 192
          Top = 57
          Width = 57
          Height = 17
          Caption = 'Italic'
          TabOrder = 2
          OnClick = chkItalicClick
        end
        object chkUnderline: TCheckBox
          Left = 192
          Top = 84
          Width = 73
          Height = 17
          Caption = 'Underline'
          TabOrder = 3
          OnClick = chkUnderlineClick
        end
      end
    end
  end
end
