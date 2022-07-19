unit ClassLog;
interface
uses
    Classes, ComCtrls, Controls, DateUtils, db, DBGrids, Dialogs,
    ExtCtrls, filectrl, Forms, Graphics, Grids, ImgList, IniFiles, Menus, Messages,
    Printers, Registry, ShellAPI, StdCtrls, SysUtils, Variants, Windows, WinSock,
    ZAbstractDataset, ZAbstractRODataset, ZConnection, ZDataset;
type

  TArquivoDelog= class
    private
      __complemento__      : String;
      __mensagem__         : String;
      __DiretorioSaida__   : string;
      __nomeArquivo__      : string;
      __imprimirInfoDebug__: Boolean;

      Function FileIsOpen(const FileName : TFileName) : Boolean;
    public
      {Importante: para que funcione corretamente é necessário que a versão da aplicação seja informada em Project => Options => Version Info, campo Module Version Number}
      function GetVersaoDaAplicacao(): string;
      {Loga mensagem com a versão do programa, deve ser informado na guia Project -> options -> Version Info a versão do programa}
      function Logar(Mensagem: string; DiretorioSaida: string=''; nomeArquivo: string=''; imprimirInfoDebug: boolean=true; exibirShowMessage: boolean=false): String;//Boolean;
      function getArquivoDeLog(DiretorioSaida: string=''): String;

      constructor create(complemento_nome_arquivo_log: string='');

   End;

implementation
//uses Math, ClassDirectory;
{ TContagemCedulas }

//Método set

//Método get

constructor TArquivoDelog.create(complemento_nome_arquivo_log: string='');
var
  sArquivo     : string;
begin

  __complemento__ := complemento_nome_arquivo_log;

  sArquivo := StringReplace(AnsiLowerCase(ExtractFileName(Application.ExeName)), '.exe', '', [rfReplaceAll, rfIgnoreCase]);

  if __complemento__ <> '' then
    sArquivo := sArquivo + '_' + __complemento__;

  sArquivo        := sArquivo + '.log';
  __nomeArquivo__ := sArquivo;

end;

Function TArquivoDelog.Logar(Mensagem: string; DiretorioSaida: string=''; nomeArquivo: string=''; imprimirInfoDebug: boolean=true; exibirShowMessage: boolean=false): String;//Boolean;
var
  ArqLog       : TextFile;
  sArquivo     : string;
  sVersao      : string;
  sExecutavel  : string;
  sDirSaida    : string;
  sLinha       : string;
  iTamDirSaida : integer;

begin

    if DiretorioSaida = '' then
      DiretorioSaida :=  ExtractFilePath(Application.ExeName);

    if trim(nomeArquivo) = '' then
    begin
      sArquivo := StringReplace(AnsiLowerCase(ExtractFileName(Application.ExeName)), '.exe', '', [rfReplaceAll, rfIgnoreCase]);

      if __complemento__ <> '' then
        sArquivo := sArquivo + '_' + __complemento__;

      sArquivo        := sArquivo + '.log';
      __nomeArquivo__ := sArquivo;

    end
    else
      sArquivo := nomeArquivo;

    Assignfile(ArqLog, DiretorioSaida + sArquivo);

    if not FileExists(DiretorioSaida + sArquivo) then
      rewrite(ArqLog)
    else
    begin
      append(ArqLog);
    end;

    sVersao := GetVersaoDaAplicacao();

    if trim(Mensagem)<>'' then
    begin
      if imprimirInfoDebug then
      begin
        sExecutavel := ExtractFileName(Application.ExeName);
        sExecutavel := copy(sExecutavel,1,length(sExecutavel)-4);

        sLinha      := sExecutavel + ' V. '+ sVersao + ' - ' + formatdatetime('dd/mm/yyyy hh:nn:ss.zzz',now) + ' > ' + Mensagem;

        writeln(Arqlog, sLinha);

        if exibirShowMessage then
          ShowMessage(sLinha);

      end
      else
        writeln(Arqlog, Mensagem);
    end
    else
      writeln(Arqlog, '');

    CloseFile(ArqLog);

  Result := sLinha;  

end;

function TArquivoDelog.GetVersaoDaAplicacao(): string;
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

function TArquivoDelog.getArquivoDeLog(DiretorioSaida: string=''): String;
begin
  //Result := StringReplace(AnsiLowerCase(Application.ExeName), '.exe', '.log', [rfReplaceAll, rfIgnoreCase])

  if DiretorioSaida = '' then
    DiretorioSaida :=  ExtractFilePath(Application.ExeName);

  Result := DiretorioSaida + __nomeArquivo__;

end;

Function TArquivoDelog.FileIsOpen(const FileName : TFileName) : Boolean;
begin

  try
    With TFileStream.Create( FileName, fmOpenread or fmShareExclusive) do
    begin
      Result := False;
      Free;
    end;
  except
    Result := True;
  end;
end;

end.
