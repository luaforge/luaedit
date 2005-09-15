object frmPrjOptions: TfrmPrjOptions
  Left = 506
  Top = 300
  ActiveControl = txtDebugInitializer
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Project Options'
  ClientHeight = 316
  ClientWidth = 442
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
  object Label8: TLabel
    Left = 136
    Top = 136
    Width = 67
    Height = 13
    Caption = 'Major Version:'
  end
  object Panel1: TPanel
    Left = 0
    Top = 275
    Width = 442
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      442
      41)
    object btnCancel: TButton
      Left = 358
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
      Left = 275
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
    Width = 442
    Height = 275
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pgcPrjSettings: TPageControl
      Left = 0
      Top = 0
      Width = 442
      Height = 275
      ActivePage = stabDebug
      Align = alClient
      TabOrder = 0
      object stabGeneral: TTabSheet
        Caption = 'General'
        object GroupBox1: TGroupBox
          Left = 16
          Top = 16
          Width = 401
          Height = 161
          Caption = 'General'
          TabOrder = 0
          object Label1: TLabel
            Left = 24
            Top = 32
            Width = 67
            Height = 13
            Caption = 'Project Name:'
          end
          object Label7: TLabel
            Left = 24
            Top = 80
            Width = 29
            Height = 13
            Caption = 'Major:'
          end
          object Label9: TLabel
            Left = 115
            Top = 80
            Width = 29
            Height = 13
            Caption = 'Minor:'
          end
          object Label10: TLabel
            Left = 205
            Top = 80
            Width = 42
            Height = 13
            Caption = 'Release:'
          end
          object Label11: TLabel
            Left = 296
            Top = 80
            Width = 44
            Height = 13
            Caption = 'Revision:'
          end
          object txtPrjName: TEdit
            Left = 24
            Top = 46
            Width = 353
            Height = 21
            TabOrder = 0
          end
          object spinMajorVersion: TJvSpinEdit
            Left = 24
            Top = 94
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
            Top = 94
            Width = 81
            Height = 21
            ButtonKind = bkStandard
            MaxValue = 9999.000000000000000000
            TabOrder = 2
            HideSelection = False
          end
          object spinReleaseVersion: TJvSpinEdit
            Left = 205
            Top = 94
            Width = 81
            Height = 21
            ButtonKind = bkStandard
            MaxValue = 9999.000000000000000000
            TabOrder = 3
            HideSelection = False
          end
          object spinRevisionVersion: TJvSpinEdit
            Left = 296
            Top = 94
            Width = 81
            Height = 21
            ButtonKind = bkStandard
            MaxValue = 9999.000000000000000000
            TabOrder = 4
            HideSelection = False
          end
          object chkAutoIncRevNumber: TCheckBox
            Left = 24
            Top = 122
            Width = 201
            Height = 17
            Caption = 'Auto-Increment Revision Number'
            TabOrder = 5
          end
        end
      end
      object stabDebug: TTabSheet
        Caption = 'Debug'
        ImageIndex = 1
        object GroupBox2: TGroupBox
          Left = 16
          Top = 16
          Width = 401
          Height = 81
          Caption = 'Debug Initializer'
          TabOrder = 0
          object Label2: TLabel
            Left = 24
            Top = 24
            Width = 67
            Height = 13
            Caption = 'DLL Full Path:'
          end
          object txtDebugInitializer: TEdit
            Left = 24
            Top = 39
            Width = 329
            Height = 21
            TabOrder = 0
          end
          object btnBrowse: TButton
            Left = 360
            Top = 41
            Width = 19
            Height = 17
            Caption = '...'
            TabOrder = 1
            OnClick = btnBrowseClick
          end
        end
        object GroupBox3: TGroupBox
          Left = 16
          Top = 104
          Width = 401
          Height = 121
          Caption = 'Remote Debugging'
          TabOrder = 1
          Visible = False
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
          object txtUploadDir: TEdit
            Left = 24
            Top = 88
            Width = 361
            Height = 21
            TabOrder = 5
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
        end
      end
    end
  end
  object odlgInitializer: TOpenDialog
    Filter = 'Application Extension (*.dll)|*.dll'
    InitialDir = 'C:\'
    Left = 12
    Top = 280
  end
end
