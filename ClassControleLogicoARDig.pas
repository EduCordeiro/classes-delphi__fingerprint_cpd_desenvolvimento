unit ClassControleLogicoARDig;
interface
  uses Classes, Dialogs, SysUtils, ZDataset, ZConnection,

  ClassMySqlBases, ClassStrings;
type

  TCNTLARDIG = class
    private

      objConexao                                : TMysqlDatabase;
      __queryMySQL_processamento__              : TZQuery;

      __data_postagem__                         : string;
      __data_processamento__                    : string;

      __DiaProcessamento__                      : string;
      __MesProcessamento__                      : string;
      __AnoProcessamento__                      : string;

      __Produto__                               : string;
      __LoteInicial__                           : String;
      __LoteFinal__                             : String;

      __dias_para_postagem_apos_processamento__ : string;

	    __Tabela_CNTL__                           : string;
      __TabelaCNTLConf__                        : String;

      __UltimoLoteUsado__                       : string;

      __LoteASerUsado__                         : string; //__ProximoLote__
      __UltimoLote__                            : string;

      __LotesValidosParaGravarAposProcessamento__  : TStringList;

      function VerificaDisponibilidadeLote(NumeroLote: string): Boolean;
      function AdicionarLoteNaMemoria(cntl, data_processamento, data_postagem, produto: string): Boolean;

    public

      __FaixaExcecao__                 : TStringList;

      function setDataPostagem(DataPostagem: String): Boolean;
      function setDataProcessamento(DataProcessamento: String): Boolean;
      function getIntervaloFaixaASerUsada(): string;
      function getLoteAtual(): string;
      function getUltimoLote(Produto : String): string;
      function getUltimaPostagem(Produto : String): string;
      function IncrementarLote(): string;
      function ValidaDaDePostagem(DataPostagem: string): Boolean;

      procedure LimparLoteNaMemoria();
      function AdicionarLote(Lote:String): Boolean;
      function GravaLotesDaMemoriaNaTabela(): Boolean;
      //
      function getFaixaDeLoteInicial(Produto: String): string;
      function getFaixaDeLoteFinal(Produto: String): string;

      function getLotesAdicionados(): Integer;

      Function DigitoVerificadorDoNumeroDeRegistro(sNumeroDeRegistro:String):String;

      // VERSÃO INTERNET
      function DigitoMod11ECT(Numero: String): String;

      //
      constructor create(Conexao                                   : TMysqlDatabase;
                         produto                                   : string;
                         tabela_cntl                               : string;
                         tabela_cntl_conf                          : string;
                         dias_para_postagem_apos_processamento     : string='1');

  end;
implementation
//uses Math;


constructor TCNTLARDIG.create(Conexao                                   : TMysqlDatabase;
                              produto                                   : string;
                              tabela_cntl                               : string;
                              tabela_cntl_conf                          : string;
                              dias_para_postagem_apos_processamento     : string='1');
begin

  objConexao                                   := Conexao;
  __Tabela_CNTL__                              := tabela_cntl;
  __TabelaCNTLConf__                           := tabela_cntl_conf;
  __Produto__                                  := produto;
  __LoteInicial__                              := getFaixaDeLoteInicial(__Produto__);
  __LoteFinal__                                := getFaixaDeLoteFinal(__Produto__);

  __UltimoLote__                               := getUltimoLote(__Produto__);

  __dias_para_postagem_apos_processamento__    := dias_para_postagem_apos_processamento;
  __LoteASerUsado__                            := FormatFloat('00000000', StrToInt(__UltimoLote__) + 1);
  __FaixaExcecao__                             := TStringList.Create();
  __LotesValidosParaGravarAposProcessamento__  := TStringList.Create();
  __FaixaExcecao__.Clear;
  __LotesValidosParaGravarAposProcessamento__.Clear;
end;

function TCNTLARDIG.getUltimoLote(Produto : String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT ultimo_lote_usado from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento__, sComando, 2);

  if (__queryMySQL_processamento__.RecordCount <= 0) or (__queryMySQL_processamento__.FieldByName('ultimo_lote_usado').AsString = '') then
    Result := __LoteInicial__
  else
    Result := FormatFloat('00000000', StrToInt(__queryMySQL_processamento__.FieldByName('ultimo_lote_usado').AsString)) ;

end;

function TCNTLARDIG.getLoteAtual(): string;
begin
  Result := __LoteASerUsado__;
end;


function TCNTLARDIG.getUltimaPostagem(Produto : String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT ultimo_postagem from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento__, sComando, 2);

  Result := FormatDateTime('DD/MM/YYYY', __queryMySQL_processamento__.FieldByName('ultimo_postagem').AsDateTime);

end;

function TCNTLARDIG.VerificaDisponibilidadeLote(NumeroLote: string): Boolean;
var
  iContLotesNaFaixaDeSeguranca: Integer;
begin
  Result := true;
  for iContLotesNaFaixaDeSeguranca := 0 to __FaixaExcecao__.Count - 1 do
    if StrToInt(__FaixaExcecao__.Strings[iContLotesNaFaixaDeSeguranca]) = StrToInt(NumeroLote) then
      Result := False;
end;

function TCNTLARDIG.IncrementarLote(): string;
begin

  Repeat

    if StrToInt(__LoteASerUsado__) > 0 then
      __LoteASerUsado__ := FormatFloat('00000000', StrToInt(__LoteASerUsado__) + 1);

    if StrToInt(__LoteASerUsado__) = 0 then
      __LoteASerUsado__ := FormatFloat('00000000', StrToInt(__UltimoLoteUsado__) + 1);

    if StrToInt(__LoteASerUsado__) < 0 then
      Exit;

  Until VerificaDisponibilidadeLote(__LoteASerUsado__);

  begin

    if (StrToInt(__LoteInicial__) > StrToInt(__LoteASerUsado__)) or
       (StrToInt(__LoteFinal__)   < StrToInt(__LoteASerUsado__)) then
      __LoteASerUsado__ := '-1';

  end;
  Result := __LoteASerUsado__;

end;

function TCNTLARDIG.AdicionarLote(Lote:String): Boolean;
begin
  AdicionarLoteNaMemoria(__LoteASerUsado__, __data_processamento__, __data_postagem__, __Produto__);
end;

function TCNTLARDIG.ValidaDaDePostagem(DataPostagem: string): Boolean;
var
  dDataFacInformada   : Double;
  dDataAtual          : Double;
begin

  try
    Result := True;
    dDataFacInformada := StrToDateTime(DataPostagem);
    dDataAtual        := StrToDateTime(FormatDateTime('dd/mm/yyyy', StrToDate(__data_processamento__)));
    if dDataFacInformada < dDataAtual + StrToInt(__dias_para_postagem_apos_processamento__) then
    Begin
      ShowMessage('Data FAC deve ser maior que a data atual + ' + __dias_para_postagem_apos_processamento__ + ' dias');
      Result := false;
    end;
  except
    ShowMessage('ERROS OCORRERAM AO CONVERTER A DATA  + ' + DataPostagem);
    Result := false;
  end;

end;

function TCNTLARDIG.setDataPostagem(DataPostagem: String): Boolean;
var
  wAno: Word;
  wMes: Word;
  wDia: Word;
  bDataValida: Boolean;
begin

  if ValidaDaDePostagem(DataPostagem) then
  begin
    __data_postagem__ := DataPostagem;
    // Pega da data de postagem
    DecodeDate(StrToDate(__data_postagem__), wAno, wMes, wDia);
    bDataValida:= True;
  end
  else
    bDataValida:= False;

  Result := bDataValida;
  
end;

function TCNTLARDIG.setDataProcessamento(DataProcessamento: String): Boolean;
var
  wDiaProcessamento : word;
  wMesProcessamento : word;
  wAnoProcessamento : word;
begin

  __data_processamento__ := DataProcessamento;

  DecodeDate(StrToDate(__data_processamento__), wAnoProcessamento, wMesProcessamento, wDiaProcessamento);

  __DiaProcessamento__ := FormatFloat('00', wDiaProcessamento);
  __MesProcessamento__ := FormatFloat('00', wMesProcessamento);
  __AnoProcessamento__ := FormatFloat('0000', wAnoProcessamento);

end;

function TCNTLARDIG.AdicionarLoteNaMemoria(cntl, data_processamento, data_postagem, produto: string): Boolean;
var
  sDataProcessamento : string;
  sDataPostagem : string;
begin

  sDataProcessamento := FormatDateTime('YYYY-MM-DD', StrToDate(data_processamento));
  sDataPostagem      := FormatDateTime('YYYY-MM-DD', StrToDate(data_postagem));

  __LotesValidosParaGravarAposProcessamento__.Add('"' + cntl + '","' + sDataProcessamento + '", "' + sDataPostagem + '", "' + produto + '"');
end;

procedure TCNTLARDIG.LimparLoteNaMemoria();
begin
  __LotesValidosParaGravarAposProcessamento__.Clear;
end;

function TCNTLARDIG.getLotesAdicionados(): Integer;
begin
  Result := __LotesValidosParaGravarAposProcessamento__.Count;
end;

function TCNTLARDIG.GravaLotesDaMemoriaNaTabela(): Boolean;
Var
  sComando : string;
  iContLotes: Integer;
  sUltimoLoteUsado : String;

  bOk : Boolean;
  sMSG : string;
begin
  try

    bOk  := False;
    sMSG := '';
    sUltimoLoteUsado := FormatFloat('00000000', StrToInt(__LoteASerUsado__) - 1);

    if StrToInt(sUltimoLoteUsado) <> -1 then
    begin

      bOk := True;
      for iContLotes := 0 to __LotesValidosParaGravarAposProcessamento__.Count - 1 do
      begin

        try

          sComando :=  'insert into ' + __Tabela_CNTL__ + ' (cntl, data_processamento, data_postagem, produto) '
                     + ' values(' + __LotesValidosParaGravarAposProcessamento__.Strings[iContLotes] + ')';
          objConexao.Executar_SQL(__queryMySQL_processamento__, sComando, 1);



        except
          bOk := False;
        end;

      end;

      if bOk then
      begin
        sComando :=  'update ' + __TabelaCNTLConf__
                   + ' set ultimo_lote_usado = ' + sUltimoLoteUsado + ','
                   + '     ultima_postagem   = "' + FormatDateTime('YYYY-MM-DD', StrToDate(__data_postagem__)) + '" '
                   + ' where produto = ' + __Produto__;
        objConexao.Executar_SQL(__queryMySQL_processamento__, sComando, 1);
      end;

    end
    else
      ShowMessage('ERROS OCORRERAM GERAR O LOTE: ' + sUltimoLoteUsado + #13
                + 'ETAPA: function TCNTLARDIG.GravaLotesDaMemoriaNaTabela(Produto: String): Boolean' + #13
                + 'NENHUM LOTE ATUALIZADO.');

    LimparLoteNaMemoria();

    Result := bOk;

  except
    on E:Exception do
    begin
      ShowMessage('ERROS OCORRERAM AO GRAVAR NA TABELA ' + __Tabela_CNTL__ + #13
                + 'LOTE: ' + __Tabela_CNTL__ + #13
                + 'ETAPA: function TCNTLARDIG.GravaLotesDaMemoriaNaTabela(Produto: String): Boolean' + #13
                + E.Message);
      Result := bOk;
    end;
  end;

end;


function TCNTLARDIG.getIntervaloFaixaASerUsada(): string;
begin

end;

function TCNTLARDIG.getFaixaDeLoteInicial(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_lote_inicial from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento__, sComando, 2);

  Result := __queryMySQL_processamento__.FieldByName('faixa_lote_inicial').AsString;

end;

function TCNTLARDIG.getFaixaDeLoteFinal(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_lote_final from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento__, sComando, 2);

  Result := __queryMySQL_processamento__.FieldByName('faixa_lote_final').AsString;

end;

function TCNTLARDIG.DigitoVerificadorDoNumeroDeRegistro(sNumeroDeRegistro: String): String;
var
 sFatorMultiplicacao       : string;

 iDigitoDoNumeroDeRegistro     : Integer;
 iDigitoDoFatorDeMultiplicacao : Integer;
 iDigitoVerificador            : Integer;

 iContNumerosDoRegistro    : Integer;
 iContFatorDeMultiplicacao : integer;

 iResto                    : Integer;
 iDividendo                : Integer;
 iDivisor                  : Integer;
 iQuociente                : Integer;
 sUnidade                  : Integer;

begin

  iDividendo          := 0;
  iDivisor            := 11;
  Result              := '-1';
  sFatorMultiplicacao := '86423597';
  sNumeroDeRegistro   := StringReplace(sNumeroDeRegistro, ' ', '', [rfReplaceAll, rfIgnoreCase]);

  if Length(sNumeroDeRegistro) = 8 then
  begin

    for iContNumerosDoRegistro := 0 to Length(sFatorMultiplicacao) - 1 do
    begin

      try
        iDigitoDoNumeroDeRegistro     := StrToInt(Copy(sNumeroDeRegistro,   iContNumerosDoRegistro + 1, 1));
        iDigitoDoFatorDeMultiplicacao := StrToInt(Copy(sFatorMultiplicacao, iContNumerosDoRegistro + 1, 1));

        iDividendo := iDividendo + (iDigitoDoNumeroDeRegistro *  iDigitoDoFatorDeMultiplicacao);

      except
        ShowMessage('ERRO AO CONVERTER A POSICAO ' + IntToStr(iContNumerosDoRegistro)
                  + ' PARA O VALOR ' + Copy(sFatorMultiplicacao, iContNumerosDoRegistro + 1, 1));
        iDigitoVerificador := -1;
        Exit;

      end;
      
    end;

    try

      iQuociente := iDividendo div iDivisor;
      iResto     := iDividendo mod iDivisor;

      if iResto = 0 then
        iDigitoVerificador := 5
      else
      if iResto = 1 then
        iDigitoVerificador := 0
      else
        iDigitoVerificador := iDivisor - iResto;

    except
        ShowMessage('ERRO AO APLICAR DIV OU MOD PARA O DIVIDENDO ' + IntToStr(iDividendo) + ' E O DIVISOR ' + IntToStr(iDivisor));
        iDigitoVerificador := -1;
        Exit;
    end;

  end
  else
  begin
    ShowMessage('NUMERO DE REGISTRO: ' + sNumeroDeRegistro + ' INVALIDO.');
    iDigitoVerificador := -1;
  end;

  Result := IntToStr(iDigitoVerificador);

end;

//==================================================================
//  VERSAO INTERNET NÃO POSSUI ALGUMAS VALIDAÇÕES
//==================================================================
function TCNTLARDIG.DigitoMod11ECT(Numero: String): String;
const STR_CALC = '86423597';
var Soma, I, Resto: Integer;
begin
  result:='';
  Soma:= 0;
  if Length(Numero) = 8 then
  begin

    for I:=1 to 8 do
      Soma:= Soma + StrToInt(Numero[I]) * StrToInt(STR_CALC[I]);

    Resto:= Soma Mod 11;

    if Resto = 0 then
      result:= '5'
    else
    if Resto = 1 then
      result:= '0'
    else
      result:= IntToStr(11 - Resto);
  end;
end;

end.
