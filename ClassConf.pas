unit ClassConf;
interface
  uses Classes, Dialogs, SysUtils, Forms,
       ClassStrings;
type

  TArquivoConf= class
    private
      __ArquivoConf__          : String;
      __Path__                 : String;
      __ListaDeConfiguracoes__ : TStringList;
      __ListaDeValoreConf__    : TStringList;
      __id_processamento__     : String;

      //Métodos set
      Function setArquivoConf(ArquivoConf: String): Boolean;
      Function setPathArquivoConf(PathArquivoConf: String): Boolean;
      Function setListaDeConfiguracoes(Campo: String): Boolean;
      Function setListaDeValoreConf(Valor: String): Boolean;

    public
      //Métodos get
      Function getArquivoConf(): String;
      Function getPathArquivoConf(): String;
      Function getCampoConf(indice: Integer): String;
      Function getValorConf(indice: Integer): String;
      Function getNumeroDeLinhasConf(): Integer;
      function getIDProcessamento(): String;
      function getConfiguracao(campo: string): string;
      {Método construtor da classe}
      constructor create(PathArquivoConf, nomeApp: String; Separador: String='=');

   End;


implementation
//uses Math;

Function TArquivoConf.setArquivoConf(ArquivoConf: String): Boolean;
Begin
  __ArquivoConf__:= ArquivoConf;
end;

Function TArquivoConf.setPathArquivoConf(PathArquivoConf: String): Boolean;
Begin
  try
    __Path__:= PathArquivoConf;
    Result := True;
  except
    Result := False;
  end;
end;

Function TArquivoConf.setListaDeConfiguracoes(Campo: String): Boolean;
Begin
  if not Assigned(__ListaDeConfiguracoes__) then
  Begin
    __ListaDeConfiguracoes__:= TStringList.Create();
    __ListaDeConfiguracoes__.Clear;
  end;

  __ListaDeConfiguracoes__.Add(Campo);

end;

Function TArquivoConf.setListaDeValoreConf(Valor: String): Boolean;
Begin
  if not Assigned(__ListaDeValoreConf__) then
  Begin
    __ListaDeValoreConf__:= TStringList.Create();
    __ListaDeValoreConf__.Clear;
  end;

  __ListaDeValoreConf__.Add(Valor);

end;

constructor TArquivoConf.create(PathArquivoConf, nomeApp: String; Separador: String='=');
var
  arqArquivoConf : TextFile;
  sLinha         : String;
  sNomeAplicacao : string;
  objFormataString : TFormataString;
begin

  try
    nomeApp := StringReplace(nomeApp, '.exe', '', [rfReplaceAll, rfIgnoreCase]);

    setPathArquivoConf(PathArquivoConf);

    sNomeAplicacao := nomeApp;
    setArquivoConf(sNomeAplicacao + '.conf');

    if FileExists(getPathArquivoConf() + getArquivoConf()) Then
    Begin
      AssignFile(arqArquivoConf, getPathArquivoConf() + getArquivoConf());
      Reset(arqArquivoConf);
      while not eof(arqArquivoConf) do
      Begin
        readln(arqArquivoConf, sLinha);
        setListaDeConfiguracoes(Trim(objFormataString.getTermo(1, Separador, sLinha)));
        setListaDeValoreConf(Trim(objFormataString.getTermo(2, Separador, sLinha)));
      end;
      CloseFile(arqArquivoConf);

    End
    else
    Begin
      ShowMessage('ATENCAO !!! O ARQUIVO '
      + getPathArquivoConf() + getArquivoConf()
      + ' NAO EXISTE NO DIRETORIO DA APLICACAO. O MESMO SERA CRIADO EM '
      + getPathArquivoConf() + getArquivoConf());
      AssignFile(arqArquivoConf,  getPathArquivoConf() + getArquivoConf());
      Rewrite(arqArquivoConf);
      WriteLn(arqArquivoConf, '');
      CloseFile(arqArquivoConf);
    End;

  finally
    FreeAndNil(objFormataString);
  end;

End;

//Método set
Function TArquivoConf.getNumeroDeLinhasConf(): Integer;
Begin
  if Assigned(__ListaDeConfiguracoes__) Then
    Result:= __ListaDeConfiguracoes__.Count
  else
    Result := 0;
end;

//Método get
Function TArquivoConf.getCampoConf(indice: Integer): String;
Begin
  Result:= __ListaDeConfiguracoes__.Strings[indice];
end;

Function TArquivoConf.getValorConf(indice: Integer): String;
Begin
  Result:=  Trim(__ListaDeValoreConf__.Strings[indice]);
end;

Function TArquivoConf.getArquivoConf(): String;
Begin
  Result:= __ArquivoConf__;
end;

Function TArquivoConf.getPathArquivoConf(): String;
Begin
  Result:= __Path__;
end;

function TArquivoConf.getIDProcessamento(): String;
Var
  sID_Base: String;
Begin

  Randomize;


  sID_Base := FormatDateTime('yy-mm-dd hh:ss:zz', Now());
  sID_Base := StringReplace(sID_Base, '-', '', [rfReplaceAll]);
  sID_Base := StringReplace(sID_Base, ' ', '', [rfReplaceAll]);
  sID_Base := StringReplace(sID_Base, ':', '', [rfReplaceAll]);
  Result   := sID_Base + FormatFloat('0000', Random(9999))
end;

function TArquivoConf.getConfiguracao(campo: string): string;
var
  iContLinhasDeConfiguracao : Integer;
  iTotalDeConfiguracoes : Integer;
  sConfiguracao : string;
  sValorConfiguracao : string;
begin
    iTotalDeConfiguracoes    := getNumeroDeLinhasConf();
    for iContLinhasDeConfiguracao:= 0 to iTotalDeConfiguracoes - 1 do
    Begin
      sConfiguracao     := getCampoConf(iContLinhasDeConfiguracao);
      sValorConfiguracao:= getValorConf(iContLinhasDeConfiguracao);

      if AnsiUpperCase(sconfiguracao) = AnsiUpperCase(campo) then
      begin
        Result := svalorconfiguracao;
        Break;
      end;
    end;
end;

end.
