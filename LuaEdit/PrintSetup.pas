unit PrintSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, Main;

type
  TfrmPrintSetup = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnOk: TButton;
    Button1: TButton;
    chkUseColors: TCheckBox;
    chkUseHighLight: TCheckBox;
    chkShowLineNumbers: TCheckBox;
    chkWrapLines: TCheckBox;
    chkLineNumbersInMargin: TCheckBox;
    psdlgPrinterSetup: TPrinterSetupDialog;
    procedure Button1Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrintSetup: TfrmPrintSetup;

implementation

{$R *.dfm}

procedure TfrmPrintSetup.Button1Click(Sender: TObject);
begin
  psdlgPrinterSetup.Execute;
end;

procedure TfrmPrintSetup.btnOkClick(Sender: TObject);
var
  pIniFile: TIniFile;
begin
  pIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\LuaEdit.ini');
  
  //Printing Settings
  PrintUseColor := chkUseColors.Checked;
  PrintUseSyntax := chkUseHighLight.Checked;
  PrintUseWrapLines := chkWrapLines.Checked;
  PrintLineNumbers := chkShowLineNumbers.Checked;
  PrintLineNumbersInMargin := chkLineNumbersInMargin.Checked;

  pIniFile.WriteBool('PrintSetup', 'UseColors', chkUseColors.Checked);
  pIniFile.WriteBool('PrintSetup', 'UseSyntax', chkUseHighLight.Checked);
  pIniFile.WriteBool('PrintSetup', 'UseWrapLines', chkWrapLines.Checked);
  pIniFile.WriteBool('PrintSetup', 'LineNumbers', chkShowLineNumbers.Checked);
  pIniFile.WriteBool('PrintSetup', 'LineNumbersInMargin', chkLineNumbersInMargin.Checked);

  pIniFile.Free;
end;

procedure TfrmPrintSetup.FormShow(Sender: TObject);
begin
  chkUseColors.Checked := PrintUseColor;
  chkUseHighLight.Checked := PrintUseSyntax;
  chkWrapLines.Checked := PrintUseWrapLines;
  chkShowLineNumbers.Checked := PrintLineNumbers;
  chkLineNumbersInMargin.Checked := PrintLineNumbersInMargin;
end;

end.
