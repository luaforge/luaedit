unit FileVer;

interface
Uses Windows, SysUtils, Classes, Dialogs, Controls, FileCtrl;

function GetFileVerLang(FileName :String; var Lang :String) :String;

// Return :    -1 Version1 < Version2
//              0 Version1 = Version2
//             +1 Version1 > Version2
function CompareVer(Version1, Version2 :String) :Integer;
function InstallFile(FilesList :TStringList;
                     SourceDir, DestDir, SourceFile :String) :Boolean;

implementation

Type
    TL_DWord =packed record
                 Hi :Word;
                 Lo :Word;
              end;
    PL_DWord =^TL_DWord;

function GetFileVerLang(FileName :String; var Lang :String) :String;
Var
   viResult     :DWord;
   verSize      :Integer;
   verBuff,
   verResult    :Pointer;
   verLang      :PL_DWord;
   verLangStr   :String;

begin
     Result  :='?';
     Lang :='?';
     verBuff :=Nil;
     verResult :=Nil;
     try
        verSize :=GetFileVersionInfoSize(PChar(FileName), viResult);
        if (verSize>0) then
        begin
             GetMem(verBuff, verSize+2);

             GetFileVersionInfo(PChar(FileName), 0, verSize, verBuff);
             VerQueryValue(verBuff, PChar('\VarFileInfo\Translation'),
                      Pointer(verLang), viResult);
             verLangStr :=IntToHex(verLang^.Hi, 4)+IntToHex(verLang^.Lo, 4);
             SetLength(Lang, MAX_PATH);
             VerLanguageName(DWord(verLang^), PChar(Lang), MAX_PATH);
             Lang :=PChar(Lang);

             VerQueryValue(verBuff, PChar('\StringFileInfo\'+verLangStr+'\FileVersion'),
                      verResult, viResult);
             Result :=PChar(verResult);
        end;
     finally
        if (verBuff<>Nil) then FreeMem(verBuff);
     end;
end;

function CompareVer(Version1, Version2 :String) :Integer;
Var
   ver1, ver2 :String;
   pos1, pos2 :Integer;
   last       :Boolean;

begin
     last :=False;
     repeat
           pos1 :=Pos('.', Version1);
           pos2 :=Pos('.', Version2);
           if (pos1>1)
           then begin
                     ver1 :=Copy(Version1, 1, pos1-1);
                     Delete(Version1, 1, pos1);
                end
           else begin
                     ver1 :=Version1;
                     Version1 :='';
                     last :=True;
                end;
           if (pos2>1)
           then begin
                     ver2 :=Copy(Version2, 1, pos2-1);
                     Delete(Version2, 1, pos2);
                end
           else begin
                     ver2 :=Version2;
                     Version2 :='';
                     last :=True;
                end;
           if (ver1<ver2)
           then Result := -1
           else begin
                     if (ver1=ver2)
                     then begin
                                Result := 0;
                                if last then
                                begin
                                     if (Version1<>'')
                                     then Result := 1  //esempio : 1.0.x è maggiore di 1.0
                                     else  if (Version2<>'')
                                           then Result := -1;
                                end;
                           end
                     else Result := 1;
                end;
     Until (Result<>0) or last;
end;

function InstallFile(FilesList :TStringList;
                     SourceDir, DestDir, SourceFile :String) :Boolean;
Var
   Ver1,
   Ver2,
   Lang1,
   Lang2        :String;


begin
     Result :=True;

(*   Ma cumu mai nun funziona................?
     M'a 'e fari sempri a manu????

    viResult :=VerInstallFile(0,
                           PChar(SourceFile), PChar(SourceFile),
                           PChar(SourceDir), PChar(DestDir),
                           PChar(viPrevFile), PChar(viTempFile), viSizeTemp);

     Result :=Not((viResult and VIF_SRCOLD<>0) or
                  (viResult and VIF_DIFFLANG<>0) or
                  (viResult and VIF_DIFFCODEPG<>0));
     if Not(Result) then
*)
     if FileExists(DestDir+SourceFile) then
     begin
          Ver1  :=GetFileVerLang(DestDir+SourceFile, Lang1);
          Ver2  :=GetFileVerLang(SourceDir+SourceFile, Lang2);

          Result :=(MessageDlg('Overwrite File '+DestDir+SourceFile+#13#10+
                         '     Version= '+Ver1+' Language= '+Lang1+#13#10+
                         'With Version= '+Ver2+' Language= '+Lang2+#13#10, mtConfirmation, [mbYes, mbNo], 0)
                  =mrYes);
     end;
     if Result then
     begin
          ForceDirectories(ExtractFilePath(DestDir+SourceFile));
          Result :=CopyFile(PChar(SourceDir+SourceFile),
                            PChar(DestDir+SourceFile), False);
          if (FilesList<>Nil) then FilesList.Add(DestDir+SourceFile);
      end;
end;


end.
 