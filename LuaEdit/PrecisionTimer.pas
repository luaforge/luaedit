unit PrecisionTimer;

interface

uses
  Windows, Classes, SysUtils;

type
  // Precision timer class declaration
  TPrecisionTimer = class
    OverheadTime: Int64;
    InitFreq: Int64;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
    function GetCurrentTime(var lpPerformanceCount: Int64): Extended;
    function GetFrequency(): Int64;
    function GetPerformanceOverhead(): Int64;
  end;

implementation

// Initialize the timer
procedure TPrecisionTimer.Init;
var
  lpStart: Int64;
  lpEnd: Int64;
begin
  // Calculate process overhead
  QueryPerformanceCounter(lpStart);
  QueryPerformanceCounter(lpEnd);
  OverheadTime := lpEnd - lpStart;

  // Get initial frequency
  QueryPerformanceFrequency(InitFreq);
end;

function TPrecisionTimer.GetCurrentTime(var lpPerformanceCount: Int64): Extended;
begin
  QueryPerformanceCounter(lpPerformanceCount);
  lpPerformanceCount := lpPerformanceCount - GetPerformanceOverhead();
end;

function TPrecisionTimer.GetFrequency(): Int64;
begin
  Result := InitFreq;
end;

function TPrecisionTimer.GetPerformanceOverhead(): Int64;
begin
  Result := OverheadTime;
end;

end.
 