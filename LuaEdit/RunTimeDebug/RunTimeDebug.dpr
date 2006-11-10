program RunTimeDebug;

uses
  Forms,
  RTDebugWin in 'RTDebugWin.pas' {RTDebugMainWin},
  RTDebugOptions in 'RTDebugOptions.pas' {FormOptions};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TRTDebugMainWin, RTDebugMainWin);
  Application.CreateForm(TFormOptions, FormOptions);
  Application.Run;
end.
