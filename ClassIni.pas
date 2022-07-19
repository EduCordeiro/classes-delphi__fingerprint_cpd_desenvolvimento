{
Utilizacao da classe ClasseArquivoIni
------------------------------------

1)O Primeiro passo e declarar o objeto na sessa£o Var:
    Var
      objIni             : ClasseArquivoIni;

2)Apos sua declaracao, devemos criar o objeto:
    objIni         := TArquivoIni.Create();

    Obs: Em sua criacao, o metodos construtor ja° se encarregara° de
    verificar se o arquivo ini ja° existe caso na£o exista o mesmo se oferecera° para cria-lo

3) Apos o objeto criado, podemos obter informaaßaµes dos metodos para:

    Retornar o path contido no arquivo ini do arquivo databases.conf:
    objIni.GetPathConexoes()

    Retornar o path contido no arquivo ini do arquivo de configuracao(mesmo nome da aplicacao) da aplicacao:
    objIni.getPathConfiguracoes()

    Retornar o path contido no arquivo ini dos arquivos de script sql:
    objIni.getPathScripSQL()

    Retornar o path contido no arquivo ini dos arquivos tempora°rios:
    objIni.getPathArquivosTemporarios()

    Retornar o path contido no arquivo ini para outros recursos:
    objIni.getPathOutrosRecursos()
}

unit ClassIni;
interface
  uses
    Classes, ComCtrls, Controls, DateUtils, db, DBGrids, Dialogs,
    ExtCtrls, filectrl, Forms, Graphics, Grids, ImgList, IniFiles, Menus, Messages,
    Printers, Registry, ShellAPI, StdCtrls, SysUtils, Variants, Windows, WinSock,
    ZAbstractDataset, ZAbstractRODataset, ZConnection, ZDataset;
type

  TArquivoIni= class
    Private
      __arquivoIni__               : String;
      __path__                     : String;
      __pathConexoesDB__           : String;
      __pathConfiguracoes__        : String;
      __pathScripSQL__             : String;
      __pathArquivosTemporarios__  : String;
      __pathOutrosRecursos__       : String;

      //Metodo set
      Function setArquivoIni(const arquivo: String): Boolean;
      Function setPath(const path: String): Boolean;
      Function setPathConexoes(const path: String): Boolean;
      Function setPathConfiguracoes(const path: String): Boolean;
      Function setPathScripSQL(const path: String): Boolean;
      Function setPathArquivosTemporarios(const path: String): Boolean;
      Function setPathOutrosRecursos(const path: String): Boolean;

    public
      //Metodo get
      Function getArquivoIni(): String;
      Function getPath(): String;
      Function getPathConexoes(): String;
      Function getPathConfiguracoes(): String;
      Function getPathScripSQL(): String;
      Function getPathArquivosTemporarios(): String;
      Function getPathOutrosRecursos(): String;

      {Metodo construtor da classe}
      Constructor create(path, nomeAplicacao: String);

  End;

implementation
//uses Math, ;

//Metodo get
Constructor TArquivoIni.create(path, nomeAplicacao: String);
var
  arqArquivoIni : TextFile;
  sLinha        : String;
begin
  (* uses unit Forms;
     Application: TApplication;
  *)

  setPath(path);
  setArquivoIni(AnsiLowerCase(nomeAplicacao + '.ini'));

  if FileExists(getPath() + getArquivoIni()) Then
  Begin
    AssignFile(arqArquivoIni, getPath() + getArquivoIni());
    Reset(arqArquivoIni);
    while not eof(arqArquivoIni) do
    Begin
      readln(arqArquivoIni, sLinha);

      if Pos('PATH_CONEXOES', sLinha) > 0 Then
        setPathConexoes(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if Pos('PATH_CONFIGURACOES', sLinha) > 0 Then
        setPathConfiguracoes(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if Pos('PATH_ARQUIVOS_TEMPORARIOS', sLinha) > 0 Then
        setPathArquivosTemporarios(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if Pos('PATH_SCRIPTS_SQL', sLinha) > 0 Then
        setPathScripSQL(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

      if Pos('PATH_OUTROS_RECURSOS', sLinha) > 0 Then
        setPathOutrosRecursos(Trim(Copy(sLinha, pos('=', sLinha) + 1, Length(sLinha))));

    end;
    CloseFile(arqArquivoIni);
  end
  else
  Begin
    ShowMessage('ATENaáaÉO !!! O ARQUIVO '
    + getPath() + getArquivoIni()
    + ' NaÉO EXISTE NO DIRETaìRIO DA APLICAaáaÉO. O MESMO SERaÅ CRIADO.');
    AssignFile(arqArquivoIni, getPath() + getArquivoIni());
    Rewrite(arqArquivoIni);

    writeln(arqArquivoIni,'PATH_CONEXOES = .\diretorio_conexao\');
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
    __path__:= path;
    Result := True;
  except
    Result := False;
  end;
end;

Function TArquivoIni.setPathConexoes(const path: String): Boolean;
Begin
  Try
    __pathConexoesDB__:= path;
    Result := True;
  finally
    Result := false
  end;
end;

Function TArquivoIni.setPathConfiguracoes(const path: String): Boolean;
Begin
  try
    __pathConfiguracoes__:= path;
    Result := True;
  finally
    Result := False;
  end;
end;

Function TArquivoIni.setPathScripSQL(const path: String): Boolean;
Begin
  try
    __pathScripSQL__:= path;
    Result := True;
  finally
    Result := False;
  end;
end;

Function TArquivoIni.setPathArquivosTemporarios(const path: String): Boolean;
Begin
  try
    __pathArquivosTemporarios__:= path;
    Result := True;
  finally
    Result := False;
  end;
end;

Function TArquivoIni.setPathOutrosRecursos(const path: String): Boolean;
Begin
  try
    __pathOutrosRecursos__:= path;
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
