unit ReplaceQuerry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmReplaceQuerry = class(TForm)
    lblConfirmation: TLabel;
    imgIcon: TImage;
    btnReplace: TButton;
    btnSkip: TButton;
    btnCancel: TButton;
    btnReplaceAll: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Prepare(EditorRect: TRect; X, Y1, Y2: Integer; sReplaceText: string);
  end;

var
  frmReplaceQuerry: TfrmReplaceQuerry;

const
  sAskReplaceText = 'Replace this occurence of "%s"?';

implementation

{$R *.dfm}

procedure TfrmReplaceQuerry.Prepare(EditorRect: TRect; X, Y1, Y2: Integer; sReplaceText: string);
var
  nW, nH: integer;
begin
  imgIcon.Picture.Icon.Handle := LoadIcon(0, IDI_QUESTION);
  lblConfirmation.Caption := Format(SAskReplaceText, [sReplaceText]);
  nW := EditorRect.Right - EditorRect.Left;
  nH := EditorRect.Bottom - EditorRect.Top;

  if nW <= Width then
    X := EditorRect.Left - (Width - nW) div 2
  else
  begin
    if X + Width > EditorRect.Right then
      X := EditorRect.Right - Width;
  end;
  
  if Y2 > EditorRect.Top + MulDiv(nH, 2, 3) then
    Y2 := Y1 - Height - 4
  else
    Inc(Y2, 4);
    
  SetBounds(X, Y2, Width, Height);
end;

end.
