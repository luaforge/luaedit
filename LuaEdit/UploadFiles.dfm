object frmUploadFiles: TfrmUploadFiles
  Left = 443
  Top = 285
  BorderStyle = bsSingle
  Caption = 'Uploading Files...'
  ClientHeight = 241
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 104
    Width = 34
    Height = 13
    Caption = 'Source'
  end
  object jvlblSource: TJvLabel
    Left = 80
    Top = 104
    Width = 201
    Height = 13
    AutoSize = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = tePathEllipsis
  end
  object Label2: TLabel
    Left = 8
    Top = 128
    Width = 34
    Height = 13
    Caption = 'Target:'
  end
  object jvlblTarget: TJvLabel
    Left = 80
    Top = 128
    Width = 201
    Height = 13
    AutoSize = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = tePathEllipsis
  end
  object Label3: TLabel
    Left = 8
    Top = 152
    Width = 23
    Height = 13
    Caption = 'Size:'
  end
  object jvlblSize: TJvLabel
    Left = 80
    Top = 152
    Width = 201
    Height = 13
    AutoSize = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = teEndEllipsis
  end
  object Label4: TLabel
    Left = 8
    Top = 176
    Width = 25
    Height = 13
    Caption = 'Host:'
  end
  object jvlblHost: TJvLabel
    Left = 80
    Top = 176
    Width = 201
    Height = 13
    AutoSize = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = teEndEllipsis
  end
  object anmFileTransfer: TAnimate
    Left = 8
    Top = 8
    Width = 272
    Height = 60
    CommonAVI = aviCopyFiles
    StopFrame = 31
  end
  object pgbFileTransfer: TProgressBar
    Left = 8
    Top = 72
    Width = 273
    Height = 16
    Step = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 208
    Top = 208
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 2
  end
end
