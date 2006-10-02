unit GUIFormType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmGUIFormType = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    optLuaUnit: TRadioButton;
    optLuaMacro: TRadioButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGUIFormType: TfrmGUIFormType;

implementation

{$R *.dfm}

procedure TfrmGUIFormType.Button1Click(Sender: TObject);
begin
  Self.Close;
end;

end.
