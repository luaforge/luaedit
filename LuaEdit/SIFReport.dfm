object frmSIFReport: TfrmSIFReport
  Left = 458
  Top = 255
  BorderStyle = bsToolWindow
  Caption = 'Find in Files Report'
  ClientHeight = 150
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 81
    Height = 13
    Caption = 'Last/Current File:'
  end
  object lblCurrentFile: TJvLabel
    Left = 8
    Top = 24
    Width = 233
    Height = 13
    AutoSize = False
    Color = clBtnFace
    ParentColor = False
    AutoOpenURL = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = tePathEllipsis
  end
  object Label4: TLabel
    Left = 8
    Top = 48
    Width = 66
    Height = 13
    Caption = 'Match Found:'
  end
  object Label5: TLabel
    Left = 128
    Top = 48
    Width = 74
    Height = 13
    Caption = 'Scanned Lines:'
  end
  object Label3: TLabel
    Left = 128
    Top = 88
    Width = 66
    Height = 13
    Caption = 'Skipped Files:'
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 70
    Height = 13
    Caption = 'Scanned Files:'
  end
  object lblMatchFound: TJvLabel
    Left = 8
    Top = 64
    Width = 113
    Height = 13
    AutoSize = False
    Color = clBtnFace
    ParentColor = False
    AutoOpenURL = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = tePathEllipsis
  end
  object lblScannedLines: TJvLabel
    Left = 128
    Top = 64
    Width = 113
    Height = 13
    AutoSize = False
    Color = clBtnFace
    ParentColor = False
    AutoOpenURL = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = tePathEllipsis
  end
  object lblScannedFiles: TJvLabel
    Left = 8
    Top = 104
    Width = 113
    Height = 13
    AutoSize = False
    Color = clBtnFace
    ParentColor = False
    AutoOpenURL = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = tePathEllipsis
  end
  object lblSkippedFiles: TJvLabel
    Left = 128
    Top = 104
    Width = 113
    Height = 13
    AutoSize = False
    Color = clBtnFace
    ParentColor = False
    AutoOpenURL = False
    HotTrackFont.Charset = DEFAULT_CHARSET
    HotTrackFont.Color = clWindowText
    HotTrackFont.Height = -11
    HotTrackFont.Name = 'MS Sans Serif'
    HotTrackFont.Style = []
    TextEllipsis = tePathEllipsis
  end
  object chkKeepReportOpened: TCheckBox
    Left = 8
    Top = 128
    Width = 233
    Height = 17
    Caption = 'Keep this window opened when finished'
    TabOrder = 0
    OnClick = chkKeepReportOpenedClick
  end
end
