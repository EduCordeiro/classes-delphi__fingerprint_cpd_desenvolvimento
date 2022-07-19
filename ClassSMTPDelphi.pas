(*

  CRIADA POR: Eduardo C. M. Monteiro
  DATA: 10/06/2011

  Objetivo: Este objeto tem o objetivo de enviar e receber e-mails.

  uses: IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFTP.

   /////////////////////////////////////////////////////////
  //  EXEMPLO DE USO DE UMA PROCEDURE QUE EFETUA O ENVIO //
 /////////////////////////////////////////////////////////
procedure TForm1.btnEnviarClick(Sender: TObject);
var
  objEmail : TSMTPDelphi;
  sHost : string;
  suser : string;
  sFrom : string;
  sTo : string;
  sAssunto : string;
  sCorpo : string;
  sAnexo : string;
begin

  sHost := '192.168.0.10';
  suser := 'ecordeiro@fingerprint.emp';
  sFrom := edtFrom.Text;
  sTo   := edtTo.Text;
  sAssunto := edtAssunto.Text;
  sCorpo := edtCorpo.Text;
  sAnexo := StringReplace(edtAnexo.Text, '"', '', [rfReplaceAll, rfIgnoreCase]);
  sAnexo := StringReplace(edtAnexo.Text, '''', '', [rfReplaceAll, rfIgnoreCase]);

  try

    objEmail := TSMTPDelphi.create(sHost, suser);

    if objEmail.ConectarAoServidorSMTP() then
    begin
      if objEmail.AnexarArquivo(sAnexo) then
      begin

          if not (objEmail.EnviarrEmail(sFrom, sTo, sAssunto, sCorpo)) then
            ShowMessage('ERRO AO ENVIAR O E-MAIL')
          else
          if not objEmail.DesconectarDoServidorSMTP() then
            ShowMessage('ERRO AO DESCONECTAR DO SERVIDOR');
      end
      else
        ShowMessage('ERRO AO ANEXAR O ARQUIVO');
    end
    else
      ShowMessage('ERRO AO CONECTAR AO SERVIDOR');

  except
    ShowMessage('NÃO FOI POSSIVEL ENVIAR O E-MAIL.');
  end;
end;

*)


unit ClassSMTPDelphi;
interface
  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdSMTP;
type

  TSMTPDelphi= class
    private
      __smtp__                    : TIdSMTP;
      __mensagem__                : TIdMessage;
      __host__                    : string;
      __username__                : string;
      __password__                : string;
      __fron__                    : string;
      __to__                      : string;
      __assunto__                 : string;
      __textoEmail__              : string;
      __anexo__                   : string;

      //Metodos set privados

      //Métodos get privados

      // Metodos privados

    public

      //Metodos set publicos

      //Métodos get publicos

      //Metodos publicos
      constructor create(host, user: string; password: string='');
      function ConectarAoServidorSMTP(): Boolean;
      function DesconectarDoServidorSMTP(): Boolean;      
      function EnviarEmail(EmailOrigem, EmailsDeDestino, Assunto, Corpo: string): Boolean;
      function AnexarArquivo(arquivo: string): Boolean;
      function email_teste(): Boolean;
   End;

implementation
//uses ;
//Metodos set privados

//Métodos get privados

//Metodos set publicos

//Métodos get publicos

//Metodos publicos
constructor TSMTPDelphi.create(host, user: string; password: string='');
begin
  __host__        := host;
  __username__    := user;
  __password__    := password;

  __smtp__          := TIdSMTP.Create(Application);
  __mensagem__      := TIdMessage.Create(Application);
  __smtp__.Host     := __host__;
  __smtp__.Username := __username__;
  __smtp__.Password := __password__;
end;

function TSMTPDelphi.ConectarAoServidorSMTP(): Boolean;
begin
  try
    __smtp__.Connect();
    Result := True;
  except
    raise Exception.Create('Erro de conexão');
    Result := False;
  end
end;

function TSMTPDelphi.DesconectarDoServidorSMTP(): Boolean;
begin
  try
    __smtp__.Disconnect;

    Result := True;
  except
    raise Exception.Create('Erro de conexão');
    Result := False;
  end;
end;

function TSMTPDelphi.EnviarEmail(EmailOrigem, EmailsDeDestino, Assunto, Corpo: string): Boolean;
begin
  try
    __mensagem__.From.Address              := EmailOrigem;
    __mensagem__.Recipients.EMailAddresses := EmailsDeDestino;
    __mensagem__.Subject                   := Assunto;
    __mensagem__.Body.Text                 := Corpo;
    __smtp__.Send(__mensagem__);
    Result := True
  except
    { Se ocorrer algum erro durante a conexão com o servidor, avise! }
    raise Exception.Create('Erro de conexão');
    Result := False;
  end;
end;

function TSMTPDelphi.AnexarArquivo(arquivo: string): Boolean;
begin

  try
    if (FileExists(arquivo)) then
    begin
      __mensagem__.MessageParts.Clear;
      with __mensagem__ do
        TIdAttachment.Create(__mensagem__.MessageParts, arquivo);
    end;
    Result := True;
  except
    raise Exception.Create('Erro de conexão');
    Result := False;
  end;

end;

function TSMTPDelphi.email_teste(): Boolean;
var
  idsmtpSMTP : TIdSMTP;
  idmsg1 : TIdMessage;
begin

  idsmtpSMTP := TIdSMTP.Create(Application);
  idmsg1 := TIdMessage.Create(Application);

  with idsmtpSMTP do
  begin
    // Nome do host
    Host := '192.168.0.10';
    //Nome do usuario, normalmente o e-mail
    Username := 'cpd';
    //        Port := ??
    //conecta com o servidor smtp
    Connect();
  end;

  { Se ocorrer algum erro durante a conexão com o servidor, avise! }
  if not idsmtpSMTP.Connected then
    raise Exception.Create('Erro de conexão');

  with idmsg1 do
  begin
    //o seu endereço de e-mail
    from.address := 'cpd@fingerprint.com.br';
    //aqui vai o endereço de e-mail para o qual voc~e quer mandar o e-mail
    recipients.EmailAddresses:= 'edivaldo.medeiros@netservicos.com.br';    // incluído em 29/03/2010 //

    //  EXCLUIDO EM 04/11/2010 .....  'rs02_acjdspedro@correios.com.br' + ';' +

    // TESTE //
    //        recipients.EmailAddresses:= 'frppaiva@gmail.com';
    //        recipients.EmailAddresses:= 'cpd@fingerprint.com.br';


    // o assunto da mensagem             //
    subject := 'favor desconsiderar - teste ';

  end;
  // aqui para poder anexar um arquivo           //
 // TIdAttachment.Create(idmsg1.MessageParts, NOME);

  // envia a mensagem
  idsmtpSMTP.Send(idmsg1);
  idsmtpSMTP.Disconnect;

  showmessage('Mensagem enviada');
end;

end.
