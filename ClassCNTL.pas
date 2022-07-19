unit ClassCNTL;
interface
  uses Classes, Dialogs, SysUtils, ZDataset, ZConnection,

  ClassMySqlBases, ClassStrings;
type

  TCNTL = class
    private

      objConexao                                : TMysqlDatabase;
      __queryMySQL_processamento_CNTL__         : TZQuery;

      __periodo_processamento__                 : string;
      __periodo_postagem__                      : string;
      __periodo_para_virada__                   : string;

      __data_postagem__                         : string;
      __data_processamento__                    : string;

      __DiaProcessamento__                      : string;
      __MesProcessamento__                      : string;
      __AnoProcessamento__                      : string;

      __Produto__                               : string;
      __LoteInicial__                           : String;
      __LoteFinal__                             : String;

      __FaixaDeSegurancaASerUsada__             : string;

      __LoteSeguranca_A_Inicial__               : String;
      __LoteSeguranca_A_Final__                 : String;

      __LoteSeguranca_B_Inicial__               : String;
      __LoteSeguranca_B_Final__                 : String;

      __dias_para_postagem_apos_processamento__        : string;
      __prazo_maximo_para_entrega_apos_processamento__ : string;

	    __Tabela_CNTL__                           : string;
      __TabelaDePeriodos__                      : String;
      __TabelaCNTLConf__                        : String;

      __UltimoLoteUsado__                       : string;

      __Lote__                                  : string;
      //__UltimoLote__                            : string;

      __StatusFaixaSeguranca__                  : string;

      __LotesValidosParaGravarAposProcessamento__  : TStringList;

      __Status_do_Processo_FAC__                : Boolean;

      function VerificaDisponibilidadeLote(NumeroLote: string): Boolean;


    public

      __FaixaExcecao__                          : TStringList;
      __codigo_operadora__                      : string;

      function setDataPostagem(DataPostagem: String): Boolean;
      function setDataProcessamento(DataProcessamento: String): Boolean;
      function getIntervaloFaixaASerUsada(): string;
      function getUltimoLote(Produto : String): string;
      function getUltimaPostagem(Produto : String): string;
      function getPeriodoMes(Mes: string): string;
      //
      //  0 - MODELO
      //  1 - PRODUCAO
      function IncrementarLote(iTipoProcesso: Integer): string;
      //

      function ValidaDaDePostagem(DataPostagem: string): Boolean;
      function ValidaLoteNaFaixa(sLote: String): Boolean;
      function AdicionarLoteNaMemoria(cntl, periodo_processamento, data_processamento, data_postagem, produto, operadora, pedido_mv_vt, qtd_obj, ano_periodo: string): Boolean;
      procedure LimparLoteNaMemoria();
      function GravaLotesDaMemoriaNaTabela(): Boolean;
      //
      function getFaixaDeLoteInicial(Produto: String): string;
      function getFaixaDeLoteFinal(Produto: String): string;
      function getFaixaDeSegurancaALoteInicial(Produto: String): string;
      function getFaixaDeSegurancaALoteFinal(Produto: String): string;
      function getFaixaDeSegurancaBLoteInicial(Produto: String): string;
      function getFaixaDeSegurancaBLoteFinal(Produto: String): string;
      function getIntervaloFaixaDeSegurancaUsada(Produto: String): string;
      function getProximoPeriodo(Produto: String): string;
      function AtualizaProximoPeriodo(Produto, Periodo: String): Boolean;
      function VerificaSeLoteDePostagemEstaDentroDaFaixaDeSeguranca(IntervaloUsadoFaixaDeSeguranca, LotesDePostagem: string): Boolean;
      function AtualizaProximoIntervaloDeSeguranca(Produto, IntervaloSeguranca: String): Boolean;
      function getStatusFaixaDeSeguranca(Produto: String): string;

      procedure DesativarFaixaDeSeguranca(Produto: String);
      procedure AtivarFaixaDeSeguranca(Produto: String);

      //
      constructor create(Conexao                                   : TMysqlDatabase;
                         produto                                   : string;
                         tabela_cntl                               : string;
                         tabela_periodos                           : string;
                         tabela_cntl_conf                          : string;
                         dias_para_postagem_apos_processamento     : string='1';
                         prazo_maximo_para_entrega_apos_processamento : string='10');

  end;
implementation
//uses Math;


constructor TCNTL.create(Conexao                                   : TMysqlDatabase;
                         produto                                   : string;

                         tabela_cntl                               : string;
                         tabela_periodos                           : string;
                         tabela_cntl_conf                          : string;
                         dias_para_postagem_apos_processamento     : string='1';
                         prazo_maximo_para_entrega_apos_processamento : string='10');
begin

  objConexao                                        := Conexao;
  __Tabela_CNTL__                                   := tabela_cntl;
  __TabelaDePeriodos__                              := tabela_periodos;
  __TabelaCNTLConf__                                := tabela_cntl_conf;
  __Produto__                                       := produto;
  __LoteInicial__                                   := getFaixaDeLoteInicial(__Produto__);
  __LoteFinal__                                     := getFaixaDeLoteFinal(__Produto__);
  __LoteSeguranca_A_Inicial__                       := getFaixaDeSegurancaALoteInicial(__Produto__);
  __LoteSeguranca_A_Final__                         := getFaixaDeSegurancaALoteFinal(__Produto__);
  __LoteSeguranca_B_Inicial__                       := getFaixaDeSegurancaBLoteInicial(__Produto__);
  __LoteSeguranca_B_Final__                         := getFaixaDeSegurancaBLoteFinal(__Produto__);
  __UltimoLoteUsado__                               := getUltimoLote(__Produto__);
  __FaixaDeSegurancaASerUsada__                     := getIntervaloFaixaDeSegurancaUsada(__Produto__);
  __StatusFaixaSeguranca__                          := getStatusFaixaDeSeguranca(__Produto__);
  __dias_para_postagem_apos_processamento__         := dias_para_postagem_apos_processamento;
  __prazo_maximo_para_entrega_apos_processamento__  := prazo_maximo_para_entrega_apos_processamento;
  __Lote__                                          := __UltimoLoteUsado__;
  __FaixaExcecao__                                  := TStringList.Create();
  __LotesValidosParaGravarAposProcessamento__       := TStringList.Create();
  __FaixaExcecao__.Clear;
  __LotesValidosParaGravarAposProcessamento__.Clear;
end;

function TCNTL.getUltimoLote(Produto : String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT ultimo_lote_usado from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('ultimo_lote_usado').AsString;

end;

function TCNTL.getUltimaPostagem(Produto : String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT ultima_postagem from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := FormatDateTime('DD/MM/YYYY', __queryMySQL_processamento_CNTL__.FieldByName('ultima_postagem').AsDateTime);

end;

function TCNTL.VerificaDisponibilidadeLote(NumeroLote: string): Boolean;
var
  iContLotesNaFaixaDeSeguranca: Integer;
begin
  Result := true;
  for iContLotesNaFaixaDeSeguranca := 0 to __FaixaExcecao__.Count - 1 do
    if StrToInt(__FaixaExcecao__.Strings[iContLotesNaFaixaDeSeguranca]) = StrToInt(NumeroLote) then
      Result := False;
end;

function TCNTL.IncrementarLote(iTipoProcesso: Integer): string;
var
  sMSG     : string;
  sPeriodo : string;
begin

  // TIPO DE PROCESSO
  // 0 - MODELO
  // 1 - PRODUÇÃO

  IF iTipoProcesso = 0 then
  begin

    Result := '12345';

  end
  else
  BEGIN

      __periodo_para_virada__  := getProximoPeriodo(__Produto__);

      if StrToInt(__Lote__) > 0 then
        __Lote__ := FormatFloat('00000', StrToInt(__Lote__) + 1);

      if StrToInt(__Lote__) = 0 then
        __Lote__ := FormatFloat('00000', StrToInt(__UltimoLoteUsado__) + 1);

      if (
         ( (__periodo_processamento__ = '1') and (__periodo_postagem__ = '2') ) or
         ( (__periodo_processamento__ = '2') and (__periodo_postagem__ = '3') ) or
         ( (__periodo_processamento__ = '3') and (__periodo_postagem__ = '4') ) or
         ( (__periodo_processamento__ = '4') and (__periodo_postagem__ = '1') )
         )
       then
      begin

        if not VerificaSeLoteDePostagemEstaDentroDaFaixaDeSeguranca(__FaixaDeSegurancaASerUsada__, __Lote__) Then
        begin

          if StrToInt(__StatusFaixaSeguranca__) = 0 then
          begin

            AtivarFaixaDeSeguranca(__Produto__);

            if __FaixaDeSegurancaASerUsada__ = 'A' then
            begin

              __Lote__ := __LoteSeguranca_A_Inicial__;

              ShowMessage('DATA FAC USADA FAZ PARTE DO PROXIMO PERÍODO' + #13
                        + 'PASSAREMOS A USAR A FAIXA DE LOTE DE SEGURANCA:'
                        + 'LOTE INICIAL: ' + __Lote__ + ' ATÉ O LOTE: ' + __LoteSeguranca_A_Final__ + #13
                        + 'CONFIRA OS LOTES DE POSTAGEM !!!' + #13
                        + 'ETAPA: function TCNTL.IncrementarLote(): string');
            end;

            if __FaixaDeSegurancaASerUsada__ = 'B' then
            begin

              __Lote__ := __LoteSeguranca_B_Inicial__;

              ShowMessage('DATA FAC USADA FAZ PARTE DO PROXIMO PERÍODO' + #13
                        + 'PASSAREMOS A USAR A FAIXA DE LOTE DE SEGURANCA:'
                        + 'LOTE INICIAL: ' + __Lote__ + ' ATÉ O LOTE: ' + __LoteSeguranca_B_Final__ + #13
                        + 'CONFIRA OS LOTES DE POSTAGEM !!!' + #13
                        + 'ETAPA: function TCNTL.IncrementarLote(): string');

            end;

          end;

        end;

      end;

      if __periodo_processamento__ = __periodo_para_virada__ then
      begin

        __Lote__                := __LoteInicial__;
        __periodo_para_virada__ := FormatFloat('0', StrToInt(__periodo_para_virada__) + 1);

        if __periodo_para_virada__ = '5' then
          __periodo_para_virada__ := '1';

        AtualizaProximoPeriodo(__Produto__, __periodo_para_virada__);

        if __FaixaDeSegurancaASerUsada__ = 'A' then
        begin
          AtualizaProximoIntervaloDeSeguranca(__Produto__, 'B');
        end;

        if __FaixaDeSegurancaASerUsada__ = 'B' then
        Begin
          AtualizaProximoIntervaloDeSeguranca(__Produto__, 'A');
        end;

        DesativarFaixaDeSeguranca(__Produto__);

        ShowMessage('ESTAMOS EM UM NOVO PERÍODO' + #13
                  + 'PASSAREMOS A USAR A FAIXA INICIAL DE LOTE:'
                  + 'LOTE INICIAL: ' + __Lote__ + ' ATÉ O LOTE: ' + __LoteFinal__ + #13
                  + 'CONFIRA OS LOTES DE POSTAGEM !!!' + #13
                  + 'ETAPA: function TCNTL.IncrementarLote(): string');

      end;

      __StatusFaixaSeguranca__ := getStatusFaixaDeSeguranca(__Produto__);

      if not ValidaLoteNaFaixa(__Lote__) then
      begin

        __Status_do_Processo_FAC__ := False;

        IF StrToInt(__StatusFaixaSeguranca__) = 0 then
          ShowMessage('LOTE ' + __Lote__ + ' ESTÁ FORA DA FAIXA ' + __LoteInicial__ + ' E ' + __LoteFinal__ + ' .' + #13 + 'FAVOR INFORMAR O ANALISTA.')
        else
        begin

          if __FaixaDeSegurancaASerUsada__ = 'A' then
            ShowMessage('LOTE ' + __Lote__ + ' ESTÁ FORA DA FAIXA ' + __LoteSeguranca_A_Inicial__ + ' E ' + __LoteSeguranca_A_Final__ + ' .' + #13 + 'FAVOR INFORMAR O ANALISTA.');

          if __FaixaDeSegurancaASerUsada__ = 'B' then
            ShowMessage('LOTE ' + __Lote__ + ' ESTÁ FORA DA FAIXA ' + __LoteSeguranca_B_Inicial__ + ' E ' + __LoteSeguranca_B_Final__ + ' .' + #13 + 'FAVOR INFORMAR O ANALISTA.');

        end;

        __Lote__ := '-1';

      end
      else
        __Status_do_Processo_FAC__ := True;


      if __Status_do_Processo_FAC__ then
      begin

        if StrToInt(__StatusFaixaSeguranca__) = 1 then
          sPeriodo := IntToStr(StrToInt(__periodo_processamento__)+1)
        else
          sPeriodo := __periodo_processamento__;


        AdicionarLoteNaMemoria(__Lote__, sPeriodo, __data_processamento__, __data_postagem__, __Produto__, __codigo_operadora__ , '', '', __AnoProcessamento__);
        Result := __Lote__;
      end;

  end;
end;

function TCNTL.getPeriodoMes(Mes: string): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT periodo from ' + __TabelaDePeriodos__ + ' where mes = ' + Mes;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('periodo').AsString;

end;

function TCNTL.ValidaDaDePostagem(DataPostagem: string): Boolean;
var
  dDataFacInformada   : Double;
  dDataAtual          : Double;
begin

  try
    Result := True;
    dDataFacInformada := StrToDateTime(DataPostagem);
    dDataAtual        := StrToDateTime(FormatDateTime('dd/mm/yyyy', StrToDate(__data_processamento__)));

    if dDataFacInformada < dDataAtual then
    Begin
      ShowMessage('Data FAC deve ser maior que a data atual');
      Result := false;
    end;

    // TIRADO DA LÓGICA POIS HAVIA A NECESSIDADE DE POSTAR NO MESMO DIA POUCOS DOCUMENTOS
    (*
    if dDataFacInformada > (dDataAtual + StrToInt(__dias_para_postagem_apos_processamento__)) then
    Begin
      ShowMessage('Data FAC deve ser maior que a data atual + ' + __dias_para_postagem_apos_processamento__ + ' dias');
      Result := false;
    end;
    *)

    (*
    if dDataFacInformada >= (dDataAtual + StrToInt(__prazo_maximo_para_entrega_apos_processamento__)) then
    Begin
      ShowMessage('Data FAC deve ser menor que a data atual + ' + __prazo_maximo_para_entrega_apos_processamento__ + ' dias');
      Result := false;
    end;
    *)

  except
    ShowMessage('ERROS OCORRERAM AO CONVERTER A DATA  + ' + DataPostagem);
    Result := false;
  end;

end;

function TCNTL.setDataPostagem(DataPostagem: String): Boolean;
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
    __periodo_postagem__ := getPeriodoMes(FormatFloat('0', wMes));
    bDataValida:= True;
  end
  else
    bDataValida:= False;

  Result := bDataValida;
  
end;

function TCNTL.setDataProcessamento(DataProcessamento: String): Boolean;
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

  __periodo_processamento__ := getPeriodoMes(FormatFloat('0', wMesProcessamento));

end;

function TCNTL.AdicionarLoteNaMemoria(cntl, periodo_processamento, data_processamento, data_postagem, produto, operadora, pedido_mv_vt, qtd_obj, ano_periodo: string): Boolean;
var
  sDataProcessamento : string;
  sDataPostagem : string;
begin

  sDataProcessamento := FormatDateTime('YYYY-MM-DD', StrToDate(data_processamento));
  sDataPostagem      := FormatDateTime('YYYY-MM-DD', StrToDate(data_postagem));

  __LotesValidosParaGravarAposProcessamento__.Add('"' + cntl + '","' + periodo_processamento + '","' + sDataProcessamento + '", "' + sDataPostagem + '", "' + produto + '", "' + operadora + '", "' + pedido_mv_vt + '", "' + qtd_obj + '", "' + ano_periodo + '"');
end;

procedure TCNTL.LimparLoteNaMemoria();
begin
  __LotesValidosParaGravarAposProcessamento__.Clear;
end;

function TCNTL.GravaLotesDaMemoriaNaTabela(): Boolean;
Var
  sComando : string;
  iContLotes: Integer;
begin
  try

    Result := false;

    if StrToInt(__Lote__) <> -1 then
    begin

      Result := True;
      for iContLotes := 0 to __LotesValidosParaGravarAposProcessamento__.Count - 1 do
      begin

        try
          sComando :=  'insert into ' + __Tabela_CNTL__ + ' (cntl, periodo, data_processamento, data_postagem, produto, operadora, pedido_mv_vt, qtd_obj, ano_periodo) '
                     + ' values(' + __LotesValidosParaGravarAposProcessamento__.Strings[iContLotes] + ')';
          objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 1);
        except
          Result := False;
        end;

      end;

      sComando :=  'update ' + __TabelaCNTLConf__
                 + ' set ultimo_lote_usado = ' + __Lote__ + ','
                 + '     ultima_postagem   = "' + FormatDateTime('YYYY-MM-DD', StrToDate(__data_postagem__)) + '"'
                 + ' where produto = ' + __Produto__;
      if Result then
        objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 1);

    end
    else
      ShowMessage('ERROS OCORRERAM GERAR O LOTE: ' + __Lote__ + #13
                + 'ETAPA: function TCNTL.GravaLotesDaMemoriaNaTabela(Produto: String): Boolean' + #13
                + 'NENHUM LOTE ATUALIZADO.');

    LimparLoteNaMemoria();

  except
    ShowMessage('ERROS OCORRERAM AO GRAVAR NA TABELA ' + __Tabela_CNTL__ + #13
              + 'LOTE: ' + __Tabela_CNTL__ + #13
              + 'ETAPA: function TCNTL.GravaLotesDaMemoriaNaTabela(Produto: String): Boolean');
    Result := False;
  end;
end;

function TCNTL.getIntervaloFaixaASerUsada(): string;
begin

end;

function TCNTL.getFaixaDeLoteInicial(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_lote_inicial from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('faixa_lote_inicial').AsString;

end;

function TCNTL.getFaixaDeLoteFinal(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_lote_final from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('faixa_lote_final').AsString;

end;

function TCNTL.getFaixaDeSegurancaALoteInicial(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_seguranca_A_ini from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('faixa_seguranca_A_ini').AsString;

end;

function TCNTL.getFaixaDeSegurancaALoteFinal(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_seguranca_A_fin from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('faixa_seguranca_A_fin').AsString;

end;

function TCNTL.getFaixaDeSegurancaBLoteInicial(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_seguranca_B_ini from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('faixa_seguranca_B_ini').AsString;

end;

function TCNTL.getFaixaDeSegurancaBLoteFinal(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_seguranca_B_fin from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('faixa_seguranca_B_fin').AsString;

end;

function TCNTL.getIntervaloFaixaDeSegurancaUsada(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT faixa_seguranca from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('faixa_seguranca').AsString;

end;

function TCNTL.getStatusFaixaDeSeguranca(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT statusFaixaSeguranca from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('statusFaixaSeguranca').AsString;

end;

function TCNTL.getProximoPeriodo(Produto: String): string;
Var
  sComando : string;
begin

  sComando :=  'SELECT proximo_periodo from ' + __TabelaCNTLConf__ + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 2);

  Result := __queryMySQL_processamento_CNTL__.FieldByName('proximo_periodo').AsString;

end;

function TCNTL.AtualizaProximoPeriodo(Produto, Periodo: String): Boolean;
Var
  sComando : string;
begin

  sComando :=  'update ' + __TabelaCNTLConf__
             + ' set proximo_periodo = "' + Periodo + '"'
             + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 1);

  Result := True;

end;

function TCNTL.AtualizaProximoIntervaloDeSeguranca(Produto, IntervaloSeguranca: String): Boolean;
Var
  sComando : string;
begin

  sComando :=  'update ' + __TabelaCNTLConf__
             + ' set faixa_seguranca = "' + IntervaloSeguranca + '"'
             + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 1);

  Result := True;

end;

function TCNTL.VerificaSeLoteDePostagemEstaDentroDaFaixaDeSeguranca(IntervaloUsadoFaixaDeSeguranca, LotesDePostagem: string): Boolean;
var
  bEstaDentroDaFaixa: Boolean;
begin

  bEstaDentroDaFaixa := false;

  if IntervaloUsadoFaixaDeSeguranca = 'A' then
  begin
    if (StrToInt(__LoteSeguranca_A_Inicial__) <= StrToInt(LotesDePostagem)) and
       (StrToInt(__LoteSeguranca_A_Final__)   >= StrToInt(LotesDePostagem)) then
      bEstaDentroDaFaixa := True;
  end;

  if IntervaloUsadoFaixaDeSeguranca = 'B' then
  begin
    if (StrToInt(__LoteSeguranca_B_Inicial__) <= StrToInt(LotesDePostagem)) and
       (StrToInt(__LoteSeguranca_B_Final__)   >= StrToInt(LotesDePostagem)) then
       bEstaDentroDaFaixa := True;
  end;

  Result := bEstaDentroDaFaixa;

end;


procedure TCNTL.AtivarFaixaDeSeguranca(Produto: String);
Var
  sComando : string;
begin

  sComando :=  'update ' + __TabelaCNTLConf__
             + ' set statusFaixaSeguranca = "1"'
             + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 1);

end;

procedure TCNTL.DesativarFaixaDeSeguranca(Produto: String);
Var
  sComando : string;
begin

  sComando :=  'update ' + __TabelaCNTLConf__
             + ' set statusFaixaSeguranca = "0"'
             + ' where produto = ' + Produto;
  objConexao.Executar_SQL(__queryMySQL_processamento_CNTL__, sComando, 1);

end;

function TCNTL.ValidaLoteNaFaixa(sLote: String): Boolean;
var
  sStatus : Boolean;
begin

  sStatus := False;

  if StrToInt(__StatusFaixaSeguranca__) = 0 then
  begin

    if ( StrToInt(__LoteInicial__) <= StrToInt(sLote) ) and ( StrToInt(__LoteFinal__)   >= StrToInt(sLote) ) then
      sStatus := True;

  end;

  if StrToInt(__StatusFaixaSeguranca__) = 1 then
  begin

    if __FaixaDeSegurancaASerUsada__ = 'A' then
      if ( StrToInt(__LoteSeguranca_A_Inicial__) <= StrToInt(sLote) ) and ( StrToInt(__LoteSeguranca_A_Final__)   >= StrToInt(sLote) ) then
       sStatus := True;

    if __FaixaDeSegurancaASerUsada__ = 'B' then
    if ( StrToInt(__LoteSeguranca_B_Inicial__) <= StrToInt(sLote) ) and ( StrToInt(__LoteSeguranca_B_Final__)   >= StrToInt(sLote) ) then
       sStatus := True;

  end;

  Result := sStatus;

end;

end.
