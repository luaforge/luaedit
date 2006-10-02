unit GUIControls;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvJVCLUtils, JvComponent, JvDockControlForm, JvExControls,
  ExtCtrls, JvOutlookBar, ImgList;

type
  TfrmGUIControls = class(TForm)
    jvGUIControls: TJvOutlookBar;
    JvDockClient1: TJvDockClient;
    imlControls: TImageList;
    procedure jvGUIControlsCustomDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect; AStage: TJvOutlookBarCustomDrawStage; AIndex: Integer; ADown, AInside: Boolean; var DefaultDraw: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure jvGUIControlsPageChange(Sender: TObject; Index: Integer);
  private
    { Private declarations }
    procedure btnXControlClick(Sender: TObject);
    procedure CreateList();
  public
    { Public declarations }
  end;

var
  frmGUIControls: TfrmGUIControls;

implementation

{$R *.dfm}

procedure TfrmGUIControls.jvGUIControlsCustomDraw(Sender: TObject; ACanvas: TCanvas; ARect: TRect; AStage: TJvOutlookBarCustomDrawStage; AIndex: Integer; ADown, AInside: Boolean; var DefaultDraw: Boolean);
var
  pImage: TBitmap;
begin
  DefaultDraw := False;

  case AStage of
    odsBackground:
      // Draw the background
      GradientFillRect(ACanvas, ARect, clBtnFace, clBtnFace, fdTopToBottom, 255);

    odsPage:
      // Draw the page
      GradientFillRect(ACanvas,ARect, clBtnFace, clBtnFace, fdTopToBottom, 255);

    odsPageButton:
    begin
      // Draw the page button
      GradientFillRect(ACanvas,ARect, clBtnFace, clBtnFace, fdTopToBottom, 255);

      if ADown then
        OffsetRect(ARect,1,1);

      Frame3D(ACanvas, ARect, clBtnHighlight, clBtnShadow, 2);
      ACanvas.Font.Color := clBlack;
      ARect.Left := ARect.Left + 18;
      DrawText(ACanvas.Handle, PChar(' '+jvGUIControls.Pages[AIndex].Caption), Length(jvGUIControls.Pages[AIndex].Caption)+1, ARect, DT_SINGLELINE or DT_VCENTER or DT_LEFT);
    end;

    odsButton:
    begin
      // Draw small button image if required
      if jvGUIControls.ActivePage.Buttons[AIndex].ImageIndex <> -1 then
      begin
        pImage := TBitmap.Create;
        imlControls.GetBitmap(jvGUIControls.ActivePage.Buttons[AIndex].ImageIndex, pImage);
        pImage.Transparent := True;
        pImage.TransparentColor := pImage.Canvas.Pixels[0, 0];
        pImage.TransparentMode := tmAuto;
        ACanvas.Draw(ARect.Left + 1, ARect.Top + 3, pImage);
        pImage.Free;
      end;

      // Draw the button
      ACanvas.Font.Color := clBlack;
      ARect.Left := ARect.Left + 17;
      DrawText(ACanvas.Handle, PChar(' '+jvGUIControls.ActivePage.Buttons[AIndex].Caption), Length(jvGUIControls.ActivePage.Buttons[AIndex].Caption)+1, ARect, DT_SINGLELINE or DT_VCENTER or DT_LEFT or DT_MODIFYSTRING or DT_END_ELLIPSIS);
    end;

    odsButtonFrame:
    begin
      // Draw button frame according to its down value (this is called if the button is down or if the mouse is over)
      if ADown then
        Frame3D(ACanvas, ARect, clBtnShadow, clBtnHighlight, 2)
      else
        Frame3D(ACanvas, ARect, clBtnHighlight, clBtnShadow, 2);
    end;
  end;
end;

procedure TfrmGUIControls.jvGUIControlsPageChange(Sender: TObject; Index: Integer);
begin
  jvGUIControls.Pages[Index].DownIndex := 0;
end;

procedure TfrmGUIControls.btnXControlClick(Sender: TObject);
var
  btnSender: TJvOutlookBarButton;
begin
  btnSender := TJvOutlookBarButton(Sender);
  btnSender.Down := True;
end;

procedure TfrmGUIControls.CreateList();
  // This method add a button to the controls list
  procedure AddOBButton(pOnClick: TNotifyEvent; iPageIndex: Integer; iImageIndex: Integer; sCaption: String; bDown: Boolean = False; bEnabled: Boolean = True);
  var
    jvOBBtn: TJvOutlookBarButton;
  begin
    jvOBBtn := jvGUIControls.Pages[iPageIndex].Buttons.Add();
    jvOBBtn.Caption := sCaption;
    jvOBBtn.ImageIndex := iImageIndex;
    jvOBBtn.Down := bDown;
    jvOBBtn.Enabled := bEnabled;
    jvOBBtn.OnClick := pOnClick;
  end;

begin
  // Create standard controls...
  AddOBButton(btnXControlClick, 0, 0, 'Select', True);
  AddOBButton(btnXControlClick, 0, 1, 'Label');
  AddOBButton(btnXControlClick, 0, 2, 'Button');
  AddOBButton(btnXControlClick, 0, 3, 'Edit');
  AddOBButton(btnXControlClick, 0, 4, 'CheckBox');
  AddOBButton(btnXControlClick, 0, 5, 'RadioButton');

  // Create additional controls...
  AddOBButton(btnXControlClick, 1, 0, 'Select', True);
  AddOBButton(btnXControlClick, 1, 6, 'Image');
end;

procedure TfrmGUIControls.FormCreate(Sender: TObject);
begin
  CreateList();
end;

end.
