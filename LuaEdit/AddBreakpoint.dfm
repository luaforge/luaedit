object frmAddBreakpoint: TfrmAddBreakpoint
  Left = 374
  Top = 249
  BorderStyle = bsDialog
  Caption = 'Add Breakpoint'
  ClientHeight = 176
  ClientWidth = 369
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
  object Panel1: TPanel
    Left = 0
    Top = 135
    Width = 369
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      369
      41)
    object Button1: TButton
      Left = 288
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object Button2: TButton
      Left = 208
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 369
    Height = 135
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 22
      Height = 13
      Caption = 'Unit:'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 47
      Height = 13
      Caption = 'Condition:'
    end
    object Label3: TLabel
      Left = 16
      Top = 96
      Width = 23
      Height = 13
      Caption = 'Line:'
    end
    object cboUnits: TComboBox
      Left = 16
      Top = 32
      Width = 337
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object txtCondition: TEdit
      Left = 16
      Top = 72
      Width = 337
      Height = 21
      TabOrder = 1
    end
    object txtLine: TEdit
      Left = 16
      Top = 112
      Width = 89
      Height = 21
      MaxLength = 6
      TabOrder = 2
      OnKeyPress = txtLineKeyPress
    end
  end
end
