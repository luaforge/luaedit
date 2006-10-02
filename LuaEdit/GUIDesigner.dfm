object GUIForm1: TGUIForm1
  Left = 669
  Top = 277
  Width = 250
  Height = 250
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ELGUIDesigner: TELDesigner
    ClipboardFormat = 'Extension Library designer components'
    OnModified = ELGUIDesignerModified
    OnControlInserting = ELGUIDesignerControlInserting
    OnControlInserted = ELGUIDesignerControlInserted
    OnChangeSelection = ELGUIDesignerChangeSelection
    Left = 16
    Top = 16
  end
end
