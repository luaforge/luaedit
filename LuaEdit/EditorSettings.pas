unit EditorSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SynEdit, ComCtrls, ExtCtrls, IniFiles, Main, LuaSyntax,
  Registry, ImgList, JvExControls, JvComponent, JvGroupHeader, JvPageList,
  JvExComCtrls, JvPageListTreeView, Buttons, JvxSlider, Mask, JvExMask,
  JvSpin, Misc, JvToolEdit, JvDotNetControls;

const
  UM_MEASUREFONTS = WM_USER;

type
  TfrmEditorSettings = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    imgNotify: TImage;
    lblNotify: TLabel;
    jvSettingsTVSettings: TJvSettingsTreeView;
    jvPageListSettings: TJvPageList;
    JvStandardPage1: TJvStandardPage;
    JvGroupHeader1: TJvGroupHeader;
    chkFileAssociate: TCheckBox;
    chkKeepReportOpened: TCheckBox;
    chkShowExSaveDlg: TCheckBox;
    chkSaveProjectsInc: TCheckBox;
    chkSaveUnitsInc: TCheckBox;
    chkSaveBreakpoints: TCheckBox;
    JvStandardPage2: TJvStandardPage;
    txtTabWidth: TEdit;
    txtUndoLimit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    chkAutoIndent: TCheckBox;
    chkSmartTab: TCheckBox;
    chkTabIndent: TCheckBox;
    chkGroupUndo: TCheckBox;
    chkRightMouseMovesCursor: TCheckBox;
    chkEHomeKey: TCheckBox;
    chkTabsToSpaces: TCheckBox;
    chkHideScrollBars: TCheckBox;
    chkTrailBlanks: TCheckBox;
    chkKeepCaretX: TCheckBox;
    chkScrollPastEOL: TCheckBox;
    chkScrollPastEOF: TCheckBox;
    JvGroupHeader2: TJvGroupHeader;
    imlEditorSettings: TImageList;
    JvStandardPage3: TJvStandardPage;
    JvStandardPage4: TJvStandardPage;
    Label10: TLabel;
    txtLibraries: TEdit;
    btnBrowseLibraries: TButton;
    JvGroupHeader3: TJvGroupHeader;
    JvGroupHeader4: TJvGroupHeader;
    JvStandardPage5: TJvStandardPage;
    chkShowGutter: TCheckBox;
    chkShowLineNumbers: TCheckBox;
    chkLeadingZeros: TCheckBox;
    cboGutterColor: TColorBox;
    Label4: TLabel;
    txtGutterWidth: TEdit;
    Label3: TLabel;
    JvGroupHeader5: TJvGroupHeader;
    JvStandardPage6: TJvStandardPage;
    pnlPreview: TPanel;
    cboFonts: TComboBox;
    Label5: TLabel;
    cboFontSize: TComboBox;
    Label6: TLabel;
    JvGroupHeader6: TJvGroupHeader;
    JvStandardPage7: TJvStandardPage;
    synSample: TSynEdit;
    lstElement: TListBox;
    Label7: TLabel;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    Label8: TLabel;
    cboForeground: TColorBox;
    Label9: TLabel;
    cboBackground: TColorBox;
    JvGroupHeader7: TJvGroupHeader;
    Label11: TLabel;
    cboColorSet: TComboBox;
    bitbtnDelete: TBitBtn;
    bitbtnSave: TBitBtn;
    bitbtnNew: TBitBtn;
    Splitter1: TSplitter;
    jvslAnimatedTabsSpeed: TJvxSlider;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    chkShowStatusBar: TCheckBox;
    JvGroupHeader8: TJvGroupHeader;
    JvGroupHeader9: TJvGroupHeader;
    JvGroupHeader10: TJvGroupHeader;
    JvGroupHeader11: TJvGroupHeader;
    JvGroupHeader12: TJvGroupHeader;
    JvGroupHeader13: TJvGroupHeader;
    JvGroupHeader14: TJvGroupHeader;
    txtHomePage: TEdit;
    txtSearchPage: TEdit;
    chkHomePage: TCheckBox;
    chkSearchPage: TCheckBox;
    jvspinHistoryMaxAge: TJvSpinEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    txtTempFolder: TJvDotNetDirectoryEdit;
    procedure cboFontsMeasureItem(Control: TWinControl; Index: Integer;  var Height: Integer);
    procedure cboFontsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure cboFontsChange(Sender: TObject);
    procedure cboFontSizeKeyPress(Sender: TObject; var Key: Char);
    procedure cboFontSizeChange(Sender: TObject);
    procedure txtUndoLimitKeyPress(Sender: TObject; var Key: Char);
    procedure txtTabWidthKeyPress(Sender: TObject; var Key: Char);
    procedure txtGutterWidthKeyPress(Sender: TObject; var Key: Char);
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
    procedure cboFontSizeMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure btnBrowseLibrariesClick(Sender: TObject);
    procedure cboColorSetClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure bitbtnDeleteClick(Sender: TObject);
    procedure bitbtnNewClick(Sender: TObject);
    procedure bitbtnSaveClick(Sender: TObject);
    procedure chkHomePageClick(Sender: TObject);
    procedure chkSearchPageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UMMeasureFonts(var msg: TMessage); message UM_MEASUREFONTS;
    procedure NotifyRestart(Notify: Boolean);
    procedure LoadEditorSettings;
    procedure WriteEditorSettings;
    procedure WriteColorSet;
    procedure BuildColorSetList;
  end;

var
  frmEditorSettings: TfrmEditorSettings;
  Options: TSynEditorOptions;
  lstEditorColorsTemp: TList;
  pTempUnit: TLuaUnit;

function SetPrivilege(sPrivilegeName : PChar; bEnabled : boolean): boolean; cdecl; external 'LuaEditSys.dll';
function WinExit(iFlags: integer): Boolean; cdecl; external 'LuaEditSys.dll';

implementation

uses RegSetFileType, SearchPath;

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
  pReg: TRegistry;
  x: Integer;
begin
  Screen.Cursor := crHourGlass;
  pReg := TRegistry.Create();

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

  pReg.OpenKey('\Software\LuaEdit\EditorSettings\General', True);
  pReg.WriteInteger('EditorOptions', Integer(Options));
  pReg.WriteInteger('UndoLimit', StrToInt(txtUndoLimit.Text));
  pReg.WriteInteger('TabWidth', StrToInt(txtTabWidth.Text));
  pReg.WriteInteger('AnimatedTabsSpeed', 2001 - jvslAnimatedTabsSpeed.Value);
  pReg.WriteInteger('HistoryMaxAge', Trunc(jvspinHistoryMaxAge.Value));
  pReg.WriteBool('SaveProjectsInc', chkSaveProjectsInc.Checked);
  pReg.WriteBool('SaveBreakpoints', chkSaveBreakpoints.Checked);
  pReg.WriteBool('SaveUnitsInc', chkSaveUnitsInc.Checked);
  pReg.WriteBool('AssociateFiles', chkFileAssociate.Checked);
  pReg.WriteBool('ShowExSaveDlg', chkShowExSaveDlg.Checked);
  pReg.WriteBool('KeepSIFWindowOpened', chkKeepReportOpened.Checked);
  pReg.WriteBool('ShowStatusBar', chkShowStatusBar.Checked);
  pReg.WriteString('HomePage', txtHomePage.Text);
  pReg.WriteString('SearchPage', txtSearchPage.Text);
  pReg.WriteString('TempFolder', txtTempFolder.Text);

  // Clean up old temporary folder if set to new one
  if TempFolder <> txtTempFolder.Text then
    frmMain.CleanUpTempDir();

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
        Application.MessageBox('LuaEdit was unable to restart your computer!', 'LuaEdit', MB_OK+MB_ICONERROR);
    end;
  end;

  // Writing environement settings
  pReg.OpenKey('\Software\LuaEdit\EditorSettings\Environment', True);
  pReg.WriteString('LibrariesSearchPaths', '"'+txtLibraries.Text+'"');

  //Writing display settings
  pReg.OpenKey('\Software\LuaEdit\EditorSettings\Display', True);
  pReg.WriteBool('ShowGutter', chkShowGutter.Checked);
  pReg.WriteBool('ShowLineNumbers', chkShowLineNumbers.Checked);
  pReg.WriteBool('LeadingZeros', chkLeadingZeros.Checked);
  pReg.WriteInteger('GutterWidth', StrToInt(txtGutterWidth.Text));
  pReg.WriteString('GutterColor', ColorToString(cboGutterColor.Selected));
  pReg.WriteString('FontName', cboFonts.Text);
  pReg.WriteInteger('FontSize', StrToInt(cboFontSize.Text));
  pReg.WriteString('ColorSet', cboColorSet.Text);

  pReg.Free;
  WriteColorSet;    

  frmMain.LoadEditorSettingsFromReg;
  for x := 0 to LuaOpenedUnits.Count - 1 do
    frmMain.ApplyValuesToEditor(TLuaUnit(LuaOpenedUnits.Items[x]).synUnit, EditorColors);
  Screen.Cursor := crDefault;
end;

procedure TfrmEditorSettings.WriteColorSet;
var
  pColorSet: TIniFile;
  x: Integer;
begin
  // Create .\Data directory if innexistant
  if not DirectoryExists(GetLuaEditInstallPath()+'\Data') then
    CreateDirectory(PChar(GetLuaEditInstallPath()+'\Data'), nil);

  // Creating/opening file
  pColorSet := TIniFile.Create(GetLuaEditInstallPath()+'\Data\' + cboColorSet.Text + '.dat');

  //Writing colors settings
  for x := 0 to lstElement.Items.Count - 1 do
  begin
    pColorSet.WriteBool(lstElement.Items.Strings[x], 'IsBold', TEditorColors(lstElement.Items.Objects[x]).IsBold);
    pColorSet.WriteBool(lstElement.Items.Strings[x], 'IsItalic', TEditorColors(lstElement.Items.Objects[x]).IsItalic);
    pColorSet.WriteBool(lstElement.Items.Strings[x], 'IsUnderline', TEditorColors(lstElement.Items.Objects[x]).IsUnderline);
    pColorSet.WriteString(lstElement.Items.Strings[x], 'ForegroundColor', TEditorColors(lstElement.Items.Objects[x]).Foreground);
    pColorSet.WriteString(lstElement.Items.Strings[x], 'BackgroundColor', TEditorColors(lstElement.Items.Objects[x]).Background);
  end;

  pColorSet.UpdateFile;
  pColorSet.Free;
end;

procedure TfrmEditorSettings.LoadEditorSettings;
var
  x: Integer;
begin
  lstEditorColorsTemp.Assign(EditorColors);
  Options := EditorOptions;

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
  chkSaveBreakpoints.Checked := SaveBreakpoints;
  chkKeepReportOpened.Checked := KeepSIFWindowOpened;
  chkShowStatusBar.Checked := ShowStatusBar;
  jvslAnimatedTabsSpeed.Value := 2001 - AnimatedTabsSpeed;
  txtUndoLimit.Text := IntToStr(Main.UndoLimit);
  txtTabWidth.Text := IntToStr(Main.TabWidth);
  txtLibraries.Text := LibrariesSearchPaths.CommaText;
  chkShowGutter.Checked := Main.ShowGutter;
  chkShowLineNumbers.Checked := Main.ShowLineNumbers;
  chkLeadingZeros.Checked := Main.LeadingZeros;
  txtGutterWidth.Text := IntToStr(Main.GutterWidth);
  cboGutterColor.Selected := StringToColor(Main.GutterColor);
  cboFonts.ItemIndex := cboFonts.Items.IndexOf(Main.FontName);
  cboFontSize.ItemIndex := cboFontSize.Items.IndexOf(IntToStr(Main.FontSize));
  txtHomePage.Text := HomePage;
  chkHomePage.Checked := (txtHomePage.Text <> '');
  txtHomePage.Enabled := chkHomePage.Checked;
  txtSearchPage.Text := SearchPage;
  chkSearchPage.Checked := (txtSearchPage.Text <> '');
  txtSearchPage.Enabled := chkSearchPage.Checked;
  txtTempFolder.Text := TempFolder;
  jvspinHistoryMaxAge.Value := HistoryMaxAge;

  if cboColorSet.ItemIndex = -1 then
  begin
    for x := 0 to cboColorSet.Items.Count - 1 do
    begin
      if Main.ColorSet = cboColorSet.Items[x] then
        cboColorSet.ItemIndex := x;
    end;
  end;

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
end;

procedure TfrmEditorSettings.btnOKClick(Sender: TObject);
begin
  ModalResult := mrNone;
  
  if ((txtUndoLimit.Text = '0') or (txtUndoLimit.Text = '')) then
  begin
    jvPageListSettings.ActivePageIndex := 1;
    Application.MessageBox('The limit of undo must be higher than zero.', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtUndoLimit.SetFocus;
  end
  else if ((txtTabWidth.Text = '0') or (txtTabWidth.Text = '')) then
  begin
    jvPageListSettings.ActivePageIndex := 1;
    Application.MessageBox('The tab width must be higher than zero.', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtTabWidth.SetFocus;
  end
  else if ((txtGutterWidth.Text = '0') or (txtGutterWidth.Text = '')) then
  begin
    jvPageListSettings.ActivePageIndex := 4;
    Application.MessageBox('The gutter width must be higher than zero.', 'LuaEdit', MB_OK+MB_ICONERROR);
    txtGutterWidth.SetFocus;
  end
  else if cboColorSet.Text = '' then
  begin
    jvPageListSettings.ActivePageIndex := 6;
    Application.MessageBox('The color set name can''t be empty.', 'LuaEdit', MB_OK+MB_ICONERROR);
    cboColorSet.SetFocus;
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
  jvPageListSettings.ActivePageIndex := 0;
  jvSettingsTVSettings.Selected := jvSettingsTVSettings.Items[1];
  lstEditorColorsTemp.Clear;
  BuildColorSetList;

  // Initializing settings
  LoadEditorSettings;

  // Hide notification
  NotifyRestart(False);
end;

procedure TfrmEditorSettings.BuildColorSetList;
var
  srSearchRec: TSearchRec;
begin
  cboColorSet.Clear;

  // Fill content of ColorSet combo box
  if FindFirst(GetLuaEditInstallPath()+'\Data\*.dat', faAnyFile, srSearchRec) = 0 then
  begin
    repeat
      cboColorSet.AddItem(Copy(srSearchRec.Name, 1, Length(srSearchRec.Name) - 4), nil);
    until FindNext(srSearchRec) <> 0;
  end;
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

procedure TfrmEditorSettings.btnBrowseLibrariesClick(Sender: TObject);
begin
  // Initialize search path form
  frmSearchPath := TfrmSearchPath.Create(nil);
  frmSearchPath.InitSearchPathForm(txtLibraries.Text, 'Libraries Search Paths', 'Select libraries search paths for LuaEdit to use when looking for *.lib files:');

  // Show form and replace current path string by the new one
  if frmSearchPath.ShowModal = mrOk then
     txtLibraries.Text := frmSearchPath.GetSearchPathString;

  // Free search path form
  frmSearchPath.Free;
end;

procedure TfrmEditorSettings.cboColorSetClick(Sender: TObject);
begin
  frmMain.GetColorSet(cboColorSet.Items[cboColorSet.ItemIndex]);
  LoadEditorSettings;
end;

procedure TfrmEditorSettings.btnCancelClick(Sender: TObject);
begin
  frmMain.LoadEditorSettingsFromReg;
end;

procedure TfrmEditorSettings.bitbtnDeleteClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('Are you sure you want to delete color set "' + cboColorSet.Text + '"?'), 'LuaEdit', MB_ICONQUESTION+MB_YESNO) = IDYES then
  begin
    DeleteFile(GetLuaEditInstallPath()+'\Data\'+cboColorSet.Text+'.dat');
    BuildColorSetList;
    cboColorSet.ItemIndex := 0;
  end;
end;

procedure TfrmEditorSettings.bitbtnNewClick(Sender: TObject);
var
  sColorSet: String;
  x: Integer;
begin
  sColorSet := 'New Color Set';
  
  if InputQuery('Add Color Set', 'Enter the name of the new color set:', sColorSet) then
  begin
    if sColorSet <> '' then
    begin
      if not FileExists(GetLuaEditInstallPath()+'\Data\'+sColorSet+'.dat') then
      begin
        if not DirectoryExists(GetLuaEditInstallPath()+'\Data\') then
          CreateDirectory(PChar(GetLuaEditInstallPath()+'\Data\'), nil);

        CloseHandle(CreateFile(PChar(GetLuaEditInstallPath()+'\Data\'+sColorSet+'.dat'), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_NEW, 0, 0));
        BuildColorSetList;

        for x := 0 to cboColorSet.Items.Count - 1 do
        begin
          if sColorSet = cboColorSet.Items[x] then
            cboColorSet.ItemIndex := x;
        end;

        frmMain.GetColorSet(cboColorSet.Items[cboColorSet.ItemIndex]);
        LoadEditorSettings;
      end
      else
        Application.MessageBox('The specified color set name already exists!', 'LuaEdit', MB_ICONERROR);
    end
    else
      Application.MessageBox('Invalid color set name!', 'LuaEdit', MB_ICONERROR);
  end;
end;

procedure TfrmEditorSettings.bitbtnSaveClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('Save changes to "' + cboColorSet.Text + '"?'), 'LuaEdit', MB_ICONQUESTION+MB_YESNO) = IDYES then
    WriteColorSet;

  {if cboColorSet.Items.Count > 0 then
  begin
    cboColorSet.ItemIndex := 0;
    frmMain.GetColorSet(cboColorSet.Items[cboColorSet.ItemIndex]);
    LoadEditorSettings;
  end;}
end;

procedure TfrmEditorSettings.chkHomePageClick(Sender: TObject);
begin
  if not chkHomePage.Checked then
    txtHomePage.Text := '';

  txtHomePage.Enabled := chkHomePage.Checked;
end;

procedure TfrmEditorSettings.chkSearchPageClick(Sender: TObject);
begin
  if not chkSearchPage.Checked then
    txtSearchPage.Text := '';

  txtSearchPage.Enabled := chkSearchPage.Checked;
end;

end.
