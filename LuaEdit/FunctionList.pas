unit FunctionList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmFunctionList = class(TForm)
    lstFunctions: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshList(sFileName: String);
  end;

var
  frmFunctionList: TfrmFunctionList;

implementation

{$R *.dfm}

procedure TfrmFunctionList.RefreshList(sFileName: String);
var
  CTagAppPath: String;
  CTagParams: String;
begin
  CTagAppPath := ExtractFilePath(Application.ExeName) + '\ctags.exe';
  CTagParams := '--languages=+Lua --langmap=.lua';
end;

end.
