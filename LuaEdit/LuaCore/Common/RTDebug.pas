unit RTDebug;

interface
Uses Windows, Messages, SysUtils, Classes, MGRegistry;

Const
     MG_RTD_AddReference  =WM_USER+12123;
     MG_RTD_DelReference  =MG_RTD_AddReference+1;
     MG_RTD_GetListHandle =MG_RTD_AddReference+2;

     REG_KEY              ='\Software\MaxM_BeppeG\RTDebug\';
     REG_LOGFILE          ='Log File';
     REG_LOGONFILE        ='Log File Enabled';

type
    TRTDebugParameters =record
                       processID,
                       threadID  :DWord;
                       Level     :Byte;
                       theString :ShortString;
                       StrColor  :DWord;
                 end;
var
   LogFileName :String  ='';
   LogOnFile   :Boolean =False;

function RTAssert(Level :Byte; Condition :Boolean; TrueStr, FalseStr :ShortString;
                  StrColor :DWord=0) :Boolean; overload;
function RTAssert(TrueStr :ShortString; StrColor :DWord=0) :Boolean; overload;
function RTAssert(Condition :Boolean; TrueStr, FalseStr :ShortString; StrColor :DWord=0) :Boolean; overload;
function RTAssert(Condition :Boolean; TrueStr :ShortString; StrColor :DWord=0) :Boolean; overload;

function RTFileAssert(Filename :ShortString; Condition :Boolean; TrueStr, FalseStr :ShortString) :Boolean;
function RTFileEmpty(Filename :ShortString) :Boolean;
function GetLogFileName :String;

implementation

procedure AddLineToList(Level :Byte; theString :ShortString; StrColor :DWord);
Var
   pCopyData  :TCopyDataStruct;
   WinHandle  :HWnd;

begin
     WinHandle :=FindWindow('TRTDebugMainWin', Nil);
     if IsWindow(WinHandle) then
     begin
          pCopyData.cbData :=SizeOf(TRTDebugParameters);
          GetMem(pCopyData.lpData, SizeOf(TRTDebugParameters));

          TRTDebugParameters(pCopyData.lpData^).processID :=GetCurrentProcessID;
          TRTDebugParameters(pCopyData.lpData^).ThreadID :=GetCurrentThreadID;
          TRTDebugParameters(pCopyData.lpData^).Level :=Level;
          TRTDebugParameters(pCopyData.lpData^).theString :=theString;
          TRTDebugParameters(pCopyData.lpData^).StrColor :=StrColor;

          SendMessage(WinHandle, WM_COPYDATA, 0, Integer(@pCopyData));
          FreeMem(pCopyData.lpData);
     end;

end;

function RTAssert(Level :Byte; Condition :Boolean; TrueStr, FalseStr :ShortString;
                  StrColor :DWord) :Boolean;
begin
     Result :=Condition;
     if Result then AddLineToList(Level, TrueStr, StrColor)
               else AddLineToList(Level, FalseStr, StrColor);

     if (LogOnFile) and (LogFilename <> '')
     then RTFileAssert(LogFilename, Condition, TrueStr, FalseStr);
end;

function RTAssert(TrueStr :ShortString; StrColor :DWord=0) :Boolean;
begin
     Result :=RTAssert(0, true, TrueStr, '', StrColor);
end;

function RTAssert(Condition :Boolean; TrueStr, FalseStr :ShortString; StrColor :DWord=0) :Boolean;
begin
     Result :=RTAssert(0, Condition, TrueStr, FalseStr, StrColor);
end;

function RTAssert(Condition :Boolean; TrueStr :ShortString; StrColor :DWord=0) :Boolean;
begin
     if Condition
     then Result :=RTAssert(0, true, TrueStr, '', StrColor)
     else Result :=False; 
end;

function RTFileAssert(Filename :ShortString; Condition :Boolean; TrueStr, FalseStr :ShortString) :Boolean;
Var
   ToWrite :PChar;
   theFile :TFileStream;

begin
     if FileExists(FileName) then theFile :=TFileStream.Create(FileName, fmOpenWrite)
                             else theFile :=TFileStream.Create(FileName, fmCreate);
     try
        Result :=False;
        theFile.Seek(0, soFromEnd);
        if Condition
        then ToWrite :=PChar(IntToHex(GetCurrentProcessID,8)+' '+
                             IntToHex(GetCurrentThreadID,8)+' '+
                             TrueStr+#13#10)
        else ToWrite :=PChar(IntToHex(GetCurrentProcessID,8)+' '+
                             IntToHex(GetCurrentThreadID,8)+' '+
                             FalseStr+#13#10);
        theFile.Write(ToWrite^, Length(ToWrite));
        Result :=True;
     finally
        theFile.Free;
     end;
end;


function RTFileEmpty(Filename :ShortString) :Boolean;
Var
   theFile :TFileStream;

begin
     theFile :=TFileStream.Create(FileName, fmCreate);
     try
        Result :=False;
        theFile.Size :=0;
        Result :=True;
     finally
        theFile.Free;
     end;
end;

function GetLogFileName :String;
Var
   xReg :TMGRegistry;

begin
     xReg :=TMGRegistry.Create;
     if xReg.OpenKeyReadOnly(REG_KEY)
     then begin
               Result :=xReg.ReadString('', true, REG_LOGFILE);
               LogOnFile :=xReg.ReadBool(False, REG_LOGONFILE);
          end

     else begin
               Result :='';
               LogOnFile :=False;
          end;
     xReg.Free;
end;

initialization
   LogFileName :=GetLogFileName;

end.
