unit RTDebugOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, MGRegistry;

type
  TFormOptions = class(TForm)
    edLogFilename: TLabeledEdit;
    btBrowseFile: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    dlgSaveLog: TSaveDialog;
    cbLogOnFile: TCheckBox;
    procedure btBrowseFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbLogOnFileClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveOptions;
    procedure LoadOptions;
  public
    { Public declarations }
  end;

var
  FormOptions: TFormOptions;

implementation

{$R *.dfm}

uses RTDebug;

procedure TFormOptions.SaveOptions;
Var
   xReg :TMGRegistry;

begin
     xReg :=TMGRegistry.Create;
     if xReg.OpenKey(REG_KEY, true)
     then begin
               xReg.WriteBool(REG_LOGONFILE, Self.cbLogOnFile.Checked);
               xReg.WriteString(REG_LOGFILE, Self.edLogFilename.Text);
          end;
     xReg.Free;
end;

procedure TFormOptions.LoadOptions;
Var
   xReg :TMGRegistry;

begin
     xReg :=TMGRegistry.Create;
     if xReg.OpenKeyReadOnly(REG_KEY)
     then begin
               Self.cbLogOnFile.Checked :=xReg.ReadBool(False, REG_LOGONFILE);
               Self.edLogFilename.Text :=xReg.ReadString('', true, REG_LOGFILE);
          end
     else begin
               Self.cbLogOnFile.Checked := False;
               Self.edLogFilename.Text :='';
          end;
     cbLogOnFileClick(nil);
     xReg.Free;
end;

procedure TFormOptions.btBrowseFileClick(Sender: TObject);
begin
     if dlgSaveLog.Execute then
     begin
          Self.edLogFilename.Text := dlgSaveLog.FileName;
     end;
end;

procedure TFormOptions.Button1Click(Sender: TObject);
begin
     SaveOptions;
end;

procedure TFormOptions.FormShow(Sender: TObject);
begin
     LoadOptions;
end;

procedure TFormOptions.cbLogOnFileClick(Sender: TObject);
begin
     edLogFileName.Enabled :=cbLogOnFile.Checked;
     btBrowseFile.Enabled :=cbLogOnFile.Checked;
     if (edLogFileName.Enabled)
     then edLogFileName.Color :=clWindow
     else edLogFileName.Color :=clBtnFace;
end;

end.
