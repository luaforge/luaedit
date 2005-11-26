object frmMainSimon: TfrmMainSimon
  Left = 447
  Top = 136
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Simon'
  ClientHeight = 473
  ClientWidth = 402
  Color = clBlack
  TransparentColorValue = clNone
  Constraints.MinHeight = 389
  Constraints.MinWidth = 389
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblGreen: TLabel
    Left = 16
    Top = 16
    Width = 185
    Height = 185
    Cursor = crHandPoint
    AutoSize = False
    Color = clGreen
    ParentColor = False
    Transparent = False
    OnMouseDown = lblGreenMouseDown
    OnMouseUp = lblGreenMouseUp
  end
  object lblRed: TLabel
    Left = 200
    Top = 16
    Width = 185
    Height = 185
    Cursor = crHandPoint
    AutoSize = False
    Color = clMaroon
    ParentColor = False
    Transparent = False
    OnMouseDown = lblRedMouseDown
    OnMouseUp = lblRedMouseUp
  end
  object lblBlue: TLabel
    Left = 200
    Top = 200
    Width = 185
    Height = 185
    Cursor = crHandPoint
    AutoSize = False
    Color = clNavy
    ParentColor = False
    Transparent = False
    OnMouseDown = lblBlueMouseDown
    OnMouseUp = lblBlueMouseUp
  end
  object lblYellow: TLabel
    Left = 16
    Top = 200
    Width = 185
    Height = 185
    Cursor = crHandPoint
    AutoSize = False
    Color = clOlive
    ParentColor = False
    Transparent = False
    OnMouseDown = lblYellowMouseDown
    OnMouseUp = lblYellowMouseUp
  end
  object Shape1: TShape
    Left = 16
    Top = 393
    Width = 169
    Height = 65
    Brush.Color = clBlack
    Pen.Color = clWhite
    Pen.Width = 5
    Shape = stRoundRect
  end
  object Label1: TLabel
    Left = 43
    Top = 406
    Width = 114
    Height = 38
    Caption = 'SIMON'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -32
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object shpPlay: TShape
    Left = 353
    Top = 432
    Width = 25
    Height = 25
    Cursor = crHandPoint
    Pen.Color = clWhite
    Shape = stCircle
    OnMouseDown = shpPlayMouseDown
  end
  object Label2: TLabel
    Left = 349
    Top = 407
    Width = 36
    Height = 19
    Caption = 'Play'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object shpGameOver: TShape
    Left = 8
    Top = 161
    Width = 385
    Height = 88
    Brush.Color = clBlack
    Pen.Color = clWhite
    Pen.Width = 5
    Shape = stRoundRect
  end
  object lblGameOver: TLabel
    Left = 18
    Top = 168
    Width = 365
    Height = 75
    Caption = 'Game Over'
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -64
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object shpPower: TShape
    Left = 272
    Top = 432
    Width = 69
    Height = 25
    Cursor = crHandPoint
    Brush.Color = clLime
    Pen.Color = clLime
    Shape = stRoundRect
    OnMouseDown = shpPowerMouseDown
  end
  object Label3: TLabel
    Left = 280
    Top = 407
    Width = 52
    Height = 19
    Caption = 'Power'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 200
    Top = 407
    Width = 46
    Height = 19
    Caption = 'Score'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape2: TShape
    Left = 192
    Top = 432
    Width = 65
    Height = 25
    Brush.Color = clBlack
    Pen.Color = clWhite
    Pen.Width = 5
    Shape = stRoundRect
  end
  object lblScore: TLabel
    Left = 206
    Top = 438
    Width = 39
    Height = 14
    Alignment = taCenter
    AutoSize = False
    Caption = '0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object shpMessage: TShape
    Left = 8
    Top = 161
    Width = 385
    Height = 88
    Brush.Color = clBlack
    Pen.Color = clWhite
    Pen.Width = 5
    Shape = stRoundRect
    Visible = False
  end
  object lblMessage: TLabel
    Left = 16
    Top = 176
    Width = 369
    Height = 57
    Alignment = taCenter
    AutoSize = False
    Caption = 'A Message!'
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -48
    Font.Name = 'Bookman Old Style'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
end
