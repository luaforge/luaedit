object frmAddToPrj: TfrmAddToPrj
  Left = 468
  Top = 287
  Width = 408
  Height = 217
  Caption = 'Add File to Project'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 150
    Width = 400
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    Constraints.MinWidth = 400
    TabOrder = 0
    DesignSize = (
      400
      33)
    object btnCancel: TButton
      Left = 320
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object btnOK: TButton
      Left = 239
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 150
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinHeight = 150
    Constraints.MinWidth = 400
    TabOrder = 1
    DesignSize = (
      400
      150)
    object lblEG1: TLabel
      Left = 56
      Top = 44
      Width = 288
      Height = 13
      Caption = '(Each File must be double-quoted and seperated by commas)'
      WordWrap = True
    end
    object lblEG2: TLabel
      Left = 56
      Top = 59
      Width = 226
      Height = 13
      Caption = '(EG: "C:\Test1.lua","C:\Test2.lua","TestX.lua")'
    end
    object btnBrowse: TButton
      Left = 370
      Top = 80
      Width = 20
      Height = 17
      Anchors = [akTop, akRight]
      Caption = '...'
      TabOrder = 2
      OnClick = btnBrowseClick
    end
    object txtExistingFile: TEdit
      Left = 56
      Top = 78
      Width = 307
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object chkExisting: TRadioButton
      Left = 24
      Top = 24
      Width = 305
      Height = 17
      Caption = 'Existing Unit(s)'
      TabOrder = 0
      OnClick = chkExistingClick
    end
    object chkNew: TRadioButton
      Left = 24
      Top = 112
      Width = 113
      Height = 17
      Caption = 'New Unit'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = chkNewClick
    end
  end
  object odlgOpenUnit: TOpenDialog
    Filter = 'Lua Units (*.lua)|*.lua'
    InitialDir = 'C:\'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 200
    Top = 145
  end
end
