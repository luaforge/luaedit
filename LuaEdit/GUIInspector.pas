unit GUIInspector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvDockControlForm, Grids, ELPropInsp, ComCtrls,
  StdCtrls, ExtCtrls, TypInfo;

type
  TfrmGUIInspector = class(TForm)
    JvDockClient1: TJvDockClient;
    Panel1: TPanel;
    Panel2: TPanel;
    cboGUIElements: TComboBox;
    TabControl1: TTabControl;
    ELGUIPropertyInspector: TELPropertyInspector;
    procedure ELGUIPropertyInspectorFilterProp(Sender: TObject; AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGUIInspector: TfrmGUIInspector;

implementation

{$R *.dfm}

procedure TfrmGUIInspector.ELGUIPropertyInspectorFilterProp(Sender: TObject; AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: Boolean);
begin
  // Filter out unsupported properties
  if APropInfo.Name = 'Action' then
    AIncludeProp := False;
end;

end.
