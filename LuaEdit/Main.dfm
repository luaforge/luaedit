object frmMain: TfrmMain
  Left = 355
  Top = 183
  Width = 684
  Height = 490
  Caption = 'LuaEdit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    800000000000000000000000000000008787878787878787878788F000000080
    000000000000000000000088000000887878787878787878787F780800000800
    00000000000000000887F780800008FFFFFFFFFFFFFFFFFF00887F78000008FF
    FFFFFFFFFFFFFFFF070887F08000008FFFFFFFFFFFFFFFFF077088780000008F
    FFFFFFFFFFFFFFFF0F7708808000008FFFFFFFFFFFFFFFFF07F7708800000008
    FFFFFFFFFFFFFFFF0F7F770080000008FFFFFFFFFFFFFFFF0000000800000008
    FFF76F7F7676FF76F7FFFF8080000008FFF67F66FFF6F6F6F66FFF0800000008
    FFFFFFFFFFFFFFFFFFFFFF8080000008FFFFFFFFFFFFFFFFFFFFFF0800000008
    FFFFFFFFFFFFFFFFFFFFFF8080000008FFF677F6F767F667F7FFFF0800000008
    FFF6FF6F7FF6F7F6F6FFFF8080000008FFFFFFFFFFFFFFFFFFFFFF0800000008
    FFFFFFFFFFFFFFFFFFFFFF8080000008FFFFFFFFFFFFFFFFFFFFFF0800000008
    FFF776F6F6776F76F6FFFF8080000008FFF6FFFF6FFFF6F6F7FFFF0800000008
    FFFFFFFFFFFFFFFFFFFFFF8080000008FFFFFFFFFFFFFFFFFFFFFF0800000001
    F9F9F9F9F9F9F9F9F9F9F980800000039B9B9B9B9B9B9B9B9B9B9B0800000001
    F9F9F9F9F9F9F9F9F9F9F930800000039B9B9B9B9B9B9B9B9B9B9B1300000001
    F9F9F9F9F9F9F9F9F9F9F9F1800000001313131313131313131313130000F000
    001FF000000FC0000007C0000007800000078000000780000007C0000007C000
    0007C0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007E0000007E0000007E0000007E0000007E0000007E0000007E0000007E000
    0007E0000007E0000007E0000007E0000007E0000007E0000007F0000007}
  KeyPreview = True
  Menu = mnuMain
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 56
    Width = 676
    Height = 388
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 676
      Height = 388
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 676
        Height = 388
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object stbMain: TStatusBar
          Left = 0
          Top = 369
          Width = 676
          Height = 19
          Panels = <
            item
              Bevel = pbNone
              Style = psOwnerDraw
              Width = 100
            end
            item
              Bevel = pbNone
              Style = psOwnerDraw
              Width = 75
            end
            item
              Bevel = pbNone
              Style = psOwnerDraw
              Width = 75
            end
            item
              Bevel = pbNone
              Style = psOwnerDraw
              Width = 75
            end
            item
              Bevel = pbNone
              Style = psOwnerDraw
              Width = 75
            end
            item
              Bevel = pbNone
              Style = psOwnerDraw
              Width = 75
            end>
          OnDrawPanel = stbMainDrawPanel
        end
        object jvUnitBar: TJvTabBar
          Left = 0
          Top = 0
          Width = 676
          Height = 25
          PopupMenu = ppmUnits
          SelectBeforeClose = True
          Tabs = <>
          Painter = jvModernUnitBarPainter
          OnTabClosing = jvUnitBarTabClosing
          OnTabSelected = jvUnitBarTabSelected
        end
        object pnlMain: TPanel
          Left = 0
          Top = 25
          Width = 676
          Height = 344
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 2
        end
      end
    end
  end
  object ctrlBar: TControlBar
    Left = 0
    Top = 0
    Width = 676
    Height = 56
    Align = alTop
    AutoSize = True
    PopupMenu = ppmToolBar
    TabOrder = 1
    OnDockOver = ctrlBarDockOver
    object tlbRun: TToolBar
      Left = 320
      Top = 2
      Width = 214
      Height = 22
      Align = alLeft
      AutoSize = True
      Caption = 'Run ToolBar'
      EdgeBorders = []
      Flat = True
      Images = imlActions
      TabOrder = 0
      object ToolButton11: TToolButton
        Left = 0
        Top = 0
        Action = actRunScript
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton12: TToolButton
        Left = 23
        Top = 0
        Action = actPause
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton13: TToolButton
        Left = 46
        Top = 0
        Action = actStop
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton14: TToolButton
        Left = 69
        Top = 0
        Width = 10
        Caption = 'ToolButton14'
        ImageIndex = 33
        Style = tbsSeparator
      end
      object ToolButton15: TToolButton
        Left = 79
        Top = 0
        Action = actCheckSyntax
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton19: TToolButton
        Left = 102
        Top = 0
        Width = 10
        Caption = 'ToolButton19'
        ImageIndex = 37
        Style = tbsSeparator
      end
      object ToolButton16: TToolButton
        Left = 112
        Top = 0
        Action = actStepInto
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton17: TToolButton
        Left = 135
        Top = 0
        Action = actStepOver
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton18: TToolButton
        Left = 158
        Top = 0
        Action = actRunToCursor
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton20: TToolButton
        Left = 181
        Top = 0
        Width = 10
        Caption = 'ToolButton20'
        ImageIndex = 34
        Style = tbsSeparator
      end
      object ToolButton21: TToolButton
        Left = 191
        Top = 0
        Action = actAddBreakpoint
        ParentShowHint = False
        ShowHint = True
      end
    end
    object tlbBaseFile: TToolBar
      Left = 11
      Top = 2
      Width = 283
      Height = 22
      Align = alLeft
      AutoSize = True
      Caption = 'File ToolBar'
      EdgeBorders = []
      Flat = True
      Images = imlActions
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Action = actNewProject
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton3: TToolButton
        Left = 23
        Top = 0
        Action = actNewUnit
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton4: TToolButton
        Left = 46
        Top = 0
        Width = 10
        Caption = 'ToolButton4'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton2: TToolButton
        Left = 56
        Top = 0
        Action = actOpenFile
        DropdownMenu = mnuReopen
        ParentShowHint = False
        ShowHint = True
        Style = tbsDropDown
      end
      object ToolButton7: TToolButton
        Left = 92
        Top = 0
        Action = actSave
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton6: TToolButton
        Left = 115
        Top = 0
        Action = actSaveAs
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton8: TToolButton
        Left = 138
        Top = 0
        Width = 10
        Caption = 'ToolButton8'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object ToolButton5: TToolButton
        Left = 148
        Top = 0
        Action = actOpenProject
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton9: TToolButton
        Left = 171
        Top = 0
        Action = actSaveProjectAs
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton34: TToolButton
        Left = 194
        Top = 0
        Action = actAddToPrj
      end
      object ToolButton33: TToolButton
        Left = 217
        Top = 0
        Action = actRemoveFromPrj
      end
      object ToolButton22: TToolButton
        Left = 240
        Top = 0
        Width = 10
        Caption = 'ToolButton22'
        ImageIndex = 7
        Style = tbsSeparator
      end
      object ToolButton10: TToolButton
        Left = 250
        Top = 0
        Action = actSaveAll
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton23: TToolButton
        Left = 273
        Top = 0
        Action = actPrint
      end
    end
    object tlbEdit: TToolBar
      Left = 11
      Top = 28
      Width = 272
      Height = 22
      Align = alLeft
      AutoSize = True
      ButtonWidth = 28
      Caption = 'File ToolBar'
      EdgeBorders = []
      Flat = True
      Images = imlActions
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      object ToolButton35: TToolButton
        Left = 0
        Top = 0
        Action = actUndo
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton36: TToolButton
        Left = 28
        Top = 0
        Action = actRedo
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton37: TToolButton
        Left = 56
        Top = 0
        Width = 10
        Caption = 'ToolButton4'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton38: TToolButton
        Left = 66
        Top = 0
        Action = actCut
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton39: TToolButton
        Left = 94
        Top = 0
        Action = actCopy
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton40: TToolButton
        Left = 122
        Top = 0
        Action = actPaste
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton41: TToolButton
        Left = 150
        Top = 0
        Width = 10
        Caption = 'ToolButton8'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object ToolButton42: TToolButton
        Left = 160
        Top = 0
        Action = actBlockUnindent
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton43: TToolButton
        Left = 188
        Top = 0
        Action = actBlockIndent
        ParentShowHint = False
        ShowHint = True
      end
      object ToolButton24: TToolButton
        Left = 216
        Top = 0
        Action = actBlockComment
      end
      object ToolButton25: TToolButton
        Left = 244
        Top = 0
        Action = actBlockUncomment
      end
    end
  end
  object actListMain: TActionList
    Images = imlActions
    Left = 48
    Top = 249
    object actNewProject: TAction
      Category = 'File Operation'
      Caption = 'Project'
      Hint = 'New Project'
      ImageIndex = 10
      OnExecute = actNewProjectExecute
    end
    object actNewUnit: TAction
      Category = 'File Operation'
      Caption = 'Unit'
      Hint = 'New Unit'
      ImageIndex = 11
      OnExecute = actNewUnitExecute
    end
    object actOpenFile: TAction
      Category = 'File Operation'
      Caption = 'Open File...'
      Hint = 'Open File...'
      ImageIndex = 2
      ShortCut = 16463
      OnExecute = actOpenFileExecute
    end
    object actOpenProject: TAction
      Category = 'File Operation'
      Caption = 'Open Lua Project...'
      Hint = 'Open Lua Project...'
      ImageIndex = 3
      ShortCut = 49231
      OnExecute = actOpenProjectExecute
    end
    object actExit: TAction
      Category = 'Application Related'
      Caption = 'Exit'
      ImageIndex = 1
      OnExecute = actExitExecute
    end
    object actSave: TAction
      Category = 'File Operation'
      Caption = 'Save'
      Hint = 'Save current file'
      ImageIndex = 5
      ShortCut = 16467
      OnExecute = actSaveExecute
    end
    object actSaveAs: TAction
      Category = 'File Operation'
      Caption = 'Save As...'
      Hint = 'Save As...'
      ImageIndex = 7
      OnExecute = actSaveAsExecute
    end
    object actSaveProjectAs: TAction
      Category = 'File Operation'
      Caption = 'Save Project As...'
      Hint = 'Save Project As...'
      ImageIndex = 8
      OnExecute = actSaveProjectAsExecute
    end
    object actSaveAll: TAction
      Category = 'File Operation'
      Caption = 'Save All'
      Hint = 'Save All'
      ImageIndex = 6
      ShortCut = 24659
      OnExecute = actSaveAllExecute
    end
    object actClose: TAction
      Category = 'File Operation'
      Caption = 'Close Unit'
      Hint = 'Close Unit'
      OnExecute = actCloseExecute
    end
    object actPrint: TAction
      Category = 'Application Related'
      Caption = 'Print...'
      Hint = 'Print...'
      ImageIndex = 4
      OnExecute = actPrintExecute
    end
    object actUndo: TAction
      Category = 'Code Manipulation'
      Caption = 'Undo'
      Hint = 'Undo'
      ImageIndex = 14
      ShortCut = 16474
      OnExecute = actUndoExecute
    end
    object actRedo: TAction
      Category = 'Code Manipulation'
      Caption = 'Redo'
      Hint = 'Redo'
      ImageIndex = 13
      ShortCut = 24666
      OnExecute = actRedoExecute
    end
    object actSelectAll: TAction
      Category = 'Code Manipulation'
      Caption = 'Select All'
      Hint = 'Select All'
      ShortCut = 16449
      OnExecute = actSelectAllExecute
    end
    object actCut: TAction
      Category = 'Code Manipulation'
      Caption = 'Cut'
      Hint = 'Cut'
      ImageIndex = 16
      ShortCut = 16472
      OnExecute = actCutExecute
    end
    object actCopy: TAction
      Category = 'Code Manipulation'
      Caption = 'Copy'
      Hint = 'Copy'
      ImageIndex = 15
      ShortCut = 16451
      OnExecute = actCopyExecute
    end
    object actPaste: TAction
      Category = 'Code Manipulation'
      Caption = 'Paste'
      Hint = 'Paste'
      ImageIndex = 12
      ShortCut = 16470
      OnExecute = actPasteExecute
    end
    object actSearch: TAction
      Category = 'Code Manipulation'
      Caption = 'Search...'
      Hint = 'Search...'
      ImageIndex = 17
      ShortCut = 16454
      OnExecute = actSearchExecute
    end
    object actSearchAgain: TAction
      Category = 'Code Manipulation'
      Caption = 'Search Again'
      Hint = 'Search Again'
      ImageIndex = 18
      ShortCut = 114
      OnExecute = actSearchAgainExecute
    end
    object actSearchReplace: TAction
      Category = 'Code Manipulation'
      Caption = 'Replace...'
      Hint = 'Replace...'
      ImageIndex = 22
      ShortCut = 16466
      OnExecute = actSearchReplaceExecute
    end
    object actGoToLine: TAction
      Category = 'Code Manipulation'
      Caption = 'Goto Line...'
      Hint = 'Goto Line...'
      ImageIndex = 20
      ShortCut = 24647
      OnExecute = actGoToLineExecute
    end
    object actRunScript: TAction
      Category = 'Debugging Operations'
      Caption = 'Run Script'
      Hint = 'Run Script'
      ImageIndex = 26
      ShortCut = 116
      OnExecute = actRunScriptExecute
    end
    object actStepOver: TAction
      Category = 'Debugging Operations'
      Caption = 'Step Over'
      Hint = 'Step Over'
      ImageIndex = 24
      ShortCut = 121
      OnExecute = actStepOverExecute
    end
    object actStepInto: TAction
      Category = 'Debugging Operations'
      Caption = 'Step Into'
      Hint = 'Step Into'
      ImageIndex = 23
      ShortCut = 122
      OnExecute = actStepIntoExecute
    end
    object actAddBreakpoint: TAction
      Category = 'Debugging Operations'
      Caption = 'Toggle Breakpoint'
      Hint = 'Toggle Breakpoint'
      ImageIndex = 42
      ShortCut = 120
      OnExecute = actAddBreakpointExecute
    end
    object actCheckSyntax: TAction
      Category = 'Debugging Operations'
      Caption = 'Check Syntax'
      Hint = 'Check Syntax'
      ImageIndex = 31
      ShortCut = 16502
      OnExecute = actCheckSyntaxExecute
    end
    object actPause: TAction
      Category = 'Debugging Operations'
      Caption = 'Pause Script'
      Hint = 'Pause Script'
      ImageIndex = 25
      ShortCut = 24692
      OnExecute = actPauseExecute
    end
    object actStop: TAction
      Category = 'Debugging Operations'
      Caption = 'Stop Script'
      Hint = 'Stop Script'
      ImageIndex = 32
      ShortCut = 8308
      OnExecute = actStopExecute
    end
    object actRunToCursor: TAction
      Category = 'Debugging Operations'
      Caption = 'Run Script to Cursor'
      Hint = 'Run Script to Cursor'
      ImageIndex = 33
      ShortCut = 16505
      OnExecute = actRunToCursorExecute
    end
    object actAddToPrj: TAction
      Category = 'Project Manipulations'
      Caption = 'Add Unit to Project...'
      Hint = 'Add Unit to Project...'
      ImageIndex = 34
      ShortCut = 8314
      OnExecute = actAddToPrjExecute
    end
    object actRemoveFromPrj: TAction
      Category = 'Project Manipulations'
      Caption = 'Remove Unit From Project'
      Hint = 'Remove Unit from Project'
      ImageIndex = 36
      ShortCut = 8315
      OnExecute = actRemoveFromPrjExecute
    end
    object actEditorSettings: TAction
      Category = 'Application Related'
      Caption = 'Editor Settings...'
      Hint = 'Editor Settings...'
      ImageIndex = 41
      OnExecute = actEditorSettingsExecute
    end
    object actBlockUnindent: TAction
      Category = 'Code Manipulation'
      Caption = 'Unindent Selection'
      Hint = 'Unindent Selection'
      ImageIndex = 39
      ShortCut = 24661
      OnExecute = actBlockUnindentExecute
    end
    object actBlockIndent: TAction
      Category = 'Code Manipulation'
      Caption = 'Indent Selection'
      Hint = 'Indent Selection'
      ImageIndex = 40
      ShortCut = 24649
      OnExecute = actBlockIndentExecute
    end
    object actPrjSettings: TAction
      Category = 'Project Manipulations'
      Caption = 'Options...'
      Hint = 'Options...'
      ImageIndex = 35
      OnExecute = actPrjSettingsExecute
    end
    object actActiveSelPrj: TAction
      Category = 'Project Manipulations'
      Caption = 'Activate Selected Project'
      Hint = 'Activate Selected Project'
      OnExecute = actActiveSelPrjExecute
    end
    object actAddWatch: TAction
      Category = 'Debugging Operations'
      Caption = 'Add Watch'
      Hint = 'Add Watch'
      ImageIndex = 53
      OnExecute = actAddWatchExecute
    end
    object actMainMenuFile: TAction
      Caption = '&File'
      Hint = 'File Main Menu'
      OnExecute = actMainMenuFileExecute
    end
    object actMainMenuEdit: TAction
      Caption = '&Edit'
      Hint = 'Edit Main Menu'
      OnExecute = actMainMenuEditExecute
    end
    object actMainMenuView: TAction
      Caption = '&View'
      Hint = 'View Main Menu'
      OnExecute = actMainMenuViewExecute
    end
    object actMainMenuProject: TAction
      Caption = '&Project'
      Hint = 'Project Main Menu'
      OnExecute = actMainMenuProjectExecute
    end
    object actMainMenuRun: TAction
      Caption = '&Run'
      Hint = 'Run Main Menu'
      OnExecute = actMainMenuRunExecute
    end
    object actMainMenuTools: TAction
      Caption = '&Tools'
      Hint = 'Tools Main Menu'
      OnExecute = actMainMenuToolsExecute
    end
    object actMainMenuHelp: TAction
      Caption = '&?'
      Hint = 'Help Main Menu'
      OnExecute = actMainMenuHelpExecute
    end
    object actShowProjectTree: TAction
      Category = 'View Actions'
      Caption = 'Project Tree'
      Hint = 'Show Project Tree'
      ImageIndex = 44
      OnExecute = actShowProjectTreeExecute
    end
    object actShowBreakpoints: TAction
      Category = 'View Actions'
      Caption = 'Breakpoints'
      Hint = 'Show Breakpoints'
      ImageIndex = 46
      OnExecute = actShowBreakpointsExecute
    end
    object actShowMessages: TAction
      Category = 'View Actions'
      Caption = 'Messages'
      Hint = 'Show Messages'
      ImageIndex = 52
      OnExecute = actShowMessagesExecute
    end
    object actShowWatchList: TAction
      Category = 'View Actions'
      Caption = 'Watch List'
      Hint = 'Show Watch List'
      ImageIndex = 45
      OnExecute = actShowWatchListExecute
    end
    object actShowCallStack: TAction
      Category = 'View Actions'
      Caption = 'Call Stack'
      Hint = 'Show Call Stack'
      ImageIndex = 47
      OnExecute = actShowCallStackExecute
    end
    object actShowLuaStack: TAction
      Category = 'View Actions'
      Caption = 'Lua Stack'
      Hint = 'Show Lua Stack'
      ImageIndex = 49
      OnExecute = actShowLuaStackExecute
    end
    object actShowLuaOutput: TAction
      Category = 'View Actions'
      Caption = 'Lua Output'
      Hint = 'Show Lua Output'
      ImageIndex = 48
      OnExecute = actShowLuaOutputExecute
    end
    object actShowLuaGlobals: TAction
      Category = 'View Actions'
      Caption = 'Lua Globals'
      Hint = 'Show Lua Globals'
      ImageIndex = 50
      OnExecute = actShowLuaGlobalsExecute
    end
    object actShowLuaLocals: TAction
      Category = 'View Actions'
      Caption = 'Lua Locals'
      Hint = 'Show Lua Locals'
      ImageIndex = 51
      OnExecute = actShowLuaLocalsExecute
    end
    object actShowRings: TAction
      Category = 'View Actions'
      Caption = 'Rings'
      Hint = 'Show Rings'
      ImageIndex = 54
      OnExecute = actShowRingsExecute
    end
    object actShowFunctionList: TAction
      Category = 'View Actions'
      Caption = 'Function List'
      Hint = 'Show Function List'
      ImageIndex = 55
      OnExecute = actShowFunctionListExecute
    end
    object actFunctionHeader: TAction
      Category = 'Tools'
      Caption = 'Function Header...'
      OnExecute = actFunctionHeaderExecute
    end
    object actGotoLastEdited: TAction
      Category = 'Code Manipulation'
      Caption = 'Goto Last Edited'
      Hint = 'Goto Last Edited Line'
      ShortCut = 24652
      OnExecute = actGotoLastEditedExecute
    end
    object actBlockComment: TAction
      Category = 'Code Manipulation'
      Caption = 'Comment Selection'
      Hint = 'Comment Selection'
      ImageIndex = 57
      ShortCut = 24643
      OnExecute = actBlockCommentExecute
    end
    object actBlockUncomment: TAction
      Category = 'Code Manipulation'
      Caption = 'Uncomment Selection'
      Hint = 'Uncomment Selection'
      ImageIndex = 56
      ShortCut = 24662
      OnExecute = actBlockUncommentExecute
    end
  end
  object imlActions: TImageList
    Left = 48
    Top = 217
    Bitmap = {
      494C01013A003B00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000F0000000010020000000000000F0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424242004242420042424200424242004242420042424200424242004242
      4200424242004242420042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424242004242420042424200424242004242420042424200424242004242
      4200424242004242420042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242004242420042424200424242004242
      4200424242004242420042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242004242420042424200424242004242
      4200424242004242420042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF4200FFFF4200FFFF4200FFFF4200FFFF4200FFFF4200FFFF
      4200FFFF4200FFFF4200FFFF4200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF4200FFFF4200FFFF4200FFFF4200FFFF4200FFFF4200FFFF
      4200FFFF4200FFFF4200FFFF4200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF4200FFFF4200FFFF4200FFFF4200FFFF42009D4242009D9D
      9D00FFFF4200FFFF4200FFFF4200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009D42
      42009D4242009D4242009D424200000000000000000000000000000000009D42
      42009D9D9D000000000000000000000000000000000000000000000000000000
      000000000000FFFF4200FFFF4200FFFF4200FFFF4200FFFF4200FFFF4200FFFF
      4200FFFF4200FFFF4200FFFF4200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009D42
      42009D4242009D42420000000000000000000000000000000000000000000000
      00009D4242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009D42
      42009D4242009D42420000000000000000000000000000000000000000000000
      00009D4242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009D42
      420000000000000000009D4242009D9D9D000000000000000000000000009D42
      42009D9D9D000000000000000000000000000000000000000000424242004242
      4200000000004242420042424200424242004242420042424200424242004242
      4200424242004242420042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009D4242009D4242009D4242009D4242009D9D
      9D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000000000000000000084848400000000000000
      000000000000C6C6C600C6C6C600C6C6C6000000000000000000C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000000000008080800000FFFF008080
      8000000000000000000000000000FFFFFF000000000000000000FFFFFF000000
      000000000000FFFFFF00000000000000000000000000E3DFE000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E3DFE000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00C6C6C6000000000000000000FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE000000000000000000000000000000000000000
      000000000000C6C6C600FFFFFF00C6C6C6000000000000000000C6C6C600FFFF
      FF00C6C6C6000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000000000000000000000008080800000FFFF008080
      8000000000000000000000000000FFFFFF000000000000000000000000000000
      0000FFFFFF00FFFFFF00000000000000000000000000E3DFE00000000000FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFF000000000000E3DFE000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000084848400000000000000
      00000000000084848400000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE000000000000000000084848400000000008484
      8400000000000000000000000000000000000000000000000000000000008484
      84000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000001FFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      FF00FFFF000000000000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000001F
      FF00001FFF00001FFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000001FFF00001F
      FF00001FFF00001FFF00001FFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000C0C0C000FFFFFF000000
      0000FFFFFF0000000000000000000000000000000000E3DFE00000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFF000000000000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000001FFF00000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      00008400000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      FF00000000000000000000000000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF000000000000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      00000000000000000000000000000000000000000000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080008080800080808000FFFF
      0000FFFF0000FFFF0000FFFF0000808080000000000000000000000000000000
      0000000000000000000000000000FF00FF000000000080008000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000808080000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000808080000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF000000000080008000800080000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF0000000000FF00FF0000000000800080000000
      0000000000000000000000000000000000000000000075757500FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00FF0000000000FF00FF00FF00FF00FF00FF00000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      8000808080008080800000000000000000008080800000000000000000008080
      8000808080008080800080808000808080000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000808080000000000000000000808080000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00808080000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      0000000000000000000000000000000000000000000075757500B9B9B900B9B9
      B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9
      B900B9B9B900B9B9B90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000808080008080800080808000808080008080800080808000FF00
      FF00FF00FF00FF00FF00FF00FF00808080000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF0000000000000000000000
      0000000000000000000000000000000000000000000075000000750000007500
      000075000000750000007500000075000000FFFFFF0075000000FFFFFF007500
      0000FFFFFF007500000075000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000808080000000000000000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00808080000000000000000000000000000000
      0000000000000000000000000000FF00FF000000000000000000000000000000
      0000000000000000000000000000000000000000000075000000750000007500
      0000750000007500000075000000750000007500000075000000750000007500
      0000750000007500000075000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000808080000000000000000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF0000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000414141004141410041414100414141004141410041414100414141004141
      4100414141004141410041414100414141000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009D4141009D4141009D4141009D4141009D4141009D41
      4100000000000000000000000000000000000000000000000000750000007500
      0000750000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF004141410000000000B9B9B900B9B9B9000000
      0000000000000000000000000000B9B9B900B9B9B90000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF004141
      4100000000000000000000000000000000000000000000000000000000007500
      0000750000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000041414100FFFFFF004141410041414100FFFFFF009D4141009D4141009D41
      41009D4141009D414100FFFFFF004141410000000000FFFF0000FFFFFF000000
      0000000000000000000000000000FFFF0000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0041414100000000000000000000000000000000000000000075000000B9B9
      B900750000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000004141410041414100414141004141
      410041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF004141410000000000FFFF0000FFFF00000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000041414100414141004141
      41009D9D9D0041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00414141004141410041414100000000000000000075000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000041414100CDCDCD00CDCDCD00CDCD
      CD0041414100FFFFFF004141410041414100FFFFFF009D4141009D4141009D41
      41009D4141009D414100FFFFFF0041414100000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000041414100FFFFFF00FFFF
      FF0041414100FFFFFF0041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0041414100FFFFFF0041414100000000007500000000000000000000000000
      0000FFFFFF00FFFFFF0000000000757575007575750000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000041414100CDCDCD0041414100FFFF
      FF0041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00414141000000000000000000000000000000
      0000B9B9B900B9B9B900B9B9B900FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000041414100FFFFFF004141
      4100FFFFFF004141410041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000007500000000000000000000000000
      0000FFFFFF007575750000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000041414100CDCDCD00CDCDCD00CDCD
      CD00414141004141410041414100414141004141410041414100414141004141
      410041414100414141004141410041414100000000000000000000000000B9B9
      B90000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000041414100FFFFFF004141
      410041414100FFFFFF0041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000007500000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF000000000041414100CDCDCD0041414100FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CDCD
      CD00CDCDCD00414141000000000000000000000000000000000000000000FFFF
      FF00B9B9B90000000000B9B9B90000000000B9B9B90075757500FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000007500000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF000000000041414100CDCDCD00CDCDCD00CDCD
      CD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCD
      CD00CDCDCD00414141000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000007500000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF000000000041414100CDCDCD0041414100FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CDCD
      CD00CDCDCD00414141000000000000000000000000000000000000000000FFFF
      FF00757575007575750075757500FFFFFF007575750075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0041414100FFFFFF0041414100FFFFFF00414141004141
      4100FFFFFF00FFFFFF0041414100000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000041414100CDCDCD00CDCDCD00CDCD
      CD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCD
      CD00CDCDCD00414141000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF004141410041414100FFFFFF0041414100FFFF
      FF00FFFFFF00FFFFFF0041414100000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000041414100CDCDCD0041414100CDCD
      CD00CDCDCD004141410041414100414141004141410041414100414141004141
      410041414100414141000000000000000000000000000000000000000000FFFF
      FF0075757500757575007575750075757500FFFFFF007575750075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004141410041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00414141000000000000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000007575750075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000041414100CDCDCD00CDCDCD00CDCD
      CD00CDCDCD0041414100CDCDCD00FFFFFF00CDCDCD00CDCDCD00414141000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000009D4141009D4141009D41
      41009D4141009D4141009D4141009D4141009D4141009D4141009D4141009D41
      41009D4141009D4141009D4141000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000041414100414141004141
      4100414141000000000041414100414141004141410041414100000000000000
      0000000000000000000000000000000000000000000000000000750000007500
      0000750000007500000075000000750000007500000075000000750000007500
      000075000000750000007500000075000000000000009D4141009D4141009D41
      41009D4141009D4141009D4141009D4141009D4141009D4141009D4141009D41
      41009D4141009D4141009D4141000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000075000000750000007500000075000000750000007500
      0000750000007500000075000000750000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000750000007500
      0000750000007500000075000000750000007500000075000000750000007500
      0000750000007500000075000000750000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000075000000750000007500000075000000750000007500
      0000750000007500000075000000750000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C60084848400000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420000000000424242004242420000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF000000
      0000FFFFFF008484840084848400848484008484840084848400848484008484
      8400FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420000000000424242004242420042424200424242004242
      42004242420042424200424242004242420000000000C6C6C600000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000848484000000000000FFFF000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C60000000000FFFF
      FF00000000000000000084848400848484008484840084848400848484008484
      8400FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000848484000000
      00000000000000000000000000000000000000000000000000009D4242000000
      0000000000000000000000000000424242004242420042424200424242004242
      42004242420000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C6008484840000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      00000000000000000000000000000000000000000000000000009D4242009D42
      4200000000000000000000000000424242004242420042424200424242004242
      42004242420000000000000000000000000000000000C6C6C600FFFFFF000000
      0000FFFFFF008484840084848400848484008484840084848400848484008484
      8400FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000009D4242009D4242009D4242009D42
      42009D4242000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      00000000000000000000000000000000000000000000000000009D4242009D42
      4200000000000000000000000000424242004242420042424200424242004242
      42004242420042424200424242004242420000000000C6C6C60000000000FFFF
      FF00000000000000000084848400848484008484840084848400848484008484
      8400FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000848484000000
      00000000000000000000000000000000000000000000000000009D4242000000
      0000000000000000000000000000424242004242420042424200424242004242
      42004242420042424200424242004242420000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C60084848400000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000848484000000000000FFFF000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF008484840084848400848484008484840084848400FFFFFF008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420000000000424242004242420042424200424242004242
      42004242420042424200424242004242420000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600FFFFFF008484840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000666666003D3D3D003D3D
      3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D
      3D003D3D3D00A7A7A70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009D419D009D419D00419D9D009D419D0041414100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006666660055DFD4003D3D3D0055DF
      FF0055DFFF0055DFFF0055DFFF0055DFFF0055DFD40055DFFF0055DFD40055DF
      FF0055C0D4003D3D3D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009D41
      9D009D419D00419D9D00FFFFFF00CDCDCD00FFFFFF009D419D00414141000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242000000000000000000000000000000
      0000000000000000000000000000000000006666660000F2FF0055DFD4003D3D
      3D00A9FFFF0055DFFF0055DFFF0055DFFF0055DFFF0055DFFF0055DFFF0055DF
      D40055DFFF0055DFD4003D3D3D00000000000000000000000000000080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D419D009D419D00419D
      9D00FFFFFF00FFFFFF00CDCDCD00CDCDCD00CDCDCD00FFFFFF009D419D004141
      4100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007373730054FFFF0000F2FF0055DF
      D4003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D
      3D003D3D3D003D3D3D003D3D3D003D3D3D000000000000000000000000000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009D419D00419D9D00FFFFFF00FFFF
      FF00CDCDCD00CDCDCD009D9D9D009D419D009D9D9D00CDCDCD00FFFFFF009D41
      9D00414141000000000000000000000000000000000000000000424242004242
      4200424242004242420000000000424242004242420000000000000000000000
      0000000000000000000000000000000000007373730054FFFF0054FFFF0000F2
      FF0055DFD40000F2FF0055DFD400FFFFFF0098F7FF0099F7FF0098F7FF0098F7
      FF0098F7FF0098F7FF0098F7FF00B4B4B4000000000000000000000000000000
      0000000080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009D419D00CDCDCD00CDCDCD00CDCD
      CD009D9D9D009D419D009D419D00FF41FF00414141009D9D9D00CDCDCD00FFFF
      FF009D419D004141410000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000081818100A9FFFF0054FFFF0054FF
      FF0000F2FF0055DFD400B4B4B400FFFFFF0099F8FF00AAFFFF0099F8FF00AAFF
      FF0099F8FF00AAFFFF0099F8FF00B4B4B4000000000000000000000000000000
      0000000000000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009D419D00CDCDCD009D9D9D009D41
      9D009D419D00FF41FF00FF41FF00FF41FF009D419D00414141009D9D9D00CDCD
      CD00FFFFFF009D419D0041414100000000000000000000000000424242004242
      4200424242004242420000000000424242004242420042424200424242004242
      4200424242004242420042424200424242008181810054FFFF00A9FFFF008181
      8100737373005959590059595900595959005959590073737300AAFFFF0099F8
      FF00AAFFFF0099F8FF00AAFFFF00767676000000000000000000000000000000
      0000000000000000000000008000000000000000000000000000000000000000
      0000000000000000000000000000000000009D419D009D419D009D419D00FF41
      FF00FF41FF009D419D009D419D00FF41FF00FF41FF009D419D00414141009D9D
      9D00CDCDCD00FFFFFF009D419D00414141000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009A9A9A00A9FFFF0054FFFF008181
      8100005FFF00001FFF00001FFF00001FFF00001FFF005959590099F8FF00AAFF
      FF0099F8FF00AAFFFF0099F8FF00767676000000000000000000000000000000
      0000000000000000000000000000000080000000000000000000000000000000
      0000000000000000000000000000000000009D419D00CDCDCD00FF41FF00FF41
      FF00FF41FF0041FFFF00CDCDCD00419D9D009D419D00FF41FF009D419D004141
      41009D9D9D00CDCDCD009D419D004141410000000000000000009D4242000000
      0000000000000000000000000000424242004242420042424200424242004242
      4200424242000000000000000000000000009A9A9A0054FFFF00A9FFFF008181
      81001D94F7001D94F700005FFF00001FFF00001FFF0059595900AAFFFF0099F8
      FF00AAFFFF0099F8FF00AAFFFF00818181000000000000000000000000000000
      0000000000000000000000000000000000000000800000000000000000000000
      000000000000008080000000000000000000000000009D419D00CDCDCD00FF41
      FF00FF41FF00FF41FF00FF41FF0041FFFF0041FFFF00CDCDCD00419D9D009D41
      9D00414141009D9D9D009D419D00CDCDCD00000000009D4242009D4242000000
      0000000000000000000000000000424242004242420042424200424242004242
      420042424200000000000000000000000000A7A7A700A7A7A70000F2FF00A7A7
      A7009A9A9A009A9A9A009A9A9A009A9A9A009A9A9A00A7A7A70099F8FF00AAFF
      FF0099F8FF00AAFFFF0099F8FF008E8E8E000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000000000000
      00000000000000808000008080000000000000000000000000009D419D00CDCD
      CD00FF41FF00FF41FF00FF41FF00FF41FF00FF41FF00CDCDCD0041FFFF009D41
      9D009D419D00414141009D419D00CDCDCD009D4242009D4242009D4242009D42
      42009D4242000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A7A7A70000F2FF0000F2
      FF0000F2FF0000F2FF00B4B4B400FFFFFF00AAFFFF00AAFFFF00AAFFFF0099F8
      FF0055DFFF0055DFFF0055C0D4009A9A9A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000009D41
      9D00CDCDCD00FF41FF00FF41FF0041FFFF0041FFFF0041FFFF00419D9D009D41
      9D00FF41FF009D419D004141410041414100000000009D4242009D4242000000
      0000000000000000000000000000424242004242420042424200424242004242
      420042424200424242004242420042424200000000009B9B9B0054FFFF0067F4
      FF0067F4FF0067F4FF0091919100FFFFFF00AAFFFF00AAFFFF00AAFFFF00B4B4
      B400A0A0A0008D8D8D0081818100A7A7A7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000008080000000000000000000000000000000000000000000000000000000
      00009D419D00CDCDCD00FF41FF00FF41FF00419D9D00419D9D009D419D00FF41
      FF009D419D009D419D00414141000000000000000000000000009D4242000000
      0000000000000000000000000000424242004242420042424200424242004242
      42004242420042424200424242004242420000000000000000009B9B9B008D8D
      8D008D8D8D00B4B4B40090909000FFFFFF00FFFFFF00AAFFFF00AAFFFF00A1A1
      A100E6E6E600DADADA00DADADA00B4B4B4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000009D419D00CDCDCD00FF41FF00FF41FF00FF41FF00FF41FF009D41
      9D00414141000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000091919100FFFFFF00AAFFFF00FFFFFF00AAFFFF00A7A7
      A700FFFFFF00E7E7E700B4B4B400000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009D419D00CDCDCD00FF41FF009D419D00414141000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420000000000424242004242420042424200424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      0000000000000000000091919100FFFFFF00FFFFFF00AAFFFF00FFFFFF008D8D
      8D00FFFFFF00B4B4B40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009D419D004141410000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B4B4B400A7A7A700A7A7A7009A9A9A008E8E8E008181
      8100C1C1C1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A8A8A800666666003D3D
      3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D
      3D003D3D3D003D3D3D00A7A7A700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006666660055DFD4003D3D
      3D0055DFFF0055DFFF0055DFFF0055DFFF0055DFFF0055DFD40055DFFF0055DF
      D40055DFFF0055C0D4003D3D3D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004242420042424200424242004242
      420042424200424242004242420042424200000000006666660000F2FF0055DF
      D4003D3D3D00A9FFFF0055DFFF0055DFFF0055DFFF0055DFFF0055DFFF0055DF
      FF0055DFD40055DFFF0055DFD4003D3D3D0084848400FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007373730054FFFF0000F2
      FF0055DFD4003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D3D003D3D
      3D003D3D3D003D3D3D003D3D3D003D3D3D0084848400C6C6C600FFFFFF00C6C6
      C60000000000C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      420042424200424242004242420042424200000000007373730054FFFF0054FF
      FF0000F2FF0055DFD40000F2FF0055DFD40099F8FF0099F8FF0099F8FF0099F8
      FF0099F8FF0099F8FF0099F8FF00B4B4B40084848400FFFFFF00C6C6C6000000
      00000000000000000000C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF0000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000081818100A9FFFF0054FF
      FF0054FFFF0000F2FF00EFAD00007F5B0000EFAD0000AAFFFF0099F8FF00AAFF
      FF0099F8FF00AAFFFF0099F8FF007676760084848400C6C6C600FFFFFF000000
      0000FFFFFF000000000000000000C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      420042424200424242004242420042424200000000008181810054FFFF00A9FF
      FF0054FFFF0054FFFF007F5B0000D9A77D007F5B0000FFFFFF00AAFFFF0099F8
      FF00AAFFFF0099F8FF00AAFFFF007676760084848400FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF000000000000000000C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF0000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009A9A9A00A9FFFF0054FF
      FF00EFAD0000A2760000A2760000D9A77D00A37700007F5B0000EFAD0000AAFF
      FF0099F8FF00AAFFFF0099F8FF007676760084848400C6C6C600FFFFFF00C6C6
      C60000000000C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      420042424200424242004242420042424200000000009A9A9A0054FFFF00A9FF
      FF00AA7F0000FFFFCC00D9A77D00D9A77D00D9A77D00D9A77D007F5B0000AAFF
      FF00AAFFFF0099F8FF00AAFFFF008181810084848400FFFFFF00C6C6C6000000
      00000000000000000000C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF0000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A7A7A700A7A7A70055C0
      D400F7D06C00E5B72600E2B62900F6CF6D00AA7F0000AA7F0000F7CF6C00AAFF
      FF0099F8FF00AAFFFF0099F8FF008E8E8E0084848400C6C6C600FFFFFF000000
      0000FFFFFF000000000000000000C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D42420000000000000000004242420042424200424242004242
      4200424242004242420042424200424242000000000000000000A7A7A70000F2
      FF0000F2FF0000F1FF00F1BF2B00FFFFCC00AA7F0000AAFFFF00AAFFFF00AAFF
      FF0055DFFF0055DFFF0055C0D4009A9A9A0084848400FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF000000000000000000C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C600FFFFFF0000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242009D4242009D4242009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D424200000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B9B9B0054FF
      FF0067F4FF0067F4FF00F8D06D00FDC83100F7CF6C00AAFFFF00AAFFFF00B4B4
      B400A0A0A0008D8D8D0081818100A7A7A70084848400C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D4242009D4242009D42
      42009D4242009D4242009D4242009D4242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009B9B
      9B008D8D8D008D8D8D00B4B4B40090909000FFFFFF00AAFFFF00FFFFFF00A1A1
      A100E6E6E600DADADA00DADADA00B4B4B4008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000091919100FFFFFF00FFFFFF00AAFFFF00A7A7
      A700FFFFFF00E7E7E700B4B4B4000000000084848400FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FFFF
      FF00FF000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009D42420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000091919100FFFFFF00FFFFFF00FFFFFF008D8D
      8D00FFFFFF00B4B4B40000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B4B4B4009A9A9A009A9A9A008E8E8E008181
      8100C1C1C1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000008484840084848400000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C6C6C6000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000084848400C6C6C60084848400C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400000080000000000000FFFF000000000000008000848484000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000084848400C6C6C60084848400C6C6C60084848400C6C6C600848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000080008484
      8400000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00848484000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000C6C6C60084848400C6C6C60084848400C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000008484
      8400000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF000000000000000000FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      000084848400C6C6C60084848400C6C6C60084848400C6C6C600848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C60084848400C6C6C60084848400C6C6C60084848400C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000008484
      8400000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400C6C6C60084848400C6C6C60084848400C6C6C600848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000080008484
      8400000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000084848400C6C6C60084848400C6C6C60084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400000080000000000000FFFF000000000000008000848484000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840084848400C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000008484840084848400000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242009D42420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009D4242009D42
      42009D4242009D4242009D424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      00009D4242009D42420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D42420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      00009D4242000000000000000000000000004242420042424200424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000800000008000000080000000800000008000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D4242009D4242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D4242009D4242009D42420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D4242009D4242009D4242009D424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D4242009D4242009D42420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D4242009D4242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000800000008000000080000000800000008000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242009D4242009D42420000000000000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000009D42420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000004242420042424200424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009D4242009D42
      42009D4242009D4242009D424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004242420042424200424242004242
      4200424242004242420042424200424242008400000084000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000000000
      00008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004242
      4200424242004242420042424200424242008400000084000000840000000000
      00008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D4242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000000000000000
      00008484840000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      00009D4242009D42420000000000000000000000000000000000000000004242
      4200424242004242420042424200424242008400000000000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      00000000000000000000000000000000000000000000000000009D4242009D42
      42009D4242009D4242009D424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      00009D4242009D42420000000000000000000000000000000000000000004242
      4200424242004242420042424200424242000000000000000000000000000000
      000084848400FFFFFF0084848400848484008484840084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      00009D4242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000004242420042424200424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009D4242009D42
      42009D4242009D4242009D4242009D4242009D42420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600000000000000000000000000000000000000
      00000000000000000000C6C6C600000000000000000000000000000000000000
      00009D42420000000000000000009D42420000000000000000009D4242009D42
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      00009D42420000000000000000009D424200000000009D424200000000000000
      00009D42420000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009D42420000000000000000009D424200000000009D424200000000000000
      00009D42420000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C60000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000009D4242009D4242009D424200000000009D424200000000000000
      00009D4242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C60000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009D424200000000009D4242009D4242009D42
      4200000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009D424200424242009D424200000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000E3DFE0000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C60000FFFF000000
      000000FFFF000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004242420000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000E3DFE0000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000FFFF000000000000FF
      FF00C6C6C60000FFFF00C6C6C600000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242004242420042424200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      00000000000000000000000000000000000000000000C6C6C60000FFFF00C6C6
      C60000FFFF008400000000FFFF000000000000000000C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000424242000000000042424200000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00C6C6C60000FF
      FF008400000000FFFF00C6C6C600000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000042424200424242000000000042424200424242000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C60000FFFF008400
      000000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000042424200000000000000000000000000424242000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00C6C6C60000FF
      FF00C6C6C60000FFFF00C6C6C60000FFFF00C6C6C60000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000042424200000000000000000000000000424242000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C60000FFFF008484
      8400000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000042424200000000000000000000000000424242000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A64D4D00A64D4D00A64D4D00A64D4D00A64D4D00A64D
      4D00A64D4D00A64D4D00A64D4D00A64D4D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D00A64D4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A64D4D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009D4242009D4242009D4242009D4242009D42
      42009D4242009D4242009D4242009D4242004D4D4D00A6A6A6004DA6A600A6A6
      A6004DA6A600A6A6A600A64D4D00FFFFFF00A64D4D00A64D4D00A64D4D00A64D
      4D00A64D4D00A64D4D00FFFFFF00A64D4D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009D424200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D4242004D4D4D004DA6A600A6A6A6004DA6
      A600A6A6A6004DA6A600A64D4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00A64D4D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000009D424200FFFFFF0042424200424242004242
      42004242420042424200FFFFFF009D4242004D4D4D00A6A6A6004DA6A600A6A6
      A6004DA6A600A6A6A600A64D4D00FFFFFF00A64D4D00A64D4D00A64D4D00FFFF
      FF00A64D4D00A64D4D00A64D4D00A64D4D000000000000000000000000000000
      00009D4242009D9D9D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009D9D
      9D009D4242000000000000000000000000000000000042424200424242004242
      42004242420042424200424242009D424200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D4242004D4D4D004DA6A600A6A6A6004DA6
      A600A6A6A6004DA6A600A64D4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00A64D4D00FFFFFF00A64D4D00000000000000000000000000000000009D9D
      9D009D42420000000000000000000000000000000000000000009D4242009D42
      42009D4242009D4242009D4242000000000000000000000000009D4242009D42
      42009D4242009D4242009D424200000000000000000000000000000000000000
      00009D4242009D9D9D0000000000000000000000000042424200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D424200FFFFFF0042424200424242004242
      42004242420042424200FFFFFF009D4242004D4D4D00A6A6A6004DA6A600A6A6
      A6004DA6A600A6A6A600A64D4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00A64D4D00A64D4D0000000000000000000000000000000000000000009D42
      4200000000000000000000000000000000000000000000000000000000009D42
      42009D4242009D4242009D4242000000000000000000000000009D4242009D42
      42009D4242009D42420000000000000000000000000000000000000000000000
      0000000000009D42420000000000000000000000000042424200FFFFFF004242
      42004242420042424200424242009D424200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D4242004D4D4D004DA6A600A6A6A6004DA6
      A600A6A6A6004DA6A600A64D4D00A64D4D00A64D4D00A64D4D00A64D4D00A64D
      4D00A64D4D004D4D4D0000000000000000000000000000000000000000009D42
      4200000000000000000000000000000000000000000000000000000000000000
      00009D4242009D4242009D4242000000000000000000000000009D4242009D42
      42009D4242000000000000000000000000000000000000000000000000000000
      0000000000009D42420000000000000000000000000042424200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D424200FFFFFF004242420042424200FFFF
      FF009D4242009D4242009D4242009D4242004D4D4D00A6A6A6004DA6A600A6A6
      A6004DA6A600A6A6A6004DA6A600A6A6A6004DA6A600A6A6A6004DA6A600A6A6
      A6004DA6A6004D4D4D0000000000000000000000000000000000000000009D42
      4200000000000000000000000000000000000000000000000000000000009D42
      4200000000009D4242009D4242000000000000000000000000009D4242009D42
      4200000000009D42420000000000000000000000000000000000000000000000
      0000000000009D42420000000000000000000000000042424200FFFFFF004242
      42004242420042424200424242009D424200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF009D424200FFFFFF009D424200000000004D4D4D004DA6A600A6A6A6004D4D
      4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D00A6A6
      A600A6A6A6004D4D4D0000000000000000000000000000000000000000009D9D
      9D009D424200000000000000000000000000000000009D4242009D4242000000
      000000000000000000009D4242000000000000000000000000009D4242000000
      000000000000000000009D4242009D4242000000000000000000000000000000
      00009D4242009D9D9D0000000000000000000000000042424200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF009D424200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF009D4242009D42420000000000000000004D4D4D00A6A6A600A6A6A6004D4D
      4D00D3D3D300D3D3D300D3D3D300D3D3D300D3D3D300D3D3D3004D4D4D00A6A6
      A6004DA6A6004D4D4D0000000000000000000000000000000000000000000000
      00009D9D9D009D4242009D4242009D4242009D42420000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009D4242009D4242009D4242009D42
      42009D9D9D000000000000000000000000000000000042424200FFFFFF004242
      420042424200FFFFFF00424242009D4242009D4242009D4242009D4242009D42
      42009D4242000000000000000000000000004D4D4D004DA6A600A6A6A6004DA6
      A6004D4D4D004DFFFF004D4D4D004D4D4D004DFFFF004D4D4D00A6A6A6004DA6
      A600A6A6A6004D4D4D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042424200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0042424200FFFFFF004242420000000000000000000000
      000000000000000000000000000000000000000000004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D004DFFFF004DFFFF004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042424200FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0042424200424242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004D4D4D004D4D4D004D4D4D004D4D4D0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042424200424242004242
      4200424242004242420042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004B4B
      4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B004B4B4B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600848484008484840084848400848484008484840084848400848484008484
      84008484840084848400848484004B4B4B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E3DF
      E000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600848484004B4B4B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000075757500FFFF
      FF0075000000750000007500000075000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000E3DF
      E000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600848484004B4B4B00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000007575750000FFFF0075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000E3DF
      E000C6C6C6000000FF000000FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600848484004B4B4B00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000075757500FFFFFF0075757500FFFF
      FF0075000000750000007500000075000000FFFFFF0000000000FFFFFF00B9B9
      B900FFFFFF00B9B9B900FFFFFF00000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000000000000000000000000000000000E3DF
      E000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000C6C6C60000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000007575750000FFFF0075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000B9B9B900FFFF
      FF00B9B9B900FFFFFF00B9B9B900000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000075757500FFFFFF0075757500FFFF
      FF0075000000750000007500000075000000FFFFFF0000000000FFFFFF00B9B9
      B900FFFFFF00B9B9B900FFFFFF00000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000000000000000004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B004B4B4B004B4B4B000000000000000000000000000000
      0000000000004B4B4B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000007575750000FFFF0075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000B9B9B900FFFF
      FF00B9B9B900FFFFFF00B9B9B900000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000004B4B4B00DFFFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF00DFFFFF004B4B4B0000000000000000000000
      00004B4B4B004B4B4B004B4B4B0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000FFFF00B9B9B900757575007575
      7500FFFFFF0000FFFF0075757500757575007575750000000000FFFFFF00B9B9
      B900FFFFFF00B9B9B900FFFFFF0000000000000000000000000000000000A19D
      9D00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000004B4B4B0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0060DFDF0080FFFF004B4B4B0000000000000000004B4B
      4B004B4B4B004B4B4B004B4B4B004B4B4B00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000075757500FFFFFF00B9B9B9007575
      750000FFFF00FFFFFF00FFFFFF0075757500FFFFFF00FFFFFF00B9B9B900FFFF
      FF00B9B9B900FFFFFF00B9B9B90000000000A19D9D000000000000000000A19D
      9D0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000004B4B4B0080FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF004B4B4B0000000000000000000000
      0000000000004B4B4B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000DAEBED00B9B9B90000FFFF007575
      7500FFFFFF00757575007575750075757500FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B9B9B900FFFFFF00000000000000000000000000FFFFFF00A19D
      9D00FFFFFF00FFFFFF00A19D9D000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000004B4B4B0000FFFF0080FFFF0080FF
      FF0080FFFF0080FFFF0080FFFF0080FFFF004B4B4B0000000000000000000000
      0000000000004B4B4B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000757575007575750075757500FFFF
      FF0000FFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00B9B9B900FFFFFF00B9B9B90000000000A19D9D00A19D9D00A19D9D00FFFF
      FF0000FFFF0000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000004B4B4B004B4B4B004B4B4B004B4B
      4B0010BFCF0080FFFF0080FFFF00DFFFFF004B4B4B0000000000000000000000
      0000000000004B4B4B000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      00000000000000000000000000000000000000FFFF00FFFFFF007575750000FF
      FF00FFFFFF007575750000FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00B9B9B900FFFFFF00000000000000000000FFFF00A19D9D0000FF
      FF00FFFFFF00A19D9D00A19D9D00A19D9D00A19D9D00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000004B4B4B0000FFFF00FFFFFF0000CF
      CF004B4B4B004B4B4B004B4B4B004B4B4B00000000004B4B4B004B4B4B004B4B
      4B004B4B4B00848484000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000DAEBED007575750000FFFF007575
      750000FFFF00B9B9B9007575750000FFFF007500000075000000750000007500
      00007500000075000000750000007500000000000000A19D9D0000FFFF00A19D
      9D0000FFFF00A19D9D0000FFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000000000000000000000000000000000000000004B4B4B004B4B4B004B4B
      4B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007575750000FFFF00B9B9B9007575
      7500FFFFFF00DAEBED00B9B9B900757575007500000075000000750000007500
      000075000000750000007500000075000000A19D9D0000FFFF0000000000A19D
      9D00FFFFFF0000000000A19D9D0000FFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00B9B9B900DAEBED007575
      750000FFFF00DAEBED00DAEBED00B9B9B9000000000000000000000000000000
      00000000000000000000000000000000000000FFFF000000000000000000A19D
      9D0000FFFF000000000000000000A19D9D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000424242004242
      4200424242004242420042424200424242004242420042424200424242004242
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004D4D4D004D4D
      4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D000000000000000000000000000000000000000000424242004242
      4200424242004242420042424200424242004242420042424200424242004242
      4200424242004242420042424200000000000000000042424200429D9D00429D
      9D0042424200424242004242420042424200CECECE0042424200429D9D004242
      4200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004D4D4D00D3D3D300D3D3
      D300D3D3D300D3D3D300D3D3D300D3D3D300D3D3D300D3D3D300D3D3D3004D4D
      4D00D3D3D3004D4D4D0000000000000000000000000042424200429D9D00429D
      9D00424242004242420042424200424242004242420042424200CECECE00CECE
      CE0042424200429D9D0042424200000000000000000042424200429D9D00429D
      9D0042424200424242004242420042424200CECECE0042424200429D9D004242
      4200424242004242420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D00D3D3D3004D4D4D00000000000000000042424200429D9D00429D
      9D00424242004242420042424200424242004242420042424200CECECE00CECE
      CE0042424200429D9D0042424200000000000000000042424200429D9D00429D
      9D00424242004242420042424200424242004242420042424200429D9D004242
      4200429D9D004242420000000000000000000000000000000000000000000000
      0000424242004242420042424200424242004242420042424200424242004242
      4200424242000000000000000000000000004D4D4D00D3D3D300D3D3D300D3D3
      D300D3D3D300D3D3D300D3D3D3004DFFFF004DFFFF004DFFFF00D3D3D300D3D3
      D3004D4D4D004D4D4D004D4D4D00000000000000000042424200429D9D00429D
      9D00424242004242420042424200424242004242420042424200CECECE00CECE
      CE0042424200429D9D0042424200000000000000000042424200429D9D00429D
      9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D004242
      4200429D9D004242420042424200424242000000000000000000000000004242
      4200429D9D0042424200424242004242420042424200CECECE0042424200429D
      9D00424242000000000000000000000000004D4D4D00D3D3D300D3D3D300D3D3
      D300D3D3D300D3D3D300D3D3D300A6A6A600A6A6A600A6A6A600D3D3D300D3D3
      D3004D4D4D00D3D3D3004D4D4D00000000000000000042424200429D9D00429D
      9D00424242004242420042424200424242004242420042424200424242004242
      420042424200429D9D0042424200000000000000000042424200429D9D00429D
      9D004242420042424200424242004242420042424200429D9D00429D9D004242
      4200429D9D0042424200429D9D00424242000000000000000000000000004242
      4200429D9D00424242004242420042424200424242004242420042424200429D
      9D00424242000000000000000000000000004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D00D3D3D300D3D3D3004D4D4D000000000042424200429D9D00429D
      9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D
      9D00429D9D00429D9D0042424200000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE0042424200429D9D004242
      4200429D9D0042424200429D9D00424242000000000000000000000000004242
      4200429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D
      9D00424242000000000000000000000000004D4D4D00D3D3D300D3D3D300D3D3
      D300D3D3D300D3D3D300D3D3D300D3D3D300D3D3D300D3D3D300D3D3D3004D4D
      4D00D3D3D3004D4D4D00D3D3D3004D4D4D000000000042424200429D9D00429D
      9D00424242004242420042424200424242004242420042424200424242004242
      4200429D9D00429D9D0042424200000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE0042424200429D9D004242
      4200429D9D0042424200429D9D00424242000000000000000000000000004242
      4200429D9D004242420042424200424242004242420042424200429D9D00429D
      9D0042424200000000000000000000000000000000004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D00D3D3
      D3004D4D4D00D3D3D3004D4D4D004D4D4D000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE0042424200429D9D0042424200000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE0042424200424242004242
      4200429D9D0042424200429D9D00424242000000000000000000000000004242
      4200429D9D0042424200CECECE00CECECE00CECECE00CECECE0042424200429D
      9D004242420000000000000000000000000000000000000000004D4D4D00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004D4D
      4D00D3D3D3004D4D4D00D3D3D3004D4D4D000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE0042424200429D9D0042424200000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE0042424200CECECE004242
      4200429D9D0042424200429D9D00424242000000000000000000000000004242
      4200429D9D0042424200CECECE00CECECE00CECECE00CECECE0042424200429D
      9D00424242000000000000000000000000000000000000000000000000004D4D
      4D00FFFFFF004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D00FFFFFF004D4D
      4D004D4D4D004D4D4D004D4D4D00000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE0042424200429D9D0042424200000000000000000042424200424242004242
      4200424242004242420042424200424242004242420042424200424242004242
      42004242420042424200429D9D00424242000000000000000000000000004242
      4200429D9D0042424200CECECE00CECECE00CECECE00CECECE0042424200429D
      9D00424242000000000000000000000000000000000000000000000000004D4D
      4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF004D4D4D000000000000000000000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE0042424200429D9D0042424200000000000000000000000000000000004242
      4200429D9D0042424200CECECE00CECECE00CECECE00CECECE00CECECE004242
      4200CECECE0042424200429D9D00424242000000000000000000000000004242
      4200429D9D0042424200CECECE00CECECE00CECECE00CECECE0042424200CECE
      CE00424242000000000000000000000000000000000000000000000000000000
      00004D4D4D00FFFFFF004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D00FFFF
      FF004D4D4D000000000000000000000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE00424242004242420042424200000000000000000000000000000000004242
      4200424242004242420042424200424242004242420042424200424242004242
      4200424242004242420042424200424242000000000000000000000000004242
      4200424242004242420042424200424242004242420042424200424242004242
      4200424242000000000000000000000000000000000000000000000000000000
      00004D4D4D00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF004D4D4D0000000000000000000000000042424200429D9D004242
      4200CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECECE00CECE
      CE0042424200CECECE0042424200000000000000000000000000000000000000
      00000000000042424200429D9D0042424200CECECE00CECECE00CECECE00CECE
      CE00CECECE0042424200CECECE00424242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D4D004D4D
      4D004D4D4D004D4D4D0000000000000000000000000042424200424242004242
      4200424242004242420042424200424242004242420042424200424242004242
      4200424242004242420042424200000000000000000000000000000000000000
      0000000000004242420042424200424242004242420042424200424242004242
      4200424242004242420042424200424242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004F4F4F000000
      00004F4F4F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000666666004B4B4B004B4B
      4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B006666660000000000000000000000000000000000000000000000
      000000000000000000000000000000000000979797004F4F4F004F4F4F000000
      00004F4F4F004F4F4F0097979700000000008484840084848400848484008484
      840084848400848484008484840084848400848484008484840000000000C6C6
      C60084848400C6C6C60000000000C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000081818100C5C5C500C1C1
      C100B4B4B400B4B4B400B4B4B400B4B4B400B4B4B400B4B4B400B4B4B400B4B4
      B400B4B4B4004B4B4B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004F4F4F00979797004F4F4F000000
      00004F4F4F00979797004F4F4F00000000008484840084848400848484008484
      840084848400848484008484840084848400848484008484840084848400FFFF
      FF0084848400FFFFFF0084848400FFFFFF004242420042424200424242004242
      4200424242004242420042424200424242004242420042424200424242000000
      0000000000000000000000000000000000000000000081818100DADADA00CDCD
      CD00CDCDCD00C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C5C5C500C1C1
      C100B4B4B4004B4B4B0000000000000000000000000000000000000000000000
      00000000000000000000000000004F4F4F004F4F4F004F4F4F00979797000000
      0000979797004F4F4F004F4F4F004F4F4F000000000000000000000000000000
      00000000000000000000848484008484840084848400FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000004242420042424200429D9D00429D
      9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D004242
      4200000000000000000000000000000000000000000081818100E6E6E600E6E6
      E600CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00001FFF00CDCDCD0000BF
      0000B4B4B4005959590000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004F4F4F004F4F4F00000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000004242420042FFFF0042424200429D
      9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D
      9D0042424200000000000000000000000000000000008E8E8E00E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000E3DFE000E6E6E600E6E6E600E6E6E600DADA
      DA00CDCDCD006666660000000000000000000000000000000000000000000000
      00000000000000000000000000004F4F4F004F4F4F004F4F4F00979797000000
      0000979797004F4F4F004F4F4F004F4F4F000000000000000000000000000000
      00004F4F4F004F4F4F004F4F4F0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000042424200FFFFFF0042FFFF004242
      4200429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D
      9D00429D9D00424242000000000000000000000000009A9A9A00A7A7A700A7A7
      A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7A700A7A7
      A700A7A7A700A7A7A70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004F4F4F00979797004F4F4F000000
      00004F4F4F00979797004F4F4F00000000000000000000000000000000000000
      00004F4F4F004F4F4F004F4F4F0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000004242420042FFFF00FFFFFF0042FF
      FF0042424200429D9D00429D9D00429D9D00429D9D00429D9D00429D9D00429D
      9D00429D9D00429D9D00424242000000000000000000001FFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000979797004F4F4F004F4F4F000000
      00004F4F4F004F4F4F0097979700000000000000000000000000000000000000
      00004F4F4F004F4F4F004F4F4F0000000000FFFFDF00FFFF8000F7EF7000FFFF
      00000000000000000000000000000000000042424200FFFFFF0042FFFF00FFFF
      FF0042FFFF004242420042424200424242004242420042424200424242004242
      42004242420042424200424242004242420000000000001FFF00000000000000
      000000000000A8A8A8004B4B4B004B4B4B004B4B4B004B4B4B004B4B4B004B4B
      4B004B4B4B004B4B4B004B4B4B004B4B4B0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000004F4F4F000000
      00004F4F4F000000000000000000000000000000000000000000000000000000
      00004F4F4F004F4F4F004F4F4F0000000000FFFF8000FFFF8000FFFF8000FFFF
      8000000000000000000000000000000000004242420042FFFF00FFFFFF0042FF
      FF00FFFFFF0042FFFF00FFFFFF0042FFFF00FFFFFF0042FFFF00424242000000
      00000000000000000000000000000000000000000000001FFF00000000000000
      0000001FFF009A9A9A0099F8FF0099F8FF0099F8FF0055DFFF00AADFD50055DF
      FF0055DFFF00AADFD50055DFFF0055C0D40000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004F4F4F004F4F4F004F4F4F0000000000FFFF8000FFFF8000FFFF8000FFFF
      80000000000000000000000000000000000042424200FFFFFF0042FFFF00FFFF
      FF0042FFFF00FFFFFF0042FFFF00FFFFFF0042FFFF00FFFFFF00424242000000
      0000000000000000000000000000000000000000000000000000001FFF000000
      000000000000001FFF00A9FFFF00A9FFFF00A9FFFF0099F7FF00A9FFFF0098F7
      FF0098F7FF0054DFFF00AADFD50055DFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004F4F4F004F4F4F004F4F4F0000000000FFFF0000FFFF8000FFFF8000FFFF
      DF00000000000000000000000000000000004242420042FFFF00FFFFFF0042FF
      FF00424242004242420042424200424242004242420042424200424242000000
      000000000000000000000000000000000000000000000000000000000000001F
      FF00001FFF00001FFF00001FFF00A9FFFF00A9FFFF00A9FFFF0099F8FF0099F8
      FF0055DFFF0098F7FF0055DFFF00AADFD50000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042424200424242004242
      4200000000000000000000000000000000000000000000000000000000000000
      0000424242004242420042424200000000000000000000000000000000000000
      000000000000001FFF00E3DFE000A9FFFF00A9FFFF00A9FFFF00A9FFFF0099F7
      FF0099F7FF0055DFFF0099F8FF0055DFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004242420042424200000000000000000000000000000000000000
      0000001FFF00C1C1C100E3DFE000E3DFE000E3DFE000A9FFFF009A9A9A009A9A
      9A009A9A9A0055BFD30054BFD30055BFD30000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004242420000000000000000000000
      0000424242000000000042424200000000000000000000000000000000000000
      000000000000A7A7A700B4B4B4009A9A9A009A9A9A009A9A9A0055DFFF0055DF
      FF0055DFFF0055DFFF0055DFFF0054BFD30000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000DF000000DF000000DF000000DF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000042424200424242004242
      4200000000000000000000000000000000000000000000000000000000000000
      000000000000B4B4B400A9FFFF0000F2FF0000F1FF0055BFD3008D8D8D008D8D
      8D008D8D8D008D8D8D008D8D8D008D8D8D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C1C1C1009B9B9B008D8D8D008D8D8D009B9B9B00B4B4B4000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000F00000000100010000000000800700000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000F001FFFF00000000
      FFFFF00100000000FFFFFFFF00000000FE01FFFF00000000FFFFFE0100000000
      FFFFFFFF00000000F801FFFF00000000FFFFF80100000000FFFFFFFF00000000
      F801FFFF00000000E1E7F80100000000E3F7FFFF00000000E3F7FFFF00000000
      ECE7C80100000000FE0FFFFF00000000FFFFFFFFFFFFFC018001F803FFFF8C01
      00009003FC7F04010000B003F39F04010000B003EFEF04010000A003DFFF8C01
      00008FE7DFF7FC010000FFFFBFE3FC010000FFFFBFC104030000FFFFDFF70407
      0000FFE7DFFF040F0000FFE7EFEF07FF0000FF81F39F06030000FF81FC7FFF07
      0000FFE7FFFFFF8F8001FFE7FFFFFFDFFFFFFFFFFFFFFFFFFFFFE007FFFFFFFF
      8001C003FFE0FFFF8001CFF3FFE0FF7F8001C813FFE0FE3F8001CFF3FF00FC1F
      8001C813FF60F80F8001CFF3FF7FF00F8001C813FF7FF00F8001CFF30360F00F
      8001CE730360F01F80018C310000F83F80018E7103E0FC7F8001FE7F03E0FEFF
      FFFFFE7F03FFFFFFFFFFF87FFFFFFFFFFFFFFFFFFFFFFFFFF0009E7FFC0FC7FF
      F0000C3FFC0FE781F0000C3FF807C781000000008001A0000000800080016000
      0000C000800160000000C000800160000003C000800160000003C00080016000
      0003C0008001E0000003C000800100000003C00080010000001FC00080010000
      843FC00080010000FFFFC000FFFF0000FFFFFFFFFFFFFFFFFEFF8001FC03FFFF
      FFFF8001FC03FFFFC27F8001F801FDFFFFFF8001F001F83FC2008001F001F01F
      FFFF8001E001E00FDE078001C001E00FCE078001C401E00F07FF8001FC01E00F
      CE008001FC01E00FDE008001FC03F01FFFFF8001FC07F83FC2008003FE0FFDFF
      FFFF8007FF3FFFFFFEFF800FFFFFFFFF8003FFFFF83FFFFF00039FFFE01FFEFF
      00018FFF800FFFFF0000C7FF0007C27F0000E3FF0003FFFF0000F1FF0001C200
      0000F8FF0000FFFF0000FC7B0000DE070000FE3180009E070000FF00C00007FF
      8000FF81E0009E008000FF83F001DE00C000FF03F807FFFFFC01FC07FC1FC200
      FC03FE1FFE7FFFFFFC07FFFFFFFFFEFFFFFFFFFF8001FFFFFFFFFFFF80010001
      FFFFFF0080000001FFFFFFFF80000001F00FFFC080000001F00FFFFF80000001
      F00FFFC080000001F00FFFFF80000001F00FFFC080000001F00FFFFF80000001
      F00FFB00C0000001F00FF9FFC0000001FFFF80FFE0000001FFFFF9FFFE010001
      FFFFFBFFFE030001FFFFFFFFFE07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8007
      FFFFFFFFFFFF8007FFFFFDFFFDFF8007F83FFCFFF83F8007F01FFC7FF01F8007
      E00FE03FE00F8007E00FE01FE00F8007E00FE00FE00F800FE00FE01FE00F800F
      E00FE03FE00F8007F01FFC7FF01F8003F83FFCFFF83F8009FFFFFDFFFDFF801F
      FFFFFFFFFFFF803FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFF
      F3FFFFFFFFFFFFFFC1FFFFFFFFFFFFFFB3FFF18FFBFFF83FB700F18FF9FFF01F
      BFFFF18FF8FFE00FBFC0F18FF87FE00FBFFFF18FF83FE00FBFC0F18FF87FE00F
      BFFFF18FF8FFE00FBFC0F18FF9FFF01FBFFFF18FFBFFF83FBF00FFFFFFFFFFFF
      BFFFFFFFFFFFFFFFC1FFFFFFFFFFFFFFF000AC00B6E7FFFFF00007FFB76BFFFF
      F000AFFF8427FFFF700007FFB76BFF003000AFFFCEE7FFFF1000FFFFFFFFFFE0
      1000C7C7C7C7F7FF3000C7C7C7C7F3E07000C387C387C1FFF000C007C007B3E0
      F000C007C007B7FFF000C007C007BF00F001C007C007BFFFF003C007C007C07F
      F007F39FF39FFFFFFFFFF39FF39FFFFFFFFFFFFFFE49F8F8F9FFFFFFFE49F8F8
      F6CF07C1FFFFF870F6B707C1FFFFF800F6B707C1C7C7F800F8B70101C7C7F800
      FE8F0001C3870000FE3F0001C0070000FF7F0001C0070013FE3F8003C0070013
      FEBFC107C0070013FC9FC107C007001FFDDFE38FF39F001FFDDFE38FF39F001F
      FDDFE38FF39F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00FFFFFFFFFFFF
      8000FFFFFFFFFE000000FFFFFFFFFE000000FFFFFFFFFE000000F3FFFFE78000
      0001E7C1C1F380000003EFE1C3FB80000003EFF1C7FB80000003EFE9CBFB8001
      0003E79DDCF380030003F07FFF0780070003FFFFFFFF807F8007FFFFFFFF80FF
      F87FFFFFFFFF81FFFFFFFFFFFFFFFFFFE001FFFFC03FFFFFE000FFFFC03FE001
      E000C007003FE001E000C0070000E001E000C0070000E001E001C0070000E001
      FFFFC0070000E00180FBC0070000E0010071C0070000E0010060C00700006001
      007BC0070000C001007BC00700000001007BC00F000080030083C01F00008007
      8FFFC03F0000240FFFFFFFFF00FF661FFFFFFFFFC00FFEFFC007C001800FBEFD
      800380018003DFFB000180018003F007000180018000E007000180018000E007
      000080018000E0070000800180002004800080018000E007C00080018000E007
      E00180018000E007E0078001E000E007F0078001E000E007F0038001F800DFFB
      F8038001F800BEFDFFFFFFFFFFFFFEFFF7D7FFFFFFFF8003F3110022FFFF8003
      81110000001F8003B2100000000F8003B7FFE00700078003BE10E00700038003
      FF11E0070001BFFF0011E0070000B80000D7E007001FB00000FFE007001FD800
      00FFE007001FE00000FFE0078FF1F80000FFFFFFFFF9F00000FFF81FFF75F800
      01FFF81FFF8FF80003FFF81FFFFFF81F00000000000000000000000000000000
      000000000000}
  end
  object odlgOpenUnit: TOpenDialog
    Filter = 
      'Lua Files (*.lua, *.lpr)|*.lua;*.lpr|Lua Units (*.lua)|*.lua|Lua' +
      ' Projects (*.lpr)|*.lpr'
    InitialDir = 'C:\'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 80
    Top = 217
  end
  object odlgOpenProject: TOpenDialog
    Filter = 'Lua Projects (*.lpr)|*.lpr'
    InitialDir = 'C:\'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 112
    Top = 217
  end
  object sdlgSaveAsUnit: TSaveDialog
    DefaultExt = '*.lua'
    Filter = 'Lua Units (*.lua)|*.lua'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 16
    Top = 281
  end
  object sdlgSaveAsPrj: TSaveDialog
    DefaultExt = '*.lpr'
    Filter = 'Lua Projects (*.lpr)|*.lpr'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 48
    Top = 281
  end
  object mnuReopen: TPopupMenu
    AutoHotkeys = maManual
    Left = 80
    Top = 281
  end
  object synMainSearch: TSynEditSearch
    Left = 112
    Top = 281
  end
  object synMainSearchRegEx: TSynEditRegexSearch
    Left = 112
    Top = 249
  end
  object ppmEditor: TPopupMenu
    Images = imlActions
    OwnerDraw = True
    OnPopup = ppmEditorPopup
    Left = 16
    Top = 249
    object OpenFileatCursor1: TMenuItem
      Caption = 'Open Document ""'
      Hint = 'Open File at Cursor'
      ShortCut = 16397
      OnClick = OpenFileatCursor1Click
    end
    object N21: TMenuItem
      Caption = '-'
    end
    object Undo2: TMenuItem
      Action = actUndo
    end
    object Redo2: TMenuItem
      Action = actRedo
    end
    object N17: TMenuItem
      Caption = '-'
    end
    object Cut2: TMenuItem
      Action = actCut
    end
    object Copy2: TMenuItem
      Action = actCopy
    end
    object Paste2: TMenuItem
      Action = actPaste
    end
    object N19: TMenuItem
      Caption = '-'
    end
    object IndentSelection2: TMenuItem
      Action = actBlockIndent
    end
    object UnindentSelection2: TMenuItem
      Action = actBlockUnindent
    end
    object CommentSelection2: TMenuItem
      Action = actBlockComment
    end
    object UncommentSelection2: TMenuItem
      Action = actBlockUncomment
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object oggleBookmark1: TMenuItem
      Caption = 'Toggle Bookmark'
      object GotoBookmark12: TMenuItem
        Tag = 1
        Caption = 'Bookmark 1'
        GroupIndex = 1
        ShortCut = 24625
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark13: TMenuItem
        Tag = 2
        Caption = 'Bookmark 2'
        GroupIndex = 1
        ShortCut = 24626
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark14: TMenuItem
        Tag = 3
        Caption = 'Bookmark 3'
        GroupIndex = 1
        ShortCut = 24627
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark15: TMenuItem
        Tag = 4
        Caption = 'Bookmark 4'
        GroupIndex = 1
        ShortCut = 24628
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark16: TMenuItem
        Tag = 5
        Caption = 'Bookmark 5'
        GroupIndex = 1
        ShortCut = 24629
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark17: TMenuItem
        Tag = 6
        Caption = 'Bookmark 6'
        GroupIndex = 1
        ShortCut = 24630
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark18: TMenuItem
        Tag = 7
        Caption = 'Bookmark 7'
        GroupIndex = 1
        ShortCut = 24631
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark81: TMenuItem
        Tag = 8
        Caption = 'Bookmark 8'
        GroupIndex = 1
        ShortCut = 24632
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark91: TMenuItem
        Tag = 9
        Caption = 'Bookmark 9'
        GroupIndex = 1
        ShortCut = 24633
        OnClick = ToggleBookmarkClick
      end
      object GotoBookmark11: TMenuItem
        Caption = 'Bookmark 0'
        GroupIndex = 1
        ShortCut = 24624
        OnClick = ToggleBookmarkClick
      end
    end
    object GotoBookmark1: TMenuItem
      Caption = 'Goto Bookmark'
      object Bookmark11: TMenuItem
        Tag = 1
        Caption = 'Bookmark 1'
        GroupIndex = 1
        ShortCut = 16433
        OnClick = GotoBookmarkClick
      end
      object Bookmark12: TMenuItem
        Tag = 2
        Caption = 'Bookmark 2'
        GroupIndex = 1
        ShortCut = 16434
        OnClick = GotoBookmarkClick
      end
      object Bookmark13: TMenuItem
        Tag = 3
        Caption = 'Bookmark 3'
        GroupIndex = 1
        ShortCut = 16435
        OnClick = GotoBookmarkClick
      end
      object Bookmark14: TMenuItem
        Tag = 4
        Caption = 'Bookmark 4'
        GroupIndex = 1
        ShortCut = 16436
        OnClick = GotoBookmarkClick
      end
      object Bookmark15: TMenuItem
        Tag = 5
        Caption = 'Bookmark 5'
        GroupIndex = 1
        ShortCut = 16437
        OnClick = GotoBookmarkClick
      end
      object Bookmark16: TMenuItem
        Tag = 6
        Caption = 'Bookmark 6'
        GroupIndex = 1
        ShortCut = 16438
        OnClick = GotoBookmarkClick
      end
      object Bookmark17: TMenuItem
        Tag = 7
        Caption = 'Bookmark 7'
        GroupIndex = 1
        ShortCut = 16439
        OnClick = GotoBookmarkClick
      end
      object Bookmark18: TMenuItem
        Tag = 8
        Caption = 'Bookmark 8'
        GroupIndex = 1
        ShortCut = 16440
        OnClick = GotoBookmarkClick
      end
      object Bookmark19: TMenuItem
        Tag = 9
        Caption = 'Bookmark 9'
        GroupIndex = 1
        ShortCut = 16441
        OnClick = GotoBookmarkClick
      end
      object Bookmark110: TMenuItem
        Caption = 'Bookmark 0'
        GroupIndex = 1
        ShortCut = 16432
        OnClick = GotoBookmarkClick
      end
    end
    object N24: TMenuItem
      Caption = '-'
    end
    object AddBreakpoint1: TMenuItem
      Action = actAddBreakpoint
    end
    object N15: TMenuItem
      Caption = '-'
    end
    object GotoLastEdited2: TMenuItem
      Action = actGotoLastEdited
    end
    object GotoLine2: TMenuItem
      Action = actGoToLine
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object EditorSettings2: TMenuItem
      Action = actEditorSettings
    end
  end
  object ppmUnits: TPopupMenu
    Images = imlActions
    OwnerDraw = True
    OnPopup = ppmUnitsPopup
    Left = 16
    Top = 313
    object Save2: TMenuItem
      Action = actSave
    end
    object SaveAs2: TMenuItem
      Action = actSaveAs
    end
    object N22: TMenuItem
      Caption = '-'
    end
    object Close2: TMenuItem
      Action = actClose
    end
  end
  object synEditPrint: TSynEditPrint
    Copies = 1
    Header.DefaultFont.Charset = DEFAULT_CHARSET
    Header.DefaultFont.Color = clBlack
    Header.DefaultFont.Height = -13
    Header.DefaultFont.Name = 'Arial'
    Header.DefaultFont.Style = []
    Footer.DefaultFont.Charset = DEFAULT_CHARSET
    Footer.DefaultFont.Color = clBlack
    Footer.DefaultFont.Height = -13
    Footer.DefaultFont.Name = 'Arial'
    Footer.DefaultFont.Style = []
    Margins.Left = 25.000000000000000000
    Margins.Right = 15.000000000000000000
    Margins.Top = 25.000000000000000000
    Margins.Bottom = 25.000000000000000000
    Margins.Header = 15.000000000000000000
    Margins.Footer = 15.000000000000000000
    Margins.LeftHFTextIndent = 2.000000000000000000
    Margins.RightHFTextIndent = 2.000000000000000000
    Margins.HFInternalMargin = 0.500000000000000000
    Margins.MirrorMargins = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TabWidth = 8
    Color = clWhite
    Left = 48
    Top = 313
  end
  object pdlgPrint: TPrintDialog
    Options = [poPageNums, poSelection]
    Left = 80
    Top = 313
  end
  object ppmToolBar: TPopupMenu
    OwnerDraw = True
    Left = 112
    Top = 313
    object File3: TMenuItem
      Caption = 'File'
      OnClick = File2Click
    end
    object Edit3: TMenuItem
      Caption = 'Edit'
      OnClick = Edit2Click
    end
    object Run4: TMenuItem
      Caption = 'Run'
      OnClick = Run3Click
    end
  end
  object jvDockVSNet: TJvDockVSNetStyle
    ConjoinServerOption.GrabbersSize = 18
    ConjoinServerOption.SplitterWidth = 4
    ConjoinServerOption.ActiveFont.Charset = ANSI_CHARSET
    ConjoinServerOption.ActiveFont.Color = clWhite
    ConjoinServerOption.ActiveFont.Height = -11
    ConjoinServerOption.ActiveFont.Name = 'Arial'
    ConjoinServerOption.ActiveFont.Style = []
    ConjoinServerOption.InactiveFont.Charset = ANSI_CHARSET
    ConjoinServerOption.InactiveFont.Color = clBlack
    ConjoinServerOption.InactiveFont.Height = -11
    ConjoinServerOption.InactiveFont.Name = 'Arial'
    ConjoinServerOption.InactiveFont.Style = []
    ConjoinServerOption.TextAlignment = taLeftJustify
    ConjoinServerOption.ActiveTitleStartColor = clNavy
    ConjoinServerOption.ActiveTitleEndColor = clNavy
    ConjoinServerOption.InactiveTitleStartColor = clBtnFace
    ConjoinServerOption.InactiveTitleEndColor = clBtnFace
    ConjoinServerOption.TextEllipsis = True
    ConjoinServerOption.SystemInfo = False
    TabServerOption.TabPosition = tpBottom
    TabServerOption.ActiveSheetColor = clBtnFace
    TabServerOption.InactiveSheetColor = clWhite
    TabServerOption.ActiveFont.Charset = ANSI_CHARSET
    TabServerOption.ActiveFont.Color = clWindowText
    TabServerOption.ActiveFont.Height = -11
    TabServerOption.ActiveFont.Name = 'Arial'
    TabServerOption.ActiveFont.Style = []
    TabServerOption.InactiveFont.Charset = ANSI_CHARSET
    TabServerOption.InactiveFont.Color = 5395794
    TabServerOption.InactiveFont.Height = -11
    TabServerOption.InactiveFont.Name = 'Arial'
    TabServerOption.InactiveFont.Style = []
    TabServerOption.HotTrackColor = clBlue
    TabServerOption.ShowTabImages = True
    ChannelOption.ActivePaneSize = 100
    ChannelOption.ShowImage = True
    ChannelOption.HideHoldTime = 1000
    Left = 80
    Top = 342
  end
  object jvDockServer: TJvDockServer
    LeftSplitterStyle.Cursor = crHSplit
    LeftSplitterStyle.ParentColor = False
    RightSplitterStyle.Cursor = crHSplit
    RightSplitterStyle.ParentColor = False
    TopSplitterStyle.Cursor = crVSplit
    TopSplitterStyle.ParentColor = False
    BottomSplitterStyle.Cursor = crVSplit
    BottomSplitterStyle.ParentColor = False
    DockStyle = jvDockVSNet
    Left = 48
    Top = 342
  end
  object imlDock: TImageList
    Left = 16
    Top = 342
    Bitmap = {
      494C01010C000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000000000008080800000FFFF008080
      8000000000000000000000000000FFFFFF000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E3DFE000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000000000000000000000008080800000FFFF008080
      8000000000000000000000000000FFFFFF000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00FF000000000080008000000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFF000000000000E3DFE0000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF000000000080008000800080000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE0000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000001FFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF0000000000FF00FF0000000000800080000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      FF00FFFF000000000000E3DFE00000000000000000000000FF00000000000000
      000000000000000000000000000000000000000000000000000000000000001F
      FF00001FFF00001FFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF00FF0000000000FF00FF00FF00FF00FF00FF00000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE00000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000001FFF00001F
      FF00001FFF00001FFF00001FFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000C0C0C000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFF000000000000E3DFE0000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000001FFF00000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE0000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF0000000000000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      FF00000000000000000000000000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF000000000000E3DFE000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00FF000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE00000000000FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF0000000000E3DFE000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E3DFE000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DFE000E3DF
      E000E3DFE000E3DFE000E3DFE000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000414141004141410041414100414141004141410041414100414141004141
      4100414141004141410041414100414141000000000000000000000000000000
      0000000000008080800080000000800000008000000080000000800000008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009D4141009D4141009D4141009D4141009D4141009D41
      4100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00414141000000000000000000000000000000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF004141
      4100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080000000000000000000000000000000
      000041414100FFFFFF004141410041414100FFFFFF009D4141009D4141009D41
      41009D4141009D414100FFFFFF00414141000000000000000000000000008000
      000080000000FF00000080000000FFFFFF00FFFFFF0080808000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      00000000000041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00414141000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF0000808080004141410041414100414141004141
      410041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00414141000000000000000000808080008000
      0000FF00000080000000FF000000FFFFFF00FFFFFF0080808000FF0000008000
      0000800000008000000080808000000000000000000041414100414141004141
      41009D9D9D0041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00414141004141410041414100000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF00008080800041414100CDCDCD00CDCDCD00CDCD
      CD0041414100FFFFFF004141410041414100FFFFFF009D4141009D4141009D41
      41009D4141009D414100FFFFFF0041414100000000000000000080000000FF00
      000080000000FF00000080000000FF000000FF000000FF00000080000000FF00
      0000800000008000000080000000000000000000000041414100FFFFFF00FFFF
      FF0041414100FFFFFF0041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0041414100FFFFFF0041414100000000000000000000000000000000000000
      000000000000000000000000000000000000808080008080800080808000FFFF
      0000FFFF0000FFFF0000FFFF00008080800041414100CDCDCD0041414100FFFF
      FF0041414100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00414141000000000000000000FF000000FF00
      0000FF00000080000000FF000000FFFFFF00FFFFFF0080808000FF0000008000
      0000FF0000008000000080000000000000000000000041414100FFFFFF004141
      4100FFFFFF004141410041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000000000000000000000000000000000
      000000000000000000000000000000000000808080000000000000000000FFFF
      0000FFFF0000FFFF0000FFFF00008080800041414100CDCDCD00CDCDCD00CDCD
      CD00414141004141410041414100414141004141410041414100414141004141
      4100414141004141410041414100414141000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF0080808000FF00
      000080000000FF00000080000000000000000000000041414100FFFFFF004141
      410041414100FFFFFF0041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      00000000000000000000000000000000000041414100CDCDCD0041414100FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CDCD
      CD00CDCDCD004141410000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000080808000FF000000FF000000FFFFFF00FFFFFF008000
      0000FF0000008000000080000000000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      00000000000000000000000000000000000041414100CDCDCD00CDCDCD00CDCD
      CD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCD
      CD00CDCDCD004141410000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FFFFFF00FFFFFF00FF000000FFFFFF00FFFFFF00FF00
      000080000000FF00000080000000000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0041414100FFFFFF0041414100FFFFFF0041414100FFFF
      FF0041414100FFFFFF0041414100000000008080800080808000808080008080
      8000808080008080800000000000000000008080800000000000000000008080
      80008080800080808000808080008080800041414100CDCDCD0041414100FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CDCD
      CD00CDCDCD00414141000000000000000000000000000000000080808000FF00
      0000FF000000FF00000080808000FFFFFF00FFFFFF00FFFFFF00808080008000
      0000FF0000008000000080808000000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0041414100FFFFFF0041414100FFFFFF00414141004141
      4100FFFFFF00FFFFFF004141410000000000FF000000FF000000FF000000FF00
      0000FF000000808080000000000000000000808080000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF008080800041414100CDCDCD00CDCDCD00CDCD
      CD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCDCD00CDCD
      CD00CDCDCD00414141000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000808080008080800080808000FF000000FF00
      0000800000008000000000000000000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF004141410041414100FFFFFF0041414100FFFF
      FF00FFFFFF00FFFFFF004141410000000000FF000000FF000000FF000000FF00
      0000FF000000808080008080800080808000808080008080800080808000FF00
      FF00FF00FF00FF00FF00FF00FF008080800041414100CDCDCD0041414100CDCD
      CD00CDCDCD004141410041414100414141004141410041414100414141004141
      4100414141004141410000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000008000
      0000800000000000000000000000000000000000000041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF004141410041414100FFFFFF00FFFF
      FF00FFFFFF00FFFFFF004141410000000000FF000000FF000000FF000000FF00
      0000FF000000808080000000000000000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF008080800041414100CDCDCD00CDCDCD00CDCD
      CD00CDCDCD0041414100CDCDCD00FFFFFF00CDCDCD00CDCDCD00414141000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FF000000FF000000FF000000FF000000808080008080
      800000000000000000000000000000000000000000009D4141009D4141009D41
      41009D4141009D4141009D4141009D4141009D4141009D4141009D4141009D41
      41009D4141009D4141009D41410000000000FF000000FF000000FF000000FF00
      0000FF000000808080000000000000000000000000000000000000000000FF00
      FF00FF00FF00FF00FF00FF00FF00808080000000000041414100414141004141
      4100414141000000000041414100414141004141410041414100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009D4141009D4141009D41
      41009D4141009D4141009D4141009D4141009D4141009D4141009D4141009D41
      41009D4141009D4141009D41410000000000FF000000FF000000FF000000FF00
      0000FF0000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000750000007500
      0000750000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B9B9B900B9B9B9000000
      0000000000000000000000000000B9B9B900B9B9B90000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007500
      0000750000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFFFF000000
      0000000000000000000000000000FFFF0000FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000075000000B9B9
      B900750000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFF0000FFFF00000000
      0000000000000000000000000000FFFF0000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000075000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007500000000000000000000000000
      0000FFFFFF00FFFFFF0000000000757575007575750000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000B9B9B900B9B9B900B9B9B900FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00000000007500000000000000000000000000
      0000FFFFFF007575750000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000B9B9
      B90000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000007500000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00B9B9B90000000000B9B9B90000000000B9B9B90075757500FFFFFF00FFFF
      FF000000000000000000FFFFFF00000000007500000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000007500000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00757575007575750075757500FFFFFF007575750075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075757500B9B9B900B9B9
      B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9B900B9B9
      B900B9B9B900B9B9B9000000000000000000000000000000000000000000FFFF
      FF0075757500757575007575750075757500FFFFFF007575750075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000007575750075757500FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075000000750000007500
      000075000000750000007500000075000000FFFFFF0075000000FFFFFF007500
      0000FFFFFF00750000007500000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000075000000750000007500
      0000750000007500000075000000750000007500000075000000750000007500
      0000750000007500000075000000000000000000000000000000750000007500
      0000750000007500000075000000750000007500000075000000750000007500
      00007500000075000000750000007500000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000075000000750000007500000075000000750000007500
      0000750000007500000075000000750000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000750000007500
      0000750000007500000075000000750000007500000075000000750000007500
      0000750000007500000075000000750000000000000000000000000000000000
      0000000000000000000075000000750000007500000075000000750000007500
      0000750000007500000075000000750000000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFC01FFFF8001FFFF8C01
      FFFF0000FC7F0401FF7F0000F39F0401FE3F0000EFEF0401FC1F0000DFFF8C01
      F80F0000DFF7FC01F00F0000BFE3FC01F00F0000BFC10403F00F0000DFF70407
      F01F0000DFFF040FF83F0000EFEF07FFFC7F0000F39F0603FEFF0000FC7FFF07
      FFFF0000FFFFFF8FFFFF8001FFFFFFDFFFFFFFFFFFFFFFFFF000F80FFC0FFFFF
      F000F007FC0FFFE0F000E003F807FFE00000C0018001FFE00000C0018001FF00
      0000C0018001FF600000C0018001FF7F0003C0018001FF7F0003C00180010360
      0003C001800103600003E003800100000003F007800103E0001FF80F800103E0
      843FFFFF800103FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9E7FC7FFE007FFFF
      0C3FE781C00380010C3FC781CFF380010000A000C813800180006000CFF38001
      C0006000C8138001C0006000CFF38001C0006000C8138001C0006000CFF38001
      C000E000CE738001C00000008C318001C00000008E718001C0000000FE7F8001
      C0000000FE7FFFFFC0000000F87FFFFF00000000000000000000000000000000
      000000000000}
  end
  object jvModernUnitBarPainter: TJvModernTabBarPainter
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    DisabledFont.Charset = ANSI_CHARSET
    DisabledFont.Color = clGrayText
    DisabledFont.Height = -11
    DisabledFont.Name = 'Arial'
    DisabledFont.Style = []
    Left = 112
    Top = 342
  end
  object jvchnNotifier: TJvChangeNotify
    Notifications = <>
    CheckInterval = 1000
    FreeOnTerminate = False
    OnChangeNotify = jvchnNotifierChangeNotify
    Left = 144
    Top = 342
  end
  object mnuMain: TMainMenu
    AutoHotkeys = maManual
    Images = imlActions
    OwnerDraw = True
    Left = 80
    Top = 249
    object File1: TMenuItem
      Action = actMainMenuFile
      object New1: TMenuItem
        Caption = 'New'
        ImageIndex = 9
        object Project1: TMenuItem
          Action = actNewProject
        end
        object Unit1: TMenuItem
          Action = actNewUnit
        end
      end
      object OpenFile1: TMenuItem
        Action = actOpenFile
      end
      object OpenLuaProject1: TMenuItem
        Action = actOpenProject
      end
      object Reopen1: TMenuItem
        Caption = 'Reopen'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Action = actSave
      end
      object SaveAs1: TMenuItem
        Action = actSaveAs
      end
      object SaveProjectAs1: TMenuItem
        Action = actSaveProjectAs
      end
      object SaveAll1: TMenuItem
        Action = actSaveAll
      end
      object CloseUnit1: TMenuItem
        Action = actClose
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Print1: TMenuItem
        Action = actPrint
      end
      object PrintSetup1: TMenuItem
        Caption = 'Print Setup...'
        OnClick = PrintSetup1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = actExit
      end
    end
    object Edit1: TMenuItem
      Action = actMainMenuEdit
      object Undo1: TMenuItem
        Action = actUndo
      end
      object Redo1: TMenuItem
        Action = actRedo
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Cut1: TMenuItem
        Action = actCut
      end
      object Copy1: TMenuItem
        Action = actCopy
      end
      object Paste1: TMenuItem
        Action = actPaste
      end
      object SelectAll1: TMenuItem
        Action = actSelectAll
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Search1: TMenuItem
        Action = actSearch
      end
      object Replace1: TMenuItem
        Action = actSearchReplace
      end
      object SearchAgain1: TMenuItem
        Action = actSearchAgain
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object IndentSelection1: TMenuItem
        Action = actBlockIndent
      end
      object UnindentSelection1: TMenuItem
        Action = actBlockUnindent
      end
      object CommentSelection1: TMenuItem
        Action = actBlockComment
      end
      object UncommentSelection1: TMenuItem
        Action = actBlockUncomment
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object GotoLastEdited1: TMenuItem
        Action = actGotoLastEdited
      end
      object GotoLine1: TMenuItem
        Action = actGoToLine
      end
    end
    object View1: TMenuItem
      Action = actMainMenuView
      object ProjectTree1: TMenuItem
        Action = actShowProjectTree
      end
      object Breakpoints1: TMenuItem
        Action = actShowBreakpoints
      end
      object Messages1: TMenuItem
        Action = actShowMessages
      end
      object ClipboardRing1: TMenuItem
        Action = actShowRings
      end
      object FunctionList1: TMenuItem
        Action = actShowFunctionList
      end
      object DebugWindows1: TMenuItem
        Caption = 'Debug Windows'
        object WatchList1: TMenuItem
          Action = actShowWatchList
        end
        object CallStack1: TMenuItem
          Action = actShowCallStack
        end
        object LuaStack1: TMenuItem
          Action = actShowLuaStack
        end
        object LuaOutput1: TMenuItem
          Action = actShowLuaOutput
        end
        object LuaGlobals1: TMenuItem
          Action = actShowLuaGlobals
        end
        object LuaLocals1: TMenuItem
          Action = actShowLuaLocals
        end
      end
      object oolbars1: TMenuItem
        Caption = 'Toolbars'
        object File2: TMenuItem
          Caption = 'File'
        end
        object Edit2: TMenuItem
          Caption = 'Edit'
        end
        object Run1: TMenuItem
          Caption = 'Run'
        end
      end
    end
    object Project2: TMenuItem
      Action = actMainMenuProject
      object AddUnittoProject1: TMenuItem
        Action = actAddToPrj
      end
      object RemoveUnitFromProject1: TMenuItem
        Action = actRemoveFromPrj
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object ActivateSelectedProject1: TMenuItem
        Action = actActiveSelPrj
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object Options1: TMenuItem
        Action = actPrjSettings
      end
    end
    object Run2: TMenuItem
      Action = actMainMenuRun
      object RunScript1: TMenuItem
        Action = actRunScript
      end
      object PauseScript1: TMenuItem
        Action = actPause
      end
      object StopScript1: TMenuItem
        Action = actStop
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object CheckSyntax1: TMenuItem
        Action = actCheckSyntax
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object StepOver1: TMenuItem
        Action = actStepOver
      end
      object StepInto1: TMenuItem
        Action = actStepInto
      end
      object RunScripttoCursor1: TMenuItem
        Action = actRunToCursor
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object oggleBreakpoint1: TMenuItem
        Action = actAddBreakpoint
      end
    end
    object ools1: TMenuItem
      Action = actMainMenuTools
      object Calculator1: TMenuItem
        Caption = 'Calculator'
        ImageIndex = 37
        OnClick = Calculator1Click
      end
      object ErrorLookup1: TMenuItem
        Caption = 'Error Lookup'
        ImageIndex = 37
        OnClick = ErrorLookup1Click
      end
      object Conversions1: TMenuItem
        Caption = 'Conversions'
        ImageIndex = 37
        OnClick = Conversions1Click
      end
      object AsciiTable1: TMenuItem
        Caption = 'Ascii Table'
        ImageIndex = 37
        OnClick = AsciiTable1Click
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object HeaderBuilder1: TMenuItem
        Caption = 'Header Builder'
        object Functions1: TMenuItem
          Action = actFunctionHeader
        end
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object EditorSettings1: TMenuItem
        Action = actEditorSettings
      end
    end
    object N14: TMenuItem
      Action = actMainMenuHelp
      object Help1: TMenuItem
        Caption = 'LuaEdit Help'
        ImageIndex = 38
        ShortCut = 112
        OnClick = Help1Click
      end
      object LuaHelp1: TMenuItem
        Caption = 'Lua Help'
        ImageIndex = 38
        OnClick = LuaHelp1Click
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object ContributorsList1: TMenuItem
        Caption = 'Contributors List...'
        OnClick = ContributorsList1Click
      end
      object AboutLuaEdit1: TMenuItem
        Caption = 'About LuaEdit...'
        OnClick = AboutLuaEdit1Click
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 16
    Top = 217
  end
  object xmpMenuPainter: TXPMenu
    DimLevel = 30
    GrayLevel = 10
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Color = clWhite
    DrawMenuBar = True
    IconBackColor = clBtnFace
    MenuBarColor = clBtnFace
    SelectColor = 15717318
    SelectBorderColor = 13003057
    SelectFontColor = clMenuText
    DisabledColor = clGrayText
    SeparatorColor = clBtnFace
    CheckedColor = clHighlight
    IconWidth = 24
    DrawSelect = True
    UseSystemColors = False
    UseDimColor = False
    OverrideOwnerDraw = False
    Gradient = False
    FlatMenu = False
    AutoDetect = False
    XPContainers = [xccToolbar, xccCoolbar, xccControlbar, xccScrollBox, xccPageScroller]
    Active = True
    Left = 144
    Top = 313
  end
  object jvAppDrop: TJvDragDrop
    DropTarget = Owner
    OnDrop = jvAppDropDrop
    Left = 144
    Top = 281
  end
end
