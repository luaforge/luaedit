unit ExSaveExit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvListBox, JvDotNetControls, ExtCtrls;

type
  TfrmExSaveExit = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel3: TPanel;
    Label1: TLabel;
    btnYes: TButton;
    lstFiles: TJvDotNetListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmExSaveExit: TfrmExSaveExit;

implementation

{$R *.dfm}

end.
