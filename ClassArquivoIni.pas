{

Nome anterior do arquivo: ClassIni.pas

Utilizacao da classe ClasseArquivoIni
------------------------------------

1)O Primeiro passo e declarar o objeto na sessa£o Var:
    Var
      objIni             : ClasseArquivoIni;

2)Apos sua declaracao, devemos criar o objeto:
    objIni         := TArquivoIni.Create();

    Obs: Em sua criacao, o metodos construtor ja¡ se encarregara¡ de
    verificar se o arquivo ini ja¡ existe caso na£o exista o mesmo se oferecera¡ para cria-lo

3) Apos o objeto criado, podemos obter informaa§aµes dos metodos para:

    Retornar o path contido no arquivo ini do arquivo databases.conf:
    objIni.GetPathConexoes()

    Retornar o path contido no arquivo ini do arquivo de configuracao(mesmo nome da aplicacao) da aplicacao:
    objIni.getPathConfiguracoes()

    Retornar o path contido no arquivo ini dos arquivos de script sql:
    objIni.getPathScripSQL()

    Retornar o path contido no arquivo ini dos arquivos tempora¡rios:
    objIni.getPathArquivosTemporarios()

    Retornar o path contido no arquivo ini para outros recursos:
    objIni.getPathOutrosRecursos()
}

unit ClassArquivoIni;
interface
  uses
    Classes, ComCtrls, Controls, DateUtils, db, DBGrids, Dialogs,
    ExtCtrls, filectrl, Forms, Graphics, Grids, ImgList, IniFiles, Menus, Messages,
    Printers, Registry, ShellAPI, StdCtrls, SysUtils, Variants, Windows, WinSock,
    ZAbstractDataset, ZAbstractRODataset, ZConnection, ZDataset, ClassStrings, ClassLog;
type

  TArquivoIni= class
    Private
      __arquivoIni__               : String;
      __path__                     : String;
      __pathConexoesDB__           : String;
      __pathConexoesDB_2__         : String;
      __pathConfiguracoes__        : String;
      __pathScripSQL__             : String;
      __pathArquivosTemporarios__  : String;
      __pathOutrosRecursos__       : String;

      objString         : TFormataString;
      objLogar          : TArquivoDelog;

      //Metodo set
      Function setArquivoIni(const arquivo: String): Boolean;
      Function setPath(const path: String): Boolean;
      Function setPathConexoes(const path: String): Boolean;
      Function setPathConexoes_2(const path: String): Boolean;
      Function setPathConfiguracoes(const path: String): Boolean;
      Function setPathScripSQL(const path: String): Boolean;
      Function setPathArquivosTemporarios(const path: String): Boolean;
      Function setPathOutrosRecursos(const path: String): Boolean;

    public
      //Metodo get
      Function getArquivoIni(): String;
      Function getPath(): String;
      Function getPathConexoes(): String;
      Function getPathConexoes_2(): String;
      Function getPathConfiguracoes(): String;
      Function getPathScripSQL(): String;
      Function getPathArquivosTemporarios(): String;
      Function getPathOutrosRecursos(): String;

      {Metodo construtor da classe}
      Constructor create(Var objLogar: TArquivoDelog;
                         Var objString : TFormataString;
                         path, nomeAplicacao: String);

  End;

implementation
//uses Math, ;

//Metodo get
Constructor TArquivoIni.create(Var objLogar: TArquivoDelog;
                               Var objString : TFormataString;
                               path, nomeAplicacao: String);
var
  arqArquivoIni : TextFile;
  sLinha        : String;
  sParametro    : string;
begin
  (* uses unit Forms;
     Application: TApplication;
  *)

  objString         := objString;
  objLogar          := objLogar;

  nomeAplicacao := StringReplace(nomeAplicacao, '.exe', '', [rfReplaceAll, rfIgnoreCase]);

  setPath(path);
  setArquivoIni(AnsiLowerCase(nomeAplicacao + '.ini'));

  if FileExists(getPath() + getArquivoIni()) Then
  Begin
    AssignFile(arqArquivoIni, getPath() + getArquivoIni());
    Reset(arqArquivoIni);
    while not eof(arqArquivoIni) do
    Begin
      readln(arqArquivoIni, sLinha);

      sParametro := Trim(Copy(sLinha, 1, Pos('=', sLinha)-1));

      if sParametro = 'PATH_CONEXOES' Then
        setPathConexoes(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if sParametro = 'PATH_CONEXOES_2' Then
        setPathConexoes_2(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if sParametro = 'PATH_CONFIGURACOES' Then
        setPathConfiguracoes(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if sParametro = 'PATH_ARQUIVOS_TEMPORARIOS' Then
        setPathArquivosTemporarios(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if sParametro = 'PATH_SCRIPTS_SQL' Then
        setPathScripSQL(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if sParametro = 'PATH_OUTROS_RECURSOS' Then
        setPathOutrosRecursos(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

    end;
    CloseFile(arqArquivoIni);
  end
  else
  Begin
    ShowMessage('ATENENCAO !!! O ARQUIVO '
    + getPath() + getArquivoIni()
    + ' NAO EXISTE NO DIRETORIO DA APLICACAO. O MESMO SERA CRIADO.');
    AssignFile(arqArquivoIni, getPath() + getArquivoIni());
    Rewrite(arqArquivoIni);

    writeln(arqArquivoIni,'PATH_CONEXOES = .\diretorio_conexao\');
    setPathConexoes('.\diretorio_conexao\');

    writeln(arqArquivoIni,'PATH_CONEXOES_2 = .\diretorio_conexao\');
    setPathConexoes('.\diretorio_conexao\');

    writeln(arqArquivoIni,'PATH_CONFIGURACOES = .\diretorio_configuracao\');
    setPathConfiguracoes('.\diretorio_configuracao\');

    writeln(arqArquivoIni,'PATH_ARQUIVOS_TEMPORARIOS = .\diretorio_arquivos_temporarios\');
    setPathArquivosTemporarios('.\diretorio_arquivos_temporarios\');

    writeln(arqArquivoIni,'PATH_SCRIPTS_SQL = .\diretorio_scripts_sql\');
    setPathScripSQL('.\diretorio_scripts_sql\');

    writeln(arqArquivoIni,'PATH_OUTROS_RECURSOS = .\diretorio_outros_recursos\');
    setPathOutrosRecursos('.\diretorio_outros_recursos\');

    CloseFile(arqArquivoIni);
  end;

end;

//Metodo set
Function TArquivoIni.setArquivoIni(const arquivo: String): Boolean;
Begin
  __arquivoIni__:= arquivo;
end;

Function TArquivoIni.setPath(const path: String): Boolean;
Begin
  try
    __path__:= objString.AjustaPath(path);
    Result := True;
  except
    Result := False;
  end;
end;

Function TArquivoIni.setPathConexoes(const path: String): Boolean;
Begin
  Try
    __pathConexoesDB__:= objString.AjustaPath(path);
    Result := True;
  finally
    Result := false
  end;
end;

Function TArquivoIni.setPathConexoes_2(const path: String): Boolean;
Begin
  Try
    __pathConexoesDB_2__:= objString.AjustaPath(path);
    Result := True;
  finally
    Result := false
  end;
end;

Function TArquivoIni.setPathConfiguracoes(const path: String): Boolean;
Begin
  try
    __pathConfiguracoes__:= objString.AjustaPath(path);
    Result := True;
  finally
    Result := False;
  end;
end;

Function TArquivoIni.setPathScripSQL(const path: String): Boolean;
Begin
  try
    __pathScripSQL__:= objString.AjustaPath(path);
    Result := True;
  finally
    Result := False;
  end;
end;

Function TArquivoIni.setPathArquivosTemporarios(const path: String): Boolean;
Begin
  try
    __pathArquivosTemporarios__:= objString.AjustaPath(path);
    Result := True;
  finally
    Result := False;
  end;
end;

Function TArquivoIni.setPathOutrosRecursos(const path: String): Boolean;
Begin
  try
    __pathOutrosRecursos__:= objString.AjustaPath(path);
    Result := True;
  finally
    Result := False;
  end;
end;

Function TArquivoIni.getArquivoIni(): String;
Begin
  Result := __arquivoIni__;
end;

Function TArquivoIni.getPath(): String;
Begin
  Result := __path__;
end;

Function TArquivoIni.GetPathConexoes(): String;
Begin
  Result := __pathConexoesDB__;
end;

Function TArquivoIni.GetPathConexoes_2(): String;
Begin
  Result := __pathConexoesDB_2__;
end;

Function TArquivoIni.GetPathConfiguracoes(): String;
Begin
  Result := __pathConfiguracoes__;
end;

Function TArquivoIni.GetPathScripSQL(): String;
Begin
  Result := __pathScripSQL__;
end;

Function TArquivoIni.GetPathArquivosTemporarios(): String;
Begin
  Result := __pathArquivosTemporarios__;
end;

Function TArquivoIni.GetPathOutrosRecursos(): String;
Begin
  Result := __pathOutrosRecursos__;
end;

end.
