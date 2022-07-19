unit ClassZip;
interface
  uses Classes, Dialogs, SysUtils, ComCtrls, Windows;

type

  TZip= class
    private
      __Arquivo__                : String;
      __PathOrigem__             : String;
      __PathDestino__            : String;
      __AplicativoCompactacao__  : String;
      __AplicativoDescomprecao__ : String;

      //MÃ©todos set
      function setArquivoZip(const Filename: String): Boolean;
      function setPathOrigem(const Path: String): Boolean;
      function setPathDestino(const Path: String): Boolean;
      function setAplicativoCompactacao(const Aplicativo: String): Boolean;
      function setAplicativoDescomprecao(const Aplicativo: String): Boolean;

      function WinExecAndWait32(FileName: string; Visibility: Integer=0): Longword;
      {Substitui uma String por outra}
      function TrocarString(sString, oldString, newString: String): String;

      {Ajusta o Path de diretórios com barra no final.}
      Function AjustaPath(sPath : string; sOS: String = 'W'): string;

      //MÃ©todos get
      function getAplicativoCompactacao(): String;
      function getAplicativoDescomprecao(): String;
    public
      //MÃ©todos
      function Compactar_Arquivos(Arquivo, destino, aplicativo: String; mover_arquivo: Boolean=false; excluir_path: Boolean=true; path_recursivo: Boolean=false): integer;

      //ESTA VERSÃO COMPACTA ARQUIVOS ADICIONANDO EXTEÇÃO .ZIP POR PADRÃO, CONTENDO OU NÃO A EXTENÇÃO
      function Compactar_ArquivosV2(Arquivo, destino, aplicativo: String; mover_arquivo: Boolean=false; excluir_path: Boolean=true; path_recursivo: Boolean=false): integer;

      procedure Descompactar_Arquivos(Arquivo:string; destino: string; aplicativo: String='');
      procedure Compactar_Diretorio(PathOrigem, PathDestino, Aplicativo: String;Arquivo_zip: String='';Pre_Observacao_nome_arquivo: String=''; Pos_observacao_nome_arquivo: String=''; mover_arquivo: Boolean=false; path_recursivo: Boolean=true);
      constructor create(AplicacaoZIPCompactar, AplicacaoZIPDescompactar: String);
   End;

implementation
//uses Math;
{ TContagemCedulas }

// MÃ©todos set

constructor TZip.create(AplicacaoZIPCompactar, AplicacaoZIPDescompactar: String);
begin
  setAplicativoCompactacao(AplicacaoZIPCompactar);
  setAplicativoDescomprecao(AplicacaoZIPDescompactar);
end;

function TZip.setAplicativoCompactacao(const Aplicativo: String): Boolean;
Begin
  __AplicativoCompactacao__:= Aplicativo;
end;

function TZip.setAplicativoDescomprecao(const Aplicativo: String): Boolean;
Begin
    __AplicativoDescomprecao__:= Aplicativo;
end;

function TZip.setArquivoZip(const Filename: String): Boolean;
Begin
  __Arquivo__:= Filename;
end;

function TZip.setPathDestino(const Path: String): Boolean;
Begin
  __PathDestino__:= Path;
end;

function TZip.setPathOrigem(const Path: String): Boolean;
Begin
  __PathOrigem__:= Path;
end;

// MÃ©todos get
function TZip.getAplicativoCompactacao(): String;
Begin
  Result:= __AplicativoCompactacao__;
end;

function TZip.getAplicativoDescomprecao(): String;
Begin
  Result:= __AplicativoDescomprecao__;
end;

// MÃ©todos
function TZip.Compactar_Arquivos(Arquivo, destino, aplicativo: String; mover_arquivo: Boolean=false; excluir_path: Boolean=true; path_recursivo: Boolean=false): integer;
Var
  sComando            : String;
  sArquivoDestino     : String;
  sParametros         : String;
Begin

    if aplicativo <> '' then
      setAplicativoCompactacao(aplicativo);

    sArquivoDestino := TrocarString(ExtractFileName(Arquivo), '.txt', '.zip');

    destino := AjustaPath(destino);

    sParametros := ' -9 -q';

    if mover_arquivo then
      sParametros := sParametros + ' -m';

    if excluir_path then
      sParametros := sParametros + ' -j';

    if path_recursivo then
      sParametros := sParametros + ' -r';

    sComando := __AplicativoCompactacao__ + sParametros + ' "' + destino + sArquivoDestino + '" "' + Arquivo + '"';


    Result:= WinExecAndWait32(sComando);

End;

//ESTA VERSÃO COMPACTA ARQUIVOS ADICIONANDO EXTEÇÃO .ZIP POR PADRÃO, CONTENDO OU NÃO A EXTENÇÃO
function TZip.Compactar_ArquivosV2(Arquivo, destino, aplicativo: String; mover_arquivo: Boolean=false; excluir_path: Boolean=true; path_recursivo: Boolean=false): integer;
Var
  sComando            : String;
  sArquivoDestino     : String;
  sParametros         : String;

  iRetorno            : Integer;
Begin

    if aplicativo <> '' then
      setAplicativoCompactacao(aplicativo);

    sArquivoDestino := ExtractFileName(Arquivo) + '.zip';

    destino := AjustaPath(destino);

    sParametros := ' -9 -q';

    if mover_arquivo then
      sParametros := sParametros + ' -m';

    if excluir_path then
      sParametros := sParametros + ' -j';

    if path_recursivo then
      sParametros := sParametros + ' -r';

    sComando := __AplicativoCompactacao__ + sParametros + ' "' + destino + sArquivoDestino + '" "' + Arquivo + '"';

    iRetorno := WinExecAndWait32(sComando);

    // =  0 - ok
    // <> 0 - erro
    Result := iRetorno;

End;


procedure TZip.Descompactar_Arquivos(Arquivo: string; destino:string; aplicativo: String = '');
Var
  sComando            : String;
  sParametros         : String;
  sArquivoDestino     : String;
Begin

  if aplicativo <> '' then
    setAplicativoCompactacao(aplicativo);


  destino := AjustaPath(destino);

  sParametros := ' -qqu';

  if destino <> '' Then
    destino := ' -d "' + destino + '"';

  destino := StringReplace(destino, '\', '/', [rfReplaceAll]);

  sComando := __AplicativoDescomprecao__ + sParametros + ' "' + Arquivo + '" ' + destino;
  WinExecAndWait32(sComando);
End;

procedure TZip.Compactar_Diretorio(PathOrigem, PathDestino, Aplicativo: String;Arquivo_zip: String='';Pre_Observacao_nome_arquivo: String=''; Pos_observacao_nome_arquivo: String=''; mover_arquivo: Boolean=false; path_recursivo: Boolean=true);
Var
  sComando            : String;
  sParametros         : String;
Begin

  if aplicativo <> '' then
    setAplicativoDescomprecao(aplicativo);

  if Arquivo_zip = '' then
  Begin
    if PathOrigem[Length(PathOrigem)] = PathDelim then
      PathOrigem := copy(PathOrigem, 1, Length(PathOrigem) - 1);
    Arquivo_zip := copy(PathOrigem, LastDelimiter(PathDelim ,PathOrigem) + 1, length(PathOrigem));
  End;

  PathDestino := AjustaPath(PathDestino);

  Arquivo_zip := ExtractFileName(Arquivo_zip) + '.zip';

  sParametros := ' -9 -q -j';

  if mover_arquivo then
    sParametros := sParametros + ' -m';

  if path_recursivo then
    sParametros := sParametros + ' -r';

  if Pre_Observacao_nome_arquivo <> '' Then
    Pre_Observacao_nome_arquivo := Pre_Observacao_nome_arquivo + '_';

  if Pos_observacao_nome_arquivo <> '' Then
    Pos_observacao_nome_arquivo := '_' + Pos_observacao_nome_arquivo;

  Arquivo_zip := Pre_Observacao_nome_arquivo + Arquivo_zip + Pos_observacao_nome_arquivo  + '.zip';

  sComando := __AplicativoCompactacao__ + sParametros + ' "' + PathDestino + Arquivo_zip + '" "' + PathOrigem + '"';
  WinExecAndWait32(sComando);
End;

function TZip.WinExecAndWait32(FileName: string; Visibility: Integer=0): Longword;
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

Function TZip.AjustaPath(sPath : string; sOS: String = 'W'): string;
var
  PathTemp: string;
begin

  if AnsiUpperCase(sOS) = 'W' then
  Begin
    PathTemp:= StringReplace(sPath, '/', '\', [rfReplaceAll, rfIgnoreCase]);
    if length(PathTemp) > 0 then
      if PathTemp[length(PathTemp)] <> PathDelim then
        PathTemp :=  PathTemp + '\';
  end;

  if AnsiUpperCase(sOS) = 'L' then
  Begin
    PathTemp:= StringReplace(sPath, '\', '/', [rfReplaceAll, rfIgnoreCase]);
    if length(PathTemp) > 0 then
      if PathTemp[length(PathTemp)] <> PathDelim then
        PathTemp :=  PathTemp + '/';
  end;

  Result := PathTemp;
end;

function TZip.TrocarString(sString,oldString, newString: String): String;
Begin
  Result:= StringReplace(sString, oldString, newString, [rfIgnoreCase, rfReplaceAll]);
end;

end.
