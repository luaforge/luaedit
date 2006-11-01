unit ConvertPath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvBaseDlg, JvSelectDirectory, StdCtrls, JvComponent,
  JvBrowseFolder;

type
  TfrmConvertPath = class(TForm)
    btnClose: TButton;
    btnConvert: TButton;
    txtPathToConvert: TEdit;
    btnBrowsePath: TButton;
    txtConvertedPath: TEdit;
    jvSelectDir: TJvBrowseForFolderDialog;
    procedure btnBrowsePathClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConvertPath: TfrmConvertPath;

implementation

uses Main;

{$R *.dfm}

procedure TfrmConvertPath.btnBrowsePathClick(Sender: TObject);
begin
  jvSelectDir.Directory := txtPathToConvert.Text;

  if jvSelectDir.Execute() then
    txtPathToConvert.Text := jvSelectDir.Directory;
end;

procedure TfrmConvertPath.btnConvertClick(Sender: TObject);
begin
  if txtPathToConvert.Text <> '' then
    txtConvertedPath.Text := StringReplace(txtPathToConvert.Text, '\', '\\', [rfReplaceAll, rfIgnoreCase]);
end;

end.
