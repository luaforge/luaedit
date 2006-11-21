//******************************************************************************
//***                   COMMON DELPHI FUNCTIONS                              ***
//***                                                                        ***
//***        (c) Massimo Magnano 2004-2005                                   ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//  File        : CopyRoutines.pas
//
//  Description : functions for copy e delete Dirs
//
//******************************************************************************

unit CopyRoutines;

interface
uses Windows, SysUtils, Masks, Controls, FileVer, Dialogs;

const
    faOnlyFile  =$27;
    faAnyDir    =$1F;

    EXISTING_DONTCOPY        =0;
    EXISTING_IF_VER_GREATER  =1;     //Copy if New File have greater version
    EXISTING_IF_ASK          =2;
    EXISTING_OVERWRITE       =3;

type
    TCopyPathProgressRoutine =procedure (Data :Pointer;
                                         totalfiles,
                                         currentfile :Integer;
                                         FileName    :String;
                                         TotalFileSize,
                                         TotalBytesTransferred :LARGE_INTEGER;
                                         var cancelled :Boolean
                                         );

  TCopyProgressRoutine = function (
    TotalFileSize,	                        // total file size, in bytes
    TotalBytesTransferred,	                // total number of bytes transferred
    StreamSize,	                                // total number of bytes for this stream
    StreamBytesTransferred : LARGE_INTEGER;     // total number of bytes transferred for this stream
    dwStreamNumber,	                        // the current stream
    dwCallbackReason :DWord;	                // reason for callback
    hSourceFile,                         	// handle to the source file
    hDestinationFile :THandle;	                // handle to the destination file
    lpData :Pointer	                        // passed by CopyFileEx
   ) :DWord; stdcall;


procedure CopyPath(SourcePath, DestPath, wild :String;
                   OnExistingFile :Integer; Recursive :Boolean =True;
                   Data :Pointer=Nil; CopyProgressRoutine :TCopyPathProgressRoutine=Nil);
procedure CopyFile(SourceFile, DestPath:String; OnExistingFile :Integer; DestFileName :String='';
                   Data :Pointer=Nil; CopyProgressRoutine :TCopyPathProgressRoutine=Nil);


procedure DeleteDir(BaseDir:String; SelName :String; Recursive, RemoveDirs :Boolean);

function  AdjustPath(Path :String) :String;

implementation

type
    TCopyPathData =record
                    Data :Pointer;
                    FileName :String;
                    CopyProgressRoutine :TCopyPathProgressRoutine;
                    totalfiles,
                    currentfile   :Integer;
                    cancelled     :Boolean;
                    Check_Ask     :TModalResult;
                  end;



function internalProgress(
    TotalFileSize,	                        // total file size, in bytes
    TotalBytesTransferred,	                // total number of bytes transferred
    StreamSize,	                                // total number of bytes for this stream
    StreamBytesTransferred : LARGE_INTEGER;	// total number of bytes transferred for this stream
    dwStreamNumber,	                        // the current stream
    dwCallbackReason :DWord;	                // reason for callback
    hSourceFile,                         	// handle to the source file
    hDestinationFile :THandle;	                // handle to the destination file
    lpData :Pointer	                        // passed by CopyFileEx
   ) :DWord; stdcall;
var
   copyData :^TCopyPathData;

begin
     Result :=PROGRESS_CONTINUE;
     copyData :=lpData;
     if (copyData=Nil)
     then Exit;

     if assigned(copyData^.CopyProgressRoutine) then
     begin
          copyData^.CopyProgressRoutine(copyData^.Data,
                                        copyData^.totalfiles,
                                        copyData^.currentfile,
                                        copyData^.FileName,
                                        TotalFileSize, TotalBytesTransferred,
                                        copyData^.cancelled);
          if (copyData^.cancelled)
          then Result :=PROGRESS_CANCEL;
      end;
end;

function CheckExisting(SourceFileName, DestFileName :String;
                       OnExistingFile :Integer; var AskResult :TModalResult) :Boolean;
Var
   SVer,
   DVer,
   SLang,
   DLang,
   SInfo,
   DInfo   :String;
   FInfo   :TSearchRec;

   function Ask(MsgSource, MsgDest :String) :TModalResult;
   begin
        Result :=MessageDlg('Overwrite EXISTING File :'+#13#10#13#10+
                            DestFileName+#13#10+MsgDest+#13#10#13#10+
                            'With NEW File :'+#13#10#13#10+
                            SourceFileName+#13#10+MsgSource+#13#10#13#10,
                            mtConfirmation, mbYesAllNoAllCancel, 0);
   end;

begin
     if FileExists(DestFileName)
     then begin
               Result :=True;
               Case OnExistingFile of
               EXISTING_DONTCOPY        : Result :=False;
               EXISTING_IF_VER_GREATER  : begin
                                               SVer :=GetFileVerLang(SourceFileName, SLang);
                                               DVer :=GetFileVerLang(DestFileName, DLang);
                                               Result := (CompareVer(SVer, DVer)>=0);
                                          end;
               EXISTING_IF_ASK          : begin
                                               if AskResult=mrYesToAll
                                               then begin
                                                         Result :=True;
                                                         Exit;
                                                    end
                                               else
                                               if AskResult=mrNoToAll
                                               then begin
                                                         Result :=False;
                                                         Exit;
                                                    end;

                                               SVer :=GetFileVerLang(SourceFileName, SLang);
                                               DVer :=GetFileVerLang(DestFileName, DLang);

                                               FindFirst(SourceFilename, faAnyFile,
                                                         FInfo);
                                               SInfo :=' Version '+SVer+' Lang '+SLang+#13#10+
                                                  ' Date '+DateTimeToStr(FileDateToDateTime(FInfo.Time))+#13#10+
                                                  ' Size '+IntToStr(FInfo.Size)+#13#10;
                                               FindClose(FInfo);
                                               FindFirst(DestFilename, faAnyFile,
                                                         FInfo);
                                               DInfo :=' Version '+DVer+' Lang '+DLang+#13#10+
                                                  ' Date '+DateTimeToStr(FileDateToDateTime(FInfo.Time))+#13#10+
                                                  ' Size '+IntToStr(FInfo.Size)+#13#10;
                                               FindClose(FInfo);
                                               AskResult :=Ask(SInfo, DInfo);
                                               Result := (AskResult in [mrYes, mrYesToAll]);
                                          end;
               EXISTING_OVERWRITE        : Result :=True;
               end;
          end
     else Result :=True;
end;

procedure CopyPath(SourcePath, DestPath, wild :String;
                   OnExistingFile :Integer; Recursive :Boolean =True;
                   Data :Pointer=Nil; CopyProgressRoutine :TCopyPathProgressRoutine=Nil);
var
   xSourcePath,
   xDestPath     :String;
   myData        :TCopyPathData;
   int0          :LARGE_INTEGER;
   CanCopy       :Boolean;


   procedure copyDir(rSource, rDest, wild :String);
   Var
      fileInfo :TSearchRec;
      Error :Integer;

   begin
        ForceDirectories(rDest);
        //find first non entra nelle sotto dir se non è *.*
        // non posso fare (*.*, faDirectory) perchè mi prende anche i file
        // Questa si che è un mostro di API...
        Error := FindFirst(rSource+'*.*', faAnyFile, FileInfo); //+wild

        While (Error=0) Do
        begin
          if (FileInfo.Name[1] <> '.') then //non è [.] o [..]
          begin
               if ((FileInfo.Attr and faDirectory) = faDirectory)
               then begin
                         if Recursive
                         then copyDir(rSource+FileInfo.Name+'\',
                                      rDest+FileInfo.Name+'\', wild);
                    end
               else if MatchesMask(FileInfo.Name, wild) then
                    begin
                         myData.FileName :=rSource+FileInfo.Name;
                         inc(myData.currentfile);

                         CanCopy :=CheckExisting(myData.FileName, rDest+FileInfo.Name,
                                                 OnExistingFile, myData.Check_Ask);
                         myData.cancelled := myData.cancelled or
                                             (myData.Check_Ask = mrCancel);

                         if CanCopy
                         then CopyFileEx(PChar(myData.FileName),
                                         PChar(rDest+FileInfo.Name),
                                         @internalProgress, @myData, Nil,
                                         COPY_FILE_RESTARTABLE);
                    end;

           end;
          Error :=FindNext(FileInfo);
        end;
        FindClose(FileInfo);
    end;

   procedure countDir(rSource, rDest, wild :String);
   Var
      fileInfo :TSearchRec;
      Error :Integer;

   begin
        Error := FindFirst(rSource+'*.*', faAnyFile, FileInfo);
        While (Error=0) Do
        begin
          if (FileInfo.Name[1] <> '.') then //non è [.] o [..]
          begin
               if ((FileInfo.Attr and faDirectory) = faDirectory)
               then begin
                         if Recursive
                         then countDir(rSource+FileInfo.Name+'\',
                                       rDest+FileInfo.Name+'\', wild);
                    end
               else if MatchesMask(FileInfo.Name, wild)
                    then inc(myData.totalfiles);

           end;
          Error :=FindNext(FileInfo);
        end;
        FindClose(FileInfo);
    end;

begin
     xSourcePath :=AdjustPath(SourcePath);
     xDestPath :=AdjustPath(DestPath);

     myData.totalfiles :=0;
     myData.currentfile :=0;
     myData.cancelled :=False;
     myData.Data :=Data;
     myData.CopyProgressRoutine :=CopyProgressRoutine;
     myData.Check_Ask :=mrNone;

     if assigned(CopyProgressRoutine) then
     begin
          int0.QuadPart :=0;
          CopyProgressRoutine(Data, 0, 0,
                              'Preparing for Copy...', int0, int0, myData.Cancelled);
          countDir(xSourcePath, xDestPath, wild);
          CopyProgressRoutine(Data, myData.totalfiles, 0,
                              'Starting Copy...', int0, int0, myData.Cancelled);
      end;

     copyDir(xSourcePath, xDestPath, wild);
     if assigned(CopyProgressRoutine)
     then CopyProgressRoutine(Data, myData.totalfiles, 0,
                              'Copy completed...', int0, int0, myData.Cancelled);
end;

procedure CopyFile(SourceFile, DestPath :String; OnExistingFile :Integer; DestFileName :String='';
                   Data :Pointer=Nil; CopyProgressRoutine :TCopyPathProgressRoutine=Nil);
var
   xDestPath,
   xDestFileName :String;
   myData        :TCopyPathData;
   int0          :LARGE_INTEGER;

begin
     xDestPath :=AdjustPath(DestPath);

     if (DestFileName='')
     then xDestFileName :=ExtractFilename(SourceFile)
     else xDestFileName :=ExtractFilename(DestFileName);

     myData.totalfiles :=1;
     myData.currentfile :=0;
     myData.cancelled :=False;
     myData.Data :=Data;
     myData.CopyProgressRoutine :=CopyProgressRoutine;
     myData.Check_Ask :=mrNone;

     if assigned(CopyProgressRoutine) then
     begin
          int0.QuadPart :=0;
          CopyProgressRoutine(Data, myData.totalfiles, 0,
                              'Starting Copy...', int0, int0, myData.Cancelled);
     end;
     myData.FileName :=SourceFile;
     myData.currentfile :=1;
     if ForceDirectories(xDestPath)
     then begin
               if (CheckExisting(SourceFile, xDestPath+xDestFileName, OnExistingFile,
                                myData.Check_Ask))
               then CopyFileEx(PChar(SourceFile),
                          PChar(xDestPath+xDestFileName),
                          @internalProgress, @myData, Nil,
                          COPY_FILE_RESTARTABLE);

               if assigned(CopyProgressRoutine)
               then CopyProgressRoutine(Data, myData.totalfiles, 0,
                              'Copy completed...', int0, int0, myData.Cancelled);
          end
     else raise Exception.Create('Cannot copy Files on '+xDestPath);
end;

procedure DeleteDir(BaseDir:String; SelName :String; Recursive, RemoveDirs :Boolean);

   procedure _DeleteDir(BaseDir:String; SelName :String; Recursive, RemoveDirs :Boolean);
   Var
      SFile,
      SDir  :TSearchRec;
      Error :Integer;

   begin
     //Display('Deleting Dir '+BaseDir+'\'+SelName);
     if (BaseDir[Length(BaseDir)]<>'\')
     then BaseDir := BaseDir + '\';

     Error :=FindFirst(BaseDir+Selname, faOnlyFile, Sfile);
     While (Error=0) Do
     begin
          if (SFile.Name[1]<>'.') and
             not(Sfile.Attr in[faDirectory..faAnyDir])
          then DeleteFile(BaseDir+SFile.Name);

          Error :=FindNext(SFile);
     end;
     FindClose(SFile);
     if Recursive then
     begin
          Error :=FindFirst(BaseDir+'*.*', faAnyDir, SDir);
          While (Error=0) Do
          begin
               if (SDir.Name[1]<>'.') and
                  (SDir.Attr in[faDirectory..faAnyDir])
               then begin
                         DeleteDir(BaseDir+Sdir.Name, SelName, Recursive, RemoveDirs);
                         if RemoveDirs
                         then RemoveDirectory(PChar(BaseDir+Sdir.Name));
                    end;

               Error :=FindNext(SDir);
           end;
          FindClose(SDir);
      end;
   end;

begin
     _DeleteDir(BaseDir, SelName, Recursive, RemoveDirs);
     if RemoveDirs
     then RemoveDirectory(PChar(BaseDir));
end;

function AdjustPath(Path :String) :String;
begin
     if Path[Length(Path)]<>'\'
     then Result :=Path+'\'
     else Result :=Path;
end;

end.
