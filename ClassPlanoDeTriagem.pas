unit ClassPlanoDeTriagem;
interface
  uses Classes, Dialogs, SysUtils, ZDataset, ZConnection, MaskUtils,

  ClassMySqlBases, ClassLog, ClassStrings;
type

  TTipoPlanoTriagem = (fac, mala);

  TRecordPlanoTriagemCorreios= Record
    CepInicial : TStringList;
    CepFinal   : TStringList;
    CDD        : TStringList;
    CTC        : TStringList;
    Regiao     : TStringList;
    Destino    : TStringList;
    Categoria  : TStringList;
    seq        : TStringList;
  End;

  TPlanoDeTriagem = class
    private
      __cep__                      : String;
      __cepinicial__               : String;
      __cepfinal__                 : String;
      __cdd__                      : String;
      __ctc__                      : String;
      __seq__                      : String;
      __queryMySQL_processamento__ : TZQuery;
      __tipoDePlanoDeTriagem__     : TTipoPlanoTriagem;
      __ListaPlanoDeTriagem__      : TRecordPlanoTriagemCorreios;

      objConexao                   : TMysqlDatabase;
      objLogar                     : TArquivoDelog;
      objString                    : TFormataString;

      //M√©todos set
      function setCep(const cep: String): Boolean;
      function setTipoDePlanoDeTriagem(TipoDePlano: TTipoPlanoTriagem): Boolean;
      function setCepInicial(const cepinicial: String): Boolean;
      function setCepFinal(const cepfinal: String): Boolean;
      function setCDD(const cdd: String): Boolean;
      function setCTC(const ctc: String): Boolean;
      function setSEQ(const seq: String): Boolean;
      function setListaDePlanoDeTriagem(const cepinicial, cepfinal, cdd, ctc, regiao, seq: String): Boolean;
      //Metodos get
      function getCep(): String;
      function getCepInicial(): String;
      function getCepFinal(): String;
      function getCDD(): String;
      function getCTC(): String;
      function getSEQ(): String;
      function getTipoPlanoDeTriagem(): String;
      function getTipoPLanoTriagem(): TTipoPlanoTriagem;
      function getListagemDePlanoDeTriagem(): TRecordPlanoTriagemCorreios;
    public

      bMostrarErro : Boolean;
      //function CriarListaPlanoDeTriagem(Conexao: TMysqlDatabase; planoDeTriagem: String; TipoDePlanoDeTriagem: TTipoPlanoTriagem): Boolean;
      function RetornaCDDCTC(cep: String): String;
      function RetornaCDD(cep: String): String;
      function RetornaCTC(cep: String): String;
      function RetornaDirecao(cep: String): String;
      function RetornaCategoriaFacSimples(cep: String): String;
      function RetornaCategoriaFacRegistrado(cep: String): String;
      function RetornaCategoriaFacRegistradoComAr(cep: String): String;
      function RetornaPorte(PESO: String): String;
      function RetornaFaixaFormatada(cep: String): String;
      function RetornaIndiceCep(cep: String): Integer;
      function RetornaRegiaoDaMala(cep: String): String;
      function RetornaOrdemDoCDDCTCNoPlano(cep: String): Integer;
      function RetornaCTCCDDFAIXACEP(iPosicao: integer): String;

      constructor create(Var Conexao: TMysqlDatabase; Var objLogar: TArquivoDelog; Var objString: TFormataString; planoDeTriagem: String; TipoDePlanoDeTriagem: TTipoPlanoTriagem; MostrarErroCepNaoEncontrado: Boolean=False);

  end;
implementation
//uses Math;

//function TPlanoDeTriagem.CriarListaPlanoDeTriagem(Conexao: TMysqlDatabase; planoDeTriagem: String; TipoDePlanoDeTriagem: TTipoPlanoTriagem): Boolean;
constructor TPlanoDeTriagem.create(var Conexao: TMysqlDatabase; Var objLogar: TArquivoDelog; Var objString: TFormataString; planoDeTriagem: String; TipoDePlanoDeTriagem: TTipoPlanoTriagem; MostrarErroCepNaoEncontrado: Boolean=False);
Var
  sRegiao  : String;
  sComando : string;
begin

  bMostrarErro := MostrarErroCepNaoEncontrado;

  objConexao := Conexao;
  objLogar   := objLogar;
  objString  := objString;

  __ListaPlanoDeTriagem__.CepInicial := TStringList.Create;
  __ListaPlanoDeTriagem__.CepFinal   := TStringList.Create;
  __ListaPlanoDeTriagem__.CDD        := TStringList.Create;
  __ListaPlanoDeTriagem__.CTC        := TStringList.Create;
  __ListaPlanoDeTriagem__.Regiao     := TStringList.Create;
  __ListaPlanoDeTriagem__.seq        := TStringList.Create;

  __ListaPlanoDeTriagem__.CepInicial.Clear;
  __ListaPlanoDeTriagem__.CepFinal.Clear;
  __ListaPlanoDeTriagem__.CDD.Clear;
  __ListaPlanoDeTriagem__.CTC.Clear;
  __ListaPlanoDeTriagem__.Regiao.Clear;
  __ListaPlanoDeTriagem__.seq.Clear;


  // net_default     - Plano de Triagem Oficial NET
  // santuario_mod_1 - Plano de Triagem para Modelo 1 Santuario

  sComando := 'select * from ' + planoDeTriagem;
  objConexao.Executar_SQL(__queryMySQL_processamento__, sComando, 2);

  while not __queryMySQL_processamento__.EOF do
  Begin

    if TipoDePlanoDeTriagem = fac Then
      sRegiao:= ''
    else
    if TipoDePlanoDeTriagem = mala Then
      sRegiao:= __queryMySQL_processamento__.FieldByName('regiao').AsString;


    setListaDePlanoDeTriagem(__queryMySQL_processamento__.FieldByName('cepini').AsString,
                             __queryMySQL_processamento__.FieldByName('cepfin').AsString,
                             __queryMySQL_processamento__.FieldByName('cdd').AsString,
                             __queryMySQL_processamento__.FieldByName('ctc').AsString,
                             sRegiao,
                             __queryMySQL_processamento__.FieldByName('seq').AsString
                             );

    __queryMySQL_processamento__.Next;
  end;

end;

function TPlanoDeTriagem.setCep(const cep: String): Boolean;
Begin
  __cep__:= cep;
end;

function TPlanoDeTriagem.setCepInicial(const cepinicial: String): Boolean;
Begin
  __cepinicial__:= cepinicial;
end;

function TPlanoDeTriagem.setCepFinal(const cepfinal: String): Boolean;
Begin
  __cepfinal__:= cepfinal;
end;

function TPlanoDeTriagem.setCDD(const cdd: String): Boolean;
Begin
  __cdd__:= cdd;
end;

function TPlanoDeTriagem.setCTC(const ctc: String): Boolean;
Begin
  __ctc__:= ctc;
end;

function TPlanoDeTriagem.setSEQ(const seq: String): Boolean;
Begin
  __seq__:= seq;
end;

function TPlanoDeTriagem.setListaDePlanoDeTriagem(const cepinicial, cepfinal, cdd, ctc, regiao, seq: String): Boolean;
Begin

  if (not Assigned(__ListaPlanoDeTriagem__.CepInicial)) or
     (not Assigned(__ListaPlanoDeTriagem__.CepFinal)) or
     (not Assigned(__ListaPlanoDeTriagem__.CDD)) or
     (not Assigned(__ListaPlanoDeTriagem__.CTC)) or
     (not Assigned(__ListaPlanoDeTriagem__.seq))Then
  Begin
    ShowMessage('Listagem interna do objeto n√£o foi criada.');
    objLogar.Logar('Listagem interna do objeto n√£o foi criada.');
    Result:= false;
  end
  else
  Begin

    setCepInicial(cepinicial);
    setCepFinal(cepfinal);
    setCDD(cdd);
    setCTC(ctc);
    setSEQ(seq);

    getListagemDePlanoDeTriagem().CepInicial.add(getCepInicial());
    getListagemDePlanoDeTriagem().CepFinal.add(getCepFinal());
    getListagemDePlanoDeTriagem().CDD.add(getCDD());
    getListagemDePlanoDeTriagem().CTC.add(getCTC());
    getListagemDePlanoDeTriagem().seq.add(getSEQ());
    getListagemDePlanoDeTriagem().Regiao.add(regiao);

    Result:= true;
  end;

end;

//M√©todos get
function TPlanoDeTriagem.getCep(): String;
Begin
  Result:= __cep__;
end;

function TPlanoDeTriagem.getCepInicial(): String;
Begin
  Result:= __cepinicial__;
end;

function TPlanoDeTriagem.getCepFinal(): String;
Begin
  Result:= __cepfinal__;
end;

function TPlanoDeTriagem.getCDD(): String;
Begin
  Result:= __cdd__;
end;

function TPlanoDeTriagem.getCTC(): String;
Begin
  Result:= __ctc__;
end;

function TPlanoDeTriagem.getSEQ(): String;
Begin
  Result:= __seq__;
end;

function TPlanoDeTriagem.getListagemDePlanoDeTriagem(): TRecordPlanoTriagemCorreios;
Begin
  Result:= __ListaPlanoDeTriagem__;
end;

function TPlanoDeTriagem.RetornaIndiceCep(cep: String): Integer;
Var
  iPosicao         : Integer;
  iCepIni          : Integer;
  iCepFim          : Integer;
  iCep             : Integer;
  sCep             : string;
begin

  sCep := StringReplace(cep, '-', '', [rfReplaceAll, rfIgnoreCase]);
  sCep := StringReplace(sCep, ' ', '', [rfReplaceAll, rfIgnoreCase]);

  iCep := StrToIntDef(sCep, -1);

  Result := -1;

  if iCep <> -1 then
    if (length(Trim(sCep)) = 8) then
    begin
      for iPosicao := 0 to getListagemDePlanoDeTriagem().CepInicial.Count - 1 do
      Begin
        iCepIni := StrToInt(getListagemDePlanoDeTriagem().CepInicial.Strings[iPosicao]);
        iCepFim := StrToInt(getListagemDePlanoDeTriagem().CepFinal.Strings[iPosicao]);
        if (iCepIni <= icep) and (iCepFim >= icep) then
        Begin
          Result:= iPosicao;
          Break;
        End;
      End;
    end;

  if bMostrarErro then
    if Result = -1 then
      ShowMessage('FAIXA NAO ENCONTRADA PARA O CEP ' + cep);
    
end;

function TPlanoDeTriagem.RetornaCDDCTC(cep: String): String;
Var
  iPosicao         : Integer;
begin

  iPosicao:=  RetornaIndiceCep(cep);

  if iPosicao >=0 then
  begin

    IF length(Trim(getListagemDePlanoDeTriagem().CDD.Strings[iPosicao]) ) > 0  then
      Result := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().CDD.Strings[iPosicao]), 40)
    else
    IF length(Trim(getListagemDePlanoDeTriagem().CTC.Strings[iPosicao]) ) > 0  then
      Result := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().CTC.Strings[iPosicao]), 40)
    else
    begin
    
       if bMostrarErro then
         ShowMessage('Nao encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!.');

       Result := objString.AjustaStr('NAO ENCONTRADO', 40);
       objLogar.Logar('==> N„o encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!' + FORMATDATETIME('DD/MM/YYYY HH:MM:SS',Now));
    end;

  end
  else
  begin
    if bMostrarErro then
      ShowMessage('Nao encontrado o CEP ' + cep + #13 + 'Processo Cancelado !!!.');

    Result := objString.AjustaStr('', 40);
    //objLogar.Logar('==> N„o encontrado o CEP ' + cep + #13 + 'Processo Cancelado !!!' + FORMATDATETIME('DD/MM/YYYY HH:MM:SS',Now));
  end;
end;

function TPlanoDeTriagem.RetornaCDD(cep: String): String;
Var
  iPosicao         : Integer;
begin

  iPosicao:=  RetornaIndiceCep(cep);

  IF length(Trim(getListagemDePlanoDeTriagem().CDD.Strings[iPosicao]) ) > 0  then
    Result := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().CDD.Strings[iPosicao]), 40)
  else
  begin
  
     if bMostrarErro then
       ShowMessage('Nao encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!.');

     objLogar.Logar('==> N„o encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!'
           + FORMATDATETIME('DD/MM/YYYY HH:MM:SS',Now)+' '+ '' , '', '', false);

    Result := objString.AjustaStr('NAO ENCONTRADO', 40);
  end;

end;

function TPlanoDeTriagem.RetornaCTC(cep: String): String;
Var
  iPosicao         : Integer;
begin


  iPosicao:=  RetornaIndiceCep(cep);

  IF length(Trim(getListagemDePlanoDeTriagem().CTC.Strings[iPosicao]) ) > 0  then
    Result := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().CTC.Strings[iPosicao]), 40)
  else
  begin
     if bMostrarErro then
       ShowMessage('Nao encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!.');

     objLogar.Logar('==> N„o encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!'
           + FORMATDATETIME('DD/MM/YYYY HH:MM:SS',Now)+' '+ '' , '', '', false);

    Result := objString.AjustaStr('NAO ENCONTRADO', 40);

  end;

end;

function TPlanoDeTriagem.RetornaFaixaFormatada(cep: String): String;
Var
  iPosicao         : Integer;
Begin

  iPosicao:=  RetornaIndiceCep(cep);

  if iPosicao <> -1 Then
    Result:= ' - [' + getListagemDePlanoDeTriagem().CepInicial.Strings[iPosicao] + ' - ' +
                      getListagemDePlanoDeTriagem().CepFinal.Strings[iPosicao] + ']'
  else
  begin
     if bMostrarErro then
       ShowMessage('Nao encontrado a faixa para o CEP ' + cep + ' !!!.');

     objLogar.Logar('==> N„o encontrado a faixa para o CEP ' + cep + ' !!!'
           + FORMATDATETIME('DD/MM/YYYY HH:MM:SS',Now)+' '+ '' , '', '', false);
  end;

end;

function TPlanoDeTriagem.setTipoDePlanoDeTriagem(TipoDePlano: TTipoPlanoTriagem): Boolean;
Begin
  __tipoDePlanoDeTriagem__:= TipoDePlano;
end;

function TPlanoDeTriagem.getTipoPLanoTriagem(): TTipoPlanoTriagem;
Begin
  Result:= __tipoDePlanoDeTriagem__;
end;

function TPlanoDeTriagem.getTipoPlanoDeTriagem(): String;
Begin
  if __tipoDePlanoDeTriagem__ = fac Then
    Result:= 'FAC';

  if __tipoDePlanoDeTriagem__ = mala Then
    Result:= 'MALA';
end;

function TPlanoDeTriagem.RetornaRegiaoDaMala(cep: String): String;
Var
  iPosicao   : Integer;


Begin

  iPosicao:=  RetornaIndiceCep(cep);

  IF iPosicao <> -1 then
    Result := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().Regiao.Strings[iPosicao]), 8)
  else
  begin
  
     if bMostrarErro then
       ShowMessage('Nao encontrado a Regiao no Plano da Mala para o CEP ' + cep + #13 + 'Processo Cancelado !!!.');

     objLogar.Logar('Nao encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!.');

     Result := objString.AjustaStr('NAO ENCONTRADO', 40);

  end;

end;

function TPlanoDeTriagem.RetornaOrdemDoCDDCTCNoPlano(cep: String): Integer;
Var
  iPosicao         : Integer;
begin
  iPosicao :=  RetornaIndiceCep(cep);
  if iPosicao = -1 then
  begin

    if bMostrarErro then
      ShowMessage('Nao encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!.');

    //objLogar.Logar('Nao encontrado CDD/CTC para o CEP ' + cep + #13 + 'Processo Cancelado !!!.');
    Result := iPosicao;
  end
  else
    Result := StrToInt(__ListaPlanoDeTriagem__.seq.Strings[iPosicao]);

end;

function TPlanoDeTriagem.RetornaDirecao(cep: String): String;
var
  sDirecao : String;
begin
  if cep < '10000000' then  //Apurando o Destino/Categoria
  begin

    sDirecao   := '1'; // LOCAL

  end
  else
  begin

    if cep < '20000000' then
    begin

      sDirecao   := '2'; // ESTADUAL

    end
    else
    begin

      sDirecao   := '3'; // NACIONAL

    end;

  end;

  Result := sDirecao;

end;

function TPlanoDeTriagem.RetornaCategoriaFacSimples(cep: String): String;
var
  sCategoria : String;
begin
  if cep < '10000000' then  //Apurando o Destino/Categoria
  begin

    sCategoria := '82015'; // Grande S.Paulo //

  end
  else
  begin

    if cep < '20000000' then
    begin

      sCategoria := '82023'; // Interior de S.Paulo //

    end
    else
    begin

      sCategoria := '82031'; // Outros Estados //

    end;

  end;

  Result := sCategoria;

end;

function TPlanoDeTriagem.RetornaCategoriaFacRegistrado(cep: String): String;
var
  sCategoria : String;
begin
  if cep < '10000000' then  //Apurando o Destino/Categoria
  begin

    sCategoria := '82104'; // Grande S.Paulo //

  end
  else
  begin

    if cep < '20000000' then
    begin

      sCategoria := '82112'; // Interior de S.Paulo //

    end
    else
    begin

      sCategoria := '82120'; // Outros Estados //

    end;

  end;

  Result := sCategoria;

end;

function TPlanoDeTriagem.RetornaCategoriaFacRegistradoComAr(cep: String): String;
var
  sCategoria : String;
begin
  if cep < '10000000' then  //Apurando o Destino/Categoria
  begin

    sCategoria := '82139'; // Grande S.Paulo //

  end
  else
  begin

    if cep < '20000000' then
    begin

      sCategoria := '82147'; // Interior de S.Paulo //

    end
    else
    begin

      sCategoria := '82155'; // Outros Estados //

    end;

  end;

  Result := sCategoria;

end;

function TPlanoDeTriagem.RetornaPorte(PESO: String): String;
var
  sPorte : string;
begin
  //=======================================================
  //  DEFINICAO DE POSRTE
  //=======================================================
  case StrToInt(PESO) of
    0001..2000: sPorte := '1';
    2001..5000: sPorte := '2';
  else
     sPorte := '3';
  end;
  //=======================================================

  Result := sPorte;
end;

function TPlanoDeTriagem.RetornaCTCCDDFAIXACEP(iPosicao: integer): String;
Var
  objString        : TFormataString;
  sCdd,sCtc,sFaixaCep:string;
begin

  objString:= TFormataString.Create(objLogar);
  if iPosicao <> -1 then
  begin

    //Alimenta CDD
    if length(Trim(getListagemDePlanoDeTriagem().CDD.Strings[iPosicao]) ) > 0  then
      sCdd := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().CDD.Strings[iPosicao]), 40)
    else
    if length(Trim(getListagemDePlanoDeTriagem().CTC.Strings[iPosicao]) ) > 0  then
      sCdd := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().CTC.Strings[iPosicao]), 40);

    //Alimenta CTC
    sCtc := objString.AjustaStr(TRIM(getListagemDePlanoDeTriagem().CTC.Strings[iPosicao]), 40);

    {
    sFaixaCep:= FormatMaskText('00000-000;0;*',PreencheStrEsquerda(getListagemDePlanoDeTriagem().CepInicial.Strings[iPosicao],'0',8)) +' - '+
                FormatMaskText('00000-000;0;*',PreencheStrEsquerda(getListagemDePlanoDeTriagem().CepFinal.Strings[iPosicao],'0',8));
    }

    sFaixaCep:= FormatMaskText('00000-000;0;*', objString.Completa(getListagemDePlanoDeTriagem().CepInicial.Strings[iPosicao],8,'0','E')) +' - '+
                FormatMaskText('00000-000;0;*', objString.Completa(getListagemDePlanoDeTriagem().CepFinal.Strings[iPosicao],8,'0','E'));

  end
  else
  begin
    sCtc:=objString.AjustaStr(' ',40);
    sCdd:=objString.AjustaStr(' ',40);
    sFaixaCep:=objString.AjustaStr(' ',22);
  end;

  Result:=sCtc+sCdd+sFaixaCep;

  FreeAndNil(objString);

end;

end.
