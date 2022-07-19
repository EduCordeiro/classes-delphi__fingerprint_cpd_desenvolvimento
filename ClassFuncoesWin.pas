Unit ClassFuncoesWin;

interface

  uses Windows, Classes, Dialogs, SysUtils, Forms, Controls, Graphics, WinSock, ShellAPI,
  math,
  StdCtrls, ComCtrls, udatatypes_apps, ClassLog, TLHelp32, Printers;

  type

    TFuncoesWin= Class
      private
        objLogar : TArquivoDelog;

      public
        procedure ObterListaDeArquivosDeUmDiretorio(Path: string; var ListagemDeArquivos : TStringList; extensao: string='*.*');
        procedure ObterListaDeArquivosDeUmDiretorioV2(const RootDir:string; var ListagemDeArquivos : TStringList; extensao: string='*.*'; FILTRO:STRING='');
        procedure ObterListaDeDiretorios(const RootDir:string; var ListagemDeArquivos : TStringList; FILTRO: STRING='');
        function IsArquivoVazio(const FileName: String): Boolean;
        function GetArquivos(Mascara, Path: string): RInfoArquivo;
        function GetTamanhoArquivo(const FileName: String): double;
        function GetItemArquivoOuDiretorio(fullpath: string): string;
        function GetTamanhoArquivo_WinAPI(FileName : String): int64;
        function GetTamanhoMaiorUnidade(Bytes: int64): String;
        function Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;
        function GetVersaoDaAplicacao: string;
        function GetIP(): string;
        procedure  DelTree(Diretorio: string);
        procedure DelFile(Arquivo: string);
        function ExecutarPrograma(cmd: string; esconderJanela: boolean=true; passarControleparaAplicacao: boolean=true): boolean;
        procedure ExecutarArquivoComProgramaDefault(Arquivo: String);
        function GetTrimestreFromData(data: string): string;
        Function RetornaNivel(Diretorio : String; nDiretorios : Integer): String;
        function WinExecAndWait32(FileName: string; Visibility: Integer=0): Longword;
        procedure ObterListaDeArquivoRecursivamente(const RootDir:string; var ListagemDeArquivos : TStringList);
        procedure ObterListaDePathDoDiretorio(const RootDir:string; var ListagemDeArquivos : TStringList; extensao: string='*.*');
        Function DataPorExtenso:String;
        procedure DeletarArquivosPorFiltro(path: string; filtro: string);
        function CopiarArquivo(source,dest: String): Boolean;

        procedure GetListaDeArquivosEmOrdemAlfabetica(path : String; var listaArquivos : TStringList; filtro : String);
        function  NumeroDeLinhasDoArquivo(sLocalDoArquivo : string; sNomeDoArquivo : string; sTipoDoRegistro  :string = ''; iPos : Integer = 0; iTam : Integer = 0) : Integer;
        function IsRunningProcess(ExeFileName : string) : Boolean;
        Function FileIsOpen(const FileName : TFileName) : Boolean;
        function AplicacaoEstaAberta(NomeAPP: PChar): Boolean;

        function GetFileDate(Arquivo: String; MASCARA: String='YYYY-MMDD'): String;

        function GetUsuarioLogado(): String;

        procedure PrintFile(aFile : TFileName);

        //============================
        //  NOME DA MÁQUINA NA REDE
        //============================
        function GetNetHostName: String;
        //============================

        constructor create(Var objLogar: TArquivoDelog);

    end;

implementation

constructor TFuncoesWin.create(Var objLogar: TArquivoDelog);
begin
  objLogar := objLogar;
end;

procedure TFuncoesWin.ObterListaDeArquivosDeUmDiretorio(Path: string; var ListagemDeArquivos : TStringList; extensao: string='*.*');
var
 SR: TSearchRec;
 ret: Integer;
 PathTemp: string;
begin
  (*
   CRIADA POR: Eduardo Cordeiro M. Monteiro

   OBJETIVO:
     - Esta função possui o objetivo de obter a listagem de arquivos de um
       diretório específico
  *)

  if extensao = '' then
    extensao:= '*.*';

  if Path = '' then
    Path:= '.';

  PathTemp:= StringReplace(Path, '/', '\', [rfReplaceAll, rfIgnoreCase]);
  if length(PathTemp) > 0 then
    if Path[length(PathTemp)] <> PathDelim then
      Path :=  PathTemp + PathDelim;

  ret := FindFirst(Path + extensao, faAnyFile, SR);
  if ret = 0 then
  try
    repeat
      if (SR.Attr <> 0) and (faAnyFile <> 0) and (SR.Name <> '.') and ( SR.Name <> '..') then
        if FileExists(Path + SR.Name) then
          ListagemDeArquivos.Add(SR.Name);
      ret := FindNext( SR );
    until ret <> 0;
  finally
    FindClose(SR)
  end;
end;

function TFuncoesWin.GetArquivos(Mascara, Path: string): RInfoArquivo;
var
  SearchRec : TSearchRec;
  intControl : integer;
  InfoArquivo: RInfoArquivo;
  dTamanhoArquivo: double;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  Path := Path + '\';

  if DirectoryExists(Path) then
  begin
    intControl := FindFirst( Path+Mascara, faAnyFile, SearchRec );
    if intControl = 0 then
    begin
      while (intControl = 0) do
      begin
        if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
        begin
          SetLength(InfoArquivo.Nome,length(InfoArquivo.Nome)+1);
          SetLength(InfoArquivo.Tamanho,length(InfoArquivo.Tamanho)+1);
          SetLength(InfoArquivo.Path,length(InfoArquivo.Path)+1);

          //tamanho em KB
          dTamanhoArquivo := GetTamanhoArquivo(Path+SearchRec.Name);

          InfoArquivo.Nome[length(InfoArquivo.Nome)-1] := SearchRec.Name;
          InfoArquivo.Path[length(InfoArquivo.Path)-1] := Path;
          InfoArquivo.Tamanho[length(InfoArquivo.Tamanho)-1] := dTamanhoArquivo;
        end;
        intControl := FindNext( SearchRec );
      end;
      FindClose(SearchRec);
    end;
  end;

  result := InfoArquivo;
end;

function TFuncoesWin.GetTamanhoArquivo(const FileName: String): double;
var
  SearchRec : TSearchRec;
begin { !Win32! -> GetFileSize }

  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - Retorna o tamanho de um arquivo em KB (/1024)

  *)

  if FindFirst(FileName,faAnyFile,SearchRec)=0 then
    Result:=round(SearchRec.Size/1024)
  else
    Result:=0;
  FindClose(SearchRec);
end;

function TFuncoesWin.GetItemArquivoOuDiretorio(fullpath: string): string;
var
  sTipo: string;
  sFileName: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  sTipo := '?';

  sFileName := ExtractFileName(fullpath);

  if (sFileName = '.') then
    sTipo := 'ponteiro_diretorio_atual'
  else
  if (sFileName = '..') then
    sTipo := 'ponteiro_diretorio_anterior'
  else
  begin
    if DirectoryExists(fullpath) then
      sTipo := 'diretorio'
    else
      sTipo := 'arquivo';
  end;

  result := sTipo;
end;

function TFuncoesWin.GetTamanhoArquivo_WinAPI(FileName : String): int64;
var
  SearchRec : TSearchRec;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  if FindFirst(FileName, faAnyFile, SearchRec ) = 0 then
    Result := Int64(SearchRec.FindData.nFileSizeHigh) shl Int64(32)
              +Int64(SearchREc.FindData.nFileSizeLow)
  else
    Result := 0;

  FindClose(SearchRec);
end;

function TFuncoesWin.GetTamanhoMaiorUnidade(Bytes: int64): String;
var
  dTamanho: double;
  sBytes: string;
  iTamanho: integer;
  iPower: integer;
  sUnidade: string;
//  rrFile: RFile;
  iParDiv: variant;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

//  rrFile.Tamanho := 0;
//  rrFile.Unidade := '';

  iTamanho := 0;
  sUnidade := '';

  sBytes := inttostr(Bytes);
  iTamanho := length(sBytes);

  case iTamanho of
    4..6:
      begin
        sUnidade := 'KB';
        iPower:= 1;
      end;
    7..9:
      begin
        sUnidade := 'MB';
        iPower := 2;
      end;
    10..12:
      begin
        sUnidade := 'GB';
        iPower := 3;
      end;
    13..15:
      begin
        sUnidade := 'TB';
        iPower := 4;
      end;
  end;

  if iTamanho >= 4 then
  begin
    iParDiv  := power(1024,iPower);
    dTamanho := Bytes / iParDiv;
  end
  else
  begin
    dTamanho := Bytes;
    sUnidade := 'Bytes';
  end;

//  rrFile.Tamanho := dTamanho;
//  rrFile.Unidade := sUnidade;

//  rrFile.Tamanho := arredondar(dTamanho,2);

  dTamanho := Arredondar(dTamanho, 2);

  result := floattostr(dTamanho) + ' ' + sUnidade;

end;

function TFuncoesWin.Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;
var
  Valor1, Numero1, Numero2, Numero3: Double;
  bJahArredondou: boolean;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  Valor1:=Exp(Ln(10) * (Dec + 1));
  Numero1:=Int(Valor * Valor1);
  Numero2:=(Numero1 / 10);

  Numero3:=Round(Numero2);

  if Numero3 <= trunc(Valor) then
  begin
    //Arredondamento opcional para cima quando não tiver casas decimais após a vírgula
    if (Dec=0) and (ParaCima) then
      Numero3 := Numero3 + 1;
  end;

  Result:=(Numero3 / (Exp(Ln(10) * Dec)));
end;

function TFuncoesWin.GetVersaoDaAplicacao: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1, V2, V3, V4: Word;
  sV1, sV2, sV3, sV4: string;
  Prog, sVersao : string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBS.:
    - Para que funcione corretamente é necessário que a versão da aplicação
      seja informada em Project => Options => Version Info,
      campo "Module Version Number".

  *)

   sVersao := '';

   Prog := Application.Exename;
   VerInfoSize := GetFileVersionInfoSize(PChar(prog), Dummy);
   GetMem(VerInfo, VerInfoSize);
   GetFileVersionInfo(PChar(prog), 0, VerInfoSize, VerInfo);
   VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
   with VerValue^ do
   begin
     V1 := dwFileVersionMS shr 16;
     V2 := dwFileVersionMS and $FFFF;
     V3 := dwFileVersionLS shr 16;
     V4 := dwFileVersionLS and $FFFF;
   end;
   FreeMem(VerInfo, VerInfoSize);

   {
   sV1 := Copy (IntToStr (100 + v1), 3, 2);
   sV2 := Copy (IntToStr (100 + v2), 3, 2);
   sV3 := Copy (IntToStr (100 + v3), 3, 2);
   sV4 := Copy (IntToStr (100 + v4), 3, 2);
   }
   sV1 := IntToStr(v1);
   sV2 := IntToStr(v2);
   sV3 := IntToStr(v3);
   sV4 := IntToStr(v4);

   sVersao := sV1 + '.' + sV2 + '.' + sV3 + '.' + sV4;

   Result := sVersao;
end;

function TFuncoesWin.GetIP(): string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));

  with HostEnt^ do
  begin
    Result := Format('%d.%d.%d.%d',
    [Byte(h_addr^[0]),Byte(h_addr^[1]),
    Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;

  WSACleanup;
end;

procedure TFuncoesWin.DelTree(Diretorio: string);
var
  sComandoDelDir: string;
  sPathFormatado: string;
begin
  {apaga um diretório, os arquivos e subdiretórios contidos nele}
  if DirectoryExists(Diretorio) then
  begin
    sComandoDelDir := 'CMD /C RMDIR /Q /S "'+Diretorio+'"';
    ExecutarPrograma(sComandoDelDir,true,true);
  end;
end;

procedure TFuncoesWin.DelFile(Arquivo: string);
var
  sComandoDelDir: string;
  sPathFormatado: string;
begin
  {apaga um diretório, os arquivos e subdiretórios contidos nele}
  if FileExists(Arquivo) then
  begin
    sComandoDelDir := 'CMD /C del "'+Arquivo+'"';
    ExecutarPrograma(sComandoDelDir,true,true);
  end;
end;

function TFuncoesWin.ExecutarPrograma(cmd: string; esconderJanela: boolean=True;
 passarControleparaAplicacao: boolean=True): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  {Com o parâmetro "passarControleparaAplicacao" ativado, o programa
   que está chamando essa função interromperá a sua execução até que
   o programa passado como parâmetro aqui seja encerrado.}

  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb      := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;


  if esconderJanela then
    SUInfo.wShowWindow := SW_HIDE
  else
    SUInfo.wShowWindow := SW_NORMAL;

  Result := CreateProcess(nil,
                          PChar(cmd),
                          nil,
                          nil,
                          false,
                          CREATE_NEW_CONSOLE or
                          NORMAL_PRIORITY_CLASS,
                          nil,
                          nil,
                          SUInfo,
                          ProcInfo);

  if (Result) then
  begin
    if passarControleparaAplicacao then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);

    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

procedure TFuncoesWin.ExecutarArquivoComProgramaDefault(Arquivo: String);
Var
 Nome: Array[0..1024] of Char;
 Parms: Array[0..1024] of Char;
begin
  StrPCopy (Nome, 'Open');
  StrPCopy (Parms, Arquivo);

  ShellExecute(0, Nome, Parms, nil, nil, SW_NORMAL);
end;

function TFuncoesWin.GetTrimestreFromData(data: string): string;
var
  iTrimestre: integer;
  wDia      : Word;
  wMes      : Word;
  wAno      : Word;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - Retorna o trimestre na forma <numero_trimestre>/<ano>.
      Ex.: 01/2010, 02/2010, 03/2010, 04/2010.

  *)

  DecodeDate(StrToDate(data), wAno, wMes, wDia);

  case wMes of
    1..3:   iTrimestre := 1;
    4..6:   iTrimestre := 2;
    7..9:   iTrimestre := 3;
    10..12: iTrimestre := 4;
  end;

  result := formatfloat('00', iTrimestre)+'/'+formatfloat('0000', wAno);
end;

Function TFuncoesWin.RetornaNivel(Diretorio : String; nDiretorios : Integer): String;
var
 iCont : Integer;
 dir                       : string;
 iUltimaPosicaoDelimitador : integer;
Begin
  //Retona um nível
  for iCont := 0 to nDiretorios - 1 do
  begin
    iUltimaPosicaoDelimitador := LastDelimiter('\', Diretorio);
    dir := Diretorio;
    delete(dir, iUltimaPosicaoDelimitador, length(dir));
    iUltimaPosicaoDelimitador := LastDelimiter('\', dir) + 1;
    delete(dir, iUltimaPosicaoDelimitador, length(dir));
    Diretorio := Dir;
  end;
  result := Dir;
end;


procedure TFuncoesWin.ObterListaDeDiretorios(const RootDir:string; var ListagemDeArquivos : TStringList; FILTRO: STRING='');
var
SearchRec: tSearchREC;
Erc:Integer;
sPath : string;
Begin
  try

    sPath:= StringReplace(RootDir, '/', '\', [rfReplaceAll, rfIgnoreCase]);
    if length(sPath) > 0 then
      if sPath[length(sPath)] <> PathDelim then
        sPath :=  sPath + PathDelim;

    {$I-}
    ChDir(sPath);
    if IOResult <> 0 then
      Exit;

    FindFirst('*.*', faAnyFile, SearchRec);
    Erc:=0;
    while Erc=0 do
    begin

      if ((searchRec.Name <> '.') and (searchrec.Name<>'..')) then
        if not (SearchRec.Attr and faDirectory <= 0) then
        Begin

          if Trim(FILTRO) = '' then
            ListagemDeArquivos.Add(Searchrec.Name)
          else
            if pos(AnsiUpperCase(Trim(FILTRO)), AnsiUpperCase(Searchrec.Name)) > 0 then
              ListagemDeArquivos.Add(Searchrec.Name)

        end;

      Erc:=FindNext (SearchRec);

     // Application.ProcessMessages;

    end;
    FindClose(SearchRec);

  finally
    If Length (sPath)>3 then
      Chdir('..');
  end;
  {$I+}
End;

procedure TFuncoesWin.ObterListaDeArquivosDeUmDiretorioV2(const RootDir:string; var ListagemDeArquivos : TStringList; extensao: string='*.*'; FILTRO: STRING='');
var
SearchRec: tSearchREC;
Erc:Integer;
sPath : string;
Begin
  try

    sPath:= StringReplace(RootDir, '/', '\', [rfReplaceAll, rfIgnoreCase]);
    if length(sPath) > 0 then
      if sPath[length(sPath)] <> PathDelim then
        sPath :=  sPath + PathDelim;

    {$I-}
    ChDir(sPath);
    if IOResult <> 0 then
      Exit;

    FindFirst(extensao, faAnyFile, SearchRec);
    Erc:=0;
    while Erc=0 do
    begin

      if ((searchRec.Name <> '.') and (searchrec.Name<>'..')) then
        if not (SearchRec.Attr and faDirectory > 0) then
        Begin

          if Trim(FILTRO) = '' then
            ListagemDeArquivos.Add(Searchrec.Name)
          else
            if pos(AnsiUpperCase(Trim(FILTRO)), AnsiUpperCase(Searchrec.Name)) > 0 then
              ListagemDeArquivos.Add(Searchrec.Name)

        end;

      Erc:=FindNext (SearchRec);

     // Application.ProcessMessages;

    end;
    FindClose(SearchRec);

  finally
    If Length (sPath)>3 then
      Chdir('..');
  end;
  {$I+}
End;

function TFuncoesWin.WinExecAndWait32(FileName: string; Visibility: Integer=0): Longword;
var { by Pat Ritchey }
  zAppName: array[0..512] of Char;
  zCurDir: array[0..255] of Char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, SizeOf(StartupInfo), #0);
  StartupInfo.cb          := SizeOf(StartupInfo);
  StartupInfo.dwFlags     := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, // pointer to command line string
    nil, // pointer to process security attributes
    nil, // pointer to thread security attributes
    False, // handle inheritance flag
    CREATE_NEW_CONSOLE or // creation flags
    NORMAL_PRIORITY_CLASS,
    nil, //pointer to new environment block
    nil, // pointer to current directory name
    StartupInfo, // pointer to STARTUPINFO
    ProcessInfo) // pointer to PROCESS_INF
  then
    Result := WAIT_FAILED
  else
  begin
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end; { WinExecAndWait32 }

procedure TFuncoesWin.ObterListaDeArquivoRecursivamente(const RootDir:string; var ListagemDeArquivos : TStringList);
var
SearchRec: tSearchREC;
Erc:Integer;
PathTemp : string;
Begin
  try

    PathTemp:= StringReplace(RootDir, '/', '\', [rfReplaceAll, rfIgnoreCase]);
    if length(PathTemp) > 0 then
      if PathTemp[length(PathTemp)] <> PathDelim then
        PathTemp :=  PathTemp + PathDelim;

    {$I-}
    ChDir(PathTemp);
    if IOResult <> 0 then
      Exit;

    FindFirst('*.*', faAnyFile, SearchRec);
    Erc:=0;
    while Erc=0 do
    begin

      if ((searchRec.Name <> '.') and (searchrec.Name<>'..')) then
        if (SearchRec.Attr and faDirectory>0) then
          ObterListaDeArquivoRecursivamente(PathTemp + SearchRec.Name, ListagemDeArquivos)
        Else
          ListagemDeArquivos.Add(PathTemp  + Searchrec.Name);


      Erc:=FindNext (SearchRec);

      Application.ProcessMessages;

    end;
    FindClose(SearchRec);

  finally
    If Length (PathTemp)>3 then
      Chdir('..');
  end;
  {$I+}
End;

procedure TFuncoesWin.ObterListaDePathDoDiretorio(const RootDir:string; var ListagemDeArquivos : TStringList; extensao: string='*.*');
var
SearchRec: tSearchREC;
Erc:Integer;
PathTemp : string;
Begin
  try

    PathTemp:= StringReplace(RootDir, '/', '\', [rfReplaceAll, rfIgnoreCase]);
    if length(PathTemp) > 0 then
      if PathTemp[length(PathTemp)] <> PathDelim then
        PathTemp :=  PathTemp + PathDelim;

    {$I-}
    ChDir(PathTemp);
    if IOResult <> 0 then
      Exit;

    FindFirst('*.*', faAnyFile, SearchRec);
    Erc:=0;
    while Erc=0 do
    begin

      if ((searchRec.Name <> '.') and (searchrec.Name<>'..')) then
        if (SearchRec.Attr and faDirectory>0) then
          ListagemDeArquivos.Add(PathTemp  + Searchrec.Name);

      Erc:=FindNext (SearchRec);

      Application.ProcessMessages;

    end;
    FindClose(SearchRec);

  finally
    If Length (PathTemp)>3 then
      Chdir('..');
  end;
  {$I+}
End;

//-----------------------------------------------------------------------
//A função DayOfWeek retorna um número inteiro que indica o dia da semana,
// sendo que o valor pode variar de 1 a 7, sendo que o valor 1 corresponde
// ao domingo. Para escrever o dia da semana por extenso, a função posiciona
// o vetor semana no  valor indicado pela variável DiaSem.
//-----------------------------------------------------------------------
Function TFuncoesWin.DataPorExtenso:String;
const
     Semana : Array [1..7] of String = ('Domingo', 'Segunda-Feira', 'Terça-Feira','Quarta-Feira','Quinta-Feira','Sexta-Feira', 'Sábado');
var
    DiaSem : Word;
begin
    DiaSem:=DayOfWeek(Date);
    Result := Semana[DiaSem];
end;
procedure TFuncoesWin.DeletarArquivosPorFiltro(path: string; filtro: string);
var
  slListaArquivos: TStringList;
  i: integer;
  sArquivo: string;
begin

  if path[length(path)] <> '\' then
    path := path + '\';

  try

    slListaArquivos := TStringList.Create;

    ObterListaDeArquivosDeUmDiretorio(path, slListaArquivos, filtro);

    for i:=0 to slListaArquivos.Count-1 do
    begin
      sArquivo := slListaArquivos[i];
      sArquivo := path + sArquivo;

      try
        if FileExists(sArquivo) then
          DeleteFile(sArquivo);
      except
        on E:Exception do
          objLogar.Logar('ufuncoes.pas - DeletarArquivosPorFiltro()  - Arquivo: "'+sArquivo+'" - Exceção: '+E.Message);
      end;

    end;


  finally

    if Assigned(slListaArquivos) then
      FreeAndNil(slListaArquivos);

  end;




end;

function TFuncoesWin.CopiarArquivo(source,dest: String): Boolean;
var
  fSrc,fDst,len: Integer;
  size: Longint;
  buffer: packed array [0..2047] of Byte;
begin
  if source <> dest then
  begin
    fSrc := FileOpen(source,fmOpenRead);

    if fSrc >= 0 then
    begin
      size := FileSeek(fSrc,0,2);
      FileSeek(fSrc,0,0);
      fDst := FileCreate(dest);
      if fDst >= 0 then
      begin
        while size > 0 do
        begin
          len := FileRead(fSrc,buffer,sizeof(buffer));
          FileWrite(fDst,buffer,len);
          size := size - len;
        end;
        FileSetDate(fDst,FileGetDate(fSrc));
        FileClose(fDst);
        FileSetAttr(dest,FileGetAttr(source));
        Result := True;
      end
      else
      begin
        Result := False;
      end;
      FileClose(fSrc);
    end;
  end;
end;

procedure TFuncoesWin.GetListaDeArquivosEmOrdemAlfabetica(path : String; var listaArquivos : TStringList; filtro : String);
var
  Arq: TSearchRec;
  dir: String;
begin
  if path[length(path)] <> '\' then
   path :=  path + '\';

  if FindFirst(path + filtro , faDirectory , Arq) = 0 then
  begin
    repeat
      if (Arq.Attr <> 0) and (faDirectory <> 0)
       and (Arq.Name <> '.') and ( Arq.Name <> '..') then
        listaArquivos.Add(Arq.Name);
    until FindNext(Arq) <> 0;
    FindClose(Arq);
  end;

  listaArquivos.Sort;
end;

function TFuncoesWin.NumeroDeLinhasDoArquivo(sLocalDoArquivo : string; sNomeDoArquivo : string; sTipoDoRegistro  :string = ''; iPos : Integer = 0; iTam : Integer = 0) : Integer;
var

  arqEntrada : TextFile;
  sLinha     : string;

  stlCaregaArquivo : TStringList;
  iContLinhasDoArquivo  :Integer;
begin

  Assignfile(arqEntrada, sLocalDoArquivo + sNomeDoArquivo);
  Reset(arqEntrada);


  iContLinhasDoArquivo := 0;
  while not Eof(arqEntrada) do
  begin

    Readln(arqEntrada, sLInha);

    if Copy(sLInha, iPos, iTam) = sTipoDoRegistro then
      Inc(iContLinhasDoArquivo);

  end;

  CloseFile(arqEntrada);

  result :=  iContLinhasDoArquivo;

end;

function TFuncoesWin.IsRunningProcess(ExeFileName : string) : Boolean;
var
  ContinueLoop    : Boolean;
  FSnapshotHandle : THandle;
  FProcessEntry32 : TProcessEntry32;
begin
   FSnapshotHandle        := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
   FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
   ContinueLoop           := Process32First(FSnapshotHandle,FProcessEntry32);
   Result                 := False;
   while Integer(ContinueLoop) <> 0 do
   begin
     if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
     begin
        Result := True;
     end;
     ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32)
   end;
   CloseHandle(FSnapshotHandle)
end;

Function TFuncoesWin.FileIsOpen(const FileName : TFileName) : Boolean;
begin
  Result := False;
  try
    With TFileStream.Create( FileName, fmOpenread or fmShareExclusive)
    do Free;
  except
    Result := True;
  end;
end;

function TFuncoesWin.AplicacaoEstaAberta(NomeAPP: PChar): Boolean;
var
//não esqueça de declarar Windows esta uses
Hwnd : THandle;
begin

  Hwnd := FindWindow('TApplication', NomeAPP); //lembrando que Teste é o titulo da sua aplicação

  // se o Handle e' 0 significa que nao encontrou
  if Hwnd = 0 then
  begin
    // Não
    Result := False;
  end
  else
  Begin
    // Sim
    Result := True;
  end;

end;

function TFuncoesWin.GetFileDate(Arquivo: String; MASCARA: String='YYYY-MMDD'): String;
var
  FHandle: integer;
begin
  FHandle := FileOpen(Arquivo, 0);
  try
    Result := FormatDateTime(MASCARA, FileDateToDateTime(FileGetDate(FHandle)));
  finally
    FileClose(FHandle);
  end;
end;

function TFuncoesWin.getUsuarioLogado(): String;
Var
  User : DWord;
begin
  User := 50;
  SetLength(Result, User);
  GetUserName(PChar(Result), User);
  SetLength(Result, StrLen(PChar(Result)));
end;


//============================
//  NOME DA MÁQUINA NA REDE
//============================
function TFuncoesWin.getNetHostName: String;
var
  lpBuffer : pChar;
  nSize    : dWord;
  const
    buff_size = MAX_COMPUTERNAME_LENGTH + 1;
begin

  nSize := buff_size;

  lpBuffer := StrAlloc(buff_size);
  GetComputerName(lpBuffer, nSize);

  Result := lpBuffer;

  StrDispose(lpBuffer);


end;

procedure TFuncoesWin.PrintFile(aFile : TFileName);
var
  Device: array[0..255] of Char;
  Driver: array[0..255] of Char;
  Port: array[0..255] of Char;
  S: string;
  hDeviceMode: THandle;
begin
  // Selecione uma impressora, neste caso é a padrão.
  Printer.PrinterIndex := -1;
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  S := Format('"%s" "%s" "%s"', [Device, Driver, Port]);
  ShellExecute(Application.Handle, 'printto', PChar(aFile), PChar(S), nil, SW_HIDE);
end;

function TFuncoesWin.IsArquivoVazio(const FileName: String): Boolean;
var
  flArquivo   : TextFile;
  bResult     : Boolean;
begin

  bResult := False;

  AssignFile(flArquivo, FileName);
  Reset(flArquivo);

  if FileSize(flArquivo) <= 0 then
    bResult := True;

  CloseFile(flArquivo);

  Result := bResult;

end;

End.
