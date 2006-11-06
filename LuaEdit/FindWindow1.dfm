object frmFindWindow1: TfrmFindWindow1
  Left = 498
  Top = 287
  Width = 350
  Height = 200
  BorderStyle = bsSizeToolWin
  Caption = 'Find Window 1'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 350
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
  object lvwResult: TJvDotNetListView
    Left = 0
    Top = 0
    Width = 342
    Height = 173
    Align = alClient
    Columns = <
      item
        Caption = 'File Name'
        Width = 100
      end
      item
        Caption = 'Line'
      end
      item
        AutoSize = True
        Caption = 'Snipset'
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawSubItem = lvwResultCustomDrawSubItem
    OnDblClick = lvwResultDblClick
    ColumnsOrder = '0=100,1=50,2=188'
    SortOnClick = False
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmLuaEditMain.jvDockVSNet
    Left = 8
    Top = 24
  end
end
