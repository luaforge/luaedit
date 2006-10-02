object frmLuaLocals: TfrmLuaLocals
  Left = 408
  Top = 300
  Width = 515
  Height = 252
  BorderStyle = bsSizeToolWin
  Caption = 'Lua Locals'
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
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
  object lstLocals: TJvListBox
    Left = 0
    Top = 0
    Width = 507
    Height = 225
    Align = alClient
    ItemHeight = 13
    Background.FillMode = bfmTile
    Background.Visible = False
    TabOrder = 0
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmLuaEditMain.jvDockVSNet
    Left = 24
    Top = 16
  end
end
