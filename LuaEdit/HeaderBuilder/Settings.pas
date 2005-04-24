unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Registry;

type
  TfrmSettings = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    odlgTemplate: TOpenDialog;
    txtFctTemplatePath: TEdit;
    btnBrowseFctTpl: TButton;
    TabSheet3: TTabSheet;
    btnEditFctTpl: TButton;
    Label2: TLabel;
    txtFileTemplatePath: TEdit;
    btnBrowseFileTpl: TButton;
    btnEditFileTpl: TButton;
    Label3: TLabel;
    txtDevelopper: TEdit;
    Label4: TLabel;
    txtCopyright: TEdit;
    Label5: TLabel;
    txtInitialRelease: TEdit;
    procedure btnBrowseFctTplClick(Sender: TObject);
    procedure btnBrowseFileTplClick(Sender: TObject);
    procedure txtFileTemplatePathChange(Sender: TObject);
    procedure txtFctTemplatePathChange(Sender: TObject);
  private
    { Private declarations }
    function Browse(sInitial: String): String;
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

function TfrmSettings.Browse(sInitial: String): String;
var
  pReg: TRegistry;
begin
  pReg := TRegistry.Create;
  Result := '';

  if sInitial = '' then
  begin
    if pReg.OpenKey('\Software\LuaEdit\HdrBld', False) then
      sInitialPath := pReg.ReadString('LastBrowsePath');
  end;

  odlgTemplate.InitialDir := sInitial;
  if odlgTemplate.Execute then
  begin
    Result := odlgTemplate.FileName;
    if pReg.OpenKey('\Software\LuaEdit\HdrBld', True) then
      pReg.WriteString('LastBrowsePath', ExtractFilePath(odlgTemplate.FileName));
  end;

  pReg.Free;
end;

procedure TfrmSettings.btnBrowseFctTplClick(Sender: TObject);
begin
  txtFctTemplatePath.Text := Browse(txtFctTemplatePath.Text);
end;

procedure TfrmSettings.btnBrowseFileTplClick(Sender: TObject);
begin
  txtFileTemplatePath.Text := Browse(txtFileTemplatePath.Text);
end;

procedure TfrmSettings.txtFileTemplatePathChange(Sender: TObject);
begin
  btnEditFileTpl.Enabled := (txtFileTemplatePath.Text <> '');
end;

procedure TfrmSettings.txtFctTemplatePathChange(Sender: TObject);
begin
  btnEditFctTpl.Enabled := (txtFctTemplatePath.Text <> '');
end;

end.
