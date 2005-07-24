unit Rings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvOutlookBar, JvDockControlForm, JvExControls,
  ExtCtrls, JvNavigationPane, JvJVCLUtils, JvComponent;

type
  TfrmRings = class(TForm)
    jvRings: TJvOutlookBar;
    JvDockClient1: TJvDockClient;
    procedure jvRingsCustomDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect; AStage: TJvOutlookBarCustomDrawStage; AIndex: Integer; ADown, AInside: Boolean; var DefaultDraw: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRings: TfrmRings;

implementation

{$R *.dfm}

procedure TfrmRings.jvRingsCustomDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect; AStage: TJvOutlookBarCustomDrawStage; AIndex: Integer; ADown, AInside: Boolean; var DefaultDraw: Boolean);
begin
  DefaultDraw := False;

  case AStage of
    odsBackground:
      GradientFillRect(ACanvas, ARect, clBtnFace, clBtnFace, fdTopToBottom, 255);

    odsPage:
      GradientFillRect(ACanvas,ARect, clWhite, clWhite, fdTopToBottom, 255);

    odsPageButton:
    begin
      GradientFillRect(ACanvas,ARect, clBtnFace, clBtnFace, fdTopToBottom, 255);

      if ADown then
        OffsetRect(ARect,1,1);

      Frame3D(ACanvas, ARect, clBtnHighlight, clBtnShadow, 2);
      ACanvas.Font.Color := clBlack;
      DrawText(ACanvas.Handle, PChar(' '+jvRings.Pages[AIndex].Caption), Length(jvRings.Pages[AIndex].Caption)+1, ARect, DT_SINGLELINE or DT_VCENTER or DT_LEFT);
    end;

    odsButton:
    begin
      ACanvas.Font.Color := clBlack;
      DrawText(ACanvas.Handle, PChar(' '+jvRings.ActivePage.Buttons[AIndex].Caption), Length(jvRings.ActivePage.Buttons[AIndex].Caption)+1, ARect, DT_SINGLELINE or DT_VCENTER or DT_LEFT or DT_MODIFYSTRING or DT_END_ELLIPSIS);
    end;

    odsButtonFrame:
    begin
      ACanvas.Brush.Color := clNavy;
      ACanvas.FrameRect(ARect);
      InflateRect(ARect,-1,-1);
      if ADown then
        ACanvas.Brush.Color := clWhite;
      ACanvas.FrameRect(ARect);
    end;
  end;
end;

end.
