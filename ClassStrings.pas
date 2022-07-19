Unit ClassStrings;

interface

  uses Windows, Classes, Dialogs, SysUtils, Forms, Controls, Graphics, WinSock, ShellAPI,
  math,
  StdCtrls, ComCtrls, udatatypes_apps, ClassLog;

Const                                    //        1                     2                         3                              4                        5                         6                                 7
   Produto_cartas: array[1..7] of String = ('CARTA DE COBRAN«A','CARTA DE REAJUSTE','CARTA DE QUITA«√O ANUAL DE D…BITOS', 'CARTA RESCISORIA', 'CARTA DE COBRANCA UNO', 'CARTA DE COBRANCA FAC CLARO', 'CARTA DE COBRAN«A AFP DIGITALPOST');

  type
    TFormataString= Class

      objLogar : TArquivoDelog;

      {Constroi a classe e massa os par‚metros iniciais}
      constructor create(Var objLogar: TArquivoDelog);

      {Obtem o termo de uma de acordo com o delimitador informado}
      function getTermo(APosicao: Integer; ASeparador,ALinha: String): String;

      {Retorna o numero de ocorrencias de um asubstring em uma string}
      function GetNumeroOcorrenciasCaracter(str: string; caracter: string): integer;

      {Ajusta a String dentro do espa√ßo informado colunando-a}
      function AjustaStr(str: String=''; tam: Integer=0; Inicio: Integer=0): String;

      {Substitui uma String por outra}
      function TrocarString(sString, oldString, newString: String): String;

      {Substitui uma lista de strings por outra}
      Function TrocaListaDeCaracteres(Linha: String; ListaDeCaracteres: String): String;
      
      {Converte String em Pchar}
      function StrToPChar(const Str: string): PChar;

      {Ajusta o Path de diretÛrios com barra no final.}
      Function AjustaPath(sPath : string; sOS: String = 'W'): string;

      {Ajusta o Path de diretÛrios com barra no final.}
      Function AjustaPathLinux(sPath : string): string;

      {Deleta a extens„o de um arquivo}
      Function TiraExtensaoDoArquivo(nome:string): string; {Sem_Exten}

      {Valida Email}
      Function ValidaEMail(const EMailIn: string):Boolean;

      {FormataStringNumerica}
      Function FormatFloatString(Format: String; sString: string):string;

      {Repete um char n vezes}
      function RepeteChar(str: char; tam: Integer=0): String;
	  
	    {Retorna um nÌvel no diretÛrio}
      Function RetornaNivelPath(Diretorio : String; nDiretorios : Integer): String;

      function  Completa(str: string; iTamDesejado: integer; Caracter: char; DireitaOuEsquerda: char): string;

      function  substituirCaracterNull(sString:String):String;

      function PreencheStrEsquerda ( str, sChar : String; tam: Integer ): String;
      function PreencheStrDireita ( str, sChar : String; tam: Integer ): String;

      {Substitui Caracter de fim de arquivo ante do fim de arquivo}
      procedure SubstituirCaracterNuloAntesdoEOF(nomeArquivo: string; substituirPelaString: string);

      {Substitui Caracter de fim de arquivo ante do fim de arquivo versao cid}
      function StringReplaceCharEndFileFromFile(fFile: string): Boolean;

      {Formata String decimal como 1.000,32 para formato de insercao no banco no campo double. SaÌda 1000.32}
      function FormataStrinfDecimalParaInsercaoNoBaco(Valor: String): String;

      {Carrega um arquivo em uma stringList}
      procedure LoadStringListFromFile(var sl: TStringList; filename: string);

      {LÍ um arquivo e retorna a string do arquivo}
      function FileToString(nomeArquivo: string): string;

      {Grava uma srting em arquivo}
      function StringToFile(sString: string; sFile: string; apagarArquivoSeExiste: boolean=false): boolean;

      {Grava uma string do arquivo}
      procedure GravarLinhaEmArquivo(nomeArquivo: widestring; linha: widestring);

      {Alerta para a substituiÁ„o manual do caracter <TAB> encontrado na linha}
      function SubstituiTabNaLinha(sString: String): String;

      {Retorna Dia}
      function getDia(data: TDateTime): string;

      {Retorna Mes}
      function getMes(data: TDateTime): string;

      {Retorna Ano}
      function getAno(data: TDateTime): string;

      {Converte uma String em Hexadecimal}
      function StrToHex(inp: String): String;

      {Faz escape de string para o banco}
      function EscaparStrings(texto: string): string;

      {Elimina todos os espaÁos da string}
      function AllTrim(str: string): string;

      {Converte boll para string true/false}
      function BooleanToStr(valorBooleano: boolean): string;

      //Leia mais em: Dicas - Removendo acentos de uma string http://www.devmedia.com.br/dicas-removendo-acentos-de-uma-string/933#ixzz39X202sKN
      function RemoveAcento(Str: string): string;

      function uppercase_acentos(strString: string; correcao_bug: boolean=true): string;

      Function StringReplaceList(LinhaDoArquivo: String; ListaDeCaracteresInvalidos: String): String;

      Function StringReplaceListEspeciaisBancoMysql(LinhaDoArquivo: String; ListaDeCaracteres: String): String;

      function  GetNumeroPossuiCasasDecimais(numero: double): boolean;
      function  Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;
      function  FloatToInt(numero: double): integer;

      function GetMesNumericoFromMesExtenso(mesExtenso: string): string;
      function GetMesExtensoFromMesNumerico(mesNumerico: string): string;

      function PadC(S:string;Len:byte):string;

      function getPastaOrigemArquivoStringPath(sPath: String;niveis: Integer=1): String;

      function StringContemSomenteNumeros(str: string): boolean;

      function IntToStrValida(iValor: Integer; var Erro : Boolean; ValorCaseErro: string='0'): string;

      function UTF8ParaAnsi(Linha: string): string;

      function getExtensaoArquivo(NomeArquivo: String): String;

      // CONVERTE ESPA«OS EM UM ESPA«O
      function ConverteEspacosEmUmEspaco(sString: String): string;

      
      function HexToInt(Hexadecimal : String) : Integer;

    end;

implementation

constructor TFormataString.create(Var objLogar: TArquivoDelog);
Begin
 objLogar := objLogar;
end;

function TFormataString.getTermo(APosicao: Integer; ASeparador,ALinha: String): String;
var
 sAux: TStringList;
begin
 Result:='';
 sAux:=TStringList.Create;
 sAux.Text:=StringReplace(ALinha,ASeparador,#13#10,[rfReplaceAll, rfIgnoreCase]);
 if APosicao <= sAux.Count then
   Result:=sAux.Strings[APosicao-1];
 sAux.Free;
end;

function TFormataString.GetNumeroOcorrenciasCaracter(str: string; caracter: string): integer;
var
  sTemp: string;
  sCharAtual: string;
  i, iTamString: integer;
  iContOcorrencias: integer;
begin
  iContOcorrencias:=0;
  sTemp := str;
  iTamString := length(sTemp);

  for i:=0 to iTamString-1 do
  begin
    sCharAtual := copy(str, i+1, 1);

    if sCharAtual = caracter then
      iContOcorrencias := iContOcorrencias + 1;
  end;

  result := iContOcorrencias;
end;

function TFormataString.AjustaStr ( str: String=''; tam: Integer=0; Inicio:Integer=0): String;
begin

  while Length ( str ) < tam do
    if Inicio = 0 then
      str := str + ' '
    else
      str := ' ' + str;

  if Length ( str ) > tam then
    str := Copy (str, 1, tam);

  Result := str;
end;

function TFormataString.RepeteChar(str: char; tam: Integer=0): String;
begin
  Result := StringOfChar(str, tam);
end;

function TFormataString.TrocarString(sString,oldString, newString: String): String;
Begin
  Result:= StringReplace(sString, oldString, newString, [rfIgnoreCase, rfReplaceAll]);
end;

function TFormataString.StrToPChar(const Str: string): PChar;
{Converte String em Pchar}
type
  TRingIndex = 0..7;
var
  Ring: array[TRingIndex] of PChar;
  RingIndex: TRingIndex;
  Ptr: PChar;
begin
  Ptr := @Str[length(Str)];
  Inc(Ptr);
  if Ptr^ = #0 then
  begin
  Result := @Str[1];
  end
  else
  begin
  Result := StrAlloc(length(Str)+1);
  RingIndex := (RingIndex + 1) mod (High(TRingIndex) + 1);
  StrPCopy(Result,Str);
  StrDispose(Ring[RingIndex]);
  Ring[RingIndex]:= Result;
  end;
end;

Function TFormataString.AjustaPath(sPath : string; sOS: String = 'W'): string;
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

Function TFormataString.AjustaPathLinux(sPath : string): string;
begin
  if length(sPath) > 0 then
    if sPath[length(sPath)] <> '/' then
      sPath :=  sPath + '/';

  Result := sPath;
end;

Function TFormataString.TiraExtensaoDoArquivo(nome:string):string;
Var
 aExt : String;
 aPos : Integer;
Begin
  aExt := ExtractFileExt(nome);
  nome := ExtractFileName(nome);
  if aExt <> '' then
    begin
      aPos := Pos(aExt,nome);
       if aPos > 0 then
         Delete(nome,aPos,Length(aExt));
    end;

  Result := nome;
end;

Function TFormataString.ValidaEMail(const EMailIn: string):Boolean;
const
  CaraEsp: array[1..40] of string[1] =
  ( '!','#','$','%','®','&','*',
  '(',')','+','=','ß','¨','¢','π','≤',
  '≥','£','¥','`','Á','«',',',';',':',
  '<','>','~','^','?','/','','|','[',']','{','}',
  '∫','™','∞');
var
  i,cont   : integer;
  EMail    : ShortString;
begin
  EMail := EMailIn;
  Result := True;
  cont := 0;
  if EMail <> '' then
    if (Pos('@', EMail)<>0) and (Pos('.', EMail)<>0) then    // existe @ .
    begin
      if (Pos('@', EMail)=1) or (Pos('@', EMail)= Length(EMail)) or (Pos('.', EMail)=1) or (Pos('.', EMail)= Length(EMail)) or (Pos(' ', EMail)<>0) then
        Result := False
      else                                   // @ seguido de . e vice-versa
        if (abs(Pos('@', EMail) - Pos('.', EMail)) = 1) then
          Result := False
        else
          begin
            for i := 1 to 40 do            // se existe Caracter Especial
              if Pos(CaraEsp[i], EMail)<>0 then
                Result := False;
            for i := 1 to length(EMail) do
            begin                                 // se existe apenas 1 @
              if EMail[i] = '@' then
                cont := cont + 1;                    // . seguidos de .
              if (EMail[i] = '.') and (EMail[i+1] = '.') then
                Result := false;
            end;
                                   // . no f, 2ou+ @, . no i, - no i, _ no i
            if (cont >=2) or ( EMail[length(EMail)]= '.' )
              or ( EMail[1]= '.' ) or ( EMail[1]= '_' )
              or ( EMail[1]= '-' )  then
                Result := false;
                                            // @ seguido de COM e vice-versa
            if (abs(Pos('@', EMail) - Pos('com', EMail)) = 1) then
              Result := False;
                                              // @ seguido de - e vice-versa
            if (abs(Pos('@', EMail) - Pos('-', EMail)) = 1) then
              Result := False;
                                              // @ seguido de _ e vice-versa
            if (abs(Pos('@', EMail) - Pos('_', EMail)) = 1) then
              Result := False;
          end;
    end
    else
      Result := False;
end;

Function TFormataString.FormatFloatString(Format: String; sString: string):string;
begin
  try
    Result := FormatFloat(Format, StrToInt(sString));
  except
    ShowMessage('ERRO AO CONVERTER A STRING ' + sString + ' NA FORMATA«√O ' + sString + ' - Function TFormataString.FormatFloatString(Format: String; sString: string):string;');
  end;
end;

function TFormataString.Completa(str: string; iTamDesejado: integer; Caracter: char;
 DireitaOuEsquerda: char): string;
var
  iTam: integer;
begin
  iTam := length(str);

  if DireitaOuEsquerda = 'D' then
    result := str + StringOfChar(Caracter,iTamDesejado-iTam)
  else
  if DireitaOuEsquerda = 'E' then
    result := StringOfChar(Caracter,iTamDesejado-iTam) + str;
end;

function TFormataString.substituirCaracterNull(sString:String):String;
var
  iTamString, i: integer;
  sCharAtual, sRetorno: string;
begin
  if pos(chr(0), sString) > 0 then // se tiver um caracter #0 (NULL)
  begin
    sRetorno := '';

    iTamString := length(sString);

    for i:=1 to iTamString do
    begin
      //Itera pela string, caracter por caracter
      sCharAtual :=  sString[i];

      if sCharAtual = chr(0) then
        sCharAtual := ' ';

      sRetorno := sRetorno + sCharAtual
    end;
  end;

  if sRetorno = '' then
    result := sString
  else
    result := sRetorno;
end;

function TFormataString.FormataStrinfDecimalParaInsercaoNoBaco(Valor: String): String;
Var
sValor : String;
begin

  // Exemplo
  // Entrada: 1.000,32
  // SaÌda: 1000.32

  sValor := StringReplace(Trim(Valor), '.', '', [rfReplaceAll, rfIgnoreCase]);
  sValor := StringReplace(Trim(sValor), ',', '.', [rfReplaceAll, rfIgnoreCase]);

  Result := sValor
end;

function TFormataString.GetMesNumericoFromMesExtenso(mesExtenso: string): string;
var
  sMesNumerico: string;
  sMesExtenso: string;
begin
  {Ex. de entrada: JANEIRO, dezembro
   Ex. de retorno: 01, 12}


  sMesNumerico := '?';

  sMesExtenso := AnsiUpperCase(mesExtenso);

  if sMesExtenso = 'JANEIRO' then sMesNumerico := '01'
  else
  if sMesExtenso = 'FEVEREIRO' then sMesNumerico := '02'
  else
  if (sMesExtenso = 'MARCO') or (sMesExtenso = 'MAR«O') then sMesNumerico := '03'
  else
  if sMesExtenso = 'ABRIL' then sMesNumerico := '04'
  else
  if sMesExtenso = 'MAIO' then sMesNumerico := '05'
  else
  if sMesExtenso = 'JUNHO' then sMesNumerico := '06'
  else
  if sMesExtenso = 'JULHO' then sMesNumerico := '07'
  else
  if sMesExtenso = 'AGOSTO' then sMesNumerico := '08'
  else
  if sMesExtenso = 'SETEMBRO' then sMesNumerico := '09'
  else
  if sMesExtenso = 'OUTUBRO' then sMesNumerico := '10'
  else
  if sMesExtenso = 'NOVEMBRO' then sMesNumerico := '11'
  else
  if sMesExtenso = 'DEZEMBRO' then sMesNumerico := '12';

  result := sMesNumerico;
end;

function TFormataString.GetMesExtensoFromMesNumerico(mesNumerico: string): string;
var
  sMesNumerico: string;
  sMesExtenso: string;
begin
  {Ex. de entrada: 01, 12
   Ex. de retorno: JANEIRO, DEZEMBRO}

  sMesExtenso := '?';

  sMesNumerico := mesNumerico;
  if length(sMesNumerico) = 1 then
    sMesNumerico := '0' + sMesNumerico;

  if sMesNumerico = '01' then sMesExtenso := 'JANEIRO'
  else
  if sMesNumerico = '02' then sMesExtenso := 'FEVEREIRO'
  else
  if sMesNumerico = '03' then sMesExtenso := 'MAR«O'
  else
  if sMesNumerico = '04' then sMesExtenso := 'ABRIL'
  else
  if sMesNumerico = '05' then sMesExtenso := 'MAIO'
  else
  if sMesNumerico = '06' then sMesExtenso := 'JUNHO'
  else
  if sMesNumerico = '07' then sMesExtenso := 'JULHO'
  else
  if sMesNumerico = '08' then sMesExtenso := 'AGOSTO'
  else
  if sMesNumerico = '09' then sMesExtenso := 'SETEMBRO'
  else
  if sMesNumerico = '10' then sMesExtenso := 'OUTUBRO'
  else
  if sMesNumerico = '11' then sMesExtenso := 'NOVEMBRO'
  else
  if sMesNumerico = '12' then sMesExtenso := 'DEZEMBRO';

  result := sMesExtenso;
end;

function TFormataString.FileToString(nomeArquivo: string): string;
var
  sConteudoArquivo : string;
  slArquivo        : TStringList;
begin
  sConteudoArquivo := '';
  try
    slArquivo := TStringList.Create;
    LoadStringListFromFile(slArquivo, nomeArquivo);
    sConteudoArquivo :=  slArquivo.Text;
  finally
    slArquivo.Clear;
    if Assigned(slArquivo) then
      FreeAndNil(slArquivo);
  end;
  result := sConteudoArquivo;
end;

procedure TFormataString.LoadStringListFromFile(var sl: TStringList; filename: string);
var
  arq: TextFile;
  sLinha: string;
  iContLinhas: integer;
begin

  try

    try

      AssignFile(arq, filename);
      Reset(arq);

      iContLinhas := 0;

      while not EOF(arq) do
      begin
        readln(arq, sLinha);

        iContLinhas := iContLinhas + 1;

        if pos(#0, sLinha) > 0 then
          objLogar.Logar('uFuncoes - LoadStringListFromFile_SafeWay() - ' + 'Arquivo "' + filename + '" contÈm caracter nulo (#0). Linha: '+inttostr(iContLinhas));

        sl.Add(sLinha);
      end;

    except
      on E:Exception do
        objLogar.Logar('uFuncoes - LoadStringListFromFile_SafeWay() - Arquivo: "' + filename+'" + #13 + ExceÁ„o: "'+E.Message+'"');
    end;

  finally
    CloseFile(arq);
  end;

end;

procedure TFormataString.GravarLinhaEmArquivo(nomeArquivo: widestring; linha: widestring);
var
  arq: TextFile;
begin

  try
    AssignFile(arq, nomeArquivo);

    if FileExists(nomeArquivo) then
      Append(arq)
    else
      Rewrite(arq);

    writeln(arq, linha);

    CloseFile(arq);
  except
    on E:Exception do
      objLogar.Logar('GravarLinhaEmArquivo() - ExceÁ„o: '+E.Message);
  end;
end;

function TFormataString.StringToFile(sString: string; sFile: string;
 apagarArquivoSeExiste: boolean=false): boolean;
var
  slFile: TStringList;
  bSucesso: boolean;
begin
  bSucesso := true;

  if apagarArquivoSeExiste then
    DeleteFile(sFile);

  try
    try
      slFile := TStringList.Create;

      slFile.Add(sString);

      slFile.SaveToFile(sFile);
    except
      on E:Exception do
      begin
        bSucesso := false;
        objLogar.Logar('N„o foi possÌvel gravar o arquivo "'+sFile+'". ExceÁ„o: '+E.Message);
      end;
    end;
  finally
    if Assigned(slFile) then
      FreeAndNil(slFile);
  end;

  result := bSucesso;
end;

function TFormataString.GetNumeroPossuiCasasDecimais(numero: double): boolean;
var
  sNumero: string;
begin
  sNumero := FloatToStr(numero);

  if pos(',', sNumero) = 0 then
    result := false
  else
    result := true;
end;

function TFormataString.Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;
var
  Valor1,
  Numero1,
  Numero2,
  Numero3: Double;
  bJahArredondou: boolean;
begin
  Valor1:=Exp(Ln(10) * (Dec + 1));
  Numero1:=Int(Valor * Valor1);
  Numero2:=(Numero1 / 10);

  Numero3:=Round(Numero2);

  if Numero3 <= trunc(Valor) then
  begin
    //Arredondamento opcional para cima quando n„o tiver casas decimais apÛs a vÌrgula
    if (Dec=0) and (ParaCima) then
      Numero3 := Numero3 + 1;
  end;    

  Result:=(Numero3 / (Exp(Ln(10) * Dec)));
end;

function TFormataString.FloatToInt(numero: double): integer;
var
  iRetorno : integer;
  sNumero  : string;
begin
  sNumero  := floattostr(numero);
  iRetorno := strtointdef(sNumero, 0);

  result := iRetorno;
end;

//Alerta para a substituiÁ„o manual do caracter <TAB> encontrado na linha
function TFormataString.SubstituiTabNaLinha(sString: String): String;
var
  TMP: string;
  iPosCharTab : Integer;
begin
  iPosCharTab := pos(#9,sString);
  if iPosCharTab > 0 then
  begin
    TMP := StringReplace(sString, #9, ' ', [rfReplaceAll, rfIgnoreCase]);
    objLogar.Logar('  > Linha '+ sString + ': CARACTER INV¡LIDO <TAB> NA LINHA. Coluna: '+inttostr(iPosCharTab) + '.');
  end
  else
    TMP := sString;

    Result := TMP;
end;

function TFormataString.StrToHex(inp: String): String;
var
  i     : Integer;
  cStr  : String;
begin
  for i:= 1 to Length(inp) do
    cStr:= cStr + IntToHex(Ord(inp[i]), 2) + ' ';
  Result:= cStr;
end;

function TFormataString.getDia(data: TDateTime): string;
var
  wDia : Word;
  wMes : Word;
  wAno : Word;
begin
  DecodeDate(data, wAno, wMes, wDia);
  Result := IntToStr(wDia);
end;

function TFormataString.getMes(data: TDateTime): string;
var
  wDia : Word;
  wMes : Word;
  wAno : Word;
begin
  DecodeDate(data, wAno, wMes, wDia);
  Result := IntToStr(wMes);
end;

function TFormataString.getAno(data: TDateTime): string;
var
  wDia : Word;
  wMes : Word;
  wAno : Word;
begin
  DecodeDate(data, wAno, wMes, wDia);
  Result := IntToStr(wAno);
end;

Function TFormataString.RetornaNivelPath(Diretorio : String; nDiretorios : Integer): String;
var
 iCont : Integer;
 dir                       : string;
 iUltimaPosicaoDelimitador : integer;
Begin
  //Retona um nÌvel
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

Function TFormataString.TrocaListaDeCaracteres(Linha: String; ListaDeCaracteres: String): String;
Var
  iContLetras              : Integer;
  iContCaracteresInvalidos : Integer;
  sLinhaTemp               : String;
  sTipo                    : String;
  sCaracter                : String;
Begin

  sTipo := copy(Linha, 1, 2);
  for iContLetras := 1 to length(Linha) do
    if pos(#0, Linha[iContLetras]) > 0 then
      Linha[iContLetras] := ' ';

  for iContLetras := 1 to length(Linha) do
    if pos(#9, Linha[iContLetras]) > 0 then
      Linha[iContLetras] := ' ';

  for iContCaracteresInvalidos := 1 to GetNumeroOcorrenciasCaracter(ListaDeCaracteres, ',') + 1 do
  Begin
    sCaracter  := getTermo(iContCaracteresInvalidos, ',', ListaDeCaracteres);
    sLinhaTemp := StringReplace(Linha, sCaracter , ' ', [rfReplaceAll, rfIgnoreCase]);
    if AnsiCompareStr(Linha, sLinhaTemp) <> 0 then
      Linha := sLinhaTemp;
  End;
  Result := Linha;
End;

Function TFormataString.StringReplaceList(LinhaDoArquivo: String; ListaDeCaracteresInvalidos: String): String;
Var
  iContLetras              : Integer;
  iContCaracteresInvalidos : Integer;
  sLinhaTemp               : String;
  sTipo                    : String;
  sCaracter                : String;
Begin

  for iContLetras := 1 to length(LinhaDoArquivo) do
    if pos(#0, LinhaDoArquivo[iContLetras]) > 0 then
      LinhaDoArquivo[iContLetras] := ' ';

  for iContLetras := 1 to length(LinhaDoArquivo) do
    if pos(#9, LinhaDoArquivo[iContLetras]) > 0 then
      LinhaDoArquivo[iContLetras] := ' ';

  for iContCaracteresInvalidos := 1 to GetNumeroOcorrenciasCaracter(ListaDeCaracteresInvalidos, ',') + 1 do
  Begin

    sCaracter  := getTermo(iContCaracteresInvalidos, ',', ListaDeCaracteresInvalidos);
    sLinhaTemp := StringReplace(LinhaDoArquivo, sCaracter , ' ', [rfReplaceAll, rfIgnoreCase]);

    if AnsiCompareStr(LinhaDoArquivo, sLinhaTemp) <> 0 then
      LinhaDoArquivo := sLinhaTemp;

  End;
  Result := LinhaDoArquivo;
End;

Function TFormataString.StringReplaceListEspeciaisBancoMysql(LinhaDoArquivo: String; ListaDeCaracteres: String): String;
Var
  iContLetras              : Integer;
  iContCaracteres          : Integer;
  sLinhaTemp               : String;
  sTipo                    : String;
  sCaracter                : String;
Begin

  for iContLetras := 1 to length(LinhaDoArquivo) do
    if pos(#0, LinhaDoArquivo[iContLetras]) > 0 then
      LinhaDoArquivo[iContLetras] := ' ';

  for iContLetras := 1 to length(LinhaDoArquivo) do
    if pos(#9, LinhaDoArquivo[iContLetras]) > 0 then
      LinhaDoArquivo[iContLetras] := ' ';

  for iContCaracteres := 1 to GetNumeroOcorrenciasCaracter(ListaDeCaracteres, ',') + 1 do
  Begin

    sCaracter  := getTermo(iContCaracteres, ',', ListaDeCaracteres);
    sLinhaTemp := StringReplace(LinhaDoArquivo, sCaracter , '\' + sCaracter  , [rfReplaceAll, rfIgnoreCase]);

    if AnsiCompareStr(LinhaDoArquivo, sLinhaTemp) <> 0 then
      LinhaDoArquivo := sLinhaTemp;

  End;
  Result := LinhaDoArquivo;

End;


function TFormataString.EscaparStrings(texto: string): string;
var
  sRetorno: string;
begin
  sRetorno := texto;

  sRetorno := StringReplace(sRetorno,'\' ,'\\',[rfReplaceAll]);
  sRetorno := StringReplace(sRetorno,'"' ,'\"',[rfReplaceAll]);
  sRetorno := StringReplace(sRetorno,'''' ,'\''',[rfReplaceAll]);

  result := sRetorno;
end;

function TFormataString.AllTrim(str: string): string;
begin
  result := StringReplace(str, ' ', '', [rfReplaceAll]);
end;


function TFormataString.RemoveAcento(Str: string): string;
const
  ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸¿¬ ‘€√’¡…Õ”⁄«‹';
  SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
var
   x: Integer;
begin;
  for x := 1 to Length(Str) do
    if Pos(Str[x],ComAcento) <> 0 then
      Str[x] := SemAcento[Pos(Str[x], ComAcento)];

  Result := Str;
end;

function TFormataString.uppercase_acentos(strString: string; correcao_bug: boolean=true): string;
const
  sMaiusculas = '«¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€ƒÀœ÷‹√’—';
  sMinusculas = 'Á·ÈÌÛ˙‡ËÏÚ˘‚ÍÓÙ˚‰ÎÔˆ¸„ıÒ';
var
  x : integer;
begin
  if correcao_bug then
    result := AnsiUppercase(strString)
  else
  begin
    for x := 1 to length(strString) do
    begin
      if pos(strString[x], sMinusculas) <> 0 then
        strString[x] := sMaiusculas[pos(strString[x], sMinusculas)]
    end;
    result := uppercase(strString);
  end;

end;

function TFormataString.BooleanToStr(valorBooleano: boolean): string;
begin
  if valorBooleano = true then
    result := 'TRUE'
  else
    result := 'FALSE';
end;

procedure TFormataString.SubstituirCaracterNuloAntesdoEOF(nomeArquivo: string; substituirPelaString: string);
var
  sConteudoArquivo: string;
  bPossui: boolean;
  iTotalOcorrencias: integer;
  sArquivoTemp: string;
  sNovaString: string;
  sCaracterAtual: string;
  i: integer;
begin
  bPossui := true;

  sConteudoArquivo := FileToString(nomeArquivo);

  //iTotalOcorrencias := GetTotalOcorrenciasSubstringEmString(sConteudoArquivo, #0);
  iTotalOcorrencias := GetNumeroOcorrenciasCaracter(sConteudoArquivo, #0);

  sNovaString := '';

  if iTotalOcorrencias > 0 then
  begin
    for i:=1 to length(sConteudoArquivo) do
    begin
      sCaracterAtual := sConteudoArquivo[i];

      if sCaracterAtual = #0 then
      begin
        sCaracterAtual := substituirPelaString;

        objLogar.Logar('uFuncoes - SubstituirCaracterNuloAntesdoEOF() - '
                     + 'Encontrado caracter NULO (NUL - #0) no arquivo "'+nomeArquivo+'".'
                     + ' SubstituÌdo por "'+substituirPelaString+'".');
      end;

      sNovaString := sNovaString + sCaracterAtual;
    end;

    sConteudoArquivo := sNovaString;
  end;

  StringToFile(sConteudoArquivo, nomeArquivo, true);
  sConteudoArquivo := '';
end;

function TFormataString.StringReplaceCharEndFileFromFile(fFile: string): Boolean;
var
  sPath      : string;
  sFile      : string;
  sFileTMP   : string;
  Arquivo    : TFileStream;
  ArquivoOut : TFileStream;
  cChar      : char;
begin

  // Remove caracteres do arquivos
  // PrÛprio para substituiÁ„o de caracteres de fim dearquivo no meio do arquivo;

  sPath    := ExtractFilePath(fFile);
  sFile    := ExtractFileName(fFile);
  sFileTMP := sFile + '.TMP';

  Arquivo    := TFileStream.Create(sPath + sFile,fmOpenRead);
  ArquivoOut := TFileStream.Create(sPath + sFileTMP,fmCreate);

  while Arquivo.Read(cChar, SizeOf(1)) > 0 do
  begin

    if (cChar = #0) or ((cChar = #26)) then
      cChar := ' ';

    ArquivoOut.Write(cChar, sizeof(1));

  end;

  Arquivo.Free;
  ArquivoOut.Free;

  DeleteFile(StrToPChar(sPath + sFile));
  CopyFile(StrToPChar(sPath + sFileTMP), StrToPChar(sPath + sFile), True);
  DeleteFile(StrToPChar(sPath + sFileTMP));

end;

function TFormataString.PadC(S:string;Len:byte):string;
var
 Str:String;
 L:byte;
begin
  str :='';
  if len < Length(s) then
  begin
    Result := '';
    Exit;
  end;

  l:=(Len-Length(S)) div 2;

  while l > 0 do
  begin
    str := str + ' ';
    dec(l);
  end;

  for l:=1 to length(S) do
    str := str+s[L];

 Result := str;

end;

function TFormataString.getPastaOrigemArquivoStringPath(sPath: String;niveis: Integer=1): String;
var
  iContNiveis    : integer;
  iTotalDeNiveis : Integer;

  iContNiveisLidos : Integer;

  sResult        : string;

begin
  iTotalDeNiveis := GetNumeroOcorrenciasCaracter(sPath, PathDelim);

  sResult          := '';
  iContNiveisLidos := 0;

  for iContNiveis := 0 to iTotalDeNiveis do
  begin

    if ( (iTotalDeNiveis - iContNiveisLidos) + 1 ) <= niveis then
      sResult := sResult + PathDelim + getTermo(iContNiveis +1 , PathDelim ,sPath);

    iContNiveisLidos := iContNiveisLidos + 1;
  end;

  sResult := '..' + sResult;

  Result := sResult

end;

function TFormataString.StringContemSomenteNumeros(str: string): boolean;
Var
  iTamanhoDaLinha                      : Integer;
  iContCaracteres                      : Integer;
  cCaracter                            : Char;
  bResult                              : Boolean;
begin

  iTamanhoDaLinha                      := Length(str);
  iContCaracteres                      := 0;
  bResult                              := False;

  try

    if iTamanhoDaLinha > 0 then
    begin
      while iContCaracteres <= (iTamanhoDaLinha - 1) do
      begin
        cCaracter := str[iContCaracteres+1];
        StrToInt(cCaracter);
        iContCaracteres := iContCaracteres + 1;
      end;
      bResult := True;
    end;
    
  except
    bResult := False;
  end;

  Result := bResult;

end;

function TFormataString.IntToStrValida(iValor: Integer; var Erro : Boolean; ValorCaseErro: string='0'): string;
var
  sValor : string;
begin

  try
    sValor := IntToStr(iValor);
    Erro   := True;
  except
    sValor := '0';
    Erro   := False;
  end;
  Result := sValor;
end;

function TFormataString.UTF8ParaAnsi(Linha: string): string;
Var
  sNewLinha                            : string;
  iTamanhoDaLinha                      : Integer;
  iContCaracteres                      : Integer;

  cCaracter       : Char;

begin

  iTamanhoDaLinha                      := Length(Linha);
  iContCaracteres                      := 0;

  sNewLinha := '';
  while iContCaracteres <= (iTamanhoDaLinha - 1) do
  begin

    cCaracter := Linha[iContCaracteres+1];
    sNewLinha := sNewLinha + UTF8ToAnsi(cCaracter);

    iContCaracteres := iContCaracteres + 1;
  end;

  Result := sNewLinha;

end;

function TFormataString.ConverteEspacosEmUmEspaco(sString: String): string;
var
  newString                    : string;
  iCont                        : Integer;
  iTotal                       : Integer;
begin

  newString := sString;

  iTotal := Length(sString);

  for iCont := 0 to iTotal -1 do
    newString := StringReplace(newString, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);


  Result := Trim(newString);

end;

function TFormataString.getExtensaoArquivo(NomeArquivo: String): String;
Var
  iOcorrencias : Integer;
begin

  iOcorrencias := GetNumeroOcorrenciasCaracter(NomeArquivo, '.');
  Result := '.' + getTermo(iOcorrencias+1, '.', NomeArquivo);

end;

function TFormataString.HexToInt(Hexadecimal : String) : Integer;
begin
  Result := StrToInt('$' + Hexadecimal);
end;

function TFormataString.PreencheStrEsquerda ( str, sChar : String; tam: Integer ): String;
begin
  while Length ( str ) < tam do
    str := sChar+str ;

  if Length ( str ) > tam then
    str := Copy ( str, 1, tam );

  Result := str;
end;

function TFormataString.PreencheStrDireita ( str, sChar : String; tam: Integer ): String;
begin
  while Length ( str ) < tam do
    str := str+sChar ;

  if Length ( str ) > tam then
    str := Copy ( str, 1, tam );

  Result := str;
end;

End.
