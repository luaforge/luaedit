unit GUIDesigner;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ELDsgnr, StdCtrls, ExtCtrls, Misc;

type
  TGUIForm1 = class(TForm)
    ELGUIDesigner: TELDesigner;
    procedure FormShow(Sender: TObject);
    procedure ELGUIDesignerChangeSelection(Sender: TObject);
    procedure ELGUIDesignerControlInserting(Sender: TObject; var AControlClass: TControlClass);
    procedure ELGUIDesignerControlInserted(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ELGUIDesignerModified(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pLuaEditGUIForm: TLuaEditGUIForm;
  end;

var
  GUIForm1: TGUIForm1;

implementation

uses GUIInspector, GUIControls;

{$R *.dfm}

procedure TGUIForm1.FormShow(Sender: TObject);
begin
  ELGUIDesigner.DesignControl := Self;
  ELGUIDesigner.Active := True;
end;

procedure TGUIForm1.ELGUIDesignerChangeSelection(Sender: TObject);
var
  lstObjects: TList;
begin
  try
    lstObjects := TList.Create;
    frmGUIInspector.ELGUIPropertyInspector.Clear;
    ELGUIDesigner.SelectedControls.GetControls(lstObjects);
    frmGUIInspector.ELGUIPropertyInspector.AssignObjects(lstObjects);
  finally
    lstObjects.Free;
  end;
end;

procedure TGUIForm1.ELGUIDesignerControlInserting(Sender: TObject; var AControlClass: TControlClass);
var
  sCtrlName: String;
begin
  sCtrlName := UpperCase(frmGUIControls.jvGUIControls.ActivePage.DownButton.Caption);

  if sCtrlName = 'LABEL' then
    AControlClass := TLabel
  else if sCtrlName = 'BUTTON' then
    AControlClass := TButton
  else if sCtrlName = 'EDIT' then
    AControlClass := TEdit
  else if sCtrlName = 'CHECKBOX' then
    AControlClass := TCheckBox
  else if sCtrlName = 'RADIO' then
    AControlClass := TRadioButton
  else if sCtrlName = 'IMAGE' then
    AControlClass := TImage;
end;

procedure TGUIForm1.ELGUIDesignerControlInserted(Sender: TObject);
begin
  frmGUIControls.jvGUIControls.ActivePage.DownIndex := 0;
end;

procedure TGUIForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  ShowWindow(Self.Handle, SW_HIDE);
  CanClose := False;
end;

procedure TGUIForm1.ELGUIDesignerModified(Sender: TObject);
begin
  pLuaEditGUIForm.HasChanged := True;
end;

end.
