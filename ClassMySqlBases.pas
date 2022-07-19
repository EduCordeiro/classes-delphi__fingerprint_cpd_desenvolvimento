unit ClassMySqlBases;
interface
//  uses Classes, Dialogs, SysUtils, Process, ZConnection, ZDataset;
  uses Forms, Classes, Dialogs, SysUtils, ZConnection, ZDataset, ZSqlProcessor, ZAbstractRODataset, ZAbstractDataset, ZSqlMonitor,
  // Classes
  ClassLog, ClassStatusProcessamento;
type


  TMysqlDatabase= class
    private
      {Propriedades privadas}
      __ListaDeBases__      : TStringList;

      {MÃ©todos privados}
      //function AlimentaListaDeBasesDoHost(): Boolean;
    public

      __Conexao__            : TZConnection;
      objLogar               : TArquivoDelog;
      objStatusProcessamento : TStausProcessamento;

      //MÃ©todos get publicos
      function getHostName(): String;
      function getBase(): String;
      function getUser(): String;
      function getPassword(): String;
      function getProtocolo(): String;
//      function getConexao(): TZConnection;
//      function getListaBases(): TStringList;

      {MÃ©todos pÃºblicos}
      Function ValidaPropriedades(): Boolean;

      function ConectarAoBanco(HostName, Database, user, password, protocolo: String; logarParametros: Boolean=True): boolean;
      Function Executar_SQL(Var Consulta: TZQuery; SQL: string; Tipo: Integer; logarErro:boolean=true; exibirErro:boolean=true): TStausProcessamento;
      function ExecutaScript(Var SQL: TStringList; logarErro:boolean=true; exibirErro:boolean=true): TStausProcessamento;
      function CriarDatabase(hostname, Base, user, password, protocolo: string): Boolean;


      {MÃ©todo Construtor}
      constructor create();
  End;

implementation
uses Math;

{MÃ©todos ge}
constructor TMysqlDatabase.create();
begin
  objLogar               := TArquivoDelog.create();
  objStatusProcessamento := TStausProcessamento.create();
end;


function TMysqlDatabase.getHostName(): String;
Begin
  Result:= __Conexao__.HostName;
end;

function TMysqlDatabase.getBase(): String;
Begin
  Result:= __Conexao__.Database;
end;

function TMysqlDatabase.getUser(): String;
Begin
  Result:= __Conexao__.User;
end;

function TMysqlDatabase.getPassword(): String;
Begin
  Result:= __Conexao__.Password;
end;

function TMysqlDatabase.getProtocolo(): String;
Begin
  Result:= __Conexao__.Protocol;
end;

(*
function TMysqlDatabase.getConexao(): TZConnection;
Begin
  Result:= __Conexao__;
end;

function TMysqlDatabase.getListaBases(): TStringList;
Begin

  if not Assigned(__ListaDeBases__) Then
    __ListaDeBases__:= TStringList.Create();

  if ValidaPropriedades() Then
    AlimentaListaDeBasesDoHost();

  Result:= __ListaDeBases__;

end;
*)
function  TMysqlDatabase.ConectarAoBanco(HostName, Database, user, password, protocolo: String; logarParametros: Boolean=True): boolean;
var
  sMsg     : String;
begin

  try

    if not Assigned(__Conexao__) Then
      __Conexao__:= TZConnection.Create(nil)
    else
      __Conexao__.Disconnect;

    __Conexao__.HostName  := HostName;
    __Conexao__.Database  := Database;
    __Conexao__.User      := User;
    __Conexao__.Password  := Password;
    __Conexao__.Protocol  := protocolo;
    __Conexao__.Properties.Add(' CLIENT_MULTI_STATEMENTS=1 ');

    __Conexao__.Connected := true;


    Result := True;

    if logarParametros then
    begin
      objLogar.Logar('[DEBUG] :: CONEXAO COM A BASE');
      objLogar.Logar('[DEBUG] HOST .............: ' + HostName);
      objLogar.Logar('[DEBUG] DATABASE DEFAULT..: ' + Database);
      objLogar.Logar('[DEBUG] USER .............: ' + User);
      //objLogar.Logar('[DEBUG] PASSWORD .........: ' + Password);
      objLogar.Logar('[DEBUG] PROTOCOLO.........: ' + protocolo);
    end;

  except

    on E:Exception do
    begin
      sMsg:='Nao foi possi­vel conectar ao banco "'
            + __Conexao__.Database + ':' + __Conexao__.HostName + '". Excecao: '
            + E.Message;

      objLogar.Logar(sMsg);
      Result := false;
    end;
  end;

end;
(*
function TMysqlDatabase.AlimentaListaDeBasesDoHost(): Boolean;
var
  objConsulta                                    : TMySqlQuery;
  sComando                                       : String;
  sSelect                                        : String;
  sWhere                                         : String;
  sGroupBy                                       : String;
  sOrderBy                                       : String;
begin
  Try

    try
      objConsulta := TMySqlQuery.Create();
      If ValidaPropriedades() Then
      Begin
        sSelect  := 'show databases';
        sWhere   := '';
        sGroupBy := '';
        sOrderBy := '';
        sComando := sSelect + sWhere + sGroupBy + sOrderBy;
        objConsulta.Executar_SQL(__Conexao__, sComando, 2);
        if Assigned(__ListaDeBases__) Then
        Begin
          __ListaDeBases__:= TStringList.Create();
          __ListaDeBases__.Clear;
        end;
        while not objConsulta.getQuerySQL().EOF do
        Begin
          __ListaDeBases__.Add(objConsulta.getQuerySQL().FieldByName('database').AsString);
          objConsulta.getQuerySQL().Next;
        end;
        Result:= True;
      end;
    except
      on E:Exception do
      begin
        ShowMessage('Nao foi possi­vel conectar ao banco "'+ __Conexao__.Database + ':' + __Conexao__.HostName + '". Excecao: '+E.Message);
        Result:= false;
      end;
    end;
  finally
    FreeAndNil(objConsulta);
  end;
end;
*)

Function TMysqlDatabase.ValidaPropriedades(): Boolean;
Begin
  if not Assigned(__Conexao__) Then
  bEGIN
    ShowMessage('OBJETO NÃƒO CRIADO.');
    Result:= False;
  end
  else
  if(getHostName() = '') or
    (getBase() = '') or
    (getUser() = '') or
    (getProtocolo() = '') Then
  bEGIN
    ShowMessage('OBJETO SEM PROPRIEDADES.');
    Result:= False;
  end
  else
  if not __Conexao__.Connected Then
  bEGIN
    ShowMessage('OBJETO NÃƒO CONECTADO.');
    Result:= False;
  end
  else
    Result := true;
end;

Function TMysqlDatabase.Executar_SQL(Var Consulta: TZQuery; SQL: string; Tipo: Integer; logarErro:boolean=true; exibirErro:boolean=true): TStausProcessamento;
begin
  begin
    try

      if not Assigned(Consulta) Then
        Consulta:= TZQuery.Create(nil);

      if Consulta.Active then
        Consulta.close;

      Consulta.Connection := __Conexao__;

      Consulta.SQL.Clear;
      Consulta.SQL.Text := SQL;

      case tipo of
        1: Consulta.ExecSQL; //usado para updates, inserts e deletes
        2: Consulta.Open;    //usado para select
      end;

      objStatusProcessamento.status := True;
      result                        := objStatusProcessamento;
    except

       on E:Exception do
      begin

        if logarErro then
        begin
          objLogar.Logar('[ERRO] Não foi possível executar a Query. Exceção: '+E.Message+' SQL: '+SQL);
          objLogar.Logar('==> Não foi possível executar a Query. Conexão: ' + __Conexao__.HostName
                       + ' - Base: ' + __Conexao__.Database
                       + '. Exceção: ' + E.Message
                       + ' SQL: '+SQL+' '+FORMATDATETIME('DD/MM/YYYY HH:MM:SS',Now));
        end;

        if exibirErro then
          ShowMessage('Não foi possível executar a Query. Exceção: '+E.Message+' SQL: '+SQL);

        objStatusProcessamento.status := false;
        objStatusProcessamento.msg    := E.Message;
        result                        := objStatusProcessamento;

      end;

    end;
  end;
end;

function TMysqlDatabase.ExecutaScript(Var SQL: TStringList; logarErro:boolean=true; exibirErro:boolean=true): TStausProcessamento;
Var
  zsExecutaScript                  : TZSQLProcessor;
begin

  try
    zsExecutaScript            := TZSQLProcessor.Create(Application);
    zsExecutaScript.Connection := __Conexao__;

    zsExecutaScript.Clear;
    zsExecutaScript.Script.Text := SQL.Text;
    zsExecutaScript.Execute;

    objStatusProcessamento.status := true;
    result                        := objStatusProcessamento;
  except

    on E:Exception do
    begin

      if logarErro then
      begin
        objLogar.Logar('[ERRO] Não foi possível executar a Query. Exceção: '+E.Message+' SQL: '+SQL.Text);
        objLogar.Logar('=========> Não foi possível executar a Query. Conexão: ' + __Conexao__.hostname
              + ' - Base: ' + __Conexao__.database + '. Exceção: '+E.Message
              +' SQL: '+SQL.Text+' '+FORMATDATETIME('DD/MM/YYYY HH:MM:SS',Now));
      end;

      if exibirErro then
        ShowMessage('Não foi possível executar a Query. Exceção: '+E.Message+' SQL: '+SQL.Text);

      objStatusProcessamento.status := false;
      objStatusProcessamento.msg    := E.Message;
      result                        := objStatusProcessamento;

    end;

  end;

end;

function TMysqlDatabase.CriarDatabase(hostname, Base, user, password, protocolo: string): Boolean;
begin
  Result := True;
end;

end.
