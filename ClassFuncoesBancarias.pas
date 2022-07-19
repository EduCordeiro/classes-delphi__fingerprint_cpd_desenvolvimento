unit ClassFuncoesBancarias;
interface
uses
    Classes, ComCtrls, Controls, DateUtils, db, DBGrids, Dialogs,
    ExtCtrls, filectrl, Forms, Graphics, Grids, ImgList, IniFiles, Menus, Messages,
    Printers, Registry, ShellAPI, StdCtrls, SysUtils, Variants, Windows, WinSock,
    ZAbstractDataset, ZAbstractRODataset, ZConnection, ZDataset;
type

  TFuncoesBancarias= class
    private

    public

    //Funções SAFRA - Cobrança registrada
    Function SAFRA_COBRANCA_REGISTRADA_CODIGOBARRAS(sBanco, sMoeda, sVencimento, sValor, sCampoLivre: String):String;
    Function SAFRA_COBRANCA_REGISTRADA_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
    Function SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO10(sString:String):String;
    Function SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO11(sString:String):String;
    Function SAFRA_COBRANCA_REGISTRADA_CALCULA_NOSSONUMERO(sString:String):String;



    //Funções BRADESCO SEM REGISTRO
    Function BRADESCO_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre: String):String;
    Function BRADESCO_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
    Function BRADESCO_SR_CALCULA_MODULO10(sString:String):String;
    Function BRADESCO_SR_CALCULA_MODULO11(sString:String):String;
    Function BRADESCO_SR_CALCULA_NOSSONUMERO(sString:String):String;

    // Funções genÉrica (vale para todos os bancos)
    Function GENERICO_FATOR_DE_VENCIMENTO(sVencimento : String):Integer;

    //Funções CAIXA ECONÔMICA SEM REGISTRO - SIGCB
    Function CaixaEconomicaFederal_SR_SIGCB_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_MODULO10(sString:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_MODULO11(sString:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_DV_CONTA(sString:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_NOSSONUMERO(sNossoNr:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_DIGITOCAMPOLIVRE(sCampoLivre:string):string;

    //Funções CAIXA ECONÔMICA SEM REGISTRO - Nosso nr começado com 8
    Function CaixaEconomicaFederal_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
    Function CaixaEconomicaFederal_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;

    //Funções ITAU SEM REGISTRO (NOSSO NUMERO 12 BYTES)
    Function ITAU_SR_CODIGOBARRAS_CART_198(sVencimento,sValor,sCampoLivre:STRING):string;
    Function ITAU_SR_LINHADIGITAVEL_CART_198(sVencimento,sValor,sCampoLivre:STRING):string;

    Function ITAU_SR_CODIGOBARRAS_CART_109_175(sBanco,sMoeda,sVencimento,sValor,sCampoLivre: String):string;
    Function ITAU_SR_LINHADIGITAVEL_CART_109_175(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:STRING):string;

    Function ITAU_CALCULA_DIGITO_NOSSO_NUMERO(Agencia, ContaSemDigito, Carteira , NossoNumero:STRING):string;

    Function ITAU_SR_MODULO10(sString:string):string;
    Function ITAU_SR_MODULO11(sString:string):string;
    Function ITAU_SR_NOSSONUMERO(sNossoNr:string):string;
    Function ITAU_SR_SOMADIGITOS(sNumero: String): String;

    //Funções SANTANDER SEM REGISTRO (NOSSO NUMERO 12 BYTES)
    Function SANTANDER_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:STRING):string;
    Function SANTANDER_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:STRING):string;
    Function SANTANDER_SR_MODULO10(sString:string):string;
    Function SANTANDER_SR_MODULO11(sString:string):string;
    Function SANTANDER_SR_NOSSONUMERO(sNossoNr:string):string;

    //Funções BANCO DO BRASIL MODULO 10 E 11
    Function BRASIL_SR_MODULO11(sString:string):string;
    Function BRASIL_SR_MODULO10(sString:string):string;

    //Funções BANCO DO BRASIL REGISTRADO
    Function BRASIL_CR_CODIGOBARRAS_CONVENIO_COM_7POS(  sBanco, sMoeda, sVencimento, sValor, sNossoNr, sModCob:STRING):string;
    Function BRASIL_CR_LINHADIGITAVEL_CONVENIO_COM_7POS(sBanco, sMoeda, sVencimento, sValor, sNossoNr, sModCob:STRING):string;
    Function BRASIL_CR_DIG_NOSSONUMERO(sNossoNr: string):string;

    //Funções BANCO DO BRASIL SEM REGISTRO (NOSSO NUMERO 17 BYTES (CONVENIO 7 BYTES))
    Function BRASIL_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:STRING):string;
    Function BRASIL_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:STRING):string;
    Function BRASIL_SR_NOSSONUMERO(sNossoNr:string):string;

    //Funções BANCO DO BRASIL SEM REGISTRO (NOSSO NUMERO 11 BYTES (CONVENIO 6 BYTES))
    Function BRASIL_SR6_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:STRING):string;
    Function BRASIL_SR6_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:STRING):string;
    Function BRASIL_SR6_NOSSONUMERO(sNossoNr:string):string;

    //Funções BANCO DO BRASIL SEM REGISTRO (NOSSO NÚMERO DE 17 POSIÇÕES LIVRE DO CLIENTE)
    Function BRASIL_SR17_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:STRING):string;
    Function BRASIL_SR17_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:STRING):string;

    //Funções UNIBANCO????

    //Funções Sicoob
    Function Sicoob_Dv_NossoNumero(sNossoNumero: string):string;
    Function Sicoob_CodigoBarras(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
    Function Sicoob_Modulo11(sString:string):string;
    Function Sicoob_LinhaDigitavel(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
    Function Sicoob_Modulo10(sString:string):string;

    //Funções Ficha de Arrecadação
    Function FichaArrecadacao_CALCULA_MODULO10(sString:String):String;
    Function FichaArrecadacao_CALCULA_MODULO11(sString:String):String;

    //Funções genéricas
    Function Generico_ValidaCpfCnpj(sCpf: string):Boolean;
    Function Generico_ValidaCpfCnpj_Modulo11_Cpf(sString:String):String;
    Function Generico_ValidaCpfCnpj_Modulo11_Cnpj(sString:String):String;

   End;

implementation
//uses Math, ClassDirectory;


Function TFuncoesBancarias.SAFRA_COBRANCA_REGISTRADA_CODIGOBARRAS(sBanco, sMoeda, sVencimento, sValor, sCampoLivre: String):String;
Var
  sDAC          : String;
  sLivre        : String;
  sFator        : String;
  sTipoCobranca : string;

Begin
  sFator        := '';
  sLivre        := '';
  sDAC          := '';
  sTipoCobranca := Copy(sCampoLivre, Length(sCampoLivre), 1);

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  //  sDAC -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDAC := SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO11(sBanco + sMoeda + sFator + sValor + sCampoLivre);

  Result  := PChar(sBanco + sMoeda + sDAC + sFator + sValor + sCampoLivre);
End;

Function TFuncoesBancarias.SAFRA_COBRANCA_REGISTRADA_LINHADIGITAVEL(sBanco, sMoeda, sVencimento, sValor, sCampoLivre : String):String;
Var
  sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
  sDac_c1, sDac_c2, sDac_c3, sFator,sresult : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco + sMoeda + Copy(sCampoLivre, 1, 5);
  sDac_c1 := SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDac_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  // 6 à 15 do campo livre
  sCampo2 := Copy(sCampoLivre, 6, 10);
  sDac_c2 := SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDac_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  // 16 à 25 do campo livre
  sCampo3 := Copy(sCampoLivre, 16, 10);
  sDac_c3 := SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDac_c3;

  {-- Campo 4 DAC -----------------------------------------------------------}
  sCampo4 := BRADESCO_SR_CALCULA_MODULO11(sBanco + sMoeda + sFator + sValor + sCampoLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator + sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function TFuncoesBancarias.SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO10(sString:String):String;
Var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sresult: String;
Begin
  bDig := True;
  isoma := 0;
  For iI := Length(sString) downto 1 do
  Begin

    If bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    Else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    If Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig  := Not(bDig);
  End;

  // Nota: Quando o resto da divisão for 0 (Zero), o DV calculado é o 0 (Zero).
  Case (10-(iSoma mod 10)) of
    10 : sresult := IntToStr(0);
  Else
      sresult := IntToStr(10-(iSoma mod 10));
  End;

  result := pchar(sresult);
End;

Function TFuncoesBancarias.SAFRA_COBRANCA_REGISTRADA_CALCULA_MODULO11(sString:String):String;
Var
  iRes, iSoma, iI, iMult: Integer;
  sresult : String;
Begin

  iMult := 2;
  iSoma := 0;

  For iI := Length(sString) downto 1 do
  Begin

    iRes  := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;
    iMult := iMult + 1;

    // calculado pelo módulo 11, multiplicando-se cada algarismo, pela seqüência de 2 a 9, posicionados da direita para a esquerda
    If iMult = 10 Then
      iMult := 2;

  End;

  // Se na divisão o resto for 0 (zero), 10 (dez) ou 1 (um) o DAC será sempre 1 (um).
  Case (11-(iSoma mod 11)) of
    0,1,10,11 : sresult := IntToStr(1)
  Else
    sresult := IntToStr(11-(iSoma mod 11));
  End;

  result := Pchar(sresult);

End;

Function TFuncoesBancarias.SAFRA_COBRANCA_REGISTRADA_CALCULA_NOSSONUMERO(sString:String):String;
Var
  iRes, iSoma, iI, iMult: Integer;
  sresult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  Begin

    iRes  := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;
    iMult := iMult + 1;

    // calculado pelo módulo 11, multiplicando-se cada algarismo, pela seqüência de 2 a 9, posicionados da direita para a esquerda
    If iMult = 10 Then
      iMult := 2;

  End;

  Case (iSoma mod 11) of
    0 : sresult := IntToStr(1);
    1 : sresult := IntToStr(0);
  Else
    sresult := IntToStr(11-(iSoma mod 11));
  End;

  result := Pchar(sresult);
End;

Function TFuncoesBancarias.BRADESCO_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre: String):String;
Var
  sDAC_CB, sLivre, sFator : String;

Begin
  sFator  := '';
  sLivre  := '';
  sDAC_CB := '';

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  //  WDAC_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDAC_CB := BRADESCO_SR_CALCULA_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  Result  := PChar(sBanco   + sMoeda   + sDAC_CB   + sFator   +
                   sValor   + sCampoLivre);
End;

Function TFuncoesBancarias.BRADESCO_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
Var
  sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
  sDac_c1, sDac_c2, sDac_c3, sFator,sresult : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sCampoLivre,1,5);
  sDac_c1 := BRADESCO_SR_CALCULA_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDac_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sCampoLivre,6,10);
  sDac_c2 := BRADESCO_SR_CALCULA_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDac_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sCampoLivre,16,10);
  sDac_c3 := BRADESCO_SR_CALCULA_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDac_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRADESCO_SR_CALCULA_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function TFuncoesBancarias.BRADESCO_SR_CALCULA_MODULO10(sString:String):String;
Var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sresult: String;
Begin
  bDig := True;
  isoma := 0;
  For iI := Length(sString) downto 1 do
    Begin
      If bDig = True then
        iRes := StrToInt(Copy(sString,iI,1)) * 2
      Else
        iRes := StrToInt(Copy(sString,iI,1)) * 1;

      If Length(IntToStr(iRes)) = 2 Then
        iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

        iSoma := iSoma + iRes;
        bDig := Not(bDig);
    End;

  Case (10-(iSoma mod 10)) of
    10 : sresult := IntToStr(0);
    Else
      sresult := IntToStr(10-(iSoma mod 10));
  End;

  result := pchar(sresult);
End;

Function TFuncoesBancarias.BRADESCO_SR_CALCULA_MODULO11(sString:String):String;
Var
  iRes, iSoma, iI, iMult: Integer;
  sresult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
    Begin
      iRes := StrToInt(Copy(sString,iI,1)) * iMult;
      iSoma := iSoma + iRes;
      iMult := iMult + 1;
      If iMult = 10 Then
        iMult := 2;
    End;

    Case (11-(iSoma mod 11)) of
      0,1,10,11 : sresult := IntToStr(1)
      Else
        sresult := IntToStr(11-(iSoma mod 11));
    End;

  result := Pchar(sresult);
End;

Function TFuncoesBancarias.BRADESCO_SR_CALCULA_NOSSONUMERO(sString:String):String;
Var
  iRes, iSoma, iI, iMult: Integer;
  sresult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
    Begin
      iRes := StrToInt(Copy(sString,iI,1)) * iMult;
      iSoma := iSoma + iRes;
      iMult := iMult + 1;
      If iMult = 8 Then
        iMult := 2;
      End;

      Case (iSoma mod 11) of
        0 : sresult := IntToStr(0);
        1 : sresult := 'P';
      Else
        sresult := IntToStr(11-(iSoma mod 11));
      End;

  result := Pchar(sresult);
End;

Function TFuncoesBancarias.GENERICO_FATOR_DE_VENCIMENTO(sVencimento : String) : Integer;
Var
  iI, isomd : Integer;
  aDAno : Array[1..12] of Integer;
  aDAnobi : Array[1..12] of Integer;

Begin
  aDAno[01] := 31;
  aDAno[02] := 28;
  aDAno[03] := 31;
  aDAno[04] := 30;
  aDAno[05] := 31;
  aDAno[06] := 30;
  aDAno[07] := 31;
  aDAno[08] := 31;
  aDAno[09] := 30;
  aDAno[10] := 31;
  aDAno[11] := 30;
  aDAno[12] := 31;
  aDAnobi[01] := 31;
  aDAnobi[02] := 29;
  aDAnobi[03] := 31;
  aDAnobi[04] := 30;
  aDAnobi[05] := 31;
  aDAnobi[06] := 30;
  aDAnobi[07] := 31;
  aDAnobi[08] := 31;
  aDAnobi[09] := 30;
  aDAnobi[10] := 31;
  aDAnobi[11] := 30;
  aDAnobi[12] := 31;

  //66 dias de 07/10/1997 atÃ© 31/12/1997
  isomd := 85;

  //Soma atÃ© Ãºltimo dia do ano anterior
  //se o vencimento Ã© 30/03/2006, a soma Ã© feita atÃ© 31/12/2005
  //Depois do For i, Ã© feito a soma dos dias do ano atual [atÃ© o vencimento]
  For ii := 1998 to StrToInt(Copy(sVencimento,7,4))-1 do
    Case iI of
      //Ano Bisexto
      2000,2004,2008,2012,2016,2020,2024 : isomd := isomd + 366
    Else
      isomd := isomd + 365;
    End;


  //Soma dos dias do ano atÃ© o mÃªs anterior do vencimento
  For ii := 1 to StrToInt(Copy(sVencimento,4,2))-1 do
    Case StrToInt(Copy(sVencimento,7,4)) of
      //Ano Bisexto
      2000,2004,2008,2012,2016,2020 : isomd := isomd + aDanobi[ii]
    Else
      isomd := isomd + aDano[ii]
    End;

  //Soma dos dias do mes do vencimento
  isomd := isomd + StrToInt(Copy(sVencimento,1,2));

  Result := isomd;
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
Var
  sDigito,sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sDigito := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);
  Result := sBanco+sMoeda+sDigito+sFator+sValor+sCampoLivre;
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
Var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sDig1 := sBanco+sMoeda+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) +CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig2);

  sDig3 := Copy(sCampoLivre,16,10);
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig3);

  sDig4 := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  sDig5 := sFator+sValor;

  Result := sDig1 + '  ' + sDig2 + '  ' + sDig3 + '  ' + sDig4 + '  ' + sDig5;
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_SIGCB_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
Var
  sDigito,sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sDigito := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);
  Result := sBanco+sMoeda+sDigito+sFator+sValor+sCampoLivre;
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_SIGCB_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
Var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sDig1 := sBanco+sMoeda+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) +CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig2);

  sDig3 := Copy(sCampoLivre,16,10);
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig3);

  sDig4 := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  sDig5 := sFator+sValor;

  Result := sDig1 + ' ' + sDig2 + ' ' + sDig3 + ' ' + sDig4 + ' ' + sDig5;
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_SIGCB_MODULO10(sString:string):string;
Var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sResult : String;
Begin
  bDig := True;
  isoma := 0;
  For iI := Length(sString) downto 1 do
  Begin
    If bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    Else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    If Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  End;

  Case (10-(iSoma mod 10)) of
    10,0 :
      sResult := IntToStr(0);
    Else
      sResult := IntToStr(10-(iSoma mod 10));
    End;

    result := pchar(sResult);
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_SIGCB_NOSSONUMERO(sNossoNr:string):string;
Var
  iRes, iSoma, iI, iMult, iRest: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sNossoNr) downto 1 do
  Begin
    iRes := StrToInt(Copy(sNossoNr,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  irest:=(11-(iSoma mod 11));
  if irest > 9 then
    sResult := IntToStr(0)
  Else
    sResult := IntToStr(iRest);

  result := Pchar(sResult);
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_SIGCB_MODULO11(sString:string):string;
Var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  Begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  case (11-(iSoma mod 11)) of
    0,10,1,11 :
      sResult := IntToStr(1);
    Else
      sResult := IntToStr(11-(iSoma mod 11));
     end;

  result := Pchar(sResult);
End;

Function TFuncoesBancarias.CaixaEconomicaFederal_SR_SIGCB_DV_CONTA(sString:string):string;
Var
  iRes, iSoma, iI, iMult: Integer;
  iDV: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;

  For iI := Length(sString) downto 1 do
  Begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  iDV:= iSoma mod 11;

  iDV:= 11 - iDv;

  if iDv > 9 then
    iDV:= 0;

  sResult:= IntToStr(iDv);

  result := Pchar(sResult);
End;


Function TFuncoesBancarias.CaixaEconomicaFederal_SR_SIGCB_DIGITOCAMPOLIVRE(sCampoLivre:string):string;
Var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sCampoLivre) downto 1 do
  Begin
    iRes := StrToInt(Copy(sCampoLivre,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  if (11-(iSoma mod 11)) > 9 then
    sResult := IntToStr(0)
  Else
    sResult := IntToStr(11-(iSoma mod 11));

  result := Pchar(sResult);
End;

Function TFuncoesBancarias.ITAU_SR_MODULO10(sString:string):string;
var
  iRes, iI, iSoma : Integer;
  bDig : Boolean;
  sResult : String;
begin
  bDig  := True;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  begin
    if bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    if Length(IntToStr(iRes)) = 2 then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  end;

  case (10-(iSoma mod 10)) of
    10,0 : sResult := IntToStr(0);
  else
    sResult := IntToStr(10-(iSoma mod 10));
  end;
  result := pchar(sResult);
end;


Function TFuncoesBancarias.ITAU_SR_NOSSONUMERO(sNossoNr:string):string;
var
    iDig, iI, iMult,iSoma: Integer;
    sResult : String;
begin

  iSoma := 0;
  iMult := 2;

  for iI := Length(sNossoNr) downto 1 do
  begin

    iDig := StrToInt(Copy(sNossoNr,iI,1)) * iMult;

    if iDig >= 10 then
      iSoma := iSoma + StrToInt(ITAU_SR_SOMADIGITOS(IntToStr(iDig)))
    else
      iSoma := iSoma + iDig;

    if iMult = 2 then
      iMult := 1
    else
      iMult := 2;

  end;

  iDig:=(10-(iSoma mod 10));

  case iDig of
    10,0 : Result := IntToStr(0);
  else
    Result := Pchar(IntToStr(iDig));
  end;
  
end;

Function TFuncoesBancarias.ITAU_CALCULA_DIGITO_NOSSO_NUMERO(Agencia, ContaSemDigito, Carteira , NossoNumero:STRING):string;
var
  iDig    : Integer;
  iI      : Integer;
  iMult   : Integer;
  iSoma   : Integer;
  sResult : String;
  sN      : string;

begin

  iSoma := 0;
  iMult := 2;

  if Length(Agencia) <> 4 then
    ShowMessage('AGÊNCIA ITAÚ INVÁLIDA');

  if Length(ContaSemDigito) <> 5 then
    ShowMessage('CONTA ITAÚ INVÁLIDA');

  if Length(Carteira) <> 3 then
    ShowMessage('CARTEIRA ITAÚ INVÁLIDA');

  if Length(NossoNumero) <> 8 then
    ShowMessage('NOSSO NÚMERO ITAÚ INVÁLIDO');

  sN := Agencia + ContaSemDigito + Carteira + NossoNumero;

  for iI := Length(sN) downto 1 do
  begin

    iDig := StrToInt(Copy(sN,iI,1)) * iMult;

    if iDig >= 10 then
      iSoma := iSoma + StrToInt(ITAU_SR_SOMADIGITOS(IntToStr(iDig)))
    else
      iSoma := iSoma + iDig;

    if iMult = 2 then
      iMult := 1
    else
      iMult := 2;

  end;

  iDig:=(10-(iSoma mod 10));

  case iDig of
    10,0 : Result := IntToStr(0);
  else
    Result := Pchar(IntToStr(iDig));
  end;
  
end;

Function TFuncoesBancarias.ITAU_SR_SOMADIGITOS(sNumero: String): String;
var
  iDigitos     : Integer;
  iContDigitos : Integer;
  iSoma        : Integer;
begin
  iSoma    := 0;
  iDigitos := Length(sNumero);

  for iContDigitos := 0 to iDigitos - 1 do
    iSoma :=  + iSoma + StrToInt(Copy(sNumero, iContDigitos + 1, 1));
  Result := IntToStr(iSoma);
end;

Function TFuncoesBancarias.ITAU_SR_CODIGOBARRAS_CART_198(sVencimento,sValor,sCampoLivre:string):string;
var
  sDigito,sFator : String;
begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sValor  := FormatFloat('0000000000',StrToInt(sValor));
  sDigito := ITAU_SR_MODULO11('3419' + sFator+sValor+sCampoLivre+ITAU_SR_MODULO10(sCampoLivre)+'0');
  Result  := '3419'+sDigito+sFator+sValor+sCampoLivre+ITAU_SR_MODULO10(sCampoLivre)+'0';
end;

Function TFuncoesBancarias.ITAU_SR_LINHADIGITAVEL_CART_198(sVencimento,sValor,sCampoLivre:string):string;
var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sValor := FormatFloat('0000000000',StrToInt(sValor));

  sDig1 := '3419'+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) + ITAU_SR_MODULO10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + ITAU_SR_MODULO10(sDig2);

  sDig3 := Copy(sCampoLivre,16,8)+ITAU_SR_MODULO10(sCampoLivre)+'0';
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + ITAU_SR_MODULO10(sDig3);

  sDig4 := ITAU_SR_MODULO11('3419' + sFator+sValor+sCampoLivre+ITAU_SR_MODULO10(sCampoLivre)+'0');

  sDig5 := sFator+sValor;

  Result := sDig1 + ' ' + sDig2 + ' ' + sDig3 + ' ' + sDig4 + ' ' + sDig5;
end;

Function TFuncoesBancarias.ITAU_SR_CODIGOBARRAS_CART_109_175(sBanco,sMoeda,sVencimento,sValor,sCampoLivre: String):string;
Var
  sDAC_CB, sLivre, sFator : String;

begin
  sFator  := '';
  sLivre  := '';
  sDAC_CB := '';

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  //  WDAC_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDAC_CB := ITAU_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  Result  := PChar(sBanco   + sMoeda   + sDAC_CB   + sFator   +
                   sValor   + sCampoLivre);
end;


Function TFuncoesBancarias.ITAU_SR_LINHADIGITAVEL_CART_109_175(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
var
  sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
  sDac_c1, sDac_c2, sDac_c3, sFator,sresult : String;
begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sCampoLivre,1,5);
  sDac_c1 := ITAU_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDac_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sCampoLivre,6,10);
  sDac_c2 := ITAU_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDac_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sCampoLivre,16,10);
  sDac_c3 := ITAU_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDac_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := ITAU_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
end;


Function TFuncoesBancarias.ITAU_SR_MODULO11(sString:string):string;
var
    iRes, iSoma, iI, iMult: Integer;
    sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  end;

  case (11-(iSoma mod 11)) of
   0,10,1,11 : sResult := IntToStr(1);
  else
    sResult := IntToStr(11-(iSoma mod 11));
  end;

  Result := Pchar(sResult);
end;


Function TFuncoesBancarias.SANTANDER_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
var
  sFator, sDig : String;
begin

    sDig:= '';

    if Trim(sVencimento) = '' then
      sFator  :='0000'
    else
      sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

//  sDig   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
    sDig    := SANTANDER_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

    Result := (sBanco   + sMoeda    + sDig + sFator +
               sValor   + sCampoLivre );
end;

Function TFuncoesBancarias.SANTANDER_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5 : String;
    sDig_c1, sDig_c2, sDig_c3,sFator , sDig : String;
begin
    sCampo1 := '';
    sCampo2 := '';
    sCampo3 := '';
    sCampo4 := '';
    sCampo5 := '';

    {-- Campo 1 ---------------------------------------------------------------}
    sCampo1 := sBanco+sMoeda+copy(sCampoLivre,1,5);
    sDig_c1 := SANTANDER_SR_MODULO10(sCampo1);
    sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

    {-- Campo 2 ---------------------------------------------------------------}
    sCampo2 := copy(sCampoLivre,6,10);
    sDig_c2 := SANTANDER_SR_MODULO10(sCampo2);
    sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

    {-- Campo 3 ---------------------------------------------------------------}
    sCampo3 := copy(sCampoLivre,16,10);
    sDig_c3 := SANTANDER_SR_MODULO10(sCampo3);
    sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

    {-- Campo 4 ---------------------------------------------------------------}
    if Trim(sVencimento) = '' then
      sFator  :='0000'
    else
      sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

    sDig :='';

//  sDig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
    sDig    := SANTANDER_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

    sCampo4 := sDig;

    {-- Campo 5 ---------------------------------------------------------------}
    sCampo5 := sFator+sValor;

    Result := (sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
end;

Function TFuncoesBancarias.SANTANDER_SR_MODULO10(sString:string):string;
var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sResult:string;
begin
  bDig := True;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  begin
    if bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    if Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  end;

  case (10-(iSoma mod 10)) of
    10 : sResult := IntToStr(0);
    else
      sResult := IntToStr(10-(iSoma mod 10));
    end;

  Result := sResult;
end;

Function TFuncoesBancarias.SANTANDER_SR_MODULO11(sString:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 then
      iMult := 2;
    end;

    case (11-(iSoma mod 11)) of
      0,1,10,11: sResult := IntToStr(1)
      else
        sResult := IntToStr(11-(iSoma mod 11));
    end;

     Result := (sResult);
end;

Function TFuncoesBancarias.SANTANDER_SR_NOSSONUMERO(sNossoNr:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sNossoNr) downto 1 do
  begin
    iRes := StrToInt(Copy(sNossoNr,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 then
      iMult := 2;
  end;

  case ((iSoma mod 11)) of
    10: sResult := IntToStr(1);
    0,1,11:  sResult := IntToStr(0)
    else
      sResult := IntToStr(11-(iSoma mod 11));
  end;

  Result := (sResult);
end;


Function TFuncoesBancarias.BRASIL_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:string):string;
var
  sDig_CB, sLivre, sFator : String;
begin
  sFator  := '';
  sLivre  := '';
  sDig_CB := '';

  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sLivre  := '000000'+sNossoNr+sModCob;

// Wig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDig_CB := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  Result  := PChar(sBanco   + sMoeda   + sDig_CB   + sFator   + svalor +
                   sLivre);
end;


Function TFuncoesBancarias.BRASIL_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
    sDig_c1, sDig_c2, sDig_c3, sFator : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  sLivre  := '000000'+sNossoNr+sModCob;
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sLivre,1,5);
  sDig_c1 := BRASIL_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sLivre,6,10);
  sDig_c2 := BRASIL_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sLivre,16,10);
  sDig_c3 := BRASIL_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function TFuncoesBancarias.BRASIL_SR_MODULO10(sString:string):string;
var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sResult:string;
begin
  bDig := True;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    if bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    if Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  end;

  case (10-(iSoma mod 10)) of
    10 : sResult := IntToStr(0);
  else
    sResult := IntToStr(10-(iSoma mod 10));
  end;

  Result := pchar(sResult);
end;

Function TFuncoesBancarias.BRASIL_SR6_NOSSONUMERO(sNossoNr:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sNossoNr) downto 1 do
  begin
    iRes := StrToInt(Copy(sNossoNr,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 Then
      iMult := 2;
  end;

  case (iSoma mod 11) of
    0  : sResult := IntToStr(0);
    10 : sResult := 'X';
    else
      sResult := IntToStr(iSoma mod 11);
  end;

  Result := Pchar(sResult);
End;

Function TFuncoesBancarias.BRASIL_SR_MODULO11(sString:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 Then
      iMult := 2;
  end;

  case (11-(iSoma mod 11)) of
    0,1,10,11 : sResult := IntToStr(1)
  else
    sResult := IntToStr(11-(iSoma mod 11));
  end;

  Result := Pchar(sResult);
End;



Function TFuncoesBancarias.BRASIL_SR_NOSSONUMERO(sNossoNr:string):string;
var
  iN1,iN2,iN3,iN4,iN5,iN6,iN7,iN8,iN9,iN10: integer;
  iN11,iN12,iN13,iN14,iN15,iN16,iN17, iAux :integer;
begin
  iN1 := StrToInt(Copy(sNossoNr,1,1) ) * 2;
  iN2 := StrToInt(Copy(sNossoNr,2,1) ) * 2;
  iN3 := StrToInt(Copy(sNossoNr,3,1) ) * 3;
  iN4 := StrToInt(Copy(sNossoNr,4,1) ) * 4;
  iN5 := StrToInt(Copy(sNossoNr,5,1) ) * 5;
  iN6 := StrToInt(Copy(sNossoNr,6,1) ) * 6;
  iN7 := StrToInt(Copy(sNossoNr,7,1) ) * 7;
  iN8 := StrToInt(Copy(sNossoNr,8,1) ) * 8;
  iN9 := StrToInt(Copy(sNossoNr,9,1) ) * 9;
  iN10:= StrToInt(Copy(sNossoNr,10,1)) * 2;
  iN11:= StrToInt(Copy(sNossoNr,11,1)) * 3;
  iN12:= StrToInt(Copy(sNossoNr,12,1)) * 4;
  iN13:= StrToInt(Copy(sNossoNr,13,1)) * 5;
  iN14:= StrToInt(Copy(sNossoNr,14,1)) * 6;
  iN15:= StrToInt(Copy(sNossoNr,15,1)) * 7;
  iN16:= StrToInt(Copy(sNossoNr,16,1)) * 8;
  iN17:= StrToInt(Copy(sNossoNr,17,1)) * 9;

  iAux := 0;
  iAux := (iN1 + iN2 + iN3 + iN4 + iN5 + iN6 + iN7 + iN8 + iN9 + iN10);
  iAux := (iAux + iN11 + iN12 + iN13 + iN14 + iN15 + iN16 + iN17) MOD 11;

  if iAux = 10 then
     Result:= 'X'
  else
  begin
   Result:= IntToStr(iAux);
  end;
end;

Function TFuncoesBancarias.BRASIL_SR6_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:string):string;
var
  sDig_CB, sLivre, sFator : String;
begin
  sFator  := '';
  sLivre  := '';
  sDig_CB := '';

  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sLivre  := sNossoNr+sAgencia+sConta+sModCob;

// Wig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDig_CB := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  Result  := PChar(sBanco   + sMoeda   + sDig_CB   + sFator   + svalor +
                   sLivre);
end;


Function TFuncoesBancarias.BRASIL_SR6_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
    sDig_c1, sDig_c2, sDig_c3, sFator : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  sLivre  := sNossoNr+sAgencia+sConta+sModCob;
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sLivre,1,5);
  sDig_c1 := BRASIL_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sLivre,6,10);
  sDig_c2 := BRASIL_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sLivre,16,10);
  sDig_c3 := BRASIL_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function TFuncoesBancarias.BRASIL_SR17_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:string):string;
var
  sDig_CB, sLivre, sFator : String;
begin
  sFator  := '';
  sLivre  := '';
  sDig_CB := '';

  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sLivre  := sConvenio+sNossoNr+sModCob;

// Wig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDig_CB := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  Result  := PChar(sBanco   + sMoeda   + sDig_CB   + sFator   + svalor +
                   sLivre);
end;

Function TFuncoesBancarias.BRASIL_SR17_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
    sDig_c1, sDig_c2, sDig_c3, sFator : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  sLivre  := sConvenio+sNossoNr+sModCob;
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sLivre,1,5);
  sDig_c1 := BRASIL_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sLivre,6,10);
  sDig_c2 := BRASIL_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sLivre,16,10);
  sDig_c3 := BRASIL_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;


Function TFuncoesBancarias.Sicoob_Dv_NossoNumero(sNossoNumero: string):string;
var
  //sDig_CB, sLivre, sFator : String;
  sConstante: string;
  sDv       : string;

  iIndiceConstante  : integer;
  iIndiceNossoNumero: integer;
  iCopyConstante    : integer;
  iCopyNossoNumero  : integer;
  iSoma             : integer;
  iResto            : integer;

begin

  sConstante      := '3197';
  iIndiceConstante:= 1;
  iSoma           := 0;
  iResto          := 0;

  //Itera sobre o Nosso Numero
  for iIndiceNossoNumero:= 1 to length(sNossoNumero) do
  begin

    //Obtem valores para a multiplicacao
    iCopyConstante  := strtoint(copy(sConstante, iIndiceConstante,1));
    iCopyNossoNumero:= strtoint(copy(sNossoNumero,iIndiceNossoNumero,1));

    //Acumula os valores multiplicados
    iSoma:= iSoma + (iCopyConstante * iCopyNossoNumero);

    //Itera sobre a constante 3>1>9>7...3>1>9>7
    iIndiceConstante := iIndiceConstante + 1;
    if iIndiceConstante > 4 then
      iIndiceConstante:= 1;

  end;

  iResto:= iSoma mod 11;

  if ((iResto = 0) or (iResto = 1)) then
    iResto:= 0
  else
    iResto:= 11 - iResto;

  //Dî¨©to verificador
  sDv:= inttostr(iResto);


  Result:= sDv;


end;

Function TFuncoesBancarias.Sicoob_CodigoBarras(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
var
  sDigito: String;
  sFator : String;

begin

  if Trim(sVencimento) = '' then
    sFator  := '0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sDigito := Sicoob_Modulo11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  Result := sBanco     + //(03)
            sMoeda     + //(01)
            sDigito    + //(01)
            sFator     + //(04)
            sValor     + //(10)
            sCampoLivre; //(25)

end;

Function TFuncoesBancarias.Sicoob_Modulo11(sString:string):string;
Var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  Begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  case (11-(iSoma mod 11)) of
    0,10,1,11 :
      sResult := IntToStr(1);
    Else
      sResult := IntToStr(11-(iSoma mod 11));
     end;

  result := Pchar(sResult);
end;

Function TFuncoesBancarias.Sicoob_LinhaDigitavel(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
Var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
begin

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sDig1 := sBanco+sMoeda+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) + Sicoob_Modulo10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + Sicoob_Modulo10(sDig2);

  sDig3 := Copy(sCampoLivre,16,10);
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + Sicoob_Modulo10(sDig3);

  sDig4 := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  sDig5 := sFator+sValor;

  Result := sDig1 + ' ' + sDig2 + ' ' + sDig3 + ' ' + sDig4 + ' ' + sDig5;
end;

Function TFuncoesBancarias.Sicoob_Modulo10(sString:string):string;
Var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sResult : String;

begin
  bDig := True;
  isoma := 0;
  For iI := Length(sString) downto 1 do
  Begin
    If bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    Else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    If Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  End;

  Case (10-(iSoma mod 10)) of
    10,0 :
      sResult := IntToStr(0);
    Else
      sResult := IntToStr(10-(iSoma mod 10));
    End;

    result := pchar(sResult);
end;


Function TFuncoesBancarias.FichaArrecadacao_CALCULA_MODULO10(sString:String):String;
Var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sresult: String;
Begin
  bDig := True;
  isoma := 0;
  For iI := Length(sString) downto 1 do
    Begin
      If bDig = True then
        iRes := StrToInt(Copy(sString,iI,1)) * 2
      Else
        iRes := StrToInt(Copy(sString,iI,1)) * 1;

      If Length(IntToStr(iRes)) = 2 Then
        iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

        iSoma := iSoma + iRes;
        bDig := Not(bDig);
    End;

  Case (10-(iSoma mod 10)) of
    10 : sresult := IntToStr(0);
    Else
      sresult := IntToStr(10-(iSoma mod 10));
  End;

  result := pchar(sresult);

End;


Function TFuncoesBancarias.FichaArrecadacao_CALCULA_MODULO11(sString:String):String;
Var
  WRes, WSoma, I, WMult: Integer;
  wresult : String;
  iTeste : Integer;
Begin
  WMult := 2;
  WSoma := 0;
  For I := Length(sString) downto 1 do
    Begin
      WRes := StrToInt(Copy(sString,I,1)) * WMult;
      WSoma := WSoma + WRes;

      WMult := WMult + 1;
      If WMult = 10 Then
         WMult := 2;
    End;

  {
  Case (11-(WSoma mod 11)) of
    0,1,10,11 : wresult := IntToStr(1)
  Else
    wresult := IntToStr(11-(WSoma mod 11));
  End;
  }

  if (11-(WSoma mod 11)) > 9 then
    wresult := IntToStr(0)
  else
    wresult := IntToStr(11-(WSoma mod 11));

  result := (wresult);

End;

Function TFuncoesBancarias.Generico_ValidaCpfCnpj(sCpf: String): Boolean;
Var
  WRes  : integer;
  WSoma : integer;
  I     : integer;
  WMult : integer;
  iTeste : integer;

  wresult : String;

  bRetorno       : Boolean;
  bDigitosIguais : Boolean;

  sDvOriginal  : string;
  sDvCalculado : string;

  sDigito         : string;
  sDigitoAnterior : string;


begin

  //Limpa o cpf/cnpj
  sCpf := StringReplace(sCpf,'.','',[rfIgnoreCase, rfReplaceAll]);
  sCpf := StringReplace(sCpf,'-','',[rfIgnoreCase, rfReplaceAll]);
  sCpf := StringReplace(sCpf,'/','',[rfIgnoreCase, rfReplaceAll]);
  sCpf := StringReplace(sCpf,' ','',[rfIgnoreCase, rfReplaceAll]);
  sCpf := Trim(sCpf);

  //Se todos os digitos forem iguais tambê­ é¡©nvalido
  //Ex 111.111.111-11 ou 00.000.000/0000-00
  bDigitosIguais := True;

  for i:= 1 to length(sCpf) do
  begin

    sDigito := copy(sCpf,i,1);

    if i = 1 then
      sDigitoAnterior := copy(sCpf,i,1);

    if sDigito = sDigitoAnterior then
      sDigitoAnterior := sDigito
    else
    begin
      bDigitosIguais := False;
      Break;
    end;

  end;

  //Valida layout do copf
  //11 posiè¶¥s = CPF, 14 posiè¶¥s = CNPJ
  if ((Length(sCpf) <> 11) and (Length(sCpf) <> 14)) or (bDigitosIguais = True) then
  begin

    bRetorno := False;

  end
  else
  begin

    //Obtem Dv original
    sDvOriginal := copy(sCpf,Length(sCpf) - 1, 1) +
                   copy(sCpf,Length(sCpf), 1);

    //Remove o Dv original
    sCpf := copy(sCpf,1,Length(sCpf) - 2);

    //Obtem Dv calculado

    //Obtem o primeiro dî¨©to do Dv
    if Length(sCpf) = 9 then  //Cpf sem o dv tem 9 posiè¶¥s
      sDvCalculado := Generico_ValidaCpfCnpj_Modulo11_Cpf(sCpf)
    else
      sDvCalculado := Generico_ValidaCpfCnpj_Modulo11_Cnpj(sCpf);

    //Obtem o segundo dî¨©to do Dv
    sCpf := sCpf + sDvCalculado;

    if Length(sCpf) = 10 then //Cpf com o primeiro dî¨©to do Dv tem 10 posiè¶¥s
      sDvCalculado := sDvCalculado + Generico_ValidaCpfCnpj_Modulo11_Cpf(sCpf)   //Cpf
    else
      sDvCalculado := sDvCalculado + Generico_ValidaCpfCnpj_Modulo11_Cnpj(sCpf); //Cnpj

    if sDvCalculado = sDvOriginal then
      bRetorno := True
    else
      bRetorno := False;

  end;

  result := (bRetorno);

End;


Function TFuncoesBancarias.Generico_ValidaCpfCnpj_Modulo11_Cpf(sString:String):String;
Var
  WRes, WSoma, I, WMult: Integer;
  wresult : String;
  iTeste : Integer;
Begin
  WMult := 2;
  WSoma := 0;
  For I := Length(sString) downto 1 do
    Begin
      WRes := StrToInt(Copy(sString,I,1)) * WMult;
      WSoma := WSoma + WRes;

      WMult := WMult + 1;

      {
      If WMult = 10 Then
         WMult := 2;
      }
    End;

  if (11-(WSoma mod 11)) > 9 then
    wresult := IntToStr(0)
  else
    wresult := IntToStr(11-(WSoma mod 11));

  result := (wresult);

End;

Function TFuncoesBancarias.Generico_ValidaCpfCnpj_Modulo11_Cnpj(sString:String):String;
Var
  WRes, WSoma, I, WMult: Integer;
  wresult : String;
  iTeste : Integer;
Begin
  WMult := 2;
  WSoma := 0;
  For I := Length(sString) downto 1 do
    Begin
      WRes := StrToInt(Copy(sString,I,1)) * WMult;
      WSoma := WSoma + WRes;

      WMult := WMult + 1;

      If WMult = 10 Then
         WMult := 2;

    End;

  if (11-(WSoma mod 11)) > 9 then
    wresult := IntToStr(0)
  else
    wresult := IntToStr(11-(WSoma mod 11));

  result := (wresult);

End;

Function TFuncoesBancarias.BRASIL_CR_CODIGOBARRAS_CONVENIO_COM_7POS(sBanco, sMoeda, sVencimento, sValor, sNossoNr, sModCob: string):string;
var
  sDig_CB, sLivre, sFator : String;
begin
  sFator  := '';
  sLivre  := '';
  sDig_CB := '';

  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sLivre  := '000000' + sNossoNr + sModCob;

 //-->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDig_CB := BRASIL_SR_MODULO11(sBanco + sMoeda + sFator + sValor + sLivre);

  Result  := PChar(sBanco + sMoeda + sDig_CB + sFator + svalor + sLivre);
end;

Function TFuncoesBancarias.BRASIL_CR_LINHADIGITAVEL_CONVENIO_COM_7POS(sBanco, sMoeda, sVencimento, sValor, sNossoNr, sModCob:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
    sDig_c1, sDig_c2, sDig_c3, sFator : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  sLivre  := '000000' + sNossoNr + sModCob;
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco + sMoeda + Copy(sLivre,1,5);
  sDig_c1 := BRASIL_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sLivre,6,10);
  sDig_c2 := BRASIL_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sLivre,16,10);
  sDig_c3 := BRASIL_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRASIL_SR_MODULO11(sBanco + sMoeda + sFator + sValor + sLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator + sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function TFuncoesBancarias.BRASIL_CR_DIG_NOSSONUMERO(sNossoNr:string):string;
var
  iN1,iN2,iN3,iN4,iN5,iN6,iN7,iN8,iN9,iN10: integer;
  iN11,iN12,iN13,iN14,iN15,iN16,iN17, iAux :integer;
begin
  iN1 := StrToInt(Copy(sNossoNr,1,1) ) * 9;
  iN2 := StrToInt(Copy(sNossoNr,2,1) ) * 2;
  iN3 := StrToInt(Copy(sNossoNr,3,1) ) * 3;
  iN4 := StrToInt(Copy(sNossoNr,4,1) ) * 4;
  iN5 := StrToInt(Copy(sNossoNr,5,1) ) * 5;
  iN6 := StrToInt(Copy(sNossoNr,6,1) ) * 6;
  iN7 := StrToInt(Copy(sNossoNr,7,1) ) * 7;
  iN8 := StrToInt(Copy(sNossoNr,8,1) ) * 8;
  iN9 := StrToInt(Copy(sNossoNr,9,1) ) * 9;
  iN10:= StrToInt(Copy(sNossoNr,10,1)) * 2;
  iN11:= StrToInt(Copy(sNossoNr,11,1)) * 3;
  iN12:= StrToInt(Copy(sNossoNr,12,1)) * 4;
  iN13:= StrToInt(Copy(sNossoNr,13,1)) * 5;
  iN14:= StrToInt(Copy(sNossoNr,14,1)) * 6;
  iN15:= StrToInt(Copy(sNossoNr,15,1)) * 7;
  iN16:= StrToInt(Copy(sNossoNr,16,1)) * 8;
  iN17:= StrToInt(Copy(sNossoNr,17,1)) * 9;

  iAux := (iN1 + iN2 + iN3 + iN4 + iN5 + iN6 + iN7 + iN8 + iN9 + iN10 + iN11 + iN12 + iN13 + iN14 + iN15 + iN16 + iN17) MOD 11;

  if iAux = 10 then
    Result:= 'X'
  else
    Result:= IntToStr(iAux);

end;


end.
