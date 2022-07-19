unit ClassRegularExpression;

  (*

    CRIADO POR: Tiago Paranhos Lima

    OBJETIVO:
      - Classe para utilização de expressões regulares.

    EXEMPLO DE CHAMADA:
      procedure TForm1.btn_analisarClick(Sender: TObject);
      var
        sTexto, sRegex: string;
        oRegularExpression: TRegularExpressionFingerprint;
        i: integer;
        rrRetorno: RActionReturn;
      begin
        sTexto := mmo_texto.Text; //TEXTO ONDE FAZER A PROCURA
        sRegex := edt_regex.Text; //EXPRESSÃO REGULAR

        try

          oRegularExpression := TRegularExpressionFingerprint.create();

          oRegularExpression.StringOriginal := sTexto;
          oRegularExpression.RegEx := sRegex;

          rrRetorno := oRegularExpression.ExecuteSearch();

          if rrRetorno.sucesso then
          begin
            { No exemplo abaixo, adiciona em um memo todas as
             ocorrências da expressão regular encontradas na string. }
            for i:=0 to oRegularExpression.Matches.Count -1 do
              mmo_matches.Lines.Add(oRegularExpression.Matches[i]);

            { Como obter o total de ocorrências da regex encontradas na string:}
            showmessage('Foram encontradas '+inttostr(oRegularExpression.Matches.Count)+' ocorrências da regex no texto.');
          end;

        finally

          if Assigned(oRegularExpression) then
            FreeAndNil(oRegularExpression);

        end;
      end;

  *)

interface

uses Classes, Dialogs, SysUtils, udatatypes_apps;

type

  TRegularExpressionFingerprint = class
    private

      sRegEx: string;
      sStringOriginal: string;
      slMatches: TStringList;

    public

      constructor create();
      destructor destroy();

      property RegEx: string read sRegEx write sRegEx;
      property StringOriginal: string read sStringOriginal write sStringOriginal;
      property Matches: TStringList read slMatches write slMatches;

      function ExecuteSearch(): RActionReturn;

  end;

implementation

uses Math, uFuncoes, RegExpr;

constructor TRegularExpressionFingerprint.create();
begin

  (*

    CRIADO POR: Tiago Paranhos Lima

  *)

  slMatches := TStringList.Create;

end;

destructor TRegularExpressionFingerprint.destroy;
begin

  (*

    CRIADO POR: Tiago Paranhos Lima

  *)

  if Assigned(slMatches) then
    FreeAndNil(slMatches);
end;

function TRegularExpressionFingerprint.ExecuteSearch(): RActionReturn;
var
  r : TRegExpr;
  sLinhaAtual: string;
  rrRetorno: RActionReturn;
  bRegexEncontrada: boolean;
begin

  (*

    CRIADO POR: Tiago Paranhos Lima

  *)

  rrRetorno.sucesso := True;
  rrRetorno.mensagem := '';

  self.RegEx := stringreplace(self.RegEx, #13#10, '',[rfReplaceAll]);

  self.Matches.Clear;

  r := TRegExpr.Create;
  try // ensure memory clean-up
    r.Expression := self.RegEx;

    // Assign r.e. source code. It will be compiled when necessary
    // (for example when Exec called). If there are errors in r.e.
    // run-time execption will be raised during r.e. compilation
    try
      bRegexEncontrada := r.Exec (self.StringOriginal);

      if bRegexEncontrada then
      begin
        repeat
          sLinhaAtual := r.Match [0];
          if sLinhaAtual <> '' then
            self.Matches.Add(sLinhaAtual);
        until not r.ExecNext;
      end;

    except
      on E:Exception do
      begin
        rrRetorno.sucesso  := False;
        rrRetorno.mensagem := 'ClassRegularExpression.pas - TRegularExpressionFingerprint.ExecuteSearch() - Exceção: '+E.Message;
      end;
    end;
  finally
    r.Free;
  end;

  result := rrRetorno;

end;

end.
