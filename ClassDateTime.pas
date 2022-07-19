Unit ClassDateTime;

interface

  uses Windows, Classes, Dialogs, SysUtils, Forms, Controls, Graphics, WinSock, ShellAPI,
  math,
  StdCtrls, ComCtrls, udatatypes_apps, ClassLog;

  type
    TFormataDateTime= Class

      objLogar : TArquivoDelog;

      {Constroi a classe e massa os parâmetros iniciais}
      constructor create(Var objLogar: TArquivoDelog);

      {Obtem o termo de uma de acordo com o delimitador informado}
      function SomaDiasUlteis(Dat:TDateTime;Numdias:Integer): TDateTime;


    end;

implementation

constructor TFormataDateTime.create(Var objLogar: TArquivoDelog);
Begin
 objLogar := objLogar;
end;

function TFormataDateTime.SomaDiasUlteis(Dat:TDateTime;Numdias:Integer): TDateTime;
var
  iSemanaNumerico : Integer;
begin

  Dat := Dat + Numdias;

  iSemanaNumerico := DayOfWeek (Dat);

  if iSemanaNumerico = 1 then
    Dat := Dat + 1
  else
  if iSemanaNumerico = 7 then
    Dat := Dat + 2;

  Result := Dat;
end;

End.
