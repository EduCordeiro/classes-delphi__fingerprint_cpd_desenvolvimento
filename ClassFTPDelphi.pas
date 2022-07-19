(*

  CRIADA POR: Eduardo C. M. Monteiro
  DATA: 10/06/2011

  Objetivo: Este objeto tem o objetivo de enviar e receber arquivos via ftp
            de um servidor.

  uses: IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFTP.

   /////////////////////////////////////////////////////////
  //  EXEMPLO DE USO DE UMA PROCEDURE QUE EFETUA O ENVIO //
 /////////////////////////////////////////////////////////

procedure NOME_PROJETO.NOME_PROCEDIMENTO(Sender: TObject);
var
  objFTP : TFTPDelphi;
  sHost : string;
  sUser : string;
  sPassword: string;
  sPathOrigem : string;
  sPathDestinoFTP : string;
  sArquivoLocal : string;
  sArquivoDestino: string;

begin

  sHost := '200.190.99.43';
  sUser := 'finger';
  sPassword := 'finftp07';

  sPathOrigem := 'c:\temp' + PathDelim;
  sArquivoLocal := 'contas.txt';

  sPathDestinoFTP := 'temp' + PathDelim;
  sArquivoDestino := 'contas_transferidas.txt';

  objFTP := TFTPDelphi.create(sHost, sUser, sPassword);

  if objFTP.ConectarAoServidosFTP() then
  begin

    try

      objFTP.CriarDiretorioNoServidorFTP(sPathDestinoFTP);

      if objFTP.EnviarArquivoAoServidorFTP(sPathOrigem, sArquivoLocal, sPathDestinoFTP, sArquivoDestino) then
        ShowMessage('Arquivo transmitido com sucesso !!!')
      else
        ShowMessage('ERRO AO TENTAR ENVIAR ARQUIVO DO SERVIDOR FTP ' + objFTP.getHost +
                    ' user ' + objFTP.getUser + ' senha ' + objFTP.getPassword);

    finally
      if not objFTP.DesconectarDoServidosFTP() then
        ShowMessage('ERRO AO SE DESCONECTAR DO SERVIDOR FTP ' + objFTP.getHost +
                    ' user ' + objFTP.getUser + ' senha ' + objFTP.getPassword);
    end;
  end
  else
  begin
    ShowMessage('ERRO AO SE CONECTAR AO SERVIDOR FTP ' + objFTP.getHost +
                ' user ' + objFTP.getUser + ' senha ' + objFTP.getPassword);
  end;

end;


   ///////////////////////////////////////////////////////////////
  //  EXEMPLO DE USO DE UMA PROCEDURE QUE EFETUA O RECEBIMENTO //
 ///////////////////////////////////////////////////////////////

procedure NOME_PROJETO.PROCEDIMENTO(Sender: TObject);
var
  objFTP : TFTPDelphi;
  sHost : string;
  sUser : string;
  sPassword: string;
  sPathOrigem : string;
  sPathDestinoFTP : string;
  sArquivoLocal : string;
  sArquivoDestino: string;

begin

  sHost := '200.190.99.43';
  sUser := 'finger';
  sPassword := 'finftp07';

  sPathOrigem := 'c:\temp' + PathDelim;
  sArquivoLocal := 'contas.txt';

  sPathDestinoFTP := 'temp' + PathDelim;
  sArquivoDestino := 'contas_transferidas.txt';

  objFTP := TFTPDelphi.create(sHost, sUser, sPassword);

  if objFTP.ConectarAoServidosFTP() then
  begin

    try

      if objFTP.ReceberArquivoAoServidorFTP(sPathDestinoFTP, sArquivoDestino, sPathOrigem, sArquivoLocal) then
        ShowMessage('Arquivo recebido com sucesso !!!')
      else
        ShowMessage('ERRO AO TENTAR RECEBER ARQUIVO DO SERVIDOR FTP ' + objFTP.getHost +
                    ' user ' + objFTP.getUser + ' senha ' + objFTP.getPassword);

    finally
      if not objFTP.DesconectarDoServidosFTP() then
        ShowMessage('ERRO AO SE DESCONECTAR DO SERVIDOR FTP ' + objFTP.getHost +
                    ' user ' + objFTP.getUser + ' senha ' + objFTP.getPassword);
    end;
  end
  else
  begin
    ShowMessage('ERRO AO SE CONECTAR AO SERVIDOR FTP ' + objFTP.getHost +
                ' user ' + objFTP.getUser + ' senha ' + objFTP.getPassword);
  end;

end;

*)


unit ClassFTPDelphi;
interface
  uses Windows, Classes, Dialogs, SysUtils, ComCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFTP;
type

  TFTPDelphi= class
    private
      __Conexao__            : TIdftp;
      __hos__                : String;
      __user__               : String;
      __senha__              : String;
      __pathArquivoLocal__   : String;
      __pathDestinoArquivo__ : String;
      __nomeArquivoLocal     : String;
      __nomeArquivoDestino   : String;

      //Metodos set privados

      //Métodos get privados

      // Metodos privados

    public

      //Metodos set publicos

      //Métodos get publicos
      function getHost(): string;
      function getUser(): string;
      function getPassword(): string;

      //Metodos publicos
      //constructor create(host, user, password, Proxy_host, Proxy_porta, Proxy_user, Proxy_passWord: string);
      constructor create(host, user, password: string);
      function ConectarAoServidosFTP(PathFTP: string='.\'): Boolean;
      function DesconectarDoServidosFTP(): Boolean;      
      function CriarDiretorioNoServidorFTP(nomeDireto: string): Boolean;
      function DeletarDiretorioNoServidorFTP(nomeDiretorio: string): Boolean;
      function DeletarArquivoNoServidorFTP(PathFTP: string; nomeArquivo: string): Boolean;
      function EnviarArquivoAoServidorFTP(PathOrigemDoArquivo,
                                          nomeDoArquivoOrigem,
                                          PathDestinoFTP,
                                          nomeArquivoDestinoFTP: string): Boolean;

      function ReceberArquivoDoServidorFTP(PathFTP: string; ArquivoOrigem: string; Direc: String; ArquivoDestino: String; repli: Boolean=true): Boolean;

      function getListaDeArquivosNoServidorFTP(PathFTP: string; var stlListaDeArquivos: TStringList; extensao: string='*.*'): Boolean;



   End;

implementation
//uses ;
{ TContagemCedulas }

//Metodos set privados

//Métodos get privados

//Metodos set publicos

//Métodos get publicos

//Metodos publicos
//constructor TFTPDelphi.create(host, user, password, Proxy_host, Proxy_porta, Proxy_user, Proxy_passWord : string);
constructor TFTPDelphi.create(host, user, password : string);
begin
  __Conexao__ := TIdftp.Create(nil);
  __hos__     := host;
  __user__    := user;
  __senha__   := password;

  __Conexao__.Host     := __hos__;
  __Conexao__.Username := __user__;
  __Conexao__.Password := __senha__;


// Não implementado.  
//  __Conexao__.Port       := StrToInt(Proxy_porta);
//  __Conexao__.ProxySettings.UserName  := Proxy_user;
//  __Conexao__.ProxySettings.Password  := Proxy_passWord;
//  __Conexao__.ProxySettings.Host      := Proxy_host;
//  __Conexao__.ProxySettings.Port      := StrToInt(Proxy_porta);


end;

function TFTPDelphi.ConectarAoServidosFTP(PathFTP: string='.\'): Boolean;
var
  sMSG : string;
begin
  try
    __Conexao__.Connect;
    __Conexao__.changeDir(PathFTP);
    result := True;
  except

    on E:Exception do
    begin

      sMSG := '[ERRO] Não foi possível inicializar as configurações do programa. '+#13#10#13#10
            + ' EXCEÇÃO: '+E.Message+#13#10#13#10
            + ' O programa será encerrado agora.';

      showmessage(sMSG);
      result := False;

    end;


  end;
end;

function TFTPDelphi.DesconectarDoServidosFTP(): Boolean;
begin
  try
    __Conexao__.Disconnect;
    result := True;
  except
    result := False;
  end;
end;

function TFTPDelphi.CriarDiretorioNoServidorFTP(nomeDireto: string): Boolean;
begin
  try
    __Conexao__.MakeDir(nomeDireto);
    Result := true
  except
      Result := False;
  end;
end;

function TFTPDelphi.DeletarDiretorioNoServidorFTP(nomeDiretorio: string): Boolean;
begin
  try
    __Conexao__.Delete(nomeDiretorio);
    Result := true
  except
      Result := False;
  end;
end;

function TFTPDelphi.EnviarArquivoAoServidorFTP(PathOrigemDoArquivo,
                                               nomeDoArquivoOrigem,
                                               PathDestinoFTP,
                                               nomeArquivoDestinoFTP: string): Boolean;
begin
  try
    __Conexao__.put(PathOrigemDoArquivo + nomeDoArquivoOrigem, PathDestinoFTP + nomeArquivoDestinoFTP); // D7.0
    Result := true
  except
    Result := False;
  end;
end;

function TFTPDelphi.ReceberArquivoDoServidorFTP(PathFTP: string; ArquivoOrigem: string; Direc: String; ArquivoDestino: String; repli: Boolean=True): Boolean;
var
  line: string;
begin

  line := Direc + ArquivoDestino;

  if not DirectoryExists(direc) then
    ForceDirectories(direc);

 if (FileExists(line)) then
  BEGIN
    if repli THEN
    BEGIN
      DeleteFile(line);
    END
    else
    BEGIN
      ShowMessage('o arquivo ja existe neste local');
      abort;
    END;
  end;
  if NOT (FileExists(line)) then
  BEGIN
    try

      if not __Conexao__.Connected then
      begin
        __Conexao__.Connect;
        __Conexao__.ChangeDir(PathFTP);
      end;
      __Conexao__.Get(ArquivoOrigem, Line, false);
      Result := True;
    except
      Result := False;
    end;

    //if __Conexao__.Connected then
    //  __Conexao__.Disconnect;

  END;
end;

function TFTPDelphi.getListaDeArquivosNoServidorFTP(PathFTP: string; var stlListaDeArquivos: TStringList; extensao: string='*.*'): Boolean;
begin
  try

    if not Assigned(stlListaDeArquivos) then
      stlListaDeArquivos := TStringList.Create();

    stlListaDeArquivos.Clear;

    if not __Conexao__.Connected then
      __Conexao__.Connect;


    __Conexao__.list(stlListaDeArquivos, extensao, true);

    if __Conexao__.Connected then
      __Conexao__.Disconnect;

    Result := true;  

  except
    ShowMessage('ERRO AO OBTER LISTA DE ARQUIVOS NO SERVIDOR FTP');
    Result := false;
  end;
end;

function TFTPDelphi.DeletarArquivoNoServidorFTP(PathFTP: string; nomeArquivo: string): Boolean;
begin
  try
    if not __Conexao__.Connected then
    begin
      __Conexao__.Connect;
      __Conexao__.changeDir(PathFTP);
    end;

    __Conexao__.Delete(nomeArquivo);
    
    Result := true;

  except
    Result := False;
  end;

  if __Conexao__.Connected then
    __Conexao__.Disconnect;

end;

function TFTPDelphi.getHost(): string;
begin
  Result:= __hos__;
end;

function TFTPDelphi.getUser(): string;
begin
  Result:= __user__;
end;
function TFTPDelphi.getPassword(): string;
begin
  Result := __senha__;
end;

end.
