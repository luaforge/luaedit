unit SIFReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvExExtCtrls, JvShape, JvExForms,
  JvCustomItemViewer, JvOwnerDrawViewer, JvComponent, JvPanel,
  JvExControls, JvLabel;

type
  TfrmSIFReport = class(TForm)
    Label1: TLabel;
    lblCurrentFile: TJvLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    chkKeepReportOpened: TCheckBox;
    lblMatchFound: TJvLabel;
    lblScannedLines: TJvLabel;
    lblScannedFiles: TJvLabel;
    lblSkippedFiles: TJvLabel;
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkKeepReportOpenedClick(Sender: TObject);
  private
    { Private declarations }
    FCurrentFile: String;
    FMatchFound: Integer;
    FScannedLines: Integer;
    FScannedFiles: Integer;
    FSkippedFiles: Integer;

    procedure UpdateUI;
    procedure SetCurrentFile(FileName: String);
    procedure SetMatchFound(Count: Integer);
    procedure SetScannedLines(Count: Integer);
    procedure SetScannedFiles(Count: Integer);
    procedure SetSkippedFiles(Count: Integer);
  public
    { Public declarations }
    procedure ResetReport;
    
    property CurrentFile: String read FCurrentFile write SetCurrentFile;
    property MatchFound: Integer read FMatchFound write SetMatchFound;
    property ScannedLines: Integer read FScannedLines write SetScannedLines;
    property ScannedFiles: Integer read FScannedFiles write SetScannedFiles;
    property SkippedFiles: Integer read FSkippedFiles write SetSkippedFiles;
  end;

var
  frmSIFReport: TfrmSIFReport;

implementation

uses Main;

{$R *.dfm}

procedure TfrmSIFReport.ResetReport;
begin
  FCurrentFile := '[None]';
  FMatchFound := 0;
  FScannedLines := 0;
  FScannedFiles := 0;
  FSkippedFiles := 0;
  UpdateUI;
end;

procedure TfrmSIFReport.UpdateUI;
var
  pRect: TRect;
begin
  // Initialize stuff...
  lblCurrentFile.Caption := FCurrentFile;
  lblMatchFound.Caption := IntToStr(FMatchFound);
  lblScannedLines.Caption := IntToStr(FScannedLines);
  lblScannedFiles.Caption := IntToStr(FScannedFiles);
  lblSkippedFiles.Caption := IntToStr(FSkippedFiles);
  Self.Canvas.Brush.Color := clInactiveCaption;

  // Draw the frame rectangle to add some style
  pRect := lblCurrentFile.BoundsRect;
  InflateRect(pRect, 2, 1);
  Self.Canvas.FrameRect(pRect);
  pRect := lblMatchFound.BoundsRect;
  InflateRect(pRect, 2, 1);
  Self.Canvas.FrameRect(pRect);
  pRect := lblScannedLines.BoundsRect;
  InflateRect(pRect, 2, 1);
  Self.Canvas.FrameRect(pRect);
  pRect := lblScannedFiles.BoundsRect;
  InflateRect(pRect, 2, 1);
  Self.Canvas.FrameRect(pRect);
  pRect := lblSkippedFiles.BoundsRect;
  InflateRect(pRect, 2, 1);
  Self.Canvas.FrameRect(pRect);
  Application.ProcessMessages;
end;

procedure TfrmSIFReport.SetCurrentFile(FileName: String);
begin
  FCurrentFile := FileName;
  UpdateUI;
end;

procedure TfrmSIFReport.SetMatchFound(Count: Integer);
begin
  FMatchFound := Count;
  UpdateUI;
end;

procedure TfrmSIFReport.SetScannedLines(Count: Integer);
begin
  FScannedLines := Count;
  UpdateUI;
end;

procedure TfrmSIFReport.SetScannedFiles(Count: Integer);
begin
  FScannedFiles := Count;
  UpdateUI;
end;

procedure TfrmSIFReport.SetSkippedFiles(Count: Integer);
begin
  FSkippedFiles := Count;
  UpdateUI;
end;

procedure TfrmSIFReport.FormPaint(Sender: TObject);
begin
  UpdateUI;
end;

procedure TfrmSIFReport.FormShow(Sender: TObject);
begin
  chkKeepReportOpened.Checked := KeepSIFWindowOpened;
end;

procedure TfrmSIFReport.chkKeepReportOpenedClick(Sender: TObject);
begin
  KeepSIFWindowOpened := chkKeepReportOpened.Checked;
end;

end.
