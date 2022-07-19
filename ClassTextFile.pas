unit ClassTextFile;
interface
  uses  Classes, ComCtrls, Controls, DateUtils, db, DBGrids, Dialogs,
    ExtCtrls, filectrl, Forms, Graphics, Grids, ImgList, IniFiles, Menus, Messages,
    Printers, Registry, ShellAPI, StdCtrls, SysUtils, Variants, Windows, WinSock,
    ZAbstractDataset, ZAbstractRODataset, ZConnection, ZDataset,
    // Classes
    ClassDirectory;
type

  TModoDeAberturaDeArquivo = (leitura, escrita, criacao);
  TCase = (normalCase, lowerCase, upperCase);

  TArquivoTexto= class
    private
      __file__                   : TextFile;
      __linha__                  : String;
      __nomeArquivo__            : String;
      __path__                   : String;
      __dataCriacao__            : TDateTime;
      __tamanho__                : Double;
      __extensao__               : String;
      __modo__                   : TModoDeAberturaDeArquivo;
      __NumeroDeLinhasLidas__    : Integer;
      __NumeroDeLinhasGravadas__ : Integer;

      objDiretorio               : TDiretorio;

    {Métodos set}
    Procedure setArquivo(const Filename: String);
    Procedure setPath(const Path: String);

    {Métodos get}
    function getModoDoArquivo(): TModoDeAberturaDeArquivo;
    function getLinhasJaLidas(): Integer;
    function getLinhasJaGravadas(): Integer;
    {Metodos}


   public
    {Métodos set}

    {Métodos get}
    function getPath(): String;
    function getArquivo(): String;
    function getLinha(AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
    function getParte(posicao: integer= 1; tamanho: Integer= 0; sString: String= ''; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
    function getTermo(posicao: Integer; separador: String=''; sString: String=''; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
    function getNomeDoArquivoReplace(oldString, newString: String; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;

    {Metodos}
    function LerLinha(modoInsercaoEmBanco : boolean = false): Boolean;
    function EscreverNoArquivo(Linha: String): Boolean;
    function ArquivoEstaAberto(): Boolean;
    function FimDeArquivo(): Boolean;
    function FecharArquivo(): Boolean;
    function ExtractName(): String;
    function TrocarString(oldString, NewString: String; posicao: Integer=0; tamanho: Integer=0): String;

    {Método construtor da classe}
    constructor create(var objDiretorio: TDiretorio; Arquivo: String; modo: TModoDeAberturaDeArquivo= leitura);
   End;

implementation
//uses Math;
{ TContagemCedulas }

function TArquivoTexto.LerLinha(modoInsercaoEmBanco : boolean = false): Boolean;
Begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

    OBJETIVO:
      - Ler a linha do arquivo que esteja aberto no modo leitura.
      - Possui modo de insercao em banco para caracterer especiais através
        da variavel  "modoInsercaoEmBanco"

  *)
  try
    if __modo__ = leitura Then
    Begin
      ReadLn(__file__, __linha__);
      if modoInsercaoEmBanco then
      begin
        __linha__:= StringReplace(__linha__, '\', '\\', [rfIgnoreCase, rfReplaceAll]);
        __linha__:= StringReplace(__linha__, '"', '\"', [rfIgnoreCase, rfReplaceAll]);
        __NumeroDeLinhasLidas__ := __NumeroDeLinhasLidas__ + 1;
      end;
      Result:= true;
    end
    else
    Begin
      ShowMessage('ARQUIVO ' + __nomeArquivo__ + ' ESTÁ EM MODO SOMENTE ESCRITA');
      Result:= false;
    end;
  except
    ShowMessage('ERRO AO LER A LINHA '
              + FormatFloat('0000000', __NumeroDeLinhasLidas__)
              + ' DO ARQUIVO' + __nomeArquivo__);
  end;
end;

function TArquivoTexto.FimDeArquivo(): Boolean;
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO: Verificar se é fim de arquivo.
  *)
  try
    Result:= eof(__file__);
  except
    ShowMessage('ERRO AO OBTER O PONTEIRO DO ARQUIVO ' + __nomeArquivo__ + ' NO PATH ' + __path__ + ', PODE ESTAR ABERTO POR ALGUMA APLICAÇÃO ' +
                #13 + 'FECHE A APLICAÇÃO E TENTE NOVAMENTE !!!');
    Result:= true;
  end;
end;

function TArquivoTexto.getLinha(AplicarTrim: Boolean= false;  Caixa: TCase= normalCase): String;
Var
   sLinha       : String;
Begin
(*
CRIADO POR: Eduardo C. M. Monteiro.

OBJETIVO: Retornar a linha corrente.
*)
 // AplicarTrim: Boolean= false;     -> Aplicar Trim
 // TCase      : Aplica caixa alta e baixa na String;
 //              - caseNomal
 //              - lowerCase
 //              - upperCase

  case Caixa of
    normalCase: if AplicarTrim Then
         Result:= Trim(__linha__)
       else
         Result:= __linha__;

    upperCase: if AplicarTrim Then
         Result:= Trim(AnsiUpperCase(__linha__))
       else
         Result:= AnsiUpperCase(__linha__);

    lowerCase: if AplicarTrim Then
         Result:= Trim(AnsiLowerCase(__linha__))
       else
         Result:= AnsiLowerCase(__linha__);
    end;
end;

function TArquivoTexto.getParte(posicao: integer= 1; tamanho: Integer= 0; sString: String= ''; AplicarTrim: Boolean= false; Caixa: TCase= normalCase): String;
Begin
   (*
   CRIADO POR: Eduardo C. M. Monteiro.

   OBJETIVO: Retornar a parte de uma string
   *)
  // posicao: integer= 1              -> Posição inicial do registro
  // tamanho: Integer= 0;             -> Posição final do registro
  // AplicarTrim: Boolean= false;     -> Aplicar Trim
  // TCase      : Aplica caixa alta e baixa na String;
  //              - caseNomal
  //              - lowerCase
  //              - upperCase

  if sString = '' Then
    sString:= __linha__;

  if tamanho = 0 Then
    tamanho:= Length(sString);

  case Caixa of
    normalCase: if AplicarTrim Then
         Result:= Trim(copy(sString, posicao, tamanho))
       else
         Result:= copy(sString, posicao, tamanho);

    upperCase: if AplicarTrim Then
         Result:= Trim(AnsiUpperCase(copy(sString, posicao, tamanho)))
       else
         Result:= AnsiUpperCase(copy(sString, posicao, tamanho));

    lowerCase: if AplicarTrim Then
         Result:= Trim(AnsiLowerCase(copy(sString, posicao, tamanho)))
       else
         Result:= AnsiLowerCase(copy(sString, posicao, tamanho));
    end;
end;

function TArquivoTexto.getTermo(posicao: Integer; separador: String=''; sString: String=''; AplicarTrim: Boolean= false;  Caixa: TCase= normalCase): String;
var
 sAux: TStringList;
begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO: Retorna um string baseado em um separador
            termo: Integer;                  -> Termo a ser retornado baseado no separador
            separador: String='';            -> Separador de string
            AplicarTrim: Boolean= false;     -> Aplicar Trim
            TCase      : Aplica caixa alta e baixa na String;
                         - caseNomal
                         - lowerCase
                         - upperCase
  *)


  if sString = '' Then
    sString:= __linha__;

  Result:='';
  sAux  :=TStringList.Create;

  sAux.Text:=StringReplace(sString, separador,#13#10,[rfReplaceAll, rfIgnoreCase]);

  if posicao <= sAux.Count then
   Result:=sAux.Strings[posicao-1];
  sAux.Free;

  case Caixa of
   normalCase: if AplicarTrim Then
        Result:= Trim(Result)
      else
        Result:= Result;

   upperCase: if AplicarTrim Then
        Result:= Trim(AnsiUpperCase(Result))
      else
        Result:= AnsiUpperCase(Result);

   lowerCase: if AplicarTrim Then
        Result:= Trim(AnsiLowerCase(Result))
      else
        Result:= AnsiLowerCase(Result);
   end;

end;

function TArquivoTexto.getModoDoArquivo(): TModoDeAberturaDeArquivo;
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO: Retorna o modo em que o arquivo se encontra (criacao, escrita ou leitura)
  *)
  Result:= __modo__;
end;

function TArquivoTexto.getNomeDoArquivoReplace(oldString, newString: String; AplicarTrim: Boolean= false;  Caixa: TCase= normalCase): String;
Var
 newName: String;
Begin

  newName:= StringReplace(__nomeArquivo__, oldString, newString, [rfIgnoreCase, rfReplaceAll]);

  case Caixa of
   normalCase: if AplicarTrim Then
        Result:= Trim(newName)
      else
        Result:= newName;

   upperCase: if AplicarTrim Then
        Result:= Trim(AnsiUpperCase(newName))
      else
        Result:= AnsiUpperCase(newName);

   lowerCase: if AplicarTrim Then
        Result:= Trim(AnsiLowerCase(newName))
      else
        Result:= AnsiLowerCase(newName);
   end;
end;

constructor TArquivoTexto.create(var objDiretorio: TDiretorio; Arquivo: String; modo: TModoDeAberturaDeArquivo= leitura);
Var
//  objPath  : TDiretorio;
  sArquivo : String;
  MSG      : String;
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
  *)
  try

    __NumeroDeLinhasLidas__   := 0;
    __NumeroDeLinhasGravadas__:= 0;

    __modo__:= modo;

    //objPath:= TDiretorio.create(ExtractFilePath(Arquivo));

    setPath(objDiretorio.getDiretorio());
    setArquivo(ExtractFileName(Arquivo));

    sArquivo:= Arquivo;

    if ArquivoEstaAberto() Then
    Begin
      AssignFile(__file__, sArquivo);
      case modo of
        escrita: Append(__file__);
        criacao: Rewrite(__file__);
        leitura:Begin
                 if FileExists(sArquivo) Then
                   Reset(__file__)
                 else
                   ShowMessage('O ACESSO AO ARQUIVO ' + Arquivo + ' ESTA NO MODO SOMENTE LEITURA POREM NAO EXISTE ');
                end;
      end;
    end
    else
      ShowMessage('ARQUVO ' + __nomeArquivo__ + ' NO PATH ' + __path__ + ' ESTA ABERTO POR ALGUMA APLICACAO ' +
                  #13 + 'FECHE A APLICACAO PRIMEIRO !!!');
  Except
    on E:Exception do
    begin
      MSG:=E.Message;
      ShowMessage(MSG);
    end;
  end;
end;

function TArquivoTexto.EscreverNoArquivo(Linha: String): Boolean;
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
  *)
  if (getModoDoArquivo() = escrita) or (getModoDoArquivo() = criacao) Then
  Begin
    WriteLn(__file__, Linha);
    __NumeroDeLinhasGravadas__ := __NumeroDeLinhasGravadas__ + 1;
    Result:= true;
  end
  else
  Begin
    ShowMessage('ARQUIVO ' + __nomeArquivo__ + ' ESTÁ EM MODO SOMENTE LEITURA' );
    Result:= false;
  end;
end;

function TArquivoTexto.ExtractName(): String;
var
aExt : String;
aPos : Integer;
begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
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
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
  *)
  __path__:=  Path;
end;

Procedure TArquivoTexto.setArquivo(const Filename: String);
Begin
(*
CRIADO POR: Eduardo C. M. Monteiro.

OBJETIVO:
*)
  __NomeArquivo__:= Filename;
end;

function TArquivoTexto.getPath(): String;
Begin
(*
CRIADO POR: Eduardo C. M. Monteiro.

OBJETIVO:
*)
  Result:= __path__;
end;

function TArquivoTexto.getArquivo(): String;
Begin
(*
CRIADO POR: Eduardo C. M. Monteiro.

OBJETIVO:
*)
  Result:= __nomeArquivo__;
end;

function TArquivoTexto.ArquivoEstaAberto(): Boolean;
var
   S        : TStream;
   sArquivo : String;
begin
(*
CRIADO POR: Eduardo C. M. Monteiro.

OBJETIVO:
*)
  Result := true;
  sArquivo:= getPath() + getArquivo();
  if FileExists(sArquivo) Then
  try
     try
         S := TFileStream.Create(sArquivo, fmOpenRead or fmShareExclusive);
     except
       on EStreamError do Result := False; // EFOpenError
     end;
  finally
     S.Free;
  end;
end;

function TArquivoTexto.FecharArquivo(): Boolean;
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
  *)
  try
    CloseFile(__file__);
    Result:= true;
  except
    ShowMessage('NÃO FOI POSSÍVEL FECHAR O ARQUIVO ' + __nomeArquivo__ + ' NO PATH ' + __path__ + ' !!!');
    Result:= false;
  end;
end;

function TArquivoTexto.getLinhasJaLidas(): Integer;
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
  *)
  Result:= __NumeroDeLinhasLidas__;
end;

function TArquivoTexto.getLinhasJaGravadas(): Integer;
Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
  *)
  Result:= __NumeroDeLinhasGravadas__;
end;

function TArquivoTexto.TrocarString(oldString, NewString: String; posicao: Integer=0; tamanho: Integer=0): String;
Var
   Parte: String;

Begin
  (*
  CRIADO POR: Eduardo C. M. Monteiro.

  OBJETIVO:
  *)
   if posicao = 0 then
     posicao:= 1;

   if tamanho = 0 then
     tamanho:= Length(__linha__);

   Result:= StringReplace(Copy(__linha__, posicao, tamanho), oldString, NewString, [rfReplaceAll, rfIgnoreCase]);
end;

end.
