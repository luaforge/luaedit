object frmSettings: TfrmSettings
  Left = 488
  Top = 343
  BorderStyle = bsToolWindow
  Caption = 'Header Builder Settings'
  ClientHeight = 216
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 181
    Width = 392
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnCancel: TButton
      Left = 312
      Top = 6
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 232
      Top = 6
      Width = 75
      Height = 25
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 181
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 392
      Height = 181
      ActivePage = TabSheet3
      Align = alClient
      TabOrder = 0
      object TabSheet3: TTabSheet
        Caption = 'General'
        ImageIndex = 2
        object Label3: TLabel
          Left = 8
          Top = 11
          Width = 89
          Height = 13
          Caption = 'Developper Name:'
        end
        object Label4: TLabel
          Left = 240
          Top = 11
          Width = 47
          Height = 13
          Caption = 'Copyright:'
        end
        object Label5: TLabel
          Left = 8
          Top = 56
          Width = 69
          Height = 13
          Caption = 'Initial Release:'
        end
        object txtDevelopper: TEdit
          Left = 8
          Top = 26
          Width = 225
          Height = 21
          TabOrder = 0
        end
        object txtCopyright: TEdit
          Left = 240
          Top = 26
          Width = 137
          Height = 21
          TabOrder = 1
        end
        object txtInitialRelease: TEdit
          Left = 8
          Top = 71
          Width = 369
          Height = 21
          TabOrder = 2
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Functions'
        object Label1: TLabel
          Left = 8
          Top = 11
          Width = 72
          Height = 13
          Caption = 'Template Path:'
        end
        object txtFctTemplatePath: TEdit
          Left = 8
          Top = 26
          Width = 345
          Height = 21
          TabOrder = 0
          OnChange = txtFctTemplatePathChange
        end
        object btnBrowseFctTpl: TButton
          Left = 360
          Top = 27
          Width = 19
          Height = 19
          Caption = '...'
          TabOrder = 1
          OnClick = btnBrowseFctTplClick
        end
        object btnEditFctTpl: TButton
          Left = 8
          Top = 51
          Width = 75
          Height = 25
          Caption = 'Edit...'
          Enabled = False
          TabOrder = 2
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Files'
        ImageIndex = 1
        object Label2: TLabel
          Left = 8
          Top = 11
          Width = 72
          Height = 13
          Caption = 'Template Path:'
        end
        object txtFileTemplatePath: TEdit
          Left = 8
          Top = 26
          Width = 345
          Height = 21
          TabOrder = 0
          OnChange = txtFileTemplatePathChange
        end
        object btnBrowseFileTpl: TButton
          Left = 360
          Top = 27
          Width = 19
          Height = 19
          Caption = '...'
          TabOrder = 1
          OnClick = btnBrowseFileTplClick
        end
        object btnEditFileTpl: TButton
          Left = 8
          Top = 51
          Width = 75
          Height = 25
          Caption = 'Edit...'
          Enabled = False
          TabOrder = 2
        end
      end
    end
  end
  object odlgTemplate: TOpenDialog
    Filter = 'Template Files (*.tpl)|*.tpl'
    Options = [ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Open Template File'
    Left = 10
    Top = 184
  end
end
