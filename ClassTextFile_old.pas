unit ClassTextFile;

  (*

    CRIADO POR: Eduardo C. M. Monteiro.

    OBJETIVO:
      Classe para tratamento de arquivos.

    OBS.:
      - Ao Destruir um objeto desta classe, não use "FreeAndNil".
        Se você o fizer o arquivo não será fechado, ocasionando um erro
        se ele for aberto em seguida.
        A forma correta de instanciar um objeto desta classe (invocando
        o construtor e o destrutor, e supondo um arquivo em modo leitura) é :

          try
            oArquivo := TArquivoTexto.Create(ARQUIVO_CONFIGURACAO_APP, leitura);

            while not oArquivo.FimDeArquivo do
            begin
              oArquivo.LerLinha();
              sLinha := oArquivo.getLinha()

              //Seu código aqui...
            end;

          finally
            if Assigned(oArquivo) then
            begin
              //Se eu usar o FreeAndNil o handler do arquivo fica "preso"
              //FreeAndNil(oArquivo);

              //Equivalente ao "FreeAndNil":
              oArquivo.destroy;
              Pointer(oArquivo) := nil;
            end;
          end;

  *)


interface

uses Classes, ComCtrls, Controls, DateUtils, db, DBGrids, Dialogs,
  ExtCtrls, filectrl, Forms, Graphics, Grids, ImgList, IniFiles, Menus, Messages,
  Printers, Registry, ShellAPI, StdCtrls, SysUtils, variants, Windows, WinSock,
  ZAbstractDataset, ZAbstractRODataset, ZConnection, ZDataset,
  ClassSimpleFileStream;

type

  TModoDeAberturaDeArquivo = (leitura, escrita, criacao);
  TCase = (normalCase, lowerCase, upperCase);
  EModoLeituraArquivo = (memoria, disco);

  TArquivoTexto= class
    private
      __file__                   : TextFile;
      __linha__                  : String;
      __nomeArquivo__            : String;
      __path__                   : String;
      __dataCriacao__            : TDateTime;
      __tamanho__                : Double;
      __extensao__               : String;
      //__modo__                   : TModoDeAberturaDeArquivo;
      __NumeroDeLinhasLidas__    : Integer;
      __NumeroDeLinhasGravadas__ : Integer;
      eeModoLeituraArquivo       : EModoLeituraArquivo;
      eeModoAberturaArquivo      : TModoDeAberturaDeArquivo;


    {Métodos set}
    Procedure setArquivo(const Filename: String);
    Procedure setPath(const Path: String);

    {Métodos get}

    {Métodos}

   public
    oFileStream: TFileStream;
    slArquivo: TStringList;

    {Métodos set}

    {Métodos get}
    function getPath(): String;
    function getArquivo(): String;
    function getLinha(AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
    function getParte(posicao: integer= 1; tamanho: Integer= 0; sString: String= ''; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
    function getTermo(posicao: Integer; separador: String=''; sString: String=''; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
    function getNomeDoArquivoReplace(oldString, newString: String; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
    function getModoDoArquivo(): TModoDeAberturaDeArquivo;
    function getLinhasJaLidas(): Integer;
    function getLinhasJaGravadas(): Integer;

    {Métodos}
    function LerLinha(modoInsercaoEmBanco : boolean = false): Boolean;
    function EscreverNoArquivo(Linha: String; ForcarQuebraDeLinha: boolean=true): Boolean;
    function ArquivoEstaAberto(): Boolean;
    function FimDeArquivo(): Boolean;
    function FecharArquivo(): Boolean;
    function ExtractName(): String;
    function TrocarString(oldString, NewString: String; posicao: Integer=0; tamanho: Integer=0): String;

    { Propriedades }
    property ModoLeituraArquivo: EModoLeituraArquivo read eeModoLeituraArquivo write eeModoLeituraArquivo;
    property ModoAberturaArquivo: TModoDeAberturaDeArquivo read eeModoAberturaArquivo write eeModoAberturaArquivo;

    
    {Método construtor da classe}
    constructor create(Arquivo: String; modo: TModoDeAberturaDeArquivo= leitura);
    destructor  destroy();
   end;

const
TAMANHO_MAXIMO_EM_MB__STRINGLIST_CARREGAMENTO_RAPIDO_ARQUIVO: integer = 250; //limite testado na FINGER09: 250

implementation

uses ClassDirectory, uFuncoes, udatatypes_apps;

function TArquivoTexto.LerLinha(modoInsercaoEmBanco : boolean = false): Boolean;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

    OBJETIVO:
      - Ler a linha do arquivo que esteja aberto no modo leitura.
      - Possui modo de inserção em banco para caracteres especiais através
        da variável  "modoInsercaoEmBanco"

  *)
  
  try
    if ModoAberturaArquivo = leitura then
    begin

      if ModoLeituraArquivo = disco then
        readln(__file__, __linha__)
      else
      if ModoLeituraArquivo = memoria then
        __linha__ := slArquivo[__NumeroDeLinhasLidas__];

      __linha__ := StringReplace(__linha__, #0, ' ', [rfReplaceAll, rfIgnoreCase]);

      if modoInsercaoEmBanco then
        PrepararStringParaInsercaoEmBanco(__linha__);
        
      __NumeroDeLinhasLidas__ := __NumeroDeLinhasLidas__ + 1;

      result := true;
    end
    else
    begin
      ShowMessage('ARQUIVO ' + __nomeArquivo__ + ' ESTÁ EM MODO SOMENTE ESCRITA');
      result := false;
    end;
  except
    ShowMessage('ERRO AO LER A LINHA '
              + FormatFloat('0000000', __NumeroDeLinhasLidas__)
              + ' DO ARQUIVO' + __nomeArquivo__);
    result := false;
  end;
end;

function TArquivoTexto.FimDeArquivo(): Boolean;
var
  bEOF: boolean;
begin
  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO: Verificar se é fim de arquivo.

  *)

  try

    if ModoLeituraArquivo = disco then
      bEOF :=  eof(__file__)
    else if ModoLeituraArquivo = memoria then
    begin
      if __NumeroDeLinhasLidas__ = slArquivo.Count then
        bEOF := true
      else
        bEOF := false;
    end;  

  except

    ShowMessage('ERRO AO OBTER O PONTEIRO DO ARQUIVO ' + __nomeArquivo__ + ' NO PATH ' + __path__ + ', PODE ESTAR ABERTO POR ALGUMA APLICAÇÃO ' +
                #13 + 'FECHE A APLICAÇÃO E TENTE NOVAMENTE. ');

    bEOF :=  true;

  end;

  result := bEOF;

end;

function TArquivoTexto.getLinha(AplicarTrim: Boolean= false;  Caixa: TCase= normalCase): String;
var
   sLinha       : String;
begin
  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO: Retornar a linha corrente.

  OBS.:

    - AplicarTrim: Boolean= false;     -> Aplicar Trim

    - TCase      : Aplica caixa alta e baixa na String;
                - caseNomal
                - lowerCase
                - upperCase

  *)

  case Caixa of
    normalCase:
      begin
        if AplicarTrim then
          result :=  Trim(__linha__)
        else
          result :=  __linha__;
      end;

    upperCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiUpperCase(__linha__))
        else
          result :=  AnsiUpperCase(__linha__);
      end;

    lowerCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiLowerCase(__linha__))
        else
          result :=  AnsiLowerCase(__linha__);
      end;

  end;
end;

function TArquivoTexto.getParte(posicao: integer= 1; tamanho: Integer= 0; sString: String= ''; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

    OBJETIVO: Retornar a parte de uma string

    OBS.:
      - posicao: integer= 1              -> Posição inicial do registro
      - tamanho: Integer= 0;             -> Posição final do registro
      - AplicarTrim: Boolean= false;     -> Aplicar Trim
      - TCase: Aplica caixa alta e baixa na String:
                     - caseNomal
                     - lowerCase
                     - upperCase

  *)

  if sString = '' then
    sString:= __linha__;

  if tamanho = 0 then
    tamanho:= Length(sString);

  case Caixa of
    normalCase:
      begin
        if AplicarTrim then
          result :=  Trim(copy(sString, posicao, tamanho))
        else
          result :=  copy(sString, posicao, tamanho);
      end;

    upperCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiUpperCase(copy(sString, posicao, tamanho)))
        else
          result :=  AnsiUpperCase(copy(sString, posicao, tamanho));
      end;

    lowerCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiLowerCase(copy(sString, posicao, tamanho)))
        else
          result :=  AnsiLowerCase(copy(sString, posicao, tamanho));
      end;
  end;
end;

function TArquivoTexto.getTermo(posicao: Integer; separador: String=''; sString: String=''; AplicarTrim: Boolean= false;  Caixa: TCase= normalCase): String;
var
  sAux: TStringList;
begin
  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO: Retorna um string baseado em um separador.

  OBS.:
    - termo: Integer;                  -> Termo a ser retornado baseado no separador
    - separador: String='';            -> Separador de string
    - AplicarTrim: Boolean= false;     -> Aplicar Trim
    - TCase      : Aplica caixa alta e baixa na String;
    - caseNomal
    - lowerCase
    - upperCase
    
  *)


  if sString = '' then
    sString:= __linha__;

  result := '';

  sAux  :=TStringList.Create;

  sAux.Text:=StringReplace(sString, separador,#13#10,[rfReplaceAll, rfIgnoreCase]);

  if posicao <= sAux.Count then
    result := sAux.Strings[posicao-1];
  sAux.Free;

  case Caixa of
    normalCase:
      begin
        if AplicarTrim then
          result :=  Trim(Result)
        else
          result :=  Result;
      end;

    upperCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiUpperCase(Result))
        else
          result :=  AnsiUpperCase(Result);
      end;


    lowerCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiLowerCase(Result))
        else
          result :=  AnsiLowerCase(Result);
      end;
  end;

end;

function TArquivoTexto.getModoDoArquivo(): TModoDeAberturaDeArquivo;
begin
  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO: Retorna o modo em que o arquivo se encontra (criacao, escrita ou leitura)

  *)


  result :=  ModoAberturaArquivo;
end;

function TArquivoTexto.getNomeDoArquivoReplace(oldString, newString: String; AplicarTrim: Boolean= false;  Caixa: TCase= normalCase): String;
var
  newName: String;
begin

  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  newName:= StringReplace(__nomeArquivo__, oldString, newString, [rfIgnoreCase, rfReplaceAll]);

  case Caixa of
    normalCase:
      begin
        if AplicarTrim then
          result :=  Trim(newName)
        else
          result :=  newName;
      end;

    upperCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiUpperCase(newName))
        else
          result :=  AnsiUpperCase(newName);
      end;

    lowerCase:
      begin
        if AplicarTrim then
          result :=  Trim(AnsiLowerCase(newName))
        else
          result :=  AnsiLowerCase(newName);
      end;
  end;
end;

constructor TArquivoTexto.create(Arquivo: String; modo: TModoDeAberturaDeArquivo = leitura);
var
  objPath  : TDiretorio;
  sArquivo : String;
  MSG      : String;
  iTamanho: int64;
  rrTamanho: RFile;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  ModoAberturaArquivo := modo;

  if ModoAberturaArquivo = leitura then
  begin
    iTamanho  := GetTamanhoArquivo_WinAPI(Arquivo);
    rrTamanho := GetTamanhoMaiorUnidade(iTamanho);

    if ((rrTamanho.Unidade = 'MB')
     and (rrTamanho.Tamanho < TAMANHO_MAXIMO_EM_MB__STRINGLIST_CARREGAMENTO_RAPIDO_ARQUIVO)
     ) or (rrTamanho.Unidade = 'KB') then
      ModoLeituraArquivo := memoria
    else
      ModoLeituraArquivo := disco;
  end;

  if ModoAberturaArquivo in [escrita, criacao] then
  begin
    if ModoAberturaArquivo = criacao then //rewrite
    begin
      oFileStream := TFileStream.Create(Arquivo,
       fmCreate or fmShareDenyWrite);
      oFileStream.Seek(0, soFromEnd);
    end
    else if ModoAberturaArquivo = escrita then //append
    begin
      if FileExists(Arquivo) then
      begin
        oFileStream := TFileStream.Create(Arquivo,
         fmOpenReadWrite or fmShareDenyWrite)
      end
      else
      begin
        oFileStream := TFileStream.Create(Arquivo,
         fmCreate or fmShareDenyWrite);
      end;
      oFileStream.Seek(0, soFromEnd);
    end;

  end;

  try
    __NumeroDeLinhasLidas__   := 0;
    __NumeroDeLinhasGravadas__:= 0;

    objPath:= TDiretorio.create(ExtractFilePath(Arquivo));

    setPath(objPath.getDiretorio());
    setArquivo(ExtractFileName(Arquivo));

    sArquivo:= Arquivo;

    //if ArquivoEstaAberto() then
    //begin
      case ModoAberturaArquivo of
        {
        escrita: Append(__file__);
        criacao: Rewrite(__file__);
        }
        leitura:
          begin
            if FileExists(sArquivo) then
            begin
              if ModoLeituraArquivo = disco then
              begin
                AssignFile(__file__, sArquivo);
                Reset(__file__)
              end
              else
              if ModoLeituraArquivo = memoria then
              begin
                slArquivo := TStringList.Create();
                slArquivo.LoadFromFile(Arquivo);
              end;
            end
            else
              ShowMessage('O ACESSO AO ARQUIVO ' + Arquivo + ' ESTÁ NO MODO SOMENTE LEITURA PORÉM NÃO EXISTE. ');
          end;
      end;
    //end
    //else
    //begin
    //  ShowMessage('ARQUIVO ' + __nomeArquivo__ + ' NO PATH ' + __path__ + ' ESTÁ ABERTO POR ALGUMA APLICAÇÃO ' +
    //              #13 + 'FECHE A APLICAÇÃO PRIMEIRO.');
    //end;
  except
    on E:Exception do
    begin
      MSG := E.Message;
      ShowMessage(MSG);
    end;
  end;
end;

function TArquivoTexto.EscreverNoArquivo(Linha: String; ForcarQuebraDeLinha: boolean=true): Boolean;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  if ModoAberturaArquivo in [criacao, escrita] then
  begin
    if ForcarQuebraDeLinha then
      linha := linha + #13#10; //força quebra de linhas do windows
    try
      oFileStream.Write(linha[1], length(linha));

      __NumeroDeLinhasGravadas__ := __NumeroDeLinhasGravadas__ + 1;
      result :=  true;

    except
      on E:Exception do
      begin
        result :=  false;
        ShowMessage('Erro na gravação do arquivo "' + __nomeArquivo__ + '".' );
      end;
    end;
  end
  else
  begin
    ShowMessage('Arquivo  "' + __nomeArquivo__ + '" não pode ser gravado, pois está em modo de leitura.');
    result :=  false;
  end;

end;

function TArquivoTexto.ExtractName(): String;
var
  aExt : String;
  aPos : Integer;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  aExt := ExtractFileExt(getArquivo());

  Result := ExtractFileName(getArquivo());

  if aExt <> '' then
  begin
    aPos := Pos(aExt,Result);
    if aPos > 0 then
    begin
      Delete(Result,aPos,Length(aExt));
    end;
  end;

end;

Procedure TArquivoTexto.setPath(const Path: String);
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  __path__:=  Path;
end;

Procedure TArquivoTexto.setArquivo(const Filename: String);
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  __NomeArquivo__:= Filename;
end;

function TArquivoTexto.getPath(): String;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  result :=  __path__;
end;

function TArquivoTexto.getArquivo(): String;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  result :=  __nomeArquivo__;
end;

function TArquivoTexto.ArquivoEstaAberto(): Boolean;
var
  S: TStream;
  sArquivo: String;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  Result := true;
  sArquivo:= getPath() + getArquivo();
  if FileExists(sArquivo) then
  try
    try
      S := TFileStream.Create(sArquivo, fmOpenRead or fmShareExclusive);
    except
      on EStreamError do
        Result := False; // EFOpenError
    end;
  finally
    S.Free;
  end;
end;

function TArquivoTexto.FecharArquivo(): Boolean;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  try
    if ModoAberturaArquivo = leitura then //se o arquivo estiver aberto para leitura
    begin
      if ModoLeituraArquivo = disco then
        CloseFile(__file__)
      else if ModoLeituraArquivo = memoria then
      begin
        if Assigned(slArquivo) then
          FreeAndNil(slArquivo);
      end;
    end
    else if ModoAberturaArquivo in [criacao, escrita] then  //se o arquivo estiver aberto para gravação
    begin
      if Assigned(oFileStream) then
      begin
        //Equivalente ao "FreeAndNil":
        oFileStream.destroy;
        Pointer(oFileStream) := nil;
      end;
    end;  

    result :=  true;
  except
    ShowMessage('NÃO FOI POSSÍVEL FECHAR O ARQUIVO ' + __nomeArquivo__ + ' NO PATH ' + __path__ + ' !!!');
    result :=  false;
  end;

end;

function TArquivoTexto.getLinhasJaLidas(): Integer;
begin

  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  result :=  __NumeroDeLinhasLidas__;
end;

function TArquivoTexto.getLinhasJaGravadas(): Integer;
begin

  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  result :=  __NumeroDeLinhasGravadas__;
end;

function TArquivoTexto.TrocarString(oldString, NewString: String; posicao: Integer=0; tamanho: Integer=0): String;
var
  Parte: String;
begin

  (*

  CRIADO POR: Eduardo C. M. Monteiro.

  *)

  if posicao = 0 then
    posicao:= 1;

  if tamanho = 0 then
    tamanho:= Length(__linha__);

  result :=  StringReplace(Copy(__linha__, posicao, tamanho), oldString, NewString, [rfReplaceAll, rfIgnoreCase]);
end;

destructor TArquivoTexto.destroy;
begin
  self.FecharArquivo();

  if ModoAberturaArquivo in [criacao, escrita] then
  begin
    if Assigned(oFileStream) then
    begin
      //Equivalente a FreeAndNil:
      oFileStream.destroy;
      Pointer(oFileStream) := nil;
    end;
  end
  else if (ModoAberturaArquivo = leitura) and (ModoLeituraArquivo = memoria) then
  begin
    if Assigned(slArquivo) then
      FreeAndNil(slArquivo);
  end;

  inherited Destroy;
end;


end.
