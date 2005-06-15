object frmSearchPath: TfrmSearchPath
  Left = 442
  Top = 344
  Width = 370
  Height = 300
  Caption = 'Search Path'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 370
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    362
    273)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 350
    Height = 224
    Anchors = [akLeft, akTop, akRight, akBottom]
    Constraints.MinWidth = 350
    TabOrder = 0
    DesignSize = (
      350
      224)
    object lblMessage: TLabel
      Left = 11
      Top = 17
      Width = 331
      Height = 28
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      WordWrap = True
    end
    object Panel1: TPanel
      Left = 2
      Top = 191
      Width = 346
      Height = 31
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        346
        31)
      object btnAdd: TButton
        Left = 92
        Top = 1
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Add'
        TabOrder = 1
        OnClick = btnAddClick
      end
      object btnDelete: TButton
        Left = 172
        Top = 1
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Delete'
        TabOrder = 2
        OnClick = btnDeleteClick
      end
      object btnDeleteInvalid: TButton
        Left = 252
        Top = 1
        Width = 88
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Delete &Invalid'
        TabOrder = 3
        OnClick = btnDeleteInvalidClick
      end
      object btnReplace: TButton
        Left = 12
        Top = 1
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Replace'
        TabOrder = 0
        OnClick = btnReplaceClick
      end
    end
    object txtSearchPath: TJvDotNetDirectoryEdit
      Left = 11
      Top = 164
      Width = 331
      Height = 21
      AcceptFiles = False
      OnButtonClick = txtSearchPathButtonClick
      DialogKind = dkWin32
      AutoCompleteFileOptions = []
      DialogOptions = [sdAllowCreate, sdPerformCreate]
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 1
    end
    object lstSearchPath: TJvDotNetListBox
      Left = 11
      Top = 49
      Width = 331
      Height = 112
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      Background.FillMode = bfmTile
      Background.Visible = False
      Sorted = True
      Style = lbOwnerDrawFixed
      TabOrder = 0
      OnClick = lstSearchPathClick
      OnDrawItem = lstSearchPathDrawItem
    end
  end
  object btnCancel: TButton
    Left = 280
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 200
    Top = 240
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
