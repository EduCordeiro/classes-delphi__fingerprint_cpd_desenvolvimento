unit ClassDirectory;

  (*

    CRIADO POR: Eduardo C. M. Monteiro.

    OBJETIVO:
      Classe para tratamento de diretórios.

  *)

interface

uses Classes, Dialogs, SysUtils;

type

  TPathModo = (setarDiretorio, criarDiretorio);

  TDiretorio= class
    private
      __Path__            : String;
      __ListaDeArquivos__ : TStringList;

      //Método set
      function setListaDeArquivos(const Valor: String): Boolean;
      function AjustaPath(): String;
    public
      //Método
      function getDiretorio():String;
      function getDiretorioInvertido():String;
      function getArquivoDaListaDeArquivos(Indicer: Integer):String;
      function setDiretorio(Diretorio: String; modo: TPathModo=setarDiretorio): Boolean;
      {Obtém lista de arquivos de um diretório}
      function getListaDeArquivosDeUmDiretorio(extensao: String='*.*'): TStringList;
      {Método construtor da classe}
      constructor create(path: String = ''; modo: TPathModo=setarDiretorio; codificacaoUTF8:Boolean=True);
  End;

implementation

//uses Math, uFuncoes;

function TDiretorio.GetListaDeArquivosDeUmDiretorio(extensao: String='*.*'): TStringList;
var
 SR: TSearchRec;
 ret: Integer;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  __ListaDeArquivos__ := TStringList.Create();
  __ListaDeArquivos__.Clear;

  ret:= FindFirst(getDiretorio() + extensao, faDirectory, SR);
  if ret = 0 then
  try
    repeat
      if (SR.Attr <> 0) and (faDirectory <> 0) and (SR.Name <> '.') and ( SR.Name <> '..') then
        __ListaDeArquivos__.Add(SR.Name);
      ret := FindNext( SR );
    until ret <> 0;
  finally
    SysUtils.FindClose(SR)
  end;

  Result:= __ListaDeArquivos__;

end;

function TDiretorio.AjustaPath(): String;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  if length(__Path__) > 0 then
  begin
    if __Path__[length(__Path__)] <> PathDelim then
      Result:= __Path__ + PathDelim
    else
      Result:= __Path__;
  end;    
end;

function TDiretorio.setDiretorio(Diretorio: String; modo: TPathModo=setarDiretorio): Boolean;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  case modo of
    setarDiretorio: __Path__:= Diretorio;
    criarDiretorio:
       begin
         if not DirectoryExists(Diretorio) then
           ForceDirectories(Diretorio);
         __Path__:= Diretorio;;
       end;
  end;
end;

function TDiretorio.getArquivoDaListaDeArquivos(Indicer: Integer):String;
begin

  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  if Assigned(__ListaDeArquivos__) Then
  begin
    Result:= __ListaDeArquivos__.Strings[Indicer]
  end
  else
    Result:= '';

end;

function TDiretorio.getDiretorio():String;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  Result:= AjustaPath();
end;

function TDiretorio.getDiretorioInvertido():String;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  Result:= AnsiToUtf8(StringReplace(AjustaPath(), '\', '/', [rfReplaceAll]));
end;

function TDiretorio.setListaDeArquivos(const Valor: String): Boolean;
begin
  (*

    CRIADO POR: Eduardo C. M. Monteiro.

  *)

  if not Assigned(__ListaDeArquivos__) Then
  begin
    __ListaDeArquivos__ := TStringList.Create();
    __ListaDeArquivos__.Clear;
  end;

  __ListaDeArquivos__.Add(Valor);
end;

constructor TDiretorio.create(path: String= ''; modo: TPathModo=setarDiretorio; codificacaoUTF8:Boolean=True);
begin

  (*

    CRIADO POR: Eduardo C. M. Monteiro.

    OBS.:
      - modo criacao: Força a criação.
      - modo leitura: Apenas seta o diretório já existente.

  *)

  if path = '' then
    path:= __Path__;

  if codificacaoUTF8 Then
    path:= AnsiToUtf8(path)
  else
    path:= Utf8ToAnsi(path);

  case modo of
    criarDiretorio : setDiretorio(path, modo);
    setarDiretorio : setDiretorio(path, modo);
  end;
  
end;

end.
