unit ClassBlocaInteligente;
interface
uses
    Classes, ComCtrls, Controls, DateUtils, db, DBGrids, Dialogs,
    ExtCtrls, filectrl, Forms, Graphics, Grids, ImgList, IniFiles, Menus, Messages,
    Printers, Registry, ShellAPI, StdCtrls, SysUtils, Variants, Windows, WinSock,
    ZAbstractDataset, ZAbstractRODataset, ZConnection, ZDataset,
    // Classes
    ClassParametrosDeEntrada,
    ClassFuncoesWin, ClassMySqlBases, ClassLog, ClassStrings, ClassStatusProcessamento;
type

  TBlocagem = record
    QtdeImagensNoArquivo: integer;
    CapacidadeTotalLote: integer;
    QtdeLotesComBlocagemPadrao: integer;
    Sobra: integer;
    BlocagemParaSobra: integer;
    QtdeImagensDesperdicadas: integer;
  end;

  TBlocaInteligente= class
    private

      __exibir_mensagens__            : Boolean;

      __queryMySQL_processamento__    : TZQuery;

      objParametrosDeEntrada   : TParametrosDeEntrada;
      objConexao               : TMysqlDatabase;
      objFuncoesWin            : TFuncoesWin;
      objString                : TFormataString;
      objLogar                 : TArquivoDelog;
      objStatusProcessamento   : TStausProcessamento;

      function  Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;

	    function GetBlocagem(QtdeImagens, Blocagem, NomeArquivo: String): TBlocagem;

      function INSERT_tbl_blocagem(linha: widestring; diconix, numeroDaImagem, lote, sequencia: integer): TStausProcessamento;
      function INSERT_tbl_blocagemRelatorio(duracao: string;
                                             data: string;
                                             arquivo: widestring;
                                             tamanhoArquivo: string;
                                             qtdeImagensNoArquivo,
                                             parQtdeImagensBlocagem,
                                             parBlocagem,
                                             saidaQtdeLotesComBlocagemPadrao,
                                             saidaSobra,
                                             saidaBlocagemParaSobra,
                                             saidaQtdeImagensDesperdicadas: integer): TStausProcessamento;

     function Delete_tbl_blocagem(): TStausProcessamento;
     function Delete_tbl_blocagem_relatorio(): TStausProcessamento;


    public

      //Método set

      //Método get

	  // Funcoes
      constructor create(var __objParametrosEntrada__ : TParametrosDeEntrada;
                         Var __objConexao__: TMysqlDatabase;
                         Var __objFuncoesWin__: TFuncoesWin;
                         var __objString__: TFormataString;
                         var __objLogar__: TArquivoDelog;
                         exibirMensagens: Boolean=false);

	    function Blocar(arquivoEntrada: String): TStausProcessamento;

   End;

implementation

constructor TBlocaInteligente.create(var __objParametrosEntrada__ : TParametrosDeEntrada;
                                     Var __objConexao__: TMysqlDatabase;
                                     Var __objFuncoesWin__: TFuncoesWin;
                                     var __objString__: TFormataString;
                                     var __objLogar__: TArquivoDelog;
                                     exibirMensagens: Boolean=false);
begin
  objParametrosDeEntrada := __objParametrosEntrada__;
  objConexao             := __objConexao__;
  objFuncoesWin          := __objFuncoesWin__;
  objString              := __objString__;
  objLogar               := __objLogar__;

  objStatusProcessamento := TStausProcessamento.Create();

  __exibir_mensagens__   := exibirMensagens;


end;

function TBlocaInteligente.Blocar(arquivoEntrada: String): TStausProcessamento;
var
  rBlocagem             : TBlocagem;

  arq                   : TextFile;
  sLinha                : widestring;

  iDiconix                     : integer;
  iNumeroImagem                : integer;
  iLote                        : integer;
  iSequencia                   : integer;
  iparQtdeImagens              : integer;
  iparBlocagem                 : integer;
  iContLinhas                  : integer;
  iAcumLinhas                  : integer;
  iMaxLinhas                   : integer;
  iComprimentoLinha            : integer;
  i                            : integer;
  iNumeroLinhaInicioReblocagem : integer;
  sDiconix                     : string;
  sNumeroImagem                : string;
  sLote                        : string;
  sSequencia                   : string;
  sTamanhoArquivo              : string;
  sDuracao                     : string;
  sArquivoSaida                : string;
  sSQL                         : string;
  sDataAtual                   : string;
  sMensagemConfirmacao         : string;
  sLinhaArtificial             : string;
  sArqRelatorio                : string;
  sStatus                      : string;

  dTimeStampInicio             : TDateTime;
  dTimeStampFim                : TDateTime;
  dDuracao                     : TDateTime;

  iTamanhoArquivo              : int64;

  bCompletar                   : boolean;
  bReblocagem                  : boolean;

  arqRelatorio                 : TextFile;

  procedure Processar();
  begin
    iContLinhas := iContLinhas + 1;
    iAcumLinhas := iAcumLinhas + 1;

    //if not bCompletar then
    //  objLogar.Logar('Importando imagem '+inttostr(iAcumLinhas) + ' de ' + inttostr(rBlocagem.QtdeImagensNoArquivo)+'...')
    //else
    //  objLogar.Logar('Completando arquivo - Gerando linha '+inttostr(i+1) + ' de ' + inttostr(rBlocagem.CapacidadeTotalLote - rBlocagem.QtdeImagensNoArquivo));

    iSequencia := iSequencia + 1;

    if iContLinhas > iparBlocagem then
    begin
      iNumeroImagem := iNumeroImagem + 1;
      iContLinhas := 1;
      iDiconix    := 0;

      if iNumeroImagem > iparQtdeImagens then
      begin
        iNumeroImagem := 1;
        iLote         := iLote + 1;
        iContLinhas   := 1;
      end

    end;

    iDiconix := iDiconix + 1;

  end;

begin

  //Tira o caracter de aspas duplas do início do path quando for um caminho de rede mapeado:
  arquivoEntrada := StringReplace(arquivoEntrada,'"','',[rfReplaceAll]);

  sMensagemConfirmacao := 'Confirma blocagem com os seguintes parâmetros: '
                        + #13#10#13#10
                        + 'Arquivo de entrada: ' + ExtractFileName(arquivoEntrada)
                        + #13#10
                        + 'Quantidade de Imagens: ' + objParametrosDeEntrada.NUMERO_DE_IMAGENS_PARA_BLOCAGENS
                        + #13#10
                        + 'Blocagem: ' + objParametrosDeEntrada.BLOCAGEM
                        + #13#10#13#10
                        + ' ?';

  if __exibir_mensagens__ then
    Case MessageBox (Application.Handle, Pchar (sMensagemConfirmacao), 'Confirmação', MB_YESNO) of
      idNo:
        begin
          showmessage('Blocagem cancelada!');
          exit;
        end;
    end;

  try

    try
      Delete_tbl_blocagem();
      Delete_tbl_blocagem_relatorio();

      dTimeStampInicio := now();

      objLogar.Logar('*** INÍCIO DE PROCESSAMENTO *** ');

      sStatus := 'Etapa 1 de 5 - Obtendo informações para blocagem';

      objLogar.Logar(sStatus);
      objLogar.Logar('Aguarde, esta operação pode demorar se o arquivo for muito grande...');

      rBlocagem := GetBlocagem(objParametrosDeEntrada.NUMERO_DE_IMAGENS_PARA_BLOCAGENS, objParametrosDeEntrada.BLOCAGEM, arquivoEntrada);

      if __exibir_mensagens__ then
        showmessage('Qtde de imagens: ' + inttostr(rBlocagem.QtdeImagensNoArquivo) + #13#10
                  + 'Total de lotes: ' + inttostr(rBlocagem.QtdeLotesComBlocagemPadrao) + #13#10
                  + 'Sobra: ' + inttostr(rBlocagem.Sobra) + #13#10
                  + 'Blocagem para sobra: ' + inttostr(rBlocagem.BlocagemParaSobra) + #13#10#13#10
                  + 'Desperdício: ' + inttostr(rBlocagem.QtdeImagensDesperdicadas) + ' imagens.'
                   );

      //TODO: Adicionado em 19/09/2007
      if (rBlocagem.Sobra>0) and (rBlocagem.BlocagemParaSobra>0) then
      begin
        bReblocagem := true;
        iNumeroLinhaInicioReblocagem := (rBlocagem.CapacidadeTotalLote * rBlocagem.QtdeLotesComBlocagemPadrao) + 1;
      end
      else
      begin
        bReblocagem := false;
        iNumeroLinhaInicioReblocagem := 0;
      end;
      //TODO: Adicionado em 19/09/2007

      sStatus := 'Etapa 2 de 5- Importando arquivo...';

      objLogar.Logar(sStatus);

      try
        AssignFile(arq, arquivoEntrada);
        Reset(arq);
      except
        on E:Exception do
        begin
          showmessage('Erro ao abrir arquivo.'+#13#10
                    + 'Nome do arquivo: ' + arquivoEntrada + #13#10
                    + 'Excecao: '+ E.Message);
          exit;
        end;
      end;

      iDiconix      := 0;
      iNumeroImagem := 1;
      iLote         := 1;
      iSequencia    := 0;

      iparQtdeImagens := strtointdef(objParametrosDeEntrada.NUMERO_DE_IMAGENS_PARA_BLOCAGENS ,0);
      iparBlocagem    := StrToIntDef(objParametrosDeEntrada.BLOCAGEM,0);

      iMaxLinhas := iparQtdeImagens * iparBlocagem;

      iContLinhas      := 0;
      iAcumLinhas      := 0;

      bCompletar := false;

      while not eof(arq) do
      begin
        //Adicionado
        if (bReblocagem) and (iAcumLinhas = iNumeroLinhaInicioReblocagem) then
        begin
          iparBlocagem    := rBlocagem.BlocagemParaSobra;
          iMaxLinhas      := iparQtdeImagens * iparBlocagem;
        end;
        //

        readln(arq, sLinha);

        //>>> TRATA CARACTERES ESPECIAIS NA LINHA
        sLinha := objString.substituirCaracterNull(sLinha);
        if pos('"', sLinha) > 0 then
          sLinha := stringReplace(sLinha, '"', ' ', [rfReplaceAll]);

        if pos('\', sLinha) > 0 then
          sLinha := stringReplace(sLinha, '\', '/', [rfReplaceAll]);
        //>>>


        iComprimentoLinha := length(sLinha);

        Processar();
        INSERT_tbl_blocagem(sLinha, iDiconix, iNumeroImagem, iLote, iSequencia);
      end;

      CloseFile(arq);

      //se o arquivo é menor do que a capacidade total do lote, cria linhas com zeros
      //e continua o processamento até atingir a capacidade máxima
      if rBlocagem.QtdeImagensDesperdicadas > 0 then
      //if (rBlocagem.CapacidadeTotalLote) > rBlocagem.QtdeImagensNoArquivo then
      begin
        bCompletar := true;

        sLinhaArtificial := objString.Completa(sLinhaArtificial, iComprimentoLinha, '0', 'E');

        //for i := 0 to (rBlocagem.CapacidadeTotalLote*iLote)-rBlocagem.QtdeImagensNoArquivo-1 do
        for i:=0 to rBlocagem.QtdeImagensDesperdicadas-1 do
        begin
          sLinha := sLinhaArtificial;
          Processar();
          INSERT_tbl_blocagem(sLinha, iDiconix, iNumeroImagem, iLote, iSequencia);
        end;
      end;

    except

      on E:Exception do
      begin
        objLogar.Logar('btn_ProcessarClick() - Etapa 2 - Exceção: '+E.Message);

        ShowMessage('Aconteceu um erro que impede o programa de continuar.'+#13#10
                   +'Verifique o log de erros do programa.'+#13#10+#13#10
                   +'O programa serÃ¡ encerrado agora.');

        Application.Terminate;
      end;

    end;

    sStatus := 'Etapa 3 de 5 - Gerando arquivo de saída...';

    objLogar.Logar(sStatus);

    sStatus := 'Fase 1 de 2 - Indexando tabela...';
    objLogar.Logar(sStatus);

    sStatus := 'Etapa 2 de 2 - Gerando saída...';
    objLogar.Logar(sStatus);

    sArquivoSaida := ExtractFileName(copy(arquivoEntrada, 1, length(arquivoEntrada)-4))+'_BLOCADO.TXT';

    sArquivoSaida := ExtractFilepath(arquivoEntrada)+sArquivoSaida;

    sArquivoSaida := StringReplace(sArquivoSaida,'\','/',[rfReplaceAll]);

    sSQL := ' SELECT CONCAT(linha,'
           +'   LPAD(CAST(diconix AS CHAR(7)),7,"00000000"),'
           +'   LPAD(CAST(numeroDaImagem AS CHAR(2)),2,"00000000"),'
           +'   LPAD(CAST(lote AS CHAR(5)),5,"00000000"),'
           +'   LPAD(CAST(sequencia AS CHAR(7)),7,"00000000")'+') '
           +' INTO OUTFILE "' + sArquivoSaida + '" '
           +' FROM ' + objParametrosDeEntrada.TABELA_BLOCAGEM_INTELIGENTE
           +' ORDER BY lote,diconix,numeroDaImagem,sequencia ';
    objStatusProcessamento := objConexao.Executar_SQL(__queryMySQL_processamento__, sSQL, 1); //Executar_SQL(dm_Main.con_main, sSQL);


    //Etapa 4 - Gerando log...
    sStatus := 'Etapa 4 de 5 - Gerando log...';

    objLogar.Logar(sStatus);
    //AtualizarLabelStatus('');

    dTimeStampFim := now();
    dDuracao := dTimeStampFim - dTimeStampInicio;
    sDuracao := FormatDateTime('hh:mm:ss.zzz', dDuracao);

    sDataAtual := FormatDateTime('dd/mm/yyyy', now());

    iTamanhoArquivo        := objFuncoesWin.GetTamanhoArquivo_WinAPI(arquivoEntrada);
    sTamanhoArquivo        := objFuncoesWin.GetTamanhoMaiorUnidade(iTamanhoArquivo);

    objStatusProcessamento := INSERT_tbl_blocagemRelatorio(sDuracao,
                                               sDataAtual,
                                               StringReplace(arquivoEntrada,'\','\\',[rfReplaceAll]),
                                               sTamanhoArquivo,
                                               rBlocagem.QtdeImagensNoArquivo,
                                               strtoint(objParametrosDeEntrada.NUMERO_DE_IMAGENS_PARA_BLOCAGENS ),
                                               strtoint(objParametrosDeEntrada.BLOCAGEM),
                                               rBlocagem.QtdeLotesComBlocagemPadrao,
                                               rBlocagem.Sobra,
                                               rBlocagem.BlocagemParaSobra,
                                               rBlocagem.QtdeImagensDesperdicadas);

    //Etapa 5 - Gerando relatorio...
    sStatus := 'Etapa 5 de 5 - Gerando relatorio...';

    objLogar.Logar(sStatus);
    //AtualizarLabelStatus('');

    sArqRelatorio := arquivoEntrada + '.relatorio.txt';
    assignFile(arqRelatorio, sArqRelatorio);

    if FileExists(sArqRelatorio) then
      DeleteFile(objString.StrToPChar(sArqRelatorio));
    Rewrite(arqRelatorio);

    writeln(arqRelatorio,'Duracao do processo (HH:MM:SS.NNN) ......: ' + sDuracao);
    writeln(arqRelatorio,'Data do processo.........................: ' + sDataAtual);
    writeln(arqRelatorio,'Arquivo de entrada.......................: ' + arquivoEntrada);
    writeln(arqRelatorio,'Tamanho do arquivo.......................: ' + sTamanhoArquivo);
    writeln(arqRelatorio,'Qtde de imagens no arquivo...............: ' + inttostr(rBlocagem.QtdeImagensNoArquivo));
    writeln(arqRelatorio,'Qtde de Imagens SOLICITADA...............: ' + objParametrosDeEntrada.NUMERO_DE_IMAGENS_PARA_BLOCAGENS);
    writeln(arqRelatorio,'Blocagem SOLICITADA......................: ' + objParametrosDeEntrada.BLOCAGEM);
    writeln(arqRelatorio,'Qtde de lotes com blocagem solicitada....: ' + inttostr(rBlocagem.QtdeLotesComBlocagemPadrao));
    writeln(arqRelatorio,'Sobra (qtde de imagens)..................: ' + inttostr(rBlocagem.Sobra));
    writeln(arqRelatorio,'Blocagem da sobra........................: ' + inttostr(rBlocagem.BlocagemParaSobra));
    writeln(arqRelatorio,'Qtde de imagens desperdiÃ§adas...........: ' + inttostr(rBlocagem.QtdeImagensDesperdicadas));
    writeln(arqRelatorio,'Arquivo de saída........................: ' + sArquivoSaida);

    CloseFile(arqRelatorio);

    IF not StrToBool(objParametrosDeEntrada.MANTER_ARQUIVO_ORIGINAL) then
      if FileExists(arquivoEntrada) then
      begin
        CopyFile(objString.StrToPChar(sArquivoSaida), objString.StrToPChar(arquivoEntrada), False);
        DeleteFile(objString.StrToPChar(sArquivoSaida));
      end;    

  except
    on E:Exception do
      objLogar.Logar('Exceção durante o processamento: "'+E.Message+'"');
  end;  


  if __exibir_mensagens__ then
    Case MessageBox (Application.Handle, Pchar ('Deseja visualizar o relatório de blocagem? '),
     'Confirmação', MB_YESNO) of
      idYes: objFuncoesWin.ExecutarPrograma('notepad '+sArqRelatorio);
    end;

  if __exibir_mensagens__ then
    Case MessageBox (Application.Handle, Pchar ('Deseja abrir a pasta com o arquivo de saída? '),
     'Confirmação', MB_YESNO) of
      idYes: objFuncoesWin.ExecutarArquivoComProgramaDefault(ExtractFilePath(arquivoEntrada));
    end;

  objLogar.Logar('Excluindo a base de dados temporária...');

  Delete_tbl_blocagem();
  Delete_tbl_blocagem_relatorio();

  objLogar.Logar('*** FIM DE PROCESSAMENTO *** ');

  Result := objStatusProcessamento;

end;

function TBlocaInteligente.GetBlocagem(QtdeImagens, Blocagem, NomeArquivo: String): TBlocagem;
var
  arq          : TextFile;
  sLinha       : string;
  iQtdeImagens : integer;
  iBlocagem    : integer;
  rBlocagem    : TBlocagem;
  dValor       : double;

  iDividendo   : Integer;
  iDivisor     : Integer;
  iResultado   : Integer;
  iResto       : Integer;

begin
  //Capacidade Total:
  iQtdeImagens                   := strtointdef(QtdeImagens,0);
  iBlocagem                      := StrToIntDef(Blocagem,0);
  rBlocagem.CapacidadeTotalLote  := iQtdeImagens * iBlocagem;

  try
    //Quantidade de linhas no arquivo
    NomeArquivo := stringreplace(NomeArquivo,'"','',[rfReplaceAll]);

    //Logar('Nome do arquivo: ' + NomeArquivo);
    AssignFile(arq, NomeArquivo);
    Reset(arq);

    rBlocagem.QtdeImagensNoArquivo := 0;

    while not eof(arq) do
    begin
      readln(arq, sLinha);
      rBlocagem.QtdeImagensNoArquivo := rBlocagem.QtdeImagensNoArquivo + 1; //cada linha lida do arquivo é uma imagem
    end;
    CloseFile(arq);


    // Ajuste para casos onde o número de objetos não atendam ao total da blocagem
    // Ajuste Eduardo
    if rBlocagem.CapacidadeTotalLote > rBlocagem.QtdeImagensNoArquivo then
    begin
      iDividendo := rBlocagem.QtdeImagensNoArquivo;
      iDivisor   := iQtdeImagens;

      iResultado := iDividendo div iDivisor;
      iResto     := iDividendo mod iDivisor;

      if iResto = 0 then
        iBlocagem := iResultado
      else
        iBlocagem := iResultado + 1;

      objParametrosDeEntrada.BLOCAGEM := IntToStr(iBlocagem);
      rBlocagem.CapacidadeTotalLote   := iQtdeImagens * iBlocagem;
    end;
    //

    if rBlocagem.CapacidadeTotalLote < rBlocagem.QtdeImagensNoArquivo then
    begin
      rBlocagem.QtdeLotesComBlocagemPadrao := trunc(rBlocagem.QtdeImagensNoArquivo / rBlocagem.CapacidadeTotalLote);
      rBlocagem.Sobra                      := rBlocagem.QtdeImagensNoArquivo-(rBlocagem.CapacidadeTotalLote*rBlocagem.QtdeLotesComBlocagemPadrao);

      if (rBlocagem.Sobra mod iQtdeImagens) = 0 then
        rBlocagem.BlocagemParaSobra := trunc(rBlocagem.Sobra / iQtdeImagens)
      else
      begin
        dValor := rBlocagem.Sobra / iQtdeImagens;
        rBlocagem.BlocagemParaSobra            := trunc(arredondar(dValor, 0, true));
      end;

      rBlocagem.QtdeImagensDesperdicadas   := rBlocagem.BlocagemParaSobra*iQtdeImagens-rBlocagem.Sobra;
    end
    else
    if rBlocagem.CapacidadeTotalLote >= rBlocagem.QtdeImagensNoArquivo then
    begin
      rBlocagem.QtdeLotesComBlocagemPadrao         := 1;
      rBlocagem.Sobra                              := 0;
      rBlocagem.BlocagemParaSobra                  := 0;

      if rBlocagem.CapacidadeTotalLote <> rBlocagem.QtdeImagensNoArquivo then
        rBlocagem.QtdeImagensDesperdicadas := rBlocagem.CapacidadeTotalLote-rBlocagem.QtdeImagensNoArquivo
      else
        rBlocagem.QtdeImagensDesperdicadas := 0;
    end;
  except
    on E:Exception do
      //Logar('GetBlocagem() - Exceção: '+E.Message);
  end;

  result := rBlocagem;
end;

function TBlocaInteligente.Delete_tbl_blocagem(): TStausProcessamento;
var
  sSQL: widestring;
begin
  sSQL := 'delete from ' + objParametrosDeEntrada.TABELA_BLOCAGEM_INTELIGENTE;
  Result := objConexao.Executar_SQL(__queryMySQL_processamento__, sSQL, 1); //Executar_SQL(con_main, sSQL);
end;

function TBlocaInteligente.Delete_tbl_blocagem_relatorio(): TStausProcessamento;
var
  sSQL: widestring;
begin
  sSQL := 'delete from ' + objParametrosDeEntrada.TABELA_BLOCAGEM_INTELIGENTE_RELATORIO;
  Result := objConexao.Executar_SQL(__queryMySQL_processamento__, sSQL, 1); //Executar_SQL(con_main, sSQL);
end;

function TBlocaInteligente.INSERT_tbl_blocagem(linha: widestring; diconix, numeroDaImagem, lote, sequencia: integer): TStausProcessamento;
var
  sSQL: widestring;
begin
  sSQL := ' INSERT INTO ' + objParametrosDeEntrada.TABELA_BLOCAGEM_INTELIGENTE + ' (linha,diconix,numeroDaImagem,lote,sequencia) '
         +' VALUES ('
         +'"'+linha+'",'
         +inttostr(diconix)+','
         +inttostr(numeroDaImagem)+','
         +inttostr(lote)+','
         +inttostr(sequencia)+')';
  Result := objConexao.Executar_SQL(__queryMySQL_processamento__, sSQL, 1); //Executar_SQL(con_main, sSQL);
end;

function TBlocaInteligente.INSERT_tbl_blocagemRelatorio(duracao: string;
                                                data: string;
                                                arquivo: widestring;
                                                tamanhoArquivo: string;
                                                qtdeImagensNoArquivo,
                                                parQtdeImagensBlocagem,
                                                parBlocagem,
                                                saidaQtdeLotesComBlocagemPadrao,
                                                saidaSobra,
                                                saidaBlocagemParaSobra,
                                                saidaQtdeImagensDesperdicadas: integer): TStausProcessamento;
var
  sSQL: widestring;
begin
  sSQL := ' INSERT INTO ' + objParametrosDeEntrada.TABELA_BLOCAGEM_INTELIGENTE_RELATORIO + ' (duracao, data, arquivo, qtdeImagensNoArquivo, '
         +'  tamanhoArquivo, parQtdeImagensBlocagem, parBlocagem, '
         +'  saidaQtdeLotesComBlocagemPadrao, saidaSobra, '
         +'  saidaBlocagemParaSobra, saidaQtdeImagensDesperdicadas) '
         +' VALUES ('
         +'"'+duracao+'",'
         +'"'+data+'",'         
         +'"'+arquivo+'",'
         +inttostr(qtdeImagensNoArquivo)+','
         +'"'+tamanhoArquivo+'",'
         +inttostr(parQtdeImagensBlocagem)+','
         +inttostr(parBlocagem)+','
         +inttostr(saidaQtdeLotesComBlocagemPadrao)+','
         +inttostr(saidaSobra)+','
         +inttostr(saidaBlocagemParaSobra)+','
         +inttostr(saidaQtdeImagensDesperdicadas)+')';
  Result := objConexao.Executar_SQL(__queryMySQL_processamento__, sSQL, 1);//Executar_SQL(con_main, sSQL);
end;

function TBlocaInteligente.Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;
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
    //Arredondamento opcional para cima quando não tiver casas decimais após a vírgula
    if (Dec=0) and (ParaCima) then
      Numero3 := Numero3 + 1;
  end;    

  Result:=(Numero3 / (Exp(Ln(10) * Dec)));
end;

end.
