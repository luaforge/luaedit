object frmContributors: TfrmContributors
  Left = 432
  Top = 351
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Contributor List'
  ClientHeight = 340
  ClientWidth = 465
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
    465
    340)
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 383
    Top = 309
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
      Width = 97
      Height = 13
      Cursor = crHandPoint
      Caption = 'jf.goulet@luaedit.net'
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
      Width = 233
      Height = 13
      Caption = 'Created and developing LuaEdit in Delphi/Pascal'
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 160
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
      Width = 144
      Height = 13
      Cursor = crHandPoint
      Caption = 'shmuel.zeigerman@luaedit.net'
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
      Width = 232
      Height = 13
      Caption = 'Testing LuaEdit under several Operating Systems'
    end
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 232
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
      Width = 147
      Height = 13
      Cursor = crHandPoint
      Caption = 'massimo.magnano@luaedit.net'
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
      Width = 279
      Height = 13
      Caption = 'Contibuting to the development of LuaEdit in Delphi/Pascal'
    end
  end
  object GroupBox4: TGroupBox
    Left = 16
    Top = 88
    Width = 441
    Height = 65
    Caption = 'David Corriveau St-Louis'
    TabOrder = 4
    object Label13: TLabel
      Left = 24
      Top = 24
      Width = 32
      Height = 13
      Caption = 'E-Mail:'
    end
    object Label14: TLabel
      Left = 96
      Top = 24
      Width = 111
      Height = 13
      Cursor = crHandPoint
      Caption = 'webmaster@luaedit.net'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = Label2Click
    end
    object Label15: TLabel
      Left = 24
      Top = 40
      Width = 59
      Height = 13
      Caption = 'Contribution:'
    end
    object Label16: TLabel
      Left = 96
      Top = 40
      Width = 222
      Height = 13
      Caption = 'Concieved and created LuaEdit official website'
    end
  end
end
