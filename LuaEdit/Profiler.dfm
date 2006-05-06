object frmProfiler: TfrmProfiler
  Left = 441
  Top = 247
  Width = 601
  Height = 211
  BorderStyle = bsSizeToolWin
  Caption = 'Profiler'
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object vstLuaProfiler: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 593
    Height = 184
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    TabOrder = 0
    TreeOptions.SelectionOptions = [toFullRowSelect]
    TreeOptions.StringOptions = [toSaveCaptions]
    OnAfterCellPaint = vstLuaProfilerAfterCellPaint
    OnCollapsing = vstLuaProfilerCollapsing
    OnGetText = vstLuaProfilerGetText
    OnGetNodeDataSize = vstLuaProfilerGetNodeDataSize
    Columns = <
      item
        Position = 0
        Width = 150
        WideText = 'Function Name'
      end
      item
        Position = 1
        WideText = 'Line'
      end
      item
        Position = 2
        WideText = 'Source'
      end
      item
        Position = 3
        Style = vsOwnerDraw
        Width = 125
        WideText = 'Relative Usage'
      end
      item
        Position = 4
        Style = vsOwnerDraw
        Width = 125
        WideText = 'Overall Usage'
      end
      item
        Position = 5
        Width = 100
        WideText = 'Duration (s)'
      end
      item
        Position = 6
        Width = 75
        WideText = 'Enter Time'
      end
      item
        Position = 7
        Width = 75
        WideText = 'Exit Time'
      end>
  end
  object JvDockClient1: TJvDockClient
    DirectDrag = False
    DockStyle = frmMain.jvDockVSNet
    Left = 16
    Top = 32
  end
end
