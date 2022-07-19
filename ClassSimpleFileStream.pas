unit ClassSimpleFileStream;

  (*

    CRIADO POR: Tiago Paranhos Lima

    OBJETIVO:
      - Classe para gravação de arquivos via stream (muito mais rápido do que
        usar TextFiles).

    EXEMPLO DE CHAMADA:
      try
        slTEMP := TStringList.Create();
        slTEMP.LoadFromFile('ALIMENTO_STRINGLIST.txt');

        oSaidaFileStream := TSimpleFileStreamFingerprint.Create('SALVO_EM_FILE_STREAM.txt');
        for i:=0 to slTEMP.Count-1 do
          oSaidaFileStream.GravarLinha(slTEMP[i]);

      finally
        if Assigned(slTEMP) then
          FreeAndNil(slTEMP);

        if Assigned(oSaidaFileStream) then
        begin
          //Equivalente ao "FreeAndNil":
          oSaidaFileStream.destroy;
          Pointer(oSaidaFileStream) := nil;
        end
      end;
      
  *)

interface

uses Classes, Dialogs, SysUtils, udatatypes_apps;

type

  TSimpleFileStreamFingerprint = class
    private

      sNomeArquivo: string;
      oFileStream: TFileStream;

    public

      constructor create(nome_arquivo: string);
      destructor destroy();

      property NomeArquivo: string read sNomeArquivo write sNomeArquivo;

      function GravarLinha(linha: string): RActionReturn;

  end;

implementation

uses Math, uFuncoes, RegExpr;

constructor TSimpleFileStreamFingerprint.create(nome_arquivo: string);
begin

  (*

    CRIADO POR: Tiago Paranhos Lima

  *)

  self.NomeArquivo := nome_arquivo;

  if FileExists(self.NomeArquivo) then
    DeleteFile(self.NomeArquivo);

  {
  oFileStream := TFileStream.Create(self.NomeArquivo,
   fmCreate or fmOpenWrite or fmShareExclusive);
  }
  oFileStream := TFileStream.Create(self.NomeArquivo,
   fmCreate or fmOpenWrite or fmShareDenyWrite);

end;

destructor TSimpleFileStreamFingerprint.destroy;
begin

  (*

    CRIADO POR: Tiago Paranhos Lima

  *)

  if Assigned(oFileStream) then
  begin
    //FreeAndNil(oFileStream);

    { OBS.: Aqui é necessário forçar o destroy e o pointer como nil porque
            caso contrário, o "handle" do arquivo não será liberado, então
            o arquivo gravado não poderá ser lido imediatamente. } 

    //Equivalente ao "FreeAndNil":
    oFileStream.destroy;
    Pointer(oFileStream) := nil;
  end;

end;

function TSimpleFileStreamFingerprint.GravarLinha(linha: string): RActionReturn;
var
  rrRetorno: RActionReturn;
begin
  (*

    CRIADO POR: Tiago Paranhos Lima

  *)

  rrRetorno.sucesso := True;
  rrRetorno.mensagem := '';

  linha := linha + #13#10; //força quebra de linhas do windows

  try
    oFileStream.Write(linha[1], length(linha));
  except
    on E:Exception do
    begin
      rrRetorno.sucesso  := False;
      rrRetorno.mensagem := 'TSimpleFileStreamFingerprint.GravarLinha() - Exceção: ' + E.Message;
    end;
  end;

  result := rrRetorno;
end;

end.
