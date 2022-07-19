unit ClassConexoes;
interface
  uses Classes, Dialogs, SysUtils, ClassStrings, ClassLog;
type

  TArquivoDeConexoes= class
    private
      __ArquivoDeConexoes__ : String;
      __Path__              : String;
      __HostName__          : String;
      __ListaDeConexoes__   : TStringList;
      __User__              : String;
      __PassWord__          : String;
      __Protocolo__         : String;

      objString             : TFormataString;
      objLogar              : TArquivoDelog;

      Function setArquivoDeConexao(const arquivodeconexao: String): Boolean;
      Function setPath(const path: String): Boolean;
      Function setHostName(const hostname: String): Boolean;
      Function setListaDeConexoes(const conexao: String): Boolean;
      Function setUser(const user: String): Boolean;
      Function setPassword(const password: String): Boolean;
      Function setProtocolo(const protocolo: String): Boolean;

    public

      Function getArquivoDeConexao(): String;
      Function getPath(): String;

      Function getHostName(): String;
      Function getListaDeConexoes(): TStringList;
      Function getUser(): String;
      Function getPassword(): String;
      Function getProtocolo(): String;

      {Método construtor da classe}
      constructor create(Var objLogar: TArquivoDelog;
                         Var objString : TFormataString;
                         PathArquivoConexoes: String);

   End;

implementation
//uses Math, uFuncoes_str, log;

constructor TArquivoDeConexoes.create(Var objLogar: TArquivoDelog;
                                      Var objString : TFormataString;
                                      PathArquivoConexoes: String);
var

  arqArquivoConexao : TextFile;
  sArquivoDeConexoes: string;
  sLinha            : String;
  sBase             : String;
  iContBases        : Integer;
  iTotalDeBases     : Integer;
begin

  objString := objString;
  objLogar  := objLogar;

  setPath(PathArquivoConexoes);
  setArquivoDeConexao('databases.conf');

  sArquivoDeConexoes := getPath() + getArquivoDeConexao();

  if FileExists(sArquivoDeConexoes) Then
  Begin
    AssignFile(arqArquivoConexao, sArquivoDeConexoes);
    Reset(arqArquivoConexao);
    while not eof(arqArquivoConexao) do
    Begin
      readln(arqArquivoConexao, sLinha);

      if Pos('Host', sLinha) > 0 Then
        setHostName(Trim(objString.getTermo(2, '=', sLinha)));

      if Pos('User', sLinha) > 0 Then
        setUser(Trim(objString.getTermo(2, '=', sLinha)));

      if Pos('Password', sLinha) > 0 Then
        setPassword(Trim(objString.getTermo(2, '=', sLinha)));

      if Pos('Databases', sLinha) > 0 Then
      Begin
        sBase:= Trim(objString.getTermo(2, '=', sLinha));
        sBase:= StringReplace(sBase, '(', '', [rfReplaceAll]);
        sBase:= StringReplace(sBase, ')', '', [rfReplaceAll]);
        iTotalDeBases:= objString.GetNumeroOcorrenciasCaracter(sBase, ',');

        For iContBases:=0 to iTotalDeBases do
          setListaDeConexoes(Trim(objString.getTermo(iContBases + 1, ',', sBase)));

      end;

      if Pos('Protocolo', sLinha) > 0 Then
       setProtocolo(Trim(objString.getTermo(2, '=', sLinha)));

    end;
    CloseFile(arqArquivoConexao);
    //Result := True;
  end
  else
  Begin
    ShowMessage('ATENCAO !!! O ARQUIVO '
    +  getArquivoDeConexao()
    + ' NAO EXISTE NO DIRETORIO DA APLICACAO. O MESMO SERA CRIADO NO DIRETORIO: '
    + getArquivoDeConexao());
    try
      AssignFile(arqArquivoConexao, getPath() + getArquivoDeConexao());
      Rewrite(arqArquivoConexao);
      writeln(arqArquivoConexao, 'Host= localhost');
      setHostName('localhost');

      writeln(arqArquivoConexao, 'User= root');
      setUser('root');

      writeln(arqArquivoConexao, 'Password= ');
      setPassword('');

      writeln(arqArquivoConexao, 'Databases=(mysql)');
      setListaDeConexoes('mysql');

      writeln(arqArquivoConexao, 'Protocolo= mysql-5');
      setProtocolo('mysql-5');
      CloseFile(arqArquivoConexao);
    except
      on E:Exception do
      begin
        ShowMessage('ERRO AO CRIAR O ARQUIVO ' + getArquivoDeConexao() + ' NO PATH ' + getPath() + #13
        + E.Message);
      end;
    end;
    //Result := False;
  end;

end;

Function TArquivoDeConexoes.setArquivoDeConexao(const arquivodeconexao: String): Boolean;
Begin
  __ArquivoDeConexoes__:= arquivodeconexao;
end;

Function TArquivoDeConexoes.setPath(const path: String): Boolean;
Begin
  __Path__:= path;
end;

Function TArquivoDeConexoes.setHostName(const hostname: String): Boolean;
Begin
  __HostName__:= hostname;
end;

Function TArquivoDeConexoes.setListaDeConexoes(const conexao: String): Boolean;
Begin

  if not Assigned(__ListaDeConexoes__) Then
  Begin
    __ListaDeConexoes__ := TStringList.Create();
    __ListaDeConexoes__.Clear;
  end;

  __ListaDeConexoes__.Add(conexao);

end;

Function TArquivoDeConexoes.setUser(const user: String): Boolean;
Begin
   __User__:= user;
end;

Function TArquivoDeConexoes.setPassword(const password: String): Boolean;
Begin
  __PassWord__:= password;
end;

Function TArquivoDeConexoes.setProtocolo(const protocolo: String): Boolean;
Begin
  __Protocolo__:= protocolo;
end;

Function TArquivoDeConexoes.getArquivoDeConexao(): String;
Begin
  Result:= __ArquivoDeConexoes__;
end;

Function TArquivoDeConexoes.getPath(): String;
Begin
  Result:= __Path__;
end;

Function TArquivoDeConexoes.getHostName(): String;
Begin
  Result := __HostName__;
end;

Function TArquivoDeConexoes.getListaDeConexoes(): TStringList;
Begin
  Result:= __ListaDeConexoes__;
end;

Function TArquivoDeConexoes.getUser(): String;
Begin
  Result:= __User__;
end;

Function TArquivoDeConexoes.getPassword(): String;
Begin
  Result:= __PassWord__;
end;

Function TArquivoDeConexoes.getProtocolo(): String;
Begin
  Result:= __Protocolo__;
end;





end.
