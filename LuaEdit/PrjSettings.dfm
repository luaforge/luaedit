object frmPrjOptions: TfrmPrjOptions
  Left = 443
  Top = 265
  ActiveControl = txtPrjName
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
      TabOrder = 0
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
      TabOrder = 1
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
      ActivePage = stabGeneral
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
