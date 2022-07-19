unit ClassDRS;
interface
  uses Windows, Forms, Classes, Dialogs, SysUtils, ZDataset, ZConnection,

  ClassMySqlBases, ClassStrings;
type

  TDRS = class
    private

      objConexao                                : TMysqlDatabase;
      __queryMySQL_processamento_DRS__         : TZQuery;

      __periodo_processamento__                 : string;

      __data_processamento__                    : string;

      __DiaProcessamento__                      : string;
      __MesProcessamento__                      : string;
      __AnoProcessamento__                      : string;

      __Produto__                               : string;
      __LoteInicial__                           : String;
      __LoteFinal__                             : String;

      __Numero_Lote_DRS__                       : string;

	    __Tabela_DRS__                            : string;
      __TabelaDePeriodos__                      : String;
      __Tabela_DRS_Processamentos__             : String;

      function getPeriodoMes(Mes: string=''): string;
      function VerificaSeLoteDeDRSEstaDentroDaFaixaDeSeguranca(LotesDeDRS: string): Boolean;

    public

      __Id_processamento_app__                  : string;
      __LOTE_PEDIDO_APP__                       : string;

      function setDataProcessamento(DataProcessamento: String): Boolean;
      function CriarLoteDRS(lote_pedido: string='';
                            id_processamento_aplicacao: string=''): Boolean;
      function GetLoteDRS(lote_pedido: string='';
                          id_processamento_aplicacao: string= ''): string;
      function AtualizaDadosLoteDRS(cliente, arquivo, path, qtdeObjetos: string): Boolean;
      function ResetaTabelaDRS(LoteDRS: String=''): Boolean;

      function getUltimoLoteDRSUsado(): String;

      //
      constructor create(Conexao                                   : TMysqlDatabase;
                         produto                                   : string;
                         tabela_DRS                                : string;
                         tabela_DRS_processamentos                 : string;
                         tabela_periodos                           : string;
                         lote_pedido_app                            : string;
                         id_processamento                           : string);

  end;
implementation

uses DB, ClassStatusProcessamento;
//uses Math;


constructor TDRS.create(Conexao                                    : TMysqlDatabase;
                        produto                                    : string;
                        tabela_DRS                                 : string;
                        tabela_DRS_processamentos                  : string;
                        tabela_periodos                            : string;
                        lote_pedido_app                            : string;
                        id_processamento                           : string);
begin

  objConexao                                   := Conexao;

  __id_processamento_app__                     := id_processamento;
  __LOTE_PEDIDO_APP__                          := lote_pedido_app;

  __Tabela_DRS__                               := tabela_DRS;
  __TabelaDePeriodos__                         := tabela_periodos;
  __Tabela_DRS_Processamentos__                := tabela_DRS_processamentos;
  __Produto__                                  := produto;
  __periodo_processamento__                    := getPeriodoMes();

end;



function TDRS.setDataProcessamento(DataProcessamento: String): Boolean;
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

function TDRS.getPeriodoMes(Mes: string=''): string;
Var
  sComando : string;
  wDia : Word;
  wMes : Word;
  wAno : Word;
  sMes : string;
begin

  sMes := Mes;

  if Trim(sMes) = '' then
  begin
    DecodeDate(Now(), wAno, wMes, wDia);
    sMes := FormatFloat('00', wMes);
  end;

  sComando :=  'SELECT periodo from ' + __TabelaDePeriodos__ + ' where mes = ' + sMes;
  objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 2);

  Result := __queryMySQL_processamento_DRS__.FieldByName('periodo').AsString;

end;

function TDRS.VerificaSeLoteDeDRSEstaDentroDaFaixaDeSeguranca(LotesDeDRS: string): Boolean;
var
  bEstaDentroDaFaixa: Boolean;
begin

  bEstaDentroDaFaixa := True;

    if (1 > StrToInt(LotesDeDRS)) then
    begin
      ShowMessage('ATEÇÃO !!!' + #13 + 'LOTE DRS ' + LotesDeDRS + ' FORA DA FAIXA !!!');
      bEstaDentroDaFaixa := False;
    end;

    if (9999 < StrToInt(LotesDeDRS)) then
    begin

      bEstaDentroDaFaixa := False;

      ShowMessage('ATEÇÃO !!!' + #13 + 'LOTE DRS ' + LotesDeDRS + ' MAIOR QUE 9999 !!!');
      case MessageBox (Application.Handle, Pchar ('Deseja resetar o lote? '), 'Confirmação', MB_YESNO) of
        idYes: Begin
                 ResetaTabelaDRS();
                 bEstaDentroDaFaixa := CriarLoteDRS();
               end;
      end;

    end;

  Result := bEstaDentroDaFaixa;

end;

function TDRS.ResetaTabelaDRS(LoteDRS: String=''): Boolean;
Var
  sComando        : string;
  bStatusOperacao : Boolean;
begin

  if Trim(LoteDRS) = '' then
  begin

    sComando := 'delete from ' + __Tabela_DRS__;
    bStatusOperacao := objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 1).status;

    sComando := 'ALTER TABLE ' + __Tabela_DRS__ + ' AUTO_INCREMENT = 1';
    Result := objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 1).status;

  end
  else
  begin

    sComando := 'delete from ' + __Tabela_DRS__
              + ' where lote_drs = ' + LoteDRS;
    bStatusOperacao := objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 1).status;

    if  bStatusOperacao then
    begin
      sComando := 'ALTER TABLE ' + __Tabela_DRS__ + ' AUTO_INCREMENT = ' + LoteDRS;
      Result := objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 1).status;
    end;
  end;

end;

function TDRS.CriarLoteDRS(lote_pedido: string=''; id_processamento_aplicacao: string= ''): Boolean;
var
  sData           : string;
  sComando        : string;
  sLoteDRS        : string;
  bStatusOperacao : Boolean;
begin

  if id_processamento_aplicacao = '' then
   id_processamento_aplicacao := __id_processamento_app__;

  if lote_pedido = '' then
   lote_pedido := __LOTE_PEDIDO_APP__;

  sData:= FormatDateTime('YYYY-MM-DD', Now());

  sComando := 'insert into ' + __Tabela_DRS__ + '(lote_processamento, id_processamento, periodo, data_criacao)'
            + ' values("' + lote_pedido + '","' + id_processamento_aplicacao + '",' + __periodo_processamento__ + ',"' + sData + '")';
  objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 1);

  sLoteDRS := GetLoteDRS(lote_pedido,
                         id_processamento_aplicacao);

  if not VerificaSeLoteDeDRSEstaDentroDaFaixaDeSeguranca(sLoteDRS) then
  begin
    bStatusOperacao := False;
  end
  else
    bStatusOperacao := True;

  Result := bStatusOperacao;

end;

// Apenas Consulta o lote DRS Criado
function TDRS.GetLoteDRS(lote_pedido: string='';
                         id_processamento_aplicacao: string= ''): string;
var
  sData           : string;
  sComando        : string;
  bStatusOperacao : Boolean;
begin

  sComando := 'select lote_drs from ' + __Tabela_DRS__
            + ' where lote_processamento = "' + lote_pedido + '" and '
            + '       id_processamento   = "' + id_processamento_aplicacao + '" and '
            + '       periodo            =  ' + __periodo_processamento__;
  bStatusOperacao := objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 2).status;

  if bStatusOperacao then
  begin
    __Numero_Lote_DRS__ := FormatFloat('0000', __queryMySQL_processamento_DRS__.FieldByName('lote_drs').AsInteger);

    if Trim(__Numero_Lote_DRS__) = '' then
      __Numero_Lote_DRS__ := '-1';

    Result              := __Numero_Lote_DRS__;

  end
  else
  begin
    __Numero_Lote_DRS__ := '-1';
    Result              := __Numero_Lote_DRS__;
  end;

  if  __Numero_Lote_DRS__ = '-1' then
    ShowMessage('ATENÇÃO !!!'
        + #13 + 'NÃO FOI POSSÍVEL OBTER O LOTE DRS CORRETAMENTE OU ELE AINDA NÃO FOI CRIADO.'
        + #13 + 'CONSULTE O ANALISTA.');
end;

function TDRS.AtualizaDadosLoteDRS(cliente, arquivo, path, qtdeObjetos: String): Boolean;
var
  sComando        : string;
  bStatusOperacao : Boolean;
begin
  sComando := 'update ' + __Tabela_DRS__
            + ' set '
            + ' cliente        = "'  + cliente + '",'
            + ' arquivo        = "'  + arquivo + '",'
            + ' path           = "'  + StringReplace(path, '\', '\\', [rfReplaceAll, rfIgnoreCase]) + '",'
            + ' qtde_objetos   = '   + qtdeObjetos

            + ' where lote_drs = ' + __Numero_Lote_DRS__
            + ' and '
            + '       periodo  =  ' + __periodo_processamento__;
  bStatusOperacao := objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 1).status;
end;

function TDRS.getUltimoLoteDRSUsado(): String;
var
  sComando        : string;
begin
  sComando := ' SELECT max(lote_drs) as lote_drs FROM ' + __Tabela_DRS__;
  objConexao.Executar_SQL(__queryMySQL_processamento_DRS__, sComando, 2);

  Result := FormatFloat('0000', __queryMySQL_processamento_DRS__.FieldByName('lote_drs').AsInteger);

end;

end.

