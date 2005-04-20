unit EditorSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SynEdit, ComCtrls, ExtCtrls, IniFiles, Main, LuaSyntax;

const
  UM_MEASUREFONTS = WM_USER;

type
  TfrmEditorSettings = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    pgcDebuggerSettings: TPageControl;
    stabGeneral: TTabSheet;
    Group1: TGroupBox;
    chkAutoIndent: TCheckBox;
    chkGroupUndo: TCheckBox;
    chkScrollPastEOF: TCheckBox;
    chkSmartTab: TCheckBox;
    chkTrailBlanks: TCheckBox;
    chkTabIndent: TCheckBox;
    chkHideScrollBars: TCheckBox;
    chkEHomeKey: TCheckBox;
    Label1: TLabel;
    txtUndoLimit: TEdit;
    Label2: TLabel;
    txtTabWidth: TEdit;
    stabDisplay: TTabSheet;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    chkShowGutter: TCheckBox;
    chkShowLineNumbers: TCheckBox;
    Label3: TLabel;
    txtGutterWidth: TEdit;
    cboGutterColor: TColorBox;
    Label4: TLabel;
    chkLeadingZeros: TCheckBox;
    cboFonts: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    cboFontSize: TComboBox;
    pnlPreview: TPanel;
    stabColors: TTabSheet;
    synSample: TSynEdit;
    lstElement: TListBox;
    Label7: TLabel;
    cboForeground: TColorBox;
    Label8: TLabel;
    Label9: TLabel;
    cboBackground: TColorBox;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    chkTabsToSpaces: TCheckBox;
    chkScrollPastEOL: TCheckBox;
    chkKeepCaretX: TCheckBox;
    chkRightMouseMovesCursor: TCheckBox;
    GroupBox1: TGroupBox;
    chkFileAssociate: TCheckBox;
    imgNotify: TImage;
    lblNotify: TLabel;
    chkSaveProjectsInc: TCheckBox;
    chkSaveUnitsInc: TCheckBox;
    chkSaveBreakpoints: TCheckBox;
    chkShowExSaveDlg: TCheckBox;
    procedure cboFontsMeasureItem(Control: TWinControl; Index: Integer;  var Height: Integer);
    procedure cboFontsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure cboFontsChange(Sender: TObject);
    procedure cboFontSizeKeyPress(Sender: TObject; var Key: Char);
    procedure cboFontSizeChange(Sender: TObject);
    procedure txtUndoLimitKeyPress(Sender: TObject; var Key: Char);
    procedure txtTabWidthKeyPress(Sender: TObject; var Key: Char);
    procedure txtGutterWidthKeyPress(Sender: TObject; var Key: Char);
    procedure WriteEditorSettings;
    procedure btnOKClick(Sender: TObject);
    procedure chkShowGutterClick(Sender: TObject);
    procedure lstElementClick(Sender: TObject);
    procedure chkBoldClick(Sender: TObject);
    procedure chkItalicClick(Sender: TObject);
    procedure chkUnderlineClick(Sender: TObject);
    procedure cboForegroundChange(Sender: TObject);
    procedure cboBackgroundChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure synEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure chkFileAssociateClick(Sender: TObject);
    procedure cboFontSizeMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UMMeasureFonts(var msg: TMessage); message UM_MEASUREFONTS;
    procedure NotifyRestart(Notify: Boolean);
  end;

var
  frmEditorSettings: TfrmEditorSettings;
  Options: TSynEditorOptions;
  lstEditorColorsTemp: TList;
  pTempUnit: TLuaUnit;

function SetPrivilege(sPrivilegeName : PChar; bEnabled : boolean): boolean; cdecl; external 'LuaEditSys.dll';
function WinExit(iFlags: integer): Boolean; cdecl; external 'LuaEditSys.dll';

implementation

uses RegSetFileType;

{$R *.dfm}

procedure TfrmEditorSettings.UMMeasureFonts(var msg: TMessage);
var
  i: Integer;
  MaxItemHeight: Integer;
begin
  // use form canvas for measurements
  MaxItemHeight := 0;
  Canvas.Font.Size := 10;
  
  for i := 0 to cboFonts.Items.Count - 1 do
  begin
    Canvas.Font.Name := cboFonts.Items[i];

    if Canvas.TextHeight(cboFonts.Items[i]) > MaxItemHeight then
      MaxItemHeight := Canvas.TextHeight(cboFonts.Items[i]);

    cboFonts.Perform(CB_SETITEMHEIGHT, i, Canvas.TextHeight(cboFonts.Items[i]));
  end;

  for i := 0 to cboFontSize.Items.Count do
  begin
    cboFontSize.Perform(CB_SETITEMHEIGHT, MaxItemHeight, Canvas.TextHeight(cboFontSize.Items[i]));
  end;
end;

procedure TfrmEditorSettings.cboFontsMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
begin
  Height := (Control As TCombobox).ItemHeight+4;
end;

procedure TfrmEditorSettings.cboFontSizeMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
begin
  Height := (Control As TCombobox).ItemHeight+4;
end;

procedure TfrmEditorSettings.FormCreate(Sender: TObject);
var
  HR: TSynLuaSyn;
begin
  pTempUnit := TLuaUnit.Create('');
  pTempUnit.synUnit := synSample;
  pTempUnit.pDebugInfos.AddBreakpointAtLine(13);
  pTempUnit.pDebugInfos.iLineError := 14;
  pTempUnit.pDebugInfos.iCurrentLineDebug := 15;
  synSample.OnSpecialLineColors := synEditSpecialLineColors;
  synSample.Refresh;
  
  HR := TSynLuaSyn.Create(nil);
  synSample.Highlighter := HR;
  lstEditorColorsTemp := TList.Create;
  cboFonts.Items := Screen.Fonts;
  cboFonts.itemindex := 0;
  // Measure items after form has been shown
  PostMessage(Self.Handle, UM_MEASUREFONTS, 0, 0);
end;

procedure TfrmEditorSettings.synEditSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
begin
  Special := False;

  if pTempUnit.pDebugInfos.IsBreakPointLine(Line) then
  begin
    Special := True;
    BG := StringToColor(TEditorColors(lstEditorColorsTemp.Items[9]).Background);
    FG := StringToColor(TEditorColors(lstEditorColorsTemp.Items[9]).Foreground);
  end;

  if pTempUnit.pDebugInfos.iCurrentLineDebug = Line then
  begin
    Special := True;
    BG := StringToColor(TEditorColors(lstEditorColorsTemp.Items[3]).Background);
    FG := StringToColor(TEditorColors(lstEditorColorsTemp.Items[3]).Foreground);
  end;

  if pTempUnit.pDebugInfos.iLineError = Line then
  begin
    Special := True;
    BG := StringToColor(TEditorColors(lstEditorColorsTemp.Items[2]).Background);
    FG := StringToColor(TEditorColors(lstEditorColorsTemp.Items[2]).Foreground)
  end;
end;

procedure TfrmEditorSettings.cboFontsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  cb: TCombobox;
begin
  cb := TCombobox(Control);
  cb.Canvas.FillRect(rect);
  if (index >= 0) and (index < cb.Items.Count) then
  begin
    if odComboBoxEdit in State then
    begin
      // Draw the edit portion of the control, use the controls
      // design-time font for this since the edit control is
      // fixed height and drawing a bunch of symbols if the selected
      // font is Symbol etc. is not very informative for the user.
      cb.Canvas.Font := cb.Font;
      if odSelected in State then
       cb.Canvas.Font.Color := clHighlightText;
    end
    else
    begin
      cb.Canvas.Font.Name := cb.Items[index];
      cb.Canvas.Font.Size := 10;
    end;
    cb.Canvas.TextRect(Rect, rect.left+2, rect.top+2, cb.Items[index]);
  end;
end;

procedure TfrmEditorSettings.cboFontsChange(Sender: TObject);
begin
  cboFonts.Font.Name := cboFonts.Text;
  pnlPreview.Font.Name := cboFonts.Text;
end;

procedure TfrmEditorSettings.cboFontSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmEditorSettings.cboFontSizeChange(Sender: TObject);
begin
  if cboFontSize.Text <> '' then
    pnlPreview.Font.Size := StrToInt(cboFontSize.Text);
end;

procedure TfrmEditorSettings.txtUndoLimitKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmEditorSettings.txtTabWidthKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmEditorSettings.txtGutterWidthKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfrmEditorSettings.WriteEditorSettings;
var
  pIniFile: TIniFile;
  x: Integer;
begin
  Screen.Cursor := crHourGlass;
  pIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\LuaEdit.ini');

  //Writing general settings
  if chkAutoIndent.Checked then
    Options := Options + [eoAutoIndent]
  else
    Options := Options - [eoAutoIndent];

  if chkGroupUndo.Checked then
    Options := Options + [eoGroupUndo]
  else
    Options := Options - [eoGroupUndo];

  if chkScrollPastEOF.Checked then
    Options := Options + [eoScrollPastEof]
  else
    Options := Options - [eoScrollPastEof];

  if chkHideScrollBars.Checked then
    Options := Options + [eoHideShowScrollbars]
  else
    Options := Options - [eoHideShowScrollbars];

  if chkTrailBlanks.Checked then
    Options := Options - [eoTrimTrailingSpaces]
  else
    Options := Options + [eoTrimTrailingSpaces];

  if chkTabIndent.Checked then
    Options := Options + [eoTabIndent]
  else
    Options := Options - [eoTabIndent];

  if chkEHomeKey.Checked then
    Options := Options + [eoEnhanceHomeKey]
  else
    Options := Options - [eoEnhanceHomeKey];

  if chkSmartTab.Checked then
    Options := Options + [eoSmartTabs]
  else
    Options := Options - [eoSmartTabs];

  if chkTabsToSpaces.Checked then
    Options := Options + [eoTabsToSpaces]
  else
    Options := Options - [eoTabsToSpaces];

  if chkScrollPastEOL.Checked then
    Options := Options + [eoScrollPastEol]
  else
    Options := Options - [eoScrollPastEol];

  if chkKeepCaretX.Checked then
    Options := Options + [eoKeepCaretX]
  else
    Options := Options - [eoKeepCaretX];

  if chkRightMouseMovesCursor.Checked then
    Options := Options + [eoRightMouseMovesCursor]
  else
    Options := Options - [eoRightMouseMovesCursor];

  pIniFile.WriteInteger('General', 'EditorOptions', Integer(Options));
  pIniFile.WriteInteger('General', 'UndoLimit', StrToInt(txtUndoLimit.Text));
  pIniFile.WriteInteger('General', 'TabWidth', StrToInt(txtTabWidth.Text));
  pIniFile.WriteBool('General', 'SaveProjectsInc', chkSaveProjectsInc.Checked);
  pIniFile.WriteBool('General', 'SaveBreakpoints', chkSaveBreakpoints.Checked);
  pIniFile.WriteBool('General', 'SaveUnitsInc', chkSaveUnitsInc.Checked);
  pIniFile.WriteBool('General', 'AssociateFiles', chkFileAssociate.Checked);
  pIniFile.WriteBool('General', 'ShowExSaveDlg', chkShowExSaveDlg.Checked);

  if AssociateFiles <> chkFileAssociate.Checked then
  begin
    if chkFileAssociate.Checked then
    begin
      // Register file association for .lpr files
      RegSetAssociation('.lpr', 'LuaEdit.lpr', 'LuaEdit Project', 'LuaEdit/LuaEdit.lpr', PChar(ExtractFileDir(Application.ExeName) + '\Graphics\Project.ico'));
      RegSetOpenWith('LuaEdit.lpr', PChar(Application.ExeName + ' %1'));

      // Register file association for .lua files
      RegSetAssociation('.lua', 'LuaEdit.lua', 'LuaEdit Unit', 'LuaEdit/LuaEdit.lua', PChar(ExtractFileDir(Application.ExeName) + '\Graphics\Unit.ico'));
      RegSetOpenWith('LuaEdit.lua', PChar(Application.ExeName + ' %1'));
    end
    else
    begin      
      // Clear file association registration for .lpr files
      RegClearIEOpenKey('.lpr');
      RegClearAssociation('.lpr', 'LuaEdit.lpr');

      // Clear file association registration for .lua files
      RegClearIEOpenKey('.lua');
      RegClearAssociation('.lua', 'LuaEdit.lua');
    end;

    if Application.MessageBox('You must restart your computer for some of the changes to take effect. Do you want to restart your computer now?', 'LuaEdit', MB_ICONQUESTION+MB_YESNO) = IDYES then
    begin
      if not WinExit(EWX_REBOOT) then
      begin
        Application.MessageBox('LuaEdit was unable to restart your computer!', 'LuaEdit', MB_OK+MB_ICONERROR);
      end;
    end;
  end;

  //Writing display settings
  pIniFile.WriteBool('Display', 'ShowGutter', chkShowGutter.Checked);
  pIniFile.WriteBool('Display', 'ShowLineNumbers', chkShowLineNumbers.Checked);
  piniFile.WriteBool('Display', 'LeadingZeros', chkLeadingZeros.Checked);
  pIniFile.WriteInteger('Display', 'GutterWidth', StrToInt(txtGutterWidth.Text));
  pIniFile.WriteString('Display', 'GutterColor', ColorToString(cboGutterColor.Selected));
  pIniFile.WriteString('Display', 'FontName', cboFonts.Text);
  pIniFile.WriteInteger('Display', 'FontSize', StrToInt(cboFontSize.Text));

  pIniFile.UpdateFile;
  pIniFile.Free;
  pIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\LuaEdit.dat');

  //Writing colors settings
  for x := 0 to lstElement.Items.Count - 1 do
  begin
    pIniFile.WriteBool(lstElement.Items.Strings[x], 'IsBold', TEditorColors(lstElement.Items.Objects[x]).IsBold);
    pIniFile.WriteBool(lstElement.Items.Strings[x], 'IsItalic', TEditorColors(lstElement.Items.Objects[x]).IsItalic);
    pIniFile.WriteBool(lstElement.Items.Strings[x], 'IsUnderline', TEditorColors(lstElement.Items.Objects[x]).IsUnderline);
    pIniFile.WriteString(lstElement.Items.Strings[x], 'ForegroundColor', TEditorColors(lstElement.Items.Objects[x]).Foreground);
    pIniFile.WriteString(lstElement.Items.Strings[x], 'BackgroundColor', TEditorColors(lstElement.Items.Objects[x]).Background);
  end;

  pIniFile.UpdateFile;
  pIniFile.Free;
  frmMain.LoadEditorSettings;
  for x := 0 to LuaOpenedUnits.Count - 1 do
    frmMain.ApplyValuesToEditor(TLuaUnit(LuaOpenedUnits.Items[x]).synUnit, EditorColors);
  Screen.Cursor := crDefault;
end;

procedure TfrmEditorSettings.btnOKClick(Sender: TObject);
begin
  ModalResult := mrNone;
  
  if ((txtUndoLimit.Text = '0') or (txtUndoLimit.Text = '')) then
  begin
    pgcDebuggerSettings.ActivePageIndex := 0;
    Application.MessageBox('The limit of undo must be higher than zero.', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtUndoLimit.SetFocus;
  end
  else if ((txtTabWidth.Text = '0') or (txtTabWidth.Text = '')) then
  begin
    pgcDebuggerSettings.ActivePageIndex := 0;
    Application.MessageBox('The tab width must be higher than zero.', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtTabWidth.SetFocus;
  end
  else if ((txtGutterWidth.Text = '0') or (txtGutterWidth.Text = '')) then
  begin
    pgcDebuggerSettings.ActivePageIndex := 1;
    Application.MessageBox('The gutter width must be higher than zero.', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtGutterWidth.SetFocus;
  end
  else
  begin
    WriteEditorSettings;
    ModalResult := mrOk;
  end;
end;

procedure TfrmEditorSettings.chkShowGutterClick(Sender: TObject);
begin
  cboGutterColor.Enabled := chkShowGutter.Checked;
  txtGutterWidth.Enabled := chkShowGutter.Checked;
  chkShowLineNumbers.Enabled := chkShowGutter.Checked;
  chkLeadingZeros.Enabled := chkShowGutter.Checked;
  Label3.Enabled := chkShowGutter.Checked;
  Label4.Enabled := chkShowGutter.Checked;
end;

procedure TfrmEditorSettings.lstElementClick(Sender: TObject);
var
  SelName: String;
begin
  chkBold.Checked := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).IsBold;
  chkItalic.Checked := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).IsItalic;
  chkUnderline.Checked := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).IsUnderline;
  cboForeground.Selected := StringToColor(TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).Foreground);
  cboBackground.Selected := StringToColor(TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).Background);

  SelName := lstElement.Items.Strings[lstElement.ItemIndex];

  if SelName = 'Background' then
  begin
    chkBold.Enabled := False;
    chkItalic.Enabled := False;
    chkUnderline.Enabled := False;
    cboForeground.Enabled := False;
    Label8.Enabled := False;
    cboBackground.Enabled := True;
  end
  else if ((SelName = 'Selection') or (SelName = 'Breakpoints') or (SelName = 'Error Line') or (SelName = 'Execution Line')) then
  begin
    chkBold.Enabled := False;
    chkItalic.Enabled := False;
    chkUnderline.Enabled := False;
    Label8.Enabled := True;
    cboForeground.Enabled := True;
    cboBackground.Enabled := True;
  end
  else
  begin
    chkBold.Enabled := True;
    chkItalic.Enabled := True;
    chkUnderline.Enabled := True;
    Label8.Enabled := True;
    cboForeground.Enabled := True;
    cboBackground.Enabled := True;
  end;
end;

procedure TfrmEditorSettings.chkBoldClick(Sender: TObject);
begin
  TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).IsBold := chkBold.Checked;
  lstEditorColorsTemp.Items[lstElement.ItemIndex] := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]);
  frmMain.ApplyValuesToEditor(synSample, lstEditorColorsTemp);
end;

procedure TfrmEditorSettings.chkItalicClick(Sender: TObject);
begin
  TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).IsItalic := chkItalic.Checked;
  lstEditorColorsTemp.Items[lstElement.ItemIndex] := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]);
  frmMain.ApplyValuesToEditor(synSample, lstEditorColorsTemp);
end;

procedure TfrmEditorSettings.chkUnderlineClick(Sender: TObject);
begin
  TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).IsUnderline := chkUnderline.Checked;
  lstEditorColorsTemp.Items[lstElement.ItemIndex] := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]);
  frmMain.ApplyValuesToEditor(synSample, lstEditorColorsTemp);
end;

procedure TfrmEditorSettings.cboForegroundChange(Sender: TObject);
begin
  TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).Foreground := ColorToString(cboForeground.Selected);
  lstEditorColorsTemp.Items[lstElement.ItemIndex] := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]);
  frmMain.ApplyValuesToEditor(synSample, lstEditorColorsTemp);
end;

procedure TfrmEditorSettings.cboBackgroundChange(Sender: TObject);
begin
  TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]).Background := ColorToString(cboBackground.Selected);
  lstEditorColorsTemp.Items[lstElement.ItemIndex] := TEditorColors(lstElement.Items.Objects[lstElement.ItemIndex]);
  frmMain.ApplyValuesToEditor(synSample, lstEditorColorsTemp);
end;

procedure TfrmEditorSettings.FormShow(Sender: TObject);
begin
  pgcDebuggerSettings.ActivePageIndex := 0;
  lstEditorColorsTemp.Clear;
  lstEditorColorsTemp.Assign(Main.EditorColors);
  Options := Main.EditorOptions;

  if eoAutoIndent in Options then
    chkAutoIndent.Checked := True
  else
    chkAutoIndent.Checked := False;

  if eoGroupUndo in Options then
    chkGroupUndo.Checked := True
  else
    chkGroupUndo.Checked := False;

  if eoTabIndent in Options then
    chkTabIndent.Checked := True
  else
    chkTabIndent.Checked := False;

  if eoSmartTabs in Options then
    chkSmartTab.Checked := True
  else
    chkSmartTab.Checked := False;

  if eoRightMouseMovesCursor in Options then
    chkRightMouseMovesCursor.Checked := True
  else
    chkRightMouseMovesCursor.Checked := False;

  if eoEnhanceHomeKey in Options then
    chkEHomeKey.Checked := True
  else
    chkEHomeKey.Checked := False;

  if eoTabsToSpaces in Options then
    chkTabsToSpaces.Checked := True
  else
    chkTabsToSpaces.Checked := False;

  if eoHideShowScrollbars in Options then
    chkHideScrollBars.Checked := True
  else
    chkHideScrollBars.Checked := False;

  if eoScrollPastEof in Options then
    chkScrollPastEOF.Checked := True
  else
    chkScrollPastEOF.Checked := False;

  if eoScrollPastEol in Options then
    chkScrollPastEOL.Checked := True
  else
    chkScrollPastEOL.Checked := False;

  if eoKeepCaretX in Options then
    chkKeepCaretX.Checked := True
  else
    chkKeepCaretX.Checked := False;

  if eoTrimTrailingSpaces in Options then
    chkTrailBlanks.Checked := True
  else
    chkTrailBlanks.Checked := False;

  chkFileAssociate.Checked := AssociateFiles;
  chkSaveProjectsInc.Checked := SaveProjectsInc;
  chkSaveUnitsInc.Checked := SaveUnitsInc;
  chkShowExSaveDlg.Checked := ShowExSaveDlg;

  txtUndoLimit.Text := IntToStr(Main.UndoLimit);
  txtTabWidth.Text := IntToStr(Main.TabWidth);
  chkShowGutter.Checked := Main.ShowGutter;
  chkShowLineNumbers.Checked := Main.ShowLineNumbers;
  chkLeadingZeros.Checked := Main.LeadingZeros;
  txtGutterWidth.Text := IntToStr(Main.GutterWidth);
  cboGutterColor.Selected := StringToColor(Main.GutterColor);
  cboFonts.ItemIndex := cboFonts.Items.IndexOf(Main.FontName);
  cboFontSize.ItemIndex := cboFontSize.Items.IndexOf(IntToStr(Main.FontSize));

  lstElement.Items.Clear;
  lstElement.Items.AddObject('Background', lstEditorColorsTemp.Items[0]);
  lstElement.Items.AddObject('Comment', lstEditorColorsTemp.Items[1]);
  lstElement.Items.AddObject('Error Line', lstEditorColorsTemp.Items[2]);
  lstElement.Items.AddObject('Execution Line', lstEditorColorsTemp.Items[3]);
  lstElement.Items.AddObject('Identifier', lstEditorColorsTemp.Items[4]);
  lstElement.Items.AddObject('Numbers', lstEditorColorsTemp.Items[5]);
  lstElement.Items.AddObject('Reserved Words', lstEditorColorsTemp.Items[6]);
  lstElement.Items.AddObject('Selection', lstEditorColorsTemp.Items[7]);
  lstElement.Items.AddObject('Strings', lstEditorColorsTemp.Items[8]);
  lstElement.Items.AddObject('Valid Breakpoint', lstEditorColorsTemp.Items[9]);

  frmMain.ApplyValuesToEditor(synSample, lstEditorColorsTemp);
  lstElement.ItemIndex := 0;
  lstElementClick(lstElement);

  // Hide notification
  NotifyRestart(False);
end;

procedure TfrmEditorSettings.FormDestroy(Sender: TObject);
begin
  lstEditorColorsTemp.Free;
  pTempUnit.Free;
end;

procedure TfrmEditorSettings.NotifyRestart(Notify: Boolean);
begin
  lblNotify.Visible := Notify;
  imgNotify.Visible := Notify;
end;

procedure TfrmEditorSettings.chkFileAssociateClick(Sender: TObject);
begin
  if chkFileAssociate.Checked <> AssociateFiles then
    NotifyRestart(True)
  else
    NotifyRestart(False);
end;

end.
