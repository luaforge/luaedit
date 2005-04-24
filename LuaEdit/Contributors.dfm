object frmContributors: TfrmContributors
  Left = 432
  Top = 351
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Contributors list'
  ClientHeight = 263
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    466
    263)
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 384
    Top = 232
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 441
    Height = 65
    Caption = 'Jean-Fran'#231'ois Goulet'
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 32
      Height = 13
      Caption = 'E-Mail:'
    end
    object Label2: TLabel
      Left = 96
      Top = 24
      Width = 108
      Height = 13
      Cursor = crHandPoint
      Caption = 'hay0b29@hotmail.com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label2Click
    end
    object Label3: TLabel
      Left = 24
      Top = 40
      Width = 59
      Height = 13
      Caption = 'Contribution:'
    end
    object Label4: TLabel
      Left = 96
      Top = 40
      Width = 248
      Height = 13
      Caption = 'Created and developed LuaEdit for Lua 5.0 in Delphi'
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 88
    Width = 441
    Height = 65
    Caption = 'Shmuel Zeigerman'
    TabOrder = 2
    object Label5: TLabel
      Left = 24
      Top = 24
      Width = 32
      Height = 13
      Caption = 'E-Mail:'
    end
    object Label6: TLabel
      Left = 96
      Top = 24
      Width = 98
      Height = 13
      Cursor = crHandPoint
      Caption = 'shmuz@actcom.co.il'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label2Click
    end
    object Label7: TLabel
      Left = 24
      Top = 40
      Width = 59
      Height = 13
      Caption = 'Contribution:'
    end
    object Label8: TLabel
      Left = 96
      Top = 40
      Width = 284
      Height = 13
      Caption = 'Tested LuaEdit for Lua 5.0 under several Operating Systems'
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 160
    Width = 441
    Height = 65
    Caption = 'Massimo Magnano'
    TabOrder = 3
    object Label9: TLabel
      Left = 24
      Top = 24
      Width = 32
      Height = 13
      Caption = 'E-Mail:'
    end
    object Label10: TLabel
      Left = 96
      Top = 24
      Width = 94
      Height = 13
      Cursor = crHandPoint
      Caption = 'max.maxm@tiscali.it'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label2Click
    end
    object Label11: TLabel
      Left = 24
      Top = 40
      Width = 59
      Height = 13
      Caption = 'Contribution:'
    end
    object Label12: TLabel
      Left = 96
      Top = 40
      Width = 226
      Height = 13
      Caption = 'Helped developing LuaEdit for Lua 5.0 in Delphi'
    end
  end
end
